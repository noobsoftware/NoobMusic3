//
//  PHPControl.h
//  noobtest
//
//  Created by siggi jokull on 1.12.2022.
//

#import <Foundation/Foundation.h>

@class PHPScriptFunction;
@class PHPScriptEvaluationReference;
@class PHPVariableReference;
@class PHPReturnResult;

//@class PHPScriptFunction;
//@class PHPScriptEvaluationReference;
//@class PHPVariableReference;

@interface PHPControl : NSObject
@property(nonatomic) PHPScriptFunction* /*__weak*/ context;
- (void) construct: (PHPScriptFunction*) context;
- (NSObject*) run: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition;
- (void) run: (PHPScriptFunction*) context lastValidCondition: (NSObject*) lastValidCondition callback: (id) callback;
@end
