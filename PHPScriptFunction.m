//
//  PHPScriptFunction.m
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//
#import "PHPScriptFunction.h"
#import "PHPVariableReference.h"
#import "PHPScriptVariable.h"
#import "PHPReturnResult.h"
#import "PHPScriptEvaluationReference.h"
#import "PHPValuesOperator.h"
#import "PHPInterpretation.h"
//#import "PHPCallbackReference.h"

@implementation PHPScriptFunction

/*- (void) dealloc {
    NSLog(@"i am being destroyed : %@", [self debugText]);
}*/

/*- (void)dealloc
{*/
    //NSLog(@"I'm being destroyed : %@", self);
    /*for(NSObject* variable in [self variables]) {
        if([variable isKindOfClass:[PHPScriptFunction class]]) {
            @synchronized (variable) {
                [(PHPScriptFunction*)variable setReferenceCounter:[(PHPScriptFunction*)variable referenceCounter]-1];
            }
        }
    }*/
    /*[self setParentContext:nil];
    [self setInterpretation:nil];
    [self setPrototype:nil];
    [self setClasses:nil];
    [self setMessagesQueue:nil];
    [self setDictionary:nil];
    [self setDictionaryArray:nil];
    [self setDictionaryKeys:nil];
    [self setDictionaryAux:nil];
    [self setVariables:nil];
}*/

/*-(id)copyWithZone:(NSZone *)zone {
    PHPScriptFunction* result = [[PHPScriptFunction alloc] init];*/
    /*[self setDictionary: [[self dictionary] copyWithZone:zone]];
    [self setDictionaryArray: [[self dictionaryArray] copyWithZone:zone]];
    [self setDictionaryAux: [[self dictionaryAux] copyWithZone:zone]];
    [self setAccessFlags: [[self accessFlags] copyWithZone:zone]];
    [self setClosures:[[self closures] copyWithZone:zone]];
    [self setInputParameters:[[self inputParameters] copyWithZone:zone]];
    [self setInputVariables:[[self variables] copyWithZone:zone]];*/
    
    /*result.dictionary = [self.dictionary copyWithZone:zone];
    result.dictionaryAux = [self.dictionaryAux copyWithZone:zone];
    result.dictionaryArray = [self.dictionaryArray copyWithZone:zone];
    result.accessFlags = [self.accessFlags copyWithZone:zone];
    result.closures = [self.closures copyWithZone:zone];
    result.inputParameters = [self.inputParameters copyWithZone:zone];
    result.variables = [self.variables copyWithZone:zone];*/
    
    /*[result setDictionary:[[NSMutableDictionary alloc] initWithDictionary:[self dictionary]]];
    [result setDictionaryAux:[[NSMutableArray alloc] initWithArray:[self dictionaryAux]]];
    [result setDictionaryArray:[[NSMutableArray alloc] initWithArray:[self dictionaryArray]]];
    [result setAccessFlags:[[NSMutableDictionary alloc] initWithDictionary:[self accessFlags]]];
    [result setClosures:[[NSMutableDictionary alloc] initWithDictionary:[self closures]]];
    [result setInputParameters:[[NSMutableDictionary alloc] initWithDictionary:[self inputParameters]]];
    [result setVariables:[[NSMutableDictionary alloc] initWithDictionary:[self variables]]];*/
    /*result.dictionary = [[NSMutableDictionary alloc] initWithDictionary:[self dictionary]];
    result.dictionaryAux = [[NSMutableArray alloc] initWithArray:[self dictionaryAux]];
    result.dictionaryArray = [[NSMutableArray alloc] initWithArray:[self dictionaryArray]];
    result.accessFlags = [[NSMutableDictionary alloc] initWithDictionary:[self accessFlags]];
    result.closures = [[NSMutableDictionary alloc] initWithDictionary:[self closures]];
    result.inputParameters = [[NSMutableDictionary alloc] initWithDictionary:[self inputParameters]];
    result.variables = [[NSMutableDictionary alloc] initWithDictionary:[self variables]];*/
    /*return result;
}*/
- (void) callCallback: (NSArray*) array {
    [self callCallback:array callback:nil];
}
- (void) callCallback: (NSArray*) array callback: (id) callback {
    //NSLog(@"array call callback : %@", array);
    NSMutableArray* arrayValue = [[NSMutableArray alloc] init];
    if(array != nil) {
        for(NSObject* arrayItem in array) {
            [arrayValue addObject:[[self getInterpretation] makeIntoObjects:arrayItem]];
        }
    }
    //NSMutableArray* valueArr = [[NSMutableArray alloc] initWithArray:array];
    NSMutableArray* arr = [[NSMutableArray alloc] initWithArray:@[arrayValue]];
    //NSLog(@"arr : %@", arr);
    //PHPScriptFunction* callback = [self copyScriptFunction];
    //return 
    [self callScriptFunctionSub:arr parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:callback];
}

/*- (NSObject*) callCallbackWithObjects: (NSArray*) array {
    //[[[NSDictionary alloc] init] ]
    //NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    //[dict removeObjectForKey:<#(nonnull id)#>]
    NSMutableArray* items = [[NSMutableArray alloc] init];
    for(NSObject* item in array) {
        [items addObject:[[self getInterpretation] makeIntoObjects:item]];
    }
    return [self callCallback:items];
}*/

- (void) addIfNotResetableParseObjects: (NSObject*) item {
    /*if([[self resetableParseObjects] indexOfObject:item] == NSNotFound) {
        [[self resetableParseObjects] addObject:item];
    }*/
}

/*- (void) dealloc {
    NSLog(@"Memory to be released soon : %@ - %@", [self debugText], self);
    //[super dealloc];
}*/
- (void) unsetScriptFunction {
    //PHPScriptFunction* result = (PHPScriptFunction*)[super copyScriptObject];//[[PHPScriptFunction alloc] init];
    //PHPScriptFunction* result = [[PHPScriptFunction alloc] init];
    /*NSString* name = [@"messagesQueue" stringByAppendingString:[self description]];
    dispatch_queue_attr_t qos = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_USER_INITIATED, -1);
    dispatch_queue_t recordingQueue = dispatch_queue_create([name UTF8String], qos);
    [result setMessagesQueue:recordingQueue];*/
    //[result setResetableParseObjects:
    //[result setResetableParseObjects:[[NSMutableArray alloc] initWithArray:[self resetableParseObjects]]];//[[NSMutableArray alloc] init]];
    //[result setCache:[self cache]];
    //[result setToUnsetItems:[[NSMutableArray alloc] init]];
    //[self setParentContextStrong:nil];
    [self setReferences:nil];
    [self setIsCallback:nil];
    [self setContainsCallbacks:nil];
    [self setIsAsync:nil];
    [self setDebugText:nil];
    ////////////NSLog(@"ins10 %@ - %@", [self parentContext], [self getInterpretation]);
    [self setParentContext:nil];
    [self setIsArray:nil];
    /*[result setDictionary:[[NSMutableDictionary alloc] initWithDictionary:[self dictionary]]];
    [result setDictionaryArray:[[NSMutableArray alloc] initWithArray:[self dictionaryArray]]];
    [result setDictionaryAux:[[NSMutableArray alloc] initWithArray:[self dictionaryAux]]];*/
    [self setAccessFlags:nil];
    [self setAccessFlag:nil];
    [self setPrototype:nil];
    //[result setOriginalClass:[self originalClass]];
    [self setIdentifier:nil];
    [self setInterpretation:nil];
    //[result setParseObjectCaches:[[NSMutableDictionary alloc] init]];
    //[result initParseObjectCaches];
    //[result setNsValue:[NSValue valueWithNonretainedObject:result]];
    //[result initArrays];
    /*[result setDictionary:[[NSMutableDictionary alloc] initWithDictionary:[self dictionary]]];
    [result setDictionaryArray:[[NSMutableArray alloc] initWithArray:[self dictionaryArray]]];
    [result setDictionaryAux:[[NSMutableArray alloc] initWithArray:[self dictionaryAux]]];*/
    //[result setAccessFlags:[[NSMutableDictionary alloc] initWithDictionary:[self accessFlags]]];
    [self setClosures:nil];
    [self setInputParameters:nil];
    [self setInputParametersKeys:nil];
    [self setVariables:nil]; //initWithDictionary:[self variables]]];
    /*[result setDictionary:[self dictionary]];
    [result setDictionaryArray:[self dictionaryArray]];
    [result setDictionaryAux:[self dictionaryAux]];
    [result setAccessFlags:[self accessFlags]];
    [result setClosures:[self closures]];
    [result setInputParameters:[self inputParameters]];
    [result setVariables:[self variables]];*/
    //[result setInterpretation:[self interpretation]];
    [self setAllowReturn:nil];
    [self setClassValueClass:nil];
    [self setScriptIndexReference:nil];
    //[result setClasses:[[NSMutableDictionary alloc] initWithDictionary:[self classes]]];
    [self setClasses:nil];
    /*@property(nonatomic) NSMutableDictionary* closures;
     //@property(nonatomic) PHPInterpretation* interpretation;
     @property(nonatomic) bool allowReturn;
     @property(nonatomic) NSString* accessFlag;
     //@property(nonatomic) PHPScriptObject* prototype;
     @property(nonatomic) NSMutableDictionary* inputParameters;
     @property(nonatomic) NSMutableDictionary* variables;
     @property(nonatomic) NSMutableDictionary* classes;
     @property(nonatomic) PHPScriptObject* classValueClass;
     @property(nonatomic) PHPScriptEvaluationReference* scriptIndexReference;*/
    //return result;
}

