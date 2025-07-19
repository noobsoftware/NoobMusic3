//
//  ClickVideoView.m
//  noobtest
//
//  Created by siggi jokull on 28.2.2023.
//
#import "ClickVideoView.h"
#import "PHPScriptFunction.h"
#import "PHPMedia.h"
#import "MediaTab.h"
#import "PHPReturnResult.h"
//#import <Foundation/Foundation.h>
/*for( GenericBlock block in array ){
    block();
}*/

@implementation ClickVideoView
- (void) initArrays {
    [self setCallbacks:[[NSMutableArray alloc] init]];
}
- (void) mouseDown:(NSEvent *)event {
    NSWindow* window = [[NSApplication sharedApplication] windows][0];
    [window makeFirstResponder:[self web]];
    //[window makeFirstResponder:[window initialFirstResponder]];
    //////////////////NSLog/@"mouseDown");
    //if([[self phpMedia] commandKeyDown]) {
    if(([event modifierFlags] & NSEventModifierFlagCommand) == NSEventModifierFlagCommand) {
        NSObject* callback = [self callbacks][1];
        PHPScriptFunction* function = (PHPScriptFunction*)callback;
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        [function callScriptFunctionSub:arr parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:nil];
        /*////////////NSLog(@"result: %@", [result class]);
        if([result isKindOfClass:[PHPReturnResult class]]) {
            result = [(PHPReturnResult*)result get];
        }
        ////////////NSLog(@"result: %@ - %@", result, [result class]);*/
        [[self phpMedia] chooseScreensAlt:[self mediaTab]];
    } else {
        //for(NSObject* callback in [self callbacks]) {
        NSObject* callback = [self callbacks][0];
        PHPScriptFunction* function = (PHPScriptFunction*)callback;
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        [function callScriptFunctionSub:arr parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:nil];
        //}
    }
}

- (void) callCallbackFirst {
    NSObject* callback = [self callbacks][0];
    PHPScriptFunction* function = (PHPScriptFunction*)callback;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [function callScriptFunctionSub:arr parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:nil];
}

@end
