//
//  WKMessages.m
//  noobtest
//
//  Created by siggi jokull on 20.2.2023.
//

#import "WKMessages.h"
#import "PHPInterpretation.h"
#import "PHPScriptFunction.h"


@interface WKMessages ()


@end

@implementation WKMessages
- (void) initArrays {
    [self setMessages:[[NSMutableArray alloc] init]];
    
    dispatch_queue_attr_t qos = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, -1);
    dispatch_queue_t recordingQueue = dispatch_queue_create([@"wkMessagesQueue" UTF8String], qos);
    [self setQueue:recordingQueue];
    [self setWorld:[WKContentWorld pageWorld]];
}

/*- (void) run {
    NSString* result = [[self interpretation] receiveData:message_body];
    //result = [result stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    //////////////////////NSLog/@"message result: %@", result);
    NSData *nsdata = [result dataUsingEncoding:NSUTF8StringEncoding];

    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    [[self webView] evaluateJavaScript:[NSString stringWithFormat:@"app.receive_messages('%@');", base64Encoded] completionHandler:NULL];
}*/

- (void) sendMessage: (NSString*) evalString dictValues: (NSDictionary*) dictValues callback: (PHPScriptFunction*) callback {
    //dictValues = [self encodeValues:dictValues decode:true];
    //NSLog(@"eval string : %@ %@", evalString, dictValues);
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        //if(@available(macOS 11.0, *)) {
            [[self webView] callAsyncJavaScript:evalString arguments:dictValues inFrame:nil inContentWorld:[self world] completionHandler:^(id _Nullable_result a, NSError * _Nullable error) {
                //NSLog(@"called async javascript");
                /*if(callback != nil) {
                    PHPScriptFunction* function = (PHPScriptFunction*)callback;
                    NSMutableArray* arr = [[NSMutableArray alloc] init];
                    [function callScriptFunctionSub:arr parameterValues:nil awaited:nil returnObject:nil interpretation:nil];
                }*/
            }];
        /*} else {
            ToJSON* toJSON = [[ToJSON alloc] init];
            NSString* resultValues = [toJSON toJSONString:dictValues];
            resultValues = [resultValues stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSData *nsdata = [resultValues dataUsingEncoding:NSUTF8StringEncoding];
            
            // Get NSString from NSData object in Base64
            NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
            NSArray* split = [evalString componentsSeparatedByString:@"("];
            NSString* evalStringValue = split[0];
            evalStringValue = [evalStringValue stringByAppendingString:[NSString stringWithFormat:@"(['json_values' => '%@']);", base64Encoded]];
            //NSString* evalStringValue = [NSString stringWithFormat:@"app.receive_messages(['json_values' => '%@']);", base64Encoded];
            
            
            [[self webView] evaluateJavaScript:evalStringValue completionHandler:^(id _Nullable, NSError * _Nullable error) {
                
            }];
            // Fallback on earlier versions
        }*/
    });
}

- (NSObject*) encodeValues: (NSObject*) values decode: (bool) decode {
    if([values isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dictionary = (NSDictionary*)values;
        NSMutableDictionary* resultingDictionary = [[NSMutableDictionary alloc] init];
        for(NSObject* key in dictionary) {
            resultingDictionary[key] = [self encodeValues:dictionary[key] decode:decode];
        }
        return resultingDictionary;
    } else if([values isKindOfClass:[NSArray class]]) {
        NSArray* array = (NSArray*)values;
        long counter = 0;
        NSMutableArray* resultingArray = [[NSMutableArray alloc] init];
        for(NSObject* value in array) {
            [resultingArray addObject:[self encodeValues:value decode:decode]];
            counter++;
        }
        return resultingArray;
    } else if([values isKindOfClass:[NSString class]]) {
        NSString* stringValue = (NSString*)values;
        if(!decode) {
            stringValue = [stringValue stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
            //stringValue = [stringValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        } else {
            //stringValue = [stringValue stringByRemovingPercentEncoding];
            stringValue = [stringValue stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
        }
        return stringValue;
    }
    return values;
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    @autoreleasepool {
        
        NSMutableDictionary* message_body = [[NSMutableDictionary alloc] initWithDictionary:[message body]];
        if([self prevent]) {
            //NSLog(@"prevented");
            return;
        }
        //message_body = [self encodeValues:message_body decode:false];
        
        //NSLog(@"message %@", message_body);
        //dispatch_queue_t concurrent_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //dispatch_sync(concurrent_queue, ^{
        dispatch_barrier_async_and_wait([self queue], ^{
            @autoreleasepool {
                
                /*NSString* result = [[self interpretation] receiveData:message_body];
                 //result = [result stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
                 //////////////////////NSLog/@"message result: %@", result);
                 NSData *nsdata = [result dataUsingEncoding:NSUTF8StringEncoding];
                 
                 // Get NSString from NSData object in Base64
                 NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
                 [[self webView] evaluateJavaScript:[NSString stringWithFormat:@"app.receive_messages('%@');", base64Encoded] completionHandler:NULL];
                 //[[self webView] websc]*/
                //NSLog(@"message : %@", message_body);
                
                NSDictionary* result = nil;// [[self interpretation] receiveDataDict:message_body function:@"receive_messages"];
                if(result == NULL) {
                    return;
                }
                //NSLog(@"result WKMESSAGES : %@ ", result);
                
                //if(![result isEqualTo:@"NULL"]) {
                    //NSLog(@"result : %@", result);
                    //result = (NSDictionary*)[self encodeValues:result decode:true];
                    result = @{
                        @"data": result
                    };
                    //dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    //if(@available(macOS 11.0, *)) {
                    [[self webView] callAsyncJavaScript:@"app.receive_messages(data);" arguments:result inFrame:nil inContentWorld:[self world] completionHandler:^(id _Nullable_result a, NSError * _Nullable error) {
                        //NSLog(@"completed");
                    }];
                //}
            }
            /*} else {
             //////////////////////NSLog/@"message result: %@", result);
             ToJSON* toJSON = [[ToJSON alloc] init];
             NSString* resultValues = [toJSON toJSONString:result];
             resultValues = [resultValues stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
             NSData *nsdata = [resultValues dataUsingEncoding:NSUTF8StringEncoding];
             
             // Get NSString from NSData object in Base64
             NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
             NSString* evalString = [NSString stringWithFormat:@"app.receive_messages(['json_values' => '%@']);", base64Encoded];
             
             
             [[self webView] evaluateJavaScript:evalString completionHandler:^(id _Nullable, NSError * _Nullable error) {
             
             }];
             }*/
            /*} else {
             NSLog(@"not avaiabile");
             // Fallback on earlier versions
             }*/
            //});
            
            /*NSString* result = [[self interpretation] receiveData:message_body];
             if(![result isEqualToString:@""]) {
             //NSLog(@"result: %@", result);
             //result = [result stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
             ////////////////////////NSLog/@"message result: %@", result);
             //result = [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             result = [result stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
             //////NSLog(@"%@", result);
             NSData *nsdata = [result dataUsingEncoding:NSUTF8StringEncoding];
             
             // Get NSString from NSData object in Base64
             //NSString* base64Encoded = [result stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
             NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
             //////////NSLog(@"base64: %@", base64Encoded);
             ///
             //dispatch_async(concurrent_queue, ^{
             
             dispatch_async(dispatch_get_main_queue(), ^(void){
             [[self webView] evaluateJavaScript:[NSString stringWithFormat:@"app.receive_messages('%@');", base64Encoded] completionHandler:NULL];
             });
             }*/
        });
    }
}

@end
