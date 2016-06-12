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
        NSString *serial = [disp serialNumber];
        [displayChooser addItemWithTitle:[NSString stringWithFormat:@"%@ (SN:%@)",name,serial]];
    }
    
    [control setCurrentDisplayID:0];
    
    [self getCurrentValues];
    [self setMonitorSpecifics];
    
    // Some screens lag when you request informtion from them, need to see if fixable
    // [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCurrentValues) userInfo:nil repeats:YES];

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)changeChooser:(NSPopUpButton *)sender {
    [control setCurrentDisplayID:sender.indexOfSelectedItem];
    [self getCurrentValues];
    [self setMonitorSpecifics];
}

- (IBAction)continuousMode:(NSButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DDDisplay *disp = [control getCurrentDisplay];
    if (sender.state == NSOnState) {
        [defaults setBool:YES forKey:[NSString stringWithFormat:@"%@:%@",kContinuousEffects,[disp serialNumber]]];
    } else {
        [defaults setBool:NO forKey:[NSString stringWithFormat:@"%@:%@",kContinuousEffects,[disp serialNumber]]];
    }
    [self setMonitorSpecifics];
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

- (void)setMonitorSpecifics {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DDDisplay *disp = [control getCurrentDisplay];
    if ([defaults boolForKey:[NSString stringWithFormat:@"%@:%@",kContinuousEffects,[disp serialNumber]]] == TRUE) {
        [brightnessSlider setContinuous:NO];
        [contrastSlider setContinuous:NO];
        [continuousButton setState:NSOnState];
    } else {
        [brightnessSlider setContinuous:YES];
        [contrastSlider setContinuous:YES];
        [continuousButton setState:NSOffState];
    }
}

@end