- (void) canUnsetAlt {
    bool allClear = true;
    long functionCounter = 0;
    bool this_set = false;
    @synchronized (self) {
        
        NSDictionary* dict = [self variables]; /*test_d*/

        for(NSObject* itemKey in dict) {
            if([itemKey isEqualTo:@"this"]) {
                this_set = true;
            }
            NSObject* item = dict[itemKey];
            if([item isKindOfClass:[PHPScriptFunction class]]) {
                //NSLog(@"retain count : %lu, %@", (CFGetRetainCount((__bridge CFTypeRef) item)), [(PHPScriptFunction*)item debugText]);
                /*if((CFGetRetainCount((__bridge CFTypeRef) item)) > 3) {
                    allClear = false;
                }*/
                
                if(![(PHPScriptFunction*)item completedExecution]) {
                    allClear = false;
                }
                functionCounter++;
            }
        }
        //NSLog(@"canunset : %i %lu %i %i - %@", allClear, functionCounter, this_set, [self completedExecution], [self debugText]);
        if(allClear /*&& functionCounter > 0*/ /*&& this_set*/ && [self completedExecution]) {
            //PHPScriptFunction* parentContext = [self parentContext];
            //PHPScriptFunction* globalContext = [[self getInterpretation] globalContext];
            
            /*if(![self isCallback]) {
                parentContext = [self lastCaller];
                bool containsFunctionDefinition = [[(PHPScriptFunction*)parentContext containsCallbacks] boolValue];
                if(containsFunctionDefinition) {
                    return;
                }
            }*/
            
            [self unset:nil];
            [self unsetScriptFunction];
            
            
            
            /*if(![self isAsync]) {
                //NSLog(@"cancel propagation");
                return;
            }*/
            //NSLog(@"continue propagation : %@ - %@", [self debugText], [parentContext debugText]);
            /*if((parentContext != nil && ([parentContext identifier] == nil || ![[parentContext identifier] containsString:@"__"]) && ![parentContext isEqualTo:globalContext])) {
                //if(parentContext != nil) {
                    [parentContext canUnset];
                    //[parentContext unset:nil];
                //}
            }*/
        }
    }
}

- (void) canUnset {
    bool allClear = true;
    long functionCounter = 0;
    bool this_set = false;
    @synchronized (self) {
        
        NSDictionary* dict = [self variables]; /*test_d*/

        for(NSObject* itemKey in dict) {
            if([itemKey isEqualTo:@"this"]) {
                this_set = true;
            }
            NSObject* item = dict[itemKey];
            if([item isKindOfClass:[PHPScriptFunction class]] && (/*[(PHPScriptFunction*)item isCallback] ||*/ [(PHPScriptFunction*)item isAsync])) {
                //NSLog(@"retain count : %lu, %@", (CFGetRetainCount((__bridge CFTypeRef) item)), [(PHPScriptFunction*)item debugText]);
                /*if((CFGetRetainCount((__bridge CFTypeRef) item)) > 3) {
                    allClear = false;
                }*/
                
                /*if([(PHPScriptFunction*)item callCount] != nil) {
                    if([[(PHPScriptFunction*)item callCount] longLongValue] > 0) {
                        allClear = false;
                    }
                } else {
                    if([[(PHPScriptFunction*)item retainCountValue] longLongValue] > 0) {
                        allClear = false;
                    }
                }*/
                functionCounter++;
            }
        }
        //NSLog(@"canunset : %i %lu %i %i - %@", allClear, functionCounter, this_set, [self completedExecution], [self debugText]);
        if(allClear /*&& functionCounter > 0*/ /*&& this_set*/ && [self completedExecution]) {
            PHPScriptFunction* parentContext = [self parentContext];
            PHPScriptFunction* globalContext = [[self getInterpretation] globalContext];
            
            /*if(![self isCallback]) {
                parentContext = [self lastCaller];
                bool containsFunctionDefinition = [[(PHPScriptFunction*)parentContext containsCallbacks] boolValue];
                if(containsFunctionDefinition) {
                    return;
                }
            }*/
            
            [self unset:nil];
            [self unsetScriptFunction];
            
            
            
            /*if(![self isAsync]) {
                //NSLog(@"cancel propagation");
                return;
            }*/
            //NSLog(@"continue propagation : %@ - %@", [self debugText], [parentContext debugText]);
            if((parentContext != nil && ([parentContext identifier] == nil || ![[parentContext identifier] containsString:@"__"]) && ![parentContext isEqualTo:globalContext])) {
                //if(parentContext != nil) {
                    [parentContext canUnset];
                    //[parentContext unset:nil];
                //}
            }
        }
    }
}

- (void) setPropContainsCallbacks {
    [self setContainsCallbacks:@true];
    //[[self parentContext] setContainsCallbacks:@true];
    [[self parentContext] setPropContainsCallbacks];
}

- (PHPScriptFunction*) copyScriptFunction {
    //PHPScriptFunction* result = (PHPScriptFunction*)[super copyScriptObject];//[[PHPScriptFunction alloc] init];
    PHPScriptFunction* result = [[PHPScriptFunction alloc] init];
    [result initArrays];
    //[result construct:[self parentContext]];
    //[result setReferenceCounter:0];
    /*NSString* name = [@"messagesQueue" stringByAppendingString:[self description]];
    dispatch_queue_attr_t qos = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_USER_INITIATED, -1);
    dispatch_queue_t recordingQueue = dispatch_queue_create([name UTF8String], qos);
    [result setMessagesQueue:recordingQueue];*/
    //[result setResetableParseObjects:
    //[result setResetableParseObjects:[[NSMutableArray alloc] initWithArray:[self resetableParseObjects]]];//[[NSMutableArray alloc] init]];
    //[result setCache:[self cache]];
    //[result setToUnsetItems:[[NSMutableArray alloc] init]];
    //[result setReferences:[[NSMutableArray alloc] init]];
    //[result setIsCallback:[self isCallback]];
    //[result setContainsCallbacks:[self containsCallbacks]];
    //[self setClassIdentifierValue:nil];
    
    /*@property(nonatomic) NSString* classIdentifierValue;
     @property(nonatomic) bool reverseIteratorSet;
     @property(nonatomic) int nextKey;
     @property(nonatomic) PHPScriptFunction* parentContext;
     //@property(nonatomic) PHPScriptFunction* strongParentContext;
     @property(nonatomic) bool isArray;
     @property(atomic) NSMutableArray*  dictionaryKeys;
     @property(atomic) NSMutableDictionary*  dictionary;
     @property(atomic) NSMutableArray*  dictionaryArray;
     @property(atomic) NSMutableArray*  dictionaryAux;
     @property(nonatomic) PHPScriptObject* prototype;
     @property(nonatomic) NSMutableDictionary* accessFlags; //NSDictionary;
     @property(nonatomic) PHPScriptObject* __weak originalClass;
     @property(nonatomic) NSString* identifier;
     @property(nonatomic) PHPInterpretation* __weak interpretation;
     @property(nonatomic) PHPScriptObject* __weak parentClass;
     @property(nonatomic) PHPInterpretation* __weak interpretationForObject;
     @property(nonatomic) PHPScriptFunction* __weak currentFunctionContext;
     @property(nonatomic) bool globalObject;
     @property(nonatomic) PHPScriptObject* __weak instanceItem;*/
    //[result setContainsCallbacks:[self containsCallbacks]];
    [result setIsCallback:[self isCallback]];
    [result setIsAsync:[self isAsync]];
    [result setDebugText:[self debugText]];
    ////////////NSLog(@"ins10 %@ - %@", [self parentContext], [self getInterpretation]);
    [result setParentContext:[self parentContext]];
    [result setParentContextStrong:[self parentContext]];
    [result setIsArray:[self isArray]];
    /*[result setDictionary:[[NSMutableDictionary alloc] initWithDictionary:[self dictionary]]];
    [result setDictionaryArray:[[NSMutableArray alloc] initWithArray:[self dictionaryArray]]];
    [result setDictionaryAux:[[NSMutableArray alloc] initWithArray:[self dictionaryAux]]];*/
    [result setAccessFlags:[self accessFlags]];
    [result setAccessFlag:[self accessFlag]];
    [result setPrototype:[self prototype]];
    //[result setOriginalClass:[self originalClass]];
    [result setIdentifier:[self identifier]];
    [result setInterpretation:[self interpretation]];
    //[result setParseObjectCaches:[[NSMutableDictionary alloc] init]];
    //[result initParseObjectCaches];
    //[result setNsValue:[NSValue valueWithNonretainedObject:result]];
    //[result initArrays];
    /*[result setDictionary:[[NSMutableDictionary alloc] initWithDictionary:[self dictionary]]];
    [result setDictionaryArray:[[NSMutableArray alloc] initWithArray:[self dictionaryArray]]];
    [result setDictionaryAux:[[NSMutableArray alloc] initWithArray:[self dictionaryAux]]];*/
    //[result setAccessFlags:[[NSMutableDictionary alloc] initWithDictionary:[self accessFlags]]];
    [result setClosures:[self closures]];
    [result setInputParameters:[[NSMutableDictionary alloc] initWithDictionary:[self inputParameters]]];
    [result setInputParametersKeys:[[NSMutableArray alloc] initWithArray:[self inputParametersKeys]]];
    [result setVariables:[[NSMutableDictionary alloc] init]]; //initWithDictionary:[self variables]]];
    /*[result setDictionary:[self dictionary]];
    [result setDictionaryArray:[self dictionaryArray]];
    [result setDictionaryAux:[self dictionaryAux]];
    [result setAccessFlags:[self accessFlags]];
    [result setClosures:[self closures]];
    [result setInputParameters:[self inputParameters]];
    [result setVariables:[self variables]];*/
    //[result setInterpretation:[self interpretation]];
    [result setAllowReturn:[self allowReturn]];
    [result setClassValueClass:[self classValueClass]];
    [result setScriptIndexReference:[self scriptIndexReference]];
    //[result setClasses:[[NSMutableDictionary alloc] initWithDictionary:[self classes]]];
    [result setClasses:[self classes]];
    /*@property(nonatomic) NSMutableDictionary* closures;
     //@property(nonatomic) PHPInterpretation* interpretation;
     @property(nonatomic) bool allowReturn;
     @property(nonatomic) NSString* accessFlag;
     //@property(nonatomic) PHPScriptObject* prototype;
     @property(nonatomic) NSMutableDictionary* inputParameters;
     @property(nonatomic) NSMutableDictionary* variables;
     @property(nonatomic) NSMutableDictionary* classes;
     @property(nonatomic) PHPScriptObject* classValueClass;
     @property(nonatomic) PHPScriptEvaluationReference* scriptIndexReference;*/
    return result;
}

