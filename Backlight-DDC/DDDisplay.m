//
//  DDDisplay.m
//  Backlight-DDC
//
//  Created by Floris Fredrikze on 10/06/16.
//

#import "DDDisplay.h"

@implementation DDDisplay

- (instancetype)init
{
    self = [super init];
    if (self) {
        _values = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)initWithDisplay:(CGDirectDisplayID)displayID
{
    self = [super init];
    if (self) {
        _displayID = displayID;
        _values = [[NSMutableDictionary alloc] init];
    }
    return self;
}


// slightly altered version of: http://stackoverflow.com/a/24010476/1042279
- (NSString*) screenName {
    NSString *screenName = nil;
    io_service_t service = CGDisplayIOServicePort(_displayID);
    if (service) {
        NSDictionary *deviceInfo = (__bridge NSDictionary *)IODisplayCreateInfoDictionary(service, kIODisplayOnlyPreferredName);
        NSDictionary *localizedNames = [deviceInfo objectForKey:[NSString stringWithUTF8String:kDisplayProductName]];
                
        if ([localizedNames count] > 0) {
            screenName = [localizedNames objectForKey:[[localizedNames allKeys] objectAtIndex:0]];
        }
    }
    return screenName;
}


- (NSString*) serialNumber {
    NSString *serialNumber = nil;
    io_service_t service = CGDisplayIOServicePort(_displayID);
    if (service) {
        NSDictionary *deviceInfo = (__bridge NSDictionary *)IODisplayCreateInfoDictionary(service, kIODisplayOnlyPreferredName);
        serialNumber = [deviceInfo objectForKey:[NSString stringWithUTF8String:kDisplaySerialNumber]];
    }
    return serialNumber;
}


@end
