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
    
    for (int c = 0; c < [control.displays count]; c++ ) {
        DDDisplay *disp = [control.displays objectAtIndex:c];
        NSString *name = [disp screenName];
        [displayChooser addItemWithTitle:[NSString stringWithFormat:@"%d:\t%@",c+1,name]];
    }
    
    [control setCurrentDisplay:0];
    
    [self getCurrentValues];

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}


- (IBAction)changeChooser:(NSPopUpButton *)sender {
    [control setCurrentDisplay:sender.indexOfSelectedItem];
    [self getCurrentValues];
}

- (IBAction)brightnessChange:(NSSlider *)sender {
    [control setBrightness:[sender intValue]];
}
- (IBAction)contrastChange:(id)sender {
    [control setContrast:[sender intValue]];
}

- (IBAction)resetDisplay:(NSButton *)sender {
    [control reset];
    [self getCurrentValues];
}

- (void)getCurrentValues {
    [brightnessSlider setDoubleValue:[control getBrightness]];
    [contrastSlider setDoubleValue:[control getContrast]];
}

@end