/*- (id) retain
{
    // Break here to see who is retaining me.
    return [super retain];
}*/

- (void) initArrays {
    //NSLog(@"initarrays : %@", self);
    [self setIsAsync:false];
    //[self setNsValue:[NSValue valueWithNonretainedObject:self]];
    
    //[self setParseObjectCaches:[[NSMutableDictionary alloc] init]];
    //[self initParseObjectCaches];
    //[self setToUnsetItems:[[NSMutableArray alloc] init]];
    [self setDictionary:[[NSMutableDictionary alloc] init]];
    [self setDictionaryArray:[[NSMutableArray alloc] init]];
    [self setDictionaryAux:[[NSMutableArray alloc] init]];
    [self setAccessFlags:[[NSMutableDictionary alloc] init]];
    [self setClosures:[[NSMutableDictionary alloc] init]];
    [self setInputParameters:[[NSMutableDictionary alloc] init]];
    [self setInputParametersKeys:[[NSMutableArray alloc] init]];
    [self setVariables:[[NSMutableDictionary alloc] init]];
    //[self setResetableParseObjects:[[NSMutableArray alloc] init]];
    ////////////////////////////////NSLog/@"initArrays: %@", [self dictionary]);
    
}
/*- (PHPInterpretation*) getInterpretation {
    if([self interpretation] != nil) {
        return [self interpretation];
    }*/
    /*if(![[self parentContext] isKindOfClass:[PHPScriptFunction class]]) {
        ////////////NSLog(@"parentContext is: %@", [[self parentContext] class]);
    }*/
   /* return [[self parentContext] getInterpretation];
}*/
//- (void) setAccessFlag:(NSString *)accessFlag
- (void) scriptPushArray: (NSObject*) array item: (NSObject*) item {
    array = [self resolveVariableReturn:array];
    PHPScriptObject* arrayObject = (PHPScriptObject*)array;
    [arrayObject scriptArrayPush:item];
}
- (void) construct2:(PHPScriptFunction *)parentContext evaluation: (PHPInterpretation*) evaluation {
    ////////////NSLog(@"ins11 %@", [self parentContext]);
    if(parentContext != nil) {
        [self setParentContext:parentContext];
        [self setParentContextStrong:parentContext];
        [self setInterpretation:[parentContext interpretation]];
    } else {
        [self setInterpretation:evaluation];
        [self setAllowReturn:false];
    }
}
- (void) resetThis: (PHPScriptObject*) context {
    ////////////////////////////////NSLog/@"call resetThis");
    if(context == nil || context == NULL) {
        context = [self prototype];
    }
    if(context == nil) {
        return;
    }
    //if(context != nil && context != NULL) {
        ////////////////////////////////NSLog/@"self set proto as context is %@", context);
    PHPScriptObject* originalContext = context;
    while([context instanceItem] != nil) {
        context = [context instanceItem];
    }
    [self setVariableValue:@"this" value:context defineInContext:@true inputParameter:@false overrideThis:@true];
    [self setVariableValue:@"self_instance" value:originalContext defineInContext:@true inputParameter:@false overrideThis:@false];
        /*if([context prototype] != nil) {
            [self setVariableValue:@"parent" value:[context prototype] defineInContext:@true inputParameter:@false overrideThis:@false];
        }*/
        //[self setVariableValue:@"this", context, true,]
        //$this->set_variable_value('this', $context, true, false, true);
    /*} else {
        ////////////////////////////////NSLog/@"self prototype is %@", [self prototype]);
        [self setVariableValue:@"this" value:[self prototype] defineInContext:@true inputParameter:@false overrideThis:@true];
    }*/
    ////////////////////////////////NSLog/@"has reset this");
}

- (void) clearRunningToUnset {
    //NSLog(@"clearRunningToUnset : %@ - %@", self, @([[self toUnsetItems] count]));
    //NSMutableArray* all = [[NSMutableArray alloc] initWithArray:[self toUnsetItems]];
    for(PHPScriptFunction* func in [self toUnsetItems]) {
        [func setParentContext:nil];
        NSLog(@"clearRunningToUnset : %@", func);
        /*if([func parentContext] == nil || [[[self parentContext] toUnsetItems] containsObject:func]) {
            [[func parentContext] unset:nil];
            [func setParentContext:nil];
            //@synchronized ([self toUnset]) {
                [[self toUnsetItems] removeObject:func];
            //}
        }*/
    }
    [[self toUnsetItems] removeAllObjects];
    
    //NSLog(@"after parent count : %@ - %lu", [self parentContext], [[[self parentContext] toUnsetItems] count]);
    //NSLog(@"after self count : %@ - %lu", self, [[self toUnsetItems] count]);
    //NSLog(@"count : %@", @([[self toUnsetItems] count]));
}

- (void) unset: (PHPScriptObject*) context  {
    //NSLog(@"unset");
    ////////////////////////////////NSLog/@"call resetThis");
    if(context == nil || context == NULL) {
        context = [self prototype];
    }
    /*//if(context != nil && context != NULL) {
        ////////////////////////////////NSLog/@"self set proto as context is %@", context);
    PHPScriptObject* originalContext = context;
    while([context instanceItem] != nil) {
        context = [context instanceItem];
    }*/
    /*[self setVariableValue:@"this" value:[[PHPUndefined alloc] init] defineInContext:@true inputParameter:@false overrideThis:@true];
    [self setVariableValue:@"self_instance" value:[[PHPUndefined alloc] init] defineInContext:@true inputParameter:@false overrideThis:@false];*/
    //[self setvariableValue]
    //[[self dictionary] dealloc];
    /*if([self parentContext] != nil) {
        [[[self parentContext] toUnsetItems] addObject:self];
    }*/
    //[self setToUnset:true];
    /*if([self prototype] != nil) {
        [self setParentContext:nil];
    }*/
    //NSLog(@"unset : %@ - %@", [self identifier], [self debugText]);
    
    //if(![[self parentContext] isEqualTo:[[self getInterpretation] globalContext]]) {
    if(![context isKindOfClass:[PHPScriptFunction class]]) {
        /*context = [context parentContext];
        if(context != nil) {
            [[(PHPScriptFunction*)context toUnsetItems] addObject:self];
            NSLog(@"toUnsetItems is : %@ - %@", context, [(PHPScriptFunction*)context toUnsetItems]);
        }*/
        //NSLog(@"toUnsetItems is : %@ - %@", [self parentContext], [(PHPScriptFunction*)[self parentContext] toUnsetItems]);
        //[[(PHPScriptFunction*)[self parentContext] toUnsetItems] addObject:self];*/
        //[self setParentContext:nil];
        //[self setParentContext:nil];
        //[self setParentContextStrong:nil];
    } else {
        //NSLog(@"unset parent context");
        [self setParentContext:nil];
        [self setParentContextStrong:nil];
        //[[(PHPScriptFunction*)context toUnsetItems] addObject:self];
    }    //NSLog(@"push to unset : %@ - %@", self, @([[[self parentContext] toUnsetItems] count]));
    
   // [self setParentContext:nil];
    //[self setParentContextStrong:nil];
    //}
    //[self setParentContext:context];
    //[self setParentContext:nil];
    [self setInterpretation:nil];
    [self setPrototype:nil];
    [self setClasses:nil];
    [self setMessagesQueue:nil];
    [self setDictionary:nil];
    [self setDictionaryArray:nil];
    [self setDictionaryKeys:nil];
    [self setDictionaryAux:nil];
    [self setScriptIndexReference:nil];
    
    /*for(NSObject* varItem in [self variables]) {
        
    }*/
    [self setVariables:nil];
    //[self clearRunningToUnset];
    /*NSLog(@"parent count : %@ - %lu", context, [[(PHPScriptFunction*)context toUnsetItems] count]);
    
    NSLog(@"parent count : %@ - %lu", [self parentContext], [[[self parentContext] toUnsetItems] count]);
    NSLog(@"self count : %@ - %lu", self, [[self toUnsetItems] count]);*/
    
    //[(PHPScriptFunction*)context clearRunningToUnset];
    //[self clearRunningToUnset];
    //[[self parentContext] clearRunningToUnset];
    
    
    /*
     @property(nonatomic) NSMutableArray* resetableParseObjects;
     @property(nonatomic) NSString* functionName;
     @property(nonatomic) NSMutableDictionary* closures;
     //@property(nonatomic) PHPInterpretation* interpretation;
     @property(nonatomic) bool isAsync;
     @property(nonatomic) bool allowReturn;
     @property(nonatomic) NSString* accessFlag;
     //@property(nonatomic) NSNumber* depthValue;
     //@property(nonatomic) PHPScriptObject* prototype;
     @property(nonatomic) NSMutableDictionary* inputParameters;
     @property(nonatomic) NSMutableArray* inputParametersKeys;
     @property(nonatomic) NSMutableDictionary* variables;
     @property(nonatomic) NSMutableDictionary* classes;
     @property(nonatomic) PHPScriptObject* classValueClass;
     @property(nonatomic) PHPScriptEvaluationReference* scriptIndexReference;
     @property(atomic) bool hasRunOnce;
     @property(nonatomic) NSMutableDictionary* cache;
     @property(nonatomic) dispatch_queue_t messagesQueue;
     @property(nonatomic) PHPScriptFunction* previousClassFunction;
     @property(nonatomic) NSString* debugText;
     @property(nonatomic) bool hasNoReturn;
     @property(nonatomic) bool isReturnValueItem;
     @property(nonatomic) NSObject* returnResultValue;
     @property(nonatomic) NSValue* nsValue;
     @property(nonatomic) NSMutableDictionary* parseObjectCaches;*/
}
- (void) setContainsCallbacksValue {
    //NSLog(@"set contains callbacks value : %@", [self debugText]);
    [self setContainsCallbacks:@true];
    if([self parentContext] == nil) {
        return;
    }
    if([[self parentContext] isKindOfClass:[PHPScriptFunction class]]) {
        [(PHPScriptFunction*)[self parentContext] setContainsCallbacksValue];
    }
}
- (PHPScriptObject*) getObject {
    if([self prototype] != nil) {
        return [self prototype];
    }
    return NULL;
}
- (PHPScriptObject*) _newInstance: (PHPScriptObject*) object parameterValues: (NSMutableArray*) parameterValues callback: (id) /*__weak*/ callbackInput {
    id __block callback = callbackInput;
    PHPScriptObject* _newInstance = [object getNewInstance: self];
    //if(parameterValues != nil) {
    ////////////////////////////////NSLog/@"calling constructor called");
    ////////////////////////////////NSLog/@"newinstance object function prototype: %@", [(PHPScriptFunction*)[newInstance dictionary][@"__construct"] prototype]);
    //[_newInstance setCurrentObjectFunctionContext:]
    [_newInstance callClassConstructor:parameterValues callback:^(NSObject* valueCallback) {
        //((void(^)(NSObject*))callback)(valueCallback);
        ((void(^)(NSObject*))callback)(_newInstance);
        callback = nil;
        //((void)(^)(NSObject*)callback)(_newInstance);
        //callback
    }];
    ////////////////////////////////NSLog/@"class constructor called");
    //}
    //[newInstance setInterpretationForObject:[self interpretation]];
    //return _newInstance;
    return nil;
}
- (void) setInputVariables: (NSMutableArray*) inputs {
    int index = 0;
    ////////////////////////////////NSLog/@"setInputVariables: %@", inputs);
    ////////////////////////////////NSLog/@"setInputVariables: %@", [self inputParameters]);
    
    NSDictionary* selfInputParameters = [[NSDictionary alloc] initWithDictionary:[self inputParameters]];
    ////////////////////NSLog(@"setInputVariables: %@ - %@", [self inputParametersKeys], [self inputParameters]);
    NSMutableArray* selfInputKeys = [[NSMutableArray alloc] initWithArray:[self inputParametersKeys]];
    [self setInputParametersKeys:[[NSMutableArray alloc] init]];
    for(NSString* inputName in selfInputKeys) {
        ////////////////////NSLog(@"iterate: %@", inputName);
        ////////////NSLog(@"setInput: %@ - %@", inputName, inputs[index]);
        NSObject* inputDefaultValue = selfInputParameters[inputName];
        if(![inputDefaultValue isEqual:NULL]) {
            [self setVariableValue:inputName value:inputDefaultValue defineInContext:@true inputParameter:@true overrideThis:nil];
        }/* else {
            [self setVariableValue:inputName value:NULL defineInContext:@true inputParameter:@true overrideThis:nil];
        }*/
        if([inputs count] > index && inputs[index] != nil) {
            //[self setVariableValue:]
            // else {
            /*if([self isAsync] && [inputs[index] isKindOfClass:[PHPScriptObject class]] && ![inputName isEqualToString:@"result_pool"]) {
                ////////////NSLog(@"reset interpretation for: %@ in function : %@ isAsync: %i", inputName, [self identifier], [self isAsync]);
                [self setVariableValue:inputName value:[self cloneObject:(PHPScriptObject*)inputs[index]] defineInContext:@true inputParameter:@true overrideThis:nil];
            } else {*/
                [self setVariableValue:inputName value:inputs[index] defineInContext:@true inputParameter:@true overrideThis:nil];
            //}
            
            ////////////////////////////////NSLog/@"set input variable: %@", inputs[index]);
            //$this->set_variable_value($input_name, $inputs[$index], true, true);
        } else if([inputDefaultValue isEqual:NULL]) {
            [self setVariableValue:inputName value:NULL defineInContext:@true inputParameter:@true overrideThis:nil];
            
            
            ////////////////////////////////NSLog/@"set input variable: undefined--");
            //$this->set_variable_value($input_name, "undefined", true, true);
        }
        index++;
    }
    ////////////////////NSLog(@"setInputVariables completed");
}

