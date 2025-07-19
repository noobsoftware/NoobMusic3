//
//  LayoutVideoView.m
//  noobtest
//
//  Created by siggi jokull on 23.2.2023.
//

#import "LayoutVideoView.h"
//#import <Foundation/Foundation.h>
/*for( GenericBlock block in array ){
    block();
}*/

@implementation LayoutVideoView
- (BOOL) acceptsFirstResponder {
    return NO;
}
- (BOOL) canBecomeKeyView {
    return NO;
}

- (void) mouseDown:(NSEvent *)event {
    //NSWindow* window = [[NSApplication sharedApplication] windows][0];
    //[window makeFirstResponder:[self web]];
    //////////NSLog(@"makefirst responder");
}
@end
