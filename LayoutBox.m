//
//  LayoutBox.m
//  noobtest
//
//  Created by siggi jokull on 4.12.2022.
//

#import "LayoutBox.h"
//#import <VLCKit/VLCKit.h>
#import "ContentLayout.h"
#import "PHPLayoutItem.h"
#import "PHPInterpretation.h"

@implementation LayoutBox

- (void) setBox: (NSDictionary*) setValues {
    [self setCalculatedHeight:-1];
    [self setCalculatedWidth:-1];
    [self setCalculatedHorizontalEnd:-1];
    [self setCalculatedHorizontalPosition:-1];
    [self setCalculatedVerticalEnd:-1];
    [self setCalculatedVerticalPosition:-1];
    [self setSetHeight:-1];
    [self setSetWidth:-1];
    [self setOrientation:true];
    [self setOverflow:0];
    [self setHeightType:0];
    [self setWidthType:0];
    [self setDisplay:1];
    [self setHorizontalAlignment:0];
    [self setVerticalAlignment:0];
    [self setIsAnimated:false];
    if([self children] == nil) {
        [self setChildren:[[NSMutableArray alloc] init]];
    }
    if([setValues objectForKey:@"set_height"] != nil) {
        [self setSetHeight:([(NSNumber*)[setValues objectForKey:@"set_height"] doubleValue])];
    }
    if([setValues objectForKey:@"set_width"] != nil) {
        [self setSetWidth:([(NSNumber*)[setValues objectForKey:@"set_width"] doubleValue])];
    }
    if([setValues objectForKey:@"orientation"] != nil) {
        //if([(NSString*)[setValues objectForKey:@"orientation"] isEqualToString:@"horizontal"]) {
        if([(NSNumber*)[setValues objectForKey:@"orientation"] intValue] == 1) {
            [self setOrientation:false];
        }
    }
    if([setValues objectForKey:@"overflow"] != nil) {
        [self setOverflow:[(NSNumber*)[setValues objectForKey:@"overflow"] intValue]];
        ////////////////////////////NSLog/@"overflow: %lu", [self overflow]);
    }
    if([setValues objectForKey:@"display"] != nil) {
        //if(![(NSString*)[setValues objectForKey:@"display"] isEqualToString:@"block"]) {
        
        //if([setValues objectForKey:@"display"] == 0) {
            [self setDisplay:[(NSNumber*)[setValues objectForKey:@"display"] intValue]];
        //}
    }
    if([setValues objectForKey:@"width_type"] != nil) {
        [self setWidthType:([(NSNumber*)[setValues objectForKey:@"width_type"] intValue])];
    }
    if([setValues objectForKey:@"height_type"] != nil) {
        [self setHeightType:([(NSNumber*)[setValues objectForKey:@"height_type"] intValue])];
    }
    if([setValues objectForKey:@"horizontal_alignment"] != nil) {
        [self setHorizontalAlignment:([(NSNumber*)[setValues objectForKey:@"horizontal_alignment"] intValue])];
    }
    if([setValues objectForKey:@"vertical_alignment"] != nil) {
        [self setVerticalAlignment:([(NSNumber*)[setValues objectForKey:@"vertical_alignment"] intValue])];
    }
    if([setValues objectForKey:@"set_rectangle"] != nil) {
        [self setSetRectangle:((NSMutableArray*)[setValues objectForKey:@"set_rectangle"])];
    }
    if([setValues objectForKey:@"rectangle_type"] != nil) {
        [self setRectangleType:((NSMutableArray*)[setValues objectForKey:@"rectangle_type"])];
    }
    if([setValues objectForKey:@"rectangle_addition"] != nil) {
        [self setRectangleAddition:((NSMutableArray*)[setValues objectForKey:@"rectangle_addition"])];
    }
    if([setValues objectForKey:@"rectangle_subtraction"] != nil) {
        [self setRectangleSubtraction:((NSMutableArray*)[setValues objectForKey:@"rectangle_subtraction"])];
    }
    if([setValues objectForKey:@"string_content"] != nil) {
        [self setStringContent:((NSString*)[setValues objectForKey:@"string_content"])];
    }
    //[self setSetPo]
}


- (WKWebView*) assignWebView: (long) index {
    return [(ClickView*)[self mainView] assignWebView:index];
}
/*- (NSDictionary*) getBox {
    return @{
        @"rectangle_subtraction": [self rectangleSubtraction],
        @"rectangle_addition": [self rectangleAddition]
    };
}*/

