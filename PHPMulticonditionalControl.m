//
//  PHPMulticonditionalControl.m
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//

#import "PHPMulticonditionalControl.h"
#import "PHPScriptEvaluationReference.h"
#import "PHPReturnResult.h"

@implementation PHPMulticonditionalControl
- (void) constructMultiConditionalControl {
    [self setSubRoutines:[[NSMutableArray alloc] init]];
}
- (void) setCondition: (NSObject*) condition subRoutine: (PHPScriptEvaluationReference*) subRoutine {
    //////////////////////////////NSLog/@"setCondition : %@ - %@", condition, subRoutine);
    if(subRoutine == nil) {
        subRoutine = NULL;
    }
    [[self subRoutines] addObject:@{
        @"sub_routine": subRoutine,
        @"condition": condition
    }];
}
- (void) setElseCondition: (PHPScriptEvaluationReference*) subRoutine {
    //////////////////////////////NSLog/@"setElseCondition");
    [[self subRoutines] addObject:@{
        @"sub_routine": subRoutine,
        //@"condition": nil
    }];
}
- (void) run: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition callback: (id) /*__weak*/ callbackInput {
    id __block callback = callbackInput;
    //NSMutableArray* subRoutine = [[self subRoutines] reverseObjectEnumerator];
    //////////NSLog(@"run if statement: %lu", [[self subRoutines] count]);
    if(context == nil) {
        context = NULL;
    }
    if(lastValidCondition == nil) {
        lastValidCondition = NULL;
    }
    int key = 0;
    NSMutableArray* valuesRev = [[NSMutableArray alloc] initWithArray:[[[self subRoutines] reverseObjectEnumerator] allObjects]];
    id __block iterationCallback;
    iterationCallback = ^(long key) {
        NSMutableDictionary* value = valuesRev[key];//[valuesRev firstObject];
        //[valuesRev removeObjectAtIndex:0];
    //for(NSDictionary* value in [[self subRoutines] reverseObjectEnumerator]) {
        bool performBreak = false;
        //////////////////////////////NSLog/@"value condition : %@ - key: %d", value[@"condition"], key);
        NSObject* valueCondition = value[@"condition"];
        if([valueCondition isKindOfClass:[NSArray class]]) {
            valueCondition = ((NSArray*)valueCondition)[0];
        }
        valueCondition = [context resolveValueReferenceVariableArray:valueCondition];
        //NSLog(@"valueCondition: %@, %lu, %lu", valueCondition, [valuesRev count], key);
        if((valueCondition == NULL || valueCondition == nil) && key == [[self subRoutines] count]-1) {
            //////////////////////////////NSLog/@"else condition");
            //NSObject* result =
            [(PHPScriptEvaluationReference*)value[@"sub_routine"] callFun:NULL callback:^(NSObject* result) {
                if([result isKindOfClass:[PHPReturnResult class]]) {
                    
                    ((void(^)(NSObject*))callback)(result);
                    callback = nil;
                    iterationCallback = nil;
                    //return;
                    //return result;
                } else {
                    //if(indexLong+1 < [dictionaryValues count]) {
                    /*if([valuesRev count] > key+1) {
                        ((void(^)(long))iterationCallback)(key+1);
                        //iterationCallback(indexLong+1);
                    } else {*/
                        
                        ((void(^)(NSObject*))callback)(@false);
                        callback = nil;
                        iterationCallback = nil;
                    //}
                }
            }];// getCallFun](NULL); //NULL
            ////////NSLog(@"MultiConditionalControl result: %@", result);
            /*if([result isKindOfClass:[PHPReturnResult class]]) {
                return result;
            }
            performBreak = true;*/
        } else if([(NSNumber*)valueCondition boolValue] == true) {
            //////////////////////////////NSLog/@"if condition");
            /*NSObject* result = [(PHPScriptEvaluationReference*)value[@"sub_routine"] callFun:NULL];// getCallFun](NULL); //NULL
            //////////////////////////////NSLog/@"MultiConditionalControl result: %@", result);
            if([result isKindOfClass:[PHPReturnResult class]]) {
                return result;
            }
            performBreak = true;*/
            [(PHPScriptEvaluationReference*)value[@"sub_routine"] callFun:NULL callback:^(NSObject* result) {
                if([result isKindOfClass:[PHPReturnResult class]]) {
                    
                    ((void(^)(NSObject*))callback)(result);
                    callback = nil;
                    iterationCallback = nil;
                    //return;
                    //return result;
                } else {
                    //if(indexLong+1 < [dictionaryValues count]) {
                    /*if([valuesRev count] > key+1) {
                        ((void(^)(long))iterationCallback)(key+1);
                        //iterationCallback(indexLong+1);
                    } else {*/
                        
                        ((void(^)(NSObject*))callback)(@false);
                        callback = nil;
                        iterationCallback = nil;
                    //}
                }
            }];
        } else if([valuesRev count] > key+1) {
            ((void(^)(long))iterationCallback)(key+1);
        } else {
            ((void(^)(NSObject*))callback)(@false);
            callback = nil;
            iterationCallback = nil;
        }
        /*if(performBreak) {
            
            ((void(^)(NSObject*))callback)(@false);
            //break;
        } else*/
        /**/
        //key++;
    };
    if([valuesRev count] > 0) {
        
        ((void(^)(long))iterationCallback)(0);
    } else {
        
        ((void(^)(NSObject*))callback)(@false);
        callback = nil;
        iterationCallback = nil;
    }
    //NSNumber* falseResult = [[NSNumber alloc] initWithBool:false];
    //return falseResult;
}
/*- (void) dealloc {
    //NSLog(@"dealloc control multiconditional : %@", self);
    [self setSubRoutines:nil];
    [self setContext:nil];
}*/
@end
