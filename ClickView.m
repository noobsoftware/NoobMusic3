//
//  ClickView.m
//  noobtest
//
//  Created by siggi on 25.11.2022.
//
#import "ClickView.h"
//#import <Foundation/Foundation.h>
/*for( GenericBlock block in array ){
    block();
}*/

@implementation ClickView

//typedef GenericBlock dispatch_block_t;

/*- (void) addClickEventHandlers:(void(^)(NSEvent *))callback {
    [self setClickEventHandlers:[NSArray arrayWithObject:callback]];
}

//void (^simpleBlock)(void)

- (void) mouseDown:(NSEvent *)event {
    [[self layer] setBackgroundColor:CGColorCreateSRGB(0.1, 0.1, 1, 1)];
    ////////////////////////NSLog/@"mousedown");
    //int count = [[self clickEventHandlers] count];
    //for(int index = 0; index < count; index++) {
        //id callback = [[self clickEventHandlers] objectAtIndex:index];
        //(void(^)(NSEvent *)) *fun;
        
    //}
    for(id block in [self clickEventHandlers]) {
        ////////////////////////NSLog/@"!callblock");
        ((void(^)(NSEvent *))block)(event);
    }
}

- (void) mouseEntered:(NSEvent *)event { //gera callback eda dictionary med style gildum og kalla i til ad restora utlit eftir hover, athuga fyrst hvernig subclassed views eins og label og onnur virka?
    ////////////////////////NSLog/@"entered");
    [[self layer] setBackgroundColor:CGColorCreateSRGB(0.7, 0.5, 1, 1)];
}

- (void) mouseExited:(NSEvent *)event {
    ////////////////////////NSLog/@"exited");
    [[self layer] setBackgroundColor:CGColorCreateSRGB(0.5, 0.3, 0.4, 1)];
}*/

- (BOOL) isFlipped {
    return YES;
}

- (BOOL) acceptsFirstResponder {
    return NO;
}

- (BOOL) canBecomeKeyView {
    return NO;
}

/*- (void) mouseDown:(NSEvent *)event {
    //NSWindow* window = [[NSApplication sharedApplication] windows][0];
    //[window makeFirstResponder:[self web]];
    //////////NSLog(@"makefirst responder");
    //[event respon]
}*/

/*- (BOOL) acceptsTouchEvents {
    false;
}*/

//- (BOOL) accepts

- (WKWebView*) assignWebView: (long) index {
    WKWebViewConfiguration* conf = [[WKWebViewConfiguration alloc] init];
    [conf setValue:@false forKey:@"drawsBackground"];
    [[conf preferences] setValue:@true forKey:@"developerExtrasEnabled"];
    WKUserContentController* userContentController = [[WKUserContentController alloc] init];
    [conf setUserContentController:userContentController];
    
    NSString* evalString = @"window.addEventListener('load', function(e) { console.log('noobstart', e); });";
    
    WKUserScript* script = [[WKUserScript alloc] initWithSource:evalString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:false];
    //mogulega mikilvaget ad nota seperate contentworld!!
    //[[WKUserScript alloc] initWithSource:<#(nonnull NSString *)#> injectionTime:<#(WKUserScriptInjectionTime)#> forMainFrameOnly:<#(BOOL)#> inContentWorld:<#(nonnull WKContentWorld *)#>]
    //[userContentController addUserScript:script];
    
    [userContentController addUserScript:script];
    
    WKWebView* webView = [[WKWebView alloc] initWithFrame:[self bounds] configuration:conf];
    [self addSubview:webView];
    
    [webView setAutoresizingMask:NSViewMaxXMargin|NSViewMaxYMargin|NSViewHeightSizable|NSViewWidthSizable];
    
    [self setViewTimer:[NSTimer scheduledTimerWithTimeInterval:0.5
                                                        target:[NSBlockOperation blockOperationWithBlock:^{
        
        [[webView window] makeFirstResponder:webView];
        //[[self windowValue] makeFirstResponder:[self mainWeb]];
        //[[self mainContentLayout] recalculateLayout:[[self mainContentView] frame]];
    }]
                                                      selector:@selector(main)
                                                      userInfo:nil
                                                       repeats:YES
                       ]];
    //[webView setUIDelegate:<#(id<WKUIDelegate> _Nullable)#>]
    //[[webView webFrame] findFrameNamed:@"test1"]
    //[webView setPageZoom:0.5f];
    //[webView pagezo]
    return webView;
}
@end
