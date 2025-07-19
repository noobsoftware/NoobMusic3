//
//  PHPMulticonditionalControl.h
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//

#import <Foundation/Foundation.h>
#import "PHPControl.h"

@interface PHPMulticonditionalControl : PHPControl
//@property(nonatomic) NSDictionary* language;
@property(nonatomic) NSMutableArray* subRoutines;
- (void) constructMultiConditionalControl;
- (void) setCondition: (NSObject*) condition subRoutine: (PHPScriptEvaluationReference*) subRoutine;
- (void) setElseCondition: (PHPScriptEvaluationReference*) subRoutine;
- (NSObject*) run: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition;
@end
