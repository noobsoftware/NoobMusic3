//
//  PHPScriptObject.h
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//

#import <Foundation/Foundation.h>
//#import "PHPEmptyPlaceholder.h"
@class PHPScriptFunction;
@class PHPInterpretation;
@class PHPVariableReference;
@class PHPScriptVariable;
@class PHPReturnResult;
@class PHPScriptEvaluationReference;
@class PHPValuesOperator;
//#import "Criollo.h"
//@class CRResponse;
//@class CRRouteCompletionBlock;
//@class PHPCallbackReference;
//#import "PHPControl.h"
/*
 protected $parent_context;
 public $is_array = NULL;
 protected $dictionary = [];
 protected $prototype;
 protected $access_flags = [];*/
@interface PHPScriptObject : NSObject //<NSCopying>

@property(nonatomic) NSString* classIdentifierValue;
@property(nonatomic) bool reverseIteratorSet;
@property(nonatomic) int nextKey;
//@property(nonatomic) bool containsFunctionValue;
@property(nonatomic) PHPScriptFunction* __weak parentContext; /*__weak*/
@property(nonatomic) PHPScriptFunction* parentContextStrong;
//@property(nonatomic) PHPScriptFunction* strongParentContext;
@property(nonatomic) bool isArray;
@property(atomic) NSMutableArray*  dictionaryKeys;
@property(atomic) NSMutableDictionary*  dictionary;
@property(atomic) NSMutableArray*  dictionaryArray;
@property(atomic) NSMutableArray*  dictionaryAux;
@property(nonatomic) PHPScriptObject* /*__weak*/ prototype;
@property(nonatomic) NSMutableDictionary* accessFlags; //NSDictionary;
@property(nonatomic) PHPScriptObject* /*__weak*/ originalClass;
@property(nonatomic) NSString* identifier;
@property(nonatomic) PHPInterpretation* /*__weak*/ interpretation;
@property(nonatomic) PHPScriptObject* /*__weak*/ parentClass;
@property(nonatomic) PHPInterpretation* /*__weak*/ interpretationForObject;
@property(nonatomic) PHPScriptFunction* /*__weak*/ currentFunctionContext;
@property(nonatomic) bool globalObject;
@property(nonatomic) PHPScriptObject* /*__weak*/ instanceItem;
//@property(nonatomic) NSMutableDictionary* cacheDict;
//@property(nonatomic) NSMutableArray* cacheArr;
//- (NSMutableDictionary*) getDictionary;
- (void) removeItem: (NSObject*) item;
- (PHPScriptObject*) getParentContext;
- (NSObject*) getCacheValue;

- (PHPScriptFunction*) currentObjectFunctionContext;