- (LayoutBox*) copy {
    //LayoutBox* myArray1 = @[@"test123", @"test2"];
    //LayoutBox* superView;
    long index = -1;
    NSView* superView;
    if([[self mainView] superview] != nil) {
        superView = [[self mainView] superview];
        index = [[superView subviews] indexOfObject:[self mainView]];
        [[self mainView] removeFromSuperview];
    }
    LayoutBox* parent;
    if([self parent] != nil) {
        parent = [self parent];
        [self setParent:nil];
    }
    NSError* error;
    NSData* buffer = [NSKeyedArchiver archivedDataWithRootObject: self requiringSecureCoding:NO error:&error];
    LayoutBox* result = [NSKeyedUnarchiver unarchivedObjectOfClass:[LayoutBox class] fromData:buffer error:&error];
    //[[self mainView] ]
    if(superView != nil) {
        NSArray<NSView*>* subviews = [superView subviews];
        NSMutableArray<NSView*>* subviewsMutable = [[NSMutableArray alloc] initWithArray:subviews];
        [subviewsMutable insertObject:[self mainView] atIndex:index];
        [superView setSubviews:[subviewsMutable copy]];
    }
    if(parent != nil) {
        [self setParent:parent];
    }
    
    //[subviews add]
    return result;
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (CGColorRef) randomColor {
    double r1 = [self randomFloatBetween:0 and:1];
    double r2 = [self randomFloatBetween:0 and:1];
    double r3 = [self randomFloatBetween:0 and:1];
    double r4 = 0.2;//[self randomFloatBetween:0 and:1];
    ////////////////////////////NSLog/@"%f %f %f %f", r1, r2, r3, r3);
    return CGColorCreateSRGB(r1, r2, r3, r4);
}

- (void) addChildren: (NSArray*) children {
    [[self children] addObjectsFromArray:children];
    for(LayoutBox* child in children) {
        [child setParent:self];
    }
}

- (void) removeChild: (LayoutBox*) child {
    [[self children] removeObject:child];
    [child setParent:nil];
}

/*- (void) fillView {
    [self setBox:@{
        @"set_rectangle": @[
            @(0),
            @(0),
            @(0),
            @(0),
        ],
        @"rectangle_type": @[@0, @0, @0, @0],
    }];
    NSArray* subViews = [[[self parent] mainView] subviews];
    NSString* identifier = [[self mainView] identifier];
    [[self mainView] setIdentifier:@"to_top"];
    subViews = [subViews sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSView* view_a = (NSView*)obj1;
        NSView* view_b = (NSView*)obj2;
        if([[view_a identifier] isEqualToString:@"to_top"]) {
            return NSOrderedDescending;
        } else if([[view_b identifier] isEqualToString:@"to_top"]) {
            return NSOrderedAscending;
        }
        //return NSOrderedSame;
        return NSOrderedAscending;
        //return (NSComparisonResult)NSOrderedSame;
    }];
    [[self mainView] setIdentifier:identifier];
    [[[self parent] mainView] setSubviews:subViews];
    [[self contentLayout] setWebViewAbove];
    [self recalculateLayout:true animateTime:2 easingA:0.47 easingB:0.53 easingC:0.31 easingD:0.96 callbacks:@[^(int i){
        [[self contentLayout] resetVideoViewSizes];
        for(LayoutBox* child in [[self parent] children]) {
            if(child != self) {
                [[child mainView] setAlphaValue:0];
            }
        }
    }] layoutBoxes:@[]];
    
}*/

- (void) fillView {
    [self setBox:@{
        @"set_rectangle": @[
            @(0),
            @(0),
            @(0),
            @(0),
        ],
        @"rectangle_type": @[@0, @0, @0, @0],
    }];
    //NSLog(@"fillview : %@ - %@", [self mainView], [self parent]);
    NSMutableArray* subViews = [[NSMutableArray alloc] initWithArray:[[[self mainView] superview] subviews]];//[[[self parent] mainView] subviews];
    //NSString* identifier = [[self mainView] identifier];
    /*[[self mainView] setIdentifier:@"to_top"];
    subViews = [subViews sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSView* view_a = (NSView*)obj1;
        NSView* view_b = (NSView*)obj2;
        if([[view_a identifier] isEqualToString:@"to_top"]) {
            return NSOrderedDescending;
        } else if([[view_b identifier] isEqualToString:@"to_top"]) {
            return NSOrderedAscending;
        }
        return NSOrderedAscending;
        //return (NSComparisonResult)NSOrderedSame;
    }];
    [[self mainView] setIdentifier:identifier];*/
    [subViews removeObject:[self mainView]];
    [subViews addObject:[self mainView]];
    //NSLog(@"subviews count : %@", @([subViews count]));
    [[[self mainView] superview] setSubviews:subViews];//
    //[[[self parent] mainView] setSubviews:subViews];
    [[self contentLayout] setWebViewAbove];
    [self recalculateLayout:true animateTime:2 easingA:0.47 easingB:0.53 easingC:0.31 easingD:0.96 callbacks:@[^(int i){
        [[self contentLayout] resetVideoViewSizes];
        for(LayoutBox* child in [[self parent] children]) {
            if(child != self) {
                [[child mainView] setAlphaValue:0];
            }
        }
    }] layoutBoxes:@[]];
    
}

- (NSView*) make: (bool) returnReverse isRootCall: (bool) isRootCall { //}: (ClickView*) parentContainer contentLayout: (ContentLayout*) contentLayout {
    NSLog(@"add make");
    NSLog(@"layout item : %@", [self layoutItem]);
    if([self isReverse]) {
        returnReverse = true;
    }
    if([self layoutItem] == nil) {
        [self setLayoutItem:[[PHPLayoutItem alloc] init]];
        [[self layoutItem] setLayoutBox:self];
        
        if([[[self contentLayout] interpretation] globalContext] != nil) {
            [[self layoutItem] setInterpretation:[[self contentLayout] interpretation]];
            [[self layoutItem] init:[[[self contentLayout] interpretation] globalContext]];
        } else {
            NSLog(@"layout PHP item has no interpretation %@ - %@ - %@", [self contentLayout], [[self contentLayout] interpretation], [[[self contentLayout] interpretation] globalContext]);
        }
        
        NSLog(@"set layout item : %@", [self layoutItem]);
    }
    if([self mainView] != nil) {
        [[self mainView] removeFromSuperview];
    }
    NSView* newClickView;
    if([self isVideoView]) {
        newClickView = [[ClickVideoView alloc] init];
        //[(ClickVideoView*)newClickView setWeb:[[self contentLayout] web]];
        //[newClickView setAlphaValue:0];
        //[newClickView setHidden:true];
        //[(VLCVideoView*)newClickView set]
    } else {
        newClickView = [[ClickView alloc] init];
    }
    if(returnReverse) {
        [self setLastSetChildRoot:newClickView];
    }
    //VLCVideoView* newClickView = [[VLCVideoView alloc] init];
    
    [self setMainView:newClickView];
    CGRect result_values = [self getResultValues:true];
    [newClickView setFrame:result_values];
    if([newClickView isKindOfClass:[ClickView class]]) {
        //[newClickView ]
        CALayer* layer = [[CALayer alloc] init];
        //[layer setBackgroundColor:[self randomColor]];
        [newClickView setLayer:layer];
        bool set_scroll_view = false;
        if([self overflow] == 1) {
            set_scroll_view = true;
            //////////////////////////NSLog/@"results value is true");
            [self setCalculatedHeight:-1];
            //[self resetCalculatedValues];
            CGRect scroll_result_values = [self getResultValues:false];
            /*if(scroll_result_values.size.height == 0|| scroll_result_values.size.height < result_values.size.height) {
                scroll_result_values.size.height = result_values.size.height;
            }*/
            ScrollView* scrollView = [[ScrollView alloc] initWithFrame:scroll_result_values];
            //if(scrollView.frame.size.height != result_values.size.height) {
                ////////////////////////////NSLog/@"scroll view height difference: %f", result_values.size.height-scrollView.frame.size.height );
            //}
            //[scrollView setHasVerticalScroller:true];
            [self setScrollView:scrollView];
            [scrollView setDocumentView:newClickView];
            [scrollView setAutohidesScrollers:false];
            [scrollView setRulersVisible:true];
            [scrollView setHasVerticalScroller:true];
            [[scrollView contentView] scrollToPoint:NSMakePoint(0, 0)];
        }
        if([self stringContent] != nil) {
            NSTextField* label = [[NSTextField alloc] initWithFrame:[newClickView frame]];
            [label setStringValue:[self stringContent]];
            [label setEditable:false];
            [label setUsesSingleLineMode:false];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            [label setBackgroundColor:[NSColor clearColor]];
            //[label setMaximumNumberOfLines:5];
            [[label cell] setTruncatesLastVisibleLine:true];
            [newClickView addSubview:label];
            [self setTextField:label];
        }
        for(LayoutBox* child in [self children]) {
            //////////////////////////NSLog/@"add child");
            //if(!set_scroll_view) {
            NSView* childView = [child make:returnReverse
                                 //returnReverse
                                 isRootCall:false];
            [newClickView addSubview:childView];
            if(returnReverse) {
                [self setLastSetChildRoot:[child lastSetChildRoot]];
            }
            if(returnReverse && isRootCall) {
                return [self lastSetChildRoot];
            }
            /*} else {
                [[self scrollView] addSubview:[child make]];
            }*/
        }
        if(set_scroll_view) {
            return [self scrollView];
        }
    }
    return newClickView;
}

- (void) resetCalculatedValues {
    [self setCalculatedHeight:-1];
    [self setCalculatedWidth:-1];
    [self setCalculatedHorizontalEnd:-1];
    [self setCalculatedHorizontalPosition:-1];
    [self setCalculatedVerticalEnd:-1];
    [self setCalculatedVerticalPosition:-1];
}

- (void) fade_out { //0.24, 0.82, 0.26, 0.84
    [self fade_to:@[[self mainView]] time:0.7 callbacks:@[^(){
        //[[self mainView] setHidden:true];
    }] alphaValue:0 easingA:0.24 easingB:0.82 easingC:0.26 easingD:0.84];
}

/*- (NSComparisonResult) customComparison: (NSView*) view1 view2: (NSView*) view2 context: (void*) context {
    return NSOrderedSame;
}*/
NSComparisonResult compareViews(id firstView, id secondView, void *context) {
    if([[firstView identifier] isEqualToString:@"bringToFront"]) {
        return NSOrderedAscending;
    }
    return NSOrderedDescending;
}

- (void) fadeSwitch: (LayoutBox*) switchItem {
    
    
    //[[switchItem mainView] setHidden:false];
    /*NSComparisonResult compareViews(id firstView, id secondView, void *context) {
        int firstTag = [firstView tag];
        int secondTag = [secondView tag];

        if (firstTag == secondTag) {
            return NSOrderedSame;
        } else {
            if (firstTag < secondTag) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }
    }*/
    NSMutableArray* fadeViews = [[NSMutableArray alloc] init];
    for(LayoutBox* child in [[self parent] children]) {
        /*if(child != self) {
            [[child mainView] setAlphaValue:0];
        }*/
        [fadeViews addObject:[child mainView]];
    }
    NSLog(@"bringtofront : %@", [self mainView]);
    //@[[self mainView], [switchItem mainView]]
    [self fade_to:fadeViews time:0.35 callbacks:@[^(){
        //[[self mainView] setHidden:true];
        //[[switchItem mainView] setHidden:false];
        //(NSComparisonResult (*)(id, id, void*))
        /*[[[self mainView] superview] sortSubviewsUsingFunction:(NSComparisonResult (*)(id, id, void*))((NSComparisonResult)^(NSView* firstView, NSView* secondView, void* context) {
            return NSOrderedSame;
        }) context:nil];*/
        NSString* beforeIdentifier = [[self mainView] identifier];
        [[self mainView] setIdentifier:@"bringToFront"];
        //NSLog(@")
        [[[self mainView] superview] sortSubviewsUsingFunction:compareViews context:nil];
        [[self mainView] setIdentifier:beforeIdentifier];
        /*for(LayoutBox* child in [[self parent] children]) {
            if(child != self) {
                [[child mainView] setAlphaValue:0];
            }
        }*/
        //[[switchItem mainView] bringSubviewToFront];
    }] alphaValue:1 easingA:0.24 easingB:0.82 easingC:0.26 easingD:0.84];
}

- (void) fade_to: (NSMutableArray*) views time: (double) timeValue callbacks: (NSArray*) callbacks alphaValue: (double) alphaValue easingA: (double) a easingB: (double) b easingC: (double) c easingD: (double) d  {
    ////////////////////NSLog/@"call fadeTo");
    [CATransaction begin];
    [CATransaction setAnimationDuration:timeValue];
    CAMediaTimingFunction* custom = [[CAMediaTimingFunction alloc] initWithControlPoints:a :b :c :d];//0.79 :0.25 :0 :0.93];
    [CATransaction setAnimationTimingFunction:custom];

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration:timeValue];
        ////////////////////NSLog/@"timeValue: %f: ", timeValue);
        int index = 0;
        for(id view_item in views) {
            if([view_item isKindOfClass:[VLCVideoView class]]) {
                VLCVideoView* view = (VLCVideoView*)view_item;
                /*NSValue* rect_value_nsvalue = rects[index];
                CGRect rect_value_value = [rect_value_nsvalue rectValue];
                [[view animator] setFrame:rect_value_value];*/
                if(view_item == [self mainView]) {
                    [[view animator] setAlphaValue:alphaValue];
                } else {
                    if(alphaValue == 0) {
                        [[view animator] setAlphaValue:1];
                    } else {
                        [[view animator] setAlphaValue:0];
                    }
                }
                ////////////////////NSLog/@"set animator");
            }
            index++;
        }
    } completionHandler:^{
        //Completion Code
        /*for(LayoutBox* animationBox in [self animationLayoutBoxes]) {
            [animationBox setIsAnimated:false];
        }*/
        ////////////////////NSLog/@"Completed");
        for(id block in callbacks) {
            //////////////////////////NSLog/@"!callblock");
            ((void(^)(void))block)(); //NSEvent *
        }
    }];
    [CATransaction commit];
}
- (void) fade_in {
    //[[self mainView] setHidden:false];
    [self fade_to:@[[self mainView]] time:0.35 callbacks:@[^(){
        //[[self mainView] setHidden:false];
    }] alphaValue:1 easingA:0.24 easingB:0.82 easingC:0.26 easingD:0.84];
}

