//
//  WindowManager.m
//  noobtest
//
//  Created by siggi jokull on 3.12.2022.
//

#import "WindowManager.h"

@implementation WindowManager

- (void) windowDidResize: (NSNotification*) notification {
    ////////////////////////NSLog/@"resize");
}

- (void) windowDidEnterFullScreen:(NSNotification *)notification {
    ////////////////////////NSLog/@"fullscreen");
}

- (void) testFun: (NSString*) input {
    ////////////////////////NSLog/@"%@", input);
}

- (void) windowDidExpose:(NSNotification *)notification {
    ////////////////////////NSLog/@"open");
}

@end