- (NSObject*) getVariableContainer: (NSString*) name {
    @synchronized ([self variables]) {
        if([[self variables] objectForKey:name] != nil) {
            //////NSLog(@"getvar1 : %@", name);
            NSObject* val = [self variables][name];
            //////NSLog(@"val : %@", val);
            //////////////////NSLog/@"val: %@", val);
            if(val != nil && val != NULL &&
               //!([val isKindOfClass:[NSString class]] && [(NSString*)val isEqualToString:@"undefined"] && [val isKindOfClass:[PHPUndefined class]])
               !([val isKindOfClass:[PHPUndefined class]])
               ) {
                //////////////////NSLog/@"ret getvar1");
                //////NSLog(@"val: %@", val);
                return [self variables];
            }
        }
        //NSArray* globalObjects = @[@"math", @"data", @"object", @"date"];
        bool isGlobalObject = false;
        /*for(NSString* globalName in globalObjects) {
         if([name isEqualToString:globalName]) {
         isGlobalObject = true;
         }
         }*/
        
        if([self parentContext] != nil && [self parentContext] != NULL && [self parentContext] != self
           //&& !(!isGlobalObject && [[self parentContext] isKindOfClass:[PHPScriptObject class]])
           ) {
            //////NSLog(@"getvar2 : %@", name);
            NSObject* val = [[self parentContext] getVariableContainer:name];
            //////NSLog(@"val : %@", val);
            //////////////////NSLog/@"val result: %@ - %@", val, [val class]);
            if(val != nil && val != NULL &&
               //!([val isKindOfClass:[NSString class]] && [(NSString*)val isEqualToString:@"undefined"] && [val isKindOfClass:[PHPUndefined class]])
               !([val isKindOfClass:[PHPUndefined class]])
               ) {
                //////////////////NSLog/@"ret getvar2");
                //////NSLog(@"val2: %@", val);
                return val;
            }
        }
        /*if([self currentObjectFunctionContext] != nil) {
         
         NSObject* val = [[self currentObjectFunctionContext] getVariableValue:name];
         if(val != nil) {
         return val;
         }
         }*/
        //////NSLog(@"is null %@ - %@", name, [self variables]);
        //[self debugTest:[self variables]];
        
        /*if([[self getInterpretation] lastSetFunctionCallingContext] != nil && [[self getInterpretation] lastSetFunctionCallingContext] != self) {
         ////////////NSLog(@"call lastSetFunctionCallingContext: %@ parent: %@ - lastcallingcontext: %@ currentContext: %@ - %@", name, [self parentContext], [[[self getInterpretation] lastSetFunctionCallingContext] identifier], [self identifier]);
         NSObject* val = [[[self getInterpretation] lastSetFunctionCallingContext] getVariableValue:name];
         //if([[[self getInterpretation] lastSetFunctionCallingContext] getVariableValue:name] != nil) {
         
         //////////////////NSLog/@"call lastSetFunctionCallingContext not nil");
         if(val != nil) {
         //////////////NSLog(@"last set not nil %@ %@", val, [[self getInterpretation] lastSetFunctionCallingContext]);
         return val;//[[[self getInterpretation] lastSetFunctionCallingContext] getVariableValue:name];
         }
         }*/
        //////////////NSLog(@"is null");
        //////////////////NSLog/@"is null for key: %@: %@, %@", name, [self variables], [self dictionary]);
        return NULL;
    }
}

- (NSObject*) getVariableValue: (NSString*) name {
    //
    
    //NSLog(@"getVariableValue: %@ _ %@ - %@", name, [self identifier], [self class]);
    /*if([[self variables] objectForKey:name] == nil) {
    }*/
    /*if([name isEqualToString:@"message_counter"]) {
        NSLog(@"get message counter : %@ - %@ - %@", self, [self variables], [self debugText]);
    }*/
    
    @synchronized ([self variables]) {
        if([[self variables] objectForKey:name] != nil) {
            //////NSLog(@"getvar1 : %@", name);
            NSObject* val = [self variables][name];
            //////NSLog(@"val : %@", val);
            //////////////////NSLog/@"val: %@", val);
            if(val != nil && val != NULL &&
               //!([val isKindOfClass:[NSString class]] && [(NSString*)val isEqualToString:@"undefined"] && [val isKindOfClass:[PHPUndefined class]])
               !([val isKindOfClass:[PHPUndefined class]])
               ) {
                //////////////////NSLog/@"ret getvar1");
                //////NSLog(@"val: %@", val);
                /*if([val isKindOfClass:[NSValue class]]) {
                 return [(NSValue*)val nonretainedObjectValue];
                 }*/
                return val;
            }
        }
        //NSArray* globalObjects = @[@"math", @"data", @"object", @"date"];
        bool isGlobalObject = false;
        /*for(NSString* globalName in globalObjects) {
         if([name isEqualToString:globalName]) {
         isGlobalObject = true;
         }
         }*/
        
        if([self parentContext] != nil && [self parentContext] != NULL && [self parentContext] != self
           //&& !(!isGlobalObject && [[self parentContext] isKindOfClass:[PHPScriptObject class]])
           ) {
            //////NSLog(@"getvar2 : %@", name);
            NSObject* val = [[self parentContext] getVariableValue:name];
            //////NSLog(@"val : %@", val);
            //////////////////NSLog/@"val result: %@ - %@", val, [val class]);
            if(val != nil && val != NULL &&
               //!([val isKindOfClass:[NSString class]] && [(NSString*)val isEqualToString:@"undefined"] && [val isKindOfClass:[PHPUndefined class]])
               !([val isKindOfClass:[PHPUndefined class]])
               ) {
                //////////////////NSLog/@"ret getvar2");
                //////NSLog(@"val2: %@", val);
                ///
                /*if([val isKindOfClass:[NSValue class]]) {
                 return [(NSValue*)val nonretainedObjectValue];
                 }*/
                return val;
            }
        }
        /*if([self currentObjectFunctionContext] != nil) {
         
         NSObject* val = [[self currentObjectFunctionContext] getVariableValue:name];
         if(val != nil) {
         return val;
         }
         }*/
        //////NSLog(@"is null %@ - %@", name, [self variables]);
        //[self debugTest:[self variables]];
        
        /*if([[self getInterpretation] lastSetFunctionCallingContext] != nil && [[self getInterpretation] lastSetFunctionCallingContext] != self) {
         ////////////NSLog(@"call lastSetFunctionCallingContext: %@ parent: %@ - lastcallingcontext: %@ currentContext: %@ - %@", name, [self parentContext], [[[self getInterpretation] lastSetFunctionCallingContext] identifier], [self identifier]);
         NSObject* val = [[[self getInterpretation] lastSetFunctionCallingContext] getVariableValue:name];
         //if([[[self getInterpretation] lastSetFunctionCallingContext] getVariableValue:name] != nil) {
         
         //////////////////NSLog/@"call lastSetFunctionCallingContext not nil");
         if(val != nil) {
         //////////////NSLog(@"last set not nil %@ %@", val, [[self getInterpretation] lastSetFunctionCallingContext]);
         return val;//[[[self getInterpretation] lastSetFunctionCallingContext] getVariableValue:name];
         }
         }*/
        //////////////NSLog(@"is null");
        //////////////////NSLog/@"is null for key: %@: %@, %@", name, [self variables], [self dictionary]);
        return NULL;
    }
}


