//
//  PHPIncludedObjects.m
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import "PHPRegex.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import <WebKit/WebKit.h>

@implementation PHPRegex
- (void) init: (PHPScriptFunction*) context {
    [self initArrays];
    [self setGlobalObject:true];
    
    /*PHPScriptFunction* reg_match = [[PHPScriptFunction alloc] init];
    [reg_match initArrays];
    [self setDictionaryValue:@"reg_match" value:reg_match];
    [reg_match setPrototype:self];
    [reg_match setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSString* captureRegex = (NSString*)values[0][0];
        NSString* input = (NSString*)values[0][1];
        NSError* error;
        
        //NSLog(@"captureRegex: %@", captureRegex);
        
        NSMutableDictionary* results = [[NSMutableDictionary alloc] init];
        
        //NSString* stringCapture = @"(['])((?:\\\\\\1|(?:(?!\\1)).)*)(\\1)";
        NSRegularExpression *regex_strings_result = [NSRegularExpression regularExpressionWithPattern:captureRegex
                                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                                error:&error];
        NSArray *stringsArray = [regex_strings_result matchesInString:input options:0 range:NSMakeRange(0, [input length])] ;
        //////////////////////////NSLog/@"stringsArray: %@", stringsArray);
        for(NSTextCheckingResult* match in stringsArray) {
            //NSRange matchRange = [match replaceValueAtIndex:@(0) inPropertyWithKey:<#(nonnull NSString *)#> withValue:<#(nonnull id)#>];//[match rangeAtIndex:1];
            NSUInteger matchRange = [match numberOfRanges];
            //NSLog(@"match: %lu", matchRange);
            NSRange range = [match range];
            NSString* subString = [input substringWithRange:range];
            if(results[@(range.location)] == nil) {
                results[@(range.location)] = @{
                    @"length_value": @(range.length),
                    @"value": subString
                };
            }
        }
        return [[self_instance getInterpretation] makeIntoObjects:results];
    } name:@"main"];*/
    
    PHPScriptFunction* reg_match = [[PHPScriptFunction alloc] init];
    [reg_match initArrays];
    [self setDictionaryValue:@"reg_match" value:reg_match];
    [reg_match setPrototype:self];
    [reg_match setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSString* captureRegex = (NSString*)values[0][0];
        NSString* input = (NSString*)values[0][1];
        NSError* error;
        
        //NSLog(@"captureRegex: %@", captureRegex);
        
        NSMutableDictionary* results = [[NSMutableDictionary alloc] init];
        
        //NSString* stringCapture = @"(['])((?:\\\\\\1|(?:(?!\\1)).)*)(\\1)";
        NSRegularExpression *regex_strings_result = [NSRegularExpression regularExpressionWithPattern:captureRegex
                                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                                error:&error];
        NSArray *stringsArray = [regex_strings_result matchesInString:input options:0 range:NSMakeRange(0, [input length])] ;
        //////////////////////////NSLog/@"stringsArray: %@", stringsArray);
        NSMutableArray* resInOrder = [[NSMutableArray alloc] init];
        for(NSTextCheckingResult* match in stringsArray) {
            //NSRange matchRange = [match replaceValueAtIndex:@(0) inPropertyWithKey:<#(nonnull NSString *)#> withValue:<#(nonnull id)#>];//[match rangeAtIndex:1];
            NSUInteger matchRange = [match numberOfRanges];
            //NSLog(@"match: %lu", matchRange);
            NSRange range = [match range];
            NSString* subString = [input substringWithRange:range];
            if(results[@(range.location)] == nil) {
                results[@(range.location)] = @{
                    @"length_value": @(range.length),
                    @"value": subString
                };
                [resInOrder addObject:@{
                    @"position": @(range.location),
                    @"length_value": @(range.length),
                    @"value": subString
                }];
            }
        }
        return [[self_instance getInterpretation] makeIntoObjects:resInOrder];
    } name:@"main"];
    
    
}
@end
