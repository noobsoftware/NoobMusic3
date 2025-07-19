//
//  PHPVariableReference.m
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//


#import "PHPVariableReference.h"
#import "PHPScriptObject.h"
#import "PHPScriptFunction.h"
#import "PHPInterpretation.h"

@implementation PHPVariableReference
- (void) construct: (NSString*) identifier context: (PHPScriptObject*) /*__weak*/ context isProperty: (NSNumber*) isProperty defineInContext: (NSNumber*) defineInContext ignoreSetContext: (NSNumber*) ignoreSetContext {
    ////NSLog(@"identifier is : %@", identifier);
    if(context == nil) {
        context = NULL;
    }
    if(isProperty == nil) {
        isProperty = @false;
    }
    if(defineInContext == nil) {
        defineInContext = @false;
    }
    if(ignoreSetContext == nil) {
        ignoreSetContext = @false;
    }
    //if(isProperty)
    [self setIdentifier:identifier];
    [self setContext:context];
    [self setIsProperty:[isProperty boolValue]];
    [self setDefineInContext:[defineInContext boolValue]];
    [self setIgnoreSetContext:[ignoreSetContext boolValue]];
}
- (void) resetContext: (PHPScriptFunction*) context {
    [self setContext:context];
}
/*- (void) setIgnoreSetContext:(bool)ignoreSetContext {
    
}*/

- (void) debugTest: (NSMutableDictionary*) variables {
    for(NSObject* key in variables) {
        NSObject* keyValue = key;
        if([key isKindOfClass:[NSMutableArray class]]) {
            keyValue = (NSObject*)((NSMutableArray*)key)[0];
        }
        if([key isKindOfClass:[PHPVariableReference class]]) {
            PHPVariableReference* var = (PHPVariableReference*)key;
            ////NSLog(@"key is %@ - %@", [var identifier], [var get:nil]);
        }
        ////NSLog(@"value is : %@", [[[self context] interpretation] toJSON:variables[key]]);
    }
}

- (NSObject*) get: (PHPScriptFunction*) context {
    /*ToJSON* toJSON = [[ToJSON alloc] init];
    NSObject* json = @"";*/
    /*if([self itemValue] != nil) {
        if(![[self itemValue] isKindOfClass:[PHPScriptFunction class]]) {
            json = [toJSON toJSONString:[self itemValue]];
        } else {
            json = [self itemValue];
        }
        NSLog(@"itemValue : %@", json);
        //return [self itemValue];
    }
    if(![value isKindOfClass:[PHPScriptFunction class]]) {
        json = [toJSON toJSONString:value];
        NSLog(@"set itemValue : %@", json);
        [self setItemValue:value];
    }*/
    /*if([self itemValue] != nil) {
        return [self itemValue];
    }*/
    NSObject* value = [self getSub:context];
    //[self setItemValue:value];
    /*if([value isKindOfClass:[NSValue class]]) {
        return [(NSValue*)value nonretainedObjectValue];
    }*/
    return value;
}

