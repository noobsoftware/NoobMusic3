//
//  PHPLoopControl.h
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//

#import <Foundation/Foundation.h>
#import "PHPControl.h"
@class PHPReturnResult;

@interface PHPLoopControl : PHPControl
//@property(nonatomic) NSDictionary* language;
//@property(nonatomic) (NSMutableArray*(^)(PHPScriptFunction *)) condition;
//@property(nonatomic) (NSMutableArray*(^)(PHPScriptFunction *)) subRoutine;
@property(nonatomic) PHPScriptEvaluationReference* /*__weak*/ condition;
@property(nonatomic) PHPScriptEvaluationReference* /*__weak*/ subRoutine;
- (void) setCondition: (PHPScriptEvaluationReference*) condition subRoutine: (PHPScriptEvaluationReference*) subRoutine;
//- (void) run;
- (NSObject*) run: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition;
- (void) run: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition callback: (id) callback;
//- (void) setCondition:(NSMutableArray*(^)(PHPScriptFunction *))condition subRoutine:(NSMutableArray*(^)(PHPScriptFunction *))subRoutine;
/*{
    [self setClickEventHandlers:[NSArray arrayWithObject:callback]];
}*/
@end

