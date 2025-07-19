//
//  PHPIncludedObjects.m
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import "PHPIncludedObjects.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import <WebKit/WebKit.h>
#import "PHPRegex.h"
#import "PHPStrings.h"
#import "WKMessages.h"
//#import "PHPIntervalItem.h"
#import "GeneralOperations.h"
//#import "PHPActionHandler.h"
#import "WSServer.h"

@implementation PHPIncludedObjects
- (void) init: (PHPScriptFunction*) contextInput {
    [self initArrays];
    [self setGlobalObject:true];
    
    PHPIncludedObjects* __weak /*__block*/ weakSelf = self;
    PHPScriptFunction* __weak /*__block*/ context = contextInput;
    
    PHPRegex* regex = [[PHPRegex alloc] init];
    [regex init:context];
    
    [self setDictionaryValue:@"regex" value:regex];
    [regex setInterpretation:[context interpretation]];
    
    PHPStrings* stringsObject = [[PHPStrings alloc] init];
    [stringsObject init:context];
    [stringsObject setInterpretation:[context interpretation]];
    
    [self setDictionaryValue:@"strings" value:stringsObject];
    
    PHPScriptFunction* get_layout = [[PHPScriptFunction alloc] init];
    [get_layout initArrays];
    [self setDictionaryValue:@"get_layout" value:get_layout];
    [get_layout setPrototype:self];
    [get_layout setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        return [[self getInterpretation] mainLayoutItem];
    } name:@"main"];
    
    PHPScriptFunction* reverse = [[PHPScriptFunction alloc] init];
    [reverse initArrays];
    [self setDictionaryValue:@"reverse" value:reverse];
    [reverse setPrototype:self];
    [reverse setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPScriptObject* input = [(PHPScriptObject*)values[0][0] copyScriptObject];
        /*NSObject* index = [[self interpretation] toJSON:values[0][1]];
        NSObject* value = values[0][2];
        [(NSMutableDictionary*)[scriptObject getDictionary] setValue:value forKey:index];
        return nil;*/
        NSObject* dictionary = [(PHPScriptObject*)input getDictionary];
        if([(PHPScriptObject*)input isArray]) {
            NSMutableArray* returnArray = [[NSMutableArray alloc] init];
            for(NSObject* value in [(NSMutableArray*)dictionary reverseObjectEnumerator]) {
                NSObject* intermediateResult = value;//[self toJSONSub:value];
                if(intermediateResult != nil) {
                    [returnArray addObject:intermediateResult];
                }
            }
            [input setDictionaryArray:returnArray];
            //return returnArray;
        } else if([dictionary isKindOfClass:[NSDictionary class]]) {
            //NSMutableDictionary* returnDictionary = [[NSMutableDictionary alloc] init];
            NSMutableArray* keys = [[NSMutableArray alloc] init];
            for(NSObject* key in [[input dictionaryKeys] reverseObjectEnumerator]) { //(NSMutableDictionary*)dictionary allKeys]
                /*NSString* stringKey = (NSString*)key;
                if([key isKindOfClass:[NSNumber class]]) {
                    stringKey = [(NSNumber*)key stringValue];
                }
                returnDictionary[stringKey] = ((NSMutableDictionary*)dictionary)[key];//[self toJSONSub:((NSMutableDictionary*)dictionary)[key]];*/
                [keys addObject:key];
            }
            [input setDictionaryKeys:keys];
            //[input setDictionary:returnDictionary];
            //return returnDictionary;
        }
        return input;
    } name:@"main"];
    
    PHPScriptFunction* partition = [[PHPScriptFunction alloc] init];
    [partition initArrays];
    [self setDictionaryValue:@"partition" value:partition];
    [partition setPrototype:self];
    [partition setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        GeneralOperations* general = [[GeneralOperations alloc] init];
        ToJSON* toJSON = [[ToJSON alloc] init];
        NSMutableArray* inputValue = [toJSON toJSON:(PHPScriptObject*)values[0][0]];
        NSLog(@"inputValue count : %@", @([inputValue count]));
        NSMutableArray* results = [general partition:inputValue partitionCount:(NSNumber *)values[0][1]];
        return [[self interpretation] makeIntoObjects:results];
    } name:@"main"];
    
    PHPScriptFunction* quit_application = [[PHPScriptFunction alloc] init];
    [quit_application initArrays];
    [self setDictionaryValue:@"quit_application" value:quit_application];
    [quit_application setPrototype:self];
    [quit_application setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        [[NSApplication sharedApplication] terminate:self];
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* create = [[PHPScriptFunction alloc] init];
    [create initArrays];
    [self setDictionaryValue:@"create" value:create];
    [create setPrototype:self];
    [create setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        return [[self interpretation] makeIntoObjects:[[NSMutableDictionary alloc] init]];
    } name:@"main"];
    
    PHPScriptFunction* array_shift = [[PHPScriptFunction alloc] init];
    [array_shift initArrays];
    [self setDictionaryValue:@"array_shift" value:array_shift];
    [array_shift setPrototype:self];
    [array_shift setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][0];
        scriptObject = [self parseInputVariable:scriptObject];
        return [scriptObject scriptArrayShift];
    } name:@"main"];
    
    PHPScriptFunction* array_pop = [[PHPScriptFunction alloc] init];
    [array_pop initArrays];
    [self setDictionaryValue:@"array_pop" value:array_pop];
    [array_pop setPrototype:self];
    [array_pop setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][0];
        return [scriptObject scriptArrayPop];
    } name:@"main"];
    
    //array_unshift
    PHPScriptFunction* array_unshift = [[PHPScriptFunction alloc] init];
    [array_unshift initArrays];
    [self setDictionaryValue:@"array_unshift" value:array_unshift];
    [array_unshift setPrototype:self];
    [array_unshift setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][0];
        NSObject* item = values[0][1];
        [scriptObject scriptArrayUnshift:item];
        return nil;
    } name:@"main"];
    
    
    PHPScriptFunction* merge = [[PHPScriptFunction alloc] init];
    [merge initArrays];
    [self setDictionaryValue:@"merge_arrays" value:merge];
    [merge setPrototype:self];
    [merge setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* rowsA = [self parseInputVariable:values[0][0]];
        NSObject* rowsB =  [self parseInputVariable:values[0][1]];
        ToJSON* toJSON = [[ToJSON alloc] init];
        rowsA = [toJSON toJSON:rowsA];
        rowsB = [toJSON toJSON:rowsB];
        NSMutableSet* set;
        if([rowsA isKindOfClass:[NSMutableArray class]]) {
            set = [NSMutableSet setWithArray:rowsA];
        } else {
            set = [NSMutableSet alloc];
            [set setValuesForKeysWithDictionary:rowsA];
        }
        NSMutableSet* otherSet;
        if([rowsB isKindOfClass:[NSMutableArray class]]) {
            otherSet = [NSMutableSet setWithArray:rowsB];
        } else {
            otherSet = [NSMutableSet alloc];
            [otherSet setValuesForKeysWithDictionary:rowsB];
        }
        
        [set unionSet:otherSet];
        return [[self getInterpretation] makeIntoObjects:[set allObjects]];
    } name:@"main"];
    
    /*NSMutableSet* set = [NSMutableSet setWithArray:rowsA];
     NSMutableSet* otherSet = [NSMutableSet setWithArray:rowsA];
     [set unionSet:otherSet];
     return [set allObjects];*/
    
    PHPScriptFunction* isArray = [[PHPScriptFunction alloc] init];
    [isArray initArrays];
    [self setDictionaryValue:@"item_is_array" value:isArray];
    [isArray setPrototype:self];
    [isArray setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        if([values[0] count] == 2) {
            if([values[0][0] isKindOfClass:[PHPScriptObject class]]) {
                return @true;
            }
            return @false;
        }
        if([values[0][0] isKindOfClass:[PHPScriptObject class]]) {
            PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][0];
            return @([scriptObject isArray]);
        }
        return @(false);
    } name:@"main"];
    
    PHPScriptFunction* item_is_object = [[PHPScriptFunction alloc] init];
    [item_is_object initArrays];
    [self setDictionaryValue:@"item_is_object" value:item_is_object];
    [item_is_object setPrototype:self];
    [item_is_object setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        if([values[0][0] isKindOfClass:[PHPScriptObject class]]) {
            return @(true);
        }
        return @(false);
    } name:@"main"]; 
    
    PHPScriptFunction* functionLength = [[PHPScriptFunction alloc] init];
    [functionLength initArrays];
    [self setDictionaryValue:@"func_length" value:functionLength];
    [functionLength setPrototype:self];
    [functionLength setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = [self parseInputVariable:values[0][0]];
        if([input isKindOfClass:[PHPScriptFunction class]]) {
            return @([[(PHPScriptFunction*)input inputParametersKeys] count]);
        }
        return @(0);
    } name:@"main"];
    
    /*PHPScriptFunction* functionLength = [[PHPScriptFunction alloc] init];
    [functionLength initArrays];
    [self setDictionaryValue:@"func_length" value:functionLength];
    [functionLength setPrototype:self];
    [functionLength setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        if([values[0][0] isKindOfClass:[PHPScriptFunction class]]) {
            return @([[(PHPScriptFunction*)values[0][0] inputParameters] count]);
        }
        return @(0);
    } name:@"main"];*/
    
    PHPScriptFunction* sort = [[PHPScriptFunction alloc] init];
    [sort initArrays];
    [self setDictionaryValue:@"sort" value:sort];
    [sort setPrototype:self];
    [sort setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][0];
        PHPScriptFunction* callback = (PHPScriptFunction*)values[0][1];
        [scriptObject sort:callback];
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* array_unique = [[PHPScriptFunction alloc] init];
    [array_unique initArrays];
    [self setDictionaryValue:@"array_unique" value:array_unique];
    [array_unique setPrototype:self];
    [array_unique setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][0];
        
        NSMutableArray* items = [[self getInterpretation] toJSON:[self parseInputVariable:scriptObject]];
        
        PHPScriptObject* skipFields;
        NSMutableArray* skipItems = [[NSMutableArray alloc] init];
        if([values[0] count] > 1) {
            skipFields = (PHPScriptObject*)values[0][1];
            skipItems = [[self getInterpretation] toJSON:skipFields];
            //NSLog(@"values  %@ - %@", values, skipItems);
        }
        
        [self sanitizeObjects:items];
        /*debug*/
        if([skipItems count] > 0) {
            NSMutableArray* skippedItems = [[NSMutableArray alloc] init];
            //items = [[NSMutableArray alloc] initWithArray:items];
            for(NSObject* item in items) {
                if([item isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary* item2 = [[NSMutableDictionary alloc] initWithDictionary:item];
                    for(NSString* skipField in skipItems) {
                        [item2 removeObjectForKey:skipField];
                    }
                    [skippedItems addObject:item2];
                    //NSLog(@"item2 : %@", item2);
                } else {
                    [skippedItems addObject:item];
                    //NSLog(@"item : %@", item);
                }
            }
            items = skippedItems;
        }
        
        
        
        NSArray *uniqueArray = [[NSSet setWithArray:items] allObjects];
        NSMutableArray* results = [[NSMutableArray alloc] init];
        for(NSObject* item in uniqueArray) {
            if([item isKindOfClass:[NSString class]]) {
                if([(NSString*)item length] == 0) {
                    
                } else {
                    [results addObject:item];
                }
            } else if([item isKindOfClass:[NSDictionary class]]) {
                if([(NSDictionary*)item count] == 0) {
                    
                } else {
                    [results addObject:item];
                }
            } else {
                [results addObject:item];
            }
            //NSLog(@"unique item is : %@", item);
        }
        
        return [[self getInterpretation] makeIntoObjects:results];
    } name:@"main"];
    
    //NSArray *uniqueArray = [[NSSet setWithArray:duplicateArray] allObjects];
    
    /*PHPScriptFunction* get_timer = [[PHPScriptFunction alloc] init];
    [get_timer initArrays];
    [self setDictionaryValue:@"get_timer" value:get_timer];
    [get_timer setPrototype:self];
    [get_timer setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
      
        PHPIntervalItem* item = [[PHPIntervalItem alloc] init];
        [item init:self_instance];
        //[item setin]
        return item;
    } name:@"main"];*/
    
    PHPScriptFunction* removeObject = [[PHPScriptFunction alloc] init];
    [removeObject initArrays];
    [self setDictionaryValue:@"remove_item" value:removeObject];
    [removeObject setPrototype:self];
    [removeObject setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        /*PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][0];
        NSObject* index = [[self interpretation] toJSON:values[0][1]];
        NSObject* value = values[0][2];
        if([values[0] count] > 3) {
            NSValue* valueItem = [NSValue valueWithNonretainedObject:scriptObject];//[NSValue valueWithPointer:&scriptObject];
            [(NSMutableDictionary*)[scriptObject getDictionary] setValue:value forKey:valueItem];
        } else {
            [(NSMutableDictionary*)[scriptObject getDictionary] setValue:value forKey:index];
        }
        return nil;*/
        NSObject* input = [self parseInputVariable:values[0][0]];
        NSObject* item = [self parseInputVariable:values[0][1]];
        PHPScriptObject* objectItem = (PHPScriptObject*)input;
        [objectItem removeItem:item];
        /*@synchronized (objectItem) {
            NSObject* dict = [objectItem getDictionary]
        }*/
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* setDictValue = [[PHPScriptFunction alloc] init];
    [setDictValue initArrays];
    [self setDictionaryValue:@"set_dict_value" value:setDictValue];
    [setDictValue setPrototype:self];
    [setDictValue setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][0];
        NSObject* index = [[self interpretation] toJSON:values[0][1]];
        NSObject* value = values[0][2];
        if([values[0] count] > 3) {
            NSValue* valueItem = [NSValue valueWithNonretainedObject:scriptObject];//[NSValue valueWithPointer:&scriptObject];
            [(NSMutableDictionary*)[scriptObject getDictionary] setValue:value forKey:valueItem];
        } else {
            [(NSMutableDictionary*)[scriptObject getDictionary] setValue:value forKey:index];
        }
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* getDictValue = [[PHPScriptFunction alloc] init];
    [getDictValue initArrays];
    [self setDictionaryValue:@"get_dict_value" value:getDictValue];
    [getDictValue setPrototype:self];
    [getDictValue setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][0];
        NSObject* index = [[self interpretation] toJSON:values[0][1]];
        //NSLog(@"get dict value : %@ - %@", ((NSMutableDictionary*)[scriptObject getDictionary])[index], (NSMutableDictionary*)[scriptObject getDictionary]);
        NSObject* result;
        if([values[0] count] > 2) {
            NSValue* valueItem = [NSValue valueWithNonretainedObject:scriptObject];
            result = ((NSMutableDictionary*)[scriptObject getDictionary])[valueItem];
        } else {
            result = ((NSMutableDictionary*)[scriptObject getDictionary])[index];
        }
        if(result != nil) {
            //NSLog(@"return result");
            return result;
        }
        //NSLog(@"return null");
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* getDictValueParent = [[PHPScriptFunction alloc] init];
    [getDictValueParent initArrays];
    [self setDictionaryValue:@"get_function_parent" value:getDictValueParent];
    [getDictValueParent setPrototype:self];
    [getDictValueParent setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][0];
        //scriptObject = [scriptObject prototype];
        /*if([scriptObject isKindOfClass:[PHPScriptFunction class]]) {
            scriptObject = [scriptObject prototype];
            NSLog(@"set prototype : %@ %@", scriptObject, [scriptObject prototype]);
        }*/
        NSObject* index = [[self interpretation] toJSON:values[0][1]];
        /*
        NSLog(@"get dict value : %@ - %@ - %@", scriptObject, ((NSMutableDictionary*)[scriptObject getDictionary])[index], (NSMutableDictionary*)[scriptObject getDictionary]);
        NSLog(@"get dict value : %@ - %@ - %@", [scriptObject prototype], ((NSMutableDictionary*)[[scriptObject prototype] getDictionary])[index], (NSMutableDictionary*)[[scriptObject prototype] getDictionary]);
        
        
        
        NSObject* result = ((NSMutableDictionary*)[[scriptObject prototype] getDictionary])[index];*/
        
        PHPScriptFunction* result = [scriptObject getDictionaryValue:index returnReference:@false createIfNotExists:@false context:nil];
        /*NSLog(@"result is : %@ - %@", result, [result debugText]);
        if(result != nil) {
            result = [result previousClassFunction];
        }*/
        NSLog(@"result is : %@ - %@", result, [result debugText]);
        if(result != nil) {
            //NSLog(@"return result");
            return result;
        }
        //NSLog(@"return null");
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* deleteDictValue = [[PHPScriptFunction alloc] init];
    [deleteDictValue initArrays];
    [self setDictionaryValue:@"delete_dict_value" value:deleteDictValue];
    [deleteDictValue setPrototype:self];
    [deleteDictValue setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][0];
        NSObject* index = [[self interpretation] toJSON:values[0][1]];
        //NSLog(@"get dict value : %@ - %@", ((NSMutableDictionary*)[scriptObject getDictionary])[index], (NSMutableDictionary*)[scriptObject getDictionary]);
        [((NSMutableDictionary*)[scriptObject getDictionary]) removeObjectForKey:index];
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* set_call_count = [[PHPScriptFunction alloc] init];
    [set_call_count initArrays];
    [self setDictionaryValue:@"set_call_count" value:set_call_count];
    [set_call_count setPrototype:self];
    [set_call_count setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        
        PHPScriptFunction* main = (PHPScriptFunction*)input;
        [main setCallCount:[self_instance parseInputVariable:values[0][1]]];
        /*[values[0] removeObjectAtIndex:0];
        @synchronized (main) {
            if(![main hasRunOnce]) {
                [main setHasRunOnce:true];
                [main callScriptFunctionSub:values parameterValues:nil awaited:nil returnObject:nil interpretation:nil];
            }
        }
        return nil;*/
        //makeIntoObjects
        //NSString* string = [[self interpretation] toJSONString:input];
        //return string;
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* dispose_parent = [[PHPScriptFunction alloc] init];
    [dispose_parent initArrays];
    [self setDictionaryValue:@"dispose_parent" value:dispose_parent];
    [dispose_parent setPrototype:self];
    [dispose_parent setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        
        PHPScriptFunction* main = (PHPScriptFunction*)input;
        if([main parentContext] != nil) {
            [main setCompletedExecution:true];
            [[main parentContext] canUnset];
            [main unset:nil];
        }
        //[main setCallCount:[self_instance parseInputVariable:values[0][1]]];
        /*[values[0] removeObjectAtIndex:0];
        @synchronized (main) {
            if(![main hasRunOnce]) {
                [main setHasRunOnce:true];
                [main callScriptFunctionSub:values parameterValues:nil awaited:nil returnObject:nil interpretation:nil];
            }
        }
        return nil;*/
        //makeIntoObjects
        //NSString* string = [[self interpretation] toJSONString:input];
        //return string;
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* once = [[PHPScriptFunction alloc] init];
    [once initArrays];
    [self setDictionaryValue:@"once" value:once];
    [once setPrototype:self];
    [once setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        
        PHPScriptFunction* main = (PHPScriptFunction*)input;
        [values[0] removeObjectAtIndex:0];
        @synchronized (main) {
            if(![main hasRunOnce]) {
                [main setHasRunOnce:true];
                [main callScriptFunctionSub:values parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:nil];
            }
        }
        return nil;
        //makeIntoObjects
        //NSString* string = [[self interpretation] toJSONString:input];
        //return string;
    } name:@"main"];
    
    PHPScriptFunction* dispatch = [[PHPScriptFunction alloc] init];
    [dispatch initArrays];
    [self setDictionaryValue:@"dispatch" value:dispatch];
    [dispatch setPrototype:self];
    [dispatch setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        /*NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        
        ToJSON* toJSON = [[ToJSON alloc] init];
        NSArray* valuesInput = [toJSON toJSON:values[0][1]];
        
        
        
        PHPScriptFunction* main = (PHPScriptFunction*)input;
        //main = [main copyScriptFunction];
        dispatch_async([[self getInterpretation] messagesQueue], ^{
            [main callCallback:valuesInput];
        });
        return @"NULL";*/
        @autoreleasepool {
            NSObject* input = values[0][0];
            input = [self_instance parseInputVariable:input];
            
            ToJSON* toJSON = [[ToJSON alloc] init];
            NSArray* valuesInput = [toJSON toJSON:[self_instance parseInputVariable:values[0][1]]];
            
            
            
            PHPScriptFunction* main = (PHPScriptFunction*)input;
            //main = [main copyScriptFunction];
            dispatch_async([[self_instance getInterpretation] messagesQueue], ^{
                @autoreleasepool {
                    
                    NSLog(@"dispatch  : %@ - %@", main, valuesInput);
                    [main callCallback:valuesInput];
                    /*main = nil;
                    valuesInput = nil;*/
                }
                /*[main unset:nil];
                 [main unsetScriptFunction];*/
            });
        }
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* trycatch = [[PHPScriptFunction alloc] init];
    [trycatch initArrays];
    //////////////////////////////NSLog/@"set log");
    [self setDictionaryValue:@"trycatch" value:trycatch];
    [trycatch setPrototype:self];
    [trycatch setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
       // ////////////////////////////NSLog/@"set log");
        /*$input = $values[0][0];
         while(is_array($input)) {
         $input = $input[0];
         }
         if($input instanceof return_result) {
         $input = $input->result;
         }
         if($input instanceof script_variable) {
         $input = $input->get();
         }
         debug::debug($input);*/
        ////////////////////////////NSLog/@"log values: %@", values);
        NSObject* input = values[0][0];
        //input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        if([input isKindOfClass:[PHPReturnResult class]]) {
            input = [(PHPReturnResult*)input result];
        }
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }
        if([input isKindOfClass:[PHPScriptFunction class]]) {
            PHPScriptFunction* function = (PHPScriptFunction*)input;
            @try {
                NSMutableArray* arr = [[NSMutableArray alloc] init];
                [function callScriptFunctionSub:arr parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:nil];
            } @catch (NSException *exception) {
                //////////////////////NSLog/@"exception");
            }/* @finally {
                
            }*/
        }
        return nil;
    } name:@"main"];
    
    
    PHPScriptFunction* var_dump = [[PHPScriptFunction alloc] init];
    [var_dump initArrays];
    //////////////////////////////NSLog/@"set log");
    [self setDictionaryValue:@"log" value:var_dump];
    [var_dump setPrototype:self];
    [var_dump setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
       // ////////////////////////////NSLog/@"set log");
        /*$input = $values[0][0];
         while(is_array($input)) {
         $input = $input[0];
         }
         if($input instanceof return_result) {
         $input = $input->result;
         }
         if($input instanceof script_variable) {
         $input = $input->get();
         }
         debug::debug($input);*/
        ////////////////////////////NSLog/@"log values: %@", values);
        NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        if([input isKindOfClass:[PHPReturnResult class]]) {
            input = [(PHPReturnResult*)input result];
        }
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }
        //input = [[self interpretation] toJSON:input];
        ////////////////////NSLog/@"output: %@", [input class]);
        ///
        //dispatch_async(dispatch_get_main_queue(), ^(void){
            NSLog(@"output: %@", input);
            //printf("%s\n", [[NSString stringWithFormat:@"%@", input] UTF8String]);
        //});
        return nil;
    } name:@"main"];
    
    
    
    PHPScriptFunction* preg_match = [[PHPScriptFunction alloc] init];
    [preg_match initArrays];
    //////////////////////////////NSLog/@"set log");
    [self setDictionaryValue:@"preg_match" value:preg_match];
    [preg_match setPrototype:self];
    [preg_match setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        if([input isKindOfClass:[PHPReturnResult class]]) {
            input = [(PHPReturnResult*)input result];
        }
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }
        NSObject* input2 = values[0][1];
        input2 = [self_instance resolveValueReferenceVariableArray:input2];
        while([input2 isKindOfClass:[NSMutableArray class]]) {
            input2 = ((NSMutableArray*)input2)[0];
        }
        if([input2 isKindOfClass:[PHPReturnResult class]]) {
            input2 = [(PHPReturnResult*)input2 result];
        }
        if([input2 isKindOfClass:[PHPScriptVariable class]]) {
            input2 = [(PHPScriptVariable*)input2 get];
        }
        NSRange range = [(NSString*)input2 rangeOfString:(NSString*)input options:NSRegularExpressionSearch];
        bool matches = range.location != NSNotFound;
        return @(matches);
    } name:@"main"];

    
    /*
     resultValues = [resultValues stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
     NSData *nsdata = [resultValues dataUsingEncoding:NSUTF8StringEncoding];
     
     // Get NSString from NSData object in Base64
     NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];*/
    
    PHPScriptFunction* setProperty = [[PHPScriptFunction alloc] init];
    [setProperty initArrays];
    [self setDictionaryValue:@"set_app_property" value:setProperty];
    [setProperty setPrototype:self];
    [setProperty setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* key = values[0][0];
        key = [self parseInputVariable:key];
        key = [[self interpretation] toJSON:key];
        NSObject* input = values[0][1];
        input = [self parseInputVariable:input];
        input = [[self interpretation] toJSON:input];
        if([[self interpretation] properties] == nil) {
            [[self interpretation] setProperties:[[NSMutableDictionary alloc] init]];
        }
        [[self interpretation] properties][key] = input;
        return nil;
    } name:@"main"];
    
    NSCharacterSet* notallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ./-_0123456789[]()"] invertedSet];
    
    PHPScriptFunction* to_base64 = [[PHPScriptFunction alloc] init];
    [to_base64 initArrays];
    [self setDictionaryValue:@"to_base" value:to_base64];
    [to_base64 setPrototype:self];
    [to_base64 setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self parseInputVariable:input];
        NSString* stringInput = [self makeIntoString:input];
        //stringInput = [stringInput stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //stringInput = [[stringInput componentsSeparatedByCharactersInSet:notallowedCharacters] componentsJoinedByString:@""];
        //stringInput = [stringInput stringbyins]
        NSData *nsdata = [stringInput dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
        NSLog(@"encoded : %@", base64Encoded);
        return base64Encoded;//[[self interpretation] makeIntoObjects:base64Encoded];
    } name:@"main"];
    
    PHPScriptFunction* from_base64 = [[PHPScriptFunction alloc] init];
    [from_base64 initArrays];
    [self setDictionaryValue:@"from_base" value:from_base64];
    [from_base64 setPrototype:self];
    [from_base64 setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        bool flag = false;
        if([values[0] count] > 1) {
            NSObject* inputFlag = values[0][1];
            flag = [(NSNumber*)inputFlag boolValue];
        }
        input = [self parseInputVariable:input];
        NSString* stringInput = [self makeIntoString:input];
        NSLog(@"converted stringInput : %@", stringInput);
        NSData* data = [[NSData alloc] initWithBase64EncodedString:stringInput options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString* convertedString;
        if(!flag) {
            convertedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        } else {
            NSLog(@"ascii");
            convertedString = [[NSString alloc] initWithData:data encoding:NSUnicodeStringEncoding];
        }
        //convertedString = [convertedString stringByRemovingPercentEncoding];
        NSLog(@"converted string : %@", convertedString);
        return convertedString;
        //return [[self interpretation] makeIntoObjects:convertedString];
    } name:@"main"];
    
    PHPScriptFunction* toString = [[PHPScriptFunction alloc] init];
    [toString initArrays];
    [self setDictionaryValue:@"to_string" value:toString];
    [toString setPrototype:self];
    [toString setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self parseInputVariable:input];
        input = [self makeIntoString:input];
        return [[self interpretation] makeIntoObjects:input];
    } name:@"main"];
    
    PHPScriptFunction* toNumber = [[PHPScriptFunction alloc] init];
    [toNumber initArrays];
    [self setDictionaryValue:@"to_number" value:toNumber];
    [toNumber setPrototype:self];
    [toNumber setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        if([input isKindOfClass:[PHPReturnResult class]]) {
            input = [(PHPReturnResult*)input result];
        }
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }
        /*if([input isKindOfClass:[NSString class]]) {
            NSString* stringValue = input;
            if([input isKindOfClass:[NSNumber class]]) {
                NSNumber* numberValue = (NSNumber*)input;
                stringValue = [numberValue stringValue];
            }
            return stringValue;
        }
        return @"0";*/
        return [self makeIntoNumber:input];
        //makeIntoObjects
        //NSString* string = [[self interpretation] toJSONString:input];
        //return string;
    } name:@"main"];
    
    PHPScriptFunction* toJSON = [[PHPScriptFunction alloc] init];
    [toJSON initArrays];
    [self setDictionaryValue:@"toJSON" value:toJSON];
    [toJSON setPrototype:self];
    [toJSON setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSString* string;
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            /*input = [self_instance resolveValueReferenceVariableArray:input];
            while([input isKindOfClass:[NSMutableArray class]]) {
                input = ((NSMutableArray*)input)[0];
            }
            if([input isKindOfClass:[PHPReturnResult class]]) {
                input = [(PHPReturnResult*)input result];
            }
            if([input isKindOfClass:[PHPScriptVariable class]]) {
                input = [(PHPScriptVariable*)input get];
            }*/
            [self_instance parseInputVariable:input];
            
            ToJSON* toJSONInstance = [[ToJSON alloc] init];
            string = [toJSONInstance toJSONString:input];//@"[]";//[[weakSelf interpretation] toJSONString:input];
            if([string isEqualToString:@"[]"]) {
                string = @"[ ]";
            }
            if([string isEqualToString:@"{}"]) {
                string = @"{ }";
            }
            toJSONInstance = nil;
        }
        return string;
    } name:@"main"];
    
    /*PHPScriptFunction* toJSONtest = [[PHPScriptFunction alloc] init];
    [toJSONtest initArrays];
    [self setDictionaryValue:@"toJSONtest" value:toJSONtest];
    [toJSONtest setPrototype:self];
    [toJSONtest setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        if([input isKindOfClass:[PHPReturnResult class]]) {
            input = [(PHPReturnResult*)input result];
        }
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }
        ToJSON* toJSONInstance = [[ToJSON alloc] init];
        //NSObject* tojsonSub = [toJSONInstance toJSON:input];
        NSString* string = [toJSONInstance toJSONString:input];//@"[]";//[[weakSelf interpretation] toJSONString:input];
        if([string isEqualToString:@"[]"]) {
            string = @"[ ]";
        }
        if([string isEqualToString:@"{}"]) {
            string = @"{ }";
        }
        return string;
    } name:@"main"];*/
    
    PHPScriptFunction* equals = [[PHPScriptFunction alloc] init];
    [equals initArrays];
    [self setDictionaryValue:@"equals" value:equals];
    [equals setPrototype:self];
    [equals setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        NSObject* input2 = values[0][1];
        input2 = [self_instance parseInputVariable:input2];
        return @([input isEqualTo:input2]);
    } name:@"main"];
    
    /*PHPScriptFunction* get_action_handler = [[PHPScriptFunction alloc] init];
    [get_action_handler initArrays];
    [self setDictionaryValue:@"get_action_handler" value:get_action_handler];
    [get_action_handler setPrototype:self];
    [get_action_handler setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPActionHandler* actionHandler = [[PHPActionHandler alloc] init];
        return actionHandler;
    } name:@"main"];*/
    
    
    PHPScriptFunction* fromJSON = [[PHPScriptFunction alloc] init];
    [fromJSON initArrays];
    [self setDictionaryValue:@"fromJSON" value:fromJSON];
    [fromJSON setPrototype:self];
    [fromJSON setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* resultsPost = [[NSMutableArray alloc] init];
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            input = [self_instance resolveValueReferenceVariableArray:input];
            while([input isKindOfClass:[NSMutableArray class]]) {
                input = ((NSMutableArray*)input)[0];
            }
            if([input isKindOfClass:[PHPReturnResult class]]) {
                input = [(PHPReturnResult*)input result];
            }
            if([input isKindOfClass:[PHPScriptVariable class]]) {
                input = [(PHPScriptVariable*)input get];
            }
            if([input isKindOfClass:[NSString class]]) {
                /*NSString* stringValue = (NSString*)input;
                 NSError* error;
                 NSData* dataPost = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
                 NSObject* resultsPost = [NSJSONSerialization
                 JSONObjectWithData:dataPost
                 options:0
                 error:&error];
                 
                 return [[self interpretation] makeIntoObjects:resultsPost];*/
                @autoreleasepool {
                    
                    NSString* stringValue = (NSString*)input;
                    NSError* error;
                    NSData* dataPost = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
                    resultsPost = [NSJSONSerialization
                                   JSONObjectWithData:dataPost
                                   options:0
                                   error:&error];
                    if([values[0] count] == 2) {
                        NSLog(@"return NULL from fromJSON");
                        return @"NULL";
                    }
                }
                
            }
        }
        return [[weakSelf interpretation] makeIntoObjects:resultsPost];
        //return [[self interpretation] makeIntoObjects:@[]];
    } name:@"main"];
    
    PHPScriptFunction* objectValues = [[PHPScriptFunction alloc] init];
    [objectValues initArrays];
    [self setDictionaryValue:@"values" value:objectValues];
    [objectValues setPrototype:self];
    [objectValues setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        if([input isKindOfClass:[PHPReturnResult class]]) {
            input = [(PHPReturnResult*)input result];
        }
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }
        if([input isKindOfClass:[PHPScriptObject class]]) {
            PHPScriptObject* inputObject = (PHPScriptObject*)input;
            if([inputObject isArray]) {
                return inputObject;
            }
            PHPScriptObject* result = [[PHPScriptObject alloc] init];
            [result initArrays];
            [result setIsArray:true];
            [result setDictionaryArray:[inputObject getDictionaryValues]];
            return result;
            //for(NSString* key in )
        }
        return input;
    } name:@"main"];
    
    PHPScriptFunction* objectKeys = [[PHPScriptFunction alloc] init];
    [objectKeys initArrays];
    [self setDictionaryValue:@"keys" value:objectKeys];
    [objectKeys setPrototype:self];
    [objectKeys setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        /*input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        if([input isKindOfClass:[PHPReturnResult class]]) {
            input = [(PHPReturnResult*)input result];
        }
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }*/
        input = [self_instance parseInputVariable:input];
        if([input isKindOfClass:[PHPScriptObject class]]) {
            PHPScriptObject* inputObject = (PHPScriptObject*)input;
            if([inputObject isArray]) {
                return inputObject;
            }
            /*PHPScriptObject* result = [[PHPScriptObject alloc] init];
            [result initArrays];
            [result setIsArray:true];
            [result setDictionaryArray:[inputObject getDictionaryValues]];
            return result;*/
            return [[self interpretation] makeIntoObjects:[inputObject getKeys]];
            //for(NSString* key in )
        }
        return input;
    } name:@"main"];
    
    
    PHPScriptFunction* isset = [[PHPScriptFunction alloc] init];
    [isset initArrays];
    [self setDictionaryValue:@"isset" value:isset];
    [isset setPrototype:self];
    [isset setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        NSObject* reference;
        if([input isKindOfClass:[PHPVariableReference class]]) {
            reference = input;
        }
        input = [self_instance resolveValueArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        if([input isKindOfClass:[PHPReturnResult class]]) {
            input = [(PHPReturnResult*)input result];
        }
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }
        if([input isKindOfClass:[PHPVariableReference class]]) {
            reference = input;
        }
        input = [self_instance resolveValueReferenceVariableArray:input];
        //////////////NSLog/@"variable isset result: %@", input);
        if([input isKindOfClass:[PHPUndefined class]] || input == nil || input == NULL) { //([input isKindOfClass:[NSString class]] && [(NSString*)input isEqualToString:@"undefined"] && 
            //////////////////////////////NSLog/@"delete reference: %@", reference);
            //[self_instance deletePropertyReference:reference];
            return @false;
        }
        return @true;
    } name:@"main"];
    
    PHPScriptFunction* instanceOf = [[PHPScriptFunction alloc] init];
    [instanceOf initArrays];
    [self setDictionaryValue:@"instance_of" value:instanceOf];
    [instanceOf setPrototype:self];
    [instanceOf setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* item = values[0][0];
        item = [self parseInputVariable:item];
        NSObject* className = values[0][1];
        className = [self parseInputVariable:className];
        if([(PHPScriptObject*)item instanceOf:(NSString*)className]) {
            return @true;
        }
        return @false;
        /*if([item isKindOfClass:[PHPScriptVariable class]]) {
            //return [item]
        }*/
        return [self getTypeOf:item];
    } name:@"main"];
    
    PHPScriptFunction* typeof_ = [[PHPScriptFunction alloc] init];
    [typeof_ initArrays];
    [self setDictionaryValue:@"typeof" value:typeof_];
    [typeof_ setPrototype:self];
    [typeof_ setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* item = values[0][0];
        //input = [self parseInputVariable:input];
        //NSString* stringValue = [self makeIntoString:input];
        
        
        if([item isKindOfClass:[PHPReturnResult class]]) {
            item = [(PHPReturnResult*)item get];
        }
        if([item isKindOfClass:[PHPVariableReference class]]) {
            item = [(PHPVariableReference*)item get:nil];
        }
        if([item isKindOfClass:[NSArray class]]) {
            item = [self resolveValueArray:(NSMutableArray*)item];
        }
        /*if([item isKindOfClass:[PHPScriptVariable class]]) {
            //return [item]
        }*/
        return [[NSString alloc] initWithString:[self getTypeOf:item]];
    } name:@"main"];
    
    PHPScriptFunction* splice_sync = [[PHPScriptFunction alloc] init];
    [splice_sync initArrays];
    //[splice_sync setIsAsync:true];
    [self setDictionaryValue:@"splice" value:splice_sync];
    [splice_sync setPrototype:self];
    [splice_sync setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        
        //@synchronized (self_instance) {
            NSObject* input = values[0][0];
            NSMutableArray* arr = (NSMutableArray*)[(PHPScriptObject*)input dictionaryArray];
            NSNumber* index = (NSNumber*)values[0][1];
            NSNumber* count = (NSNumber*)values[0][2];
            
            NSRange range = NSMakeRange([index longLongValue], [count longLongValue]);
            
            NSMutableArray* result = [[NSMutableArray alloc] initWithArray:[arr subarrayWithRange:range]];
            [arr removeObjectsInRange:range];
            return [[self interpretation] makeIntoObjects:result];
        //}
        return nil;
    } name:@"main"];
    
    /*PHPScriptFunction* sort = [[PHPScriptFunction alloc] init];
    [sort initArrays];
    //[splice_sync setIsAsync:true];
    [self setDictionaryValue:@"sort" value:sort];
    [sort setPrototype:self];
    [sort setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        PHPScriptObject* sortObject = (PHPScriptObject*)values[0][0];
        if(![sortObject isArray]) {
            
        }
        [sortObject sort:values[0][1]];
        return nil;
    } name:@"main"];*/
    
    PHPScriptFunction* splice = [[PHPScriptFunction alloc] init];
    [splice initArrays];
    [self setDictionaryValue:@"splice_depr" value:splice];
    [splice setPrototype:self];
    [splice setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        NSMutableArray* arr = (NSMutableArray*)[(PHPScriptObject*)input dictionaryArray];
        NSNumber* index = (NSNumber*)values[0][1];
        NSNumber* count = (NSNumber*)values[0][2];
        
        NSRange range = NSMakeRange([index longLongValue], [count longLongValue]);
        
        NSMutableArray* result = [[NSMutableArray alloc] initWithArray:[arr subarrayWithRange:range]];
        [arr removeObjectsInRange:range];
        return [[self interpretation] makeIntoObjects:result];
    } name:@"main"];
    
    
    
    PHPScriptFunction* concat = [[PHPScriptFunction alloc] init];
    [concat initArrays];
    [self setDictionaryValue:@"concat" value:concat];
    [concat setPrototype:self];
    [concat setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        //@synchronized (self_instance) {
        //NSLog(@"concat : %@", values);
        NSObject* input = values[0][0];
        
        NSMutableArray* arr = (NSMutableArray*)[(PHPScriptObject*)[self parseInputVariable:input] dictionaryArray];
        NSMutableArray* arr2 = (NSMutableArray*)[(PHPScriptObject*)[self parseInputVariable:values[0][1]] dictionaryArray];
        
       /* NSRange range = NSMakeRange([index longLongValue], [count longLongValue]);
        
        NSMutableArray* result = [[NSMutableArray alloc] initWithArray:[arr subarrayWithRange:range]];
        [arr removeObjectsInRange:range];
        return [[self interpretation] makeIntoObjects:result];*/
        return [[self interpretation] makeIntoObjects:[[NSMutableArray alloc] initWithArray:[arr arrayByAddingObjectsFromArray:arr2]]];
            
        //}
        //return nil;
    } name:@"main"];
    
    PHPScriptFunction* device_id = [[PHPScriptFunction alloc] init];
    [device_id initArrays];
    [self setDictionaryValue:@"device_id" value:device_id];
    [device_id setPrototype:self];
    [device_id setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        //[[NSDevice currentDevice] uniqueIdentifier]
        return nil;
    } name:@"main"];
  
    
    PHPScriptFunction* send_result = [[PHPScriptFunction alloc] init];
    [send_result initArrays];
    [self setDictionaryValue:@"send_result" value:send_result];
    [send_result setPrototype:self];
    [send_result setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        //NSLog(@"sendResult values : %@", values[0][0]);
        /*
         Verdur fyrir einhverja asteadu array med streng, veit ekki hversvegna, problem
         */
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        NSString* result = input;//[self makeIntoString:input];
        //NSLog(@"result value : %@", result);
        result = [result stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //////////////NSLog(@"%@", result);
        NSData *nsdata = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString* default_func = @"app.receive_messages('%@');";
        
        //if([values[0] count] > 1) {
        //    default_func = [[self makeIntoString:[self parseInputVariable:values[0][1]]] stringByAppendingString:@"('%@');"];
        //}

        // Get NSString from NSData object in Base64
        //NSString* base64Encoded = [result stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
        NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
        //////////////NSLog(@"base64: %@", base64Encoded);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[[self interpretation] webView] evaluateJavaScript:[NSString stringWithFormat:default_func, base64Encoded] completionHandler:NULL];
            //Run UI Updates
        });
        return nil;
    } name:@"main"];
    
    /*PHPScriptFunction* send = [[PHPScriptFunction alloc] init];
    [send initArrays];
    [self setDictionaryValue:@"send" value:send];
    [send setPrototype:self];
    [send setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self parseInputVariable:input];
        ////////////////NSLog/@"input: %@", input);
        ////////////////////////NSLog/@"trim: %@", input);
        //NSString *trimmedString = [(NSString*)input stringByTrimmingCharactersInSet:
        //[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* stringValue = @([(NSString*)[self makeIntoString:input] UTF8String]);
        ////////////////NSLog/@"stringValue: %@", stringValue);
        ////////////////NSLog/@"stringValue: %@", [stringValue class]);
                
        
        if([values[0] count] > 1) {
            NSObject* inputArr = values[0][1];
            inputArr = [self_instance resolveValueArray:inputArr];
            while([inputArr isKindOfClass:[NSMutableArray class]]) {
                inputArr = ((NSMutableArray*)inputArr)[0];
            }
            inputArr = [self_instance resolveValueReferenceVariableArray:inputArr];
            if([inputArr isKindOfClass:[PHPScriptVariable class]]) {
                inputArr = [(PHPScriptVariable*)inputArr get];
            }
            NSMutableArray* arrValue = (NSMutableArray*)[[self interpretation] toJSON:inputArr];
            for(NSString* valueItem in arrValue) {
                NSString* parameter = @"'";
                parameter = [parameter stringByAppendingString:@([[self makeIntoString:valueItem] UTF8String])];
                parameter = [parameter stringByAppendingString:@"'"];
                ////////////////NSLog/@"stringValue: %@", parameter);
                ////////////////NSLog/@"stringValue: %@", [parameter class]);
                NSString* eval_string = [[NSString alloc] initWithFormat:@"%@(%@);", stringValue, parameter];
                ////////////////NSLog/@"eval_string: %@", eval_string);
                ///
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [[[self interpretation] webView] evaluateJavaScript:eval_string completionHandler:^(id _Nullable main_par, NSError * _Nullable error) {
                        ////////////////NSLog/@"eval error");
                    }];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
        
                [[[self interpretation] webView] evaluateJavaScript:stringValue completionHandler:^(id _Nullable main_par, NSError * _Nullable error) {
                    ////////////////NSLog/@"eval error");
                }]; //Run UI Updates
            });
        }
        return nil;
        ////////////////////////NSLog/@"trimmedString: %@", trimmedString);
        //return [[self interpretation] makeIntoObjects:trimmedString];
    } name:@"main"];*/
 
    [self setGlobalCallbacks:[[NSMutableDictionary alloc] init]];
  
    PHPScriptFunction* assign_global_callback = [[PHPScriptFunction alloc] init];
    [assign_global_callback initArrays];
    [self setDictionaryValue:@"assign_global_callback" value:assign_global_callback];
    [assign_global_callback setPrototype:self];
    [assign_global_callback setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        //[[NSDevice currentDevice] uniqueIdentifier]
        //return nil;
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        
        NSObject* inputCallback = values[0][1];
        inputCallback = [self_instance parseInputVariable:inputCallback];
        
        [self globalCallbacks][(NSString*)input] = inputCallback;
        return @"NULL";
    } name:@"main"];
    
    PHPScriptFunction* send = [[PHPScriptFunction alloc] init];
    [send initArrays];
    [self setDictionaryValue:@"send_depr" value:send];
    [send setPrototype:self];
    [send setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSLog(@"send %@", values);
        //@synchronized (self_instance) {
            
        /*NSObject* input = values[0][0];
        
        NSMutableArray* arr = (NSMutableArray*)[(PHPScriptObject*)input dictionaryArray];
        NSMutableArray* arr2 =(NSMutableArray*)[(PHPScriptObject*)values[0][1] dictionaryArray];
        return [[self interpretation] makeIntoObjects:[[NSMutableArray alloc] initWithArray:[arr arrayByAddingObjectsFromArray:arr2]]];*/
        NSString* evalString = (NSString*)values[0][0];
        NSDictionary* dictValues = (NSDictionary*)[[self interpretation] toJSON:values[0][1]];
        PHPScriptObject* callback = nil;
        if([values[0] count] > 2) {
            callback = values[0][2];
        }
        //NSLog(@"send : %@ %@", evalString, dictValues);
        [[[self interpretation] wkmessages] sendMessage:evalString dictValues:dictValues callback:callback];
            
        //}
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* initializeServer = [[PHPScriptFunction alloc] init];
    [initializeServer initArrays];
    [self setDictionaryValue:@"set_ws_server" value:initializeServer];
    [initializeServer setPrototype:self];
    [initializeServer setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSObject* input = [self parseInputVariable:values[0][0]];
        NSObject* item = [self parseInputVariable:values[0][1]];
        NSObject* callback = [self parseInputVariable:values[0][2]];
        
        NSString* ip = [self makeIntoString:input];
        NSNumber* port = [self makeIntoNumber:item];
        
        if([self serverWebsockets] != nil) {
            [[self serverWebsockets] close];
        }
        [self setServerWebsockets:[[WSServer alloc] init]];
        [[self serverWebsockets] setInterpretation:[self getInterpretation]];
        [[self serverWebsockets] initServer:ip port:port callback:callback];
        
        return @true;
    } name:@"main"];
    
    PHPScriptFunction* request = [[PHPScriptFunction alloc] init];
    [request initArrays];
    [self setDictionaryValue:@"request" value:request];
    [request setPrototype:self];
    [request setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSString* url = [self_instance makeIntoString:values[0][0]];
        PHPScriptFunction* callback = (PHPScriptFunction*)values[0][1];
        //NSObject* result = [self getDataFrom:url callback:callback];
        /*if(result != nil) {
            return result;
        }*/
        
        /*NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:url]];*/

        /*[NSURLConnection sendAsynchronousRequest:request queue:[self queue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [callback callCallback:@[response]];
        }];*/
        NSLog(@"make request : %@", url);
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* sessitem = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"response : %@", responseString);
            [callback callCallback:@[responseString]];
        }];
        [sessitem resume];
        
        //[NSURLSession datat]
        //NSURLSession dataTaskWithRequest:completionHandler:]
        return @"NULL";
    } name:@"main"];
}

- (void) sanitizeObjects: (NSMutableArray*) input {
    for(NSObject* dictItem in input) {
        if([dictItem isKindOfClass:[NSMutableDictionary class]]) {
            NSMutableDictionary* dict = (NSMutableDictionary*)dictItem;
            //NSLog(@"dict is : %@", dict);
            NSMutableArray* toChange = [[NSMutableArray alloc] init];
            for(NSObject* key in dict) {
                //NSLog(@"key is : %@", key);
                NSObject* value = dict[key];
                //NSLog(@"value is : %@", value);
                if([value isKindOfClass:[NSNull class]]) {
                    //dict[key] = @"";
                    [toChange addObject:key];
                    //NSLog(@"add key : %@", key);
                }
            }
            for(NSObject* key in toChange) {
                dict[key] = @"";
            }
        }
    }
}

/*- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];

    [NSURLConnection sendAsynchronousRequest:request queue:[self queue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
    }];
    return nil;
}*/
@end