- (NSObject*) getSub: (PHPScriptFunction*) context {
    ////NSLog(@"called get: %@", [self identifier]);
    ////////////////////////////////NSLog/@"kind of context: %@", [[self context] class]);
    /*if([self itemContainer] != nil) {
        //NSLog(@"used item container");
        if([[self itemContainer] isKindOfClass:[NSDictionary class]]) {
            return ((NSDictionary*)[self itemContainer])[[self identifier]];
        } else {
            return ((NSArray*)[self itemContainer])[[[self identifier] longLongValue]];
        }
    }*/
    if([self isProperty]) {
        //////NSLog(@"is property");
        if([[self context] isArray]) {
            //////NSLog(@"called get1:");
            //NSObject* intermediateResult =
            //////NSLog(@"self contex is : %@", [self context]);
            /*if([(PHPScriptObject*)[self context] isArray]) {
                [self setItemContainer:[(PHPScriptObject*)[self context] dictionaryArray]];
            } else {*/
                //[self setItemContainer:[(PHPScriptObject*)[self context] getDictionary]];
            //}
            NSObject* intermediateResult = [(PHPScriptObject*)[self context] getVariableValue:[self identifier]];//[(PHPScriptObject*)context getDictionaryValue:[self identifier] returnReference:@false createIfNotExists:@false context:nil];//[context getVariableValue:[self identifier]];//[[[self context] currentObjectFunctionContext] getVariableValue:[self identifier]];
            //////NSLog(@"intermediateResult : %@ identifier : %@ - %@", intermediateResult, [self identifier], [[self context] dictionaryArray]);
            return intermediateResult;
            /*if([self currentContext] != nil) {
                //[self debugTest:[[self currentContext] variables]];
                //////NSLog(@"currentContextIs: %@ %@ valueIS: %@ - %@", [self identifier], [self currentContext],  [[self currentContext] getVariableValue:[self identifier]], [[self currentContext] variables]);
                return [[self currentContext] getVariableValue:[self identifier]];
            }
            ////////////NSLog(@"no-current-context2 valueIs: %@", [[[self context] parentContext] getVariableValue:[self identifier]]);
            return [[[self context] parentContext] getVariableValue:[self identifier]];*/
        } else {
            //////NSLog(@"called get2");
            ////////////NSLog(@"called get2: valueIs: %@", [[self context] getDictionaryValue:[self identifier] returnReference:nil createIfNotExists:nil]);
            
            //[self setItemContainer:[(PHPScriptObject*)[self context] getDictionary]];
            NSObject* intermediateResult = [[self context] getDictionaryValue:[self identifier] returnReference:nil createIfNotExists:nil context:context];
            
            //////NSLog(@"intermediateResult : %@", intermediateResult);
            return intermediateResult;
        }
    } else {
        //////NSLog(@"is not property");
        if(([[self context] isKindOfClass:[PHPScriptObject class]] && ![[self context] isKindOfClass:[PHPScriptFunction class]])) {
            //////NSLog(@"called get3:");
            //Breyta i currentFunctionContext
            //////NSLog(@"currentContext is : %@ - %@", [self currentContext], [[self context] currentObjectFunctionContext]);
            if([self currentContext] != nil) {
                ////////////NSLog(@"currentContextIs: %@ valueIs: %@ - %@", [self currentContext], [[self currentContext] getVariableValue:[self identifier]], [[self currentContext] variables]);
                //////NSLog(@"initial");
                //[self setItemContainer:[(PHPScriptFunction*)[self context] variables]];
                //[self setItemContainer:[[self context] getDictionary]];
                //[self setItemContainer:[(PHPScriptFunction*)[self context] getVariableContainer:[self identifier]]];
                //[self setItemContainer:[(PHPScriptFunction*)[self currentContext] getVariableContainer:[self identifier]]];
                return [[self currentContext] getVariableValue:[self identifier]];
            }
            /*if(context != nil && [context parentContext] != nil) {
                NSObject* intermediateResult = [[context parentContext] getVariableValue:[self identifier]];
                return intermediateResult;
            }*/
            /*if([[self context] currentObjectFunctionContext] != nil) {
                NSObject* intermediateResult = [[[self context] currentObjectFunctionContext] getVariableValue:[self identifier]];
                //////NSLog(@"intermediateResult0 : %@", intermediateResult);
                return intermediateResult;
            }*/
            ////////////NSLog(@"no-current-context1 valueIs: %@", [[[self context] parentContext] getVariableValue:[self identifier]]);
            //return [[[self context] currentObjectFunctionContext] getVariableValue:[self identifier]];
            if([[self context] parentContext] != NULL) {
                //[self setItemContainer:[(PHPScriptFunction*)[[self context] parentContext] getVariableContainer:[self identifier]]];
                NSObject* intermediateResult = [[[self context] parentContext] getVariableValue:[self identifier]];
                //////NSLog(@"intermediateResult1 : %@", intermediateResult);
                return intermediateResult;
            }
        }
        //////NSLog(@"called get4:");
        ////////////////////NSLog(@"called get4: context: %@, current_context: %@ valueIs: %@", [(PHPScriptFunction*)[self context] debugFunctionValue], [(PHPScriptFunction*)[self currentContext] debugFunctionValue], [(PHPScriptFunction*)[self context] getVariableValue:[self identifier]]);
        ////////////NSLog(@"variables are: %@ - %@", [(PHPScriptFunction*)[self context] variables], [(PHPScriptFunction*)[self currentContext] variables]);
        //[self setItemContainer:[(PHPScriptFunction*)[self context] getVariableContainer:[self identifier]]];
        NSObject* intermediateResult = [(PHPScriptFunction*)[self context] getVariableValue:[self identifier]];
        //if(intermediateResult != nil) {
            //////NSLog(@"intermediateResult2 : %@", intermediateResult);
            return intermediateResult;
        /*} else {
            if([[self context] currentObjectFunctionContext] != nil) {
                NSObject* intermediateResult = [[[self context] currentObjectFunctionContext] getVariableValue:[self identifier]];
                //////NSLog(@"intermediateResult0 : %@", intermediateResult);
                return intermediateResult;
            }
        }*/
        return nil;
    }
}

