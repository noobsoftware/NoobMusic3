//
//  WKMessages.h
//  noobtest
//
//  Created by siggi jokull on 20.2.2023.
//

#ifndef WKMessages_h
#define WKMessages_h

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class PHPInterpretation;
@class PHPScriptFunction;

@interface WKMessagesAlt : NSObject<WKScriptMessageHandler>
@property(nonatomic) PHPInterpretation* interpretation;
@property(nonatomic) WKWebView* webView;
@property(nonatomic) NSMutableArray* messages;
@property(nonatomic) dispatch_queue_t queue;
@property(nonatomic) PHPScriptFunction* callback;

@property(nonatomic) WKContentWorld* world;
- (void) initArrays;
- (void) run;
- (void) sendMessage: (NSString*) evalString dictValues: (NSDictionary*) dictValues callback: (PHPScriptFunction*) callback;
@end



#endif /* WKMessages_h */
