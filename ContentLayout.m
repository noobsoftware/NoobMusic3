//
//  ContentLayout.m
//  noobtest
//
//  Created by siggi jokull on 3.12.2022.
//

#import "ContentLayout.h"
#import "LayoutVideoView.h"
#import "PHPLayoutItem.h"
#import <WebKit/WebKit.h>

@implementation ContentLayout

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (CGColorRef) randomColor {
    double r1 = [self randomFloatBetween:0 and:1];
    double r2 = [self randomFloatBetween:0 and:1];
    double r3 = [self randomFloatBetween:0 and:1];
    double r4 = 0.5;//[self randomFloatBetween:0 and:1];
    return CGColorCreateSRGB(r1, r2, r3, r4);
}

- (void) performCopy {
    NSArray* myArray1 = @[@"test123", @"test2"];
    NSError* error;
    NSData* buffer = [NSKeyedArchiver archivedDataWithRootObject: myArray1 requiringSecureCoding:NO error:&error];
    NSArray* myArray2 = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:buffer error:&error];
}

- (void) recalculateLayout: (NSRect) frame {
    //////////////////////////NSLog/@"frame width %f", frame.size.width);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSRect rect = [[[NSApplication sharedApplication] mainWindow] frame];
        rect.origin.x = 0;
        rect.origin.y = 0;
        //////////////////////////NSLog/@" rect: %f, %f", rect.size.width, rect.size.height);
        [[self rootClickView] setFrame:rect];//[[self mainView].superview frame]];
        //[[self rootClickView] wantsLayer];
        [[self rootLayoutBox] recalculateLayout];
    });
}

-(void)transform: (NSMutableArray*) views rects: (NSMutableArray*) rects time: (double) timeValue a:(double) a b:(double) b c:(double) c d:(double) d callbacks: (NSMutableArray*) callbacks {
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
        [context setDuration:1.0f];
        //Animation code
        //Gera switch fyrir JS
        //for loopu fyrir oll element sem animatast
        //[stack_view set]
        //[[[self stackView] animator] setAlphaValue:0];
        int index = 0;
        for(id view_item in views) {
            if([view_item isKindOfClass:[ClickView class]]) {
                ClickView* view = (ClickView*)view_item;
                //[[view animator] setFrame:CGRectMake(250, 250, 300, 300)];
                //NSRect* rect_value = (NSRect*)rects[index];
                //CGRect rect_cg_value = [rect_value cg]
                //[[view animator] setFrame:];
                CGRect* rect_value = (CGRect*)[rects[index] pointerValue];
                [[view animator] setFrame:(*rect_value)];
            }
            index++;
        }
        //[[stack_view layer] setBackgroundColor:CGColorCreateSRGB(1, 1, 0, 0.5)];
        //[stack_view setFrame:CGRectMake(250, 250, 50, 50)];
    } completionHandler:^{
        //Completion Code
        //////////////////////////NSLog/@"Completed");
        for(id block in callbacks) {
            //////////////////////////NSLog/@"!callblock");
            ((void(^)(int))block)(0); //NSEvent *
        }
    }];
    [CATransaction commit];
}

- (void) setFullScreen {
    /*[[self videoViewLayoutBox] setBox:@{
        @"set_rectangle": @[@0, @0, @0, @0],
        @"rectangle_type": @[@0, @0, @0, @0],
        @"display": @0
    }];
    [[self videoViewLayoutBox] recalculateLayout];
    //[self recalculateLayout:CGRectNull];*/
}

- (void) setNonFullScreen {
    //[[[self mainRoot] rootContainer] setFrame:[[self mainView] frame]];
    /*[[self videoViewLayoutBox] setBox:@{
        @"set_rectangle": @[@0, @115, @0, @0],
        @"rectangle_type": @[@0, @0, @0, @0],
        @"display": @0
    }];
    
    [[self videoViewLayoutBox] recalculateLayout];
    
    for(NSObject* layoutChild in [[self videoViewLayoutBox] children]) {
        LayoutBox* layoutBox = (LayoutBox*)layoutChild;
        
        /*[layoutBox setBox:@{
            @"set_rectangle": @[@0, @0, @50, @50],
            @"rectangle_type": @[@0, @0, @1, @1],
            @"display": @0
        }];*/
        //[layoutBox fillView];
    //}
    /*[[self rootLayoutBox] recalculateLayout:true animateTime:2 easingA:0.47 easingB:0.53 easingC:0.31 easingD:0.96 callbacks:@[^(int i) {
        for(NSObject* layoutChild in [[self videoViewLayoutBox] children]) {
            LayoutBox* layoutBox = (LayoutBox*)layoutChild;
            
            [layoutBox fillView];
        }
    }] layoutBoxes:@[[self videoViewLayoutBox]]];*/
    //[self chooseScreens];
    
    
    /*[[self mainRoot] recalculateLayout:true animateTime:2 easingA:0.47 easingB:0.53 easingC:0.31 easingD:0.96 callbacks:@[^(int i){
        
    }] layoutBoxes:@[]];*/
    //[self recalculateLayout:CGRectNull];
    //[self resetVideoViewSizes];
}

