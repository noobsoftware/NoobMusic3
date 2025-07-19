//
//  PHPIncludedObjects.m
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import "PHPMedia.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import "ContentLayout.h"
#import "PHPVideoOperations.h"
#import "PHPLayoutItem.h"

@implementation PHPMedia
- (void) init: (PHPScriptFunction*) context {
    [self initArrays];
    [self setGlobalObject:true];
    
    PHPVideoOperations* videoOperations = [[PHPVideoOperations alloc] init];
    [videoOperations init:context];
    [videoOperations setInterpretation:[context interpretation]];
    
    [self setDictionaryValue:@"operations" value:videoOperations];

    
    PHPScriptFunction* newTab = [[PHPScriptFunction alloc] init];
    [newTab initArrays];
    [self setDictionaryValue:@"add_tab" value:newTab];
    [newTab setPrototype:self];
    [newTab setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        /*NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        input = [self_instance resolveValueReferenceVariableArray:input];*/
        //dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"add tab");
            MediaTab* newMediaTab = [[MediaTab alloc] init];
            [newMediaTab setPhpMedia:self];
        
        if([values[0] count] == 0 || values[0][0] == NULL || [values[0][0] isEqualTo:@0]) {
            [newMediaTab init:context contentLayout:[self contentLayout]];
        } else {
            NSLog(@"values[0][0] %@", values[0][0]);
            [newMediaTab init:context contentLayout:(LayoutBox*)[(PHPLayoutItem*)[self parseInputVariable:values[0][0]] layoutBox]];
        }
        //});
        //[[self contentLayout] addVideoViewLayout:[newMediaTab layoutBox]];
        
            
        
        return newMediaTab;
    } name:@"main"];
    
    PHPScriptFunction* choose_screens = [[PHPScriptFunction alloc] init];
    [choose_screens initArrays];
    [self setDictionaryValue:@"choose_screens" value:choose_screens];
    [choose_screens setPrototype:self];
    [choose_screens setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        double __block result;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            result = [[self contentLayout] chooseScreens];
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return [@(result) stringValue];
    } name:@"main"];
    
    
    PHPScriptFunction* choose_screens_alt = [[PHPScriptFunction alloc] init];
    [choose_screens_alt initArrays];
    [self setDictionaryValue:@"choose_screens_alt" value:choose_screens_alt];
    [choose_screens_alt setPrototype:self];
    [choose_screens_alt setClosure:^NSObject*(NSMutableArray* values, PHPScriptFunction* self_instance) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSObject* input = values[0][0];
            if([input isKindOfClass:[MediaTab class]]) {
                MediaTab* mediaTab = (MediaTab*)input;
                [[self contentLayout] chooseScreensAlt:[mediaTab layoutBox]];
                //return [@(result) stringValue];
            }
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return nil;
    } name:@"main"];
    [self setCommandKeyDown:false];
    
    /*PHPScriptFunction* set_click_callback = [[PHPScriptFunction alloc] init];
    [set_click_callback initArrays];
    [self setDictionaryValue:@"register_callback" value:set_click_callback];
    [set_click_callback setPrototype:self];
    [set_click_callback setClosure:^NSObject*(NSMutableArray* values, PHPScriptFunction* self_instance) {
        //////////////////NSLog/@"set click callback input %@", values);
        NSObject* input = values[0][0];
        //////////////////NSLog/@"set click callback input %@", input);
        PHPScriptFunction* callback = (PHPScriptFunction*)input;
        //[clickVideoView setCallbacks:@[callback]];
        return nil;
    } name:@"main"];*/
    /*[NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown handler:^NSEvent*(NSEvent* event) {
        if(([event modifierFlags] & NSEventModifierFlagCommand) == NSEventModifierFlagCommand) {
            [self setCommandKeyDown:true];
        }
        return event;
    }];*/
}

- (MediaTab*) getCurrentMediaTab {
    return nil;
    /*PHPScriptFunction* getCurrentTab = [self getDictionaryValue:@"get_current_tab" returnReference:@false createIfNotExists:@false context:self];
    PHPScriptObject* mediaTab = [(PHPReturnResult*)[getCurrentTab callCallback:@[]] get];
   
    return mediaTab;*/
}

- (void) chooseScreensAlt: (MediaTab*) mediaTab {
    [[self contentLayout] chooseScreensAlt:[mediaTab layoutBox]];
}
@end