- (void) debugTest: (NSMutableDictionary*) variables {
    for(NSObject* key in variables) {
        NSObject* keyValue = key;
        if([key isKindOfClass:[NSMutableArray class]]) {
            keyValue = (NSObject*)((NSMutableArray*)key)[0];
        }
        if([keyValue isKindOfClass:[PHPVariableReference class]]) {
            PHPVariableReference* var = (PHPVariableReference*)keyValue;
            ////NSLog(@"key is %@ - %@", [var identifier], [var get:nil]);
        }
        //////NSLog(@"value is : %@", [[self interpretation] toJSON:variables[key]]);
    }
}


- (bool) variableDefined: (NSString*) name {
    if([[self variables] objectForKey:name] != nil && [[self variables] objectForKey:name] != NULL) {
        
        if([[[self variables] objectForKey:name] isKindOfClass:[PHPUndefined class]]) {//[stringValue isEqualToString:@"undefined"] &&
            return false;
        }
        //NSString* stringValue = [self makeIntoString:[self variables][name]];
        return true;
    }
    return false;
}
- (NSString*) getClassIdentifier: (PHPScriptObject*) class {
    for(NSString* key in [self classes]) {
        if([self classes][key] == class) {
            return key;
        }
    }
    return NULL;
}
- (PHPScriptObject*) setClassReference: (NSString*) identifier {
    if([[self classes] objectForKey:identifier] != nil) {
        ////////////////////////////////NSLog/@"class exists: %@", identifier);
        ////////////////////////////////NSLog/@"class dictionary: %@", [[self classes][identifier] dictionary]);
        ////////////////////////////////NSLog/@"class accessFlags: %@", [[self classes][identifier] accessFlags]);
        return [self classes][identifier];
    }
    ////////////////////////////////NSLog/@"class does not exist: %@", identifier);
    ////////////////////////////////NSLog/@"class count: %lu", [[self classes] count]);
    if([self parentContext] != nil) {
        return [[self parentContext] setClassReference:identifier];
    }
    return NULL;
}
- (void) setClassValue: (NSString*) identifier scriptObject: (PHPScriptObject*) scriptObject {
    ////////////////////////////////NSLog/@"set class value %@", identifier);
    if([self classes] == nil) {
        //NSMutableDictionary* classes =
        [self setClasses:[[NSMutableDictionary alloc] init]];
    }
    
    [scriptObject setClassIdentifierValue:identifier];
    [[self classes] setObject:scriptObject forKey:identifier];
    ////////////////////////////////NSLog/@"classes count : %lu", [[self classes] count]);
}
- (NSMutableDictionary*) copyClasses: (PHPInterpretation*) interpretation {
    NSMutableDictionary* classes = [[NSMutableDictionary alloc] init];
    for(NSString* key in [self classes]) {
        PHPScriptObject* class = [self classes][key];
        classes[key] = [class getNewInstance:[interpretation currentContext]];
        //[classes[key] setInterpretation:interpretation];
        //[classes[key] setInterpretationForObject:interpretation];
    }
    return classes;
}
- (NSMutableDictionary*) getClassesAsValue {
    return [self classes];
}
- (NSObject*) setVariableValueAddition: (NSObject*) name value: (NSObject*) value defineInContext: (NSNumber*) defineInContext inputParameter: (NSNumber*) inputParameter overrideThis: (NSNumber*) overrideThis method: (NSString*) method {
    NSObject* getValue = nil;
    while([name isKindOfClass:[NSArray class]]) {
        name = ((NSArray*)name)[0];
    }
    //name = [self parseInputVariable:name];
    /*value = [self parseInputVariable:value];*/
    ////NSLog(@"name: %@", name);
    ////NSLog(@"value: %@", value);
    if([name isKindOfClass:[NSString class]]) {
        [self getVariableValue:name];
    } else if([name isKindOfClass:[PHPVariableReference class]]) {
        ////NSLog(@"is variable references");
        ////NSLog(@"var reference: %@ %@ - %@", [(PHPVariableReference*)name identifier], [[(PHPVariableReference*)name context] getDictionaryValues], @([(PHPVariableReference*)name isProperty]));
        getValue = [(PHPVariableReference*)name get:nil];
    }
    ////NSLog(@"getvalue : %@", getValue);
    if([method isEqualToString:@"."]) {
        NSString* stringValue = [self makeIntoString:getValue];
        NSString* appendValue = [self makeIntoString:value];
        stringValue = [stringValue stringByAppendingString:appendValue];
        return [self setVariableValue:name value:stringValue defineInContext:defineInContext inputParameter:inputParameter overrideThis:overrideThis];
    } else {
        NSNumber* numberValue = [self makeIntoNumber:getValue];
        NSNumber* additionValue = [self makeIntoNumber:value];
        if([method isEqualToString:@"+"]) {
            numberValue = @([numberValue doubleValue] + [additionValue doubleValue]);
        } else if([method isEqualToString:@"-"]) {
            numberValue = @([numberValue doubleValue] - [additionValue doubleValue]);
        } else if([method isEqualToString:@"*"]) {
            numberValue = @([numberValue doubleValue] * [additionValue doubleValue]);
        } else if([method isEqualToString:@"/"]) {
            numberValue = @([numberValue doubleValue] / [additionValue doubleValue]);
        } /*else if([method isEqualToString:@"."]) {
           NSString*
           //numberValue = @([numberValue doubleValue] + [additionValue doubleValue]);
           }*/
        ////NSLog(@"set numberValue : %@", numberValue);
        return [self setVariableValue:name value:numberValue defineInContext:defineInContext inputParameter:inputParameter overrideThis:overrideThis];
    }
}
- (NSObject*) setVariableValue: (NSObject*) name value: (NSObject*) value defineInContext: (NSNumber*) defineInContext inputParameter: (NSNumber*) inputParameter overrideThis: (NSNumber*) overrideThis {
    /*if([name isKindOfClass:[NSString class]] && [value isKindOfClass:[PHPScriptFunction class]]) {
        PHPCallbackReference* callbackRef = [[PHPCallbackReference alloc] init];
        [callbackRef setReferenceItem:value];
        value = callbackRef;
    }*/
    /*////NSLog(@"setvariableValue : %@ %@ - %@", name, value, self);
    NSObject* debugName = name;
    while([debugName isKindOfClass:[NSArray class]]) {
        debugName = ((NSArray*)debugName)[0];
    }
    if([debugName isKindOfClass:[PHPVariableReference class]]) {
        ////NSLog(@"setVariableReference : %@", [(PHPVariableReference*)debugName identifier]);
    }*/
    /*if([value isKindOfClass:[PHPScriptFunction class]]) {
        NSString* nameParsed = name;
        if([name isKindOfClass:[PHPVariableReference class]]) {
            nameParsed = [(PHPVariableReference*)name identifier];
        }
        PHPScriptFunction* valueFunction = (PHPScriptFunction*)value;
        if([valueFunction identifier] == nil) {
            [valueFunction setIdentifier:nameParsed];
        }
    }*/
    
    @synchronized ([self variables]) {
        ////////////NSLog(@"set var value scriptfunc");
        ////////////NSLog(@"%@ : %@", name, value);
        ////////////////////////////////NSLog/@"variables: %@", [self variables]);
        ////////////////////////////////NSLog/@"dictionary: %@", [self dictionary]);
        if(value == nil) {
            value = [[PHPUndefined alloc] init]; //initWithString:@"undefined"]
        }
        bool defineInContextBool = false;
        if(defineInContext != nil) {
            //defineInContext = @false;
            defineInContextBool = [defineInContext boolValue];
        }
        bool inputParameterBool = false;
        if(inputParameter != nil) {
            //inputParameter = NULL;
            inputParameterBool = [inputParameter boolValue];
        }
        bool overrideThisBool = false;
        if(overrideThis != nil) {
            //overrideThis = @false;
            overrideThisBool = [overrideThis boolValue];
        }
        /*if([name isKindOfClass:[PHPVariableReference class]]) {
         //////////NSLog(@"identifier: %@", [(PHPVariableReference*)name identifier]);
         //////////NSLog(@"identifier: %@", [[(PHPVariableReference*)name identifier] class]);
         }*/
        ////////////////////////////////NSLog/@"flags: %i, %i, %i", defineInContextBool, inputParameterBool, overrideThisBool);
        if(!overrideThisBool && (([name isKindOfClass:[NSString class]] && [(NSString*)name isEqualToString:@"this"]) || ([name isKindOfClass:[PHPVariableReference class]] && [[(PHPVariableReference*)name identifier] isKindOfClass:[NSString class]] && [[(PHPVariableReference*)name identifier] isEqualToString:@"this"] && ![(PHPVariableReference*)name isProperty]))) {
            return @false;
        }
        NSString* stringValue = nil;
        if([value isKindOfClass:[NSString class]]) {
            stringValue = (NSString*)value;
            if([stringValue isEqualToString:@"{}"]) {
                value = [[PHPScriptObject alloc] init];
                [(PHPScriptObject*)value initArrays];
            } else if([stringValue isEqualToString:@"[]"]) {
                value = [[PHPScriptObject alloc] init];
                [(PHPScriptObject*)value initArrays];
                [(PHPScriptObject*)value setIsArray:true];
                
                /*test_a*/
                [(PHPScriptObject*)value setParentContext:nil];
                
                //[(PHPScriptObject*)value setParentContext:[self getParentContext]];
            } else if([stringValue isEqualToString:@"''"]) {
                /*value = [[PHPScriptVariable alloc] init];
                 [(PHPScriptVariable*)value construct:@"string" value:@""];*/
                value = @"";
            }
        }
        bool isProperty = false;
        bool valueIsProperty = false;
        if([value isKindOfClass:[PHPVariableReference class]]) {
            PHPVariableReference* variableReferenceValue = (PHPVariableReference*)value;
            valueIsProperty = [variableReferenceValue isProperty];
            value = [variableReferenceValue get:nil];
        }
        ////////////////////////////////NSLog/@"kind of setvarvaluefunc: %@", [value class]);
        if([value isKindOfClass:[NSMutableArray class]] || [value isKindOfClass:[NSArray class]]) {
            value = [self resolveValueArray:value];
            ////////////////////////////////NSLog/@"ins resolve value array: %@", value);
        }
        value = [self resolveValueReferenceVariableArray:value];
        if(inputParameterBool != false) {
            if([name isKindOfClass:[NSMutableDictionary class]]) {
                NSMutableDictionary* nameDictionaryValue = (NSMutableDictionary*)name;
                [[self inputParametersKeys] addObject:(NSString*)(nameDictionaryValue[@"identifier"])];
                [self inputParameters][(NSString*)(nameDictionaryValue[@"identifier"])] = nameDictionaryValue[@"value"];
            } else if(![name isKindOfClass:[PHPVariableReference class]]) {
                [[self inputParametersKeys] addObject:(NSString*)name];
                [self inputParameters][(NSString*)name] = NULL;
            } else {
                [[self inputParametersKeys] addObject:[(PHPVariableReference*)name identifier]];
                [self inputParameters][[(PHPVariableReference*)name identifier]] = NULL;
            }
        }
        if([name isKindOfClass:[PHPVariableReference class]]) {
            isProperty = [(PHPVariableReference*)name isProperty];
        }/* else {
          NSObject* previousvalue = [self getVariableValue:name];
          if(previousvalue != nil) {
          if([previousvalue isKindOfClass:[PHPScriptObject class]]) {
          
          }
          }
          }*/
        if([name isKindOfClass:[PHPVariableReference class]] && [value isKindOfClass:[PHPScriptFunction class]]) { //vantar synchronized?..
            //if([[(PHPVariableReference*)name get:self] isKindOfClass:[PHPScriptObject class]]) {
            value = [(PHPScriptFunction*)value copyScriptFunction];
            /*bool isInlineObject = false;
             if([[(PHPVariableReference*)name context] isKindOfClass:[PHPScriptObject class]]) {
             isInlineObject = true;
             }*/
            [(PHPScriptFunction*)value setPrototype:[(PHPVariableReference*)name context]];
            ////////////////////////////////NSLog/@"inside reset 1");
            [(PHPScriptFunction*)value resetThis:nil];
            //}
        }
        /*if([value isKindOfClass:[PHPScriptFunction class]]) {
         value = [NSValue valueWithNonretainedObject:value];
         }*/
        if([value isKindOfClass:[PHPReturnResult class]]) {
            value = [(PHPReturnResult*)value result];
        }
        //tokut-nyjasta VIP
        if(([name isKindOfClass:[NSMutableArray class]])) {
            //[self variables][()]
            if([name isKindOfClass:[NSMutableArray class]]) {
                name = ((NSMutableArray*)name)[0];
            }
        }
        
        if([name isKindOfClass:[PHPVariableReference class]]) {
            PHPVariableReference* nameVariableReference = (PHPVariableReference*)name;
            //////NSLog(@"set var reference : %@ - %@", [(PHPVariableReference*)nameVariableReference identifier], value);
            //referencevidbot
            /*if([value isKindOfClass:[PHPScriptFunction class]]) {
             PHPReferenceItem* refItem = [[PHPReferenceItem alloc] init];
             
             }*/
            [nameVariableReference set:value context:self]; //[self currentObjectFunctionContext] //self
        } else {
            //////NSLog(@"set variable value : %@ - %@ - %@ - %@ - %@", name, value, [self variables], [self parentContext], defineInContext);
            NSString* nameString = (NSString*)name;
            //VIP-BREYTING
            NSMutableDictionary* variableContainer = (NSMutableDictionary*)[self getVariableContainer:nameString];
            if(/*defineInContext &&*/ variableContainer == NULL) {
                [self variables][nameString] = value;
            } else if([self variables][nameString] != nil || defineInContextBool || ([self parentContext] == nil || [self parentContext] == NULL)) {
                //////NSLog(@"set this value: %@", name);
                //if(!([value isKindOfClass:[NSString class]] && [(NSString*)value isEqualToString:@"undefined"])) {
                [self variables][nameString] = value;
                //variableContainer[nameString] = value;
                /*if([value isKindOfClass:[PHPScriptFunction class]]) {
                 [self setContainsFunctionValue:true];
                 }*/
                /*if([value isKindOfClass:[PHPScriptFunction class]]) {
                 @synchronized (value) {
                 [(PHPScriptFunction*)value setReferenceCounter:[(PHPScriptFunction*)value referenceCounter]+1];
                 }
                 }*/
                /*for(NSObject* variable in [self variables]) {
                 if([variable isKindOfClass:[PHPScriptFunction class]]) {
                 @synchronized (variable) {
                 [(PHPScriptFunction*)variable setReferenceCounter:[(PHPScriptFunction*)variable referenceCounter]-1];
                 }
                 }
                 }*/
                //}
            } else if([self parentContext] != nil || [self parentContext] != NULL) {
                //////NSLog(@"set parent value: %@", name);
                if([self prototype] == nil) {
                    [[self parentContext] setVariableValue:name value:value defineInContext:nil inputParameter:nil overrideThis:nil];
                } else {
                    /*if([value isKindOfClass:[PHPScriptFunction class]]) {
                     [self setContainsFunctionValue:true];
                     }*/
                    [self variables][nameString] = value;
                    /*if([value isKindOfClass:[PHPScriptFunction class]]) {
                     @synchronized (value) {
                     [(PHPScriptFunction*)value setReferenceCounter:[(PHPScriptFunction*)value referenceCounter]+1];
                     }
                     }*/
                }
            }
        }
        return value;
    }
}
- (NSObject*) setVariableValueInContext: (NSObject*) name value: (NSObject*) value defineInContext: (NSNumber*) defineInContext inputParameter: (NSNumber*) inputParameter overrideThis: (NSNumber*) overrideThis context:(PHPScriptFunction*) context {
    //////NSLog(@"inside scriptfunctionsetVariableValueInContext: %@ - %@", name, value);
    if(value == nil) {
        
    }
    if(inputParameter == nil) {
        defineInContext = @false;
    }
    if(defineInContext == nil) {
        defineInContext = @true;
    }
    if(overrideThis == nil) {
        overrideThis = @false;
    }
    return [self setVariableValue:name value:value defineInContext:defineInContext inputParameter:inputParameter overrideThis:overrideThis];
}
- (NSObject*) prepareSetValue: (NSObject*) value {
    if([value isKindOfClass:[NSString class]]) {
        NSString* valueString = (NSString*)value;
        if([valueString isEqualToString:@"{}"]) {
            value = [[PHPScriptObject alloc] init];
            [(PHPScriptObject*)value initArrays];
        } else if([valueString isEqualToString:@"[]"]) {
            value = [[PHPScriptObject alloc] init];
            [(PHPScriptObject*)value initArrays];
            [(PHPScriptObject*)value setIsArray:true];
        } else if([valueString isEqualToString:@"''"]) {
            /*value = [[PHPScriptVariable alloc] init];
            [(PHPScriptVariable*)value construct:@"string" value:@""];*/
            value = @"";
        }
    }
    value = [self resolveValueReferenceVariableArray:value];
    value = [self resolveVariableReturn:value];
    return value;
}
- (NSObject*) setVariableIncrement: (NSObject*) reference {
    NSObject* value;
    if([reference isKindOfClass:[PHPVariableReference class]]) {
        PHPVariableReference* referenceValue = (PHPVariableReference*)reference;
        value = [referenceValue get:nil];
        NSNumber* numberValue = [self makeIntoNumber:value];
        numberValue = [[NSNumber alloc] initWithDouble:[numberValue doubleValue]+1];
        [referenceValue set:numberValue context:nil];
    } else {
        value = [self getVariableValue:(NSString*)reference];
        NSNumber* numberValue = [self makeIntoNumber:value];
        numberValue = [[NSNumber alloc] initWithDouble:[numberValue doubleValue]+1];
        [self setVariableValue:reference value:numberValue defineInContext:nil inputParameter:nil overrideThis:nil];
    }
    return value;
}
- (NSObject*) setVariableDecrement: (NSObject*) reference {
    NSObject* value;
    if([reference isKindOfClass:[PHPVariableReference class]]) {
        PHPVariableReference* referenceValue = (PHPVariableReference*)reference;
        value = [referenceValue get:nil];
        NSNumber* numberValue = [self makeIntoNumber:value];
        numberValue = [[NSNumber alloc] initWithDouble:[numberValue doubleValue]-1];
        [referenceValue set:numberValue context:nil];
    } else {
        value = [self getVariableValue:(NSString*)reference];
        NSNumber* numberValue = [self makeIntoNumber:value];
        numberValue = [[NSNumber alloc] initWithDouble:[numberValue doubleValue]-1];
        [self setVariableValue:reference value:numberValue defineInContext:nil inputParameter:nil overrideThis:nil];
    }
    return value;
}
- (NSObject*) getDictionaryValue:(NSObject *)name returnReference:(NSNumber *)returnReference createIfNotExists:(NSNumber *)createIfNotExists context: (PHPScriptFunction*) context {
    //////////////////////////////NSLog/@"call get dictionaryValue: %@", name);
    if(returnReference == nil) {
        returnReference = @false;
    }
    if(createIfNotExists == nil) {
        createIfNotExists = @true;
    }
    bool returnReferenceBool = [returnReference boolValue];
    bool createIfNotExistsBool = [createIfNotExists boolValue];
    if([name isKindOfClass:[NSString class]]) {
        NSString* nameString = (NSString*)name;
        if([self dictionary][nameString] != nil) {
            if(returnReferenceBool) {
                PHPVariableReference* reference = [[PHPVariableReference alloc] init];
                [reference construct:nameString context:self isProperty:@true defineInContext:nil ignoreSetContext:nil];
                return reference;
            }
            return [self dictionary][nameString];
        }
        if(createIfNotExistsBool) {
            [self dictionary][nameString] = [[PHPUndefined alloc] init]; //initWithString:@"undefined"
            if(returnReferenceBool) {
                PHPVariableReference* reference = [[PHPVariableReference alloc] init];
                [reference construct:nameString context:self isProperty:@true defineInContext:nil ignoreSetContext:nil];
                return reference;
            }
            return [self dictionary][nameString];
        }
    }
    return NULL;
}
- (void) setDictionaryValue: (NSObject*) name value: (NSObject*) value context:(PHPScriptFunction*) context {
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
    value = [self prepareSetValue:value];
    //if([self prototypeIsInline])
    [self dictionary][(NSString*)name] = value;
    ////////////////////////////////NSLog/@"setDictvalueFunc");
}
/*- (void) setClass: (PHPScriptObject*) class {
    [self setClass:class];
}*/
- (void) setFunctionIdentifier: (NSString*) identifier {
    [self setIdentifier:identifier];
    //NSLog(@"set identifier : %@", identifier);
    [[self classValueClass] setDictionaryValue:identifier value:self context:nil];
}
//- (PHPScriptFunction*) createScriptFunction:(NSNumber *)isAsync
- (PHPScriptObject*) createScriptObject: (NSObject*) values {
    PHPScriptObject* script_object = [[PHPScriptObject alloc] init];
    [script_object initArrays];
    ////////////NSLog(@"createScriptObject1: %@", self);
    [script_object construct:self];
    return script_object;
};
- (PHPScriptObject*) createScriptObjectClass:(NSObject *)values {
    PHPScriptObject* result = [[PHPScriptObject alloc] init];
    [result initArrays];
    //[result setStrongParentContext:self];
    ////////////NSLog(@"isClass: %@", result);
    return result;
}
- (PHPScriptFunction*) createScriptFunction:(NSNumber *)isAsync {
    ////////////////////////NSLog(@"is async: %@ - %i", isAsync, [isAsync boolValue]);
    PHPScriptFunction* scriptFunction = [[PHPScriptFunction alloc] init];
    [scriptFunction initArrays];
    //if(isAsync != nil) {
        [scriptFunction setIsAsync:[isAsync boolValue]];
    /*} else {
        [scriptFunction setIsAsync:false];
    }*/
    //[scriptFunction setPrototype:self];
    [scriptFunction construct:self];
    return scriptFunction;
}
- (PHPScriptObject*) createScriptObjectFunc: (NSObject*) values {
    PHPScriptObject* scriptObject = [[PHPScriptObject alloc] init];
    [scriptObject initArrays];
    ////////////NSLog(@"createScriptObject2: %@", scriptObject);
    [scriptObject construct:self];
    return scriptObject;
}
- (PHPScriptFunction*) setParametersNamed: (NSObject*) identifier parameters: (NSObject*) parameters scriptIndexReference: (NSObject*) scriptIndexReference {
    if(scriptIndexReference == nil) {
        scriptIndexReference = NULL;
    }
    if([parameters isKindOfClass:[PHPScriptEvaluationReference class]]) {
        [self setScriptIndexReference:(PHPScriptEvaluationReference*)parameters];
        parameters = [[NSMutableArray alloc] init];
    }
    [self setFunctionIdentifier:(NSString*)identifier];
    [self setFunctionName:(NSString *)identifier];
    /*if([[self functionName] containsString:@"__cached"]) {
        //////NSLog(@"functionName : %@", [self functionName]);
        [self setCache:[[NSMutableDictionary alloc] init]];
    }*/
    [self setScriptIndexReference:(PHPScriptEvaluationReference*)scriptIndexReference];
    NSMutableArray* parametersArray = (NSMutableArray*)parameters;
    for(NSString* parameter in parametersArray) {
        [self setVariableValue:parameter value:NULL defineInContext:@true inputParameter:@true overrideThis:nil];
    }
    
    /*if([(NSString*)identifier isEqualToString:@"__construct"]) {
        //NSLog(@"constrcutor dict is : %@ - %@ - %@", [self scriptIndexReference], [[self scriptIndexReference] subObjectDict], [[self scriptIndexReference] subObjectDict][@"label"]);
        //[(PHPScriptEvaluationReference*)scriptIndexReference subObjectDict][@"sub_parse_objects"][0][@"is_constructor_node"] = @true;
        NSLog(@"script eval ref  dict : %@", [(PHPScriptEvaluationReference*)scriptIndexReference subObjectDict][@"sub_parse_objects"][0][@"label"]);
    }*/
    
    return self;
}
- (PHPScriptFunction*) setParameters: (NSMutableArray*) parameters scriptIndexReference: (NSObject*) scriptIndexReference {
    [self setScriptIndexReference:(PHPScriptEvaluationReference*)scriptIndexReference];
    for(NSString* parameter in parameters) {
        [self setVariableValue:parameter value:NULL defineInContext:@true inputParameter:@true overrideThis:nil];
    }
    return self;
}
- (NSMutableArray*) numericDivision: (NSObject*) valueA valueB: (NSObject*) valueB {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    PHPValuesOperator* valueOperator = [[PHPValuesOperator alloc] init];
    [valueOperator setOperatorValue:@"/"];
    if(![valueB isKindOfClass:[NSArray class]]) {
        NSMutableArray* subArrayValue = [[NSMutableArray alloc] init];
        [subArrayValue addObject:valueA];
        [subArrayValue addObject:valueOperator];
        [subArrayValue addObject:valueB];
        [result addObject:subArrayValue];
        //[result addObject:@[valueA, valueOperator, valueB]];
        return result;
    } else {
        //result = (NSMutableArray*)@[valueA, valueOperator];
        NSMutableArray* subArrayValue = [[NSMutableArray alloc] init];
        [result addObject:valueA];
        [result addObject:valueOperator];
        NSMutableArray* concatArray = [[NSMutableArray alloc] init];
        [concatArray addObject:valueB];
        [result addObjectsFromArray:concatArray];
        NSMutableArray* returnResult = [[NSMutableArray alloc] init];
        [returnResult addObject:result];
        return returnResult;
        //return (NSMutableArray*)(@[result]);
    }
    return nil;
}
- (NSMutableArray*) numericSubtraction: (NSObject*) valueA valueB: (NSObject*) valueB {
    //NSLog(@"in numericSubtraction %@ %@", valueA, valueB);
    PHPValuesOperator* valueOperator = [[PHPValuesOperator alloc] init];
    [valueOperator setOperatorValue:@"-"];
    if(valueB == nil) {
        //NSLog(@"valueb is nil");
        if(![valueA isKindOfClass:[NSArray class]]) {
            //NSLog(@"valueb is nil-1");
            NSMutableArray* subValueResult = [[NSMutableArray alloc] init];
            [subValueResult addObject:valueOperator];
            [subValueResult addObject:valueA];
            return subValueResult;
            //return (NSMutableArray*)@[valueOperator, valueA];
        } else {
            //NSLog(@"valueb is nil-2");
            NSMutableArray* valueAArray = (NSMutableArray*)valueA;
            NSObject* valueFirst = valueAArray[0];
            [valueAArray removeObject:valueFirst];
            NSMutableArray* result = [[NSMutableArray alloc] init];//(NSMutableArray*)@[valueOperator, valueFirst];
            [result addObject:valueOperator];
            [result addObject:valueFirst];
            [result addObjectsFromArray:(NSMutableArray*)valueA];
            return result;
        }
    }
    if(![valueB isKindOfClass:[NSArray class]]) {
        //NSLog(@"in last first case");
        NSMutableArray* subValueResult = [[NSMutableArray alloc] init];
        [subValueResult addObject:valueA];
        [subValueResult addObject:valueOperator];
        [subValueResult addObject:valueB];
        return subValueResult;
        //return (NSMutableArray*)@[valueA, valueOperator, valueB];
    } else {
        //NSLog(@"in last case");
        NSMutableArray* result = [[NSMutableArray alloc] init];//(NSMutableArray*)@[valueA, valueOperator];
        [result addObject:valueA];
        [result addObject:valueOperator];
        [result addObjectsFromArray:(NSMutableArray*)valueB];
        return result;
    }
    //NSLog(@"return nil");
    return nil;
}
- (NSMutableArray*) numericMultiplication: (NSObject*) valueA valueB: (NSObject*) valueB {
    PHPValuesOperator* valueOperator = [[PHPValuesOperator alloc] init];
    [valueOperator setOperatorValue:@"*"];
    if(![valueB isKindOfClass:[NSArray class]]) {
        NSMutableArray* subValueResult = [[NSMutableArray alloc] init];
        [subValueResult addObjectsFromArray:@[valueA, valueOperator, valueB]];
         return subValueResult;
        //return (NSMutableArray*)@[valueA, valueOperator, valueB];
    } else {
        NSMutableArray* result = [[NSMutableArray alloc] initWithArray:@[valueA, valueOperator]];
        [result addObjectsFromArray:(NSMutableArray*)valueB];
        return result;
    }
    return nil;
}
- (NSMutableArray*) numericModulo: (NSObject*) valueA valueB: (NSObject*) valueB {
    PHPValuesOperator* valueOperator = [[PHPValuesOperator alloc] init];
    [valueOperator setOperatorValue:@"%"];
    if(![valueB isKindOfClass:[NSArray class]]) {
        NSMutableArray* subValueResult = [[NSMutableArray alloc] init];
        [subValueResult addObjectsFromArray:@[valueA, valueOperator, valueB]];
         return subValueResult;
        //return (NSMutableArray*)@[valueA, valueOperator, valueB];
    } else {
        NSMutableArray* result = [[NSMutableArray alloc] initWithArray:@[valueA, valueOperator]];
        [result addObjectsFromArray:(NSMutableArray*)valueB];
        return result;
    }
    return nil;
}
- (NSMutableArray*) numericAddition: (NSObject*) valueA valueB: (NSObject*) valueB {
    PHPValuesOperator* valueOperator = [[PHPValuesOperator alloc] init];
    [valueOperator setOperatorValue:@"+"];
    if(![valueB isKindOfClass:[NSArray class]]) {
        return [[NSMutableArray alloc] initWithArray:@[valueA, valueOperator, valueB]];
    } else {
        NSMutableArray* result = [[NSMutableArray alloc] initWithArray:@[valueA, valueOperator]];
        [result addObjectsFromArray:(NSMutableArray*)valueB];
        return result;
    }
    return nil;
}
- (NSMutableArray*) stringAddition: (NSObject*) valueA valueB: (NSObject*) valueB {
    PHPValuesOperator* valueOperator = [[PHPValuesOperator alloc] init];
    [valueOperator setOperatorValue:@"."];
    if(![valueB isKindOfClass:[NSMutableArray class]]) {
        return [[NSMutableArray alloc] initWithArray:@[valueA, valueOperator, valueB]];
    } else {
        NSMutableArray* result = [[NSMutableArray alloc] initWithArray:@[valueA, valueOperator]];
        [result addObjectsFromArray:(NSMutableArray*)valueB];
        return result;
    }
    return nil;
}
- (NSObject*) setParanthesis: (NSObject*) value {
    if([value isKindOfClass:[PHPScriptObject class]] || [value isKindOfClass:[PHPScriptFunction class]] || [value isKindOfClass:[PHPScriptEvaluationReference class]]) {
        return value;
    }
    return [[NSMutableArray alloc] initWithArray:@[value]];
}
- (NSObject*) returnFollowingResult: (NSObject*) value {
    if(value == nil) {
        value = NULL;
    }
    return value;
}
- (NSObject*) returnValueResult: (NSObject*) value {
    if([value isKindOfClass:[PHPVariableReference class]]) {
        value = [(PHPVariableReference*)value get:nil];
    }
    if([value isKindOfClass:[NSMutableArray class]]) {
        value = [self resolveValueArray:value];
    }
    PHPReturnResult* returnResult = [[PHPReturnResult alloc] init];
    [returnResult setInterpretation:[self getInterpretation]];
    [returnResult construct:value];
    ////////////NSLog(@"create returnValueResult %@ : %@", value, returnResult);
    return returnResult;
}
- (void) setClosure: (NSObject*(^)(NSMutableArray*, PHPScriptFunction*)) closure name: (NSString*) name {
    [self closures][name] = closure;
}
- (NSObject*) callClosure: (NSMutableArray*) parameters name: (NSString*) name {
    return ((NSObject*(^)(NSMutableArray*, PHPScriptFunction*))[self closures][name])(parameters, self);
}
- (NSObject*) callScriptFunctionReference: (PHPVariableReference*) identifierReference parameterValues: (NSMutableArray*) parameterValues awaited: (NSNumber*) awaited {
    
    NSLog(@"callScriptFunctionReference---");
    return [self callScriptFunction:identifierReference parameterValues:parameterValues awaited:awaited];
}
- (NSObject*) callScriptFunction: (PHPVariableReference*) identifierReference parameterValues: (NSMutableArray*) parameterValues awaited: (NSNumber*) awaited returnObject: (NSNumber*) returnObject {
    NSLog(@"callScriptFunction---");
    /*if(awaited == nil) {
        awaited = @false;
    }
    if(returnObject == nil) {
        returnObject = @false;
    }
    NSString* identifierName = [identifierReference identifier];
    PHPScriptFunction* scriptFunction = (PHPScriptFunction*)[self getVariableValue:identifierName];
    return [self callScriptFunctionSub:scriptFunction parameterValues:parameterValues awaited:awaited returnObject:returnObject interpretation:nil];*/
    return nil;
}


