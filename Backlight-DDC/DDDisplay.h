//
//  DDDisplay.h
//  Backlight-DDC
//
//  Created by Floris Fredrikze on 10/06/16.
//

#import <Foundation/Foundation.h>

@interface DDDisplay : NSObject

@property CGDirectDisplayID displayID;

@property NSMutableDictionary *values;


- (instancetype)init;
- (instancetype)initWithDisplay:(CGDirectDisplayID)displayID;

- (NSString*)screenName;
- (NSString*)serialNumber;

@end