-(void)transform: (NSMutableArray*) views rects: (NSMutableArray*) rects time: (double) timeValue a:(double) a b:(double) b c:(double) c d:(double) d callbacks: (NSArray*) callbacks {
    //////////////////NSLog/@"call %lu %lu", [views count], [rects count]);
    /*let duration = 2.0

    CATransaction.begin()
    CATransaction.setAnimationDuration(duration)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.8, 0.0, 0.2, 1.0))
    CATransaction.setCompletionBlock {
        print("animation finished")
    }*/
    /*NSArray* myArray = [NSArray arrayWithObjects:[NSValue valueWithPointer: myDog],
     [NSValue valueWithPointer: myPuppy],
     nil];

     structDog* dog = (structDog*)[[myArray objectAtIndex:0] pointerValue]; */
    [CATransaction begin];
    [CATransaction setAnimationDuration:timeValue];
    CAMediaTimingFunction* custom = [[CAMediaTimingFunction alloc] initWithControlPoints:a :b :c :d];//0.79 :0.25 :0 :0.93];
    [CATransaction setAnimationTimingFunction:custom];

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration:timeValue];
        //Animation code
        //Gera switch fyrir JS
        //for loopu fyrir oll element sem animatast
        //[stack_view set]
        //[[[self stackView] animator] setAlphaValue:0];
        int index = 0;
        for(id view_item in views) {
            /*if([view_item isKindOfClass:[VLCVideoView class]]) {
                VLCVideoView* view = (VLCVideoView*)view_item;
                //[[view animator] setFrame:CGRectMake(250, 250, 300, 300)];
                //NSRect* rect_value = (NSRect*)rects[index];
                //CGRect rect_cg_value = [rect_value cg]
                //[[view animator] setFrame:];
                NSValue* rect_value_nsvalue = rects[index];
                CGRect rect_value_value = [rect_value_nsvalue rectValue];
                //////////////////////////NSLog/@"rect value: %f %f %f %f", rect_value_value.size.width, rect_value_value.size.height, rect_value_value.origin.x,  rect_value_value.origin.y);
                [[view animator] setFrame:rect_value_value];
            } else {*/
                NSView* view = (NSView*)view_item;
                NSValue* rect_value_nsvalue = rects[index];
                CGRect rect_value_value = [rect_value_nsvalue rectValue];
                //////////////////////////NSLog/@"rect value: %f %f %f %f", rect_value_value.size.width, rect_value_value.size.height, rect_value_value.origin.x,  rect_value_value.origin.y);
                [[view animator] setFrame:rect_value_value];
                //[[view animator] setsc]
            //}
            index++;
        }
        //[[stack_view layer] setBackgroundColor:CGColorCreateSRGB(1, 1, 0, 0.5)];
        //[stack_view setFrame:CGRectMake(250, 250, 50, 50)];
    } completionHandler:^{
        //Completion Code
        
        for(LayoutBox* animationBox in [self animationLayoutBoxes]) {
            [animationBox setIsAnimated:false];
        }
        ////////////////////////NSLog/@"Completed");
        for(id block in callbacks) {
            //////////////////////////NSLog/@"!callblock");
            ((void(^)(int))block)(0); //NSEvent *
        }
    
        [self setAnimationRects:[[NSMutableArray alloc] init]];
        [self setAnimationViews:[[NSMutableArray alloc] init]];
    }];
    [CATransaction commit];
}

