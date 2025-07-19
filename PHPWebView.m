//
//  PHPWebView.m
//  noobtest
//
//  Created by siggi on 18.1.2025.
//

#import "PHPWebView.h"

//#import "PHPScriptObject.h"
#import "LayoutBox.h"
#import "PHPScriptFunction.h"
#import "PHPInterpretation.h"
#import "NoobWKNavigationDelegate.h"
#import "NoobWKDownloadDelegate.h"
//#import "WKMessages.h"
#import "WKMessagesAlt.h"
//#import "ContentLayout.h"

@implementation PHPWebView

- (void) initDelegates {
    
    
    /*dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        NoobWKNavigationDelegate* navDelegate = [[NoobWKNavigationDelegate alloc] init];
        [self setNavigationDelegate:navDelegate];
        NoobWKDownloadDelegate* downloadDelegate = [[NoobWKDownloadDelegate alloc] init];
        [self setDownloadDelegate:downloadDelegate];
        [navDelegate setDownloadDelegate:downloadDelegate];
        [navDelegate setInterpretation:[self getInterpretation]];
        [navDelegate setWebViewItem:self];
        [[self webView] setNavigationDelegate:navDelegate];
        
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);*/
    
}

- (void) init: (PHPScriptFunction*) context {
    [self initArrays];
    [self setGlobalObject:true];
    
    [self setInterpretation:[context getInterpretation]];
    [self initDelegates];
    /*PHPRegex* regex = [[PHPRegex alloc] init];
     [regex init:context];
     
     [self setDictionaryValue:@"regex" value:regex];
     [regex setInterpretation:[context interpretation]];
     
     PHPStrings* stringsObject = [[PHPStrings alloc] init];
     [stringsObject init:context];
     [stringsObject setInterpretation:[context interpretation]];
     
     [self setDictionaryValue:@"strings" value:stringsObject];*/
    
    PHPScriptFunction* setBox = [[PHPScriptFunction alloc] init];
    [setBox initArrays];
    [self setDictionaryValue:@"load_request" value:setBox];
    [setBox setPrototype:self];
    [setBox setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSObject* input = [self parseInputVariable:values[0][0]];
        NSString* inputBox = (NSString*)[self_instance makeIntoString:input];
        /*[[self layoutBox] setBox:inputBox];*/
        NSURL* nsurl = [[NSURL alloc] initWithString:inputBox];
        NSURLRequest* req = [[NSURLRequest alloc] initWithURL:nsurl];
        NSLog(@"self webview : %@", [self webView]);
        NSLog(@"self url : %@ - %@", nsurl, inputBox);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[self webView] loadRequest:req];
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* getCurrentUrl = [[PHPScriptFunction alloc] init];
    [getCurrentUrl initArrays];
    [self setDictionaryValue:@"get_current_url" value:getCurrentUrl];
    [getCurrentUrl setPrototype:self];
    [getCurrentUrl setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
       /* NSObject* input = [self parseInputVariable:values[0][0]];
        NSString* inputBox = (NSString*)[self_instance makeIntoString:input];
        NSURL* nsurl = [[NSURL alloc] initWithString:inputBox];
        NSURLRequest* req = [[NSURLRequest alloc] initWithURL:nsurl];
        NSLog(@"self webview : %@", [self webView]);
        NSLog(@"self url : %@ - %@", nsurl, inputBox);
        [[self webView] loadRequest:req];
        return @"NULL";*/
        return @"NULL";
        //return [[[self webView] URL] absoluteString];
    } name:@"main"];
    
    /*PHPScriptFunction* init_messages = [[PHPScriptFunction alloc] init];
        [init_messages initArrays];
        [self setDictionaryValue:@"init_messages" value:init_messages];
        [init_messages setPrototype:self];
        [init_messages setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
            if([self messagesSetValue] == nil) {
                NSObject* input = [self parseInputVariable:values[0][0]];
                PHPScriptFunction* callback = (PHPScriptFunction*)input;
                //callback = [callback copyScriptFunction];
                WKMessagesAlt* wkmessages = [[WKMessagesAlt alloc] init];
                [wkmessages setCallback:callback];
                [wkmessages initArrays];
                [wkmessages setInterpretation:[self getInterpretation]];
                [[[[self webView] configuration] userContentController] addScriptMessageHandler:wkmessages name:@"mainMessageHandler"];
                [self setMessagesSetValue:wkmessages];
            }
            return @"NULL";
        } name:@"main"];*/
    
    PHPScriptFunction* init_messages = [[PHPScriptFunction alloc] init];
    [init_messages initArrays];
    [self setDictionaryValue:@"init_messages" value:init_messages];
    [init_messages setPrototype:self];
    [init_messages setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        if([self messagesSetValue] == nil) {
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            /*dispatch_async(dispatch_get_main_queue(), ^(void){
                web = [[self layoutBox] assignWebView:index];
                dispatch_semaphore_signal(sema);
            });*/
            dispatch_async(dispatch_get_main_queue(), ^(void){
                NSObject* input = [self parseInputVariable:values[0][0]];
                PHPScriptFunction* callback = (PHPScriptFunction*)input;
                //callback = [callback copyScriptFunction];
                WKMessagesAlt* wkmessages = [[WKMessagesAlt alloc] init];
                [wkmessages setCallback:callback];
                [wkmessages initArrays];
                [wkmessages setInterpretation:[self getInterpretation]];
                [[[[self webView] configuration] userContentController] addScriptMessageHandler:wkmessages name:@"mainMessageHandler"];
                [self setMessagesSetValue:wkmessages];
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* load_file = [[PHPScriptFunction alloc] init];
    [load_file initArrays];
    [self setDictionaryValue:@"load_file" value:load_file];
    [load_file setPrototype:self];
    [load_file setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSLog(@"load file : %@ - %@", [self webView], values);
        NSString* pathhtml = @"";
        //pathhtml = [[NSBundle mainBundle] pathForResource:@"index_output"
                                                         //ofType:@"html"];
        pathhtml = [[NSBundle mainBundle] pathForResource:[self parseInputVariable:(NSString*)values[0][0]]
                                                         ofType:@"html"];
        /*if([values[0] count] >= 1) {
            
            pathhtml = [[NSBundle mainBundle] pathForResource:(NSString*)values[0][0]
                                                             ofType:@"html"];
        }*/
        NSURL* fileURLHTML = [[NSURL alloc] initFileURLWithPath:pathhtml];
         ////////////NSLog(@"fileurlhtml: %@ - %@", fileURLHTML, pathhtml);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[self webView] loadFileURL:fileURLHTML allowingReadAccessToURL:fileURLHTML];
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* setZoom = [[PHPScriptFunction alloc] init];
    [setZoom initArrays];
    [self setDictionaryValue:@"set_zoom" value:setZoom];
    [setZoom setPrototype:self];
    [setZoom setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSObject* input = [self parseInputVariable:values[0][0]];
        NSNumber* inputBox = (NSNumber*)[self_instance makeIntoNumber:input];
        /*[[self layoutBox] setBox:inputBox];*/
        /*NSURL* nsurl = [[NSURL alloc] initWithString:inputBox];
        NSURLRequest* req = [[NSURLRequest alloc] initWithURL:nsurl];
        NSLog(@"self webview : %@", [self webView]);
        NSLog(@"self url : %@ - %@", nsurl, inputBox);
        [[self webView] loadRequest:req];*/
        if (@available(macOS 11.0, *)) {
            [[self webView] setPageZoom:[inputBox floatValue]];
        } else {
            // Fallback on earlier versions
        }
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* evaluate = [[PHPScriptFunction alloc] init];
    [evaluate initArrays];
    [self setDictionaryValue:@"evaluate" value:evaluate];
    [evaluate setPrototype:self];
    [evaluate setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        //NSLog(@"in call evaluate func");
        NSObject* input = nil;
        PHPScriptFunction* callback = nil;
        if([values count] == 0 || [values[0] count] < 2) {
            return @"NULL";
        }
        input = [self parseInputVariable:values[0][1]];
        callback = (PHPScriptFunction*)input;
         /*NSNumber* inputBox = (NSNumber*)[self_instance makeIntoNumber:input];
         if (@available(macOS 11.0, *)) {
         [[self webView] setPageZoom:[inputBox floatValue]];
         } else {
         // Fallback on earlier versions
         }*/
        /*[[self webView] evaluateJavaScript:@"function() { return 'test'; }" completionHandler:^(id _Nullable results, NSError * _Nullable error) {
         NSLog(@"results : %@", results);
         }];*/
        if (@available(macOS 11.0, *)) {
            //NSLog(@"in call evaluate func");
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //NSLog(@"call async : %@", [self webView]);
                NSError* read_file_error;
                //NSString* path = [[NSBundle mainBundle] pathForResource:@"jquery-slim" ofType:@"js"];
                //////////////////NSLog(@"add file : %@", path);
                NSString* jquery = @""; /*[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&read_file_error];
                if([[[[self webView] URL] absoluteString] containsString:@"noob.software"]) {
                    jquery = @"";
                }*/
                NSString* callString = [self makeIntoString:[self parseInputVariable:values[0][0]]];//@"return 'test1';";
                jquery = [jquery stringByAppendingString:callString];
                NSDictionary* arguments = @{};
                if([values[0] count] > 2) {
                    ToJSON* toJSON = [[ToJSON alloc] init];
                    arguments = [toJSON toJSON:[self parseInputVariable:values[0][2]]];
                }
                //NSLog(@"call asycn javascript : %@ - %@", jquery, arguments);
                [[self webView] callAsyncJavaScript:jquery arguments:arguments inFrame:nil inContentWorld:[WKContentWorld pageWorld] completionHandler:^(id _Nullable_result result, NSError * _Nullable error) {
                    if(result == nil) {
                        result = @"NULL";
                    }
                    if(callback != nil && ![callback isEqualTo:@0]) {
                        NSLog(@"in call evaluate func");
                        /*[callback callCallback:@[result] callback:^(NSObject* res) {
                            
                        }];*/
                    }
                    //NSLog(@"result: %@ - %@", result, error);
                }];
            });
        } else {
            // Fallback on earlier versions
        }
        return @true;
    } name:@"main"];
}

@end
