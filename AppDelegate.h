//
//  AppDelegate.h
//  noobtest
//
//  Created by siggi on 24.11.2022.
//

#import <Cocoa/Cocoa.h>
#import "ContentLayout.h"
#import "MainVisual.h"
#import <WebKit/WebKit.h>
#import "WKMessages.h"
#import "DBConnection.h"
#import <VLCKit/VLCKit.h>
//#import "TabMed"
@class PHPInterpretation;
@class PHPData;
@class PHPMedia;
@class PHPDataWrap;
@class VideoOperations;
@class TabMediaMirror;
@class TabMedia;
@class MediaTab;
@class AdditionalWindowDelegate;
@class PHPIncludedObjects;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, WKNavigationDelegate>
@property(nonatomic) NSTimer* viewTimer;
@property(nonatomic) WKMessages* wkMessages;
@property(nonatomic) MainVisual* mainContentView;
@property(nonatomic) ContentLayout* mainContentLayout;
@property(nonatomic) int timeoutCount;
@property(nonatomic) WKWebView* mainWeb;
@property(nonatomic) PHPInterpretation* mainInterpretation;
@property(nonatomic) JSParse* js_parse;
@property(nonatomic) AdditionalWindowDelegate* additionalWindowDelegate;
@property(nonatomic) bool additionalWindowActive;
@property(nonatomic) NSTimer* additionalWindowTimer;
@property(nonatomic) NSString* interleavedIndex;
@property(nonatomic) dispatch_queue_t messagesQueue;
- (void) additionalWindowWillClose: (NSNotification*) notification;
@end

