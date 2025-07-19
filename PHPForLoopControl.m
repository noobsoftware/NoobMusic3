//
//  PHPForLoopControl.m
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//

#import "PHPForLoopControl.h"
#import "PHPScriptEvaluationReference.h"
#import "PHPScriptObject.h"
#import "PHPVariableReference.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPInterpretation.h"

@implementation PHPForLoopControl

- (void) setSwitches:(NSMutableDictionary*) switches {
    NSArray* keys = [switches allKeys];
    if([keys count] > 0) {
        [self setType:(NSString*)keys[0]];
    }
}
- (void) setForeach: (bool) flag {
    [self setType:@"foreach"];
}
- (void) setCondition: (NSObject*) a b: (NSObject*) b c: (NSObject*) c { //d: (NSObject*) d
    /*switch([self type]) {
        case @"ForIn":
        case @"ForOf:
           // [self set]
            break;
    }*/
    if(c == nil) {
        c = NULL;
    }
    if([[self type] isEqualToString:@"For"]) {
        [self setVariableDefinition:(PHPScriptEvaluationReference*)a];
        [self setCondition:(PHPScriptEvaluationReference*)b];
        [self setIterator:(PHPScriptEvaluationReference*)c];
    } else {
        if(c != NULL) {
            [self setFromVariable:a];
            [self setKeyVariable:(PHPVariableReference*)b];
            [self setIterationVariable:(PHPVariableReference*)c];
        } else {
            [self setForEach2:true];
            [self setFromVariable:a];
            [self setIterationVariable:(PHPVariableReference*)b];
        }
    }
}
- (NSObject*) run: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition { //{
    if([[self type] isEqualToString:@"foreach"]) {
        //////////////////////////////NSLog/@"inside foreach");
        NSObject* values = nil;
        NSMutableArray* keys;
        
        bool fromCache = false;
        
        if([self referenceValue] == nil) {
            values = [context parseInputVariable:[self fromVariable]];
        } else {
            values = [self referenceValue];
            keys = [self referenceKeys];
            fromCache = true;
        }
        //////////////////////////////NSLog/@"values: %@", values);
        /*while([values isKindOfClass:[NSMutableArray class]] && [(NSMutableArray*) values count] > 0) {
            values = ((NSMutableArray*)values)[0];
        }*/
        
        /*if(fromCache) {
        }*/
        PHPScriptObject* reference;
        ////////NSLog(@"fromVariable : %@", [self fromVariable]);
        if(!fromCache) {
            if([values isKindOfClass:[PHPScriptObject class]]) {
                PHPScriptObject* reference = (PHPScriptObject*)values;
                if(![reference isArray]) {
                    ////////////////////NSLog(@"inside for : %@", reference);
                    keys = [reference getKeys];
                }
                values = [reference getDictionary];
                if(![reference isArray]) {
                    ////////////////////NSLog(@"inside for : %@ - %@", keys, values);
                }
            } else {
                ////////////////////NSLog(@"inside for2 : %@", values);
                ////NSLog(@"self from variable : %@", [self fromVariable]);
                reference = (PHPScriptObject*)[(PHPVariableReference*)[self fromVariable] get:nil];
                values = [reference getDictionary];
                
                if(![reference isArray]) {
                    keys = [reference getKeys];
                    ////////////////////NSLog(@"inside for : %@ - %@", keys, values);
                }
            }
        }
        //////////////////////NSLog/@"for values: %@", values);
        if([(NSMutableDictionary*)values count] == 0) {
            return nil;
        }
        //////////////////////////////NSLog/@"values: %@", values);
        //NSObject* dictionaryValues = values;
        if(!fromCache) {
            if(keys != nil) {
                [self setReferenceKeys:keys];
            }
            if(values != nil) {
                [self setReferenceValue:values];
            }
        }
        if([self forEach2]) {
            if([values isKindOfClass:[NSArray class]]) {
                NSMutableArray* dictionaryValues = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)values];
                for(NSObject* value in dictionaryValues) {
                    //NSObject* value = dictionaryValues[key];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self iterationVariable] set:value context:nil];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value];
                    NSObject* result = [[self subRoutine] callFun:NULL];//getCallFun](NULL);
                    if([result isKindOfClass:[PHPReturnResult class]]) {
                        return result;
                    }
                }
            } else {
                NSMutableDictionary* dictionaryValues = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)values];
                for(NSString* key in keys) { //dictionaryValues;
                    NSObject* value = dictionaryValues[key];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self iterationVariable] set:value context:nil];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value];
                    NSObject* result = [[self subRoutine] callFun:NULL];//getCallFun](NULL);
                    if([result isKindOfClass:[PHPReturnResult class]]) {
                        return result;
                    }
                }
            }
        } else {
            if([values isKindOfClass:[NSArray class]]) {
                //////////////////////////NSLog/@"insfor1");
                NSMutableArray* dictionaryValues = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)values];
                long key_iterator = 0;
                for(NSObject* value in dictionaryValues) {
                    //NSObject* value = dictionaryValues[key];
                    //[[self context] setVariableValue:[[self keyVariable] identifier] value:[@(key_iterator) stringValue] defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self keyVariable] set:@(key_iterator) context:nil];
                    //////////////////////////NSLog/@"key iterator %@", @(key_iterator));
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self iterationVariable] set:value context:nil];
                    
                    //[[self context] setVariableValue:[[self keyVariable] identifier], value];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier], value];
                    NSObject* result = [[self subRoutine] callFun:NULL];//getCallFun](NULL);
                    if([result isKindOfClass:[PHPReturnResult class]]) {
                        return result;
                    }
                    key_iterator++;
                }
            } else {
                NSMutableDictionary* dictionaryValues = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)values];
                for(NSString* key in keys) {
                    NSObject* value = dictionaryValues[key];
                    //[[self context] setVariableValue:[[self keyVariable] identifier] value:key defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self keyVariable] set:key context:nil];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self iterationVariable] set:value context:nil];
                    
                    //[[self context] setVariableValue:[[self keyVariable] identifier], value];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier], value];
                    NSObject* result = [[self subRoutine] callFun:NULL];//getCallFun](NULL);
                    if([result isKindOfClass:[PHPReturnResult class]]) {
                        return result;
                    }
                }
            }
        }
    } else {
        [[self variableDefinition] callFun:NULL];//getCallFun](NULL);
        NSObject* conditionResult = [[self condition] callFun:NULL];//getCallFun](NULL);
        ////////////NSLog(@"insForLoop: %@", conditionResult);
        bool boolValue = [(NSNumber*)conditionResult boolValue];
        while(boolValue == true) {
            NSObject* result = [[self subRoutine] callFun:NULL];// getCallFun](NULL);
            [[self iterator] callFun:NULL];// getCallFun](NULL);
            if([result isKindOfClass:[PHPReturnResult class]]) {
                return result;
            }
        }
    }
    NSNumber* falseResult = [[NSNumber alloc] initWithBool:false];
    return falseResult;
}
- (void) run: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition callback: (id) callback { //{
    PHPForLoopControl* /*__weak*/ weakSelf = self;
    if([[self type] isEqualToString:@"foreach"]) {
        //////////////////////////////NSLog/@"inside foreach");
        NSObject* values = nil;
        NSMutableArray* keys;
        
        bool fromCache = false;
        
        if([self referenceValue] == nil) {
            values = [context parseInputVariable:[self fromVariable]];
        } else {
            values = [self referenceValue];
            keys = [self referenceKeys];
            fromCache = true;
        }
        //////////////////////////////NSLog/@"values: %@", values);
        /*while([values isKindOfClass:[NSMutableArray class]] && [(NSMutableArray*) values count] > 0) {
            values = ((NSMutableArray*)values)[0];
        }*/
        
        /*if(fromCache) {
        }*/
        PHPScriptObject* reference;
        ////////NSLog(@"fromVariable : %@", [self fromVariable]);
        if(!fromCache) {
            if([values isKindOfClass:[PHPScriptObject class]]) {
                PHPScriptObject* reference = (PHPScriptObject*)values;
                if(![reference isArray]) {
                    ////////////////////NSLog(@"inside for : %@", reference);
                    keys = [reference getKeys];
                }
                values = [reference getDictionary];
                if(![reference isArray]) {
                    ////////////////////NSLog(@"inside for : %@ - %@", keys, values);
                }
            } else {
                ////////////////////NSLog(@"inside for2 : %@", values);
                ////NSLog(@"self from variable : %@", [self fromVariable]);
                reference = (PHPScriptObject*)[(PHPVariableReference*)[self fromVariable] get:nil];
                values = [reference getDictionary];
                
                if(![reference isArray]) {
                    keys = [reference getKeys];
                    ////////////////////NSLog(@"inside for : %@ - %@", keys, values);
                }
            }
        }
        //////////////////////NSLog/@"for values: %@", values);
        if([(NSMutableDictionary*)values count] == 0) {
            
            ((void(^)(NSObject*))callback)(nil);
            return;
        }
        //////////////////////////////NSLog/@"values: %@", values);
        //NSObject* dictionaryValues = values;
        if(!fromCache) {
            if(keys != nil) {
                [self setReferenceKeys:keys];
            }
            if(values != nil) {
                [self setReferenceValue:values];
            }
        }
        if([self forEach2]) {
            if([values isKindOfClass:[NSArray class]]) {
                NSMutableArray* dictionaryValues = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)values];
                //NSLog(@"foreach 0-0: %@", dictionaryValues);
                //for(NSObject* value in dictionaryValues) {
                id /*__block*/ iterationCallbackOuter;
                iterationCallbackOuter = ^(long indexLong, id iterationCallback) {
                    if(indexLong >= [dictionaryValues count]) {
                        ((void(^)(NSObject*))callback)(@false);
                        return;
                    }
                    //NSLog(@"iterationCallback : %@", @(indexLong));
                    NSObject* value = dictionaryValues[indexLong];
                    //[dictionaryValues]
                    //NSObject* value = dictionaryValues[key];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[weakSelf iterationVariable] set:value context:nil];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value];
                    //NSObject* result =
                    //NSLog(@"call fun : %@ - %@ - %@ - %@", value, weakSelf, [weakSelf iterationVariable], [weakSelf subRoutine]);
                    [[weakSelf subRoutine] callFun:NULL callback:^(NSObject* result) {
                        
                        if([result isKindOfClass:[PHPReturnResult class]]) {
                            
                            ((void(^)(NSObject*))callback)(result);
                            //return;
                            //return result;
                        } else {
                            //NSLog(@"index : %@ - %@", @(indexLong+1), dictionaryValues);
                            if(indexLong+1 < [dictionaryValues count]) {
                                ((void(^)(long, id))iterationCallback)(indexLong+1, iterationCallback);
                                //iterationCallback(indexLong+1);
                            } else {
                                
                                ((void(^)(NSObject*))callback)(@false);
                            }
                        }
                    }];//getCallFun](NULL);
                    /*if([result isKindOfClass:[PHPReturnResult class]]) {
                        
                        ((void(^)(NSObject*))callback)(nil);
                        return;
                        //return result;
                    }*/
                };
                ((void(^)(long, id))iterationCallbackOuter)(0, iterationCallbackOuter);
                
            } else {
                NSMutableDictionary* dictionaryValues = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)values];
                /*for(NSString* key in keys) { //dictionaryValues;
                    NSObject* value = dictionaryValues[key];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self iterationVariable] set:value context:nil];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value];
                    NSObject* result = [[self subRoutine] callFun:NULL];//getCallFun](NULL);
                    if([result isKindOfClass:[PHPReturnResult class]]) {
                        return result;
                    }
                }*/
                id iterationCallbackOuter;
                iterationCallbackOuter = ^(long indexLong, id iterationCallback) {
                    if(indexLong >= [keys count]) {
                        ((void(^)(NSObject*))callback)(@false);
                        return;
                    }
                    NSObject* key = keys[indexLong];
                    //NSObject* value = dictionaryValues[indexLong];
                    NSObject* value = dictionaryValues[key];
                    //[dictionaryValues]
                    //NSObject* value = dictionaryValues[key];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self iterationVariable] set:value context:nil];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value];
                    //NSObject* result =
                    [[self subRoutine] callFun:NULL callback:^(NSObject* result) {
                        
                        if([result isKindOfClass:[PHPReturnResult class]]) {
                            
                            ((void(^)(NSObject*))callback)(result);
                            //return;
                            //return result;
                        } else {
                            if(indexLong+1 < [keys count]) {
                                ((void(^)(long, id))iterationCallback)(indexLong+1, iterationCallback);
                                //iterationCallback(indexLong+1);
                            } else {
                                
                                ((void(^)(NSObject*))callback)(@false);
                            }
                        }
                    }];//getCallFun](NULL);
                    /*if([result isKindOfClass:[PHPReturnResult class]]) {
                        
                        ((void(^)(NSObject*))callback)(nil);
                        return;
                        //return result;
                    }*/
                };
                ((void(^)(long, id))iterationCallbackOuter)(0, iterationCallbackOuter);
            }
        } else {
            if([values isKindOfClass:[NSArray class]]) {
                //////////////////////////NSLog/@"insfor1");
                NSMutableArray* dictionaryValues = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)values];
                long key_iterator = 0;
                /*for(NSObject* value in dictionaryValues) {
                    //NSObject* value = dictionaryValues[key];
                    //[[self context] setVariableValue:[[self keyVariable] identifier] value:[@(key_iterator) stringValue] defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self keyVariable] set:@(key_iterator) context:nil];
                    //////////////////////////NSLog/@"key iterator %@", @(key_iterator));
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self iterationVariable] set:value context:nil];
                    
                    //[[self context] setVariableValue:[[self keyVariable] identifier], value];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier], value];
                    NSObject* result = [[self subRoutine] callFun:NULL];//getCallFun](NULL);
                    if([result isKindOfClass:[PHPReturnResult class]]) {
                        return result;
                    }
                    key_iterator++;
                }*/
                
                id iterationCallbackOuter;
                iterationCallbackOuter = ^(long indexLong, id iterationCallback) {
                    if(indexLong >= [dictionaryValues count]) {
                        ((void(^)(NSObject*))callback)(@false);
                        return;
                    }
                    NSObject* value = dictionaryValues[indexLong];
                    //[dictionaryValues]
                    //NSObject* value = dictionaryValues[key];
                    [[self keyVariable] set:@(indexLong) context:nil];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self iterationVariable] set:value context:nil];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value];
                    //NSObject* result =
                    [[self subRoutine] callFun:NULL callback:^(NSObject* result) {
                        
                        if([result isKindOfClass:[PHPReturnResult class]]) {
                            
                            ((void(^)(NSObject*))callback)(result);
                            //return;
                            //return result;
                        } else {
                            if(indexLong+1 < [dictionaryValues count]) {
                                //NSLog(@"test1: %lu - %@", indexLong+1, dictionaryValues);
                                ((void(^)(long, id))iterationCallback)(indexLong+1, iterationCallback);
                                //iterationCallback(indexLong+1);
                            } else {
                                
                                ((void(^)(NSObject*))callback)(@false);
                            }
                        }
                    }];//getCallFun](NULL);
                    /*if([result isKindOfClass:[PHPReturnResult class]]) {
                        
                        ((void(^)(NSObject*))callback)(nil);
                        return;
                        //return result;
                    }*/
                };
                ((void(^)(long, id))iterationCallbackOuter)(0, iterationCallbackOuter);
            } else {
                NSMutableDictionary* dictionaryValues = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)values];
                /*for(NSString* key in keys) {
                    NSObject* value = dictionaryValues[key];
                    //[[self context] setVariableValue:[[self keyVariable] identifier] value:key defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self keyVariable] set:key context:nil];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self iterationVariable] set:value context:nil];
                    
                    //[[self context] setVariableValue:[[self keyVariable] identifier], value];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier], value];
                    NSObject* result = [[self subRoutine] callFun:NULL];//getCallFun](NULL);
                    if([result isKindOfClass:[PHPReturnResult class]]) {
                        return result;
                    }
                }*/
                
                id iterationCallbackOuter;
                iterationCallbackOuter = ^(long indexLong, id iterationCallback) {
                    if(indexLong >= [keys count]) {
                        NSLog(@"keys : %@ - %@", keys, dictionaryValues);
                        ((void(^)(NSObject*))callback)(@false);
                        return;
                    }
                    NSObject* key = keys[indexLong];
                    //NSObject* value = dictionaryValues[indexLong];
                    NSObject* value = dictionaryValues[key];
                    //[dictionaryValues]
                    //NSObject* value = dictionaryValues[key];
                    [[self keyVariable] set:key context:nil];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                    [[self iterationVariable] set:value context:nil];
                    //[[self context] setVariableValue:[[self iterationVariable] identifier] value];
                    //NSObject* result =
                    [[self subRoutine] callFun:NULL callback:^(NSObject* result) {
                        
                        if([result isKindOfClass:[PHPReturnResult class]]) {
                            
                            ((void(^)(NSObject*))callback)(result);
                            //return;
                            //return result;
                        } else {
                            if(indexLong+1 < [keys count]) {
                                //NSLog(@"test0: %lu - %@ - %@", indexLong+1, dictionaryValues, keys);
                                ((void(^)(long, id))iterationCallback)(indexLong+1, iterationCallback);
                                //iterationCallback(indexLong+1);
                            } else {
                                
                                ((void(^)(NSObject*))callback)(@false);
                            }
                        }
                    }];//getCallFun](NULL);
                    /*if([result isKindOfClass:[PHPReturnResult class]]) {
                        
                        ((void(^)(NSObject*))callback)(nil);
                        return;
                        //return result;
                    }*/
                };
                ((void(^)(long, id))iterationCallbackOuter)(0, iterationCallbackOuter);
            }
        }
    } else {
        /*[[self variableDefinition] callFun:NULL callback:^(NSObject* resIntermediate) {
            //NSObject* conditionResult =
            [[self condition] callFun:NULL callback:^(NSObject* conditionResult) {
                
                bool boolValue = [(NSNumber*)conditionResult boolValue];
                if(boolValue == true) {
                    //NSObject* result =
                    [[self subRoutine] callFun:NULL callback:^(NSObject* result) {
                        
                        if([result isKindOfClass:[PHPReturnResult class]]) {
                            
                            ((void(^)(NSObject*))callback)(result);
                            //return result;
                        } else {
                            
                        }
                    }];// getCallFun](NULL);
                    [[self iterator] callFun:NULL];// getCallFun](NULL);
                }
            }];//getCallFun](NULL);
            ////////////NSLog(@"insForLoop: %@", conditionResult);
        }];*///getCallFun](NULL);
        
    }
    //NSNumber* falseResult = [[NSNumber alloc] initWithBool:false];
    //return falseResult;
}
/*- (void) dealloc {
    //NSLog(@"dealloc control for : %@", self);
    [self setContext:nil];
    [self setCondition:nil];
    [self setSubRoutine:nil];
    [self setType:nil];
    //[self setForeach:nil];
    [self setIterator:nil];
    [self setVariableDefinition:nil];
    [self setForEach2:nil];
    [self setFromVariable:nil];
    [self setIterationVariable:nil];
    [self setReferenceKeys:nil];
    [self setReferenceKeys:nil];
}*/
@end

