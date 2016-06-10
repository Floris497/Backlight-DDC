//
//  ViewController.h
//  Backlight-DDC
//
//  Created by Floris Fredrikze on 31/08/15.
//

#import <Cocoa/Cocoa.h>
#import "DDCControl.h"
#import "DDDisplay.h"

@interface ViewController : NSViewController {
    IBOutlet NSSlider *brightnessSlider;
    IBOutlet NSSlider *contrastSlider;
    
    IBOutlet NSPopUpButton *displayChooser;
    
    DDCControl *control;
}


- (IBAction)changeChooser:(NSPopUpButton *)sender;
- (IBAction)brightnessChange:(NSSlider *)sender;
- (IBAction)contrastChange:(NSSlider *)sender;


@end

