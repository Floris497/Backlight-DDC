//
//  ViewController.h
//  Backlight-DDC
//
//  Created by Floris Fredrikze on 31/08/15.
//

#import <Cocoa/Cocoa.h>
#import "DDCControl.h"
#import "DDDisplay.h"

#define kContinuousEffects @"ContinuousEffects"

@interface ViewController : NSViewController {
    IBOutlet NSSlider *brightnessSlider;
    IBOutlet NSSlider *contrastSlider;
    
    IBOutlet NSButton *continuousButton;
    
    IBOutlet NSPopUpButton *displayChooser;
    
    DDCControl *control;
}


- (IBAction)changeChooser:(NSPopUpButton *)sender;
- (IBAction)continuousMode:(NSButton *)sender;

- (IBAction)brightnessChange:(NSSlider *)sender;
- (IBAction)contrastChange:(NSSlider *)sender;
- (IBAction)resetDisplay:(NSButton *)sender;

@end

