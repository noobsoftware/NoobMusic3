//
//  PHPScriptEvaluationReference.h
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//

#import <Foundation/Foundation.h>
#import "PHPScriptFunction.h"
@class PHPInterpretation;
@class PHPScriptObject;

@interface PHPScriptEvaluationReference : NSObject
//@property(nonatomic) NSDictionary* language;
//@property(nonatomic) NSMutableArray* callFunction;
@property (nonatomic) PHPScriptFunction* /*__weak*/ contextValue;
@property (nonatomic) PHPInterpretation* /*__weak*/ interpretation;
@property (nonatomic) NSMutableDictionary* subObjectDict;
@property (nonatomic) PHPScriptObject* /*__weak*/ lastSetValidContext;
@property (nonatomic) PHPScriptFunction* /*__weak*/ lastCurrentFunctionContext;
@property (nonatomic) NSObject* preventSetValidContext;
@property (nonatomic) NSObject* preserveContext;
@property (nonatomic) NSObject* inParentContextSetting;
@property (nonatomic) PHPScriptFunction* /*__weak*/ lastFunctionContextValue;
@property (nonatomic) bool isAsync;
/*@property (nonatomic) PHPScriptFunction*  contextValue;
@property (nonatomic) PHPInterpretation*  interpretation;
@property (nonatomic) NSMutableDictionary* subObjectDict;
@property (nonatomic) PHPScriptObject*  lastSetValidContext;
@property (nonatomic) PHPScriptFunction*  lastCurrentFunctionContext;
@property (nonatomic) NSObject* preventSetValidContext;
@property (nonatomic) NSObject* preserveContext;
@property (nonatomic) NSObject* inParentContextSetting;
@property (nonatomic) PHPScriptFunction*  lastFunctionContextValue;
@property (nonatomic) bool isAsync;*/
- (NSObject*) callFun: (PHPScriptFunction*) context;
- (void) callFun: (PHPScriptFunction*) /*__weak*/  context callback: (id) callback;
//@property (copy) NSObject* (^subRoutineHandler) (PHPScriptFunction*); //copy, nonatomic //strong
//- (void) construct:(int) index subRoutine:(NSObject*(^)(PHPScriptFunction *))subRoutine;
- (NSObject*(^)(PHPScriptFunction *)) getCallFun;
@end
