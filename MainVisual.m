//
//  MainVisual.m
//  noobtest
//
//  Created by siggi jokull on 3.12.2022.
//

#import "MainVisual.h"

@implementation MainVisual


- (BOOL) isFlipped {
    return YES;
}

/*- (void) viewDidEndLiveResize {
    ////////////////////////NSLog/@"frame");
    ////////////////////////NSLog/@"width: %f", [self frame].size.width);
    ////////////////////////NSLog/@"height: %f", [self frame].size.height);
}*/

- (BOOL) acceptsFirstResponder {
    return NO;
}

- (BOOL) canBecomeKeyView {
    return NO;
}

- (void) mouseDown:(NSEvent *)event {
    NSWindow* window = [[NSApplication sharedApplication] windows][0];
    [window makeFirstResponder:[self web]];
    //////////NSLog(@"makefirst responder");
}

@end