- (NSString*) description;
- (void) initArrays;
- (PHPInterpretation*) getInterpretation;
- (void) setAccessFlag: (NSObject*) accessFlag property: (NSObject*) property;
- (void) callClassConstructor: (NSMutableArray*) parameterValues  callback: (id) callback;
- (NSString*) getClassIdentifierFromClass;
- (bool) instanceOf: (NSString*) className;
- (void) setOriginalClass: (PHPScriptObject*) class;
- (PHPScriptObject*) getNewInstance: (PHPScriptFunction*) context;
- (PHPScriptObject*) setClassReference: (NSString*) identifier;
- (PHPScriptFunction*) createNamedScriptFunction: (PHPScriptObject*) class;
//$value='undefined', $define_in_context=true, $input_parameter=false, $override_this=false
//- (NSObject*) setVariableValueInContext: (NSObject*) name value: (NSObject*) value defineInContext: (NSNumber*) defineInContext inputParameter: (NSNumber*) inputParameter overrideThis: (NSNumber*) overrideThis;
- (NSObject*) setVariableValueInContext: (NSObject*) name value: (NSObject*) value defineInContext: (NSNumber*) defineInContext inputParameter: (NSNumber*) inputParameter overrideThis: (NSNumber*) overrideThis context: (PHPScriptFunction*) context;
//- (void) setIdentifier:(NSString *)identifier
- (NSNumber*) return_boolean_true;
- (NSNumber*) return_boolean_false;
- (void) setObjectIdentifier: (NSObject*) identifier;
- (void) construct: (PHPScriptFunction*) parentContext;
- (void) setClassExtends: (PHPScriptObject*) class;
- (PHPVariableReference*) getArrayValueContextReference: (NSObject*) index returnReference: (NSNumber*) returnReference;
- (NSObject*) getArrayValueContext: (NSObject*) index returnReference: (NSNumber*) returnReference context: (PHPScriptFunction*) context;
- (NSString*) getTypeOf: (NSObject*) value;
- (void) setArray: (bool) isArray;
- (void) scriptArrayUnshift: (NSObject*) item;
- (NSObject*) scriptArrayShift;
- (void) scriptArrayPush: (NSObject*) item;
- (NSObject*) resolveVariableReturn: (NSObject*) item;
- (NSObject*) resolveValueReferenceVariableArray: (NSObject*) item;
- (NSObject*) scriptArrayPop;
- (NSString*) toString;
- (NSString*) join: (NSObject*) delimiter;
- (NSString*) toString: (NSObject*) value;
- (NSMutableArray*) reverseArray;
- (NSString*) setString: (NSObject*) value;
- (NSMutableArray*) setStrings: (NSMutableArray*) values;
- (NSMutableDictionary*) setStringsDictionary: (NSMutableDictionary*) values;
- (NSMutableArray*) getKeys;
- (NSMutableArray*) getDictionaryValues;
- (NSObject*) getArrayVariableValue: (PHPVariableReference*) identifier index: (NSObject*) index;
- (NSObject*) getArrayValue: (PHPVariableReference*) identifier index: (NSObject*) index;
- (NSObject*) getVariableValue: (NSString*) name;
- (bool) isPrototypeOf: (PHPScriptObject*) prototypeCheck;
- (NSObject*) getDictionaryValue: (NSObject*) name returnReference: (NSNumber*) returnReference createIfNotExists: (NSNumber*) createIfNotExists context: (PHPScriptFunction*) context;
- (NSObject*) getDictionary;
- (void) setFunction: (NSString*) name function: (PHPScriptFunction*) function;
//- (void) setDictionaryValue: (NSObject*) name value: (NSObject*) value;
- (void) setDictionaryValue: (NSObject*) name value: (NSObject*) value context: (PHPScriptFunction*) context;
- (void) setDictionaryValue: (NSObject*) name value: (NSObject*) value;
- (PHPScriptFunction*) createScriptFunction: (NSNumber*) isAsync;
- (PHPVariableReference*) setPropertyReference: (NSString*) identifier;
- (NSObject*) returnPropResult: (NSObject*) value;
- (NSObject*) returnLastPropResult: (NSObject*) value;
- (PHPVariableReference*) setVariableReferenceIgnore: (NSObject*) identifier ignore: (NSNumber*) ignore;
- (PHPVariableReference*) setVariableReference: (NSObject*) identifier ignore: (NSNumber*) ignore defineInContext: (NSNumber*) defineInContext;
- (NSObject*) returnParameterInput: (NSObject*) values;
- (NSObject*) returnParameterInputIdentifierValue: (NSObject*) valueIdentifier value: (NSObject*) value;
- (NSObject*) collectParameters: (NSMutableArray*) values;
- (PHPScriptFunction*) callNewOperator: (NSObject*) scriptFunction;
- (NSObject*) callScriptFunctionSubReference: (NSObject*) scriptFunction parameterValues: (NSMutableArray*) parameterValues awaited: (NSObject*) awaited returnObject: (NSNumber*) returnObject;
- (void) callScriptFunctionSub: (NSObject*) __weak scriptFunction parameterValues: (NSMutableArray*) __weak parameterValues awaited: (NSObject*) awaited returnObject: (NSNumber*) returnObject interpretation: (PHPInterpretation*) preserveContext callback: (id) callback;
//- (NSObject*) callScriptFunctionSub: (NSObject*) scriptFunction parameterValues: (NSMutableArray*) parameterValues awaited: (NSObject*) awaited returnObject: (NSNumber*) returnObject interpretation: (PHPInterpretation*) interpretation;
- (PHPScriptObject*) concat: (PHPScriptObject*) concatAdditionObject;
- (PHPScriptObject*) slice: (NSNumber*) start stop: (NSNumber*) stop;
- (void) sort: (PHPScriptFunction*) callback;
- (NSObject*) callScriptFunction: (PHPVariableReference*) identifierReference parameterValues: (NSMutableArray*) parameterValues awaited: (NSNumber*) awaited;
- (PHPScriptObject*) createScriptObject: (NSObject*) values;
- (void) deleteProperty: (NSString*) identifier;
- (void) deletePropertyReference: (NSObject*) variableReference;
- (NSNumber*) makeIntoNumber: (NSObject*) value;
- (NSString*) makeIntoString: (NSObject*) value;
- (void) makeIntoVariableString: (NSString*) variable;
- (NSNumber*) negativeValue: (NSObject*) valueA;
- (NSNumber*) negateValue: (NSObject*) valueA;
- (NSNumber*) comparePHPVariable: (PHPScriptVariable*) a b: (PHPScriptVariable*) b;
- (NSNumber*) equalsSub: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSNumber*) equals: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSNumber*) inequality: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSNumber*) inequalityStrong: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSNumber*) equalsStrong: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSNumber*) greater: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSNumber*) less: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSNumber*) greaterEquals: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSNumber*) lessEquals: (NSObject*) valueA valueB: (NSObject*) valueB;
- (void) andCondition: (NSObject*) valueA valueB: (NSObject*) valueB callback: (id) callback;
- (void) orCondition: (NSObject*) valueA valueB: (NSObject*) valueB callback: (id) callback;
/*- (NSNumber*) andCondition: (NSObject*) valueA valueB: (NSObject*) valueB;
- (NSNumber*) orCondition: (NSObject*) valueA valueB: (NSObject*) valueB;*/
- (NSObject*) removeParanthesis: (NSObject*) valueA;
- (NSObject*) resolveValueArray: (NSObject*) values;
- (NSObject*) returnResultReference: (NSObject*) value;
- (NSObject*) returnResultDereference: (NSObject*) value;
- (NSObject*) returnResult: (NSObject*) value b: (NSObject*) b;
- (NSObject*) cloneObject: (NSObject*) object;
- (PHPScriptObject*) copyScriptObject;
- (NSObject*) parseInputVariable: (NSObject*) input;
- (void) addResetableParseObject: (NSObject*) input;
@end
