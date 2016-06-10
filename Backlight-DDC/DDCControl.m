//
//  CCDControl.m
//  Backlight-DDC
//
//  Created by Floris Fredrikze on 31/08/15.
//

#import "DDCControl.h"


@implementation DDCControl

- (id)init {
    self = [super init];
    if (self) {
        _displays = [[NSMutableArray alloc] init];
        _currentDisplay = 0;
    }
    return self;
}

- (void)setBrightness:(int)value {
    struct DDCWriteCommand command;
    command.control_id = BRIGHTNESS;
    command.new_value = value;
    if (_currentDisplay >= 0) {
        [self writeDDCCommand:&command ToDisplay:[[_displays objectAtIndex:_currentDisplay] displayID]];
    }
}

- (void)setContrast:(int)value {
    struct DDCWriteCommand command;
    command.control_id = CONTRAST;
    command.new_value = value;
    if (_currentDisplay >= 0) {
        [self writeDDCCommand:&command ToDisplay:[[_displays objectAtIndex:_currentDisplay] displayID]];
    }
}

- (int)getBrightness {
    struct DDCReadCommand command;
    command.control_id = BRIGHTNESS;
    command.max_value = 100;
    command.current_value = 0;
    if (_currentDisplay >= 0) {
        [self readDDCCommand:&command FromDisplay:[[_displays objectAtIndex:_currentDisplay] displayID]];
    }
    return command.current_value;
}
- (int)getContrast {
    struct DDCReadCommand command;
    command.control_id = CONTRAST;
    command.max_value = 100;
    command.current_value = 0;
    if (_currentDisplay >= 0) {
        [self readDDCCommand:&command FromDisplay:[[_displays objectAtIndex:_currentDisplay] displayID]];
    }
    return command.current_value;
}

- (void)reset {
    struct DDCWriteCommand command;
    command.control_id = RESET;
    command.new_value = 1;
    if (_currentDisplay >= 0) {
        [self writeDDCCommand:&command ToDisplay:[[_displays objectAtIndex:0] displayID]];
    }
}

- (BOOL)getDisplays {
    for (NSScreen *screen in NSScreen.screens) {
        NSDictionary *description = [screen deviceDescription];
        if ([description objectForKey:@"NSDeviceIsScreen"]) {
            CGDirectDisplayID displayID = [[description objectForKey:@"NSScreenNumber"] unsignedIntValue];
            [_displays addObject:[[DDDisplay alloc] initWithDisplay:displayID]];
        }
    }
    return [_displays count];
}

- (BOOL)writeDDCCommand:(struct DDCWriteCommand*)command ToDisplay:(CGDirectDisplayID)displayID {
    IOI2CRequest    request;
    UInt8           data[128];
    
    bzero( &request, sizeof(request));
    
    request.commFlags                       = 0;
    
    request.sendAddress                     = 0x6E;
    request.sendTransactionType             = kIOI2CSimpleTransactionType;
    request.sendBuffer                      = (vm_address_t) &data[0];
    request.sendBytes                       = 7;
    
    data[0] = 0x51;
    data[1] = 0x84;
    data[2] = 0x03;
    data[3] = command->control_id;
    data[4] = 0x64 ;
    data[5] = command->new_value ;
    data[6] = 0x6E^ data[0]^ data[1]^ data[2]^ data[3]^ data[4]^ data[5];
    
    
    request.replyTransactionType    = kIOI2CNoTransactionType;
    request.replyBytes              = 0;
    
    
    bool result = [self DisplayRequest:displayID request:&request];
    return result;
}
- (BOOL)readDDCCommand:(struct DDCReadCommand*)command FromDisplay:(CGDirectDisplayID)displayID {
    IOI2CRequest request;
    UInt8 reply_data[11] = {};
    bool result = false;
    UInt8 data[128];
    
    
    bzero( &request, sizeof(request));
    
    request.commFlags                       = 0;
    
    request.sendAddress                     = 0x6E;
    request.sendTransactionType             = kIOI2CSimpleTransactionType;
    request.sendBuffer                      = (vm_address_t) &data[0];
    request.sendBytes                       = 5;
    request.minReplyDelay = kDelayBase;
    
    data[0] = 0x51;
    data[1] = 0x82;
    data[2] = 0x01;
    data[3] = command->control_id;
    data[4] = 0x6E ^ data[0] ^ data[1] ^ data[2] ^ data[3];
    
    request.replyTransactionType    = kIOI2CDDCciReplyTransactionType;
    request.replyAddress            = 0x6F;
    request.replySubAddress         = 0x51;
    
    request.replyBuffer = (vm_address_t) reply_data;
    request.replyBytes = sizeof(reply_data);
    
    result = [self DisplayRequest:displayID request:&request];
    result = (result && reply_data[0] == request.sendAddress && reply_data[2] == 0x2 && reply_data[4] == command->control_id && reply_data[10] == (request.replyAddress ^ request.replySubAddress ^ reply_data[1] ^ reply_data[2] ^ reply_data[3] ^ reply_data[4] ^ reply_data[5] ^ reply_data[6] ^ reply_data[7] ^ reply_data[8] ^ reply_data[9]));
    command->max_value = reply_data[7];
    command->current_value = reply_data[9];
    return result;
}


// slightly alterd version off function found here: https://github.com/kfix/ddcctl/blob/master/DDC.c
- (BOOL) DisplayRequest:(CGDirectDisplayID)DirectDisplayID request:(struct IOI2CRequest*)request {
    bool result = false;
    io_service_t framebuffer;
    if ((framebuffer = CGDisplayIOServicePort(DirectDisplayID))) {
        IOItemCount busCount;
        if (IOFBGetI2CInterfaceCount(framebuffer, &busCount) == KERN_SUCCESS) {
            IOOptionBits bus = 0;
            while (bus < busCount) {
                io_service_t interface;
                if (IOFBCopyI2CInterfaceForBus(framebuffer, bus++, &interface) != KERN_SUCCESS)
                    continue;
                CFNumberRef flags = NULL;
                CFIndex flag;
                if (request->minReplyDelay
                    && (flags = IORegistryEntryCreateCFProperty(interface, CFSTR(kIOI2CSupportedCommFlagsKey), kCFAllocatorDefault, 0))
                    && CFNumberGetValue(flags, kCFNumberCFIndexType, &flag)
                    && flag == kIOI2CUseSubAddressCommFlag)
                    request->minReplyDelay *= kMillisecondScale;
                if (flags)
                    CFRelease(flags);
                IOI2CConnectRef connect;
                if (IOI2CInterfaceOpen(interface, kNilOptions, &connect) == KERN_SUCCESS) {
                    result = (IOI2CSendRequest(connect, kNilOptions, request) == KERN_SUCCESS);
                    IOI2CInterfaceClose(connect, kNilOptions);
                }
                IOObjectRelease(interface);
                if (result) break;
            }
        }
    }
    return result && request->result == KERN_SUCCESS;
}



@end