/*- (void) resetResetableParseObjects: (NSMutableDictionary*) input {
    for(NSObject* parseObjectKey in input) {
        NSMutableDictionary* parseObject = input[parseObjectKey];
        if([parseObject objectForKey:@"controlObject"] != nil) {
            [parseObject removeObjectForKey:@"controlObject"];
            [parseObject removeObjectForKey:@"variableReferenceItemObject"];
        }
        [self resetResetableParseObjects:parseObject];
    }
}*/
/*- (void) resetResetableParseObjects {
    
    NSValue* valueItem = [self nsValue];//
    //NSLog(@"reset : %@", @([[self resetableParseObjects] count]));
    for(NSMutableDictionary* parseObject in [self resetableParseObjects]) {
        
    }
}*/

- (void) initParseObjectCaches {
    /*[self parseObjectCaches][@"controlObject"] = [[NSMutableDictionary alloc] init];
    [self parseObjectCaches][@"variableReferenceItemObject"] = [[NSMutableDictionary alloc] init];
    [self parseObjectCaches][@"variableReferenceItemCallback"] = [[NSMutableDictionary alloc] init];
    [self parseObjectCaches][@"variableReferenceItemCallbackValues"] = [[NSMutableDictionary alloc] init];*/
}
- (void) resetResetableParseObjects {
    
}

