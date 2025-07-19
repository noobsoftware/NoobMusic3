//
//  ToJSON.m
//  noobtest
//
//  Created by siggi on 27.12.2023.
//

#import "ToJSON.h"
#import "PHPVariableReference.h"
#import "PHPScriptObject.h"
#import "PHPScriptFunction.h"
#import "PHPUndefined.h"

@implementation ToJSON
- (NSObject*) toJSON: (NSObject*) input {
    [self setToJSONRecursionDetection:[[NSMutableArray alloc] init]];

    NSObject* results = [self toJSONSub:input];
    
    [self setToJSONRecursionDetection:nil];
    return results;
}

- (NSString*) toJSONString: (NSObject*) input {
    NSObject* intermediateResult = [self toJSON:input];
    NSString *string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:intermediateResult options:0 error:nil] encoding:NSUTF8StringEncoding];
    return string;
}

- (NSObject*) toJSONSub: (NSObject*) input {
    /*if([input isKindOfClass:[PHPScriptVariable class]]) {
        return [self toJSONSub:[(PHPScriptVariable*)input get]];
    }*/
    if([input isKindOfClass:[PHPScriptFunction class]]) {
        //return input;
        return @"undefined";
    }
    if([input isKindOfClass:[PHPVariableReference class]]) {
        return [self toJSONSub:[(PHPVariableReference*)input get:nil]];
    }
    if([input isKindOfClass:[PHPUndefined class]]) {
        return @"undefined";
    }

    if([input isKindOfClass:[PHPScriptObject class]]) {
        if([[self toJSONRecursionDetection] containsObject:input]) {

            return @false;
        }
        [[self toJSONRecursionDetection] addObject:input];
        NSObject* dictionary = [(PHPScriptObject*)input getDictionary];

        if([(PHPScriptObject*)input isArray]) {
            NSMutableArray* returnArray = [[NSMutableArray alloc] init];
            for(NSObject* value in (NSMutableArray*)dictionary) {
                NSObject* intermediateResult = [self toJSONSub:value];
                if(intermediateResult != nil) {
                    [returnArray addObject:intermediateResult];
                }
            }
            /*if([self assignCacheNodes]) {
                [(PHPScriptObject*)input setCacheArr:returnArray];
                [(PHPScriptObject*)input setCacheDict:nil];
            }*/
            return returnArray;
        } else if([dictionary isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary* returnDictionary = [[NSMutableDictionary alloc] init];
            for(NSObject* key in (NSMutableDictionary*)dictionary) {
                NSString* stringKey = (NSString*)key;
                if([key isKindOfClass:[NSNumber class]]) {
                    stringKey = [(NSNumber*)key stringValue];
                }
                returnDictionary[stringKey] = [self toJSONSub:((NSMutableDictionary*)dictionary)[key]];
            }
            /*if([self assignCacheNodes]) {
                [(PHPScriptObject*)input setCacheArr:nil];
                [(PHPScriptObject*)input setCacheDict:returnDictionary];
            }*/
            return returnDictionary;
        }
        return dictionary;
    } else if([input isKindOfClass:[NSArray class]]) {
        NSMutableArray* returnArray = [[NSMutableArray alloc] init];
        for(NSObject* value in (NSMutableArray*)input) {
            
            NSObject* intermediateResult = [self toJSONSub:value];
            if(intermediateResult != nil) {
                [returnArray addObject:intermediateResult];
            }
        }
        return returnArray;
    }
    if(input == nil) {
        return @false;
    }
    return input;
}
@end
