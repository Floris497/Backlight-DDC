//
//  ViewController.m
//  Backlight-DDC
//
//  Created by Floris Fredrikze on 31/08/15.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    control = [[DDCControl alloc] init];
    [control getDisplays];
    
    if ([control.displays count])
        [displayChooser removeAllItems];
    
    for (DDDisplay *disp in control.displays) {
        NSString* name = [disp screenName];
        [displayChooser addItemWithTitle:name];
    }
    
    [control setCurrentDisplay:0];
    
    [brightnessSlider setDoubleValue:[control getBrightness]];
    [contrastSlider setDoubleValue:[control getContrast]];

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}


- (IBAction)changeChooser:(NSPopUpButton *)sender {
    [control setCurrentDisplay:sender.indexOfSelectedItem];
}

- (IBAction)brightnessChange:(NSSlider *)sender {
    [control setBrightness:[sender intValue]];
}
- (IBAction)contrastChange:(id)sender {
    [control setContrast:[sender intValue]];
}



@end
