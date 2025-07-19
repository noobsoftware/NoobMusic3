//
//  PHPIncludedObjects.m
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import "PHPSearchInstance.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import <WebKit/WebKit.h>

@implementation PHPSearchInstance
- (void) init: (PHPScriptFunction*) context {
    [self initArrays];
    [self setGlobalObject:true];
    
    PHPScriptFunction* new_search = [[PHPScriptFunction alloc] init];
    [new_search initArrays];
    [self setDictionaryValue:@"new_search" value:new_search];
    [new_search setPrototype:self];
    [new_search setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        return nil;
    } name:@"main"];
    
    
    
}
@end
