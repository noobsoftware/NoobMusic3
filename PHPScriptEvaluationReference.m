//
//  PHPScriptEvaluationReference.m
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//
#import "PHPScriptEvaluationReference.h"
#import "PHPScriptObject.h"
#import "PHPInterpretation.h"

@implementation PHPScriptEvaluationReference

- (void) construct:(int) index subRoutine:(NSObject*(^)(PHPScriptFunction *))subRoutine {
    /*[self setCallFunction:[[NSMutableArray alloc] init]];
     [[self callFunction] addObject:subRoutine];*/
    [self setIsAsync:false];
    //[self setSubRoutineHandler:subRoutine];
}
- (NSObject*(^)(PHPScriptFunction *)) getCallFun {
    return nil;
    //return [self subRoutineHandler];
    //return [self callFunction][0];
}

- (NSObject*) callFun: (PHPScriptFunction*) /*__weak*/  context {
    //@synchronized ([self contextValue]) {
    
    if(context == NULL || context == nil) {
        context = [self contextValue];
    }
    @synchronized (context) {
        
        NSMutableDictionary* subObjectDict = [self subObjectDict];
        /*if([self isAsync]) {
         NSLog(@"isasyync");
         NSMutableDictionary* newdict = (NSMutableDictionary*) CFBridgingRelease(CFPropertyListCreateDeepCopy (
         kCFAllocatorDefault,
         &subObjectDict,
         kCFPropertyListMutableContainersAndLeaves
         ));
         subObjectDict = newdict;
         subObjectDict = [[NSMutableDictionary alloc] initWithDictionary:subObjectDict copyItems:true];
         }*/
        /*NSObject* variableValue = nil;
         if([self isAsync]) {
         
         variableValue = [[self interpretation] execute:subObjectDict context:context lastParentContextParseLabel:nil lastParentContext:nil control:nil subSwitches:nil lastSetValidContext:[self lastSetValidContext] preventSetValidContext:[self preventSetValidContext] preserveContext:[self preserveContext] inParentContextSetting:[self inParentContextSetting] lastCurrentFunctionContext:nil containedAsync:[self isAsync]
         //lastFunctionContextValue:[self lastFunctionContextValue]
         ];
         } else {
         
         variableValue = [[self interpretation] execute:subObjectDict context:context lastParentContextParseLabel:nil lastParentContext:nil control:nil subSwitches:nil lastSetValidContext:[self lastSetValidContext] preventSetValidContext:[self preventSetValidContext] preserveContext:[self preserveContext] inParentContextSetting:[self inParentContextSetting] lastCurrentFunctionContext:[self lastCurrentFunctionContext] containedAsync:[self isAsync]
         //lastFunctionContextValue:[self lastFunctionContextValue]
         ];
         }*/
        /*NSObject* variableValue = [[self interpretation] execute:subObjectDict context:context lastParentContextParseLabel:nil lastParentContext:nil control:nil subSwitches:nil lastSetValidContext:[self lastSetValidContext] preventSetValidContext:[self preventSetValidContext] preserveContext:[self preserveContext] inParentContextSetting:[self inParentContextSetting] lastCurrentFunctionContext:[self lastCurrentFunctionContext] containedAsync:[self isAsync]
                                   //lastFunctionContextValue:[self lastFunctionContextValue]
        ];
        if([context isKindOfClass:[PHPScriptFunction class]] && [context isReturnValueItem]) {
            [context setReturnResultValue:variableValue];
        }
        return variableValue;*/
        NSObject* __block variableValue;
        @autoreleasepool {
            //dispatch_async_and_wait([[self interpretation] messagesQueue], ^{
                    
                //variableValue =
            [[self interpretation] execute:subObjectDict context:context lastParentContextParseLabel:nil lastParentContext:nil control:nil subSwitches:nil lastSetValidContext:[self lastSetValidContext] preventSetValidContext:[self preventSetValidContext] preserveContext:[self preserveContext] inParentContextSetting:[self inParentContextSetting] lastCurrentFunctionContext:[self lastCurrentFunctionContext] containedAsync:[self isAsync]
                                  callback:^(NSObject* intermediateResult) {
                variableValue = intermediateResult;
            }
                                       //lastFunctionContextValue:[self lastFunctionContextValue]
                ];
                if([context isKindOfClass:[PHPScriptFunction class]] && [context isReturnValueItem]) {
                    [context setReturnResultValue:variableValue];
                }
            //});
        }
        return variableValue;
    }
    //}
    return nil;
}

- (void) callFun: (PHPScriptFunction*) /*__weak*/  context callback: (id) /*__weak*/ callbackInput {
    id __block callback = callbackInput;
    //@synchronized ([self contextValue]) {
    
    if(context == NULL || context == nil) {
        context = [self contextValue];
    }
        
        //dispatch_async([[self interpretation] messagesQueue], ^{
            @synchronized (context) {
                
                //@autoreleasepool {
                    NSMutableDictionary* subObjectDict = [self subObjectDict];
                    //NSLog(@"execute script eval ref: %@ %@ %@ %@", self, subObjectDict[@"label"], [self interpretation], context);
                    [[self interpretation] execute:subObjectDict context:context lastParentContextParseLabel:nil lastParentContext:nil control:nil subSwitches:nil lastSetValidContext:[self lastSetValidContext] preventSetValidContext:[self preventSetValidContext] preserveContext:[self preserveContext] inParentContextSetting:[self inParentContextSetting] lastCurrentFunctionContext:[self lastCurrentFunctionContext] containedAsync:[self isAsync]
                                          callback:^(NSObject* variableValue) {
                        if([context isKindOfClass:[PHPScriptFunction class]] && [context isReturnValueItem]) {
                            [context setReturnResultValue:variableValue];
                        }
                        if(callback != nil) {
                            ((void(^)(NSObject*))callback)(variableValue);
                            //callback = nil;
                        }
                    }
                     //lastFunctionContextValue:[self lastFunctionContextValue]
                    ];
                //}
            }
        //});
}
/*- (void) dealloc {
    //NSLog(@"deallocate eval-ref : %@", self);
    [self setContextValue:nil];
    [self setInterpretation:nil];
    [self setSubObjectDict:nil];
    [self setLastSetValidContext:nil];
    [self setLastCurrentFunctionContext:nil];
    [self setPreventSetValidContext:nil];
    [self setPreserveContext:nil];
    [self setInParentContextSetting:nil];
    [self setLastFunctionContextValue:nil];
    [self setIsAsync:nil];
}*/


@end
