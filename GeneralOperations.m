//
//  GeneralOperations.m
//  noobtest
//
//  Created by siggi on 7.2.2024.
//

#import "GeneralOperations.h"

@implementation GeneralOperations
- (NSMutableArray*)partition:(NSMutableArray*)initial
              partitionCount:(NSNumber*)partitionCount {
    NSNumber* partitionSize =
        @([@([initial count]) doubleValue] / [partitionCount doubleValue]);
    partitionSize = @(ceil([partitionSize intValue]));
    NSMutableArray* resultsGroupped =
        [[NSMutableArray alloc] initWithArray:@[]];
    NSMutableArray* results = [[NSMutableArray alloc] initWithArray:@[]];
    NSNumber* counter = @0;
    for (NSObject* item in initial) {
        [results addObject:item];
        counter = @([counter doubleValue] + 1);
        if ([counter isEqualTo:partitionSize]) {
            counter = @0;
            [resultsGroupped addObject:results];
            results = [[NSMutableArray alloc] initWithArray:@[]];
        }
    }
    if ([@([results count]) isGreaterThan:@0]) {
        [resultsGroupped addObject:results];
    }
    return resultsGroupped;
}
@end

