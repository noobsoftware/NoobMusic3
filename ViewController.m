//
//  ViewController.m
//  noobtest
//
//  Created by siggi on 24.11.2022.
//

#import "ViewController.h"

@implementation ViewController

- (CGColorRef) randomColor {
    double r1 = arc4random() / UINT32_MAX;
    double r2 = arc4random() / UINT32_MAX;
    double r3 = arc4random() / UINT32_MAX;
    double r4 = arc4random() / UINT32_MAX;
    return CGColorCreateSRGB(r1, r2, r3, r4);
}


- (void) viewDidLoad {
    //[[[NSApplication sharedApplication] mainWindow] setPreservesContentDuringLiveResize:<#(BOOL)#>
}

- (void) viewDidLoad_depr4 {
    ContentLayout* content_layout = [[ContentLayout alloc] init];
    [[self view] setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [content_layout setMainView:[self view]];
    [content_layout start];
}

- (void)viewDidLoad_depr3 {
    ////////////////////////NSLog/@"view did load");
    NSWindow* window = [[NSApplication sharedApplication] windows][0];
    ////////////////////////NSLog/@"count: %lu", [[[window contentView] subviews] count]);
    [self setMainView:[[window contentView] subviews][0]];
    //[self set_window:@"Noob TV"];
    
    NSTextField *textField;
     
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
    [[self mainView] addSubview:stack_layout];
    
    [super viewDidLoad];
    
}

- (void)viewDidLoad_depr2 {
    //JSParse* js_parse = [JSParse alloc];
    //[js_parse test];
    [self set_window:@"Noob TV"];
    
   [super viewDidLoad];
    return;
    //PHPScriptManager* script_manager = [PHPScriptManager alloc];
    //[script_manager run:@"$array = [1, 2, 3];"];
    NSTextField *textField;
     
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
    
    StackLayout* stack_layout = [[StackLayout alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
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
    [[self view] addSubview:stack_layout];
    /*[stack_layout addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[textField][textField2(==textField)]|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:@{
        @"textField": textField,
        @"textField2": textField2
    }]];*/
    /*let horizontalConstraint = NSLayoutConstraint(
     item: newView,
     attribute: NSLayoutAttribute.centerX,
     relatedBy: NSLayoutRelation.equal,
     toItem: view,
     attribute: NSLayoutAttribute.centerX,
     multiplier: 1.0,
     constant: 0
 )

 view.addConstraints([horizontalConstraint])*/
    //NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:click_view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[self view] attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    /*NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[textField]-|" options:NSLayoutFormatAlignAllTop metrics:nil views:@{
        @"textField": textField,
        @"textField2": textField2
    }];
    [NSLayoutConstraint activateConstraints:constraints];
    //NSTextView* text_view = [[NSTextView alloc] labelWith];
    //NSTextContainer* text_container = [[NSTextContainer alloc] init];
    //[text_view setTextContainer:text_container];
    //[text_container setLineBreakMode:NSLineBreakByTruncatingTail];
    //[text_view insertText:@"test 123" replacementRange:NSMakeRange(0, 8)];
    //[text_view setRichText:<#(BOOL)#>]
    /*
     [UIView animateWithDuration:5
     animations:^{
     self._addBannerDistanceFromBottomConstraint.constant = -32;
     [self.view layoutIfNeeded]; // Called on parent view
     }];*/
    //NSText
    
    
    //NSStackView* stack_view = [[NSStackView alloc] init];
    
    
    /*CALayer* layer = [[CALayer alloc] init];
     [stack_view setLayer:layer];
     [layer setBackgroundColor:CGColorCreateSRGB(0.5, 0.5, 1, 1)];*/
    
    //[stack_view addArrangedSubview:textField];
    //[stack_view addArrangedSubview:textField2];
    //[stack_view addSubview:textField];
    //[stack_view addSubview:textField2];
    //[window dele]
    //[window setAlphaValue:0.5];
    //[[self view] view]
    
    //[window dele]
    //[window did]
    //[[self view] setFrame:[window frame]];
    //ClickView* stack_view  = [[ClickView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    CALayer* layer = [[CALayer alloc] init];
    [layer setBackgroundColor:CGColorCreateSRGB(0.5, 0.5, 1, 0.5)];
    //[[self view] setLayer:layer];
    
    CGRect frame = [[self view] frame];
    ////////////////////////NSLog/@"CGRect");
    ////////////////////////NSLog/@"%f", frame.origin.x);
    ////////////////////////NSLog/@"%f", frame.origin.y);
    ////////////////////////NSLog/@"%f", frame.size.width);
    ////////////////////////NSLog/@"%f", frame.size.height);
    
    /*ClickView* layout_main_view = [[ClickView alloc] initWithFrame:CGRectMake(0, 0, 900, 900)];//[[self view] frame]]
    CALayer* layer2 = [[CALayer alloc] init];
    [layer2 setBackgroundColor:CGColorCreateSRGB(1, 0, 0, 0.5)];
    [layout_main_view setLayer:layer2];
    [layout_main_view addSubview:stack_view];*/
    //[stack_view ]
    //[stack_view anim]
    //[[self view] layoutSubtreeIfNeeded];
    //[[self view] addSubview:layout_main_view];
    //[self setStackView:stack_view];
    [[self view] needsLayout];
    /*NSLayoutConstraint* constraint_a = [[stack_view leadingAnchor] constraintEqualToAnchor:[[[self view] layoutMarginsGuide] leadingAnchor]];
     NSLayoutConstraint* constraint_b = [[stack_view trailingAnchor] constraintEqualToAnchor:[[[self view] layoutMarginsGuide] trailingAnchor]];
     [constraint_a setActive:true];
     [constraint_b setActive:true];*/
    /*NSString *string = @"my_string";
     
     NSError *error = NULL;
     NSRegularExpression *regex =
     [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9_]+"
     options:0
     error:&error];
     // Check error here... (maybe the regex pattern was malformed)
     
     NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
     options:0
     range:NSMakeRange(0, [string length])]; // Check full string
     
     if (numberOfMatches > 0) {
     // You have at least one match ...
     ////////////////////////NSLog/@"number of matches: %lu", numberOfMatches);
     }*/
    //o
    
}

- (void) viewWillTransitionToSize:(NSSize)newSize {
    CGRect frame = [[self view] frame];
    ////////////////////////NSLog/@"CGRect");
    ////////////////////////NSLog/@"%f", frame.origin.x);
    ////////////////////////NSLog/@"%f", frame.origin.y);
    ////////////////////////NSLog/@"%f", frame.size.width);
    ////////////////////////NSLog/@"%f", frame.size.height);
}

-(void)tranform {
    /*let duration = 2.0

    CATransaction.begin()
    CATransaction.setAnimationDuration(duration)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.8, 0.0, 0.2, 1.0))
    CATransaction.setCompletionBlock {
        print("animation finished")
    }*/
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    CAMediaTimingFunction* custom = [[CAMediaTimingFunction alloc] initWithControlPoints:0.79 :0.25 :0 :0.93];
    [CATransaction setAnimationTimingFunction:custom];

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration:1.0f];
        //Animation code
        //Gera switch fyrir JS
        //for loopu fyrir oll element sem animatast
        //[stack_view set]
        //[[[self stackView] animator] setAlphaValue:0];
        [[[self stackView] animator] setFrame:CGRectMake(250, 250, 300, 300)];
        //[[stack_view layer] setBackgroundColor:CGColorCreateSRGB(1, 1, 0, 0.5)];
        //[stack_view setFrame:CGRectMake(250, 250, 50, 50)];
    } completionHandler:^{
        //Completion Code
        ////////////////////////NSLog/@"Completed");
    }];
    [CATransaction commit];
}