- (NSView*) startmedia {
    ClickView* mainContainer = [[ClickView alloc] initWithFrame:[[self mainView] frame]];
    //[self setRootClickView:mainContainer];
    
    /*CALayer* layer = [[CALayer alloc] init];
    [layer setBackgroundColor:[self randomColor]];
    [mainContainer setLayer:layer];*/
    
    [mainContainer setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [[self mainView] addSubview:mainContainer];
    RootLayoutBox* box1 = [[RootLayoutBox alloc] init];
    /**/
    //[box1 setBox:@{}];
    [box1 setIsVideoView:false];
    [box1 setRootContainer:mainContainer];
    [box1 setBox:@{
        @"display": @0
    }];
    
    LayoutBox* videoContainer = [[LayoutBox alloc] init];
    [videoContainer setIsVideoView:false];
    
    [videoContainer setBox:@{
        @"set_rectangle": @[@0, @0, @0, @0],
        @"rectangle_type": @[@0, @0, @0, @0],
        @"display": @0
    }];
    [box1 addChildren:@[videoContainer]];
    
    [self setMainRoot:box1];
    
    /*LayoutBox* box_15 = [[LayoutBox alloc] init];
    [box_15 setBox:@{
        @"set_height": @100,
        @"set_width": @100,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @1,
        @"display": @true
    }];
    
    [box1 addChildren:@[box_15]];*/
    
    
    LayoutBox* box_15 = [[LayoutBox alloc] init];
    [box_15 setBox:@{
        @"set_height": @100,
        @"set_width": @100,
        @"width_type": @0,
        @"height_type": @0,
        @"orientation": @1,
        @"display": @true
    }];
    
    LayoutBox* box_152 = [[LayoutBox alloc] init];
    [box_152 setBox:@{
        @"set_height": @100,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @0,
        @"display": @true,
    }];
    //[box_15 addChildren:@[box_152]];
    
    [videoContainer addChildren:@[box_15, box_152]];
    
    [self setRootLayoutBox:box1];
    ClickView* add = (ClickView*)[box1 make:true isRootCall:true];
    [self setRootClickView:[box1 mainView]];
    [mainContainer addSubview:add];
    //[self setVideoViewClickView:add];
    //[self setVideoViewLayoutBox:videoContainer];
    
    //test
    
    /*
    LayoutBox* box_1523 = [[LayoutBox alloc] init];
    [box_1523 setBox:@{
        @"set_height": @100,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @0,
        @"display": @true
    }];
    
    LayoutBox* box_1524 = [[LayoutBox alloc] init];
    [box_1524 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @0,
        //@"set_overflow": @1,
        @"display": @true,
        //@"string_content": @"test 123 test 123test 123 test 123test 123 test 123test 123 test 123"
    }];
    
    LayoutBox* recttest11 = [[LayoutBox alloc] init];
    [recttest11 setBox:@{
        @"set_rectangle": @[@20, @20, @50, @20],
        @"rectangle_type": @[@0, @0, @1, @0],
        @"display": @true,
    }];
    [box_1524 addChildren:@[recttest11]];
    
    LayoutBox* box_15234 = [[LayoutBox alloc] init];
    [box_15234 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @0,
        @"display": @true,
        @"overflow": @1
    }];
    [box_1523 addChildren:@[box_1524, box_15234]];
    
    [box_15 addChildren:@[box_152, box_1523]];
    int counter = 0;
    while(counter < 2500) {
        LayoutBox* add_box = [[LayoutBox alloc] init];
        [add_box setBox:@{
           // @"set_rectangle": @[@20, @50, @-1, @50],
           // @"rectangle_type": @[@1, @1, @0, @1],
            @"set_height": @40,
            @"height_type": @0,
            @"set_width": @100,
            @"width_type": @1,
            @"display": @true
        }];
        [box_15234 addChildren:@[add_box]];
        counter++;
    }
    
    LayoutBox* box2 = [[LayoutBox alloc] init];
    [box2 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @1,
        @"display": @true
    }];
    LayoutBox* box3 = [[LayoutBox alloc] init];
    [box3 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"overflow": @1,
        @"display": @true
    }];
    [box_152 addChildren:@[box2, box3]];
    
    
    
    LayoutBox* box22 = [[LayoutBox alloc] init];
    [box22 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"display": @true,
        //@"overflow": @1,
    }];
    LayoutBox* box32 = [[LayoutBox alloc] init];
    [box32 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"display": @true
    }];
    [box2 addChildren:@[box22, box32]];
    
    
    LayoutBox* box323 = [[LayoutBox alloc] init];
    [box323 setBox:@{
       // @"set_rectangle": @[@20, @50, @-1, @50],
       // @"rectangle_type": @[@1, @1, @0, @1],
        @"set_height": @40,
        @"height_type": @1,
        @"set_width": @50,
        @"width_type": @1,
        @"display": @true
    }];
    LayoutBox* box3234 = [[LayoutBox alloc] init];
    [box3234 setBox:@{
        //@"set_rectangle": @[@20, @50, @-1, @50],
        //@"rectangle_type": @[@1, @1, @0, @1],
        @"set_height": @30,
        @"height_type": @1,
        @"set_width": @50,
        @"width_type": @1,
        @"display": @true
    }];
    
    
    
    LayoutBox* box3235 = [[LayoutBox alloc] init];
    [box3235 setBox:@{
        //@"set_rectangle": @[@20, @50, @-1, @50],
        //@"rectangle_type": @[@1, @1, @0, @1],
        @"set_height": @50,
        @"height_type": @1,
        @"set_width": @50,
        @"width_type": @1,
        @"display": @true
    }];
    [box3 addChildren:@[box323, box3234, box3235]];*/
    //endtest
    //[self recalculateLayout:CGRectNull];
    /*LayoutBox* videoViewTest = [[LayoutBox alloc] init];
    //LayoutVideoView* videoView = [[LayoutVideoView alloc] init];
    //[videoViewTest setMainView:videoView];
    */
    return [box1 mainView];
}

- (void) addVideoViewLayout: (LayoutBox*) videoViewLayout {
    [videoViewLayout setBox:@{
        /*@"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @1,
        @"display": @true*/
        
        @"set_rectangle": @[@0, @0, @0, @0],
        @"rectangle_type": @[@0, @0, @0, @0],
        @"display": @0
    }];
    [videoViewLayout setContentLayout:self];
    [[self videoViewLayoutBox] addChildren:@[videoViewLayout]];
    NSView* __block addition;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_main_queue(), ^(void){
        addition = [videoViewLayout make:false isRootCall:true];
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    [[self videoViewClickView] addSubview:addition];
    //////////////////////NSLog/@"addition kindof: %@", [addition class]);
    //[self recalculateLayout:]
    ////////////////////////NSLog/@"recalculate layout frame: %@", [[self mainView] frame]);
    [self recalculateLayout:CGRectNull];
}

- (void) removeChild: (LayoutBox*) videoViewLayout {
    [[self videoViewLayoutBox] removeChild:videoViewLayout];
}

- (double) chooseScreens {
    long count = [[[self videoViewLayoutBox] children] count];
    double root = ceil(sqrt((double)count));
    int index = 0;
    int vertical_index = 0;
    if(root < 2) {
        root = 2;
    }
    double value = 1/root;
    //////////////////NSLog/@"value : %f", value);
    for(NSObject* layoutChild in [[self videoViewLayoutBox] children]) {
        LayoutBox* layoutBox = (LayoutBox*)layoutChild;
        [layoutBox setBox:@{
            /*@"set_rectangle": @[
                @(index*value),
                @(vertical_index*value),
                @((index+1)*value),
                @((vertical_index+1)*value)
            ]*/
            
            @"set_rectangle": @[
                @(index*value*100),
                @(vertical_index*value*100),
                @((root-(index+1))*value*100),
                @((root-(vertical_index+1))*value*100),
            ],
            @"rectangle_type": @[@1, @1, @1, @1],
        }];
        [[layoutBox mainView] setAlphaValue:1];
        /*//////////////////NSLog/@"set rectangle %@",  @[
            @(index*value*100),
            @(vertical_index*value*100),
            @((root-(index+1))*value*100),
            @((root-(vertical_index+1))*value*100),
        ]);*/
        index++;
        if(index == root) {
            index = 0;
            vertical_index++;
        }
    }
    //////////////////NSLog/@"child count: %lu", [[[self videoViewLayoutBox] children] count]);
    //0.47, 0.53, 0.31, 0.96
    /*[[self mainView] sortSubviewsUsingFunction:(NSComparisonResult(*)(NSView*, NSView*, void*))(^(NSView* view1, NSView* view2, void* context) {
        
    }) context:nil]*/
    //(NSComparisonResult(^)(NSView*, NSView*, void*))
    /*NSComparator compareStuff = ^(id obj1, id obj2) {
       return NSOrderedSame;
    };*/
    
    /*NSComparator block_sort = ^(id obj1, id obj2) {
        return NSOrderedSame;
    };*/
    ////////////////////NSLog/@"subViews: %@", [[self mainView] subviews]);
    NSArray* result = [[[self mainView] subviews] sortedArrayUsingComparator:^(id view1, id view2) {
        NSView* view_a = (NSView*)view1;
        NSView* view_b = (NSView*)view2;
        //////////////////NSLog/@"view_a %@ - %@", view_a, view_b);
        if([view_a isKindOfClass:[WKWebView class]]) {
            return NSOrderedAscending;
        }/* else {
            return NSOrderedAscending;
        }*/
        /*if([view_a isKindOfClass:[WKWebView class]]) {
            return NSOrderedDescending;
        } else {*/
            return NSOrderedDescending;
        /*}
        return (NSComparisonResult)NSOrderedSame;*/
    }];
    [[self mainView] setSubviews:result];
    ////////////////////NSLog/@"subViews: %@", [[self mainView] subviews]);
    //[[self mainView] sortSubviewsUsingFunction:block_sort context:nil];
    [[self rootLayoutBox] recalculateLayout:true animateTime:2 easingA:0.47 easingB:0.53 easingC:0.31 easingD:0.96 callbacks:@[] layoutBoxes:@[[self videoViewLayoutBox]]];
    return root;
}

- (void) resetVideoViewSizes {
    for(LayoutBox* child in [[self videoViewLayoutBox] children]) {
        [child setBox:@{
            @"set_rectangle": @[
                @(0),
                @(0),
                @(0),
                @(0),
            ],
            @"rectangle_type": @[@0, @0, @0, @0],
        }];
    }
    [[self videoViewLayoutBox] recalculateLayout];
}

- (void) chooseScreensAlt: (LayoutBox*) layoutBox {
    long count = [[[self videoViewLayoutBox] children] count]-1;
    double value = 1/(double)count;
    //////////////////NSLog/@"value count: %f - %lu", value, count);
    double height = 100*value;
    if(height > 20) {
        height = 20;
    }
    double top = 100-height;
    long index = 0;
    long vertical_index = 0;
    //////////////////NSLog/@"height: %f - %f", height, top);
    [layoutBox setBox:@{
        @"set_rectangle": @[
            @(0),
            @(0),
            @(0),
            @(height),
        ],
        @"rectangle_type": @[@1, @1, @1, @1],
    }];
    for(LayoutBox* layoutChild in [[self videoViewLayoutBox] children]) {
        if(layoutChild != layoutBox) {
            [layoutChild setBox:@{
                @"set_rectangle": @[
                    @(index*value*100),
                    @(top),
                    @((count-(index+1))*value*100),
                    @(0),
                ],
                @"rectangle_type": @[@1, @1, @1, @1],
            }];
            [[layoutChild mainView] setAlphaValue:1];
            index++;
        }
    }
    NSArray* result = [[[self mainView] subviews] sortedArrayUsingComparator:^(id view1, id view2) {
        NSView* view_a = (NSView*)view1;
        NSView* view_b = (NSView*)view2;
        //////////////////NSLog/@"view_a %@ - %@", view_a, view_b);
        if([view_a isKindOfClass:[WKWebView class]]) {
            return NSOrderedAscending;
        }/* else {
            return NSOrderedAscending;
        }*/
        /*if([view_a isKindOfClass:[WKWebView class]]) {
            return NSOrderedDescending;
        } else {*/
            return NSOrderedDescending;
        /*}
        return (NSComparisonResult)NSOrderedSame;*/
    }];
    [[self mainView] setSubviews:result];
    //////////////////NSLog/@"subViews: %@", [[self mainView] subviews]);
    //[[self mainView] sortSubviewsUsingFunction:block_sort context:nil];
    //0.47, 0.53, 0.31, 0.96
    [[self rootLayoutBox] recalculateLayout:true animateTime:2 easingA:0.47 easingB:0.53 easingC:0.31 easingD:0.96 callbacks:@[] layoutBoxes:@[[self videoViewLayoutBox]]];
}

- (void) setWebViewAbove {
    NSArray* result = [[[self mainView] subviews] sortedArrayUsingComparator:^(id view1, id view2) {
        NSView* view_a = (NSView*)view1;
        NSView* view_b = (NSView*)view2;
        //////////////////NSLog/@"view_a %@ - %@", view_a, view_b);
        if([view_a isKindOfClass:[WKWebView class]]) {
            return NSOrderedDescending;
        }/* else {
            return NSOrderedAscending;
        }*/
        return NSOrderedAscending;
        /*if([view_a isKindOfClass:[WKWebView class]]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;*/
    }];
    NSMutableArray* subViews = [[NSMutableArray alloc] initWithArray:result];
    [[[[[self interpretation] mainLayoutItem] layoutBox] mainView] removeFromSuperview];
    [subViews addObject:[[[[self interpretation] mainLayoutItem] layoutBox] mainView]];
    /*NSUInteger index = [subViews indexOfObject:[[[[self interpretation] mainLayoutItem] layoutBox] mainView]];
    NSLog(@"index : %@", @(index));
    NSUInteger index2 = [subViews indexOfObject:[[[[[self interpretation] mainLayoutItem] layoutBox] mainView] superview]];
    NSLog(@"index2 : %@", @(index2));
    index2 = [subViews indexOfObject:[[[[[[self interpretation] mainLayoutItem] layoutBox] mainView] superview] superview]];
    NSLog(@"index2 : %@", @(index2));*/
    //[subViews removeObject:[[[[[[self interpretation] mainLayoutItem] layoutBox] mainView] superview] superview]];
    //[subViews addObject:[[[[[[self interpretation] mainLayoutItem] layoutBox] mainView] superview] superview]];
    //[subViews removeObject:[[[[self interpretation] mainLayoutItem] layoutBox] mainView]];
    //[subViews addObject:[[[[self interpretation] mainLayoutItem] layoutBox] mainView]];
    //[subViews insertObject:[[[[self interpretation] mainLayoutItem] layoutBox] mainView] atIndex:0];
    //NSLog(@"set subviews : %@", subViews);
    //[subViews addObject:[[self interpretation] mainLayoutItem]];
    //mainInterpretation
    [[self mainView] setSubviews:subViews];
}

- (void) makeLayout: (LayoutBox*) box1 {
    //NSLog(@"make layout : %@", box1);
    if([box1 parent] == nil) {
        ClickView* add = (ClickView*)[box1 make:false isRootCall:true];
        //NSLog(@"add : %@", add);
        [[self rootClickView] addSubview:add];
    } else {
        //[[[box1 parent] mainView] removeFromSuperview];
        ClickView* add = (ClickView*)[box1 make:false isRootCall:true];
        //NSLog(@"add : %@ - %@", add, [[box1 parent] mainView]);
        [[[box1 parent] mainView] addSubview:add];
    }
}

- (NSView*) start {
    ClickView* mainContainer = [[ClickView alloc] initWithFrame:[[self mainView] frame]];
    [self setRootClickView:mainContainer];
    //[mainContainer setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [[self mainView] addSubview:mainContainer];
    
    RootLayoutBox* box1 = [[RootLayoutBox alloc] init];
    /**/
    [box1 setBox:@{}];
    [box1 setRootContainer:mainContainer];
    [box1 setBox:@{
        //@"display": @1
        
        /*@"set_rectangle": @[@20, @20, @50, @20],
        @"rectangle_type": @[@0, @0, @1, @0],*/
        @"display": @1,
    }];
    
    [self setWindowContainer:box1];
    [box1 setContentLayout:self];
    
    ////////////////////////NSLog/@"width: %f", [mainContainer frame].size.width);
    
    /*LayoutBox* box_15 = [[LayoutBox alloc] init];
    [box_15 setBox:@{
        
        @"set_rectangle": @[@20, @20, @50, @20],
        @"rectangle_type": @[@0, @0, @1, @0],
        @"display": @1,
    }];
    
    [box1 addChildren:@[box_15]];
    
    LayoutBox* box_width_1 = [[LayoutBox alloc] init];
    [box_width_1 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @1,
        @"display": @true
    }];
    
    
    LayoutBox* box_width_2 = [[LayoutBox alloc] init];
    [box_width_2 setBox:@{
        @"set_height": @40,
        @"set_width": @40,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @1,
        @"display": @true
    }];
    
    [box_15 addChildren:@[box_width_1, box_width_2]];*/
    
    /*LayoutBox* box_152 = [[LayoutBox alloc] init];
    [box_152 setBox:@{
        @"set_height": @100,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @0,
        @"display": @true,
    }];
    LayoutBox* box_1523 = [[LayoutBox alloc] init];
    [box_1523 setBox:@{
        @"set_height": @100,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @0,
        @"display": @true
    }];
    
    LayoutBox* box_1524 = [[LayoutBox alloc] init];
    [box_1524 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @0,
        //@"set_overflow": @1,
        @"display": @true,
        //@"string_content": @"test 123 test 123test 123 test 123test 123 test 123test 123 test 123"
    }];
    
    LayoutBox* recttest11 = [[LayoutBox alloc] init];
    [recttest11 setBox:@{
        @"set_rectangle": @[@20, @20, @50, @20],
        @"rectangle_type": @[@0, @0, @1, @0],
        @"display": @true,
    }];
    [box_1524 addChildren:@[recttest11]];
    
    LayoutBox* box_15234 = [[LayoutBox alloc] init];
    [box_15234 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @0,
        @"display": @true,
        @"overflow": @1
    }];
    [box_1523 addChildren:@[box_1524, box_15234]];
    
    [box_15 addChildren:@[box_152, box_1523]];*/
    /*int counter = 0;
    while(counter < 2500) {
        LayoutBox* add_box = [[LayoutBox alloc] init];
        [add_box setBox:@{
           // @"set_rectangle": @[@20, @50, @-1, @50],
           // @"rectangle_type": @[@1, @1, @0, @1],
            @"set_height": @40,
            @"height_type": @0,
            @"set_width": @100,
            @"width_type": @1,
            @"display": @true
        }];
        [box_15234 addChildren:@[add_box]];
        counter++;
    }
    
    LayoutBox* box2 = [[LayoutBox alloc] init];
    [box2 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @1,
        @"display": @true
    }];
    LayoutBox* box3 = [[LayoutBox alloc] init];
    [box3 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"overflow": @1,
        @"display": @true
    }];
    [box_152 addChildren:@[box2, box3]];
    
    
    
    LayoutBox* box22 = [[LayoutBox alloc] init];
    [box22 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"display": @true,
        //@"overflow": @1,
    }];
    LayoutBox* box32 = [[LayoutBox alloc] init];
    [box32 setBox:@{
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"display": @true
    }];
    [box2 addChildren:@[box22, box32]];
    
    
    LayoutBox* box323 = [[LayoutBox alloc] init];
    [box323 setBox:@{
       // @"set_rectangle": @[@20, @50, @-1, @50],
       // @"rectangle_type": @[@1, @1, @0, @1],
        @"set_height": @40,
        @"height_type": @1,
        @"set_width": @50,
        @"width_type": @1,
        @"display": @true
    }];
    LayoutBox* box3234 = [[LayoutBox alloc] init];
    [box3234 setBox:@{
        //@"set_rectangle": @[@20, @50, @-1, @50],
        //@"rectangle_type": @[@1, @1, @0, @1],
        @"set_height": @30,
        @"height_type": @1,
        @"set_width": @50,
        @"width_type": @1,
        @"display": @true
    }];
    
    
    
    LayoutBox* box3235 = [[LayoutBox alloc] init];
    [box3235 setBox:@{
        //@"set_rectangle": @[@20, @50, @-1, @50],
        //@"rectangle_type": @[@1, @1, @0, @1],
        @"set_height": @50,
        @"height_type": @1,
        @"set_width": @50,
        @"width_type": @1,
        @"display": @true
    }];
    [box3 addChildren:@[box323, box3234, box3235]];*/
    /*'set_rectangle' => [
     '20',
     '50',
     NULL,
     //'20',
     '10'
 ],
 'rectangle_type' => [
     '%',
     'px',
     'px',
     'px',
 ],
 'set_width' => '50',
 'width_type' => '%',*/
    [self setRootLayoutBox:box1];
    ClickView* add = (ClickView*)[box1 make:false isRootCall:true];
    [mainContainer addSubview:add];
    
    /*NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.7
                                                      target:[NSBlockOperation blockOperationWithBlock:^{
        //[self transform:@[sidebar, sidebar2]];
        [box22 setBox:@{
            @"set_height": @10,
            @"set_width": @50,
            @"width_type": @1,
            @"height_type": @1,
            @"display": @true,
            //@"overflow": @1,
        }];
        //cubic-bezier(.59,.17,.5,.91)
        //[box1 recalculateLayout];
        
        [
            box22
            //[self rootLayoutBox]
            recalculateLayout:true animateTime:2 easingA:0.59 easingB:0.17 easingC:0.5 easingD:0.91 callbacks:@[] layoutBoxes:@[box22]];
        }]
          selector:@selector(main)
          userInfo:nil
          repeats:NO
    ];*/
    
    /*NSTimer *timer2 = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                      target:[NSBlockOperation blockOperationWithBlock:^{
        //[self transform:@[sidebar, sidebar2]];
        [box_15 setBox:@{
            
            @"set_rectangle": @[@10, @10, @10, @10],
            @"rectangle_type": @[@0, @0, @1, @0],
            @"display": @1,
            //@"overflow": @1,
        }];
        //cubic-bezier(.59,.17,.5,.91)
        //[box1 recalculateLayout];
        
        [
            //box_15
            [self rootLayoutBox]
            recalculateLayout:true animateTime:2 easingA:0.59 easingB:0.17 easingC:0.5 easingD:0.91 callbacks:@[] layoutBoxes:@[box_15]];
        
            //[box1 recalculateLayout];
        }]
          selector:@selector(main)
          userInfo:nil
          repeats:NO
    ];*/
    
    return add;
    //TableView* tableView = [[TableView alloc] init];
    
    /*[self setTableView:[[TableView alloc] init]];
    NSScrollView* table_scroll = [[self tableView] getTableView:CGRectMake(0, 0, 200, 500)];
    [mainContainer addSubview:table_scroll];
    [[self tableView] getTest:1];
    [[self tableView] reload];*/
    
    /*NSView* document_view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 200, 1000)];
    CALayer* layer = [[CALayer alloc] init];
    [document_view setLayer:layer];
    
    ScrollView* scroll_view = [[ScrollView alloc] initWithFrame:NSMakeRect(0, 0, 200, 400)];
    [scroll_view setDocumentView:document_view];
    [scroll_view setAutohidesScrollers:false];
    [scroll_view setRulersVisible:true];
    [scroll_view setHasVerticalScroller:true];
    [[scroll_view contentView] scrollToPoint:NSMakePoint(0, 0)];
    //[scroll_view setScrollerStyle:NSScrollerStyleOverlay];
    //[scroll_view setAppearance:NSAppearanceNameDarkAqua];
    //[scroll_view scroll]
    [mainContainer addSubview:scroll_view];
    
    NSTextField* label = [[NSTextField alloc] initWithFrame:[document_view frame]];
    [label setStringValue:@"test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123"];
    [label setEditable:false];
    [label setUsesSingleLineMode:false];
    //[label setBackgroundColor:[NSColor whiteColor]];
    //[label setLineBreakStrategy:NSLineBreakStrategyStandard];
    //[label setDir:NSLineMovesDown];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    //[label setMaximumNumberOfLines:5];
    [[label cell] setTruncatesLastVisibleLine:true];
    //[label]
    [document_view addSubview:label];*/
    
    //set root container
    
    /*    'set_height' => '600',
         'set_width' => '950',
         'width_type' => 'px',
         'height_type' => 'px',
         'display' => 'block'
     ],*/
}


- (NSView*) startDepr2 {
    ClickView* mainContainer = [[ClickView alloc] initWithFrame:[[self mainView] frame]];
    //[self setRootClickView:mainContainer];
    
    /*CALayer* layer = [[CALayer alloc] init];
    [layer setBackgroundColor:[self randomColor]];
    [mainContainer setLayer:layer];*/
    
    [mainContainer setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [[self mainView] addSubview:mainContainer];
    RootLayoutBox* box1 = [[RootLayoutBox alloc] init];
    /**/
    //[box1 setBox:@{}];
    [box1 setIsVideoView:false];
    [box1 setRootContainer:mainContainer];
    [box1 setBox:@{
        @"display": @1
    }];
    /*[box1 setBox:@{
        @"set_rectangle": @[@0, @0, @0, @0],
        @"rectangle_type": @[@0, @0, @0, @0],
        @"display": @0
    }];*/
    //[self setWindowContainer:box1];
    
    
    LayoutBox* videoContainer = [[LayoutBox alloc] init];
    [videoContainer setIsVideoView:false];
    [videoContainer setIsReverse:true];
    
    [videoContainer setBox:@{
        @"set_rectangle": @[@0, @0, @0, @0],
        @"rectangle_type": @[@0, @0, @0, @0],
        @"display": @0
    }];
    
    
    
    LayoutBox* extrasContainer = [[LayoutBox alloc] init];
    [extrasContainer setIsVideoView:false];
    //[extrasContainer setPreventReverse:true];
    
    
    [extrasContainer setBox:@{
        @"set_rectangle": @[@0, @0, @0, @0],
        @"rectangle_type": @[@0, @0, @0, @0],
        @"display": @0
    }];
    
    [box1 addChildren:@[videoContainer,
                        extrasContainer
                      ]];
    [box1 setContentLayout:self];
    [self setMainRoot:box1];
    
    
    
    [self setWindowContainer:extrasContainer];
    [extrasContainer setContentLayout:self];
    /*LayoutBox* box_15 = [[LayoutBox alloc] init];
    [box_15 setBox:@{
        @"set_height": @100,
        @"set_width": @100,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @1,
        @"display": @true
    }];
    
    [box1 addChildren:@[box_15]];*/
    
    [self setRootLayoutBox:box1];
    ClickView* add = (ClickView*)[box1 make:false isRootCall:true];
    //[self setWindowContainer:[box1 lastSetChildRoot]];
    
    [self setRootClickView:[box1 mainView]];
    [mainContainer addSubview:add];
    [self setVideoViewClickView:add];
    [self setVideoViewLayoutBox:videoContainer];
    //[self recalculateLayout:CGRectNull];
    /*LayoutBox* videoViewTest = [[LayoutBox alloc] init];
    //LayoutVideoView* videoView = [[LayoutVideoView alloc] init];
    //[videoViewTest setMainView:videoView];
    */
    return [box1 mainView];
}

- (NSView*) start_alt {
    ClickView* mainContainer = [[ClickView alloc] initWithFrame:[[self mainView] frame]];
    [self setRootClickView:mainContainer];
    //[mainContainer setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [[self mainView] addSubview:mainContainer];
    
    RootLayoutBox* box1 = [[RootLayoutBox alloc] init];
    /**/
    [box1 setBox:@{}];
    [box1 setRootContainer:mainContainer];
    [box1 setBox:@{
        //@"display": @1
        
        /*@"set_rectangle": @[@20, @20, @50, @20],
        @"rectangle_type": @[@0, @0, @1, @0],*/
        @"display": @1,
    }];
    
    [self setWindowContainer:box1];
    [box1 setContentLayout:self];
    
    [self setRootLayoutBox:box1];
    ClickView* add = (ClickView*)[box1 make:false isRootCall:true];
    [mainContainer addSubview:add];
    
    return add;
    //TableView* tableView = [[TableView alloc] init];
    
    /*[self setTableView:[[TableView alloc] init]];
    NSScrollView* table_scroll = [[self tableView] getTableView:CGRectMake(0, 0, 200, 500)];
    [mainContainer addSubview:table_scroll];
    [[self tableView] getTest:1];
    [[self tableView] reload];*/
    
    /*NSView* document_view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 200, 1000)];
    CALayer* layer = [[CALayer alloc] init];
    [document_view setLayer:layer];
    
    ScrollView* scroll_view = [[ScrollView alloc] initWithFrame:NSMakeRect(0, 0, 200, 400)];
    [scroll_view setDocumentView:document_view];
    [scroll_view setAutohidesScrollers:false];
    [scroll_view setRulersVisible:true];
    [scroll_view setHasVerticalScroller:true];
    [[scroll_view contentView] scrollToPoint:NSMakePoint(0, 0)];
    //[scroll_view setScrollerStyle:NSScrollerStyleOverlay];
    //[scroll_view setAppearance:NSAppearanceNameDarkAqua];
    //[scroll_view scroll]
    [mainContainer addSubview:scroll_view];
    
    NSTextField* label = [[NSTextField alloc] initWithFrame:[document_view frame]];
    [label setStringValue:@"test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123"];
    [label setEditable:false];
    [label setUsesSingleLineMode:false];
    //[label setBackgroundColor:[NSColor whiteColor]];
    //[label setLineBreakStrategy:NSLineBreakStrategyStandard];
    //[label setDir:NSLineMovesDown];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    //[label setMaximumNumberOfLines:5];
    [[label cell] setTruncatesLastVisibleLine:true];
    //[label]
    [document_view addSubview:label];*/
    
    //set root container
    
    /*    'set_height' => '600',
         'set_width' => '950',
         'width_type' => 'px',
         'height_type' => 'px',
         'display' => 'block'
     ],*/
}

- (void) start_depr2 {
    
    ClickView* sidebar = [[ClickView alloc] initWithFrame:NSMakeRect(0, 0, 250, 100)]; //NSMakeRect(0, 0, 250, 100) //[[self mainView] frame]
    CALayer* layer = [[CALayer alloc] init];
    [sidebar setLayer:layer];
    [layer setBackgroundColor:[self randomColor]];
    
    ClickView* sidebar2 = [[ClickView alloc] initWithFrame:NSMakeRect(250, 250, 50, 100)]; //NSMakeRect(0, 0, 250, 100) //[[self mainView] frame]
    CALayer* layer2 = [[CALayer alloc] init];
    [sidebar2 setLayer:layer2];
    [layer2 setBackgroundColor:[self randomColor]];
    //[sidebar frame].size.height = [self mainView].frame.size.height;
    //sidebar.trailingAnchor =
    //[[sidebar heightAnchor] value
    //[[sidebar trailingAnchor] set
    //[sidebar setAutoresizingMask:NSViewHeightSizable];
    //[sidebar translatesAutoresizingMaskIntoConstraints];
    [[self mainView] addSubview:sidebar];
    [[self mainView] addSubview:sidebar2];
    
    /*NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:26], NSFontAttributeName,[NSColor blackColor], NSForegroundColorAttributeName, nil];

    NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:@"Cat" attributes: attributes];

    NSSize attrSize = [currentText size];
    [currentText drawAtPoint:NSMakePoint(yourX, yourY)];*/
    /*let label = NSTextField()
     label.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
     label.stringValue = "My awesome label"
     label.backgroundColor = .white
     label.isBezeled = false
     label.isEditable = false
     label.sizeToFit()*/
    NSTextField* label = [[NSTextField alloc] initWithFrame:[sidebar frame]];
    [label setStringValue:@"test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123"];
    [label setEditable:false];
    [label setUsesSingleLineMode:false];
    //[label setBackgroundColor:[NSColor whiteColor]];
    //[label setLineBreakStrategy:NSLineBreakStrategyStandard];
    //[label setDir:NSLineMovesDown];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    //[label setMaximumNumberOfLines:5];
    [[label cell] setTruncatesLastVisibleLine:true];
    //[label]
    [sidebar addSubview:label];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                      target:[NSBlockOperation blockOperationWithBlock:^{
        [self transform:@[sidebar, sidebar2]];
        }]
          selector:@selector(main)
          userInfo:nil
          repeats:NO
    ];
    //[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(tranform) userInfo:nil repeats:NO];
    //[[self mainView] addConstraint:[NSLayoutConstraint constraintWithItem:[self mainView] attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:sidebar attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    // align view from the left and right
    /*[self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[sidebar]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sidebar)]];

    // width constraint
    [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sidebar(==250)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sidebar)]];

    // height constraint
    [self.mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sidebar(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sidebar)]];*/
    //[[self mainView] addConstraint:[NSLayoutConstraint constraintWithItem:sidebar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self mainView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    //[[self mainView] addConstraint:[NSLayoutConstraint constraintWithItem:sidebar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self mainView] attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    //[[self mainView] addConstraint:[NSLayoutConstraint constraintWithItem:[self mainView] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:sidebar attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    //[sidebar addConstraint:[NSLayoutConstraint constraintWithItem:sidebar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self mainView] attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0]];
    
    /*NSTextField *textField;
     
    textField = [[NSTextField alloc] init];
    [textField setStringValue:@"My Label"];
    [textField setBezeled:YES];
    [textField setDrawsBackground:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];

    NSTextField *textField2;

    textField2 = [[NSTextField alloc] init]; //initWithFrame:NSMakeRect(10, 10, 200, 17)
    [textField2 setStringValue:@"My Other label"];
    [textField2 setBezeled:YES];
    [textField2 setDrawsBackground:NO];
    [textField2 setEditable:NO];
    [textField2 setSelectable:NO];
    
    ClickView* click_view = [[ClickView alloc] init]; //initWithFrame:NSMakeRect(0, 0, 5, 5)]
    
    CALayer* click_view_layer = [[CALayer alloc] init];
    [click_view_layer setBackgroundColor:CGColorCreateSRGB(0.7, 0.2, 1, 0.3)];
    [click_view setLayer:click_view_layer];
    
    StackLayout* stack_layout = [[StackLayout alloc] initWithFrame:NSMakeRect(0, 0, 200, 200)];
    CALayer* click_view_layer2 = [[CALayer alloc] init];
    [click_view_layer2 setBackgroundColor:CGColorCreateSRGB(0.1, 0.5, 1, 0.3)];
    [stack_layout setLayer:click_view_layer2];
    //[textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[textField2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [stack_layout setAlignment:NSLayoutAttributeCenterX];
    [stack_layout setOrientation:NSUserInterfaceLayoutOrientationHorizontal];
    [stack_layout setDistribution:NSStackViewDistributionEqualSpacing];
    [stack_layout addArrangedSubview:textField];
    [stack_layout addArrangedSubview:textField2];
    [stack_layout addArrangedSubview:click_view];
    [[self mainView] addSubview:stack_layout];*/
    
}

@end