/*- (NSObject*) get {
    //////NSLog(@"called get: %@", [self identifier]);
    ////////////////////////////////NSLog/@"kind of context: %@", [[self context] class]);
    if([self isProperty]) {
        //////NSLog(@"is property");
        if([[self context] isArray]) {
            //////NSLog(@"called get1:");
            NSObject* intermediateResult = [[[self context] currentObjectFunctionContext] getVariableValue:[self identifier]];
            //////NSLog(@"intermediateResult : %@", intermediateResult);
            return intermediateResult;
            if([self currentContext] != nil) {
                //[self debugTest:[[self currentContext] variables]];
                //////NSLog(@"currentContextIs: %@ %@ valueIS: %@ - %@", [self identifier], [self currentContext],  [[self currentContext] getVariableValue:[self identifier]], [[self currentContext] variables]);
                return [[self currentContext] getVariableValue:[self identifier]];
            }
            ////////////NSLog(@"no-current-context2 valueIs: %@", [[[self context] parentContext] getVariableValue:[self identifier]]);
            return [[[self context] parentContext] getVariableValue:[self identifier]];
        } else {
            //////NSLog(@"called get2");
            ////////////NSLog(@"called get2: valueIs: %@", [[self context] getDictionaryValue:[self identifier] returnReference:nil createIfNotExists:nil]);
            NSObject* intermediateResult = [[self context] getDictionaryValue:[self identifier] returnReference:nil createIfNotExists:nil context:nil];
            
            //////NSLog(@"intermediateResult : %@", intermediateResult);
            return intermediateResult;
        }
    } else {
        //////NSLog(@"is not property");
        if(([[self context] isKindOfClass:[PHPScriptObject class]] && ![[self context] isKindOfClass:[PHPScriptFunction class]])) {
            //////NSLog(@"called get3:");
            //Breyta i currentFunctionContext
            /*if([self currentContext] != nil) {
                ////////////NSLog(@"currentContextIs: %@ valueIs: %@ - %@", [self currentContext], [[self currentContext] getVariableValue:[self identifier]], [[self currentContext] variables]);
                return [[self currentContext] getVariableValue:[self identifier]];
            }*/
            /*if([[self context] currentObjectFunctionContext] != nil) {
                NSObject* intermediateResult = [[[self context] currentObjectFunctionContext] getVariableValue:[self identifier]];
                //////NSLog(@"intermediateResult0 : %@", intermediateResult);
                return intermediateResult;
            }
            ////////////NSLog(@"no-current-context1 valueIs: %@", [[[self context] parentContext] getVariableValue:[self identifier]]);
            //return [[[self context] currentObjectFunctionContext] getVariableValue:[self identifier]];
            if([[self context] parentContext] != NULL) {
                NSObject* intermediateResult = [[[self context] parentContext] getVariableValue:[self identifier]];
                //////NSLog(@"intermediateResult1 : %@", intermediateResult);
                return intermediateResult;
            }
        }
        //////NSLog(@"called get4:");
        ////////////////////NSLog(@"called get4: context: %@, current_context: %@ valueIs: %@", [(PHPScriptFunction*)[self context] debugFunctionValue], [(PHPScriptFunction*)[self currentContext] debugFunctionValue], [(PHPScriptFunction*)[self context] getVariableValue:[self identifier]]);
        ////////////NSLog(@"variables are: %@ - %@", [(PHPScriptFunction*)[self context] variables], [(PHPScriptFunction*)[self currentContext] variables]);
        NSObject* intermediateResult = [(PHPScriptFunction*)[self context] getVariableValue:[self identifier]];
        //if(intermediateResult != nil) {
            //////NSLog(@"intermediateResult2 : %@", intermediateResult);
            return intermediateResult;
        /*} else {
            if([[self context] currentObjectFunctionContext] != nil) {
                NSObject* intermediateResult = [[[self context] currentObjectFunctionContext] getVariableValue:[self identifier]];
                //////NSLog(@"intermediateResult0 : %@", intermediateResult);
                return intermediateResult;
            }
        }*/
        /*return nil;
    }
}*/
- (void) set: (NSObject*) value context: (PHPScriptFunction*) context {
    //////NSLog(@"set variable reference value: %@ - identifier: %@ - %@ - context: %@ context is %@ is prop: %i", value, [self identifier], [[self context] identifier], [self context], [[self context] class], [self isProperty]);
    ///
    /*if([value isKindOfClass:[PHPScriptFunction class]]) {
        value = [NSValue valueWithNonretainedObject:value];
        //return [(NSValue*)value nonretainedObjectValue];
    }*/
    /*if([self itemContainer] != nil) {
        //NSLog(@"used item container");
        if([[self itemContainer] isKindOfClass:[NSDictionary class]]) {
            if([value isKindOfClass:[PHPScriptFunction class]]) {
               value = [NSValue valueWithNonretainedObject:value];
            }
            ((NSMutableDictionary*)[self itemContainer])[[self identifier]] = value;
        } else {
            NSMutableArray* arrContainer = ((NSMutableArray*)[self itemContainer]);
            //if([arrContainer count] > [[self identifier] longLongValue]) {
                arrContainer[[[self identifier] longLongValue]] = value;
            //}
        }
        return;
    }*/
    //[self setItemValue:value];
    if([self isProperty]) {
        ////////////NSLog(@"is property");
        [[self context] setDictionaryValue:[self identifier] value:value context:context];
        ////////////NSLog(@"hasDictionaryValue: %@", [self identifier]);
    } else {
        ////////////NSLog(@"not property");
        if(([[self context] isKindOfClass:[PHPScriptObject class]] && ![[self context] isKindOfClass:[PHPScriptFunction class]]) && [[self context] parentContext] != NULL) {
            ////////////NSLog(@"set1");
            //[[self currentContext] setVariableValue:[self identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
            [[[self context] parentContext] setVariableValue:[self identifier] value:value  defineInContext:nil inputParameter:nil overrideThis:nil];
        } else {
            //[[self currentContext] setVariableValue:[self identifier] value:value defineInContext:nil inputParameter:nil overrideThis:nil];
            //return;
            ////////////NSLog(@"set2");
            //[self setVariableValue:name value:value defineInContext:defineInContext inputParameter:inputParameter overrideThis:overrideThis];
            PHPScriptFunction* func = (PHPScriptFunction*)[self context];
            //[[self context] setVariableValue:[self identifier] value:value defineInContext:@([self defineInContext]) inputParameter:nil overrideThis:nil];
            [func setVariableValue:[self identifier] value:value defineInContext:@([self defineInContext]) inputParameter:nil overrideThis:nil];
        }
    }
}

/*- (void) dealloc {
    //NSLog(@"deallocate var-ref : %@", self);
    [self setIdentifier:nil];
    [self setContext:nil];
    [self setIsProperty:nil];
    [self setDefineInContext:nil];
    [self setIgnoreSetContext:nil];
    [self setCurrentContext:nil];
    [self setItemValue:nil];
    [self setItemContainer:nil];
}*/
@end

/*
     public function set($value) {
         if($this->is_property) {
             $this->context->set_dictionary_value($this->identifier, $value);
         } else {
             if(($this->context instanceof script_object && !($this->context instanceof script_function)) && $this->context->get_parent_context() !== NULL) {
                 $this->context->get_parent_context()->set_variable_value($this->identifier, $value);
             } else {
                 $this->context->set_variable_value($this->identifier, $value, $this->define_in_context);
             }
         }
     }
    }*/