- (void) recalculateLayout{
    [self resetCalculatedValues];
    CGRect result_values = [self getResultValues:true];
    //NSLog(@"result values : %@ - %@", @(result_values) , self);
    [[self mainView] setFrame:result_values];
    if([self scrollView] != nil) {
        [self setCalculatedHeight:-1];
        //[self resetCalculatedValues];
        CGRect scroll_result_values = [self getResultValues:false];
        //if(scroll_result_values.size.height == 0 || scroll_result_values.size.height < result_values.size.height) {
        //    scroll_result_values.size.height = result_values.size.height;
        //}
        [[self scrollView] setFrame:scroll_result_values];
        //[[self scrollView].contentView scrollToPoint:NSMakePoint(0, 0)];
    }
    if([self textField] != nil) {
        [[self textField] setFrame:result_values];
    }
   
    for(LayoutBox* child in [self children]) {
        //NSLog(@"child is :%@", child);
        if(![[self animationViews] containsObject:child]) {
            [child recalculateLayout];
            //NSLog(@"calculate child : %@", child);
        }
    }
}

- (void) recalculateLayout: (bool) animate animateTime: (double) animateTime easingA: (double) a easingB: (double) b easingC: (double) c easingD: (double) d callbacks:(NSArray*) callbacks layoutBoxes: (NSArray*) layoutBoxes {
    [self resetCalculatedValues];
    if(animate && animateTime != -1) {
        for(LayoutBox* animationBox in layoutBoxes) {
            [animationBox setIsAnimated:true];
        }
        [self setAnimationLayoutBoxes:layoutBoxes];
    }
    CGRect result_values = [self getResultValues:true];
    //[self setCalculatedResultValue:result_values];
    //if(animate && animateTime != -1) {
        //////////////////////////NSLog/@"reset");
        [self setAnimationRects:[[NSMutableArray alloc] init]];
        [self setAnimationViews:[[NSMutableArray alloc] init]];
        //[self setAnimationCallbacks:[[NSMutableArray alloc] initWithArray:callbacks]];
        
    //}
    if(!animate) {
        [[self mainView] setFrame:result_values];
        if([self scrollView] != nil) {
            [self setCalculatedHeight:-1];
            //[self resetCalculatedValues];
            CGRect scroll_result_values = [self getResultValues:false];
            //if(scroll_result_values.size.height == 0 || scroll_result_values.size.height < result_values.size.height) {
            //    scroll_result_values.size.height = result_values.size.height;
            //}
            [[self scrollView] setFrame:scroll_result_values];
            //[[self scrollView].contentView scrollToPoint:NSMakePoint(0, 0)];
        }
        if([self textField] != nil) {
            [[self textField] setFrame:result_values];
        }
    } else {
        //////////////////////////NSLog/@"add");
        //[[self animationViews] add]
        //////////////////////////NSLog/@" cgrect: %f %f %f %f", result_values.size.width, result_values.size.height, result_values.origin.x, result_values.origin.y);
        //[[self animationRects] addObject:[NSValue valueWithPointer:&result_values]];
        [[self animationRects] addObject:[NSValue valueWithRect:result_values]];
        [[self animationViews] addObject:[self mainView]];
        //////////////////////////NSLog/@"count : %lu %lu", [[self animationViews] count], [[self animationRects] count]);
        
        /*if([self textField] != nil) {
            [[self animationRects] addObject:[NSValue valueWithPointer:&result_values]];
            [[self animationViews] addObject:[self textField]];
        }*/
    }
    for(LayoutBox* child in [self children]) {
        //////////////////////////NSLog/@"child");
        [child recalculateLayout:animate animateTime:-1 easingA:-1 easingB:-1 easingC:-1 easingD:-1 callbacks:@[] layoutBoxes:@[]];
        //[[self animationRects] addObjectsFromArray:[child animationRects]];
        //[[self animationRects] addObject:[NSValue valueWithPointer:&[child calculatedResultValue]]];
        //CGRect rect_child_value = [child calculatedResultValue];
        [[self animationRects] addObjectsFromArray:[child animationRects]];
        [[self animationViews] addObjectsFromArray:[child animationViews]];
    }
    if(animate && animateTime != -1) {
        //////////////////NSLog/@"animatinoRects: %@", [self animationRects]);
        [self transform:[self animationViews] rects:[self animationRects] time:animateTime a:a b:b c:c d:d callbacks:callbacks];
    }
}

