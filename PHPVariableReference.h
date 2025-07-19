//
//  PHPVariableReference.h
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//

#import <Foundation/Foundation.h>
@class PHPScriptFunction;
@class PHPScriptObject;
@class PHPInterpretation;

@interface PHPVariableReference : NSObject
//@property(nonatomic) NSDictionary* language;
@property(nonatomic) NSString* identifier;
@property(nonatomic) PHPScriptObject* /*__weak*/ context; //var adur PHPScriptFunction
@property(nonatomic) bool isProperty;
@property(nonatomic) bool defineInContext;
@property(nonatomic) bool ignoreSetContext;
@property(nonatomic) PHPScriptFunction* /*__weak*/ currentContext;
@property(nonatomic) NSObject* /*__weak*/ itemValue;
@property(nonatomic) NSObject* /*__weak*/ itemContainer;
- (void) construct: (NSString*) identifier context: (PHPScriptObject*) context isProperty: (NSNumber*) isProperty defineInContext: (NSNumber*) defineInContext ignoreSetContext: (NSNumber*) ignoreSetContext;
//- (NSObject*) get;
- (NSObject*) get: (PHPScriptFunction*) context;
- (void) set: (NSObject*) value context: (PHPScriptFunction*) context;
@end
/*
 public $identifier;
 public $context;
 public $is_property = false;
 public $define_in_context = false;
 private $ignore_set_context = false;
 */
