//
//  NoobWKNavigationDelegate.m
//  noobtest
//
//  Created by siggi jokull on 15.7.2023.
//

#import "NoobWKNavigationDelegate.h"
//#import "PHPInterpretation.h"

@interface NoobWKNavigationDelegate ()


@end

@implementation NoobWKNavigationDelegate
/*- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if([navigationAction shouldPerformDownload]) {
        decisionHandler(WKNavigationActionPolicyDownload);
    }
}
- (void) webView:(WKWebView *)webView navigationAction:(WKNavigationAction *)navigationAction didBecomeDownload:(WKDownload *)download {
    download.delegate = [self downloadDelegate];
    //////NSLog(@"did become download: %@", download);
}
- (void) webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if([navigationResponse canShowMIMEType]) {
        decisionHandler(WKNavigationResponsePolicyAllow);
    } else {
        decisionHandler(WKNavigationResponsePolicyDownload);
    }
    
}
- (void) webView:(WKWebView *)webView navigationResponse:(WKNavigationResponse *)navigationResponse didBecomeDownload:(WKDownload *)download {
    download.delegate = [self downloadDelegate];
    //if([navigationResponse canShowMIMEType]) {
        
    //}
    //////NSLog(@"did become download: %@", download);
}*/
- (void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"failed to navigate");
}
@end
