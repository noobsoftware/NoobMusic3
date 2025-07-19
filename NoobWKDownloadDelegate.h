//
//  NoobWKDownloadDelegate.h
//  noobtest
//
//  Created by siggi jokull on 15.7.2023.
//

#ifndef NoobWKDownloadDelegate_h
#define NoobWKDownloadDelegate_h
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class PHPInterpretation;

@interface NoobWKDownloadDelegate : NSObject<WKDownloadDelegate>
/*@property(nonatomic) PHPInterpretation* interpretation;
@property(nonatomic) WKWebView* webView;
@property(nonatomic) NSMutableArray* messages;
- (void) initArrays;
- (void) run;*/
@end


#endif /* NoobWKDownloadDelegate_h */