- (void) set_window:(NSString*) title {
    NSWindow* window = [[NSApplication sharedApplication] mainWindow];
    //for(NSWindow *window in [[NSApplication sharedApplication] windows]) {
    [window setTitlebarAppearsTransparent:true];
    [window setTitleVisibility:false];
    [window setTitle:title];
    //[window setBackingType:NSBackingStoreBuffered];
    NSVisualEffectView *visual_view = [[NSVisualEffectView alloc] initWithFrame:[[self view] frame]];
    //NSView *app_view = [window contentView];
    //[app_view removeFromSuperview];
    //NSWindowStyle.Closable | NSWindowStyle.Titled | NSWindowStyle.Miniaturizable | NSWindowStyle.Resizable
    [window setStyleMask:NSWindowStyleMaskFullSizeContentView|NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskResizable];
    //[window setBackgroundColor:[NSColor colorWithSRGBRed:0.0f green:(CGFloat)0.0f blue:(CGFloat)0.0f alpha:(CGFloat)0.0f]];
    //[window setContentView:visual_view];
    //
    [window center];
    [visual_view setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    //[visual_view setMaterial:NSVisualEffectMaterialSidebar];
    [visual_view setMaterial:NSVisualEffectMaterialPopover];
    [visual_view setBlendingMode:NSVisualEffectBlendingModeBehindWindow];
    [visual_view setState:NSVisualEffectStateActive];
    [[self view] addSubview:visual_view ]; //[window contentView] positioned:-1 relativeTo:nil
    //[[self view]]
    [self setMainView:visual_view];
    //[visual_view setFrame:[[window contentView] frame]];
    //
    //[[window contentView] addSubview:visual_view]; //positioned:-1 relativeTo:nil
    //[visual_view setBackgroundColor:[NSColor colorWithSRGBRed:0.0f green:(CGFloat)0.0f blue:(CGFloat)0.0f alpha:(CGFloat)0.0f]];
    //}
    /*let contentView = ContentView()
     .edgesIgnoringSafeArea(.top) // to extend entire content under titlebar

 // Create the window and set the content view.
 window = NSWindow(
     contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
     styleMask: [.titled, .closable, .miniaturizable, .texturedBackground, .resizable, .fullSizeContentView],
     backing: .buffered, defer: false)
 window.center()
 window.setFrameAutosaveName("Main Window")

 window.titlebarAppearsTransparent = true // as stated
 window.titleVisibility = .hidden         // no title - all in content

 window.contentView = NSHostingView(rootView: contentView)
 window.makeKeyAndOrderFront(nil)*/
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
