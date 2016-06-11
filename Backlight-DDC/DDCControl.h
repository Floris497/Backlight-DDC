//
//  CCDControl.h
//  Backlight-DDC
//
//  Created by Floris Fredrikze on 31/08/15.
//

#import <Foundation/Foundation.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/graphics/IOGraphicsLib.h>
#include <ApplicationServices/ApplicationServices.h>
#import <IOKit/i2c/IOI2CInterface.h>
#import <AppKit/NSScreen.h>

#import "DDDisplay.h"

#define kDelayBase 100


@interface DDCControl : NSObject

@property (nonatomic, retain)NSMutableArray<DDDisplay *> *displays;
@property NSInteger currentDisplay;


#define BRIGHTNESS 0x10
#define CONTRAST 0x12

#define RESET 0x05


struct DDCWriteCommand {
    UInt8 control_id;
    UInt8 new_value;
};

struct DDCReadCommand {
    UInt8 control_id;
    UInt8 max_value;
    UInt8 current_value;
};

- (void)setBrightness:(int)value;
- (void)setContrast:(int)value;
- (void)reset;

- (int)getBrightness;
- (int)getContrast;

- (BOOL)getDisplays;

- (BOOL)DisplayRequest:(CGDirectDisplayID)displayID request:(struct IOI2CRequest*)request;
- (BOOL)writeDDCCommand:(struct DDCWriteCommand*)command ToDisplay:(CGDirectDisplayID)displayID;
- (BOOL)readDDCCommand:(struct DDCReadCommand*)command FromDisplay:(CGDirectDisplayID)displayID;

@end