- (NSRect) getResultValues: (bool) forScroll {
    NSRect result = NSMakeRect(0, 0, 0, 0);
    result.size.height = [self getHeight:false forScroll:forScroll];
    result.size.width = [self getWidth:false];
    result.origin.y = [self getVerticalPosition];
    result.origin.x = [self getHorizontalPosition];
    //////////////////////////NSLog/@"%f, %f, %f, %f", result.size.height, result.size.width, result.origin.y, result.origin.x);
    return result;
    //return NULL;
}

- (void) setParentForChildren {
    for(LayoutBox* child in [self children]) {
        [child setParent:self];
    }
}

- (LayoutBox*) getPreviousElement: (LayoutBox*) element {
    LayoutBox* previous_element = nil;
    for(LayoutBox* child in [self children]) {
        if(element == child) {
            return previous_element;
        }
        if([child display]) {
            previous_element = child;
        }
    }
    return nil;
}

- (double) getHorizontalEnd {
    double horizontal_position = [self getHorizontalPosition];
    //if(vertical)
    double width = [self getWidth:false];
    return horizontal_position+width;
}

- (double) getHorizontalPosition {
    if([self calculatedHorizontalPosition] == -1) {
        double calculated_value = [self getHorizontalPositionSub];
        if(calculated_value != -1) {
            [self setCalculatedHorizontalPosition:calculated_value];
        }
        //////////////////////////NSLog/@"calculated height: %f, ", calculated_value);
    }
    return [self calculatedHorizontalPosition];
}

