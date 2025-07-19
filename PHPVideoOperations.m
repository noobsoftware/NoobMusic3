//
//  PHPVideoOperations.m
//  noobtest
//
//  Created by siggi on 7.2.2024.
//

#import "PHPVideoOperations.h"
/*
 @class PHPScriptFunction;
 @class PHPReturnResult;
 @class PHPScriptVariable;
 @class PHPInterpretation;*/
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPInterpretation.h"

@implementation PHPVideoOperations
- (void) init: (PHPScriptFunction*) context {
    [self initArrays];
    [self setGlobalObject:true];
    PHPScriptFunction* audioLevels = [[PHPScriptFunction alloc] init];
    [audioLevels initArrays];
    [self setDictionaryValue:@"find_audio_levels" value:audioLevels];
    [audioLevels setPrototype:self];
    [audioLevels setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        VideoOperations* videoOperations = [[VideoOperations alloc] init];
        
        ToJSON* toJSON = [[ToJSON alloc] init];
        NSMutableArray* files = (NSMutableArray*)[toJSON toJSON:values[0][0]];
        //NSLog(@"files : %@", files);
        [videoOperations audioLevels:files callback:(PHPScriptFunction*)values[0][1] progressCallback:(PHPScriptFunction*)values[0][2]];
        return nil;
    } name:@"main"];
}
@end