- (bool) containedAsync {
    if([self isAsync]) {
        return true;
    }
    if([self prototype] == nil) {
        if([self parentContext] != nil) {
            return [[self parentContext] containedAsync];
        }
    }
    return false;
}

/*- (void) resetResetableParseObjects {
    NSValue* valueItem = [self nsValue];//
    //NSLog(@"reset : %@", @([[self resetableParseObjects] count]));
    for(NSMutableDictionary* parseObject in [self resetableParseObjects]) {
        //NSLog(@"reset parse objects : %@", parseObject);
        if([parseObject objectForKey:@"controlObject"] != nil) {
            //NSLog(@"parseobject controlobject : %@", parseObject[@"controlObject"]);
            //[parseObject removeObjectForKey:@"controlObject"];
            if(parseObject[@"controlObject"][valueItem] != nil) {
                [parseObject[@"controlObject"] removeObjectForKey:valueItem];
            }
        } else {
            parseObject[@"controlObject"] = [[NSMutableDictionary alloc] init];
        }
        if([parseObject objectForKey:@"variableReferenceItemObject"] != nil) {
            //NSLog(@"parseobject variableReferenceItemObject : %@", parseObject[@"variableReferenceItemObject"]);
            if(parseObject[@"variableReferenceItemObject"][valueItem] != nil) {
                [parseObject[@"variableReferenceItemObject"] removeObjectForKey:valueItem];
            }
            //[parseObject removeObjectForKey:@"variableReferenceItemObject"];
        } else {
            parseObject[@"variableReferenceItemObject"] = [[NSMutableDictionary alloc] init];
        }
        if([parseObject objectForKey:@"variableReferenceItemCallback"] != nil) {
            //NSLog(@"parseobject variableReferenceItemObject : %@", parseObject[@"variableReferenceItemObject"]);
            if(parseObject[@"variableReferenceItemCallback"][valueItem] != nil) {
                [parseObject[@"variableReferenceItemCallback"] removeObjectForKey:valueItem];
            }
            //[parseObject removeObjectForKey:@"variableReferenceItemCallback"];
        } else {
            parseObject[@"variableReferenceItemCallback"] = [[NSMutableDictionary alloc] init];
        }
        if([parseObject objectForKey:@"variableReferenceItemCallbackValues"] != nil) {
            //NSLog(@"parseobject variableReferenceItemObject : %@", parseObject[@"variableReferenceItemObject"]);
            if(parseObject[@"variableReferenceItemCallbackValues"][valueItem] != nil) {
                [parseObject[@"variableReferenceItemCallbackValues"] removeObjectForKey:valueItem];
            }
            //[parseObject removeObjectForKey:@"variableReferenceItemCallbackValues"];
        } else {
            parseObject[@"variableReferenceItemCallbackValues"] = [[NSMutableDictionary alloc] init];
        }
        //[parseObject removeObjectForKey:@"variableReferenceItemObject"];
    }
    [[self resetableParseObjects] removeAllObjects];
}
/*

 
 */

@end