- (double) getHorizontalPositionSub {
    if([self setRectangle] != nil && [(NSNumber*)[self setRectangle][0] doubleValue] != -1) {
        double rectangle_value = [(NSNumber*)[self setRectangle][0] doubleValue];
        if([self rectangleType] != nil && [(NSNumber*)[self rectangleType][0] boolValue]) {
            rectangle_value /= 100;
            rectangle_value = [[self parent] getWidth:false]*rectangle_value;
        }
        double rectangle_addition_value = [(NSNumber*)[self rectangleAddition][0] doubleValue];
        if([self rectangleAddition] != nil  && rectangle_addition_value != -1) {
            rectangle_value += rectangle_addition_value;
        }
        double rectangle_subtraction_value = [(NSNumber*)[self rectangleSubtraction][0] doubleValue];
        if([self rectangleSubtraction] != nil  && rectangle_subtraction_value != -1) {
            rectangle_value -= rectangle_subtraction_value;
        }
        return rectangle_value;
    }
    if([self display] && ![[self parent] orientation]) {
        LayoutBox* previous_element = [[self parent] getPreviousElement:self];
        if(previous_element != nil) {
            double result = [previous_element getHorizontalEnd];
            int remaining_child_count = [[self parent] getRemainingChildrenCount:self];
            double parent_height = [[self parent] getWidth:false];
            if([self horizontalAlignment] == 1) {
                double remaining_margin = parent_height+result;
                if(remaining_child_count > 0) {
                    double end_addition = 0;
                    double start_offset = [[[self parent] children] count]-remaining_child_count;
                    int index = 0;
                    for(LayoutBox* child in [[self parent] children]) {
                        if(index >= start_offset) {
                            end_addition = [child getWidth:false];
                        }
                        index++;
                    }
                    remaining_margin -= 2*end_addition;
                } else {
                    
                }
                remaining_margin /= 2;
                return remaining_margin;
            } else if([self horizontalAlignment] == 2) {
                double remaining_margin = parent_height - [self getWidth:false];
                return remaining_margin;
            }
            return result;
        }
    }
    if([self horizontalAlignment] == 0) {
        return 0;
    } else if([self horizontalAlignment] == 1) {
        double children_total_width = 0;
        for(LayoutBox* child in [[self parent] children]) {
            if([self orientation]) {
                double child_width = [child getWidth:false];
                if(child_width > children_total_width) {
                    children_total_width = child_width;
                }
            } else {
                children_total_width += [child getWidth:false];
            }
        }
        double remaining_margin = [[self parent] getWidth:false]-children_total_width;
        remaining_margin /= 2;
        return remaining_margin;
    }
    return 0;
}

- (double) getVerticalEnd {
    double vertical_position = [self getVerticalPosition];
    double height = [self getHeight:false forScroll:false];
    return vertical_position+height;
}

- (int) getRemainingChildrenCount: (LayoutBox*) element {
    bool found = false;
    int child_count = 0;
    for(LayoutBox* child in [self children]) {
        if(found) {
            child_count++;
        }
        if(child == element) {
            found = true;
        }
    }
    return child_count;
}

- (double) getVerticalPosition {
    if([self calculatedVerticalPosition] == -1) {
        double calculated_value = [self getVerticalPositionSub];
        if(calculated_value != -1) {
            [self setCalculatedVerticalPosition:calculated_value];
        }
        //////////////////////////NSLog/@"calculated height: %f, ", calculated_value);
    }
    return [self calculatedVerticalPosition];
}

