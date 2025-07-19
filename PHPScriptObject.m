//
//  PHPScriptObject.m
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//


#import "PHPScriptObject.h"
#import "PHPScriptFunction.h"
#import "PHPVariableReference.h"
#import "PHPScriptVariable.h"
#import "PHPReturnResult.h"
#import "PHPScriptEvaluationReference.h"
#import "PHPValuesOperator.h"
#import "PHPInterpretation.h"
//#import "PHPCallbackReference.h"
//#import "CRRouteCompletionBlock"
//#import "CRResponse"

@implementation PHPScriptObject

- (void) removeItem: (NSObject*) item {
    NSObject* dict = [self getDictionary];
    @synchronized (dict) {
        if([dict isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray* arr = (NSMutableArray*)dict;
            [arr removeObject:item];
        } else {
            NSMutableDictionary* dictArr = (NSMutableDictionary*)dict;
            NSArray* keys = [dictArr allKeysForObject:item];
            for(NSObject* key in keys) {
                [dictArr removeObjectForKey:key];
            }
        }
    }
}

/*- (NSObject*) getCacheValue {
    if([self cacheArr] != nil) {
        return [self cacheArr];
    }
    if([self cacheDict] != nil) {
        return [self cacheDict];
    }
    return nil;
}*/
- (void) initArrays {
    [self setReverseIteratorSet:false];
    [self setNextKey:0];
    [self setDictionaryKeys:[[NSMutableArray alloc] init]];
    [self setDictionary:[[NSMutableDictionary alloc] init]];
    [self setDictionaryArray:[[NSMutableArray alloc] init]];
    [self setDictionaryAux:[[NSMutableArray alloc] init]];
    [self setAccessFlags:[[NSMutableDictionary alloc] init]];
}
/*-(id)copyWithZone:(NSZone *)zone {
    PHPScriptFunction* result = [[PHPScriptFunction alloc] init];*/
    /*[self setDictionary: [[self dictionary] copyWithZone:zone]];
    [self setDictionaryArray: [[self dictionaryArray] copyWithZone:zone]];
    [self setDictionaryAux: [[self dictionaryAux] copyWithZone:zone]];
    [self setAccessFlags: [[self accessFlags] copyWithZone:zone]];*/
    /*result.dictionary = [self.dictionary copyWithZone:zone];
    result.dictionaryAux = [self.dictionaryAux copyWithZone:zone];
    result.dictionaryArray = [self.dictionaryArray copyWithZone:zone];
    result.accessFlags = [self.accessFlags copyWithZone:zone];*/
    /*[result setDictionary:[[NSMutableDictionary alloc] initWithDictionary:[self dictionary]]];
    [result setDictionaryAux:[[NSMutableArray alloc] initWithArray:[self dictionaryAux]]];
    [result setDictionaryArray:[[NSMutableArray alloc] initWithArray:[self dictionaryArray]]];
    [result setAccessFlags:[[NSMutableDictionary alloc] initWithDictionary:[self accessFlags]]];*/
    /*
    result.dictionary = [[NSMutableDictionary alloc] initWithDictionary:[self dictionary]];
    result.dictionaryAux = [[NSMutableArray alloc] initWithArray:[self dictionaryAux]];
    result.dictionaryArray = [[NSMutableArray alloc] initWithArray:[self dictionaryArray]];
    result.accessFlags = [[NSMutableDictionary alloc] initWithDictionary:[self accessFlags]];
    return result;
}*/
/*- (NSString*) description {
    NSString* result = @"arr";*/
    /*int counter = 0;
    for(NSString* key in [self dictionary]) {
        if(counter > 0) {
            [result stringByAppendingString:@","];
        }
        [result stringByAppendingString:[self dictionary][key]];
        counter++;
    }*/
    /*return result;
}*/
- (PHPScriptFunction*) currentObjectFunctionContext {
    if([self currentFunctionContext] != nil) {
        return [self currentFunctionContext];
    }
    return [self parentContext];
}

- (PHPInterpretation*) getInterpretation {
    
    if([self interpretationForObject] != nil) {
        return [self interpretationForObject];
    }
    if([self interpretation] != nil) {
        return [self interpretation];
    }
    if(![[self parentContext] isKindOfClass:[PHPScriptFunction class]]) {
        ////////////NSLog(@"parentContext is: %@", [[self parentContext] class]);
        ////////////NSLog(@"self is : %@ - %@ - %@  - %@", [self identifier], [self dictionary], self, [self class]);
        if([self isKindOfClass:[PHPScriptFunction class]]) {
            ////////////NSLog(@"self is %@", [(PHPScriptFunction*)self variables]);
        }
    }
    return [[self parentContext] getInterpretation];
    /*if([self parentContext] != nil) {
        if(![[self parentContext] isKindOfClass:[PHPScriptFunction class]]) {
            ////////////NSLog(@"parentContext is: %@", [[self parentContext] class]);
        }
        return [[self parentContext] getInterpretation];
    }
    return nil;*/
    
    /*if([self interpretation] != nil) {
        return [self interpretation];
    }
    if[([self parentContext] isk])
    return [[self parentContext] getInterpretation];*/
}
- (void) setAccessFlag: (NSObject*) accessFlag property: (NSObject*) property {
    if(property == nil) {
        property = NULL;
    }
    //////NSLog(@"set accessflag func : %@ _ %@", accessFlag, property);
    //////////////////////////////////NSLog/@"accessFlag: %@", accessFlag);
    //////////////////////////////////NSLog/@"property: %@", property);
    if([property isKindOfClass:[PHPVariableReference class]]) {
        //NSNumber* numberValue = [[NSNumber alloc] initWithBool:accessFlag];
        NSString* numberValue = (NSString*)accessFlag;
        PHPVariableReference* referenceValue = (PHPVariableReference*)property;
        [[self accessFlags] setValue:numberValue forKey:[referenceValue identifier]];
    } else {
        //////NSLog(@"in func");
        PHPScriptFunction* objectValue = (PHPScriptFunction*) property;
        [objectValue setAccessFlag:accessFlag];
        //[objectValue setAccessFlag:accessFlag property:nil];
    }
}
- (void) callClassConstructor: (NSMutableArray*) parameterValues callback: (id) callback {
    if(parameterValues == nil) {
        parameterValues = [[NSMutableArray alloc] init];
    }
    //////////////////////////////////NSLog/@"inside callClassConstructor: %lu", [[self dictionary] count]);
    for(NSString* key in [self dictionary]) {
        //////////////////////////////////NSLog/@"keys in self dictionary: %@", key);
    }
    /*if([[self dictionary] valueForKey:@"__construct"] != nil) {
        //////////////////////////////////NSLog/@"prototype of construct: %@", [(PHPScriptFunction*)[[self dictionary] valueForKey:@"__construct"] prototype]);
        [self callScriptFunctionSub:[[self dictionary] valueForKey:@"__construct"] parameterValues:parameterValues awaited:nil returnObject:nil interpretation:nil];
        //////////////////////////////////NSLog/@"called __construct");
        //[self callScriptFunctionSub:[[self dictionary] valueForKey:@"__construct"] parameterValues:parameterValues];
    }*/
    PHPScriptFunction* constructor = (PHPScriptFunction*)[self getDictionaryValue:@"__construct" returnReference:@false createIfNotExists:@false context:nil];
    bool cancel = false;
    if([constructor isKindOfClass:[PHPVariableReference class]]) {
        if([[(PHPVariableReference*)constructor get:nil] isKindOfClass:[PHPUndefined class]]) {
            cancel = true;
        }
    }
    if(constructor != nil && !cancel) {
        //[self setCurrentFunctionContext:constructor];
        [self callScriptFunctionSub:constructor parameterValues:parameterValues awaited:nil returnObject:nil interpretation:nil callback:callback];
    } else {
        ((void(^)(NSObject*))callback)(nil);
        callback = nil; //VIP SETJA NIL A OLL CALLBACKS eftir kall
        //callback();
    }
}
/*- (NSString*) getClassIdentifierFromClass {
    PHPScriptFunction* parentContext = [[self originalClass] parentContext];
    return [parentContext getClassIdentifier:[self originalClass]];
}
- (bool) instanceOf: (NSString*) className {
    if([self getClassIdentifierFromClass] == className) {
        return true;
    }
    if([self prototype] != nil) {
        return [[self prototype] instanceOf:className];
    }
    return false;
}*/
- (NSString*) getClassIdentifierFromClass {
    /*PHPScriptFunction* parentContext = [[self originalClass] parentContext];
    return [parentContext getClassIdentifier:[self originalClass]];*/
    /*////NSLog(@"class identifier : %@", [self classIdentifierValue]);
    ////NSLog(@"original class : %@")*/
    return [[self originalClass] classIdentifierValue];
}
- (bool) instanceOf: (NSString*) className {
    //////NSLog(@"classIdentifier is : %@ - %@", [self getClassIdentifierFromClass], className);
    if([[self getClassIdentifierFromClass] isEqualToString:className]) {
        return true;
    }
    if([self prototype] != nil) {
        return [[self prototype] instanceOf:className];
    }
    return false;
}
/*- (void) setOriginalClass: (PHPScriptObject*) class {
    [self setOriginalClass:class];
}*/
- (PHPScriptObject*) getNewInstance: (PHPScriptFunction*) context {
    //return self;
    //////////////////////////////////NSLog/@"called get New instance: %@", self);
    //NSMutableArray* functions = [[NSMutableArray alloc] init];
    /*for(NSObject* key in [self dictionary]) {
        NSObject* value = [self dictionary][key];
        if([value isKindOfClass:[PHPScriptFunction class]]) {
            
            ////NSLog(@"--prototype function is : %@ - %@", [(PHPScriptFunction*)value debugText], self);
        }
    }*/
    /*for(NSObject* key in [prototypeClone dictionary]) {
         NSObject* value = [self dictionary][key];
         if([value isKindOfClass:[PHPScriptFunction class]]) {
             if([functions containsObject:key]) {
                 PHPScriptFunction* valueFunction = (PHPScriptFunction*)value;
                 
             }
         }
     }*/
    NSMutableDictionary* functions = [[NSMutableDictionary alloc] init];
    PHPScriptObject* prototypeClone = nil;
    if([self prototype] != nil && [self prototype] != NULL) {
        //////////////////////////////////NSLog/@"has prototype: %@", [self prototype]);
        prototypeClone = [[self prototype] getNewInstance: context];
        
        /*for(NSObject* key in [prototypeClone dictionary]) {
            NSObject* value = [prototypeClone dictionary][key];
            if([value isKindOfClass:[PHPScriptFunction class]]) {
                functions[key] = value;
                //////NSLog(@"prototype function is : %@", [(PHPScriptFunction*)value debugText]);
            }
        }*/
    }
    PHPScriptObject* selfClone = [self copyScriptObject];
    
    //tekut:
    ////////////NSLog(@"ins1: %@", context);
    //[selfClone setParentContext:context];
    //[selfClone setParentContext:context];
    [selfClone setParentContextStrong:context];
    //baetithessuvid:
    [selfClone setInterpretation:[context getInterpretation]];
    ////////////NSLog(@"set for class interpretation is: %@", [selfClone interpretation]);
    [selfClone setInterpretationForObject:[context getInterpretation]];
    
    //////////////////////////////////NSLog/@"has copied");
    if(prototypeClone != nil) {
        [selfClone setPrototype:prototypeClone];
        [prototypeClone setInstanceItem:selfClone];
    } else {
        [selfClone setPrototype:nil];
    }
    //for(NSObject* dictionaryValue in [selfClone getDictionaryValues]) {
    NSMutableDictionary* newDictionary = [[NSMutableDictionary alloc] init];
    for(NSObject* key in [selfClone dictionary]) {
        NSObject* dictionaryValue = [selfClone dictionary][key];
        //////////////////////////////////NSLog/@"self clone dict value: %@", dictionaryValue);
        if([dictionaryValue isKindOfClass:[PHPScriptFunction class]]) {
            dictionaryValue = [(PHPScriptFunction*)dictionaryValue copyScriptFunction];
            [(PHPScriptFunction*)dictionaryValue setPrototype:selfClone];
            ////////////NSLog(@"ins2: %@", context);
            [(PHPScriptFunction*)dictionaryValue setParentContext:context];
            [(PHPScriptFunction*)dictionaryValue setParentContextStrong:context];
            //////////////////////////////////NSLog/@"set selfclone as prototype: %@", selfClone);
            //////////////////////////////////NSLog/@"set selfclone as prototype: %@", [(PHPScriptFunction*)dictionaryValue prototype]);
            /*if(functions[key] != nil) {
                [(PHPScriptFunction*)dictionaryValue setPreviousClassFunction:functions[key]];
            }*/
        } else if([dictionaryValue isKindOfClass:[PHPScriptObject class]]) {
            dictionaryValue = [(PHPScriptObject*)dictionaryValue copyScriptObject];
        } else if([dictionaryValue isKindOfClass:[NSString class]]) {
            dictionaryValue = [[NSString alloc] initWithString:dictionaryValue];//[(NSString*)dictionaryValue mutableCopy];
        } else if([dictionaryValue isKindOfClass:[NSNumber class]]) {
            dictionaryValue = [[NSNumber alloc] initWithDouble:[(NSNumber*)dictionaryValue doubleValue]];//[(NSNumber*)dictionaryValue mutableCopy];
        }
        
        newDictionary[key] = dictionaryValue;
    }
    [selfClone setDictionary:newDictionary];
    
    
    [selfClone setOriginalClass:self];
    //////////////////////////////////NSLog/@"has copied2");
    return selfClone;
   /* NSError* error;
    PHPScriptObject* prototype = [self prototype];
    [self setPrototype:nil];
    PHPScriptFunction* parentContext = [self parentContext];
    [self setParentContext:nil];
    //NSData* buffer = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:&error];
    //PHPScriptObject* selfClone = [NSKeyedUnarchiver unarchivedObjectOfClass:[PHPScriptObject class] fromData:buffer error:&error];
    PHPScriptObject* selfClone = [self copyScriptObject];
    [self setParentContext:parentContext];
    [self setPrototype:prototype];
    [selfClone setParentContext:parentContext];
    //PHPScriptObject* selfClone = self;
    //PHPScriptObject* selfClone = [self copy];
    if(prototypeClone != nil) {
        [selfClone setPrototype:selfClone];
    }*/
    /*for(NSObject* dictionaryValue in [selfClone getDictionaryValues]) {
        if([dictionaryValue isKindOfClass:[PHPScriptFunction class]]) {
            PHPScriptFunction* dictionaryValueFunction = (PHPScriptFunction*)dictionaryValue;
            [dictionaryValueFunction setPrototype:selfClone];
        }
    }*/
}
- (PHPInterpretation*) getIntepretationRecursive {
   /* if([self interpretation] != nil) {
        return [self interpretation];
    }
    if([self parentContext] != nil) {
        return [[self parentContext] getIntepretationRecursive];
    }
    return nil;*/
    return [self getInterpretation];
}
- (PHPScriptObject*) copyScriptObject {
    PHPScriptObject* result = [[PHPScriptObject alloc] init];
    //[result initArrays];
    /*@property(nonatomic) PHPScriptFunction* parentContext;
     @property(nonatomic) bool isArray;
     @property(nonatomic) NSMutableDictionary* dictionary;
     @property(nonatomic) NSMutableArray* dictionaryArray;
     @property(nonatomic) NSMutableArray* dictionaryAux;
     @property(nonatomic) PHPScriptObject* prototype;
     @property(nonatomic) NSMutableDictionary* accessFlags; //NSDictionary;
     @property(nonatomic) PHPScriptObject* originalClass;
     @property(nonatomic) NSString* identifier;
     @property(nonatomic) PHPInterpretation* interpretation;
     @property(nonatomic) PHPScriptObject* parentClass;*/
    ////////////NSLog(@"ins3: %@", [self parentContext]);
    
    /*test_a*/
    //[result setParentContext:[self parentContext]];
    
    //[result setParentContext:[self parentContext]];
    //[result setParentContext:[self parentContext]];
    [result setIsArray:[self isArray]];
    [result setDictionaryKeys:[[NSMutableArray alloc] initWithArray:[self dictionaryKeys]]];
    [result setDictionary:[[NSMutableDictionary alloc] initWithDictionary:[self dictionary]]];
    [result setDictionaryArray:[[NSMutableArray alloc] initWithArray:[self dictionaryArray]]];
    [result setDictionaryAux:[[NSMutableArray alloc] initWithArray:[self dictionaryAux]]];
    /*[result setDictionary:[self dictionary]];
    [result setDictionaryAux:[self dictionaryAux]];
    [result setDictionaryArray:[self dictionaryArray]];*/
    [result setAccessFlags:[[NSMutableDictionary alloc] initWithDictionary:[self accessFlags]]];
    //[result setPrototype:[self prototype]];
    //[result setOriginalClass:[self originalClass]];
    [result setIdentifier:[self identifier]];
    /*if([self parentContext] != nil) {
        [result setInterpretationForObject:[[self parentContext] getInterpretation]];
        [result setInterpretation:[[self parentContext] getInterpretation]];
    } else {*/
        [result setInterpretation:[self getInterpretation]];
    //}
    //[result setParentClass:[self parentClass]];
    
    /*
     @property(nonatomic) PHPScriptFunction* parentContext;
     @property(nonatomic) bool isArray;
     @property(nonatomic) NSMutableDictionary* dictionary;
     @property(nonatomic) NSMutableArray* dictionaryArray;
     @property(nonatomic) NSMutableArray* dictionaryAux;
     @property(nonatomic) PHPScriptObject* prototype;
     @property(nonatomic) NSDictionary* accessFlags;
     @property(nonatomic) PHPScriptObject* originalClass;
     @property(nonatomic) NSString* identifier;
     @property(nonatomic) PHPInterpretation* interpretation;
     @property(nonatomic) PHPScriptObject* parentClass;
     */
    /*[result setParentContext:[self parentContext]];
    [result setIsArray:[self isArray]];
    [result setDictionary:[[NSMutableDictionary alloc] initWithDictionary:[self dictionary]]];
    [result setDictionaryArray:[[NSMutableArray alloc] initWithArray:[self dictionaryArray]]];
    //[result setDictionaryAux:[[NSMutableArray alloc] initWithArray:[self dictionaryAux]]];
    //[result setPrototype:[self prototype]];
    [result setAccessFlags:[[NSDictionary alloc] initWithDictionary:[self accessFlags]]];
    //[result setOriginalClass:[self originalClass]];
    [result setIdentifier:[self identifier]];
    [result setInterpretation:[self interpretation]];
    //[result setParentClass:[self parentClass]];*/
    //[result setParentContext:[self parentContext]];
    //[result setIsArray:[self isArray]];
    return result;
}
- (PHPScriptObject*) setClassReference: (NSString*) identifier {
    return [[self parentContext] setClassReference:identifier];
}
- (PHPScriptFunction*) createNamedScriptFunction: (PHPScriptObject*) class {
    PHPScriptFunction* scriptFunction = [[PHPScriptFunction alloc] init];
    [scriptFunction initArrays];
    ////////////NSLog(@"ins4: %@", [self parentContext]);
    [scriptFunction setParentContext:[self parentContext]];
    
    //prufa ad taka ut?
    [scriptFunction setParentContextStrong:[self parentContext]];
    [scriptFunction setClassValueClass:self];
    return scriptFunction;
}
//$value='undefined', $define_in_context=true, $input_parameter=false, $override_this=false
- (NSObject*) setVariableValueInContext: (NSObject*) name value: (NSObject*) value defineInContext: (NSNumber*) defineInContext inputParameter: (NSNumber*) inputParameter overrideThis: (NSNumber*) overrideThis context: (PHPScriptFunction*) context {
    //////////////////////////////////NSLog/@"in phpscriptobject");
    //////////////////////////////////NSLog/@"setVariableValueInContext name: %@", name);
    //////////////////////////////////NSLog/@"setVariableValueInContext value: %@", value);
    if(value == nil || value == NULL) {
        value = [[PHPUndefined alloc] init]; //initWithString:@"undefined"
    }
    if(defineInContext == nil) {
        defineInContext = @true; //ath-
    }
    if(inputParameter == nil) {
        //inputParameter = NULL;
    }
    if(overrideThis == nil) {
        overrideThis = @false;
    }
    //////NSLog(@"setVariableValueInContext name : %@ value: %@", name, value);
    [self setDictionaryValue:name value:value context:context];
    //[[self dictionary] setValue:value forKey:name];
    //PHPVariableReference* ref = [PHPVariableReference alloc];
    //return ref;
    return [self setVariableReference:name ignore:nil defineInContext:nil];
    //return [self setVariableReferenceIgnore:name ignore:nil];//[self setVariableReference:name];
}
//- (void) setIdentifier:(NSString *)identifier
- (NSNumber*) return_boolean_true {
    NSNumber* returnValue = [[NSNumber alloc] initWithBool:true];
    return returnValue;
}
- (NSNumber*) return_boolean_false {
    NSNumber* returnValue = [[NSNumber alloc] initWithBool:false];
    return returnValue;
}
- (void) setObjectIdentifier: (NSObject*) identifier {
    //////////////////////////////////NSLog/@"set object identifier: %@", identifier);
    if([self parentContext] != nil) {
        //////////////////////////////////NSLog/@"has parent context");
    }
    [[self parentContext] setClassValue:(NSString*)identifier scriptObject:self];
}
- (void) construct: (PHPScriptFunction*) parentContext { // interpretation: (PHPInterpretation*) interpretation
    if(parentContext == nil) {
        parentContext = [self parentContext];
    }
    /*if(parentContext == nil || parentContext == NULL) {
        //////////////////////NSLog/@"set parent context %@", parentContext);
    }*/
    ////////////NSLog(@"ins5: %@", parentContext);
    //tekut_d test_d
    if([self isKindOfClass:[PHPScriptFunction class]]) {
        //prufa ad taka ut?
        [self setParentContextStrong:parentContext];
    }
    [self setParentContext:parentContext]; //ekki fjarlaegja
    /*if([self parentContext] != nil) {
        [self setPrototype:[[self parentContext]]
    }*/
}
- (void) setClassExtends: (PHPScriptObject*) class {
    [self setParentClass:class];
}
//- (void) setPrototype:(PHPScriptObject *)prototype
/*- (PHPScriptObject*) getPrototype {
    
}*/
- (PHPVariableReference*) getArrayValueContextReference: (NSObject*) index returnReference: (NSNumber*) returnReference {
    ////NSLog(@"inside getArrayValueContextReference: %@, %@", index, returnReference);
    if(returnReference == nil) {
        returnReference = @true;
    }
    index = [self parseInputVariable:index];
    ////////////////////NSLog(@"returnReference: %@", returnReference);
    PHPVariableReference* result = (PHPVariableReference*)[self getArrayValueContext:index returnReference:returnReference context:nil];
    ////////////////////NSLog(@"getArrayvalueContextReference: %@", result);
    [result setIgnoreSetContext:true];
    return result;
}
- (NSObject*) getArrayValueContext: (NSObject*) index returnReference: (NSNumber*) returnReference context: (PHPScriptFunction*) context {
    
    ////NSLog(@"inside getArrayValueContext: %@, %@", index, returnReference);
    //////////////////////////////NSLog/@"getArrayValueContext: %@", index);
    if([index isKindOfClass:[PHPVariableReference class]]) {
        index = [(PHPVariableReference*)index get:context];
    }
    if([index isKindOfClass:[PHPScriptVariable class]]) {
        index = [(PHPScriptVariable*)index get];
    }
    if([index isKindOfClass:[NSArray class]]) {
        index = [self resolveValueArray:index];
    }
    //@synchronized ([self dictionary]) {
    
    index = [self parseInputVariable:index];
    NSObject* value = [self getDictionaryValue:index returnReference:returnReference createIfNotExists:@true context:context];//createIfNotExists:@true]; // createIfNotExists:@false];//
    //////NSLog(@"getDictionarValue result: %@", value);
    if([value isKindOfClass:[PHPScriptFunction class]]) {
        //////////////////////////////////NSLog/@"inside reset 2");
        //value = [(PHPScriptFunction*)value copyScriptFunction];
        //if(![(PHPScriptFunction*)value isAsync]) {
            //////////////NSLog(@"reset this %@ - %@", self, value);
            [(PHPScriptFunction*)value resetThis:self];
        //}
    }
    return value;
    //}
    return nil;
    //////////////NSLog(@"value: %@", value);
}
- (NSString*) getTypeOf: (NSObject*) value {
    while([value isKindOfClass:[NSArray class]] && [(NSMutableArray*)value count] > 0) {
        value = ((NSMutableArray*)value)[0];
    }
    if([value isKindOfClass:[PHPUndefined class]]) {
        return @"undefined";
    }
    NSString* stringValue = [self makeIntoString:value];
    if(value == nil || value == NULL) { //|| ([stringValue isEqualToString:@"undefined"] && [stringValue isKindOfClass:[PHPUndefined class]])) {
        /*PHPScriptVariable* return_result = [[PHPScriptVariable alloc] init];
        [return_result construct:@"string" value:@"undefined"];
        return return_result;*/
        return @"undefined"; //[[PHPUndefined alloc] init]; //
    }
    if([value isKindOfClass:[PHPScriptVariable class]]) {
        return [self setString:[(PHPScriptVariable*)value datatype]];
    }
    //if(![value isKindOfClass:[NSObject class]] && ![value isKindOfClass:[NSMutableArray class]]) {
    if([value isKindOfClass:[PHPScriptObject class]]) {
        if([value isKindOfClass:[PHPScriptFunction class]]) {
            /*PHPScriptVariable* return_result = [[PHPScriptVariable alloc] init];
            [return_result construct:@"string" value:@"function"];
            return return_result;*/
            
            return @"function";
        } else {
            if(![(PHPScriptObject*)value isArray]) {
                /*PHPScriptVariable* return_result = [[PHPScriptVariable alloc] init];
                [return_result construct:@"string" value:@"array"];
                return return_result;*/
                
                return @"array";
            }
            /*PHPScriptVariable* return_result = [[PHPScriptVariable alloc] init];
            [return_result construct:@"string" value:@"object"];*/
            
            return @"object";
        }
    }
    if([value isKindOfClass:[NSNull class]]) {
        /*PHPScriptVariable* return_result = [[PHPScriptVariable alloc] init];
        [return_result construct:@"string" value:@"NULL"];
        return return_result;*/
        return @"NULL";
    }
    if([value isKindOfClass:[NSNumber class]] && [(NSString*)@([(NSNumber*)value objCType]) isEqualToString:@"c"]) {
        /*PHPScriptVariable* return_result = [[PHPScriptVariable alloc] init];
        [return_result construct:@"string" value:@"boolean"];
        return return_result;*/
        return @"boolean";
    }
    /*PHPScriptVariable* return_result = [[PHPScriptVariable alloc] init];
    [return_result construct:@"string" value:@"number"];
    return return_result;*/
    return @"number";
}
- (void) setArray: (bool) isArray {
    [self setIsArray:isArray];
}
- (void) scriptArrayUnshift: (NSObject*) item {
    item = [self resolveValueReferenceVariableArray:item];
    //////////////////////////////////NSLog/@"script array unshift");
    [[self dictionaryArray] insertObject:item atIndex:0];
}
/*- (NSObject*) scriptArrayShift {
    long index = [[self dictionary] count]-1;
    NSObject* returnItem = [self dictionaryArray][index];
    [[self dictionaryArray] removeObjectAtIndex:index];
    return returnItem;
}*/
- (NSObject*) scriptArrayShift {
    long index = [[self dictionaryArray] count]-1;
    if(index >= 0) {
        NSObject* returnItem = [self dictionaryArray][index];
        [[self dictionaryArray] removeObjectAtIndex:index];
        return returnItem;
    }
    return [[PHPUndefined alloc] init];
}
- (PHPScriptObject*) getParentContext {
    if([self isKindOfClass:[PHPScriptFunction class]]) {
        return self;
    }
    return [self parentContext];
}
- (void) scriptArrayPush: (NSObject*) item {
    //NSLog(@"scriptarraypush item : %@ - %@", item, [self dictionary]);
    @synchronized ([self dictionaryArray]) {
        
        item = [self resolveValueReferenceVariableArray:item];
        /*if([item isKindOfClass:[NSString class]] && [(NSString*)item isEqualToString:@"[]"]) {
            item = [[NSMutableArray alloc] init];
        }*/
        [[self dictionaryArray] addObject:item];
        [self setIsArray:true];
    }
}
- (NSObject*) resolveVariableReturn: (NSObject*) item {
    if([item isKindOfClass:[PHPReturnResult class]]) {
        item = [(PHPReturnResult*)item get];
    }
    if([item isKindOfClass:[PHPVariableReference class]]) {
        item = [(PHPVariableReference*)item get:nil];
    }
    if([item isKindOfClass:[PHPScriptVariable class]]) {
        item = [(PHPScriptVariable*)item get];
    }
    /*if([item isKindOfClass:[NSMutableArray class]]) {
        item = [self resolveValueArray:(NSMutableArray*)item];
    }*/
    return item;
}
- (NSObject*) resolveValueReferenceVariableArray: (NSObject*) item {
    //////////////////////////////////NSLog/@"inside resolveValueReferenceVariableArray %@", item);
    if([item isKindOfClass:[PHPReturnResult class]]) {
        item = [(PHPReturnResult*)item get];
    }
    if([item isKindOfClass:[PHPVariableReference class]]) {
        item = [(PHPVariableReference*)item get:nil];
    }
    if([item isKindOfClass:[PHPScriptVariable class]]) {
        item = [(PHPScriptVariable*)item get];
    }
    if([item isKindOfClass:[NSArray class]]) {
        item = [self resolveValueArray:(NSMutableArray*)item];
    }
    //////////////////////////////////NSLog/@"return: %@", item);
    return item;
}
- (NSObject*) scriptArrayPop {
    long index = 0;//[self dictionary] count]-1;
    if([[self dictionaryArray] count] > index) {
        NSObject* returnItem = [self dictionaryArray][index];
        [[self dictionaryArray] removeObjectAtIndex:index];
        return returnItem;
    } else {
        return [[PHPUndefined alloc] init];
    }
}
- (NSString*) toString {
    return [self toString:self];
    //return @"[object Object]";
}
- (NSString*) join: (NSObject*) delimiter {
    NSString* stringValue;
    if([delimiter isKindOfClass:[PHPScriptVariable class]] && [[(PHPScriptVariable*)delimiter datatype] isEqualToString:@"string"]) {
        stringValue = (NSString*)[(PHPScriptVariable*)delimiter value];
    }
    NSString* result = @"";
    int counter = 0;
    if([self isArray]) {
        for(NSObject* dictionaryItem in [self dictionaryArray]) {
            if(counter > 0) {
                [result stringByAppendingString:[self toString:delimiter]];
            }
            [result stringByAppendingString:[self toString:dictionaryItem]];
            counter++;
        }
    } else {
        for(NSObject* dictionaryItem in [self dictionary]) {
            if(counter > 0) {
                [result stringByAppendingString:[self toString:delimiter]];
            }
            [result stringByAppendingString:[self toString:dictionaryItem]];
            counter++;
        }
    }
    return result;
}
- (NSString*) toString: (NSObject*) value {
    NSString* result = nil;
    if([value isKindOfClass:[PHPScriptVariable class]]) {
        result = (NSString*)[(PHPScriptVariable*)value value];
    } else if([value isKindOfClass:[NSNumber class]]) {
        result = [(NSNumber*)value stringValue];
    } else if([value isKindOfClass:[NSString class]]) {
        result = (NSString*)value;
    } else if([value isKindOfClass:[PHPScriptObject class]]) {
        return @"[object Object]";
    }
    return result;
}
- (NSMutableArray*) reverseArray {
    ////////////////NSLog(@"called reverseArray");
    ////////////////NSLog(@"dictkeys: %@", [self dictionaryKeys]);
    /*////NSLog(@"dict: %@", [self dictionary]);
    ////NSLog(@"dictaux: %@", [self dictionaryAux]);
    ////NSLog(@"dict: %@", [self dictionaryArray]);*/
    NSMutableArray* dictionaryAuxSetValues = [[NSMutableArray alloc] init];
    for(NSObject* item in [self dictionaryAux]) {
        NSObject* itemItem = item;
        if([itemItem isKindOfClass:[NSString class]] && [(NSString*)itemItem isEqualToString:@"[]"]) {
            //NSMutableArray* jsonItem = [[NSMutableArray alloc] init];
            itemItem = [[PHPScriptObject alloc] init];//[[self getInterpretation] makeIntoObjects:jsonItem];
            [(PHPScriptObject*)itemItem initArrays];
            /*test_a*/
            [(PHPScriptObject*)itemItem setParentContext:nil];
            //[(PHPScriptObject*)itemItem setParentContext:[self getParentContext]];
            [(PHPScriptObject*)itemItem setIsArray:true];
            //[(PHPScriptObject*)itemItem setInterpretation:[self interpretation]]
            //////NSLog(@"set arr object");
        }
        [dictionaryAuxSetValues addObject:itemItem];
    }
    [self setDictionaryAux:dictionaryAuxSetValues];
    //////NSLog(@"dictaux: %@", [self dictionaryAux]);
    
    if([[self dictionaryAux] count] > 0) {
        //NSObject* firstKey = [self dictionaryKeys][0];
        //[[self dictionaryKeys] removeObjectAtIndex:0];
        NSObject* firstValue = [self dictionaryAux][0];
        [[self dictionaryAux] removeObjectAtIndex:0];
        NSMutableArray* reverseKeys = [[NSMutableArray alloc] init];
        NSMutableArray* reverseDictionary = [[NSMutableArray alloc] init];
        for(NSObject* item in [[self dictionaryAux] reverseObjectEnumerator]) {
            NSObject* itemItem = item;
            /*if([itemItem isKindOfClass:[NSString class]] && [(NSString*)itemItem isEqualToString:@"[]"]) {
                NSMutableArray* jsonItem = [[NSMutableArray alloc] init];
                itemItem = [[self getInterpretation] makeIntoObjects:jsonItem];
            }*/
            [reverseDictionary addObject:itemItem];
        }
        /*for(NSObject* key in [[self dictionaryKeys] reverseObjectEnumerator]) {
            [reverseKeys addObject:key];
        }*/
        //[self setDictionaryArray:(NSMutableArray*)@[firstValue]];
        NSMutableArray* setDictionaryArrayValue = [[NSMutableArray alloc] init];
        [setDictionaryArrayValue addObject:firstValue];
        [self setDictionaryArray:setDictionaryArrayValue];
        /*for(NSObject* item in reverseDictionary) {
            [[self dictionaryArray] addObject:<#(nonnull id)#>
        }*/
        [[self dictionaryArray] addObjectsFromArray:reverseDictionary];
        /*[self setDictionary:[[NSMutableDictionary alloc] init]];
        int indexDictionary = 0;
        for(NSObject* item in [self dictionaryArray]) {
            NSNumber* dictIndex = @(indexDictionary);
            [self dictionary][[dictIndex stringValue]] = item;
            indexDictionary++;
        }*/
        //[self setDictionary:[[NSMutableDictionary alloc] initWithObjectsAndKeys:<#(nonnull id), ...#>, nil]]
        [self setIsArray:true];
    } else if([[self dictionaryArray] count] > 0) {
        NSMutableArray* keys = [[NSMutableArray alloc] init];//[[self dictionaryArray] index]
        int index = 0;
        for(NSObject* item in [self dictionaryArray]) {
            [keys addObject:@(index)];
            index++;
        }
        //NSMutableArray* keys = [self dictionaryKeys];
        if([keys count] > 0) {
            NSNumber* firstKey = keys[0];
            NSObject* firstValue = [self dictionaryArray][0];
            [[self dictionaryArray] removeObjectAtIndex:0];
            [keys removeObjectAtIndex:0];
            NSMutableArray* keysReversed = [[NSMutableArray alloc] init];
            NSMutableArray* valuesReversed = [[NSMutableArray alloc] init];
            for(NSObject* reverseItem in [keys reverseObjectEnumerator]) {
                [keysReversed addObject:reverseItem];
            }
            for(NSObject* reverseItem in [[self dictionaryArray] reverseObjectEnumerator]) {
                NSObject* itemItem = reverseItem;
                /*if([itemItem isKindOfClass:[NSString class]] && [(NSString*)itemItem isEqualToString:@"[]"]) {
                    NSMutableArray* jsonItem = [[NSMutableArray alloc] init];
                    itemItem = [[self getInterpretation] makeIntoObjects:jsonItem];
                }*/
                [valuesReversed addObject:itemItem];
            }
            [self setDictionaryArray:[[NSMutableArray alloc] init]];
            [[self dictionaryArray] addObject:firstValue];
            for(NSObject* value in valuesReversed) {
                [[self dictionaryArray] addObject:value];
            }
            /*[self setDictionary:[[NSMutableDictionary alloc] init]];
            int indexDictionary = 0;
            for(NSObject* item in [self dictionaryArray]) {
                NSNumber* dictIndex = @(indexDictionary);
                [self dictionary][[dictIndex stringValue]] = item;
                indexDictionary++;
            }*/
        }
    } else if([[self dictionaryKeys] count] > 0) {
        NSMutableArray* keys = [self dictionaryKeys];
        NSObject* firstKey = keys[0];
        [keys removeObjectAtIndex:0];
        
        NSMutableArray* returnKeys = [[NSMutableArray alloc] init];
        [returnKeys addObject:firstKey];
        
        for(NSObject* key in [keys reverseObjectEnumerator]) {
            [returnKeys addObject:key];
        }
        [self setDictionaryKeys:returnKeys];
    }
    ////////////////NSLog(@"dict: %@", [self dictionary]);
    return [self dictionaryArray];
}
- (NSString*) setString: (NSObject*) value {
    /*PHPScriptVariable* scriptVariable = [[PHPScriptVariable alloc] init];
    [scriptVariable setValue:value];
    [scriptVariable setDatatype:@"string"];
    return scriptVariable;*/
    return [self makeIntoString:value];
}
- (NSMutableArray*) setStrings: (NSMutableArray*) values {
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for(NSObject* value in values) {
        [results addObject:[self setString:value]];
    }
    return results;
}
- (NSMutableDictionary*) setStringsDictionary: (NSMutableDictionary*) values {
    for(NSString* key in values) {
        NSObject* value = values[key];
        values[key] = [self setString:value];
    }
    return values;
}
- (NSMutableArray*) getKeys {
    //NSMutableArray* keys = (NSMutableArray*)[[self dictionary] allKeys];
    /*NSMutableArray* keys = [[NSMutableArray alloc] initWithArray:[[self dictionary] keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        obj1 = [[self interpretation] toJSON:obj1];
        obj2 = [[self interpretation] toJSON:obj2];
        NSString* obj1Key = (NSString*)obj1;
        NSString* obj2Key = (NSString*)obj2;
        return [obj1Key compare:obj2Key];
    }]];
    NSMutableArray* returnkeys = [[NSMutableArray alloc] init];
    for(NSString* key in keys) {
        //////////////////////NSLog(@"key value getKeys: %@ - %@", key, [self dictionary][key]);
        if([self dictionary][key] != nil && ![self isUndefined:[self dictionary][key]]) {
            [returnkeys addObject:key];
            //////////////////////NSLog(@"exists");
        }
    }*/
    if([self isArray]) {
        return nil;
    }
    return [self dictionaryKeys];
    //return [[self interpretationForObject] getArrayKeys:[self dictionary]];
}
- (bool) isUndefined: (NSObject*) value {
    if([value isKindOfClass:[PHPUndefined class]]) { //[value isKindOfClass:[NSString class]] && [(NSString*)value isEqualToString:@"undefined"] &&
        return true;
    } else if(value == nil || value == NULL) {
        return true;
    }
    return false;
}
- (NSMutableArray*) getDictionaryValues {
    if([self isArray]) {
        return [self dictionaryArray];
    }
    NSMutableArray* keys = [self getKeys];
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for(NSObject* key in keys) {
        ////////////////NSLog(@"key: %@", key);
        if([self dictionary][key] != nil) {
            ////////////////NSLog(@"value: %@", [self dictionary][key]);
            [result addObject:[self dictionary][key]];
        }
    }
    return result;
    //return (NSMutableArray*)[[self dictionary] allValues];
}
- (NSObject*) getArrayVariableValue: (PHPVariableReference*) identifier index: (NSObject*) index {
    ////////////NSLog(@"getArrayVariableValue: %@ ", identifier);
    index = [self resolveValueReferenceVariableArray:index];
    NSString* identifierName = [identifier identifier];
    PHPScriptObject* array = (PHPScriptObject*)[self getVariableValue:identifierName];
    NSObject* value = [array getDictionaryValue:index returnReference:nil createIfNotExists:nil context:nil];//[array getDictionaryValue:index];
    return value;
}
- (NSObject*) getArrayValue: (PHPVariableReference*) identifier index: (NSObject*) index {
    ////NSLog(@"getArrayValue: %@ ", identifier);
    index = [self resolveValueReferenceVariableArray:index];
    NSString* identifierName = [identifier identifier];
    PHPScriptObject* array = [self getDictionaryValue:identifierName returnReference:nil createIfNotExists:nil context:nil];
    NSObject* value = [array getDictionaryValue:index returnReference:nil createIfNotExists:nil context:nil];
    return value;
}
- (NSObject*) getVariableValue: (NSString*) name {
    //NSLog(@"getVariableValue obj: %@ - %@ - %@ ", name, [self dictionaryArray], @([self isArray]));
    /*if(![name isKindOfClass:[NSString class]]) {
        name = [self parseInputVariable:name];
    }*/
    if([self isArray]) {
        return [self dictionaryArray][[name longLongValue]];
    }
    if([self dictionary][name] != nil) {
        ////////////////NSLog/@"return from dict");
        return [self dictionary][name];
    }
    
    /*if([[[self parentContext] getInterpretation] lastSetFunctionCallingContext] != nil) {
        if([[[[self parentContext] getInterpretation] lastSetFunctionCallingContext] getVariableValue:name] != nil) {
            ////////////////////NSLog/@"return from lastFunctionCallingContext");
            return [[[[self parentContext] getInterpretation] lastSetFunctionCallingContext] getVariableValue:name];
        }
    }*/
    /*if([self parentContext] != nil) {
       
    }*/
    ////////////////NSLog/@"self parentContect - %@", [self parentContext]);
    /*if([self interpretationForObject] != nil) {
        ////////////////NSLog/@"has interpretation context");
        ////////////NSLog(@"get interpretationforobject variable: %@", name);
        return [[[self interpretationForObject] lastSetFunctionCallingContext] getVariableValue:name];
    }*/
    ////////////////NSLog/@"return nil");
    return nil;
}

- (bool) isPrototypeOf: (PHPScriptObject*) prototypeCheck {
    //////////////////////////////////NSLog/@"inside calling isProtoTypeOfX");
    PHPScriptObject* prototype = self;
    //////NSLog(@"prototype : %@ - %@", prototype, prototypeCheck);
    /*////NSLog(@"prototype : %@ - %@", [prototype originalClass], [prototypeCheck originalClass]);
    ////NSLog(@"prototype : %@ - %@", [prototype prototype], [prototypeCheck instanceItem]);
    ////NSLog(@"prototype : %@ - %@", [[prototype prototype] originalClass], [[prototypeCheck instanceItem] originalClass]);*/
    //////////////////////////////////NSLog/@"prototypeCheck: %@", prototypeCheck);
    while(prototype != NULL && prototype != nil) {
        if(prototype == prototypeCheck) {
            return true;
        }
        prototype = [prototype prototype];
    }
    prototype = self;
    while(prototypeCheck != NULL && prototypeCheck != nil) {
        if(prototype == prototypeCheck) {
            return true;
        }
        prototypeCheck = [prototypeCheck prototype];
    }
    return false;
}

- (bool) isPrototypeOfDepr: (PHPScriptObject*) prototypeCheck {
    /*if([prototypeCheck instanceItem] != nil) {
        prototypeCheck = [prototypeCheck instanceItem];
    }*/
    //////////////////////////////////NSLog/@"inside calling isProtoTypeOfX");
    //////NSLog(@"DEBUG %@ proto", prototypeCheck);
    /*while(prototypeCheck != nil) {
        prototypeCheck = [prototypeCheck prototype];
    }*/
    
    
    PHPScriptObject* prototype = self;//[self instanceItem];
    ////NSLog(@"prototype : %@ - %@", [prototype originalClass], [prototypeCheck originalClass]);
    ////NSLog(@"prototype : %@ - %@", [[prototype originalClass] dictionary], [[prototypeCheck originalClass] dictionary]);
    ////NSLog(@"prototype : %@ - %@", prototype, prototypeCheck);
    ////NSLog(@"prototype : %@ - %@", [prototype dictionary], [prototypeCheck dictionary]);
    ////NSLog(@"prototype items : %@ - %@", [prototype instanceItem], [prototypeCheck instanceItem]);
    ////NSLog(@"prototype proto : %@ - %@", [prototype prototype], [prototypeCheck prototype]);
    ////NSLog(@"prototype items : %@ - %@", [[prototype instanceItem] dictionary], [[prototypeCheck prototype] dictionary]);
    ////NSLog(@"prototype items : %@ - %@", [[prototype instanceItem] prototype], [[prototypeCheck prototype] prototype]);
    //////////////////////////////////NSLog/@"prototypeCheck: %@", prototypeCheck);
    /*PHPScriptObject* original = prototypeCheck;
    while(prototypeCheck != nil) {
        if(prototypeCheck == prototype) {
            return true;
        }
        prototypeCheck = [prototypeCheck prototype];
    }*/
    //prototypeCheck = original;
    while(prototype != NULL && prototype != nil) {
        //////NSLog(@"prototype: %@ - %@ - %@ check", prototype, [prototype instanceItem], prototypeCheck);
        if(prototype == prototypeCheck) {
            return true;
        }
        
        prototype = [prototype prototype];
    }
    /*prototype = self;
    while(prototype != NULL && prototype != nil) {
        //////////////////////////////////NSLog/@"prototype: %@", prototype);
        if(prototype == prototypeCheck) {
            return true;
        }
        prototype = [prototype instanceItem];
    }*/
    return false;
}
- (void) printDebug: (NSString*) inputString {
    NSUInteger length = inputString.length;
    unichar buffer[length+1];
    // do not use @selector(getCharacters:) it's unsafe
    [inputString getCharacters:buffer range:NSMakeRange(0, length)];

    for(int i = 0; i < length; i++)
    {
        //////////////////////////////////NSLog/@"%C", buffer[i]);
    }
}
- (NSObject*) getDictionaryValue: (NSObject*) name returnReference: (NSNumber*) returnReference createIfNotExists: (NSNumber*) createIfNotExists context:(PHPScriptFunction*) context {
    ////NSLog(@"getDictionaryValue: %@ - %@ - %@", name, returnReference, createIfNotExists);
    //////////////NSLog(@"inside getDictionaryValue: %@ - %@ - caller: %@", name, [self getIntepretationRecursive], [[self interpretation] lastSetFunctionCallingContext]);
    //////////////////////////////NSLog/@"getDictionaryValue: %@ - %@", name, returnReference);
    //@synchronized (self) {
            
    @synchronized (self) {
        
        PHPScriptObject* caller = self; //[self currentObjectFunctionContext];//[[self getIntepretationRecursive] lastSetFunctionCallingContext];
        if(context != nil) {
            caller = context;
        }
        /*if([name isEqualTo:@"push_callback"]) {
            if([caller isKindOfClass:[PHPScriptFunction class]]) {
                ////NSLog(@"caller body is : %@", [(PHPScriptFunction*)caller debugText]);
                ////NSLog(@"self dict is : %@", [self dictionary]);
            }
            ////NSLog(@"getdictvalue %@ : caller %@ - self %@  caller body: %@", name, caller, self, [caller prototype]);
        }*///[(PHPScriptFunction*)caller debugText]);
        /*if([caller prototype] != nil) {
            caller = [caller prototype];
        }*/
        /*if([self parentContext] != nil) {
            caller = [self parentContext];
        }*/
        if(returnReference == nil) {
            returnReference = @false;
        }
        if(createIfNotExists == nil) {
            createIfNotExists = @true;
            //createIfNotExists = @false;
        }
        //createIfNotExists = @false;
        bool createIfNotExistsBool = [createIfNotExists boolValue];
        bool returnReferenceBool = [returnReference boolValue];
        if([caller isKindOfClass:[PHPScriptFunction class]]) {
            caller = [caller prototype];
        }
        if([name isKindOfClass:[PHPScriptVariable class]]) {
            name = [(PHPScriptVariable*)name get];
        }
        bool isNumeric = false;
        //////////////NSLog(@" return %@ create %@", returnReference, createIfNotExists);
        //////////////////////NSLog/@"name is %@ - %@", name, [name class]);
        /*if([name isKindOfClass:[NSString class]]) {
         //////////////NSLog(@"class %@ name: %@", name, [name class]);
         NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
         //////////////NSLog(@"alphaNums: %@", alphaNums);
         NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:(NSString*)name];
         //////////////NSLog(@"inStringSet: %@", inStringSet);
         //////////////NSLog(@"isNumeric: %@", name);
         isNumeric = [alphaNums isSupersetOfSet:inStringSet];
         //////////////NSLog(@"isNumeric: %i - %@", isNumeric, name);
         } else*/
        //////NSLog(@"in1");
        if([name isKindOfClass:[NSNumber class]] && [self isArray]) {
            //////NSLog(@"in2");
            long index = [(NSNumber*)name longLongValue];
            if(returnReferenceBool) {
                PHPVariableReference* reference = [[PHPVariableReference alloc] init];
                [reference construct:name context:self isProperty:@true defineInContext:nil ignoreSetContext:nil];
                //////NSLog(@"ret0");
                return reference;
            }
            if([[self dictionaryArray] count] <= index) {
                return [[PHPUndefined alloc] init];
            }
            //////NSLog(@"getdict array : %@ - %@ - %@", @(index), [self dictionaryArray], [self dictionaryArray][index]);
            return [self dictionaryArray][index];
        }
        /*if(isNumeric && [self isArray]) {
            //NSNumber* index = @([(NSString*)name longLongValue]);
            long index = [(NSString*)name longLongValue];
            if(returnReferenceBool) {
                PHPVariableReference* reference = [[PHPVariableReference alloc] init];
                [reference construct:name context:self isProperty:@true defineInContext:nil ignoreSetContext:nil];
                return reference;
            }
            return [self dictionaryArray][index];
        }*/
        /*if(![name isKindOfClass:[NSString class]]) {
            ////NSLog(@"in2 _ %@", [self dictionary]);
            //return [self dictionary][name];
            NSObject* intermediateResult = [self dictionary][name];
            ////NSLog(@"return intermediateResult:  %@", intermediateResult);
            return intermediateResult;
            ////////////NSLog(@"is not string object: %@ - %@ - %@", [self dictionary], name, [self identifier]);
        }*/
        NSString* nameString = (NSString*)name;
        if([nameString isKindOfClass:[NSNumber class]]) {
            nameString = [(NSNumber*)name stringValue];
        }
        if([nameString isEqualToString:@"is_array"]) {
            if([self isArray]) {
                return @"true";
            }
            return @"false";
        }
        /*if([nameString isEqualToString:@"set_reverse_iterator"]) {
         if([self reverseIteratorSet]) {
         [self setReverseIteratorSet:false];
         } else {
         [self setReverseIteratorSet:true];
         }
         if([self isArray]) {
         return @"true";
         }
         return @"false";
         }*/
        //////NSLog(@"in3");
        if([self isArray]) {
            //////NSLog(@"in4");
            if([nameString isEqualToString:@"length"]) {
                if([self isArray]) {
                    return @([[self dictionaryArray] count]);
                }
                return @([[self dictionary] count]);
            }
        } else {
            //////NSLog(@"in5");
            if([nameString isEqualToString:@"parent"]) {
                //////NSLog(@"parent is : %@", [self prototype]);
                if([self isKindOfClass:[PHPScriptFunction class]]) {
                    return [[self prototype] prototype];
                }
                return [self prototype];
            } else if([nameString isEqualToString:@"length"]) {
                return @([[[self dictionary] allValues] count]);
            }/* else if([nameString isEqualToString:@"get_dict_next_key"]) {
                
                long startIndex = [[self dictionary] count];
                NSString* startKey = [@(startIndex) stringValue];//[@"tab_" stringByAppendingString:[@(startIndex) stringValue]];
                while([[self dictionary] objectForKey:startKey] != nil) {
                    startIndex++;
                    startKey = [@(startIndex) stringValue];
                }
                PHPScriptVariable* keyResult = [[PHPScriptVariable alloc] init];
                [keyResult setValue:startKey];
                //[self setNextKey:[startKey intValue]];
                return keyResult;
            }*/
        }
        //////NSLog(@"inside getDictionaryValue: %@ - %@", name, self);
        //
        
        if([[self dictionary] objectForKey:nameString] != nil) {
            //////NSLog(@"inside getDictionaryValue1");
            if(returnReferenceBool) {
                PHPVariableReference* reference = [[PHPVariableReference alloc] init];
                [reference construct:nameString context:self isProperty:@true defineInContext:nil ignoreSetContext:nil];
                /*PHPScriptObject* sendContext = self;
                if(context != nil) {
                    sendContext = context;
                }
                
                [reference construct:nameString context:sendContext isProperty:@true defineInContext:nil ignoreSetContext:nil];*/
                 
                
                //////NSLog(@"ret1");
                return reference;
            }
            //////NSLog(@"dict key : %@", nameString);
            NSString* accessFlag = @"public";
            //////NSLog(@"self accessflags : %@ - %@", [self accessFlags], [self dictionary]);
            if([[self accessFlags] objectForKey:nameString] != nil) {
                accessFlag = [self accessFlags][nameString];
                //////////////////////////////////NSLog/@"accessFlags: %@", [self accessFlags]);
            }
            //////NSLog(@"accessflag from dict : %@", accessFlag);
            NSObject* result = [self dictionary][nameString];
            if([result isKindOfClass:[PHPScriptFunction class]]) {
                accessFlag = [(PHPScriptFunction*)result accessFlag];
                //////NSLog(@"accessflag from PHPScriptFunction : %@", accessFlag);
            }
            //////////////////////////////////NSLog/@"accessFlag: %@", accessFlag);
            //[self printDebug:accessFlag];
            //////////////////////////////////NSLog/@"string");
            //[self printDebug:@"protected"];
            accessFlag = [accessFlag stringByReplacingOccurrencesOfString:@" " withString:@""];
            //////////////////////////////////NSLog/@"caller: %@", caller);
            /*if([accessFlag isEqualToString:@"protected"] && [caller isPrototypeOf:self]) { //
             //////////////////////////////////NSLog/@"is EQUAL");
             //return result;
             } else {
             //////////////////////////////////NSLog/@"is not equal");
             }*/
            //
            /*if([accessFlag isEqualToString:@"private"]) {
                caller = [self currentObjectFunctionContext];
                if([caller isKindOfClass:[PHPScriptFunction class]]) {
                    caller = [caller prototype];
                }
            }*/
            bool isPrototype = [caller isPrototypeOf:self];
            if(!isPrototype) {
                isPrototype = [self isPrototypeOf:caller];
            }
            //////NSLog(@"protection level result - %@ - %@ - %@ - %@ - %@ - %@ - %@", @([caller isPrototypeOf:self]), caller, self, [self prototype], name, [caller dictionary], [self dictionary]);
            //////NSLog(@"accessflag : %@", accessFlag);
            if([accessFlag isEqualToString:@"private"]) {
                //////NSLog(@"is private result - %@ - %@ - %@ - %@ - %@", @([caller isPrototypeOf:self]), caller, self, [self prototype], name);
                if(isPrototype) {
                    //
                    return result;
                }
                return [[PHPUndefined alloc] init];
                //return NULL;
            }
            if(accessFlag == NULL || accessFlag == nil || caller == self ||
               (
                ([accessFlag isEqualToString:@"protected"] && isPrototype)
                || [accessFlag isEqualToString:@"public"]
                )
               
               ) {
                return result;
            }
            
            
            //////NSLog(@"is not accessible: %@ - %@ - %@ - %@", name, context, [caller dictionary], [self dictionary]);
            //////////////NSLog(@"is NULL");
            return [[PHPUndefined alloc] init];
            //return NULL;
        } else if(createIfNotExistsBool && returnReferenceBool) {
            //////NSLog(@"inside getDictionaryValue2");
            //[self dictionary][name] = [[PHPUndefined alloc] init]; //tWithString:@"undefined"
            //[[self dictionary] setObject:@"undefined" forKey:nameString];
            PHPVariableReference* reference = [[PHPVariableReference alloc] init];
            [reference construct:nameString context:self isProperty:@true defineInContext:nil ignoreSetContext:nil];
            //////NSLog(@"ret2");
            return reference;
        } else if([self prototype] != nil && [self prototype] != NULL) {
            //////NSLog(@"inside getDictionaryValue3");
            NSString* accessFlag = @"public";
            if([[[self prototype] accessFlags] objectForKey:nameString] != nil) {
                accessFlag = [[self prototype] accessFlags][nameString];
                //////////////////////////////////NSLog/@"accessFlags: %@", [self accessFlags]);
            }
            if(![accessFlag isEqualToString:@"private"]) {
                NSObject* result = [[self prototype] getDictionaryValue:nameString returnReference:returnReference createIfNotExists:@false context:context];
                NSObject* resultItem = result;
                /*if([resultItem isKindOfClass:[PHPVariableReference class]]) {
                    resultItem = [(PHPVariableReference*)resultItem get:context];
                }
                if([resultItem isKindOfClass:[PHPScriptFunction class]]) {
                    accessFlag = [(PHPScriptFunction*)resultItem accessFlag];
                }
                if([accessFlag isEqualToString:@"private"]) {
                    return NULL;
                }*/
                if(result != NULL && result != nil) {
                    return result;
                }
            } else {
                ////NSLog(@"is private");
                return [[PHPUndefined alloc] init];
                //return NULL;
            }
        }
        //////NSLog(@"in6");
        if(createIfNotExists) {
            //////NSLog(@"inside getDictionaryValue4");
            //////NSLog(@"createIfNotExists : %@", nameString);
            [[self dictionary] setObject:[[PHPUndefined alloc] init] forKey:nameString]; //tWithString:@"undefined"
            if(returnReference) {
                PHPVariableReference* reference = [[PHPVariableReference alloc] init];
                [reference construct:nameString context:self isProperty:@true defineInContext:nil ignoreSetContext:nil];
                //[reference construct:nameString context:self isProperty:@true defineInContext:@true ignoreSetContext:nil];
                //////////////////////////////////NSLog/@"ret3");
                return reference;
            }//*/
        }
    }
    //////NSLog(@"return NULL");
    return NULL;
}
- (NSObject*) getDictionary {
    //////////////////////////////////NSLog/@"get dictionaryfunc");
    /*if([self isArray]) {
        //////////////////////////////////NSLog/@"is array");
        NSMutableArray* dictionaryArrayResult = [[NSMutableArray alloc] init];
        for(NSObject* dictionaryValue in [self dictionaryArray]) {
            if([dictionaryValue isKindOfClass:[NSString class]] && [(NSString*)dictionaryValue isEqualToString:@"undefined"]) {
                
            } else {
                [dictionaryArrayResult addObject:dictionaryValue];
            }
        }
        
        return dictionaryArrayResult;
    } else {
        NSMutableDictionary* dictionaryResult = [[NSMutableDictionary alloc] init];
        for(NSString* key in [self getKeys]) {
            NSObject* dictionaryValue = [self dictionary][key];
            if([dictionaryValue isKindOfClass:[NSString class]] && [(NSString*)dictionaryValue isEqualToString:@"undefined"]) {
                
            } else {
                dictionaryResult[key] = dictionaryValue;
            }
        }
        return dictionaryResult;
        //return [self getDictionaryValues];
        //return [self dictionary];
    }*/
    if([self isArray]) {
        return [self dictionaryArray];
    } else {
        return [self dictionary];
    }
}
- (void) setFunction: (NSString*) name function: (PHPScriptFunction*) function {
    [function setPrototype:self];
    //////////////NSLog(@"setFunction: %@ %@", function, name);
    [[self dictionary] setObject:function forKey:name];
}
- (void) setDictionaryValue: (NSObject*) name value: (NSObject*) value context: (PHPScriptFunction*) context {
    //NSLog(@"setDictionaryValue1: %@ %@", name, value);
    if(name == nil) {
        name = NULL;
    }
    if(value == nil) {
        value = NULL;
    }
    //fordebug
    /*if([value isKindOfClass:[PHPScriptFunction class]]) {
        [(PHPScriptFunction*)value setIdentifier:name];
    }*/
    if([value isKindOfClass:[PHPScriptFunction class]]) {
        NSString* nameParsed = name;
        if([name isKindOfClass:[PHPVariableReference class]]) {
            nameParsed = [(PHPVariableReference*)name identifier];
        }
        /*if([nameParsed isKindOfClass:[NSString class]]) {
            nameParsed = nameParsed;
        }*/
        PHPScriptFunction* valueFunction = (PHPScriptFunction*)value;
        if([valueFunction identifier] == nil) {
            [valueFunction setIdentifier:nameParsed];
        }
        /*NSObject* previousValue = [self getDictionaryValue:nameParsed returnReference:@false createIfNotExists:@false];
        if(previousValue != nil && [previousValue isKindOfClass:[PHPScriptFunction class]]) {
            [valueFunction setPreviousClassFunction:(PHPScriptFunction*)previousValue];
        }
        ////NSLog(@"name : %@ - %@", name, previousValue);*/
    }
    //////NSLog(@"setDictionaryValue: %@ - %@", name, value);
    //NSMutableArray* keys = [[self dictionary] allKeys];
    //NSString* lastKey = keys[[keys count]-1];
    if(value == NULL) {
        value = name;
        value = [self resolveValueArray:value];
        [[self dictionaryAux] addObject:value];
        ////////////////////////////////////NSLog/@"setDictionaryValueAux: %@", [self dictionaryAux]);
        /*
        if(valid) {
            [self setDictionaryValue:@([lastKey intValue]) value:value];
        } else {
            //[self setDictionaryValue:@([lastKey intValue) value:value];
        }*/
        return;
    }
    name = [self resolveValueReferenceVariableArray:name];
    name = [self resolveValueArray:name];
    BOOL isNumeric = false;
    if([name isKindOfClass:[NSNumber class]]) {
        isNumeric = true;
    }/* else {
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:(NSString*)[self makeIntoString:name]];
        isNumeric = [alphaNums isSupersetOfSet:inStringSet];
    }*/
    //////////////NSLog(@"setDictionaryValue: %@ - %@", name, value);
    if(isNumeric && [self isArray]) {
        //[self setIsArray:true];
        [self dictionaryArray][[(NSNumber*)name longLongValue]] = value;
        return;
    }
    if([self prototype] != nil) {
        //////NSLog(@"prototype found: %@", [self prototype]);
        //////NSLog(@"has prototype : %@ - %@", name, value);
        PHPVariableReference* varReference = (PHPVariableReference*)[[self prototype] getDictionaryValue:name returnReference:@true createIfNotExists:@false context:context];
        //////NSLog(@"varRef: %@ - %@ - %@", varReference, [varReference get:context], name);
        if(varReference != nil && ![[varReference get:context] isKindOfClass:[PHPUndefined class]]) {
            //////NSLog(@"set varRef : %@", name);
            NSObject* getValue = [varReference get:context];
            bool preventSetVarReference = false;
            if(getValue != nil) {
                if([getValue isKindOfClass:[PHPScriptFunction class]] && [value isKindOfClass:[PHPScriptFunction class]]) {
                    //[(PHPScriptFunction*)value setPreviousClassFunction:(PHPScriptFunction*)getValue];
                    preventSetVarReference = true;
                }
            }
            if(!preventSetVarReference) {
                //////NSLog(@"set VARREF value: %@ - %@", value, varReference);
                //////NSLog(@"set nameVariableReference: %@", [(PHPVariableReference*)name identifier]);
                [varReference set:value context:context];
                return; //?
            }
        }
    }
    value = [self resolveValueArray:value];
    
    ////////////////////////////////NSLog/@"setDictionaryValue: %@ - %@", name, value);
    if([value isKindOfClass:[PHPVariableReference class]]) {
        value = [(PHPVariableReference*)value get:context];
    }
    if([value isKindOfClass:[NSString class]]) {
        NSString* valueString = (NSString*)value;
        if([valueString isEqualToString:@"{}"] || [valueString isEqualToString:@"[]"]) {
            value = [[PHPScriptObject alloc] init];
            [(PHPScriptObject*)value initArrays];
            if([valueString isEqualToString:@"[]"]) {
                [(PHPScriptObject*)value setIsArray:true];
            }
            
            /*test_a*/
            [(PHPScriptObject*)value setParentContext:nil];
            //[(PHPScriptObject*)value setParentContext:[self parentContext]];
        } else if([valueString isEqualToString:@"''"]) {
            /*value = [[PHPScriptVariable alloc] init];
            [(PHPScriptVariable*)value construct:@"string" value:@""];*/
            value = @"";
        }
    }
    if(name == NULL && [value isKindOfClass:[PHPScriptObject class]]) {
        name = [(PHPScriptObject*)value identifier];
    }
    [self setIsArray:false];
    [self addDictionaryKeysItem:name];
    //[[self dictionaryKeys] addObject:name];
    //////NSLog(@"setDictionaryValue: %@ %@", value, name);
    /*if([self dictionary][name] != nil && [[self dictionary][name] isKindOfClass:[PHPScriptFunction class]]) {
        // && [value isKindOfClass:[PHPScriptFunction class]]
        //[(PHPScriptFunction*)value setPreviousClassFunction:[self dictionary][name]];
        ////NSLog(@"name : %@", name);
    }*/
    [[self dictionary] setObject:value forKey:(NSString*)name];
    //////NSLog(@"set var inobject : %@ - %@", name, [self dictionary]);
    //////////////////////////////////NSLog/@"setDictionaryValue: %@", [self dictionary]);
}

- (void) setDictionaryValue: (NSObject*) name value: (NSObject*) value {
    //////NSLog(@"setDictionaryValue2: %@ %@", name, value);
    if(value == nil) {
        value = name;
        value = [self resolveValueArray:value];
        [[self dictionaryAux] addObject:value];
        return;
    }
    value = [self resolveValueArray:value];
    if([value isKindOfClass:[PHPVariableReference class]]) {
        value = [(PHPVariableReference*)value get:nil];
    }
    //value = [self prepareSetValue:value];
    //if([self prototypeIsInline])
    [self dictionary][(NSString*)name] = value;
    ////////////////////////////////NSLog/@"setDictvalueFunc");
}

- (void) addDictionaryKeysItem: (NSObject*) item {
    bool found = false;
    NSString* setKey = (NSString*)item;
    for(NSObject* key in [self dictionaryKeys]) {
        //NSString* keyString = (NSString*)key;
        if([key isEqualTo:setKey]) {
            found = true;
        }
    }
    if(!found) {
        [[self dictionaryKeys] addObject:item];
    }
}

- (PHPScriptFunction*) createScriptFunction: (NSNumber*) isAsync {
    ////////////////////////NSLog(@"is async %@", isAsync);
    if(isAsync == nil) {
        isAsync = @false;
    }
    PHPScriptFunction* scriptFunction = [[PHPScriptFunction alloc] init];
    [scriptFunction initArrays];
    [scriptFunction construct:[self parentContext]];
    //[scriptFunction setIsAsync:isAsync];
    [scriptFunction setPrototype:self]; // :true];
    return scriptFunction;
}
- (PHPVariableReference*) setPropertyReference: (NSString*) identifier {
    PHPVariableReference* variableReference = [[PHPVariableReference alloc] init];
    [variableReference construct:identifier context:self isProperty:@true defineInContext:nil ignoreSetContext:nil];
    return variableReference;
}
- (NSObject*) returnPropResult: (NSObject*) value {
    if(value == nil) {
        value = NULL;
    }
    if([value isKindOfClass:[NSArray class]]) {
        NSMutableArray* valueArray = (NSMutableArray*)value;
        value = valueArray[[valueArray count]-1];
    }
    if([value isKindOfClass:[PHPVariableReference class]]) {
        value = [(PHPVariableReference*)value get:nil];
    }
    return value;
}
- (NSObject*) returnLastPropResult: (NSObject*) value {
    if(value == nil) {
        value = NULL;
    }
    if(value != NULL) {
        NSMutableArray* valueArray = (NSMutableArray*)value;
        value = valueArray[[valueArray count]-1];
        return value;
    }
    return value;
}
- (PHPVariableReference*) setVariableReferenceIgnore: (NSObject*) identifier ignore: (NSNumber*) ignore {
    if(ignore == nil) {
        ignore = @true;
    }
    PHPVariableReference* result = [self setVariableReference:identifier ignore:ignore defineInContext:nil];//[self setVariableReference:identifier ignore:ignore];
    return result;
}
- (PHPVariableReference*) setVariableReference: (NSObject*) identifier ignore: (NSNumber*) ignore defineInContext: (NSNumber*) defineInContext {
    PHPVariableReference* result = [[PHPVariableReference alloc] init];
    NSString* identifierString = [self makeIntoString:identifier];
    //////////////////////////////////NSLog/@"setVariableReference: %@", identifierString);
    if(ignore == nil) {
        ignore = @false;
    }
    if(defineInContext == nil) {
        defineInContext = @false;
    }
    [result construct:identifierString context:self isProperty:@false defineInContext:defineInContext ignoreSetContext:ignore];
    //////////////////////////////////NSLog/@"setVariableReference result: %@", result);
    //////////////////////////////////NSLog/@"setVariableReference result: %@", [result get]);
    //////////////////////////////////NSLog/@"setVariableReference context value: %@", [self getVariableValue:identifier]);
    //////////////////////////////////NSLog/@"setVariableReference context value: %@", [(PHPScriptFunction*)self getVariableValue:identifier]);
    return result;
}
/*public function return_parameter_input($values) {
 var_dump('return_parameter_input', $values);
 return $values;
}
public function return_parameter_input_identifier_value($value_identifier, $value=NULL) {
 var_dump('return_parameter_input_identifier_value', $value_identifier, $value);
 return ['identifier' => $value_identifier, 'value' => $value];
}*/
- (NSObject*) returnParameterInput: (NSObject*) values {
    return values;
}
- (NSObject*) returnParameterInputIdentifierValue: (NSObject*) valueIdentifier value: (NSObject*) value {
    if(value == nil) {
        return valueIdentifier;
    }
    return [[NSMutableDictionary alloc] initWithDictionary:@{
        @"identifier": valueIdentifier,
        @"value": value
    }];
}
- (NSObject*) collectParameters: (NSMutableArray*) values {
    if([values count] == 1) {
        return values;
    }
    NSMutableArray* addition = [[NSMutableArray alloc] init];//(NSMutableArray*)@[values[0]];
    [addition addObject:values[0]];
    NSMutableArray* result = [[NSMutableArray alloc] init];
    [result addObjectsFromArray:addition];
    [result addObjectsFromArray:values[1]];
    NSMutableArray* finalResult = [[NSMutableArray alloc] init];
    for(NSObject* value in result) {
        NSObject* additionValue = value;
        if([value isKindOfClass:[PHPVariableReference class]]) {
            additionValue = [(PHPVariableReference*)value get:nil];
        }
        [finalResult addObject:additionValue];
    }
    return finalResult;
}
- (PHPScriptFunction*) callNewOperator: (NSObject*) scriptFunction {
    /*while([scriptFunction isKindOfClass:[NSMutableArray class]]) {
        scriptFunction = ((NSMutableArray*)scriptFunction)[0];
    }
    if([scriptFunction isKindOfClass:[PHPScriptFunction class]]) {
        [scriptFunction setConstructor:@true];
        return [scriptFunction getObject];
    }
    return scriptFunction;*/
    return nil;
}
- (NSObject*) callScriptFunctionSubReference: (NSObject*) scriptFunction parameterValues: (NSMutableArray*) parameterValues awaited: (NSObject*) awaited returnObject: (NSNumber*) returnObject {
    NSLog(@"call scriptfunciton sub ref");
    ////////////////////////NSLog(@"awaited: %@", awaited);
    if(scriptFunction == nil) {
        scriptFunction = NULL;
    }
    if(parameterValues == nil) {
        parameterValues = [[NSMutableArray alloc] init];
    }
    if(awaited == nil) {
        awaited = @false;
    }
    if(returnObject == nil) {
        returnObject = @true;
    }
    return nil;
    //return [self callScriptFunctionSub:scriptFunction parameterValues:parameterValues awaited:awaited returnObject:returnObject interpretation:nil];
}
- (void) callScriptFunctionSub: (NSObject*) /*__weak*/ scriptFunction parameterValues: (NSMutableArray*) /*__weak*/ parameterValues awaited: (NSObject*) awaited returnObject: (NSNumber*) returnObject interpretation: (PHPInterpretation*) preserveContext callback: (id) /*__weak*/ callbackInput {
    id __block callback = callbackInput;
    /*if([scriptFunction isKindOfClass:[PHPCallbackReference class]]) {
        scriptFunction = [(PHPCallbackReference*)scriptFunction referenceItem];
    }*/
    ////////////////////////////////////NSLog/@" %@, %@, %@, %@", scriptFunction);
    
    ////////////////////////NSLog(@"callScriptFunctionSub: awaited: %@ - par: %@", awaited, parameterValues);
    if(scriptFunction == nil) {
        scriptFunction = NULL;
    }
    if(awaited == nil) {
        awaited = @false;
    }
    if(returnObject == nil) {
        returnObject = @false;
    }
    //////////////////////////////////NSLog/@"callScriptFunctionSub parameters: %@", parameterValues);
    NSNumber* outOfContextFlag = NULL;
    if(([scriptFunction isKindOfClass:[NSArray class]] || scriptFunction == NULL) && [self isKindOfClass:[PHPScriptFunction class]]) {
        ////////////////////////////////NSLog/@"inside is func self");
        if(parameterValues != nil) {
            awaited = (NSObject*)parameterValues;
        } else {
            awaited = @false;
        }
        parameterValues = (NSMutableArray*)scriptFunction;
        
        scriptFunction = self;
    } else {
        if(parameterValues == nil) {
            parameterValues = [[NSMutableArray alloc] init];
        }
    }
    ////////////////////////NSLog(@"callScriptFunctionSub: awaited: %@", awaited);
    if([scriptFunction isKindOfClass:[PHPReturnResult class]]) {
        scriptFunction = [(PHPReturnResult*)scriptFunction get];
    }
    ////////////////////////////////NSLog/@"call script function: %@", parameterValues);
    
    if([scriptFunction isKindOfClass:[PHPScriptFunction class]]) {
        PHPScriptFunction* scriptFunctionFunction = (PHPScriptFunction*)scriptFunction;
        //scriptFunctionFunction = [scriptFunctionFunction copyScriptFunction];
        //NSLog(@"in function: %@", [scriptFunctionFunction identifier]);
        //NSLog(@"in function: %@ - %@", [scriptFunctionFunction identifier], [scriptFunctionFunction debugText]);
        /*if([self isKindOfClass:[PHPScriptFunction class]]) {
            ([(PHPScriptFunction*)self resetResetableParseObjects]);
        }*/
        //[scriptFunctionFunction resetResetableParseObjects];
        if([[scriptFunctionFunction closures] objectForKey:@"main"] != nil) {
            //NSLog(@"in function closure: %@", scriptFunctionFunction);
            //////////////////////////////////NSLog/@"call script closure main");
            //[scriptFunctionFunction setParseObjectCaches:[[NSMutableDictionary alloc] init]];
            //NSLog(@"parameterValues : %@", parameterValues);
            NSObject* resblock = nil;
            @autoreleasepool {
                id closure = (NSObject*(^)(NSObject*, NSObject*))[[scriptFunctionFunction closures] objectForKey:@"main"];
                
                ////////////////////NSLog(@"return closure result %@", ((NSObject*(^)(NSObject*, NSObject*))closure)(parameterValues, scriptFunction));
                resblock = ((NSObject*(^)(NSObject*, NSObject*))closure)(parameterValues, scriptFunctionFunction);
                //NSLog(@"resblock  : %@", resblock);
                if(callback != nil) {
                    //closure = nil;
                    ((void(^)(NSObject*))callback)(resblock);
                    //callback = nil;
                }
                return;
            }
            //return resblock;
        }
        PHPScriptObject* __weak weakSelf = self;
        @autoreleasepool {
            
            if(scriptFunction != NULL) {
                NSMutableArray* additionalParameters = [[NSMutableArray alloc] init];//(NSMutableArray*)@[];
                if(![awaited isKindOfClass:[NSNumber class]] || !awaited) {
                    if([awaited isKindOfClass:[NSArray class]]) {
                        additionalParameters = (NSMutableArray*)awaited;
                    }
                    awaited = @false;
                }
                
                
                /*if([[self parentContext] depthValue] == nil) {
                 [scriptFunctionFunction setDepthValue:@0];
                 } else {
                 [scriptFunctionFunction setDepthValue:@([[[self parentContext] depthValue] longLongValue]+1)];
                 }
                 if([[scriptFunctionFunction depthValue] longLongValue] > 100) {
                 NSLog(@"script function depthvalue reached : %@", scriptFunctionFunction);
                 return @false;
                 }*/
                //NSLog(@"script function depthvalue : %@", [scriptFunctionFunction depthValue]);
                //////NSLog(@"call scriptfunction : %@ - %@", [(PHPScriptFunction*)scriptFunction functionName]);
                /*if([self isKindOfClass:[PHPScriptFunction class]]) {
                 
                 [scriptFunctionFunction setInterpretation:[self getInterpretation]];
                 [scriptFunctionFunction setInterpretationForObject:[self getInterpretation]];
                 } else {
                 PHPScriptFunction* parentContextSelf = [self parentContext];
                 
                 [scriptFunctionFunction setInterpretation:[parentContextSelf getInterpretation]];
                 [scriptFunctionFunction setInterpretationForObject:[parentContextSelf getInterpretation]];
                 }*/
                //[scriptFunctionFunction setVariableValue:@"self_instance" value:scriptFunctionFunction defineInContext:@true inputParameter:@false overrideThis:@false];
                
                bool async_call = false;
                if([scriptFunctionFunction isKindOfClass:[PHPScriptFunction class]]) {
                    ////////////////////////NSLog(@"isAsync: %i - isAwaited %@", [scriptFunctionFunction isAsync], awaited);
                    if([scriptFunctionFunction isAsync] && ![(NSNumber*)awaited boolValue]) {
                        async_call = true;
                    }
                }
                //if(!async_call) {
                    //if([scriptFunctionFunction identifier] == nil) {
                        scriptFunctionFunction = [scriptFunctionFunction copyScriptFunction];
                
                    [scriptFunctionFunction setLastCaller:preserveContext];
                
                    [scriptFunctionFunction setCompletedExecution:false];
                    //}
                    //NSLog(@"call scriptfunction : %@", scriptFunctionFunction);
                    if(returnObject) {
                        //[scriptFunctionFunction setIsConstructor:@true];
                    }
                    //////////////////////////////////NSLog/@"inside reset 3");
                    [scriptFunctionFunction resetThis:nil];
                    if(parameterValues != nil && parameterValues != NULL && [parameterValues count] > 0) {
                        [scriptFunctionFunction setInputVariables:parameterValues[0]];
                    } else {
                        [scriptFunctionFunction setInputVariables:[[NSMutableArray alloc] init]];
                    }
                //}
                ////////////////////NSLog(@"inside1");
                
                //////////////NSLog(@"scriptFunction interpretation: %@", [scriptFunctionFunction getInterpretation]);
                
                ////////////////////////NSLog(@"async_call: %i", async_call);
                //////////////NSLog(@"parentContext7 set is : %@", [self parentContext]);
                //[scriptFunctionFunction setParentContext:[self parentContext]];
                
                //////////NSLog(@"async is: %@ - %@", [self identifier], @(async_call));
                if(async_call) {
                    //[[scriptFunctionFunction parentContext] setInvalidateExecutionCompletion:true];
                    /*PHPInterpretation* interpretationCopy = [[scriptFunctionFunction getInterpretation] copyIntepretation];
                     //[scriptFunctionFunction setInterpretation:[[scriptFunctionFunction getInterpretation] copyIntepretation]];
                     //////////////NSLog(@"interpretation Copy: %@", interpretationCopy);
                     [scriptFunctionFunction setInterpretation:interpretationCopy];
                     [scriptFunctionFunction setInterpretationForObject:interpretationCopy];
                     ////////////NSLog(@"ins8: %@", [interpretationCopy globalContext]);
                     [scriptFunctionFunction setParentContext:[interpretationCopy globalContext]];*/
                    //[[scriptFunctionFunction interpretation] setCurrentContext:scriptFunctionFunction];
                    //////////////NSLog(@"setInterpretCopy scriptFunctionFunction: %@", scriptFunctionFunction);
                    //[[scriptFunctionFunction interpretation] setCurrentContext:scriptFunctionFunction];
                    //[scriptFunctionFunction setInterpretationForObject:[self interpretation]];
                    //[scriptFunctionFunction setParentContext:[[scriptFunctionFunction parentContext] copyScriptFunction]];
                    //[scriptFunctionFunction setInterpretation:[[self interpretation] copyIntepretation]];
                    
                    //////NSLog(@"isASYNC function: %@", [scriptFunctionFunction identifier]);
                    //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    //[[scriptFunctionFunction scriptIndexReference] setIsAsync:false];
                    
                    [[[self getInterpretation] queue] addOperationWithBlock:^{
                        //dispatch_async([[self getInterpretation] messagesQueue], ^{
                        //[[[self getInterpretation] queue] addOperationWithBlock:^{
                        //dispatch_async([scriptFunctionFunction messagesQueue], ^{
                        //[[[scriptFunctionFunction getInterpretation] messagesQueue] addOperationWithBlock:^{
                        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        //Background Thread
                        /*dispatch_async(dispatch_get_main_queue(), ^(void){
                         //Run UI Updates
                         });*/
                        @autoreleasepool {
                            /*@synchronized([(PHPScriptFunction*)scriptFunction retainCountValue]) {
                             @synchronized([(PHPScriptFunction*)scriptFunction callCount]) {*/
                            /*if([(PHPScriptFunction*)scriptFunction callCount] == nil) {
                             [(PHPScriptFunction*)scriptFunction setRetainCountValue: @([[(PHPScriptFunction*)scriptFunction retainCountValue] longLongValue]+1)];
                             } else {
                             //[(PHPScriptFunction*)scriptFunction setRetainCountValue:[(PHPScriptFunction*)scriptFunction callCount]];
                             }*/
                            [[scriptFunctionFunction scriptIndexReference] setIsAsync:true];
                            //NSObject* result =
                            [[scriptFunctionFunction scriptIndexReference] callFun:scriptFunctionFunction callback:^(NSObject* unusedresult) {
                                
                                //[scriptFunctionFunction unset:nil];
                            }];// getCallFun](scriptFunctionFunction);
                            
                            
                            
                            /*if([(PHPScriptFunction*)scriptFunction callCount] == nil) {
                             [(PHPScriptFunction*)scriptFunction setRetainCountValue: @([[(PHPScriptFunction*)scriptFunction retainCountValue] longLongValue]-1)];
                             } else {
                             if([[(PHPScriptFunction*)scriptFunction callCount] longLongValue] != -1) {
                             [(PHPScriptFunction*)scriptFunction setCallCount:@([[(PHPScriptFunction*)scriptFunction callCount] longLongValue]-1)];
                             [(PHPScriptFunction*)scriptFunction setRetainCountValue:[(PHPScriptFunction*)scriptFunction callCount]];
                             }
                             }
                             if([scriptFunctionFunction parentContext] != nil && [[(PHPScriptFunction*)scriptFunction retainCountValue] longLongValue] == 0) {
                             PHPScriptFunction* parentcontext = [scriptFunctionFunction parentContext];
                             [scriptFunctionFunction unset:nil];
                             if([parentcontext isKindOfClass:[PHPScriptFunction class]] && ![[parentcontext identifier] containsString:@"__"]) {
                             [parentcontext canUnset];
                             }
                             } else {*/
                            
                            /*bool containsFunctionDefinition = [[(PHPScriptFunction*)scriptFunctionFunction containsCallbacks] boolValue];
                             if(!containsFunctionDefinition) {
                             [scriptFunctionFunction unset:nil];
                             //[scriptFunctionFunction canUnset];
                             }*/
                            
                            //if([scriptFunctionFunction parentContext] != nil) {
                            //}
                            //[scriptFunctionFunction unset:nil];
                        }
                        /*}
                         }]*/
                        //bool containsFunctionDefinition = false;
                        /*if([[scriptFunctionFunction scriptIndexReference] subObjectDict][@"containsFunctionDefinition"] != nil) {
                         containsFunctionDefinition = true;
                         }
                         if(!async_call && !containsFunctionDefinition) {
                         //NSLog(@"unset");
                         }*/
                        //[scriptFunctionFunction unset:nil];
                        //////NSLog(@"res : %@", result);
                        //[scriptFunctionFunction setVariableValue:@"self_instance" value:scriptFunctionFunction defineInContext:@true inputParameter:@false overrideThis:@false];
                        //});
                    }];
                    //dispatch_async([[self getInterpretation] messagesQueue], ^{
                    if(callback != nil) {
                        ((void(^)(NSObject*))callback)(NULL);
                        //callback = nil;
                    } else {
                        NSLog(@"NO CALLBACK : %@", [scriptFunctionFunction debugText]);
                    }
                    return;
                    //});
                    //}];
                } else {
                    //////NSLog(@"dispatch sync ");
                    
                    /*if(interpretation != nil && interpretation != [scriptFunctionFunction getInterpretation]) {
                     //&& ![[interpretation lastSetFunctionCallingContext] isAsync]
                     ////////////NSLog(@"setToNonConcurrent %@", [scriptFunctionFunction identifier]);
                     dispatch_async([[scriptFunctionFunction getInterpretation] messagesQueue], ^{
                     //dispatch_sync(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                     //////////NSLog(@"dispatch");
                     NSObject* result = [[scriptFunctionFunction scriptIndexReference] getCallFun](scriptFunctionFunction);
                     });
                     
                     //return nil;
                     //[[scriptFunctionFunction getInterpretation] set to queue
                     } else {*/
                    /*if(interpretation != nil && [[interpretation lastSetFunctionCallingContext] isAsync]) {
                     ////////////NSLog(@"set interpretation from parentasync");
                     [scriptFunctionFunction setInterpretation:interpretation];
                     [scriptFunctionFunction setInterpretationForObject:interpretation];
                     ////////////NSLog(@"ins8: %@", [interpretationCopy globalContext]);
                     [scriptFunctionFunction setParentContext:[interpretation globalContext]];
                     //dispatch_sync([interpretation messagesQueue], ^{
                     //NSObject* result = [[scriptFunctionFunction scriptIndexReference] getCallFun](scriptFunctionFunction);
                     //});
                     }*/
                    ////////////NSLog(@"run normally %@ - %@", [scriptFunctionFunction identifier], [self getInterpretation]);
                    //NSObject* __block result;
                    bool perform_function = true;
                    /*NSObject* parameterIndex = @[];
                    if([scriptFunctionFunction cache] != nil && parameterValues != nil && parameterValues != NULL && parameterValues[0] != nil && parameterValues[0][0] != nil) {
                     //////NSLog(@"paramtervalues 0 : %@", parameterValues[0][0]);
                     //////NSLog(@"inter : %@", [self getInterpretation]);
                     parameterIndex = [[self getInterpretation] toJSON:parameterValues[0][0]];
                     if([scriptFunctionFunction cache][parameterIndex] != nil) {
                     result = [scriptFunctionFunction cache][parameterIndex];
                     if([result isKindOfClass:[PHPScriptObject class]]) {
                     result = [(PHPScriptObject*)result copyScriptObject];
                     }
                     perform_function = false;
                     }
                     }*/
                    //////NSLog(@"perform Function : %@ - %@", @(perform_function), parameterIndex);
                    if(perform_function) {
                        /*if([scriptFunctionFunction hasNoReturn]) {
                         ////NSLog(@"DISPATCH SYNC");
                         dispatch_sync([[self getInterpretation] messagesQueue], ^{
                         [[scriptFunctionFunction scriptIndexReference] callFun:scriptFunctionFunction];
                         });
                         return result;
                         } else {
                         result = [[scriptFunctionFunction scriptIndexReference] callFun:scriptFunctionFunction];//
                         }*/
                        if([scriptFunctionFunction isCallback]) {
                            /*if([(PHPScriptFunction*)scriptFunction callCount] == nil) {
                                [(PHPScriptFunction*)scriptFunction setRetainCountValue: @([[(PHPScriptFunction*)scriptFunction retainCountValue] longLongValue]+1)];
                            } else {
                                //[(PHPScriptFunction*)scriptFunction setRetainCountValue:[(PHPScriptFunction*)scriptFunction callCount]];
                            }*/
                            /*if([(PHPScriptFunction*)scriptFunction callCount] == nil) {
                                [(PHPScriptFunction*)scriptFunction setRetainCountValue: @([[(PHPScriptFunction*)scriptFunction retainCountValue] longLongValue]+1)];
                            } else {
                                //[(PHPScriptFunction*)scriptFunction setRetainCountValue:[(PHPScriptFunction*)scriptFunction callCount]];
                            }*/
                        }
                        [scriptFunctionFunction setIsReturnValueItem:true];
                        //NSLog(@"in function call: %@ - %@ - %@", scriptFunctionFunction, [scriptFunctionFunction identifier], [scriptFunctionFunction debugText]);
                        //dispatch_sync([[self getInterpretation] messagesQueue], ^{
                        //@autoreleasepool {
                        //NSLog(@"scriptFunction is : %@", scriptFunctionFunction);
                        //@try {
                        
                        //dispatch_sync([[self getInterpretation] messagesQueue], ^{
                        @autoreleasepool {
                            [[scriptFunctionFunction scriptIndexReference] callFun:scriptFunctionFunction callback:^(NSObject* resultIntermediate) {
                                NSObject* result = resultIntermediate;
                                //NSLog(@"scriptfunc res : %@", result);
                                result = [scriptFunctionFunction returnResultValue];
                                //NSLog(@"scriptfunc res : %@", result);
                                if([returnObject boolValue]) {
                                    result = [scriptFunctionFunction getObject];
                                }
                                /*bool containsFunctionDefinition = [[(PHPScriptFunction*)scriptFunctionFunction containsCallbacks] boolValue];
                                
                                [scriptFunctionFunction setCompletedExecution:true];
                                if(!containsFunctionDefinition) {
                                     [scriptFunctionFunction unset:nil];
                                }*/
                                if(callback != nil) {
                                    
                                    /*if([scriptFunctionFunction cache] != nil) {
                                     [scriptFunctionFunction cache][parameterIndex] = result;
                                     }*/
                                    
                                    [[[self getInterpretation] queue] addOperationWithBlock:^{
                                        //dispatch_async([[weakSelf getInterpretation] messagesQueue], ^{
                                        @autoreleasepool {
                                            ((void(^)(NSObject*))callback)(result);
                                            //callback = nil;
                                        }
                                    }];
                                    //});
                                    
                                }
                            }];
                        }
                        return;
                        //});
                            //[[self mainInterpretation] receiveRequest:message_body callback:callback];
                        /*} @catch (NSException *exception) {
                            NSLog(@"exception : %@ - %@ - %@", exception, [scriptFunctionFunction identifier], [scriptFunctionFunction debugText]);
                        }*/
                        //}
                        //
                        //});
                        //[scriptFunctionFunction invalidateVariableReferences];
                    } else {
                        
                        //((void(^)(NSObject*))callback)(result);
                    } //getCallFun](scriptFunctionFunction);
                    /*int counter = 0;
                    while([additionalParameters count] > 0) {
                        additionalParameters = additionalParameters[0];
                        int intermediate_counter = 0;
                        if(additionalParameters[1] != nil && additionalParameters[1] != NULL) {
                            additionalParameters = additionalParameters[1];
                        } else {
                            additionalParameters = [[NSMutableArray alloc] init];//(NSMutableArray*)@[];
                        }
                        //result =
                        [self callScriptFunctionSub:result parameterValues:additionalParameters awaited:nil returnObject:nil interpretation:preserveContext callback:^(NSObject* resIntermediate) {
                            result = resIntermediate;
                        }];
                        //[self getInterpretation]
                        counter++;
                    }
                    //NSArray* ignoreDebug = @[@"length_value", ];
                    //NSLog(@"end function: %@ - %@", [scriptFunctionFunction identifier], [scriptFunctionFunction debugText]);
                    //[scriptFunctionFunction setParentContext:nil];
                    //NSLog(@"RetainCount: %ld", (CFGetRetainCount((__bridge CFTypeRef) scriptFunctionFunction)));
                    //NSLog(@"retain count : %@", [scriptFunctionFunction performSelector:NSSelectorFromString(@"retainCount")]);
                    if([returnObject boolValue]) {
                        result = [scriptFunctionFunction getObject];
                    }
                    bool containsFunctionDefinition = [[(PHPScriptFunction*)scriptFunctionFunction containsCallbacks] boolValue];
                    
                    [scriptFunctionFunction setCompletedExecution:true];
                    if(!containsFunctionDefinition) {
                        [scriptFunctionFunction unset:nil];
                    }
                    NSLog(@"res : %@", result);
                    if([result isKindOfClass:[PHPReturnResult class]]) {
                        NSLog(@"res : %@", [(PHPReturnResult*)result get]);
                        
                    }
                    ((void(^)(NSObject*))callback)(result);*/
                    //return result;
                    
                    //}
                }
            }
        }
    }
    //////////////////////////////////NSLog/@"return null");
    //return NULL;
}

/*- (bool) containsFunctionValue {
    if([self isKindOfClass:[PHPScriptFunction class]]) {
        PHPScriptFunction* func = self;
        for(NSObject* key in [func variables]) {
            NSObject* value = [func variables][key];
            if([value isKindOfClass:[PHPScriptFunction class]]) {
                return true;
            }
        }
    }
    return false;
}*/

- (void) traverseObject: (NSObject*) input marked: (NSMutableArray*) marked {
    //NSLog(@"input is : %@", input);
    if(input == nil || input == NULL) {
        return;
    }
    if(marked != nil && [marked containsObject:input]) {
        return;
    }
    [marked addObject:input];
    if([input isKindOfClass:[PHPReturnResult class]]) {
        PHPReturnResult* returnResult = (PHPReturnResult*)input;
        NSObject* returnResultvalue = [returnResult get];
        [self traverseObject:returnResultvalue marked:marked];
        //NSLog(@"returnresult value : %@", returnResultvalue);
        /*if([returnResultvalue isKindOfClass:[PHPScriptObject class]]) {
            
            //[(PHPScriptObject*)returnResultvalue setParentContext:nil];
        }*/
        //[self traverseObject:returnResultvalue marked:marked];
        //NSLog(@"returnresult traversedValue : %@", traversedValue);
        //[returnResult setResult:traversedValue];
        return;
    } else if([input isKindOfClass:[PHPScriptFunction class]]) {
        return;
    } else if([input isKindOfClass:[PHPScriptObject class]]) {
        PHPScriptObject* obj = (PHPScriptObject*)input;
        if([obj parentContext] == nil) {
            return;
        }
        [obj setParentContext:nil];
        if(marked != nil) {
            if([obj isArray]) {
                NSArray* arr = [obj getDictionary];
                for(NSObject* arrItem in arr) {
                    [self traverseObject:arrItem marked:marked];
                }
            } else {
                NSDictionary* arr = [obj getDictionary];
                for(NSObject* arrKey in arr) {
                    NSObject* arrItem = arr[arrKey];
                    [self traverseObject:arrItem marked:marked];
                }
            }
        }
    }
    return;
}

- (PHPScriptObject*) concat: (PHPScriptObject*) concatAdditionObject {
    PHPScriptObject* concatResult = [[PHPScriptObject alloc] init];
    [concatResult initArrays];
    [concatResult setArray:true];
    
    /*test_a*/
    [concatResult setParentContext:nil];
    //[concatResult setParentContext:[self getParentContext]];
    if([concatAdditionObject isKindOfClass:[PHPScriptObject class]]) {
        [concatResult setDictionaryArray:[self dictionaryArray]];
        [[concatResult dictionaryArray] addObjectsFromArray:[concatAdditionObject dictionaryArray]];
    }
    return concatResult;
}
- (PHPScriptObject*) slice: (NSNumber*) start stop: (NSNumber*) stop {
    long length = [stop longValue]-[start longValue];
    PHPScriptObject* result = [[PHPScriptObject alloc] init];
    [result initArrays];
    /*test_a*/
    [result setParentContext:nil];
    //[result setParentContext:[self getParentContext]];
    if(length > 0) {
        long index = 0;
        NSMutableArray* arrayResult = [[NSMutableArray alloc] init];
        for(NSObject* item in [self dictionaryArray]) {
            if(index >= [start longValue]) {
                [arrayResult addObject:item];
            }
            if(index >= [stop longValue]) {
                break;
            }
            index++;
        }
        [result setDictionaryArray:arrayResult];
    }
    return result;
}
- (void) sort: (PHPScriptFunction*) callback {
    //[[self dictionaryArray] sortUsingFunction:<#(nonnull NSInteger (*)(id  _Nonnull __strong, id  _Nonnull __strong, void * _Nullable))#> context:<#(nullable void *)#>]
    [[self dictionaryArray] sortUsingComparator:^NSComparisonResult(id  _Nonnull a, id  _Nonnull b) {
        if([a isKindOfClass:[PHPVariableReference class]]) {
            a = [(PHPVariableReference*)a get:nil];
        }
        if([a isKindOfClass:[PHPScriptVariable class]]) {
            a = [(PHPScriptVariable*)a get];
        }
        if([b isKindOfClass:[PHPVariableReference class]]) {
            b = [(PHPVariableReference*)b get:nil];
        }
        if([b isKindOfClass:[PHPScriptVariable class]]) {
            b = [(PHPScriptVariable*)b get];
        }
        NSMutableArray* parameterValuesValue = [[NSMutableArray alloc] init];
        NSMutableArray* parameterValuesValueSub = [[NSMutableArray alloc] init];
        [parameterValuesValueSub addObject:a];
        [parameterValuesValueSub addObject:b];
        [parameterValuesValue addObject:parameterValuesValueSub];
        //(NSMutableArray*)@[@[a, b]]
        //NSObject* result =
        //[callback callCallback:<#(NSArray *)#>]
        NSComparisonResult __block resValue;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [self callScriptFunctionSub:callback parameterValues:parameterValuesValue awaited:nil returnObject:nil interpretation:nil callback:^(NSObject* result) {
            result = [self parseInputVariable:result];
            NSNumber* resultNumber = [self makeIntoNumber:result];
            long resultLong = [resultNumber longValue];
            if(resultLong == -1) {
                resValue = NSOrderedDescending;
            } else if(resultLong == 1) {
                resValue = NSOrderedAscending;
            } else if(resultLong == 0) {
                resValue = NSOrderedSame;
            }
            dispatch_semaphore_signal(sema);
        }];
        /*[self callScriptFunctionSub:callback parameterValues:parameterValuesValue awaited:nil returnObject:nil interpretation:nil];
        result = [self parseInputVariable:result];
        NSNumber* resultNumber = [self makeIntoNumber:result];
        long resultLong = [resultNumber longValue];
        if(resultLong == -1) {
            return NSOrderedDescending;
        } else if(resultLong == 1) {
            return NSOrderedAscending;
        } else if(resultLong == 0) {
            return NSOrderedSame;
        }*/
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        return resValue;
    }];
}
- (NSObject*) callScriptFunction: (PHPVariableReference*) identifierReference parameterValues: (NSMutableArray*) parameterValues awaited: (NSNumber*) awaited {
    ////////////////////////NSLog(@"awaited: %@", awaited);
    return nil;
    if(parameterValues == nil) {
        parameterValues = [[NSMutableArray alloc] init];//(NSMutableArray*)@[];
    }
    if(awaited == nil) {
        awaited = @false;
    }
    NSString* identifierName = [identifierReference identifier];
    //////NSLog(@"identifier : %@", identifierName);
    if([self isArray]) {
        /*if([identifierName isEqualToString:@"sort"]) {
            //////NSLog(@"sort perform");
            [self sort:parameterValues[0][0]];
            return NULL;
        } else if([identifierName isEqualToString:@"slice"]) {
            return [self slice:parameterValues[0][0] stop:parameterValues[0][1]];
        } else if([identifierName isEqualToString:@"concat"]) {
            return [self concat:parameterValues[0][0]];
        } else if([identifierName isEqualToString:@"unshift"]) {
            if(parameterValues[0][0] != nil) {
                [self scriptArrayUnshift:parameterValues[0][0]];
            }
            return NULL;
        } else if([identifierName isEqualToString:@"push"]) {
            if(parameterValues[0][0] != nil) {
                [self scriptArrayPush:parameterValues[0][0]];
            }
            return NULL;
        } else if([identifierName isEqualToString:@"shift"]) {
            return [self scriptArrayShift];
        } else if([identifierName isEqualToString:@"pop"]) {
            return [self scriptArrayPop];
        } else if([identifierName isEqualToString:@"join"]) {
            if(parameterValues[0][0] != nil) {
                NSObject* index = parameterValues[0][0];
                if([index isKindOfClass:[PHPVariableReference class]]) {
                    index = [(PHPVariableReference*)index get];
                }
                if([index isKindOfClass:[NSArray class]]) {
                    index = [self resolveValueArray:index];
                }
                if([index isKindOfClass:[NSString class]]) {
                    return [self join:index];
                }
            }
            return NULL;
        } else if([identifierName isEqualToString:@"splice"]) {
            NSObject* insert = NULL;
            if(parameterValues[0][2] != nil) {
                insert = parameterValues[0][2];
            }
            PHPScriptObject* spliceResult = [[PHPScriptObject alloc] init];
            [spliceResult initArrays];
            if(parameterValues[0][0] != nil && parameterValues[0][1] != nil) {
                NSMutableArray* spliceArray = [[NSMutableArray alloc] init];
                NSNumber* start = (NSNumber*)parameterValues[0][0];
                NSNumber* length = (NSNumber*)parameterValues[0][1];
                long startLong = [start longValue];
                long lengthLong = [length longValue];
                long stop = startLong+lengthLong;
                NSMutableArray* insertArray;
                if(insert != NULL) {
                    insertArray = (NSMutableArray*)insert;
                }
                long index = 0;
                NSMutableIndexSet* indexes = [[NSMutableIndexSet alloc] init];
                for(NSObject* item in [self dictionaryArray]) {
                    if(index >= startLong) {
                        [spliceArray addObject:item];
                        [indexes addIndex:index];
                        //[indexes insertValue:<#(nonnull id)#> inPropertyWithKey:<#(nonnull NSString *)#>]
                        //[indexes addObject:@(index)];
                    }
                    if(index >= stop) {
                        break;
                    }
                    index++;
                }
                [[self dictionaryArray] removeObjectsInArray:spliceArray];
                [[self dictionaryArray] insertObjects:insertArray atIndexes:indexes];
                [spliceResult setDictionaryArray:spliceArray];
                [spliceResult setArray:true];
            }
            return spliceResult;
        } else if([identifierName isEqualToString:@"indexOf"]) {
            if(parameterValues[0][0] != nil) {
                long index = [[self dictionaryArray] indexOfObject:parameterValues[0][0]];
                return @(index);
            }
            return NULL;
        } else if([identifierName isEqualToString:@"toString"]) {
            return [self setString:[self toString]];
        } else {
            
        }*/
    }
    //PHPScriptFunction* scriptFunction = [self getDictionaryValue:identifierName returnReference:nil createIfNotExists:nil context:nil];
    //return [self callScriptFunctionSub:scriptFunction parameterValues:parameterValues awaited:awaited returnObject:false interpretation:nil];
}
- (PHPScriptObject*) createScriptObject: (NSObject*) values {
    PHPScriptObject* scriptObject = [[PHPScriptObject alloc] init];
    [scriptObject initArrays];
    ////////////NSLog(@"createScriptObject1: %@", [self parentContext]);
    //[scriptObject construct:[self parentContext]];
    return scriptObject;
}
- (void) deleteProperty: (NSString*) identifier {
    if([self isArray]) {
        [[self dictionaryArray] removeObjectAtIndex:[[self makeIntoNumber:identifier] unsignedLongValue]];
    } else {
        long index = 0;
        long set_index = -1;
        for(NSObject* key in [self dictionaryKeys]) {
            if([[self makeIntoString:key] isEqualToString:identifier]) {
                set_index = index;
            }
            index++;
        }
        if(set_index != -1) {
            [[self dictionaryKeys] removeObjectAtIndex:set_index];
        }
        [[self dictionary] removeObjectForKey:identifier];
    }
}
- (void) deletePropertyReference: (NSObject*) variableReference {
    while([variableReference isKindOfClass:[NSArray class]]) {
        variableReference = ((NSMutableArray*)variableReference)[0];
    }
    if([variableReference isKindOfClass:[PHPVariableReference class]]) {
        PHPVariableReference* varReference = (PHPVariableReference*)variableReference;
        [[varReference context] deleteProperty:[varReference identifier]];
    }
}
- (NSNumber*) makeIntoNumber: (NSObject*) value {
    if([value isKindOfClass:[NSString class]]) {
        NSString* stringValue = (NSString*)value;
        if([stringValue isEqualToString:@"true"]) {
            return [[NSNumber alloc] initWithBool:true];
        } else if([stringValue isEqualToString:@"false"]) {
            return [[NSNumber alloc] initWithBool:false];
        }/* else if([stringValue isEqualToString:@"undefined"] && [stringValue isKindOfClass:[PHPUndefined class]]) {
            return [[NSNumber alloc] initWithBool:false];
        }*/
        return [[NSNumber alloc] initWithDouble:[(NSString*)value doubleValue]];
    } else if([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    } else if([value isKindOfClass:[PHPUndefined class]]) {
        return [[NSNumber alloc] initWithBool:false];
    }
    return [[NSNumber alloc] initWithDouble:0];
}
- (NSString*) makeIntoString: (NSObject*) value {
    if([value isKindOfClass:[NSString class]]) {
        value = [[NSString alloc] initWithString:(NSString*)value];
        return (NSString*)value;
    } else if([value isKindOfClass:[NSNumber class]]) {
        value = [[NSNumber alloc] initWithDouble:[(NSString*)value doubleValue]];
        return [(NSNumber*)value stringValue];
    }
    return @"";
}
- (void) makeIntoVariableString: (PHPScriptVariable*) variable {
    NSObject* value = [variable get];
    NSString* result;
    if([value isKindOfClass:[NSString class]]) {
        result = (NSString*)value;
    } else if([value isKindOfClass:[NSNumber class]]) {
        result = [(NSNumber*)value stringValue];
    }
    result = @"";
    [variable setValue:result];
}
- (NSNumber*) negativeValue: (NSObject*) valueA {
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    //valueA = [self parseInputVariable:valueA];
    /*if([valueA isKindOfClass:[PHPScriptObject class]] || [valueA isKindOfClass:[PHPScriptFunction class]]) {
        return false;
    }
    NSNumber* result = [self makeIntoNumber:valueA];//(NSNumber*)valueA;
    result = [result initWithBool:![result boolValue]];
    return result;*/
    return @(-[[self makeIntoNumber:valueA] floatValue]);
}
- (NSNumber*) negateValue: (NSObject*) valueA {
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    //valueA = [self parseInputVariable:valueA];
    //NSNumber* result = (NSNumber*)valueA;
    if([valueA isKindOfClass:[PHPScriptObject class]] || [valueA isKindOfClass:[PHPScriptFunction class]]) {
        return @false;
    }
    NSNumber* result = [self makeIntoNumber:valueA];
    result = [[NSNumber alloc] initWithBool:![result boolValue]];
    return result;
}
- (NSNumber*) comparePHPVariable: (PHPScriptVariable*) a b: (PHPScriptVariable*) b {
    /*if([[a value] isEqualTo:[b value]]) {
        return @true;
    }
    return @false;*/
    /*NSString* aString = [self makeIntoString:a];
    NSString* bString = [self makeIntoString:b];*/
    [self makeIntoVariableString:a];
    [self makeIntoVariableString:b];
    if([(NSString*)[a value] isEqualToString:(NSString*)[b value]]) {
        return @true;
    }
    return @false;
}
- (NSNumber*) equalsArrSub: (NSObject*) arrValueA valueB: (NSObject*) arrValueB {
    if([arrValueA isKindOfClass:[arrValueB class]]) {
        if([arrValueA isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dictionaryA = (NSDictionary*)arrValueA;
            NSDictionary* dictionaryB = (NSDictionary*)arrValueB;
            if([dictionaryA count] == [dictionaryB count]) {
                for(NSString* key in dictionaryA) {
                    if([dictionaryB objectForKey:key] != nil) {
                        if(![[self equalsSub:dictionaryA[key] valueB:dictionaryB[key]] boolValue]) {
                            return @false;
                        }
                    } else {
                        return @false;
                    }
                }
            } else {
                return @false;
            }
            return @true;
        } else if([arrValueA isKindOfClass:[NSArray class]]) {
            NSArray* arrayA = (NSArray*)arrValueA;
            NSArray* arrayB = (NSArray*)arrValueB;
            if([arrayA count] == [arrayB count]) {
                int index = 0;
                for(NSObject* itemA in arrayA) {
                    NSObject* itemB = arrayB[index];
                    ////////////////////NSLog(@"compare equals: %@ - %@", itemA, itemB);
                    if(![[self equalsSub:itemA valueB:itemB] boolValue]) {
                        ////////////////////NSLog(@"returnFalse");
                        return @false;
                    }
                    index++;
                }
            } else {
                return @false;
            }
            return @true;
        } else {
            return [self equalsSub:arrValueA valueB:arrValueB];
        }
    } else {
        return @false;
    }
}
- (NSNumber*) equalsSub: (NSObject*) valueA valueB: (NSObject*) valueB {
    //////NSLog(@"equals : %@ %@", valueB, valueA);
    if((([valueA isKindOfClass:[NSString class]] && ([(NSString*)valueA isEqualToString:@"NULL"] || [(NSString*)valueA isEqualToString:@"<null>"])) || [valueA isKindOfClass:[NSNull class]] || valueA == NULL || ([valueA isKindOfClass:[NSNumber class]] && [(NSNumber*)valueA isEqualTo:@0]) || ([valueA isKindOfClass:[NSString class]] && [(NSString*)valueA isEqualToString:@"0"]))) {
        if( ([valueB isKindOfClass:[NSNull class]]
             || ([valueB isKindOfClass:[NSString class]] && [(NSString*)valueB length] == 0)
             || ([valueB isKindOfClass:[NSString class]] && [(NSString*)valueB isEqualToString:@"NULL"]) || ([valueB isKindOfClass:[NSString class]] && [(NSString*)valueB isEqualToString:@"0"]) ) || ([valueB isKindOfClass:[NSNumber class]] && [(NSNumber*)valueB isEqualToNumber:@0])
           //|| ([valueB isKindOfClass:[NSNumber class]] && [(NSNumber*) valueB isEqualToNumber:@-1])
           ) {
            return @true;
        }
        /*if([valueB isKindOfClass:[PHPUndefined class]]) {
            return @
        }*/
        return @false;
    } else if((([valueB isKindOfClass:[NSString class]] && ([(NSString*)valueB isEqualToString:@"NULL"] || [(NSString*)valueB isEqualToString:@"<null>"])) || [valueB isKindOfClass:[NSNull class]] || valueB == NULL || ([valueB isKindOfClass:[NSNumber class]] && [(NSNumber*)valueB isEqualTo:@0]) || ([valueB isKindOfClass:[NSString class]] && [(NSString*)valueB isEqualToString:@"0"]))) {
        if( ([valueA isKindOfClass:[NSNull class]]
             
             || ([valueA isKindOfClass:[NSString class]] && [(NSString*)valueA length] == 0)
             || ([valueA isKindOfClass:[NSString class]] && [(NSString*)valueA isEqualToString:@"NULL"]) || ([valueA isKindOfClass:[NSString class]] && [(NSString*)valueA isEqualToString:@"0"]) ) || ([valueA isKindOfClass:[NSNumber class]] && [(NSNumber*) valueA isEqualToNumber:@0])
           //|| ([valueA isKindOfClass:[NSNumber class]] && [(NSNumber*) valueA isEqualToNumber:@-1])
           ) {
            return @true;
        }
        return @false;
    }
    if([valueA isKindOfClass:[PHPScriptFunction class]]) {
        if([valueB isKindOfClass:[PHPScriptFunction class]]) {
            if([valueA isEqual:valueB]) {
                return @true;
            }
        }
        return @false;
    }
    if([valueB isKindOfClass:[PHPScriptObject class]]) {
        if(![valueA isKindOfClass:[PHPScriptObject class]]) {
            return @false;
        } else {
            NSObject* store = valueB;
            valueB = valueA;
            valueA = store;
        }
    }
    if([valueA isKindOfClass:[PHPScriptObject class]]) {
        if(![valueB isKindOfClass:[PHPScriptObject class]]) {
            return @false;
        } else {
            //if(valueA == valueB) {
            if([valueA isEqual:valueB]) {
                return @true;
            } else {
                ////////////////////NSLog(@"self interp %@ - %@", [self interpretation], [self interpretationForObject]);
                ToJSON* toJSONInstance = [[ToJSON alloc] init];
                NSObject* arrValueA = [toJSONInstance toJSON:valueA];
                NSObject* arrValueB = [toJSONInstance toJSON:valueB];
                if([arrValueA isKindOfClass:[NSArray class]] && [arrValueB isKindOfClass:[NSArray class]]) {
                    if([(NSArray*)arrValueA count] == 0 && [(NSArray*)arrValueB count] == 0) {
                        return @true;
                    }
                    if([(NSArray*)arrValueA isEqualToArray:(NSArray*)arrValueB]) {
                        return @true;
                    }
                } else if([arrValueA isKindOfClass:[NSDictionary class]] && [arrValueB isKindOfClass:[NSDictionary class]]) {
                    if(![(NSArray*)[(NSDictionary*)arrValueA allKeys] isEqualToArray:[(NSDictionary*)arrValueB allKeys]]) {
                        return @false;
                    }
                    if(![(NSArray*)[(NSDictionary*)arrValueA allValues] isEqualToArray:[(NSDictionary*)arrValueB allValues]]) {
                        return @false;
                    }
                    if([(NSArray*)[(NSDictionary*)arrValueA allKeys] count] == 0 && [(NSArray*)[(NSDictionary*)arrValueB allKeys] count] == 0) {
                        return @true;
                    }
                    return @true;
                }
                return @false;
                ////////////////////NSLog(@"arrValueA: - %@ - %@", arrValueA, arrValueB);
                
                //return [self equalsArrSub:arrValueA valueB:arrValueB];
            }
        }
    }
    if([valueA isKindOfClass:[NSNumber class]] && [valueB isKindOfClass:[NSNumber class]]) {
        NSNumber* numberA = (NSNumber*)valueA;
        NSNumber* numberB = (NSNumber*)valueB;
        ////////////////////NSLog(@"compare valueA valueB %@ - %@ - %@", valueA, valueB, @([numberA isEqualToNumber:numberB]));
        return @([numberA isEqualToNumber:numberB]);
        //return @([valueA isEqualTo:valueB]);
    } else if([valueA isKindOfClass:[NSString class]] || [valueB isKindOfClass:[NSString class]]) {
        if([valueA isKindOfClass:[NSNumber class]]) {
            valueA = [[NSString alloc] initWithString:[self makeIntoString:valueA]];
        }
        if([valueB isKindOfClass:[NSNumber class]]) {
            valueB = [[NSString alloc] initWithString:[self makeIntoString:valueB]];
        }
        if([valueA isKindOfClass:[NSString class]] && [valueB isKindOfClass:[NSString class]]) {
            ////////////////////NSLog(@"compare valueA valueB %@ - %@ - %@", valueA, valueB, @([(NSString*)valueA isEqualToString:(NSString*)valueB]));
            if([(NSString*)valueA isEqualToString:(NSString*)valueB]) {
                return @true;
            }
            return @false;
        }
    } else if((valueA == NULL && valueB == NULL) || (valueA == nil && valueB == nil) || (valueA == nil && valueB == NULL)  || (valueA == NULL && valueB == nil)) {
        return @true;
    }
    return @false;
    //return [self equalsArrSub:valueA valueB:valueB];
}

- (NSNumber*) equals: (NSObject*) valueA valueB: (NSObject*) valueB {
    ////////////////////NSLog(@"equals: %@ - %@", valueA, valueB);
    
    /*if([valueA isKindOfClass:[PHPScriptObject class]]) {
        if(![valueB isKindOfClass:[PHPScriptObject class]]) {
            return @true;
        }
    }
    if([valueB isKindOfClass:[PHPScriptObject class]]) {
        if(![valueA isKindOfClass:[PHPScriptObject class]]) {
            return @true;
        }
    }*/
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    
    valueB = [self resolveValueReferenceVariableArray:valueB];
    valueB = [self removeParanthesis:valueB];
    return [self equalsSub:valueA valueB:valueB];
    //NSString* valueAString = [[NSString alloc] initWithString:[self makeIntoString:valueA]];
    //NSString* valueBString = [[NSString alloc] initWithString:[self makeIntoString:valueB]];
    ////////////////////////NSLog/@"equals: %@ - %@", valueA, valueB);
    /*if([valueA isKindOfClass:[NSArray class]] || [valueA isKindOfClass:[NSDictionary class]] || [valueA isKindOfClass:[PHPScriptObject class]]) {
        if(!([valueB isKindOfClass:[NSArray class]] || [valueB isKindOfClass:[NSDictionary class]] || [valueB isKindOfClass:[PHPScriptObject class]])) {
            return @false;
        }
    }
    if([valueB isKindOfClass:[NSArray class]] || [valueB isKindOfClass:[NSDictionary class]] || [valueB isKindOfClass:[PHPScriptObject class]]) {
        if(!([valueA isKindOfClass:[NSArray class]] || [valueA isKindOfClass:[NSDictionary class]] || [valueA isKindOfClass:[PHPScriptObject class]])) {
            return @false;
        }
    }*/
    if([valueA isKindOfClass:[NSNumber class]]) {
        valueA = [[NSString alloc] initWithString:[self makeIntoString:valueA]];
    }
    if([valueB isKindOfClass:[NSNumber class]]) {
        valueB = [[NSString alloc] initWithString:[self makeIntoString:valueB]];
    }
    ////////////////////////NSLog/@"equals: %@ - %@", valueA, valueB);
    ////////////////////////NSLog/@"kinds: %@ - %@", [valueA class], [valueB class]);
    if([valueA isKindOfClass:[NSString class]] && [valueB isKindOfClass:[NSString class]]) {
        if([(NSString*)valueA isEqualToString:(NSString*)valueB]) {
            return @true;
        }
        return @false;
    }
    return @(valueA == valueB);
}
- (NSNumber*) inequality: (NSObject*) valueA valueB: (NSObject*) valueB {
    ////////////////////NSLog(@"inequals: %@ - %@", valueA, valueB);
    /*valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    
    valueB = [self resolveValueReferenceVariableArray:valueB];
    valueB = [self removeParanthesis:valueB];
    
    NSString* valueAString = [self makeIntoString:valueA];
    NSString* valueBString = [self makeIntoString:valueB];
    if(![valueAString isEqualToString:valueBString]) {
        return @true;
    }
    return @false;*/
    
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    
    valueB = [self resolveValueReferenceVariableArray:valueB];
    valueB = [self removeParanthesis:valueB];
    return @(![[self equalsSub:valueA valueB:valueB] boolValue]);
    
    /*if([valueA isKindOfClass:[PHPScriptObject class]]) {
        if(![valueB isKindOfClass:[PHPScriptObject class]]) {
            return @true;
        }
    }
    if([valueB isKindOfClass:[PHPScriptObject class]]) {
        if(![valueA isKindOfClass:[PHPScriptObject class]]) {
            return @true;
        }
    }
    ////////////////////NSLog(@"continue inequals");
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    
    valueB = [self resolveValueReferenceVariableArray:valueB];
    valueB = [self removeParanthesis:valueB];
    if([valueA isKindOfClass:[NSNumber class]]) {
        valueA = [[NSString alloc] initWithString:[self makeIntoString:valueA]];
    }
    if([valueB isKindOfClass:[NSNumber class]]) {
        valueB = [[NSString alloc] initWithString:[self makeIntoString:valueB]];
    }
    //NSString* valueAString = [[NSString alloc] initWithString:[self makeIntoString:valueA]];
    //NSString* valueBString = [[NSString alloc] initWithString:[self makeIntoString:valueB]];
    //////////////////////NSLog/@"inequals: %@ - %@", valueA, valueB);
    //////////////////////NSLog/@"inequals: %@ - %@", [valueA class], [valueB class]);
    if([valueA isKindOfClass:[NSString class]] && [valueB isKindOfClass:[NSString class]]) {
        if([(NSString*)valueA isEqualToString:(NSString*)valueB]) {
            return @false;
        }
        return @true;
    }
    return @(valueA != valueB);*/
}
- (NSNumber*) inequalityStrong: (NSObject*) valueA valueB: (NSObject*) valueB {
    /*if([self equalsStrong:valueA valueB:valueB]) {
        return @false;
    }*/
    //return [self inequality:valueA valueB:valueB];
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    //NSNumber* valueANumber = (NSNumber*)valueA;
    
    valueB = [self resolveValueReferenceVariableArray:valueB];
    valueB = [self removeParanthesis:valueB];
    //NSNumber* valueBNumber = (NSNumber*)valueB;
    NSString* typeofA = [self getTypeOf:valueA];
    NSString* typeofB = [self getTypeOf:valueB];
    ////////////NSLog(@"inequalityStrong: %@ - %@ - %@ - %@", valueA, valueB, [valueA class], [valueB class]);
    //(1 == 1) : !true : false
    //1 != 1 : !false : true
    //1 != 2 : !true : false
    //1 !== 1 : !false :
    if([valueA isEqualTo:@-1] && [valueB isEqualTo:@0]) {
        return @true;
    }
    
    if([valueB isEqualTo:@-1] && [valueA isEqualTo:@0]) {
        return @true;
    }
    if(![typeofA isEqualToString:typeofB]) {
        //////NSLog(@"a: %@ type: %@ b: %@ type %@", valueA, typeofA, valueB, typeofB);
        ////////////NSLog(@"does equal and has same type returns false and does not continue execution");
        return @true;
    }
    NSNumber* results = [self equalsSub:valueA valueB:valueB];
    ////////////NSLog(@"equalsSub: %@", results);
    if([results isEqualToNumber:@false]) {
        ////////////NSLog(@"does not equal returns true and continues execution");
        return @true;
    }
    ////////////NSLog(@"does equal and does not have same type returns true");
    return @false;
}
- (NSNumber*) equalsStrong: (NSObject*) valueA valueB: (NSObject*) valueB {
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    //NSNumber* valueANumber = (NSNumber*)valueA;
    
    valueB = [self resolveValueReferenceVariableArray:valueB];
    valueB = [self removeParanthesis:valueB];
    //NSNumber* valueBNumber = (NSNumber*)valueB;
    NSString* typeofA = [self getTypeOf:valueA];
    NSString* typeofB = [self getTypeOf:valueB];
    if(![typeofA isEqualToString:typeofB]) {
        return @false;
    }
    
    if([valueA isEqualTo:@-1] && [valueB isEqualTo:@0]) {
        return @false;
    }
    
    if([valueB isEqualTo:@-1] && [valueA isEqualTo:@0]) {
        return @false;
    }
    
    return [self equals:valueA valueB:valueB];
}
- (NSNumber*) greater: (NSObject*) valueA valueB: (NSObject*) valueB {
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    
    valueB = [self resolveValueReferenceVariableArray:valueB];
    valueB = [self removeParanthesis:valueB];
    
    NSNumber* valueAString = [self makeIntoNumber:valueA];
    NSNumber* valueBString = [self makeIntoNumber:valueB];
    /*if([valueAString isEqualToString:valueBString]) {
        return @true;
    }
    return @false;*/
    if([valueAString doubleValue] > [valueBString doubleValue]) {
        return @true;
    }
    return @false;
}
- (NSNumber*) less: (NSObject*) valueA valueB: (NSObject*) valueB {
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    
    valueB = [self resolveValueReferenceVariableArray:valueB];
    valueB = [self removeParanthesis:valueB];
    
    NSNumber* valueAString = [self makeIntoNumber:valueA];
    NSNumber* valueBString = [self makeIntoNumber:valueB];
    /*if([valueAString isEqualToString:valueBString]) {
        return @true;
    }
    return @false;*/
    if([valueAString doubleValue] < [valueBString doubleValue]) {
        return @true;
    }
    return @false;
}
- (NSNumber*) greaterEquals: (NSObject*) valueA valueB: (NSObject*) valueB {
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    
    valueB = [self resolveValueReferenceVariableArray:valueB];
    valueB = [self removeParanthesis:valueB];
    
    NSNumber* valueAString = [self makeIntoNumber:valueA];
    NSNumber* valueBString = [self makeIntoNumber:valueB];
    /*if([valueAString isEqualToString:valueBString]) {
        return @true;
    }
    return @false;*/
    if([valueAString doubleValue] >= [valueBString doubleValue]) {
        return @true;
    }
    return @false;
}
- (NSNumber*) lessEquals: (NSObject*) valueA valueB: (NSObject*) valueB {
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    
    valueB = [self resolveValueReferenceVariableArray:valueB];
    valueB = [self removeParanthesis:valueB];
    
    NSNumber* valueAString = [self makeIntoNumber:valueA];
    NSNumber* valueBString = [self makeIntoNumber:valueB];
    /*if([valueAString isEqualToString:valueBString]) {
        return @true;
    }
    return @false;*/
    if([valueAString doubleValue] <= [valueBString doubleValue]) {
        return @true;
    }
    return @false;
}
- (void) andCondition: (NSObject*) valueAInput valueB: (NSObject*) valueB callback: (id) /*__weak*/ callbackInput {
    id __block callback = callbackInput;
    //////////////////////NSLog(@"andCondition: %@ - %@", valueA, valueB);
    bool __block returnIf = false;
    bool __block setValueA = false;
    id __block firstCallback;
    PHPScriptObject* __weak weakSelf;
    firstCallback = ^(NSObject* valueA) {
        if([valueA isKindOfClass:[PHPScriptEvaluationReference class]]) {
            //valueB =
            [(PHPScriptEvaluationReference*)valueA callFun:weakSelf callback:^(NSObject* valueAItem) {
                
                ((void(^)(NSObject*))firstCallback)(valueAItem);
            }]; //getCallFun](self);
        } else {
        
            //valueA = [self parseInputVariable:valueA];
            valueA = [self resolveValueReferenceVariableArray:valueA];
            valueA = [self removeParanthesis:valueA];
            //valueA = [self parseInputVariable:valueA];
            NSNumber* valueAString = [self makeIntoNumber:valueA];
            if(!returnIf) {
                setValueA = [valueAString boolValue];
            }
            if(![valueAString boolValue]) {
                ((void(^)(NSObject*))callback)(@false);
                //firstCallback = nil;
                callback = nil;
                firstCallback = nil;
                //return @true;
            } else if(!returnIf) {
                returnIf = true;
                ((void(^)(NSObject*))firstCallback)(valueB);
            } else {
                if(setValueA && [valueAString boolValue]) {
                    ((void(^)(NSObject*))callback)(@true);
                } else {
                    ((void(^)(NSObject*))callback)(@false);
                }
                callback = nil;
                firstCallback = nil;
            }
            
        }
    };
    ((void(^)(NSObject*))firstCallback)(valueAInput);
    /*while([valueA isKindOfClass:[PHPScriptEvaluationReference class]]) {
        valueA = [(PHPScriptEvaluationReference*)valueA callFun:self]; //getCallFun](self);
        //valueA = [(PHPScriptEvaluationReference*)valueA getCallFun]([self parentContext]);
    }
    valueA = [self resolveValueReferenceVariableArray:valueA];
    valueA = [self removeParanthesis:valueA];
    //valueA = [self parseInputVariable:valueA];
    NSNumber* valueAString = [self makeIntoNumber:valueA];
    if(![valueAString boolValue]) {
        return @false;
    }
    
    while([valueB isKindOfClass:[PHPScriptEvaluationReference class]]) {
        valueB = [(PHPScriptEvaluationReference*)valueB callFun:self]; // getCallFun](self);
        //valueB = [(PHPScriptEvaluationReference*)valueB getCallFun]([self parentContext]);
    }
    valueB = [self resolveValueReferenceVariableArray:valueB];
    valueB = [self removeParanthesis:valueB];
    
    //valueB = [self parseInputVariable:valueB];
    NSNumber* valueBString = [self makeIntoNumber:valueB];
    if([valueAString boolValue] && [valueBString boolValue]) {
        return @true;
    }
    return @false;*/
}
- (void) orCondition: (NSObject*) valueAInput valueB: (NSObject*) valueB callback: (id) /*__weak*/ callbackInput { //NSNumber*
    /*while([valueA isKindOfClass:[PHPScriptEvaluationReference class]]) {
        valueA = [(PHPScriptEvaluationReference*)valueA callFun:self]; // getCallFun](self);
    }*/
    id __block callback = callbackInput;
    bool __block returnIf = false;
    id __block firstCallback;
    PHPScriptObject* __weak weakSelf;
    //NSObject* __block valueBItem = valueB;
    firstCallback = ^(NSObject* valueA) {
        if([valueA isKindOfClass:[PHPScriptEvaluationReference class]]) {
            //valueB =
            [(PHPScriptEvaluationReference*)valueA callFun:weakSelf callback:^(NSObject* valueAItem) {
                
                ((void(^)(NSObject*))firstCallback)(valueAItem);
            }]; //getCallFun](self);
        } else {
        
            //valueA = [self parseInputVariable:valueA];
            valueA = [self resolveValueReferenceVariableArray:valueA];
            valueA = [self removeParanthesis:valueA];
            //valueA = [self parseInputVariable:valueA];
            NSNumber* valueAString = [self makeIntoNumber:valueA];
            if([valueAString boolValue]) {
                ((void(^)(NSObject*))callback)(@true);
                callback = nil;
                firstCallback = nil;
                //return @true;
            } else if(!returnIf) {
                returnIf = true;
                ((void(^)(NSObject*))firstCallback)(valueB);
            } else {
                ((void(^)(NSObject*))callback)(@false);
                callback = nil;
                firstCallback = nil;
            }
            
        }
    };
    ((void(^)(NSObject*))firstCallback)(valueAInput);
        /*if([valueB isKindOfClass:[PHPScriptEvaluationReference class]]) {
            //valueB =
            [(PHPScriptEvaluationReference*)valueB callFun:self callback:^(NSObject* valueB) {
                
            }]; //getCallFun](self);
        }
        //resolveValueReferenceVariableArray
        valueB = [self parseInputVariable:valueB];
        valueB = [self resolveValueReferenceVariableArray:valueB];
        valueB = [self removeParanthesis:valueB];
        //valueB = [self parseInputVariable:valueB];
        
        NSNumber* valueBString = [self makeIntoNumber:valueB];
        if([valueBString boolValue]) {
            return @true;
        }
        return @false;*/
    //};
}
- (NSObject*) removeParanthesis: (NSObject*) valueA {
    while([valueA isKindOfClass:[NSArray class]]) {
        if([(NSMutableArray*)valueA count] > 0) {
            valueA = ((NSMutableArray*)valueA)[0];
        }
        return NULL;
    }
    return valueA;
}
- (NSObject*) resolveValueArray: (NSObject*) values {
    //////////////////////////////////NSLog/@"resolveValueArray kind: %@", [values class]);
    if([values isKindOfClass:[NSMutableArray class]] || [values isKindOfClass:[NSArray class]]) {
        NSObject* result = nil;
        NSString* nextOperator = NULL;
        bool returnString = false;
        for(NSObject* value in (NSMutableArray*)values) {
            NSObject* setValue = value;
            /*bool isNumeric = false;
            if([value isKindOfClass:[NSString class]]) {
                NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
                NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:(NSString*)value];
                isNumeric = [alphaNums isSupersetOfSet:inStringSet];
            }
            if(isNumeric && [setValue isKindOfClass:[NSString class]]) {
                setValue = [[NSNumber alloc] initWithDouble:[(NSString*)setValue doubleValue]];
            } else if([setValue isKindOfClass:[NSNumber class]]) {
                setValue = [[NSNumber alloc] initWithDouble:[(NSNumber*)setValue doubleValue]];
            } else {
                setValue = [[NSString alloc] initWithString:(NSString*)setValue];
            }*/
            if([setValue isKindOfClass:[PHPValuesOperator class]]) {
                nextOperator = [(PHPValuesOperator*)value operatorValue];
                //////////////////////////////////NSLog/@"nextOperator: %@", nextOperator);
            } else {
                setValue = [self resolveValueReferenceVariableArray:setValue];
                //////////////////////////////////NSLog/@"setValue: %@", setValue);
                if(nextOperator == NULL) {
                    result = setValue;
                } else {
                    if([nextOperator isEqualToString:@"."]) {
                        returnString = true;
                        if(result == nil) {
                            result = @"";
                        }
                        result = [self resolveValueReferenceVariableArray:result];
                        setValue = [self resolveValueReferenceVariableArray:setValue];
                        result = [self makeIntoString:result];
                        setValue = [self makeIntoString:setValue];
                        //////////////////////////////////NSLog/@"result: %@", result);
                        result = [(NSString*)result stringByAppendingString:(NSString*)setValue];
                        //////////////////////////////////NSLog/@"setValue: %@", setValue);
                        //////////////////////////////////NSLog/@"result: %@", result);
                    } else if([nextOperator isEqualToString:@"+"]) {
                        if(result == nil) {
                            result = @0;
                        }
                        result = [self resolveValueReferenceVariableArray:result];
                        setValue = [self resolveValueReferenceVariableArray:setValue];
                        result = [self makeIntoNumber:result];
                        setValue = [self makeIntoNumber:setValue];
                        result = [[NSNumber alloc] initWithDouble:[(NSNumber*)result doubleValue]+[(NSNumber*)setValue doubleValue]];
                    } else if([nextOperator isEqualToString:@"-"]) {
                        if(result == nil) {
                            result = @0;
                        }
                        result = [self resolveValueReferenceVariableArray:result];
                        setValue = [self resolveValueReferenceVariableArray:setValue];
                        result = [self makeIntoNumber:result];
                        setValue = [self makeIntoNumber:setValue];
                        result = [[NSNumber alloc] initWithDouble:[(NSNumber*)result doubleValue]-[(NSNumber*)setValue doubleValue]];
                    } else if([nextOperator isEqualToString:@"/"]) {
                        if(result == nil) {
                            result = @0;
                        }
                        result = [self resolveValueReferenceVariableArray:result];
                        setValue = [self resolveValueReferenceVariableArray:setValue];
                        result = [self makeIntoNumber:result];
                        setValue = [self makeIntoNumber:setValue];
                        result = [[NSNumber alloc] initWithDouble:[(NSNumber*)result doubleValue]/[(NSNumber*)setValue doubleValue]];
                    } else if([nextOperator isEqualToString:@"%"]) {
                        if(result == nil) {
                            result = @0;
                        }
                        result = [self resolveValueReferenceVariableArray:result];
                        setValue = [self resolveValueReferenceVariableArray:setValue];
                        result = [self makeIntoNumber:result];
                        setValue = [self makeIntoNumber:setValue];
                        result = [[NSNumber alloc] initWithDouble:[(NSNumber*)result longValue]%[(NSNumber*)setValue longValue]];
                    } else if([nextOperator isEqualToString:@"*"]) {
                        if(result == nil) {
                            result = @0;
                        }
                        result = [self resolveValueReferenceVariableArray:result];
                        setValue = [self resolveValueReferenceVariableArray:setValue];
                        result = [self makeIntoNumber:result];
                        setValue = [self makeIntoNumber:setValue];
                        result = [[NSNumber alloc] initWithDouble:[(NSNumber*)result doubleValue]*[(NSNumber*)setValue doubleValue]];
                    }
                }
            }
        }
        return result;
    }
    return values;
}
- (NSObject*) returnResultReference: (NSObject*) value {
    if(value == nil) {
        value = NULL;
    }
    ////NSLog(@"insideReturnResultDereference: value is %@", value);
    if([value isKindOfClass:[NSMutableArray class]] || [value isKindOfClass:[NSArray class]]) {
        NSMutableArray* valueArray = (NSMutableArray*)value;
        if([valueArray count] == 1) {
            return valueArray[0];
        }
        return valueArray[1];
    }
    return value;
}
- (NSObject*) returnResultDereference: (NSObject*) value {
    if(value == nil) {
        value = NULL;
    }
    ////NSLog(@"insideReturnResultDereference: value is %@", value);
    if([value isKindOfClass:[NSMutableArray class]] || [value isKindOfClass:[NSArray class]]) {
        NSMutableArray* valueArray = (NSMutableArray*)value;
        if([valueArray count] == 1) {
            return valueArray[0];
        }
        if([valueArray count] > 1) {
            return valueArray[1];
        }
    }
    return value;
}
- (NSObject*) returnResult: (NSObject*) value b: (NSObject*) b {
    ////NSLog(@"insideReturnResultDereference: value is %@ - %@", value, b);
    if(value == nil) {
        value = NULL;
    }
    if(b == nil) {
        b = NULL;
    }
    //////////////////////////////////NSLog/@"called returnResult---");
    if([value isKindOfClass:[NSArray class]]) { //[value isKindOfClass:[NSMutableArray class]] ||
        NSMutableArray* valueArray = (NSMutableArray*)value;
        /*if([valueArray count] == 1) {
            return valueArray[0];
        }
        if([valueArray count] > 1) {
            return valueArray[1];
        }*/
        //long index = 0;
        for(NSObject* value in valueArray) {
            //NSLog(@"value iskindof: %@ - %@", [value class], value);
            if([value isKindOfClass:[PHPReturnResult class]]) {
                /*return @{
                    @"value:": value,
                    @"index": @(index)
                };*/
                return value;
            }
            //index++;
        }
        if([valueArray count] > 0) {
            value = [valueArray lastObject];
            //value = valueArray[[valueArray count]-1];
        }
        /*return @{
            @"value:": value,
            @"index": @([valueArray count]-1)
        };*/
    }
    //////////////////////////////////NSLog/@"is null--");
    ////////////NSLog(@"return result: %@", value);
    return value;
}
- (NSObject*) cloneObject: (NSObject*) object {
    if([object isKindOfClass:[PHPVariableReference class]]) {
        object = [(PHPVariableReference*)object get:nil];
    }
    object = [self parseInputVariable:object];
    //////NSLog(@"clone object: %@", object);
    if([object isKindOfClass:[PHPScriptFunction class]]) {
        object = [(PHPScriptFunction*)object copyScriptFunction];
    } else if([object isKindOfClass:[PHPScriptObject class]]) {
        object = [(PHPScriptObject*)object copyScriptObject];
    }
    [(PHPScriptObject*)object setInterpretation:[self getInterpretation]];
    [(PHPScriptObject*)object setInterpretationForObject:[self getInterpretation]];
    if([object isKindOfClass:[PHPScriptObject class]] && ![(PHPScriptObject*)object isArray]) {
        PHPScriptObject* selfClone = object;
        NSMutableDictionary* newDictionary = [[NSMutableDictionary alloc] init];
        for(NSObject* key in [selfClone dictionary]) {
            NSObject* dictionaryValue = [selfClone dictionary][key];
            //////////////////////////////////NSLog/@"self clone dict value: %@", dictionaryValue);
            if([dictionaryValue isKindOfClass:[PHPScriptFunction class]]) {
                dictionaryValue = [(PHPScriptFunction*)dictionaryValue copyScriptFunction];
                [(PHPScriptFunction*)dictionaryValue setPrototype:selfClone];
                ////////////NSLog(@"ins2: %@", context);
                [(PHPScriptFunction*)dictionaryValue setParentContext:self];
                [(PHPScriptFunction*)dictionaryValue setParentContextStrong:self];
                //////////////////////////////////NSLog/@"set selfclone as prototype: %@", selfClone);
                //////////////////////////////////NSLog/@"set selfclone as prototype: %@", [(PHPScriptFunction*)dictionaryValue prototype]);
            }
            newDictionary[key] = dictionaryValue;
        }
        [selfClone setDictionary:newDictionary];
    }
    
    /*////////////NSLog(@"cloned object set inter: %@", [self getInterpretation]);
    [(PHPScriptObject*)object setInterpretation:[self getInterpretation]];
    [(PHPScriptObject*)object setInterpretationForObject:[self getInterpretation]];*/
    /*if([self isKindOfClass:[PHPScriptFunction class]]) {
        [(PHPScriptObject*)object setParentContext:self];
    }*/
    //
    //NSData* buffer = [NSKeyedArchiver archivedDataWithRootObject: self requiringSecureCoding:NO error:&error];
    //PHPScriptObject* selfClone = [NSKeyedUnarchiver unarchivedObjectOfClass:[PHPScriptObject class] fromData:buffer error:&error];
    
    //////NSLog(@"return clone object: %@", object);
    return object;
}
- (NSObject*) parseInputVariable: (NSObject*) input {
    /*if([input isKindOfClass:[PHPScriptObject class]]) {
        //fara i gegnum items
    }*/
    if([input isKindOfClass:[NSNumber class]] || [input isKindOfClass:[NSString class]]) {
        return input;
    }
    input = [self resolveValueArray:input];
    while([input isKindOfClass:[NSMutableArray class]]) {
        input = ((NSMutableArray*)input)[0];
    }
    input = [self resolveValueReferenceVariableArray:input];
    /*if([input isKindOfClass:[PHPScriptVariable class]]) {
        input = [(PHPScriptVariable*)input get];
    }*/
    return input;
}
- (void) addResetableParseObject: (NSObject*) input {
    /*if([self isKindOfClass:[PHPScriptFunction class]]) {
        //NSLog(@"add resetable : %@ , %@", [(PHPScriptFunction*)self resetableParseObjects], input);
        [[(PHPScriptFunction*)self resetableParseObjects] addObject:input];
    } else {
        [[self getParentContext] addResetableParseObject:input];
    }*/
}
/*- (void)dealloc
{
    NSLog(@"I'm being destroyed : %@", self);
}*/


@end
/*
 */
