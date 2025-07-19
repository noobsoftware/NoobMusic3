//
//  NoobWKNavigationDelegate.h
//  noobtest
//
//  Created by siggi jokull on 15.7.2023.
//

#ifndef NoobWKNavigationDelegate_h
#define NoobWKNavigationDelegate_h
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "NoobWKDownloadDelegate.h"

@class PHPInterpretation;

@interface NoobWKNavigationDelegate : NSObject<WKNavigationDelegate>
/*@property(nonatomic) PHPInterpretation* interpretation;
@property(nonatomic) WKWebView* webView;
@property(nonatomic) NSMutableArray* messages;
- (void) initArrays;
- (void) run;*/
@property NoobWKDownloadDelegate* downloadDelegate;
@end


#endif /* NoobWKNavigationDelegate_h */
