//
//  PHPLoopControl.m
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//
//
//  PHPControl.m
//  noobtest
//
//  Created by siggi jokull on 1.12.2022.
//


#import "PHPLoopControl.h"
#import "PHPScriptEvaluationReference.h"
#import "PHPReturnResult.h"

@implementation PHPLoopControl

- (void) setCondition: (PHPScriptEvaluationReference*) condition subRoutine: (PHPScriptEvaluationReference*) subRoutine {
    [self setCondition:condition];
    [self setSubRoutine:subRoutine];
}

- (void) runDepr: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition callback: (id) callback { //{
    /*while($this->condition->get_call_function()() === true) {
         $this->sub_routine->get_call_function()();
     }*/
    //NSObject* callFunctionResult =
    id  setCallback;
    setCallback = ^(NSObject* callFunctionResult) {
        callFunctionResult = [context parseInputVariable:callFunctionResult];
        ////////NSLog(@"callfunctionresult2: %@", callFunctionResult);
        NSNumber* boolresult = (NSNumber*)(callFunctionResult);
        bool bool_value = [boolresult boolValue];
        
        
        if(bool_value) {
            //NSObject* possible_return_result =
            [[self subRoutine] callFun:NULL callback:setCallback];//[[self subRoutine] getCallFun](NULL);
            /*if([possible_return_result isKindOfClass:[PHPReturnResult class]]) {
                
                ((void(^)(NSObject*))callback)(possible_return_result);
                return;
                //return possible_return_result;
            }
            callFunctionResult = [[self condition] callFun:NULL];//[[self condition] getCallFun](NULL);
            
            ////////NSLog(@"callfunctionresult: %@", callFunctionResult);
            callFunctionResult = [context parseInputVariable:callFunctionResult];
            ////////NSLog(@"callfunctionresult2: %@", callFunctionResult);
            boolresult = (NSNumber*)(callFunctionResult);
            bool_value = [boolresult boolValue];*/
        } else {
            ((void(^)(NSObject*))callback)(@(false));
        }
    };
    [[self condition] callFun:NULL callback:setCallback];//getCallFun](NULL);
    //BOOL boolResult = [callFunctionResult]
    //////////////NSLog(@"callfunction result: %@", callFunctionResult);
    ////////NSLog(@"callfunctionresult: %@", callFunctionResult);
    
    return;
    
    //NSNumber* falseResult = [[NSNumber alloc] initWithBool:false];
    //return falseResult;
}

- (void) run: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition callback: (id) callbackInput { //{
    id __block callback = callbackInput;
    //NSObject* callFunctionResult =
    id __block iterationCallback;
    PHPLoopControl* /*__weak*/ weakSelf = self;
    iterationCallback = ^{
        //NSLog(@"iteration callback value : %@ %@", weakSelf, [weakSelf condition]);
        [[weakSelf condition] callFun:NULL callback:^(NSObject* callFunctionResult) {
        
            callFunctionResult = [context parseInputVariable:callFunctionResult];
            ////////NSLog(@"callfunctionresult2: %@", callFunctionResult);
            NSNumber* boolresult = (NSNumber*)(callFunctionResult);
            bool bool_value = [boolresult boolValue];
            //NSLog(@"bool value : %@ - %@ - %@ - %@", @(bool_value), weakSelf, [weakSelf subRoutine], [weakSelf condition]);
            if(bool_value) {
                //NSObject* possible_return_result =
                [[weakSelf subRoutine] callFun:NULL callback:^(NSObject* possible_return_result) {
                    
                    if([possible_return_result isKindOfClass:[PHPReturnResult class]]) {
                        
                        ((void(^)(NSObject*))callback)(possible_return_result);
                        callback = nil;
                        iterationCallback = nil;
                        //((void(^)(NSObject*))possible_return_result)(@false);
                        //return possible_return_result;
                    } else {
                        ((void(^)(void))iterationCallback)();
                    }
                }];//[[self subRoutine] getCallFun](NULL);
            } else {
                
                ((void(^)(NSObject*))callback)(@false);
                callback = nil;
                iterationCallback = nil;
            }
            //NSNumber* falseResult = [[NSNumber alloc] initWithBool:false];
            //return falseResult;
        }];
    };
    ((void(^)(void))iterationCallback)();
    
    //getCallFun](NULL);
    //BOOL boolResult = [callFunctionResult]
    //////////////NSLog(@"callfunction result: %@", callFunctionResult);
    ////////NSLog(@"callfunctionresult: %@", callFunctionResult);
}
/*- (void) dealloc {
    //NSLog(@"dealloc control : %@", self);
    [self setContext:nil];
    [self setCondition:nil];
    [self setSubRoutine:nil];
}*/
@end
