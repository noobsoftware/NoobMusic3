//
//  PHPControl.m
//  noobtest
//
//  Created by siggi jokull on 1.12.2022.
//


#import "PHPControl.h"
#import "PHPScriptFunction.h"

@implementation PHPControl
- (void) construct: (PHPScriptFunction*) context {
    [self setContext:context];
}
- (NSObject*) run: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition {
    
    NSNumber* falseResult = [[NSNumber alloc] initWithBool:false];
    return falseResult;
}
- (void) run: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition callback: (id) callback {
    
    ((void(^)(NSObject*))callback)(@(false));
    //NSNumber* falseResult = [[NSNumber alloc] initWithBool:false];
    //return falseResult;
}
/*- (void) dealloc {
    [self setContext:nil];
}*/
@end