- (double) getVerticalPositionSub {
    if([self setRectangle] != nil && [(NSNumber*)[self setRectangle][1] doubleValue] != -1) {
        double rectangle_value = [(NSNumber*)[self setRectangle][1] doubleValue];
        if([self rectangleType] != nil && [(NSNumber*)[self rectangleType][1] boolValue]) {
            rectangle_value /= 100;
            rectangle_value = [[self parent] getHeight:false forScroll:false]*rectangle_value;
        }
        double rectangle_addition_value = [(NSNumber*)[self rectangleAddition][1] doubleValue];
        if([self rectangleAddition] != nil  && rectangle_addition_value != -1) {
            rectangle_value += rectangle_addition_value;
        }
        double rectangle_subtraction_value = [(NSNumber*)[self rectangleSubtraction][1] doubleValue];
        if([self rectangleSubtraction] != nil  && rectangle_subtraction_value != -1) {
            rectangle_value -= rectangle_subtraction_value;
        }
        return rectangle_value;
    }
    if([self display] && [[self parent] orientation]) {
        LayoutBox* previous_element = [[self parent] getPreviousElement:self];
        if(previous_element != nil) {
            double result = [previous_element getVerticalEnd];
            int remaining_children_count = [[self parent] getRemainingChildrenCount:self];
            if([self verticalAlignment] == 1) {
                double parent_height = [[self parent] getHeight:false forScroll:false];
                double remaining_margin = parent_height + result;
                if(remaining_children_count > 0) {
                    double end_addition = 0;
                    int start_offset = [[[self parent] children] count]-remaining_children_count;
                    int index = 0;
                    for(LayoutBox* child in [[self parent] children]) {
                        if(index >= start_offset && [child display]) {
                            end_addition += [child getHeight:false forScroll:false];
                        }
                        index++;
                    }
                    remaining_margin -= 2*end_addition;
                }
                remaining_margin /= 2;
            } else if([self verticalAlignment] == 2) {
                double parent_height = [[self parent] getHeight:false forScroll:false];
                double remaining_margin = parent_height - [self getHeight:false forScroll:false];
                return remaining_margin;
            }
            return result;
        }
    }
    if([self verticalAlignment] == 0) {
        return 0;
    } else if([self verticalAlignment] == 1) {
        double children_total_height = 0;
        for(LayoutBox* child in [[self parent] children]) {
            if([child display]) {
                if([[self parent] orientation]) {
                    children_total_height += [child getHeight:false forScroll:false];
                } else {
                    double child_height = [child getHeight:false forScroll:false];
                    if(child_height > children_total_height) {
                        children_total_height = child_height;
                    }
                }
            }
        }
        double remaining_margin = [[self parent] getHeight:false forScroll:false]-children_total_height;
        remaining_margin /= 2;
        return remaining_margin;
    }
    return 0;
}

- (double) getHeight: (bool) returnSetHeight forScroll: (bool) forScroll {
    if([self calculatedHeight] == -1) {
        double calculated_value = [self getHeightSub:returnSetHeight forScroll:forScroll];
        if(calculated_value != -1) {
            [self setCalculatedHeight:calculated_value];
        }
        //////////////////////////NSLog/@"calculated height: %f, ", calculated_value);
    }
    return [self calculatedHeight];
}

- (double) getHeightSub: (bool) returnSetHeight forScroll: (bool) forScroll {
    //forScroll = !forScroll;
    
    double sub_height = -1;
    sub_height = 0;
    if([self overflow] == 1 && forScroll) {
        for(LayoutBox* child in [self children]) {
            if([child display]) {
                if([self orientation]) {
                    sub_height += [child getHeight:false forScroll:false];
                } else {
                    double child_height = [child getHeight:false forScroll:false];
                    if(child_height > sub_height) {
                        sub_height = child_height;
                    }
                }
            }
        }
        return sub_height;
    }
    //////////////////////////NSLog/@"for scroll: %d", forScroll);
    if([self setRectangle] != nil && [(NSNumber*)[self setRectangle][3] doubleValue] != -1) {
        double rectangle_value = [(NSNumber*)[self setRectangle][3] doubleValue];
        if([self rectangleType] != nil && [(NSNumber*)[self rectangleType][3] boolValue]) {
            rectangle_value /= 100;
            rectangle_value = [[self parent] getHeight:false forScroll:false]*rectangle_value;
        }
        //
        //return ($this->parent->get_height()-$rectangle_value)-$this->get_vertical_position();
        
        double rectangle_result = ([[self parent] getHeight:false forScroll:false]-rectangle_value)-[self getVerticalPosition];
        
        double rectangle_addition_value = [(NSNumber*)[self rectangleAddition][3] doubleValue];
        if([self rectangleAddition] != nil  && rectangle_addition_value != -1) {
            rectangle_result += rectangle_addition_value;
        }
        double rectangle_subtraction_value = [(NSNumber*)[self rectangleSubtraction][3] doubleValue];
        if([self rectangleSubtraction] != nil  && rectangle_subtraction_value != -1) {
            rectangle_result -= rectangle_subtraction_value;
        }
        return rectangle_result;
    }
    double parent_height = -1;
    if(returnSetHeight || forScroll) { // || [self overflow] == 1
        if([self setHeight] != -1) {
            //if([self heightType])
            if([self heightType] == 0) {
                return [self setHeight];
            }
        }
    }
    if([self heightType] == 2) {
        if([[self parent] heightType] == 0) {
            parent_height = [[self parent] getHeight:true forScroll:false];
        } else {
            parent_height = [[self parent] getHeight:false forScroll:false];
        }
        double vertical_position = [self getVerticalPosition];
        return parent_height-vertical_position;
    }
    double set_percent = -1;
    if([self heightType] == 1) {
        parent_height = [[self parent] getHeight:true forScroll:false];
        double percent = ([self setHeight]/100) * parent_height;
        set_percent = percent;
        //////////////////////////NSLog/@"set_percent: %f", set_percent);
        //if(forScroll) {
            return percent;
        //}
        //return percent;
    }
    //double sub_height = -1;
    /*sub_height = 0;
    if([self overflow] != 1) {
        for(LayoutBox* child in [self children]) {
            if([child display]) {
                if([self orientation]) {
                    sub_height += [child getHeight:false forScroll:false];
                } else {
                    double child_height = [child getHeight:false forScroll:false];
                    if(child_height > sub_height) {
                        sub_height = child_height;
                    }
                }
            }
        }
        
    }*/
    //////////////////////////NSLog/@"sub_height: %f", sub_height);
    //////////////////////////NSLog/@"set_percent: %f", set_percent);
    /*if(sub_height > [self setHeight] && [self heightType] == 0 && [self overflow] == 1 && !forScroll) {
        return sub_height;
    }*/
    /*if(sub_height > set_percent && [self heightType] == 1 && [self overflow] == 1 && !forScroll) {
        return sub_height;
    }
    if(set_percent != -1) {
        return set_percent;
    }*/
    return [self setHeight];
}

