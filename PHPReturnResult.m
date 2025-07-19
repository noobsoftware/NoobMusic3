//
//  PHPReturnResult.m
//  noobtest
//
//  Created by siggi jokull on 1.12.2022.
//

#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPScriptObject.h"
#import "PHPInterpretation.h"

@implementation PHPReturnResult
- (void) construct: (NSObject*) value {
    /*NSLog(@"set return result : %@", value);
    value = [[[self interpretation] globalContext] parseInputVariable:value];
    
    NSLog(@"set return result : %@", value);*/
    
    if([value isKindOfClass:[NSString class]]) {
        if([(NSString*)value isEqualToString:@"[]"]) {
            value = [[PHPScriptObject alloc] init];
            [(PHPScriptObject*)value setIsArray:true];
        }
    }
    if([value isKindOfClass:[PHPReturnResult class]]) {
        PHPReturnResult* returnResultValue = (PHPReturnResult*) value;
        [self setResult:[returnResultValue result]];
    } else {
        [self setResult:value];
    }
}
- (NSObject*) get {
    return [self result];
}
/*- (void) dealloc {
    //NSLog(@"deallocate return-result : %@", self);
    [self setResult:nil];
}*/
@end
