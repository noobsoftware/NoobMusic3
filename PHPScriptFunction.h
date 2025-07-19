//
//  PHPScriptFunction.h
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//


#import <Foundation/Foundation.h>
#import "PHPScriptObject.h"
#import "PHPReferenceItem.h"
//@class PHPCallbackReference;
@class PHPInterpretation;

@interface PHPScriptFunction : PHPScriptObject
//@property(nonatomic) NSMutableArray* resetableParseObjects;
@property(nonatomic) NSString* functionName;
@property(nonatomic) NSMutableDictionary* closures;
//@property(nonatomic) PHPInterpretation* interpretation;
@property(nonatomic) bool isAsync;
@property(nonatomic) bool allowReturn;
@property(nonatomic) NSString* accessFlag;
@property(nonatomic) PHPScriptFunction* __weak lastCaller;

//@property(nonatomic) PHPScriptFunction* parentContext;
/*tharf ser property fyrir phpscriptfunction sem er strong og ser fyrir object sem er weak*/
@property(atomic) bool invalidateExecutionCompletion;
@property(nonatomic) NSDictionary* presetInput;
@property(nonatomic) bool toDestroy;
@property(nonatomic) NSNumber* isCallback;
@property(nonatomic) NSNumber* containsCallbacks;

@property(atomic) NSMutableArray* toUnsetItems;
@property(atomic) bool completedExecution;
@property(nonatomic) bool toUnset;
- (void) clearRunningToUnset;
@property(nonatomic) NSMutableArray* references;
//@property(nonatomic) NSNumber* depthValue;
//@property(nonatomic) PHPScriptObject* prototype;
//@property(nonatomic) PHPScriptFunction* parentContext;
//@property(atomic) long referenceCounter;
@property(nonatomic) NSMutableDictionary*  inputParameters;
@property(nonatomic) NSMutableArray*  inputParametersKeys;
@property(nonatomic) NSMutableDictionary*  variables;
@property(nonatomic) NSMutableDictionary* classes;
@property(nonatomic) PHPScriptObject* /*__weak*/ classValueClass;
@property(nonatomic) PHPScriptEvaluationReference*  scriptIndexReference;
@property(atomic) bool hasRunOnce;
@property(nonatomic) NSMutableDictionary* cache;
@property(nonatomic) dispatch_queue_t  messagesQueue;
//@property(nonatomic) PHPScriptFunction* previousClassFunction;
@property(nonatomic) NSString* debugText;
@property(nonatomic) bool hasNoReturn;
@property(nonatomic) bool isReturnValueItem;
@property(nonatomic) NSObject*  returnResultValue;
@property(nonatomic) NSValue* nsValue;
@property(atomic) NSNumber* retainCountValue;
@property(atomic) NSNumber* callCount;
- (void) setContainsCallbacksValue;
- (void) setPropContainsCallbacks;
- (void) canUnset;
- (void) unsetScriptFunction;
//@property(nonatomic) NSMutableDictionary* parseObjectCaches;
- (void) unset: (PHPScriptObject*) context;
- (void) addIfNotResetableParseObjects: (NSObject*) item;
- (void) initParseObjectCaches;
- (bool) containedAsync;
- (void) resetResetableParseObjects;
- (void) resetResetableParseObjects: (NSMutableDictionary*) input;
- (NSObject*) setVariableValueAddition: (NSObject*) name value: (NSObject*) value defineInContext: (NSNumber*) defineInContext inputParameter: (NSNumber*) inputParameter overrideThis: (NSNumber*) overrideThis method: (NSString*) method;
- (NSMutableArray*) numericMultiplication: (NSObject*) valueA valueB: (NSObject*) valueB;
- (void) callCallback: (NSArray*) array;
- (void) callCallback: (NSArray*) array callback: (id) callback;
//- (NSObject*) callCallback: (NSArray*) array;
//- (NSObject*) callCallbackWithObjects: (NSArray*) array;
- (NSMutableDictionary*) copyClasses: (PHPInterpretation*) interpretation;
//@property(nonatomic) NSDictionary* language;
- (PHPScriptObject*) createScriptObject: (NSObject*) values;
- (PHPScriptFunction*) createScriptFunction:(NSNumber *)isAsync;
- (PHPScriptFunction*) copyScriptFunction;
- (PHPInterpretation*) getInterpretation;
- (void) scriptPushArray: (NSObject*) array item: (NSObject*) item;
- (void) construct2:(PHPScriptFunction *)parentContext evaluation: (PHPInterpretation*) evaluation;
- (void) resetThis: (PHPScriptObject*) context;
- (PHPScriptObject*) getObject;
- (PHPScriptObject*) _newInstance: (PHPScriptObject*) object parameterValues: (NSMutableArray*) parameterValues callback: (id) callback;
- (void) setInputVariables: (NSMutableArray*) inputs;
- (NSObject*) getVariableValue:(NSString *)name;
- (NSObject*) getVariableContainer: (NSString*) name;
- (bool) variableDefined: (NSString*) name;
- (NSString*) getClassIdentifier: (PHPScriptObject*) class;
- (PHPScriptObject*) setClassReference: (NSString*) identifier;
- (void) setClassValue: (NSString*) identifier scriptObject: (PHPScriptObject*) scriptObject;
- (NSObject*) setVariableValue: (NSObject*) name value: (NSObject*) value defineInContext: (NSNumber*) defineInContext inputParameter: (NSNumber*) inputParameter overrideThis: (NSNumber*) overrideThis;
- (NSObject*) setVariableValueInContext: (NSObject*) name value: (NSObject*) value defineInContext: (NSNumber*) defineInContext inputParameter: (NSNumber*) inputParameter overrideThis: (NSNumber*) overrideThis context:(PHPScriptFunction*) context;
- (NSObject*) prepareSetValue: (NSObject*) value;
- (NSObject*) setVariableIncrement: (NSObject*) reference;
- (NSObject*) setVariableDecrement: (NSObject*) reference;
- (NSObject*) getDictionaryValue:(NSObject *)name returnReference:(NSNumber *)returnReference createIfNotExists:(NSNumber *)createIfNotExists context:(PHPScriptFunction*) context;
- (void) setDictionaryValue: (NSObject*) name value: (NSObject*) value context:(PHPScriptFunction*) context;
- (void) setFunctionIdentifier: (NSString*) identifier;
- (PHPScriptObject*) createScriptObjectClass:(NSObject *)values;
- (PHPScriptFunction*) setParametersNamed: (NSObject*) identifier parameters: (NSMutableArray*) parameters scriptIndexReference: (NSObject*) scriptIndexReference;
- (PHPScriptFunction*) setParameters: (NSMutableArray*) parameters scriptIndexReference: (NSObject*) scriptIndexReference;
- (NSMutableArray*) numericDivision: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSMutableArray*) numericSubtraction: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSMutableArray*) numericModulo: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSMutableArray*) numericAddition: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSMutableArray*) stringAddition: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSObject*) setParanthesis: (NSObject*) value;
- (NSObject*) returnFollowingResult: (NSObject*) value;
- (NSObject*) returnValueResult: (NSObject*) value;
- (void) setClosure: (NSObject*(^)(NSMutableArray*, PHPScriptFunction*)) closure name: (NSString*) name;
- (NSObject*) callClosure: (NSMutableArray*) parameters name: (NSString*) name;
- (NSObject*) callScriptFunctionReference: (PHPVariableReference*) identifierReference parameterValues: (NSMutableArray*) parameterValues awaited: (NSNumber*) awaited;
- (NSObject*) callScriptFunction: (PHPVariableReference*) identifierReference parameterValues: (NSMutableArray*) parameterValues awaited: (NSNumber*) awaited returnObject: (NSNumber*) returnObject;
- (PHPScriptObject*) createScriptObjectFunc: (NSObject*) values;
- (NSMutableDictionary*) getClassesAsValue;
@end