- (double) getWidth: (bool) return_set_width {
    if([self calculatedWidth] == -1) {
        double calculated_value = [self getWidthSub:return_set_width];
        if(calculated_value != -1) {
            [self setCalculatedWidth:calculated_value];
        }
        //////////////////////////NSLog/@"calculated width: %f, ", calculated_value);
    }
    return [self calculatedWidth];
}

- (double) getWidthSub: (bool) return_set_width {
    if([self setRectangle] != nil && [(NSNumber*)[self setRectangle][2] doubleValue] != -1) {
        double rectangle_value = [(NSNumber*)[self setRectangle][2] doubleValue];
        if([self rectangleType] != nil && [(NSNumber*)[self rectangleType][2] boolValue]) {
            rectangle_value /= 100;
            rectangle_value = [[self parent] getWidth:false]*rectangle_value;
        }
        //return ($this->parent->get_width()-$rectangle_value)-$this->get_horizontal_position();
        double rectangle_result = ([[self parent] getWidth:false]-rectangle_value)-[self getHorizontalPosition];
        double rectangle_addition_value = [(NSNumber*)[self rectangleAddition][2] doubleValue];
        if([self rectangleAddition] != nil  && rectangle_addition_value != -1) {
            rectangle_result += rectangle_addition_value;
        }
        double rectangle_subtraction_value = [(NSNumber*)[self rectangleSubtraction][2] doubleValue];
        if([self rectangleSubtraction] != nil  && rectangle_subtraction_value != -1) {
            rectangle_result -= rectangle_subtraction_value;
        }
        return rectangle_result;
    }
    double parent_width = -1;
    if(return_set_width) {
        if([self setWidth] != -1) {
            if([self widthType] == 1) {
                return [self setWidth];
            }
        }
        return [[self parent] getWidth:true];
    }
    if([self widthType] == 1) {
        if([[self parent] widthType] == 1) {
            parent_width = [[self parent] getWidth:true];
        } else {
            parent_width = [[self parent] getWidth:false];
        }
        double percent = ([self setWidth]/100) * parent_width;
        return percent;
    }
    double sub_width = -1;
    if([self overflow] == -1 && [self setWidth] != -1) {
        return [self setWidth];
    }
    if(sub_width > [self setWidth] && [self overflow] != -1) {
        return sub_width;
    }
    return [self setWidth];
}
/*
         if($this->width_type == '%') {
             $parent_width;
             if($this->parent->width_type == 'px') {
                 $parent_width = $this->parent->get_width(true);
             } else {
                 $parent_width = $this->parent->get_width();
             }
             $percent = ($this->set_width/100) * $parent_width;
             return $percent;
         }
         $sub_width = NULL;
         if($this->overflow == 'hidden' && $this->set_width !== NULL) {
             return $this->set_width;
         }
         if($sub_width > $this->set_width && $this->overflow != 'hidden') {
             return $sub_width;
         }
         return $this->set_width;
     }
 */


@end

/*public $resize_to_child_size = true;
 //public $position = 'relative';
 //public $child_position = 'relative';
 public $set_height = NULL;
 public $set_width = '100';
 public $set_position = NULL;
 public $occupy_next_free_space = true;
 public $direction = 'forward';
 public $orientation = 'vertical';
 public $overflow = 'none';
 public $height_type = 'px';
 public $width_type = '%';
 public $display = 'unset';
 public $id = NULL;
 public $horizontal_alignment = 'start';
 public $vertical_alignment = 'start';
 public $set_rectangle = NULL;*/
