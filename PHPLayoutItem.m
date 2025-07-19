//
//  PHPLayoutItem.m
//  noobtest
//
//  Created by siggi on 14.1.2025.
//

#import "PHPLayoutItem.h"

//#import "PHPScriptObject.h"
#import "LayoutBox.h"
#import "PHPScriptFunction.h"
#import "PHPInterpretation.h"
#import "ContentLayout.h"
#import "PHPWebView.h"

@implementation PHPLayoutItem

- (void) init: (PHPScriptFunction*) context {
    [self initArrays];
    [self setGlobalObject:true];
    
    /*PHPRegex* regex = [[PHPRegex alloc] init];
    [regex init:context];
    
    [self setDictionaryValue:@"regex" value:regex];
    [regex setInterpretation:[context interpretation]];
    
    PHPStrings* stringsObject = [[PHPStrings alloc] init];
    [stringsObject init:context];
    [stringsObject setInterpretation:[context interpretation]];
    
    [self setDictionaryValue:@"strings" value:stringsObject];*/
    
    PHPScriptFunction* setBox = [[PHPScriptFunction alloc] init];
    [setBox initArrays];
    [self setDictionaryValue:@"set_box" value:setBox];
    [setBox setPrototype:self];
    [setBox setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        //NSObject* input = [self parseInputVariable:values[0][0]];
        //NSDictionary* inputBox = (NSDictionary*)input;
        ToJSON* toJSON = [[ToJSON alloc] init];
        NSDictionary* setBoxValues = (NSDictionary*)[toJSON toJSON:[self parseInputVariable:values[0][0]]];
        //NSLog(@"set box values : %@", setBoxValues);
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[self layoutBox] setBox:setBoxValues];
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* calculate_layout = [[PHPScriptFunction alloc] init];
    [calculate_layout initArrays];
    [self setDictionaryValue:@"calculate_layout" value:calculate_layout];
    [calculate_layout setPrototype:self];
    [calculate_layout setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        /*NSObject* input = [self parseInputVariable:values[0][0]];
        NSDictionary* inputBox = (NSDictionary*)input;
        [[self layoutBox] setBox:inputBox];*/
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[self layoutBox] recalculateLayout];
        });
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* children = [[PHPScriptFunction alloc] init];
    [children initArrays];
    [self setDictionaryValue:@"children" value:children];
    [children setPrototype:self];
    [children setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        /*NSObject* input = [self parseInputVariable:values[0][0]];
        NSDictionary* inputBox = (NSDictionary*)input;
        [[self layoutBox] setBox:inputBox];*/
        /*[[self layoutBox] recalculateLayout];
        return @"NULL";*/
        NSMutableArray* results = [[NSMutableArray alloc] init];
        for(LayoutBox* child in [[self layoutBox] children]) {
            [results addObject:[child layoutItem]];
        }
        return [[self getInterpretation] makeIntoObjects:results];
    } name:@"main"];
    
    PHPScriptFunction* raise_child = [[PHPScriptFunction alloc] init];
    [raise_child initArrays];
    [self setDictionaryValue:@"raise_child" value:raise_child];
    [raise_child setPrototype:self];
    [raise_child setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        /*NSObject* input = [self parseInputVariable:values[0][0]];
        NSDictionary* inputBox = (NSDictionary*)input;
        [[self layoutBox] setBox:inputBox];*/
        /*[[self layoutBox] recalculateLayout];
        return @"NULL";*/
        /*NSMutableArray* results = [[NSMutableArray alloc] init];
        for(LayoutBox* child in [[self layoutBox] children]) {
            [results addObject:[child layoutItem]];
        }
        return [[self getInterpretation] makeIntoObjects:results];*/
        //[[[self layoutBox]]
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSMutableArray* result = [[NSMutableArray alloc] initWithArray:[[[[self layoutBox] parent] mainView] subviews]];
            [result removeObject:[[self layoutBox] mainView]];
            [result addObject:[[self layoutBox] mainView]];
            //[result insertObject:[[self layoutBox] mainView] atIndex:0];
            [[[[self layoutBox] parent] mainView] setSubviews:result];
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* make = [[PHPScriptFunction alloc] init];
    [make initArrays];
    [self setDictionaryValue:@"make" value:make];
    [make setPrototype:self];
    [make setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSObject* htmlElement = [self parseInputVariable:values[0][0]];
        PHPScriptObject* htmlElementObject = (PHPScriptObject*)htmlElement;
        
        LayoutBox* layoutBox = [[LayoutBox alloc] init];
        [layoutBox setContentLayout:[[self layoutBox] contentLayout]];
        /*[layoutBox setBox:@{
            @"set_height": @50,
            @"set_width": @50,
            @"width_type": @1,
            @"height_type": @1,
            @"orientation": @1,
            @"display": @true
        }];*/
        
        ToJSON* toJSON = [[ToJSON alloc] init];
        
        NSDictionary* setBoxValues = (NSDictionary*)[toJSON toJSON:[self parseInputVariable:values[0][1]]];
        //NSLog(@"set box values : %@", setBoxValues);
        
        if([values[0] count] >= 3) {
            [layoutBox setIsVideoView:true];
            
            
        }
        
        [layoutBox setBox:setBoxValues];
        [[self layoutBox] addChildren:@[layoutBox]];
        //[layoutBox make:false isRootCall:false];
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[layoutBox contentLayout] makeLayout:layoutBox];
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //[[self layoutBox] make:false isRootCall:true];
        return [layoutBox layoutItem];
        //PHPScriptObject* boxValues =
        /*NSDictionary* inputBox = (NSDictionary*)input;
        [[self layoutBox] setBox:inputBox];*/
        /*[[self layoutBox] recalculateLayout];
        return @"NULL";*/
        /*NSMutableArray* results = [[NSMutableArray alloc] init];
        for(LayoutBox* child in [[self layoutBox] children]) {
            [results addObject:[child layoutItem]];
        }
        return [[self getInterpretation] makeIntoObjects:results];*/
        
        //return @true;
    } name:@"main"];
    
    /*PHPScriptFunction* getBox_values = [[PHPScriptFunction alloc] init];
    [getBox_values initArrays];
    [self setDictionaryValue:@"get_box" value:getBox_values];
    [getBox_values setPrototype:self];
    [getBox_values setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        return [[self getInterpretation] makeIntoObjects:[[self layoutBox] box]];
    } name:@"main"];*/
    
    PHPScriptFunction* getBox = [[PHPScriptFunction alloc] init];
    [getBox initArrays];
    [self setDictionaryValue:@"get_result" value:getBox];
    [getBox setPrototype:self];
    [getBox setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        /*NSObject* input = [self parseInputVariable:values[0][0]];
        NSDictionary* inputBox = (NSDictionary*)input;
        [[self layoutBox] setBox:inputBox];
        return @"NULL";*/
        CGRect box = [[self layoutBox] getResultValues:true];
        NSMutableDictionary* box_values = [[NSMutableDictionary alloc] initWithDictionary:@{
            @"position": @{
                @"x": @(box.origin.x),
                @"y": @(box.origin.y)
            },
            @"size": @{
                @"width": @(box.size.width),
                @"height": @(box.size.height),
            }
        }];
        return [[self getInterpretation] makeIntoObjects:box_values];
    } name:@"main"];
    
    PHPScriptFunction* assign_web_view = [[PHPScriptFunction alloc] init];
    [assign_web_view initArrays];
    [self setDictionaryValue:@"assign_web_view" value:assign_web_view];
    [assign_web_view setPrototype:self];
    [assign_web_view setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSObject* input = [self parseInputVariable:values[0][0]];
        NSNumber* inputIndex = (NSNumber*)[self_instance makeIntoNumber:input];
        long index = [inputIndex longLongValue];
        WKWebView* __block web = nil;
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            web = [[self layoutBox] assignWebView:index];
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        PHPWebView* result = [[PHPWebView alloc] init];
        [result init:self_instance];
        [result setWebView:web];
        [result initDelegates];
        return result;
        //return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* animate = [[PHPScriptFunction alloc] init];
    [animate initArrays];
    [self setDictionaryValue:@"animate" value:animate];
    [animate setPrototype:self];
    [animate setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        /*NSObject* input = [self parseInputVariable:values[0][0]];
        NSNumber* inputIndex = (NSNumber*)[self_instance makeIntoNumber:input];
        long index = [inputIndex longLongValue];
        WKWebView* web = [[self layoutBox] assignWebView:index];
        PHPWebView* result = [[PHPWebView alloc] init];
        [result init:self_instance];
        [result setWebView:web];
        return result;*/
        //NSObject* inputBox = [self parseInputVariable:values[0][0]];
        //[[self layoutBox] recalculateLayout:true animateTime:4 easingA:0.47 easingB:0.53 easingC:0.31 easingD:0.96 callbacks:@[] layoutBoxes:@[[self layoutBox]]];
        
        /*[[[[self layoutBox] contentLayout] rootLayoutBox] recalculateLayout:true animateTime:2 easingA:0.47 easingB:0.53 easingC:0.31 easingD:0.96 callbacks:@[] layoutBoxes:@[[self layoutBox]]];*/
            LayoutBox* box22 = [self layoutBox];
            /*NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.7
             target:[NSBlockOperation blockOperationWithBlock:^{*/
            //[self transform:@[sidebar, sidebar2]];
        NSNumber* animate_time = [self makeIntoNumber:[self parseInputVariable:values[0][0]]];
        NSArray* bezier = [[self getInterpretation] toJSON:[self parseInputVariable:values[0][1]]];
        NSLog(@"root: %@ - %@", [box22 contentLayout], bezier);
        NSMutableArray* boxes = [[NSMutableArray alloc] init];
        if([values[0] count] > 2) {
            if(![values[0][2] isEqualTo:@"[]"]) {
                boxes = [[self getInterpretation] toJSON:[self parseInputVariable:values[0][2]]];//[[NSMutableArray alloc] init]
            }
        }
        [boxes addObject:box22];
        PHPScriptFunction* callback = nil;
        if([values[0] count] > 3) {
            callback = [self parseInputVariable:values[0][3]];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [
                [[box22 contentLayout] rootLayoutBox]
                //box22
                //[self rootLayoutBox]
                recalculateLayout:true animateTime:[animate_time doubleValue] easingA:[bezier[0] doubleValue] easingB:[bezier[1] doubleValue] easingC:[bezier[2] doubleValue] easingD:[bezier[3] doubleValue] callbacks:@[^{
                    if(callback != nil) {
                        [callback callCallback:@[]];
                    }
                }] layoutBoxes:boxes];
            NSLog(@"animate");
        });
        return @"NULL";
    } name:@"main"];
    
    /*[[self rootLayoutBox] recalculateLayout:true animateTime:2 easingA:0.47 easingB:0.53 easingC:0.31 easingD:0.96 callbacks:@[] layoutBoxes:@[[self videoViewLayoutBox]]];*/
    
    /*NSURL* nsurl = [[NSURL alloc] initWithString:@"http://192.168.1.5/objectives/"];
     NSURLRequest* req = [[NSURLRequest alloc] initWithURL:nsurl];
     [web loadRequest:req];*/
}

/*- (BOOL) isFlipped {
    return YES;
}*/

@end
