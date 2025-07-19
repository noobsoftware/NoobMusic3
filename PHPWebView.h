//
//  PHPWebView.h
//  noobtest
//
//  Created by siggi on 18.1.2025.
//

#ifndef PHPWebView_h
#define PHPWebView_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "PHPScriptObject.h"
//@class PHPScriptObject;
@class PHPScriptFunction;
@class PHPInterpretation;
@class LayoutBox;
@class ContentLayout;
@class NoobWKNavigationDelegate;
@class NoobWKDownloadDelegate;
@class WKMessagesAlt;

@interface PHPWebView : PHPScriptObject
@property(nonatomic) WKMessagesAlt* messagesSetValue;
@property(nonatomic) WKWebView* webView;
@property(nonatomic) NoobWKDownloadDelegate* downloadDelegate;
@property(nonatomic) NoobWKNavigationDelegate* navigationDelegate;
- (void) initDelegates;
- (void) init: (PHPScriptFunction*) context;
//@property(nonatomic) NSDictionary* language;
//@property(nonatomic) int orientation;
//@property(nonatomic) int spacing;

@end


#endif /* PHPWebView_h */
