#import "PHPInterpretation.h"
#import "PHPControl.h"
#import "PHPMulticonditionalControl.h"
#import "PHPLoopControl.h"
#import "PHPForLoopControl.h"
#import "PHPScriptEvaluationReference.h"
#import "PHPVariableReference.h"
#import "PHPReturnResult.h"
#import "PHPIncludedObjects.h"
#import "PHPScriptVariable.h"
#import "PHPData.h"
#import "PHPDates.h"
#import "PHPStrings.h"
#import "PHPMedia.h"
#import "PHPDataWrap.h"
#import "PHPFiles.h"
#import "DBConnection.h"
//#import <WebKit/WebKit.h>
#import "JSParse.h"
//#import "PHPCallbackReference.h"
//#import "WKMessages.h"
#import "PHPMetadataItem.h"

@implementation PHPInterpretation
- (PHPInterpretation*) copyIntepretation {
    ////////////NSLog(@"copy interpretation");
    PHPInterpretation* copyValue = [[PHPInterpretation alloc] init];
    [copyValue initCopyContext]; //initGlobalContext
    
    //[copyValue setJsParse:[self jsParse]];
    [copyValue setIsCopy:true];
    //[copyValue setWebView:[self webView]];
    
    //[copyValue setMessagesQueue:[self messagesQueue]];
    
    /*NSString* name = [@"interpretationQueue" stringByAppendingString:[copyValue description]];
    
    dispatch_queue_attr_t qos = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, -1);
    dispatch_queue_t recordingQueue = dispatch_queue_create([name UTF8String], qos);
    [copyValue setMessagesQueue:recordingQueue];*/
    //*/
    /*[copyValue setParsedTree:[self parsedTree]];
    [copyValue setDefinition:[self definition]];
    [copyValue setSource:[self source]];
    [copyValue setDebugCounter:0];*/
    
    
    //[copyValue setMainInterpretation:mainInterpretation];
    
    //[[copyValue jsParse] run:copyValue];
    ////////////NSLog(@"completed run");
    //[copyValue setGlobalContext:[[PHPScriptFunction alloc] init]];//[[self globalContext] copyScriptFunction]];
    //[copyValue setGlobalContext:[[self globalContext] copyScriptFunction]];
    
    //[[copyValue globalContext] setVariables:[[NSMutableDictionary alloc] init]];
    //[copyValue setCurrentContext:[copyValue globalContext]];
    /*[[copyValue currentContext] setClasses:[[self globalContext] classes]];
    [[copyValue currentContext] setDictionary:[[self globalContext] dictionary]];
    [[copyValue currentContext] setVariables:[[self globalContext] variables]];*/
    /*
     [result setDictionary:[[NSMutableDictionary alloc] initWithDictionary:[self dictionary]]];
     [result setDictionaryArray:[[NSMutableArray alloc] initWithArray:[self dictionaryArray]]];
     [result setDictionaryAux:[[NSMutableArray alloc] initWithArray:[self dictionaryAux]]];
     [result setAccessFlags:[self accessFlags]];*/

    PHPScriptFunction* currentContext = [copyValue globalContext];
    [currentContext setInterpretation:copyValue];
    [currentContext setInterpretationForObject:copyValue];
    /*[currentContext setInterpretation:copyValue];
    [currentContext setInterpretationForObject:copyValue];
    
    [copyValue setCurrentContext:currentContext];

    [copyValue setLastSetFunctionCallingContext:nil];*/

    
    //tek ut db init utaf performance, oll db actions aettu hvorteder ad gerast main threadi med thvi ad nota callback?
    /*DBConnection* sql = [[DBConnection alloc] init];
    [sql setInterpretation:copyValue];
    [sql initializeDatabase:@"NoobMusic.db"];
    //[sql executeQuery:@"" values:nil];
    
    PHPData* phpData = [[PHPData alloc] init];
    [phpData init:currentContext sql:sql];
    [phpData setInterpretation:copyValue];
    [phpData setInterpretationForObject:copyValue];
    
    PHPDataWrap* phpDataWrap = [[PHPDataWrap alloc] init];
    [phpDataWrap init:currentContext instances:@{
        @"main": phpData,
    }];
    
    [copyValue setPHPData:phpDataWrap];*/
    
    
    [copyValue setJsParse:[self jsParse]];
    //[[self jsParse] run:copyValue];
    
    [copyValue construct:[[copyValue jsParse] parse_results] definition:[[copyValue jsParse] resultsDefinition] source:[[copyValue jsParse] mainString]];
    [[copyValue globalContext] setClasses:[[self globalContext] copyClasses:copyValue]];
    //PHPScriptFunction* globalContext = [copyValue start:nil];
    //[copyValue initAgainGlobalContext];
    return copyValue;
}

- (void) clearRunningToUnset {
    NSMutableArray* all = [[NSMutableArray alloc] initWithArray:[self toUnset]];
    for(PHPScriptFunction* func in all) {
        if([func parentContext] == nil || [[self toUnset] containsObject:[func parentContext]]) {
            [func unset:nil];
            [func setParentContext:nil];
            @synchronized ([self toUnset]) {
                [[self toUnset] removeObject:func];
            }
        }
    }
}
/*- (void) loadImage {
    NSString* path = @"/Users/siggi/Desktop/silver2.png";
    //NSImage* image = [[NSImage alloc] initWithContentsOfFile:path];
    NSData* imageData = [[NSData alloc] initWithContentsOfFile:path];
    //NSData* imageData = nil;
    NSURL* baseUrl = [[NSURL alloc] initWithString:@"https://noob.software"];
    //[[[[self webView] webFrame] findFrameNamed:@"loadFrame"] loadData:imageData MIMEType:@"image/png" textEncodingName:@"UTF-8" baseURL:baseUrl];
    //[[self webView] loadData:imageData MIMEType:@"image/png" characterEncodingName:@"UTF-8" baseURL:baseUrl];
    //[[self webView] loadData:<#(nonnull NSData *)#> MIMEType:<#(nonnull NSString *)#> characterEncodingName:<#(nonnull NSString *)#> baseURL:<#(nonnull NSURL *)#>
}*/

- (NSMutableArray*) getArrayKeys: (NSDictionary*) values {

    NSMutableArray* keys =  [[NSMutableArray alloc] initWithArray:[[values allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {

        obj1 = [self toJSON:obj1];
        obj2 = [self toJSON:obj2];
        NSString* obj1Key = (NSString*)obj1;
        NSString* obj2Key = (NSString*)obj2;
        return [obj1Key compare:obj2Key];
    }]];
    NSMutableArray* returnkeys = [[NSMutableArray alloc] init];
    for(NSString* key in keys) {

        if(values[key] != nil && ![self isUndefined:values[key]]) {
            [returnkeys addObject:key];
        }
    }

    return returnkeys;
}
- (bool) isUndefined: (NSObject*) value {
    if([value isKindOfClass:[PHPUndefined class]]) { //[value isKindOfClass:[NSString class]] && [(NSString*)value isEqualToString:@"undefined"] &&
        return true;
    } else if(value == nil || value == NULL) {
        return true;
    }
    return false;
}
- (WKWebView*) getWebView {
    return [self webView];
}
- (void) construct: (NSMutableArray*) parsedTree definition: (NSMutableDictionary*) definition source: (NSString*) source {
    //////NSLog(@"in construct : %@", parsedTree);
    [self setParsedTree:parsedTree];
    [self setDefinition:definition];
    [self setSource:source];
    //////////////NSLog(@"firstSource length: %lu", [[self source] length]);
    NSMutableArray* setParsedTree = [[NSMutableArray alloc] init];
    for(NSMutableDictionary* node in parsedTree) {
        [setParsedTree addObject:[self removeWhiteSpace:node]];
    }
    [self setParsedTree:setParsedTree];
    
    /*NSURL* containerURL = [self getContainerPath];
    ////NSLog(@"containerURL : %@", containerURL);
    NSError* error;
    
     NSMutableDictionary* values = [[NSMutableDictionary alloc] initWithDictionary:@{
     //@"parsedTree": setParsedTree,
     @"definition": definition,
     //@"source": source
     }];
    
    ////NSLog(@"values : %@", parsedTree);*/
    
    /*NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:values options:0 error:&error] encoding:NSUTF8StringEncoding];
    ////NSLog(@"json string : %@", jsonString);
    [jsonString writeToURL:containerURL atomically:NO encoding:NSUTF8StringEncoding error:&error];
    ////NSLog(@"error : %@", error);*/
    
    //[values writeToURL:containerURL error:&error];
}

/*- (bool) constructFromFile {
    NSURL* containerURL = [self getContainerPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:@([containerURL fileSystemRepresentation])]) {
        return false;
    }
    
    NSString* stringValue = [NSString stringWithContentsOfFile:@([containerURL fileSystemRepresentation])
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
    NSError* error;
    NSData* dataPostParse = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary* parse_results = [NSJSONSerialization
                             JSONObjectWithData:dataPostParse
                             options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                             error:&error];
    
    
    [self setParsedTree:parse_results[@"parsedTree"]];
    [self setDefinition:parse_results[@"definition"]];
    [self setSource:parse_results[@"source"]];
    
    
    //[interpret construct:parse_results definition:resultsDefinition source:input];
    
    return true;
}*/

- (NSObject*) fromCache: (NSObject*) input context: (PHPScriptObject*) context lastCurrentFunctionContext: (PHPScriptFunction*) lastCurrentFunctionContext {
    ////////NSLog(@"from cache : %@ - %@", input, [self toJSON:input]);
    if([input isKindOfClass:[PHPScriptObject class]]) {
        PHPScriptObject* scriptObject = (PHPScriptObject*)input;
        PHPScriptObject* returnResult = [[PHPScriptObject alloc] init];
        if([scriptObject isArray]) {
            [returnResult setIsArray:true];
            NSMutableArray* arr = (NSMutableArray*)[scriptObject getDictionary];
            for(NSObject* item in arr) {
                [returnResult scriptArrayPush:[self fromCache:item context:context lastCurrentFunctionContext:lastCurrentFunctionContext]];
            }
        } else {
            [returnResult setIsArray:false];
            NSMutableDictionary* arr = (NSMutableDictionary*)[scriptObject getDictionary];
            for(NSObject* key in arr) {
                NSObject* item = arr[key];
                [returnResult setDictionaryValue:key value:[self fromCache:item context:context lastCurrentFunctionContext:lastCurrentFunctionContext] context:nil];
            }
        }
        ////////NSLog(@"from cache return : %@ - %@", input, returnResult);
        return returnResult;
    } else if([input isKindOfClass:[PHPVariableReference class]]) {
        PHPVariableReference* old = (PHPVariableReference*)input;
        PHPVariableReference* returnReference = [[PHPVariableReference alloc] init];
        [returnReference construct:[old identifier] context:context isProperty:@([old isProperty]) defineInContext:@([old defineInContext]) ignoreSetContext:@([old ignoreSetContext])];
        
        [(PHPVariableReference*)returnReference setCurrentContext:lastCurrentFunctionContext];
        ////////NSLog(@"from cache return : %@ - %@ - %@ - %@", input, returnReference, [self toJSON:[old get]], [self toJSON:[returnReference get]]);
        return returnReference;
    }
    ////////NSLog(@"from cache return : %@ - %@", input, input);
    return input;
}

- (bool) containsScriptFunction: (NSObject*) input {
    ////////NSLog(@"containsScriptFunction : %@", input);
    if([input isKindOfClass:[PHPScriptObject class]] && ![input isKindOfClass:[PHPScriptFunction class]]) {
        PHPScriptObject* scriptObject = (PHPScriptObject*)input;
        if([scriptObject isArray]) {
            NSMutableArray* arr = (NSMutableArray*)[scriptObject getDictionary];
            for(NSObject* item in arr) {
                bool intermediateResult = [self containsScriptFunction:item];
                if(intermediateResult) {
                    return true;
                }
            }
        } else {
            NSMutableDictionary* arr = (NSMutableDictionary*)[scriptObject getDictionary];
            for(NSObject* key in arr) {
                NSObject* item = arr[key];
                bool intermediateResult = [self containsScriptFunction:item];
                if(intermediateResult) {
                    return true;
                }
            }
        }
    } else if([input isKindOfClass:[PHPVariableReference class]]) {
        bool intermediateResult = [self containsScriptFunction:[(PHPVariableReference*)input get:nil]];
        if(intermediateResult) {
            return true;
        }
    } else if([input isKindOfClass:[NSArray class]]) {
        NSMutableArray* arr = (NSMutableArray*)input;
        for(NSObject* item in arr) {
            bool intermediateResult = [self containsScriptFunction:item];
            if(intermediateResult) {
                return true;
            }
        }
    } else if([input isKindOfClass:[NSDictionary class]]) {
        NSDictionary* arr = (NSDictionary*)input;
        for(NSObject* key in arr) {
            NSObject* item = arr[key];
            bool intermediateResult = [self containsScriptFunction:item];
            if(intermediateResult) {
                return true;
            }
        }
    } else if([input isKindOfClass:[PHPScriptFunction class]] || [input isKindOfClass:[PHPScriptEvaluationReference class]]) {
        return true;
    }
    
    return false;
}

/*- (NSObject*) toJSONSub: (NSObject*) input {

    if([input isKindOfClass:[PHPScriptVariable class]]) {
        return [(PHPScriptVariable*)input get];
    }

    if([input isKindOfClass:[PHPScriptObject class]]) {
        if([[self toJSONRecursionDetection] containsObject:input]) {

            return @false;
        }
        [[self toJSONRecursionDetection] addObject:input];
        NSObject* dictionary = [(PHPScriptObject*)input getDictionary];

        if([(PHPScriptObject*)input isArray]) {
            NSMutableArray* returnArray = [[NSMutableArray alloc] init];
            for(NSObject* value in (NSMutableArray*)dictionary) {

                [returnArray addObject:[self toJSONSub:value]];
            }
            return returnArray;
        } else if([dictionary isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary* returnDictionary = [[NSMutableDictionary alloc] init];
            for(NSString* key in (NSMutableDictionary*)dictionary) {

                returnDictionary[key] = [self toJSONSub:((NSMutableDictionary*)dictionary)[key]];
            }
            return returnDictionary;
        }
        return dictionary;
    }

    return input;
}*/

- (NSObject*) toJSON: (NSObject*) input {
    //[self setToJSONRecursionDetection:[[NSMutableArray alloc] init]];

    NSObject* results = [self toJSONSub:input];
    //[self setToJSONRecursionDetection:nil];
    return results;
}
- (NSObject*) toJSONSub: (NSObject*) input {

    if([input isKindOfClass:[PHPScriptVariable class]]) {
        return [self toJSONSub:[(PHPScriptVariable*)input get]];
    }
    if([input isKindOfClass:[PHPVariableReference class]]) { // || [input isKindOfClass:[AbstractParameter class]]
        return [self toJSONSub:[(PHPVariableReference*)input get:nil]];
    }
    if([input isKindOfClass:[PHPUndefined class]]) {
        return @"undefined";
    }
    if([input isKindOfClass:[PHPMetadataItem class]]) {
        return [(PHPMetadataItem*)input item];
    }
    if([input isKindOfClass:[PHPScriptFunction class]]) {
        return @false;
    }
    if([input isKindOfClass:[PHPScriptObject class]]) {
        /*if([[self toJSONRecursionDetection] containsObject:input]) {

            return @false;
        }
        [[self toJSONRecursionDetection] addObject:input];*/
        NSObject* dictionary = [(PHPScriptObject*)input getDictionary];

        if([(PHPScriptObject*)input isArray]) {
            NSMutableArray* returnArray = [[NSMutableArray alloc] init];
            for(NSObject* value in (NSMutableArray*)dictionary) {
                NSObject* intermediateResult = [self toJSONSub:value];
                if(intermediateResult != nil) {
                    [returnArray addObject:intermediateResult];
                }
            }
            return returnArray;
        } else if([dictionary isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary* returnDictionary = [[NSMutableDictionary alloc] init];
            for(NSObject* key in (NSMutableDictionary*)dictionary) {
                NSString* stringKey = (NSString*)key;
                if([key isKindOfClass:[NSNumber class]]) {
                    stringKey = [(NSNumber*)key stringValue];
                }
                returnDictionary[stringKey] = [self toJSONSub:((NSMutableDictionary*)dictionary)[key]];
            }
            return returnDictionary;
        }
        return dictionary;
    } else if([input isKindOfClass:[NSArray class]]) {
        NSMutableArray* returnArray = [[NSMutableArray alloc] init];
        for(NSObject* value in (NSMutableArray*)input) {
            
            NSObject* intermediateResult = [self toJSONSub:value];
            if(intermediateResult != nil) {
                [returnArray addObject:intermediateResult];
            }
        }
        return returnArray;
    }
    if(input == nil) {
        return @false;
    }
    return input;
}

- (NSString*) toJSONString: (NSObject*) input {
    NSString *string;
    @autoreleasepool {
        NSObject* intermediateResult = [self toJSON:input];
        NSData* dataItem = [NSJSONSerialization dataWithJSONObject:intermediateResult options:0 error:nil];
        string = [[NSString alloc] initWithData:dataItem encoding:NSUTF8StringEncoding];//[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:intermediateResult options:0 error:nil] encoding:NSUTF8StringEncoding];
    }
    return string;
}

/*- (NSString*) toJSONString: (NSObject*) input {
    NSObject* intermediateResult = [self toJSON:input];
    NSString *string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:intermediateResult options:0 error:nil] encoding:NSUTF8StringEncoding];
    return string;
}*/
- (NSObject*) makeIntoObjects: (NSObject*)  input {
    if([input isKindOfClass:[NSMetadataItem class]]) {
        PHPMetadataItem* metadataItem = [[PHPMetadataItem alloc] init];
        [metadataItem setItem:input];
        [metadataItem setInterpretation:self];
        [metadataItem init:[self globalContext]];
        
        return metadataItem;
    } else
    /*if([input isKindOfClass:[PHPScriptFunction class]]) {
        return @false;
    }*/
    //@autoreleasepool {
        
        if([input isKindOfClass:[NSString class]]) {
            /*PHPScriptVariable* scriptVariable = [[PHPScriptVariable alloc] init];
            [scriptVariable setValue:input];
            [scriptVariable setDatatype:@"string"];
            return scriptVariable;*/
            return [[NSString alloc] initWithString:input];
        } else if([input isKindOfClass:[NSArray class]]) {

            PHPScriptObject* result = [[PHPScriptObject alloc] init];
            //@autoreleasepool {
                [result initArrays];
                [result setIsArray:true];
                //[result setParentContext:[self lastSetFunctionCallingContext]];
                [result setInterpretation:self];
                [result setInterpretationForObject:self];
                int index = 0;
                for(NSObject* arrayItem in (NSArray*)input) {
                    
                    //@autoreleasepool {
                        NSObject* insertItem = [self makeIntoObjects:arrayItem];
                        [result scriptArrayPush:insertItem];
                    //}
                    
                    index++;
                }
                /*test_a*/
                [result setParentContext:nil];
            //}
            //[result setParentContext:[self globalContext]];
            return result;
        } else if([input isKindOfClass:[NSDictionary class]]) {
            PHPScriptObject* result = [[PHPScriptObject alloc] init];
            //@autoreleasepool {
                [result initArrays];
                //[result setParentContext:[self lastSetFunctionCallingContext]];
                [result setInterpretation:self];
                [result setInterpretationForObject:self];
                [result setIsArray:false];
                for(NSObject* key in (NSDictionary*)input) {
                    
                    //@autoreleasepool {
                        NSObject* insertItem = [self makeIntoObjects:((NSDictionary*)input)[key]];
                        //[result dictionary][key] = insertItem;
                        [result setDictionaryValue:key value:insertItem context:nil];
                    //}
                }
                /*test_a*/
                [result setParentContext:nil];
                //[result setParentContext:nil];
                //[result setParentContext:[self globalContext]];
            //}
            return result;
        } else if([input isKindOfClass:[NSNumber class]]) {
            return [[NSNumber alloc] initWithDouble:[(NSNumber*)input doubleValue]];
        } else {
            return input;
        }
        //}
}

/*- (NSString*) decouple {
    NSObject* PHPData = [self makeIntoObjects:[[self jsParse] parse_results]];
    ////////////NSLog(@"receive data: %@", self);
    PHPScriptObject* baseInstance = (PHPScriptObject*)[[self currentContext] getVariableValue:@"base_instance"];

    PHPScriptFunction* receiveData = [baseInstance getDictionaryValue:@"decouple" returnReference:nil createIfNotExists:nil context:nil];

    NSMutableArray* PHPDataWrapped = [[NSMutableArray alloc] init];
    [PHPDataWrapped addObject:PHPData];
    NSMutableArray* DataWrap = [[NSMutableArray alloc] init];
    [DataWrap addObject:PHPDataWrapped];

    NSObject* result = [receiveData callScriptFunctionSub:DataWrap parameterValues:nil awaited:nil returnObject:nil interpretation:nil];
    
    return @"";
}*/

/*- (void) getRows: (NSString*) query values: (NSMutableArray*) values {
    
}*/

- (void) addWsConnection: (NSObject*) input {
    NSObject* PHPData = input; /*[self makeIntoObjects:@{
        @"message": input,
        @"callback": callback
    }];*/
    
    PHPScriptObject* baseInstance = (PHPScriptObject*)[[self currentContext] getVariableValue:@"base_instance"];
    PHPScriptFunction* receiveData = [baseInstance getDictionaryValue:@"__add_ws_connection" returnReference:nil createIfNotExists:nil context:nil];
    NSLog(@"add ws connection");
    
    NSMutableArray* PHPDataWrapped = [[NSMutableArray alloc] init];
    [PHPDataWrapped addObject:PHPData];
    NSMutableArray* DataWrap = [[NSMutableArray alloc] init];
    [DataWrap addObject:PHPDataWrapped];

    [receiveData callScriptFunctionSub:DataWrap parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:nil];
}

- (void) receiveDataDict: (NSObject*) input callback: (id) callback {
    NSObject* PHPData = [self makeIntoObjects:input];
    /*NSObject* PHPData = [self makeIntoObjects:@{
        @"message": input,
        @"callback": callback
    }];*/
    
    PHPScriptObject* baseInstance = (PHPScriptObject*)[[self currentContext] getVariableValue:@"base_instance"];
    PHPScriptFunction* receiveData = [baseInstance getDictionaryValue:@"receive_messages" returnReference:nil createIfNotExists:nil context:nil];
    
    NSMutableArray* PHPDataWrapped = [[NSMutableArray alloc] init];
    [PHPDataWrapped addObject:PHPData];
    NSMutableArray* DataWrap = [[NSMutableArray alloc] init];
    [DataWrap addObject:PHPDataWrapped];

    [receiveData callScriptFunctionSub:DataWrap parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:callback];
    
}

- (void) receiveRequest: (NSObject*) input callback: (PHPScriptFunction*) callback {
    NSObject* PHPData = [self makeIntoObjects:@{
        @"message": input,
        @"callback": callback
    }];
    
    PHPScriptObject* baseInstance = (PHPScriptObject*)[[self currentContext] getVariableValue:@"base_instance"];
    PHPScriptFunction* receiveData = [baseInstance getDictionaryValue:@"receive_request" returnReference:nil createIfNotExists:nil context:nil];
    
    NSMutableArray* PHPDataWrapped = [[NSMutableArray alloc] init];
    [PHPDataWrapped addObject:PHPData];
    NSMutableArray* DataWrap = [[NSMutableArray alloc] init];
    [DataWrap addObject:PHPDataWrapped];

    [receiveData callScriptFunctionSub:DataWrap parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:nil];
}

/*- (NSDictionary*) receiveDataDict: (NSObject*) __weak input function: (NSString*) function {
    @autoreleasepool {
        NSObject* PHPData = [self makeIntoObjects:input];
        ////////////NSLog(@"receive data: %@", self);
        PHPScriptObject* __weak baseInstance = (PHPScriptObject*)[[self currentContext] getVariableValue:@"base_instance"];
        
        PHPScriptFunction* __weak receiveData = [baseInstance getDictionaryValue:function returnReference:nil createIfNotExists:nil context:nil];
        
        NSMutableArray* PHPDataWrapped = [[NSMutableArray alloc] init];
        [PHPDataWrapped addObject:PHPData];
        NSMutableArray* DataWrap = [[NSMutableArray alloc] init];
        [DataWrap addObject:PHPDataWrapped];
        
        //NSObject* result =
        [receiveData callScriptFunctionSub:DataWrap parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:^(NSObject* result) {
            NSDictionary* res;
            if([result isKindOfClass:[PHPReturnResult class]]) {
                result = [(PHPReturnResult*)result get];
            }
            NSError* error;
            //res = [self toJSON:result];
            NSData* dataPost = [(NSString*)result dataUsingEncoding:NSUTF8StringEncoding];
            res = [NSJSONSerialization
                           JSONObjectWithData:dataPost
                           options:0
                           error:&error];
            error = nil;
        }];
        
    }
    //return res;
}*/

/*- (NSString*) receiveData: (NSObject*) input {
    //////////NSLog(@"self currentContext: %@ -  %@", [self currentContext], [[self currentContext] variables]);
    //////////NSLog(@"self currentContext: %@", [self toJSON:[self currentContext]]);
    NSObject* PHPData = [self makeIntoObjects:input];
    ////////////NSLog(@"receive data: %@", self);
    PHPScriptObject* baseInstance = (PHPScriptObject*)[[self currentContext] getVariableValue:@"base_instance"];

    PHPScriptFunction* receiveData = [baseInstance getDictionaryValue:@"receive_messages" returnReference:nil createIfNotExists:nil context:nil];

    NSMutableArray* PHPDataWrapped = [[NSMutableArray alloc] init];
    [PHPDataWrapped addObject:PHPData];
    NSMutableArray* DataWrap = [[NSMutableArray alloc] init];
    [DataWrap addObject:PHPDataWrapped];

    NSObject* result = [receiveData callScriptFunctionSub:DataWrap parameterValues:nil awaited:nil returnObject:nil interpretation:nil];

    if([result isKindOfClass:[PHPReturnResult class]]) {
        result = [(PHPReturnResult*)result get];
    }
    if(!([result isKindOfClass:[NSNumber class]] && [(NSNumber*) result isEqualToNumber:@0]) && ![result isKindOfClass:[NSNull class]] && result != NULL && !([result isKindOfClass:[NSString class]] && [(NSString*)result isEqualToString:@"NULL"])) {
       
        return result;
        //ToJSON* toJSON = [[ToJSON alloc] init];
        //return [toJSON toJSON:result];
    }
    //////NSLog(@"return emtpy string");
    return @"NULL";
}*/
- (NSMutableDictionary*) removeWhiteSpace: (NSMutableDictionary*) node {
    NSMutableArray* subParseObjects = [[NSMutableArray alloc] init];
    for(NSMutableDictionary* value in node[@"sub_parse_objects"]) {

        NSString* label = (NSString*)(value[@"label"]);
        if([label isEqualToString:@"WhiteSpace"] || [label isEqualToString:@"comment"]) {

        } else {
            [subParseObjects addObject:[self removeWhiteSpace:value]];
        }
    }
    node[@"sub_parse_objects"] = subParseObjects;
    return node;
}
- (PHPScriptFunction*) start: (PHPScriptFunction*) globalContext callback:(id)callback {
    if(globalContext == nil) {

    }
    
    //////NSLog(@"self parsed Tree : %@", [self parsedTree]);

    [self execute:[self parsedTree][0] context:[self currentContext] lastParentContextParseLabel:nil lastParentContext:nil control:nil subSwitches:nil lastSetValidContext:nil preventSetValidContext:nil preserveContext:nil inParentContextSetting:nil lastCurrentFunctionContext:nil containedAsync:false callback:^(NSObject* intermediateResult) {
        NSLog(@"intermediateResult : %@", intermediateResult);
        ((void(^)(void))callback)();
    }]; //lastFunctionContextValue:nil]
    return globalContext;
}
- (void) initCopyContext {
    PHPScriptFunction* globalContext;
    globalContext = [[PHPScriptFunction alloc] init];
    [globalContext initArrays];
    [globalContext setInterpretation:self];
    [globalContext setInterpretationForObject:self];
    
    [self setGlobalContext:globalContext];
    [self setCurrentContext:globalContext];
}
- (void) initGlobalContext {
    [self setToUnset:[[NSMutableArray alloc] init]];
    [self setAffectualFunctions:@[
        @"numeric_multiplication",
        @"numeric_subtraction",
        @"numeric_division",
        @"string_addition",
        @"numeric_addition",
        @"or_condition",
        @"and_condition",
        @"inequality_strong",
        @"equals_strong",
        @"inequality",
        @"equals",
        @"greater",
        @"less",
        @"greater_equals",
        @"less_equals",
        @"negative_value",
        @"negate_value"
    ]];
    for(NSString* function in [self affectualFunctions]) {
        [self globalCache][function] = [[NSMutableDictionary alloc] init];
    }
    [self setThreadCounter:0];
    PHPScriptFunction* globalContext;
    globalContext = [[PHPScriptFunction alloc] init];
    [globalContext initArrays];
    [globalContext setInterpretation:self];
    [globalContext setInterpretationForObject:self];
    PHPIncludedObjects* includedObjects = [PHPIncludedObjects alloc];
    [self setMainObjectItem:includedObjects];
    [includedObjects setInterpretation:self];
    [includedObjects init:globalContext];
    [globalContext setVariableValue:@"object" value:includedObjects defineInContext:@true inputParameter:@false overrideThis:@false];

    PHPDates* phpDates = [PHPDates alloc];
    [phpDates setInterpretation:self];
    [phpDates init:globalContext];
    [globalContext setVariableValue:@"date" value:phpDates defineInContext:@true inputParameter:@false overrideThis:@false];

    PHPFiles* phpFiles = [[PHPFiles alloc] init];
    [phpFiles setInterpretation:self];
    [phpFiles init:globalContext];
    [globalContext setVariableValue:@"files" value:phpFiles defineInContext:@true inputParameter:@false overrideThis:@false];

    
    PHPMath* phpMath = [[PHPMath alloc] init];
    //[phpMath setGlobalObject:true];
    [phpMath setInterpretation:self];
    [phpMath init:globalContext];
    [globalContext setVariableValue:@"math" value:phpMath defineInContext:@true inputParameter:@false overrideThis:@false];
    

    /*PHPStrings* phpStrings = [[PHPStrings alloc] init];
    [phpStrings init:globalContext];
    [phpStrings setInterpretation:self];
    [globalContext setVariableValue:@"strings" value:phpStrings defineInContext:@true inputParameter:@false overrideThis:@false];*/
    
    [self setGlobalContext:globalContext];
    [self setCurrentContext:globalContext];
    
    [self setQueue:[[NSOperationQueue alloc] init]];
    [[self queue] setMaxConcurrentOperationCount:64];
    
    NSString* name = @"interpretationQueue";//[@"interpretationQueue" stringByAppendingString:[self description]];
    //QOS_CLASS_USER_INITIATED
    dispatch_queue_attr_t qos = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, 
                                                                        QOS_CLASS_USER_INITIATED,
                                                                        //QOS_CLASS_BACKGROUND,
                                                                        -1);
    dispatch_queue_t recordingQueue = dispatch_queue_create([name UTF8String], qos);
    [self setMessagesQueue:recordingQueue];
    
    NSString* nameTimeQueue = @"timeQueue";
    
    dispatch_queue_attr_t qosTime = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL,
                                                                        QOS_CLASS_USER_INITIATED,
                                                                        //QOS_CLASS_BACKGROUND,
                                                                        -1);
    dispatch_queue_t timeQueue = dispatch_queue_create([nameTimeQueue UTF8String], qosTime);
    [self setTimeQueue:timeQueue];
    
    
    /*NSString* nameAlt = @"interpretationQueueAlt";//[@"interpretationQueue" stringByAppendingString:[self description]];
    //QOS_CLASS_USER_INITIATED
    dispatch_queue_attr_t qosAlt = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT,
                                                                        QOS_CLASS_USER_INITIATED,
                                                                        //QOS_CLASS_BACKGROUND,
                                                                        -1);
    dispatch_queue_t recordingQueueAlt = dispatch_queue_create([nameAlt UTF8String], qosAlt);
    [self setMessagesQueueAlt:recordingQueueAlt];
    */
    /*NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:100];
    [self setMessagesQueue:queue];*/
}


/*- (void) initAgainGlobalContext {
    PHPIncludedObjects* includedObjects = [PHPIncludedObjects alloc];
    [includedObjects setInterpretation:self];
    [includedObjects setInterpretationForObject:self];
    [includedObjects init:[self currentContext]];
    [[self currentContext] setVariableValue:@"object" value:includedObjects defineInContext:@true inputParameter:@false overrideThis:@false];

    PHPDates* phpDates = [PHPDates alloc];
    [phpDates setInterpretation:self];
    [phpDates setInterpretationForObject:self];
    [phpDates init:[self currentContext]];
    [[self currentContext] setVariableValue:@"date" value:phpDates defineInContext:@true inputParameter:@false overrideThis:@false];

    PHPFiles* phpFiles = [[PHPFiles alloc] init];
    [phpFiles setInterpretation:self];
    [phpFiles setInterpretationForObject:self];
    [phpFiles init:[self currentContext]];
    [[self currentContext] setVariableValue:@"files" value:phpFiles defineInContext:@true inputParameter:@false overrideThis:@false];
    //[self setGlobalContext:globalContext];
    //[self setCurrentContext:globalContext];
}*/

- (void) resetGlobalContext {
    PHPScriptFunction* globalContext = [self globalContext];
    PHPIncludedObjects* includedObjects = [PHPIncludedObjects alloc];
    [includedObjects init:globalContext];
    [includedObjects setInterpretation:self];
    [globalContext setVariableValue:@"object_alt" value:includedObjects defineInContext:@true inputParameter:@false overrideThis:@false];

    PHPFiles* phpFiles = [[PHPFiles alloc] init];
    [phpFiles init:globalContext];
    [phpFiles setInterpretation:self];
    [globalContext setVariableValue:@"files_alt" value:phpFiles defineInContext:@true inputParameter:@false overrideThis:@false];
    [self setGlobalContext:globalContext];
    [self setCurrentContext:globalContext];
}

- (void) setPHPData: (PHPDataWrap*) phpData {
    [phpData setInterpretation:self];
    [phpData setInterpretationForObject:self];
    [[self currentContext] setVariableValue:@"data" value:phpData defineInContext:@true inputParameter:@false overrideThis:@false];
}
- (void) setPHPMedia: (PHPMedia*) phpMedia {
    [phpMedia setInterpretation:self];
    [[self currentContext] setVariableValue:@"media" value:phpMedia defineInContext:@true inputParameter:@false overrideThis:@false];
}
- (void) setPHPItem: (PHPScriptObject*) phpItem name: (NSString*) name {
    [phpItem setInterpretation:self];
    [[self currentContext] setVariableValue:name value:phpItem defineInContext:@true inputParameter:@false overrideThis:@false];
}

- (void) varDump: (NSObject*) object {

}

- (NSObject*) fromSubParseCache: (NSObject*) item {
    return item;
}

- (NSObject*) toSubParseCache: (NSObject*) item {
    /*if([item isKindOfClass:[PHPVariableReference class]]) {
        //return [item get];
    }*/
    if([item isKindOfClass:[NSNumber class]] || [item isKindOfClass:[NSString class]]) {
        return item;
    }
    return nil;
}

- (void) execute: (NSMutableDictionary*) subParseObject context: (PHPScriptObject*) context lastParentContextParseLabel: (NSString*) lastParentContextParseLabel lastParentContext: (PHPScriptObject*) lastParentContext control: (PHPControl*) controlInput subSwitches: (NSMutableDictionary*) subSwitches lastSetValidContext: (PHPScriptFunction*) lastSetValidContext preventSetValidContext: (NSNumber*) preventSetValidContext preserveContext: (PHPScriptObject*) preserveContext inParentContextSetting: (NSNumber*) inParentContextSetting lastCurrentFunctionContext: (PHPScriptFunction*) lastCurrentFunctionContext containedAsync:(bool)containedAsync callback: (id) /*__weak*/ callback {
    PHPControl*  control;
    //NSLog(@"execute : %@", subParseObject[@"label"]);
    //id __block callback = callbackInput;
    @autoreleasepool {
        
        PHPInterpretation* __weak weakSelf = self;
        if(controlInput != nil) {
            control = controlInput;
        }
        /*if([context isKindOfClass:[PHPScriptFunction class]] && subParseObject[@"containsFunctionDefinition"] != nil) {
         //[(PHPScriptFunction*)context setContainsCallbacksValue];
         }*/
        //bool containedAsync = false;
        /*if([context isKindOfClass:[PHPScriptFunction class]]) {
         if([(PHPScriptFunction*)context containedAsync]) {
         containedAsync = true;
         }
         } else {
         if([lastCurrentFunctionContext containedAsync]) {
         containedAsync = true;
         }
         }*/
        if(!containedAsync) {
            /*if(subParseObject[@"variableReferenceItemObject"] != nil) {
             if(subParseObject[@"variableReferenceItemObject"] != nil) {
             return subParseObject[@"variableReferenceItemObject"];
             }
             }*/
            /*if(subParseObject[@"variableReferenceItemCallback"] != nil) {
             if(subParseObject[@"variableReferenceItemCallback"] != nil) {
             NSObject* callbackResult = ((NSObject*(^)(void))subParseObject[@"variableReferenceItemCallback"])();
             //NSLog(@"callbackresult : %@", callbackResult);
             return callbackResult;
             }
             }*/
        }
        /*if(subParseObject[@"intermediateResultValue"] != nil) {
         ////NSLog(@"intermediateResult %@", subParseObject[@"intermediateResultValue"]);
         return [weakSelf fromSubParseCache:subParseObject[@"intermediateResultValue"]];
         }*/
        //PHPScriptFunction* lastFunctionContextValue = nil;
        /*if([context isKindOfClass:[PHPScriptFunction class]]) {
         lastFunctionContextValue = context;
         //////NSLog(@"set lastFunctionContextValue: %@", [lastFunctionContextValue debugText]);
         }
         if(lastFunctionContextValue == nil) {
         lastFunctionContextValue = context;
         //////NSLog(@"set lastFunctionContextValue: %@", lastFunctionContextValue);
         }*/
        //PHPScriptObject* context = contextInput; //block
        //@synchronized (context) {
        //@synchronized (subParseObject) {
        
        
        //[context retain];
        /*if(subSwitches == nil || [subParseObject[@"label"] isEqualToString:@"StatementList"]) {
         subSwitches = [[NSMutableDictionary alloc] init];
         }*/
        /*[weakSelf setThreadCounter:[weakSelf threadCounter]+1];
         long threadCount = [weakSelf threadCounter];*/
        //////////NSLog(@"call to execute parseObject: %@ - %@ - %@", subParseObject[@"label"], context, @([weakSelf threadCounter]));
        if([context isKindOfClass:[PHPScriptFunction class]]) {
            lastCurrentFunctionContext = (PHPScriptFunction*)context;
            /*[weakSelf setLastSetFunctionCallingContext:(PHPScriptFunction*)context];
             */
            /*if([[(PHPScriptFunction*)context variables] objectForKey:@"next_tab"] != nil) {
             
             }*/
        }
        PHPScriptFunction* lastCurrentFunctionContextCache = lastCurrentFunctionContext;
        if(subParseObject == NULL || subParseObject == nil) {
            
            //test-a
            [[self queue] addOperationWithBlock:^{
            
            //dispatch_async([weakSelf messagesQueue], ^{
                @autoreleasepool {
                    
                    ((void(^)(NSObject*))callback)([[NSMutableDictionary alloc] init]);
                    //callback = nil;
                }
            //});
            }];
            return;
            //return [[NSMutableDictionary alloc] init];//(NSMutableDictionary*)@[];
        }
        NSDictionary* cacheItemObject = nil;
        NSValue* subParseObjectIndex = nil;
        /*if(subParseObject[@"nsvalue"] == nil) {
         subParseObjectIndex = [NSValue valueWithNonretainedObject:subParseObject];
         subParseObject[@"nsvalue"] = subParseObjectIndex;
         } else {*/
        //subParseObjectIndex = subParseObject[@"nsvalue"];
        //}
        /*bool hasSubParseObjectInCache = false;
         if([[lastCurrentFunctionContext resetableParseObjects] containsObject:subParseObject]) {
         hasSubParseObjectInCache = true;
         }*/
        
        /*if([weakSelf isCopy]) {
         if([weakSelf debugCounter] == 32285) {
         //////////////NSLog(@"subParseObject %@", subParseObject);
         }
         }*/
        /*if([weakSelf isCopy]) {
         ////////////NSLog(@"isCopy");
         } else {
         ////////////NSLog(@"is not copy");
         }*/
        bool setSubContextSub = false;
        NSMutableArray* subContextCallback = [[NSMutableArray alloc] init];
        if([weakSelf definition][subParseObject[@"label"]][@"set_context_sub"] != nil) {
            setSubContextSub = true;
        }
        PHPScriptObject* storeContext;
        bool parentContextIsSet = false;
        if([weakSelf definition][subParseObject[@"label"]][@"parent_context"] != nil) {
            context = preserveContext;
            
            inParentContextSetting = @true;
        }
        if([weakSelf definition][subParseObject[@"label"]][@"preserve_context"] != nil) {
            if([context isKindOfClass:[PHPScriptFunction class]]) {
                
                preserveContext = context;
            }
        }
        /*NSMutableDictionary* subParseSwitchesMerge = [[NSMutableDictionary alloc] init];
         for(NSString* subParseKey in subSwitches) {
         NSObject* switchKey = subSwitches[subParseKey];
         
         if([(NSString*)subParseObject[@"label"] isEqualToString:(NSString*)subParseKey]) {
         subParseSwitchesMerge[(NSString*)switchKey] = @true;
         }
         }*/
        
        NSString* postFunction = NULL;
        bool setResultContext = false;
        bool disableFunctionCall = false;
        NSMutableArray* empty_array_parse_objects = [[NSMutableArray alloc] initWithArray:@[@"FollowingObjectFunctionCall"]];
        
        if([(NSMutableArray*)subParseObject[@"sub_parse_objects"] count] == 0 && [weakSelf definition][subParseObject[@"label"]][@"ignore_empty"] == nil) {
            
            //if([weakSelf arrayHas:empty_array_parse_objects string:subParseObject[@"label"]] != -1) {
            if([empty_array_parse_objects indexOfObject:subParseObject[@"label"]] != NSNotFound) {
                
                //test-a
                [[self queue] addOperationWithBlock:^{
                    //dispatch_async([weakSelf messagesQueue], ^{
                    @autoreleasepool {
                        ((void(^)(NSObject*))callback)([[NSMutableDictionary alloc] init]);
                        //callback = nil;
                    }
                    //});
                }];
                return;
                //return [[NSMutableArray alloc] init];//(NSMutableArray*)@[];
            } else {
                
                /*bool isString = false;
                 if([subParseObject[@"label"] isEqualToString:@"StringContent"] || [subParseObject[@"label"] isEqualToString:@"Identifier"] || [subParseObject[@"label"] isEqualToString:@"AccessFlag"] || [subParseObject[@"label"] isEqualToString:@"ObjectDefinition"]) {
                 isString = true;
                 }
                 return [weakSelf getText:[subParseObject[@"start_index"] unsignedIntValue] stop:[subParseObject[@"stop_index"] unsignedIntValue] isString:isString parseObject:subParseObject];*/
                
                //test-a
                [[self queue] addOperationWithBlock:^{
                    //dispatch_async([weakSelf messagesQueue], ^{
                    @autoreleasepool {
                        ((void(^)(NSObject*))callback)(subParseObject[@"text_value"]);
                        //callback = nil;
                    }
                    //});
                }];
                return;
                //return subParseObject[@"text_value"];
            }
        } else if([weakSelf definition][subParseObject[@"label"]] != nil) {
            
            /*NSMutableArray* switches = [[NSMutableArray alloc] init];//(NSMutableArray*)@[];
             if([weakSelf definition][subParseObject[@"label"]][@"switches"]) {
             switches = [[NSMutableArray alloc] initWithArray:[weakSelf definition][subParseObject[@"label"]][@"switches"]];
             }
             NSMutableDictionary* switchesSet = [[NSMutableDictionary alloc] init];
             
             for(NSMutableDictionary* switchValue in switches) {
             NSMutableDictionary* subObject;
             
             subObject = [weakSelf getSubParseObject:subParseObject nt:((NSMutableDictionary*)switchValue)[@"non_terminal"] offset:0];
             
             
             if(switchValue[@"disable_function"] != nil && subObject == NULL) {
             disableFunctionCall = true;
             } else if(subObject != NULL) {
             if(switchValue[@"set_result_context"] != nil) {
             setResultContext = true;
             }
             if(switchValue[@"sub_parse"] != nil) {
             subSwitches[switchValue[@"sub_parse"]] = switchValue[@"non_terminal"];
             } else {
             switchesSet[switchValue[@"non_terminal"]] = @true;
             }
             }
             }
             [switchesSet addEntriesFromDictionary:subParseSwitchesMerge];
             
             if([switchesSet count] > 0) {
             
             }*/
            NSMutableArray* switches = [[NSMutableArray alloc] init];//(NSMutableArray*)@[];
            if([weakSelf definition][subParseObject[@"label"]][@"switches"]) {
                switches = [[NSMutableArray alloc] initWithArray:[weakSelf definition][subParseObject[@"label"]][@"switches"]];
            }
            ////////////NSLog(@"switches: %@", switches);
            NSMutableDictionary* switchesSet = [[NSMutableDictionary alloc] init];
            if([switches count] > 0) {
                if([switches[0][@"non_terminal"] isEqualToString:@"AsyncFunctionPrefix"]) {
                    if([subParseObject[@"sub_parse_objects"][0][@"label"] isEqualToString:switches[0][@"non_terminal"]]) {
                        switchesSet[switches[0][@"non_terminal"]] = @true;
                    }
                    ////////////NSLog(@"switchesSet : %@", switchesSet);
                }
            }
            
            NSString* function = NULL;
            if([weakSelf definition][subParseObject[@"label"]][@"function"] != nil && [weakSelf definition][subParseObject[@"label"]][@"function"] != NULL && ![(NSString*)[weakSelf definition][subParseObject[@"label"]][@"function"] isEqualToString:@"null"]) {
                function = [weakSelf definition][subParseObject[@"label"]][@"function"];
            }
            
            NSObject* __block callFunctionResult;
            NSString* setPostFunction = NULL;
            if([weakSelf definition][subParseObject[@"label"]][@"set_post_function"] != nil) {
                setPostFunction = [weakSelf definition][subParseObject[@"label"]][@"set_post_function"];
            }
            bool createdControl = false;
            bool controlFromNode = false;
            if(function != NULL) {
                if([function isEqualToString:@"create_named_script_function"]) {
                    context = [context createNamedScriptFunction:context];
                    function = @"set_parameters_named";
                    /*if(subParseObject[@"contains_ReturnStatement"] != nil) {
                     ////NSLog(@"contains return : %@", subParseObject[@"contains_ReturnStatement"]);
                     [(PHPScriptFunction*)context setHasNoReturn:[subParseObject[@"contains_ReturnStatement"] boolValue]];
                     } else {
                     [(PHPScriptFunction*)context setHasNoReturn:false];
                     }*/
                    [(PHPScriptFunction*)context setIsCallback:@false];
                    [(PHPScriptFunction*)context setContainsCallbacks:@false];
                    
                    if(subParseObject[@"containsFunctionDefinition"] != nil) {
                        [(PHPScriptFunction*)context setContainsCallbacks:@true];
                    }
                    /*if([subParseObject[@"sub_parse_objects"] count] == 2) {
                     subParseObject[@"sub_parse_objects"][1][@"sub_parse_objects"][0][@"is_constructor_node"] = @true;
                     } else if([subParseObject[@"sub_parse_objects"] count] == 3) {
                     subParseObject[@"sub_parse_objects"][2][@"sub_parse_objects"][0][@"is_constructor_node"] = @true;
                     }*/
                    //[(PHPScriptFunction*)context setContainsCallbacks:@false];
                    [(PHPScriptFunction*)context setDebugText:(NSString*)[weakSelf getText:[(NSNumber*)subParseObject[@"start_index"] intValue] stop:[(NSNumber*)subParseObject[@"stop_index"] intValue] isString:true parseObject:subParseObject]];
                    //////NSLog(@"create function : %@ - %@ - %@", (NSNumber*)subParseObject[@"start_index"], (NSNumber*)subParseObject[@"stop_index"], [weakSelf getText:[(NSNumber*)subParseObject[@"start_index"] intValue] stop:[(NSNumber*)subParseObject[@"stop_index"] intValue] isString:true parseObject:subParseObject]);
                } else if([function isEqualToString:@"create_script_function"]) {
                    //PHPScriptObject* lastContextForFunction = context;
                    //[(PHPScriptFunction*)context setPropContainsCallbacks];
                    //[(PHPScriptFunction*)context setContainsCallbacksValue];
                    [(PHPScriptFunction*)context setContainsCallbacksValue];
                    if([switchesSet count] == 0) {
                        context = [context createScriptFunction:@false];
                        //[weakSelf setCurrentContextItem:context];
                    } else {
                        //
                        context = [context createScriptFunction:[switchesSet allValues][0]];
                        containedAsync = true;
                    }
                    [(PHPScriptFunction*)context setIsCallback:@true];
                    [(PHPScriptFunction*)context setContainsCallbacks:@false];
                    //[context setParentContextStrong:lastContextForFunction];
                    [(PHPScriptFunction*)context setDebugText:(NSString*)[weakSelf getText:[(NSNumber*)subParseObject[@"start_index"] intValue] stop:[(NSNumber*)subParseObject[@"stop_index"] intValue] isString:true parseObject:subParseObject]];
                    //NSLog(@")
                    /*if(subParseObject[@"containsFunctionDefinition"] != nil) {
                     [(PHPScriptFunction*)context setContainsCallbacks:@true];
                     }*/
                    
                    /*////NSLog(@"create function : %@ - %@ - %@", (NSNumber*)subParseObject[@"start_index"], (NSNumber*)subParseObject[@"stop_index"], [weakSelf getText:[(NSNumber*)subParseObject[@"start_index"] intValue] stop:[(NSNumber*)subParseObject[@"stop_index"] intValue] isString:true parseObject:subParseObject]);*/
                    
                    /*if(subParseObject[@"contains_ReturnStatement"] != nil) {
                     ////NSLog(@"contains return : %@", subParseObject[@"contains_ReturnStatement"]);
                     [(PHPScriptFunction*)context setHasNoReturn:[subParseObject[@"contains_ReturnStatement"] boolValue]];
                     } else {
                     [(PHPScriptFunction*)context setHasNoReturn:false];
                     }*/
                    function = @"set_parameters";
                    lastCurrentFunctionContextCache = context;
                } else if([function isEqualToString:@"create_script_object"]) {
                    
                    if(setPostFunction != NULL) {
                        if(context == [weakSelf currentContext]) {
                            
                        } else {
                            
                        }
                        //context = [(PHPScriptFunction*)context createScriptObjectFunc:@false];
                        PHPScriptObject* objectNew = [(PHPScriptFunction*)context createScriptObjectFunc:@false];
                        if(![context isKindOfClass:[PHPScriptFunction class]]) {
                            //[objectNew setCurrentFunctionContext:context];
                            [objectNew setCurrentFunctionContext:[context currentObjectFunctionContext]]; //perhaps not correct
                        } else {
                            [objectNew setCurrentFunctionContext:(PHPScriptFunction*)context];
                        }
                        context = objectNew;
                        if([context parentContext] == [weakSelf currentContext]) {
                            
                        } else {
                            
                        }
                    } else {
                        if([context isKindOfClass:[PHPScriptFunction class]]) {
                            
                            context = [(PHPScriptFunction*)context createScriptObject:@false];
                        } else {
                            
                            context = [context createScriptObject:@false];
                        }
                    }
                    function = NULL;
                    if(setPostFunction != NULL) {
                        function = setPostFunction;
                    }
                    if([weakSelf definition][subParseObject[@"label"]][@"post_function"] != nil) {
                        postFunction = [weakSelf definition][subParseObject[@"label"]][@"post_function"];
                        
                    }
                    
                    callFunctionResult = context;
                    
                    /*ToJSON* toJSONInstance = [[ToJSON alloc] init];
                     [weakSelf setJsonState:(NSMutableDictionary*)[toJSONInstance toJSON:[weakSelf globalContext]]];*/
                } else if([function isEqualToString:@"create_if_statement"]) {
                    /*if(!containedAsync && subParseObject[@"controlObject"] != nil) {
                     control = subParseObject[@"controlObject"];
                     controlFromNode = true;
                     } else {
                     control = [[PHPMulticonditionalControl alloc] init];
                     [control construct:(PHPScriptFunction*)context];
                     [(PHPMulticonditionalControl*)control constructMultiConditionalControl];
                     function = @"set_condition";
                     if(!containedAsync) {
                     subParseObject[@"controlObject"] = control;
                     [[lastCurrentFunctionContext resetableParseObjects] addObject:subParseObject];
                     }
                     }*/
                    /*if(cacheItemObject != nil && [cacheItemObject[@"type"] isEqualToString:@"controlObject"]) {
                     control = cacheItemObject[@"value"];
                     controlFromNode = true;
                     function = @"set_condition";
                     } else {*/
                    control = [[PHPMulticonditionalControl alloc] init];
                    [control construct:(PHPScriptFunction*)context];
                    [(PHPMulticonditionalControl*)control constructMultiConditionalControl];
                    function = @"set_condition";
                    /*[lastCurrentFunctionContext parseObjectCaches][subParseObjectIndex] = @{
                     @"type": @"controlObject",
                     @"value": control
                     };
                     }*/
                    createdControl = true;
                }  else if([function isEqualToString:@"create_while_loop"]) {
                    /*if(!containedAsync && subParseObject[@"controlObject"] != nil) {
                     control = subParseObject[@"controlObject"];
                     controlFromNode = true;
                     } else {
                     control = [[PHPLoopControl alloc] init];
                     [control construct:(PHPScriptFunction*)context];
                     function = @"set_condition";
                     if(!containedAsync) {
                     subParseObject[@"controlObject"] = control;
                     [[lastCurrentFunctionContext resetableParseObjects] addObject:subParseObject];
                     }
                     }*/
                    /*if(cacheItemObject != nil && [cacheItemObject[@"type"] isEqualToString:@"controlObject"]) {
                     control = cacheItemObject[@"value"];
                     controlFromNode = true;
                     } else {*/
                    control = [[PHPLoopControl alloc] init];
                    [control construct:(PHPScriptFunction*)context];
                    function = @"set_condition";
                    /*[lastCurrentFunctionContext parseObjectCaches][subParseObjectIndex] = @{
                     @"type": @"controlObject",
                     @"value": control
                     };*/
                    //}
                    createdControl = true;
                } else if([function isEqualToString:@"create_for_loop"]) {
                    /*if(!containedAsync && subParseObject[@"controlObject"] != nil) {
                     control = subParseObject[@"controlObject"];
                     controlFromNode = true;
                     } else {
                     control = [[PHPForLoopControl alloc] init];
                     [control construct:(PHPScriptFunction*)context];
                     function = @"set_sub_routine";
                     if(!containedAsync) {
                     subParseObject[@"controlObject"] = control;
                     [[lastCurrentFunctionContext resetableParseObjects] addObject:subParseObject];
                     }
                     }*/
                    
                    /*if(cacheItemObject != nil && [cacheItemObject[@"type"] isEqualToString:@"controlObject"]) {
                     control = cacheItemObject[@"value"];
                     controlFromNode = true;
                     } else {*/
                    control = [[PHPForLoopControl alloc] init];
                    [control construct:(PHPScriptFunction*)context];
                    function = @"set_sub_routine";
                    /*[lastCurrentFunctionContext parseObjectCaches][subParseObjectIndex] = @{
                     @"type": @"controlObject",
                     @"value": control
                     };*/
                    //}
                    createdControl = true;
                } else if([function isEqualToString:@"create_foreach_loop"]) {
                    /*if(!containedAsync && subParseObject[@"controlObject"] != nil) {
                     control = subParseObject[@"controlObject"];
                     controlFromNode = true;
                     } else {
                     control = [[PHPForLoopControl alloc] init];
                     [control construct:(PHPScriptFunction*)context];
                     [(PHPForLoopControl*)control setForeach:true];
                     function = @"set_sub_routine";
                     if(!containedAsync) {
                     subParseObject[@"controlObject"] = control;
                     [[lastCurrentFunctionContext resetableParseObjects] addObject:subParseObject];
                     }
                     }*/
                    
                    
                    /*if(cacheItemObject != nil && [cacheItemObject[@"type"] isEqualToString:@"controlObject"]) {
                     control = cacheItemObject[@"value"];
                     controlFromNode = true;
                     } else {*/
                    control = [[PHPForLoopControl alloc] init];
                    [control construct:(PHPScriptFunction*)context];
                    [(PHPForLoopControl*)control setForeach:true];
                    function = @"set_sub_routine";
                    /*[lastCurrentFunctionContext parseObjectCaches][subParseObjectIndex] = @{
                     @"type": @"controlObject",
                     @"value": control
                     };*/
                    //}
                    createdControl = true;
                } else if([function isEqualToString:@"set_control_switches"]) {
                    //[(PHPForLoopControl*)control setSwitches:switchesSet];
                    function = NULL;
                }
                /*if(createdControl && !containedAsync) {
                 [[lastCurrentFunctionContext resetableParseObjects] addObject:subParseObject];
                 }*/
                /*if(controlFromNode) {
                 if(createdControl && control != NULL) {
                 NSObject* controlResult = [control run:(PHPScriptFunction*)context lastValidCondition:lastSetValidContext];
                 if(([controlResult isKindOfClass:[NSNumber class]] && [(NSNumber*)controlResult boolValue] != false) || [controlResult isKindOfClass:[PHPReturnResult class]]) {
                 //NSLog(@"controlResult : %@", controlResult);
                 
                 ((void(^)(NSObject*))callback)(controlResult);
                 return;
                 //return controlResult;
                 }
                 }
                 
                 ((void(^)(NSObject*))callback)(nil);
                 return;
                 //return nil;
                 }*/
            }
            NSMutableArray* __block values = [[NSMutableArray alloc] init];
            /*long variableReferencesCount = [subParseObject[@"variable_references"] count];
             long variableReferencesCounter = 0;*/
            //for(NSMutableDictionary* variableReference in subParseObject[@"variable_references"]) {//[weakSelf definition][subParseObject[@"label"]][@"variables"]) {
            id /*__block*/ /*__strong*/ mainContinueCallback;
            //id /*__block*/ __weak mainContinueCallback;
            
            //id __weak __block mainContinueCallback;
            
            mainContinueCallback/* = mainContinueCallbackSet*/ = ^(NSString* lastParentContextParseLabel, PHPScriptObject* contextInput, PHPScriptObject* lastParentContext) {
                //id mainContinueCallbackInner = mainContinueCallback;
                PHPScriptObject* __block context = contextInput;
                id /*__block*/ mainFunctionCallback;
                //id __weak __block mainFunctionCallback;
                mainFunctionCallback = ^(NSMutableArray* valuesAltInput) {
                    /*if(valuesAltInput != nil) {
                     values = valuesAltInput;
                     }*/
                    if(function != NULL && [function isEqualToString:@"set_parameters"] && [values count] == 1) {
                        NSMutableArray* setValuesAddition = [[NSMutableArray alloc] initWithArray:@[[[NSMutableArray alloc] init]]];//(NSMutableArray*)@[(NSMutableArray*)@[]];
                        [setValuesAddition addObjectsFromArray:values];
                        values = setValuesAddition;
                    }
                    /*while(variableReferencesCounter < variableReferencesCount) {
                     
                     }*/
                    
                    //////////NSLog(@"function is: %@ - %@ - %@", subParseObject[@"label"], function, values);
                    
                    bool setCacheState = false;
                    bool valuesCallbackResult = false;
                    NSObject* cacheObject = nil;
                    NSObject* valuesDictIndex;
                    /*if([context parentContext] != nil) {
                     if([[context parentContext] isKindOfClass:[PHPScriptFunction class]]) {
                     [(PHPScriptFunction*)[context parentContext] clearRunningToUnset];
                     }
                     }*/
                    @synchronized (context) {
                        id /*__block*/ mainResultsCallback;
                        //id __weak __block mainResultsCallback;
                        mainResultsCallback = ^(NSObject* callFunctionResult) {
                            
                            @synchronized (callFunctionResult) {
                                //if(callFunctionResult != nil) {
                                NSMutableArray* results = [[NSMutableArray alloc] init];
                                NSMutableArray* subContextCallbacks = subContextCallback;
                                //NSLog(@"subContextcallbacks: %lu", [subContextCallback count]);
                                long subContextCallbackIndex = 0;
                                /*NSMutableDictionary* subContextProperties = [[NSMutableDictionary alloc] init];
                                 subContextProperties[@"to_call_count"] = @([subContextCallbacks count]);
                                 subContextProperties[@"called_count"] = @(0);
                                 NSMutableDictionary* resByIndex = [[NSMutableDictionary alloc] init];*/
                                //for(NSObject* subContextCallbackItem in subContextCallbacks) {
                                id /*__block*/ callbackWrapOuter;
                                //id __weak __block callbackWrap;
                                callbackWrapOuter = ^(long subContextCallbackIndex, NSObject* callFunctionResult, NSMutableDictionary* subContextProperties, id callbackWrap) {
                                    NSObject* subContextCallbackItem = subContextCallbacks[subContextCallbackIndex];
                                    ////////////NSLog(@"callFunctionResult is: %@ - %@ - %@", self, callFunctionResult, function);
                                    //[(PHPScriptEvaluationReference*)subContextCallbackItem setLastFunctionContextValue:lastFunctionContextValue];
                                    if(![callFunctionResult isKindOfClass:[PHPScriptObject class]]) {
                                        ////////////NSLog(@"callFunctionresult is not phpscriptfunction--");
                                        callFunctionResult = [[weakSelf globalContext] parseInputVariable:callFunctionResult];
                                    }
                                    //id callbackResBlock = ^(long index){
                                    //NSLog(@"call subcontext callback : %@", @(subContextCallbackIndex));
                                    [(PHPScriptEvaluationReference*)subContextCallbackItem callFun:(PHPScriptFunction*)callFunctionResult callback:^(NSObject* subCallItemResultValue) {
                                        
                                        if(subCallItemResultValue != nil) {
                                            //resByIndex[@(index)] = subCallItemResultValue;
                                            [results addObject:subCallItemResultValue];
                                        }
                                        //@synchronized (subContextProperties) {
                                        //subContextProperties[@"called_count"] = @([subContextProperties[@"called_count"] longLongValue] + 1);
                                        //NSLog(@"subcontext callback callback: %@", subContextProperties);
                                        //if([subContextProperties[@"called_count"] isEqual:subContextProperties[@"to_call_count"]]) {
                                        if(subContextCallbackIndex+1 == [subContextCallbacks count]) {
                                            //if([results count] == 0) {
                                            //if([resByIndex count] == 0) {
                                            if([results count] == 0) {
                                                //test-a
                                                
                                                [[self queue] addOperationWithBlock:^{
                                                    //dispatch_async([weakSelf messagesQueue], ^{
                                                    @autoreleasepool {
                                                        ((void(^)(NSObject*))callback)(callFunctionResult);
                                                        /*callback = nil;
                                                         callbackWrap = nil;
                                                         mainResultsCallback = nil;
                                                         mainFunctionCallback = nil;
                                                         mainContinueCallback = nil;*/
                                                    }
                                                //});
                                                }];
                                                return;
                                                //return callFunctionResult;
                                            }
                                            
                                            /*NSMutableArray* resultsValues = [[NSMutableArray alloc] init];
                                             long setIndexResultsValues = 0;
                                             while(setIndexResultsValues <= index) {
                                             [resultsValues addObject:resByIndex[@(setIndexResultsValues)]];
                                             setIndexResultsValues++;
                                             }*/
                                            
                                            //NSLog(@"res: %@ - %@ - %@", results, resultsValues, resByIndex);
                                            
                                            //test-a
                                            [[self queue] addOperationWithBlock:^{
                                                //dispatch_async([weakSelf messagesQueue], ^{
                                                @autoreleasepool {
                                                    ((void(^)(NSObject*))callback)(results);
                                                    /*callback = nil;
                                                     callbackWrap = nil;
                                                     mainResultsCallback = nil;
                                                     mainFunctionCallback = nil;
                                                     mainContinueCallback = nil;*/
                                                }
                                                //});
                                            }];
                                            return;
                                        } else {
                                            //test-b
                                            //dispatch_async([weakSelf messagesQueue], ^{
                                                @autoreleasepool {
                                                    ((void(^)(long, NSObject*, NSMutableDictionary*, id))callbackWrap)(subContextCallbackIndex+1, callFunctionResult, nil, callbackWrap);
                                                }
                                            //});
                                            return;
                                            //((void(^)(long, NSObject*))callbackWrap)(subContextCallbackIndex+1, callFunctionResult);
                                        }
                                        //}
                                    }];
                                    //};
                                    //if(subContextCallbackIndex == [subContextCallbacks count] - 1) {
                                    /*if([subContextCallbacks count] == 1) {
                                     dispatch_async_and_wait([weakSelf messagesQueue], ^{
                                     ((void(^)(long))callbackResBlock)(subContextCallbackIndex);
                                     });
                                     return;
                                     } else {*/
                                    //NSLog(@"dispatch async");
                                    //dispatch_async_and_wait([weakSelf messagesQueue], ^{
                                    //test-a
                                    /*dispatch_async([weakSelf messagesQueue], ^{
                                     ((void(^)(long))callbackResBlock)(subContextCallbackIndex);
                                     });*/
                                    //});
                                    //return;
                                    //}
                                    //subContextCallbackIndex++;
                                };
                                //callbackWrap = callbackWrapSet;
                                //callbackWrap
                                if([subContextCallbacks count] > 0) {
                                    //test-b
                                    //dispatch_async([weakSelf messagesQueue], ^{
                                    //NSLog(@"subcontextcallbacks count : %lu", [subContextCallbacks count]);
                                    @autoreleasepool {
                                        //long set_counter_index = 0;
                                        //while(set_counter_index < [subContextCallbacks count]) {
                                        //    dispatch_async([weakSelf messagesQueue], ^{
                                                ((void(^)(long, NSObject*, NSMutableDictionary*, id))callbackWrapOuter)(0, callFunctionResult, nil, callbackWrapOuter);
                                        /*    });
                                            set_counter_index++;
                                        }*/
                                    }
                                    //});
                                    return;
                                }
                                if([subContextCallbacks count] == 0) {
                                    if([results count] == 0) {
                                        //test-a
                                        
                                        [[self queue] addOperationWithBlock:^{
                                            //dispatch_async([weakSelf messagesQueue], ^{
                                            @autoreleasepool {
                                                ((void(^)(NSObject*))callback)(callFunctionResult);
                                                
                                                /*callback = nil;
                                                 callbackWrap = nil;
                                                 mainResultsCallback = nil;
                                                 mainFunctionCallback = nil;
                                                 mainContinueCallback = nil;*/
                                            }
                                            //});
                                        }];
                                        return;
                                        //return callFunctionResult;
                                    }
                                    
                                    //test-a
                                    //dispatch_async([weakSelf messagesQueue], ^{
                                    
                                    [[self queue] addOperationWithBlock:^{
                                        @autoreleasepool {
                                            ((void(^)(NSObject*))callback)(results);
                                            
                                            /*callback = nil;
                                             callbackWrap = nil;
                                             mainResultsCallback = nil;
                                             mainFunctionCallback = nil;
                                             mainContinueCallback = nil;*/
                                        }
                                    }];
                                    //});
                                    return;
                                }/* else {
                                  //((void(^)(NSObject*))callback)(nil);
                                  return;
                                  }*/
                                //return results;
                                //}
                                //((void(^)(NSObject*))callback)(nil);
                            }
                        };
                        @synchronized(context) {
                            //mainResultsCallback = mainResultsCallbackSet;
                            if(function != NULL) {
                                //NSLog(@"setfunction values : %@ , %@", values, function);
                                /*for(NSObject* value in values) {
                                 if([value isKindOfClass:[PHPScriptObject class]] && ![value isKindOfClass:[PHPScriptFunction class]]) {
                                 if([(PHPScriptObject*)value parentContext] == nil) {
                                 //NSLog(@"set globalcontext without parentcontext");
                                 [(PHPScriptObject*)value setParentContext:lastCurrentFunctionContext];//[weakSelf globalContext]];
                                 }
                                 }
                                 }*/
                                /*NSMutableArray* setValuesValues = [[NSMutableArray alloc] init];
                                 for(NSObject* value in setValuesValues) {
                                 [setValuesValues addObject:[[weakSelf globalContext] parseInputVariable:value]];
                                 }
                                 values = setValuesValues;*/
                                /*if(returnValueResultStopExecution != nil) {
                                 ((void(^)(NSObject*))callback)(returnValueResultStopExecution);
                                 return;
                                 //return returnValueResultStopExecution;
                                 }*/
                                //if([switchesSet count] > 0 && [values count] == 0) {
                                if([function isEqualToString:@"call_script_function_sub"]) {
                                    [values addObject:[[NSMutableArray alloc] init]];
                                }
                                //}
                                if([weakSelf definition][subParseObject[@"label"]][@"wrap_values"] != nil) {
                                    values = [[NSMutableArray alloc] initWithArray:@[values]];
                                }
                                /*for(NSString* key in switchesSet) {
                                 NSObject* value = switchesSet[key];
                                 
                                 [values addObject:value];
                                 }*/
                                
                                if(disableFunctionCall) {
                                    
                                    //test-a
                                    //dispatch_async([weakSelf messagesQueue], ^{
                                    
                                    [[self queue] addOperationWithBlock:^{
                                        @autoreleasepool {
                                            ((void(^)(NSObject*))callback)(values);
                                            /*
                                             callback = nil;
                                             mainResultsCallback = nil;
                                             mainFunctionCallback = nil;
                                             mainContinueCallback = nil;*/
                                        }
                                    }];
                                    //});
                                    return;
                                    //return values;
                                    
                                }
                                NSObject* setContext = context;
                                
                                /*debug*/
                                /*for(NSObject* valuesItem in values) {
                                 if([valuesItem isKindOfClass:[PHPUndefined class]]) {
                                 if([context isKindOfClass:[PHPScriptFunction class]]) {
                                 NSLog(@"context has undefined : %@", [(PHPScriptFunction*)context debugText]);
                                 } else {
                                 NSLog(@"other context");
                                 }
                                 }
                                 }
                                 NSLog(@"values : %@", values);*/
                                
                                if(([function isEqualToString:@"set_condition"] || [function isEqualToString:@"set_else_condition"] || [function isEqualToString:@"set_sub_routine"]) && control != NULL) {
                                    
                                    setContext = control;
                                }
                                /*PHPScriptFunction* parentContext = NULL;
                                 if([setContext isKindOfClass:[PHPScriptObject class]] || [setContext isKindOfClass:[PHPScriptFunction class]]) {
                                 parentContext = [(PHPScriptObject*)setContext parentContext];
                                 }*/
                                
                                NSMutableArray* callUserFuncArrayValues = [[NSMutableArray alloc] init];//(NSMutableArray*)@[];
                                if([context isKindOfClass:[PHPScriptObject class]]) {
                                    //lastCurrentFunctionContextCache =
                                } else {
                                    
                                }
                                while([setContext isKindOfClass:[PHPReturnResult class]]) {
                                    
                                    setContext = [(PHPReturnResult*)setContext get];
                                    
                                }
                                /*if([setContext isKindOfClass:[PHPCallbackReference class]]) {
                                 setContext = [(PHPCallbackReference*)setContext referenceItem];
                                 }*/
                                /*mainResultsCallback = ^(NSObject* callFunctionResult) {
                                 if(callFunctionResult != nil) {
                                 NSMutableArray* results = [[NSMutableArray alloc] init];
                                 NSMutableArray* subContextCallbacks = subContextCallback;
                                 //NSLog(@"subContextcallbacks: %lu", [subContextCallback count]);
                                 long subContextCallbackIndex = 0;
                                 NSMutableDictionary* subContextProperties = [[NSMutableDictionary alloc] init];
                                 subContextProperties[@"to_call_count"] = @([subContextCallbacks count]);
                                 subContextProperties[@"called_count"] = @(0);
                                 NSMutableDictionary* resByIndex = [[NSMutableDictionary alloc] init];
                                 for(NSObject* subContextCallbackItem in subContextCallbacks) {
                                 ////////////NSLog(@"callFunctionResult is: %@ - %@ - %@", self, callFunctionResult, function);
                                 //[(PHPScriptEvaluationReference*)subContextCallbackItem setLastFunctionContextValue:lastFunctionContextValue];
                                 if(![callFunctionResult isKindOfClass:[PHPScriptObject class]]) {
                                 ////////////NSLog(@"callFunctionresult is not phpscriptfunction--");
                                 callFunctionResult = [[weakSelf globalContext] parseInputVariable:callFunctionResult];
                                 }
                                 id callbackResBlock = ^(long index){
                                 
                                 [(PHPScriptEvaluationReference*)subContextCallbackItem callFun:(PHPScriptFunction*)callFunctionResult callback:^(NSObject* subCallItemResultValue) {
                                 
                                 if(subCallItemResultValue != nil) {
                                 resByIndex[@(index)] = subCallItemResultValue;
                                 //[results addObject:subCallItemResultValue];
                                 }
                                 @synchronized (subContextProperties) {
                                 subContextProperties[@"called_count"] = @([subContextProperties[@"called_count"] longLongValue] + 1);
                                 //NSLog(@"subcontext callback callback: %@", subContextProperties);
                                 if([subContextProperties[@"called_count"] isEqual:subContextProperties[@"to_call_count"]]) {
                                 //if([results count] == 0) {
                                 if([resByIndex count] == 0) {
                                 ((void(^)(NSObject*))callback)(callFunctionResult);
                                 return;
                                 //return callFunctionResult;
                                 }
                                 
                                 NSMutableArray* resultsValues = [[NSMutableArray alloc] init];
                                 long setIndexResultsValues = 0;
                                 while(setIndexResultsValues <= index) {
                                 [resultsValues addObject:resByIndex[@(setIndexResultsValues)]];
                                 setIndexResultsValues++;
                                 }
                                 
                                 //NSLog(@"res: %@ - %@ - %@", results, resultsValues, resByIndex);
                                 
                                 ((void(^)(NSObject*))callback)(resultsValues);
                                 return;
                                 }
                                 }
                                 }];
                                 };
                                 //if(subContextCallbackIndex == [subContextCallbacks count] - 1) {
                                 if([subContextCallbacks count] == 1) {
                                 dispatch_async_and_wait([weakSelf messagesQueue], ^{
                                 ((void(^)(long))callbackResBlock)(subContextCallbackIndex);
                                 });
                                 return;
                                 } else {
                                 NSLog(@"dispatch async");
                                 dispatch_async_and_wait([weakSelf messagesQueue], ^{
                                 ((void(^)(long))callbackResBlock)(subContextCallbackIndex);
                                 });
                                 //return;
                                 }
                                 subContextCallbackIndex++;
                                 }
                                 if([subContextCallbacks count] == 0) {
                                 if([results count] == 0) {
                                 ((void(^)(NSObject*))callback)(callFunctionResult);
                                 return;
                                 //return callFunctionResult;
                                 }
                                 
                                 ((void(^)(NSObject*))callback)(results);
                                 return;
                                 } else {
                                 //((void(^)(NSObject*))callback)(results);
                                 return;
                                 }
                                 //return results;
                                 }
                                 };*/
                                if(function != NULL && function != nil) {
                                    /*if(!containedAsync) {
                                     if(subParseObject[@"variableReferenceItemCallbackValues"] != nil) {
                                     NSObject* callbackResult = ((NSObject*(^)(NSMutableArray*))subParseObject[@"variableReferenceItemCallbackValues"])(values);
                                     //NSLog(@"callbackresult : %@", callbackResult);
                                     return callbackResult;
                                     //return subParseObject[@"variableReferenceItemCallbackValues"]
                                     }
                                     }*/
                                    //!containedAsync &&
                                    /*if(cacheItemObject != nil && [cacheItemObject[@"type"] isEqualToString:@"variableReferenceItemCallbackValues"]) {
                                     NSObject* callbackResult = ((NSObject*(^)(NSMutableArray*))cacheItemObject[@"value"])(values);
                                     //NSLog(@"callbackresult : %@", callbackResult);
                                     return callbackResult;
                                     }*/
                                    if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                        //lastCurrentFunctionContextCache = setContext;
                                    } else if([setContext isKindOfClass:[PHPScriptObject class]]) {
                                        
                                    }
                                    /*if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                     lastFunctionContextValue = setContext;
                                     
                                     //////NSLog(@"set lastFunctionContextValue: %@", [lastFunctionContextValue debugText]);
                                     }*/
                                    /*for(NSObject* value_item_log in values) {
                                     
                                     }*/
                                    
                                    bool skipFunction = false;
                                    
                                    /*if(subParseObject[@"containsIdentifierThis"] != nil && [subParseObject[@"containsIdentifierThis"] boolValue]) {
                                     
                                     } else*/
                                    
                                    bool isGlobal = false;
                                    
                                    /*for(NSObject* valueItem in values) {
                                     if([valueItem isKindOfClass:[PHPScriptObject class]]) {
                                     if([(PHPScriptObject*)valueItem globalObject]) {
                                     isGlobal = true;
                                     }
                                     }
                                     }*/
                                    /*if(!isGlobal && [[weakSelf affectualFunctions] indexOfObject:function] == NSNotFound && callFunctionResult == nil) {
                                     valuesDictIndex = [weakSelf getState:context];
                                     if(valuesDictIndex != nil && valuesDictIndex != NULL && subParseObject[@"cache_states"][valuesDictIndex] != nil) {
                                     ////////NSLog(@"valuesDictIndex: %@", valuesDictIndex);
                                     ////////NSLog(@"cacheState is : %@", [weakSelf toJSON:subParseObject[@"cache_states"][valuesDictIndex]]);
                                     callFunctionResult =
                                     [weakSelf fromCache:subParseObject[@"cache_states"][valuesDictIndex] context:context lastCurrentFunctionContext:lastCurrentFunctionContext];
                                     ////NSLog(@"used cache");
                                     skipFunction = true;
                                     } else {
                                     setCacheState = true;
                                     }
                                     }*/
                                    /*if([[weakSelf affectualFunctions] indexOfObject:function] != NSNotFound && callFunctionResult == nil) {
                                     ToJSON* toJSON = [[ToJSON alloc] init];
                                     cacheObject = [toJSON toJSON:values];
                                     if([weakSelf globalCache][function] != nil && [weakSelf globalCache][function][cacheObject] != nil) {
                                     callFunctionResult = [weakSelf globalCache][function][cacheObject];
                                     skipFunction = true;
                                     } else {
                                     setCacheState = true;
                                     }
                                     }*/
                                    
                                    
                                    ////////////NSLog(@"function is: %@", function);
                                    /*if([setContext isKindOfClass:[PHPScriptObject class]] && ![weakSelf isEqualTo:[(PHPScriptObject*)setContext getInterpretation]]) {
                                     //////////NSLog(@"functionCall - interpretations differ: %@ - %@ - %@", self, [(PHPScriptObject*)setContext getInterpretation]);
                                     if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                     //////////NSLog(@"func identifier: %@", [(PHPScriptFunction*)setContext identifier]);
                                     } else {
                                     //////////NSLog(@"func parent identifier: %@", [[(PHPScriptObject*)setContext parentContext] identifier]);
                                     }
                                     }*/
                                    if(!skipFunction) {
                                        //@synchronized (setContext) {
                                        
                                        //////NSLog(@"function : %@ - %@", function, values);
                                        if([function isEqualToString:@"set_sub_routine"]) {
                                            [(PHPLoopControl*)setContext setSubRoutine:(PHPScriptEvaluationReference*)[weakSelf getMutableArrayValueNil:values index:0]];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_parameters"]) {
                                            
                                            if([values count] == 1) {
                                                [values insertObject:[[NSMutableArray alloc] init] atIndex:0];
                                            }
                                            callFunctionResult = [(PHPScriptFunction*)setContext setParameters:[weakSelf getMutableArrayValueNil:values index:0] scriptIndexReference:[weakSelf getMutableArrayValueNil:values index:1]];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_parameters_named"]) {
                                            
                                            if([values count] == 2) {
                                                [values insertObject:[[NSMutableArray alloc] init] atIndex:1];
                                            }
                                            callFunctionResult = [(PHPScriptFunction*)setContext setParametersNamed:[weakSelf getMutableArrayValueNil:values index:0] parameters:[weakSelf getMutableArrayValueNil:values index:1] scriptIndexReference:[weakSelf getMutableArrayValueNil:values index:2]];
                                            setCacheState = false;
                                            //valuesCallbackResult = true;
                                        } else if([function isEqualToString:@"set_object_identifier"]) {
                                            
                                            [(PHPScriptObject*)setContext setObjectIdentifier:[weakSelf getMutableArrayValueNil:values index:0]];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"script_push_array"]) {
                                            //NSLog(@"script array push : %@", values);
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                [(PHPScriptFunction*)setContext scriptPushArray:[weakSelf getMutableArrayValueNil:values index:0] item:[weakSelf getMutableArrayValueNil:values index:1]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] scriptPushArray:[weakSelf getMutableArrayValueNil:values index:0] item:[weakSelf getMutableArrayValueNil:values index:1]];
                                            }
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"return_result_dereference"]) {
                                            if(![setContext isKindOfClass:[PHPScriptObject class]]) {
                                                ////////////NSLog(@"setContext return_result_dereference is not scriptobject");
                                                setContext = [[weakSelf globalContext] parseInputVariable:setContext];
                                            }
                                            callFunctionResult = [(PHPScriptObject*)setContext returnResultDereference:[weakSelf getMutableArrayValueNil:values index:0]];
                                            ////NSLog(@"callfunctionresult from dereference : %@", callFunctionResult);
                                            setCacheState = false;
                                            valuesCallbackResult = true;
                                        } else if([function isEqualToString:@"set_paranthesis"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext setParanthesis:[weakSelf getMutableArrayValueNil:values index:0]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] setParanthesis:[weakSelf getMutableArrayValueNil:values index:0]];
                                            }
                                        } else if([function isEqualToString:@"set_variable_increment"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext setVariableIncrement:[weakSelf getMutableArrayValueNil:values index:0]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] setVariableIncrement:[weakSelf getMutableArrayValueNil:values index:0]];
                                            }
                                        } else if([function isEqualToString:@"set_variable_decrement"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext setVariableDecrement:[weakSelf getMutableArrayValueNil:values index:0]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] setVariableDecrement:[weakSelf getMutableArrayValueNil:values index:0]];
                                            }
                                        } else if([function isEqualToString:@"set_variable_value_append"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext setVariableValueAddition:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] method:@"."];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] setVariableValueAddition:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] method:@"."];
                                            }
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_variable_value_multiplication"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext setVariableValueAddition:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] method:@"*"];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] setVariableValueAddition:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] method:@"*"];
                                            }
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_variable_value_division"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext setVariableValueAddition:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] method:@"/"];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] setVariableValueAddition:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] method:@"/"];
                                            }
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_variable_value_subtraction"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext setVariableValueAddition:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] method:@"-"];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] setVariableValueAddition:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] method:@"-"];
                                            }
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_variable_value_addition"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext setVariableValueAddition:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] method:@"+"];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] setVariableValueAddition:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] method:@"+"];
                                            }
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_variable_value"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext setVariableValue:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] setVariableValue:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4]];
                                            }
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_variable_value_in_context"]) {
                                            
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                
                                                callFunctionResult = [(PHPScriptFunction*)setContext setVariableValueInContext:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] context:lastCurrentFunctionContext];
                                                //lastCurrentFunctionContext
                                                //lastFunctionContextValue
                                            } else {
                                                
                                                callFunctionResult = [(PHPScriptObject*)setContext setVariableValueInContext:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2] inputParameter:[weakSelf getMutableArrayValueNil:values index:3] overrideThis:[weakSelf getMutableArrayValueNil:values index:4] context:lastCurrentFunctionContext];
                                                //lastCurrentFunctionContext
                                                //lastFunctionContextValue
                                            }
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"numeric_multiplication"]) {
                                            //////NSLog(@"inside mult : %@", values);
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext numericMultiplication:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[weakSelf currentContext]  numericMultiplication:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                            }
                                            //current
                                            //////NSLog(@"numeric_subtraction : %@ - %@", setContext, values);
                                        } else if([function isEqualToString:@"numeric_subtraction"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext numericSubtraction:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                //callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] numericSubtraction:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                                callFunctionResult = [[weakSelf currentContext] numericSubtraction:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                            }
                                            //NSLog(@"numeric_subtraction callfunction result : %@", callFunctionResult);
                                            //current
                                        } else if([function isEqualToString:@"numeric_division"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext numericDivision:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [[weakSelf currentContext] numericDivision:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                            }
                                        } else if([function isEqualToString:@"string_addition"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext stringAddition:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[weakSelf currentContext]  stringAddition:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                            }
                                        } else if([function isEqualToString:@"numeric_addition"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext numericAddition:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[weakSelf currentContext]  numericAddition:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                            }
                                        } else if([function isEqualToString:@"set_property_reference"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext setPropertyReference:[weakSelf getMutableArrayValueNil:values index:0]];
                                            /*if(!containedAsync) {
                                             subParseObject[@"variableReferenceItemObject"] = callFunctionResult;
                                             [[lastCurrentFunctionContext resetableParseObjects] addObject:subParseObject];
                                             }*/
                                            //lastCurrentFunctionContext
                                            /*[(PHPScriptFunction*)lastCurrentFunctionContextCache parseObjectCaches][subParseObjectIndex] = @{
                                             @"type": @"variableReferenceItemObject",
                                             @"value":callFunctionResult
                                             };*/
                                            //[lastCurrentFunctionContext addIfNotResetableParseObjects:subParseObject];
                                            
                                            //[(PHPScriptObject*)setContext addResetableParseObject:subParseObject];
                                            setContext = false;
                                        } else if([function isEqualToString:@"set_class_reference"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext setClassReference:[weakSelf getMutableArrayValueNil:values index:0]];
                                            setContext = false;
                                        } else if([function isEqualToString:@"set_variable_reference"]) {
                                            
                                            //////////NSLog(@"setVariableReference: %@ - %@", setContext, values);
                                            
                                            callFunctionResult = [(PHPScriptObject*)setContext setVariableReference:[weakSelf getMutableArrayValueNil:values index:0] ignore:[weakSelf getMutableArrayValueNil:values index:1] defineInContext:[weakSelf getMutableArrayValueNil:values index:2]];
                                            [(PHPVariableReference*)callFunctionResult setCurrentContext:lastCurrentFunctionContext];
                                            /*if(!containedAsync) {
                                             subParseObject[@"variableReferenceItemObject"] = callFunctionResult;
                                             [[lastCurrentFunctionContext resetableParseObjects] addObject:subParseObject];
                                             }*/
                                            /*[(PHPScriptFunction*)lastCurrentFunctionContextCache parseObjectCaches][subParseObjectIndex] = @{
                                             @"type": @"variableReferenceItemObject",
                                             @"value": callFunctionResult
                                             };*/
                                            //[lastCurrentFunctionContext addIfNotResetableParseObjects:subParseObject];
                                            
                                            //[(PHPScriptObject*)setContext addResetableParseObject:subParseObject];
                                            //lastCurrentFunctionContext
                                            //lastFunctionContextValue
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_variable_reference_ignore"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext setVariableReferenceIgnore:[weakSelf getMutableArrayValueNil:values index:0] ignore:[weakSelf getMutableArrayValueNil:values index:1]];
                                            [(PHPVariableReference*)callFunctionResult setCurrentContext:lastCurrentFunctionContext]; //lastCurrentFunctionContext
                                            /*if(!containedAsync) {
                                             subParseObject[@"variableReferenceItemObject"] = callFunctionResult;
                                             [[lastCurrentFunctionContext resetableParseObjects] addObject:subParseObject];
                                             }*/
                                            /*[(PHPScriptFunction*)lastCurrentFunctionContextCache parseObjectCaches][subParseObjectIndex] = @{
                                             @"type": @"variableReferenceItemObject",
                                             @"value":callFunctionResult
                                             };*/
                                            //[lastCurrentFunctionContext addIfNotResetableParseObjects:subParseObject];
                                            
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_string"]) {
                                            
                                            callFunctionResult = (NSObject*)[(PHPScriptObject*)setContext setString:[weakSelf getMutableArrayValueNil:values index:0]];
                                            
                                            //subParseObject[@"variableReferenceItemObject"] = callFunctionResult;
                                            
                                        } else if([function isEqualToString:@"set_condition"]) {
                                            if([setContext isKindOfClass:[PHPMulticonditionalControl class]]) {
                                                
                                                [(PHPMulticonditionalControl*)setContext setCondition:[weakSelf getMutableArrayValueNil:values index:0] subRoutine:[weakSelf getMutableArrayValueNil:values index:1]];
                                            } else if([setContext isKindOfClass:[PHPLoopControl class]]) {
                                                [(PHPLoopControl*)setContext setCondition:(PHPScriptEvaluationReference *)[weakSelf getMutableArrayValueNil:values index:0] subRoutine:(PHPScriptEvaluationReference *)[weakSelf getMutableArrayValueNil:values index:1]];
                                            } else if([setContext isKindOfClass:[PHPForLoopControl class]]) {
                                                [(PHPForLoopControl*)setContext setCondition:[weakSelf getMutableArrayValueNil:values index:0] b:[weakSelf getMutableArrayValueNil:values index:1] c:[weakSelf getMutableArrayValueNil:values index:2]];
                                            }
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"or_condition"]) {
                                            [(PHPScriptFunction*)setContext orCondition:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1] callback:^(NSObject* callFunctionResultItem) {
                                                //callFunctionResult = callFunctionResultItem;
                                                
                                                //test-b
                                                //dispatch_async([weakSelf messagesQueue], ^{
                                                    @autoreleasepool {
                                                        ((void(^)(NSObject*))mainResultsCallback)(callFunctionResultItem);
                                                        /*mainResultsCallback = nil;
                                                        //mainFunctionCallback = nil;
                                                        mainContinueCallback = nil;*/
                                                    }
                                                //});
                                                return;
                                            }];
                                            return;
                                            //callFunctionResult = [(PHPScriptFunction*)setContext orCondition:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                        } else if([function isEqualToString:@"and_condition"]) {
                                            
                                            //callFunctionResult =
                                            [(PHPScriptFunction*)setContext andCondition:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1] callback:^(NSObject* callFunctionResultItem) {
                                                //callFunctionResult = callFunctionResultItem;
                                                
                                                //test-b
                                                //dispatch_async([weakSelf messagesQueue], ^{
                                                    @autoreleasepool {
                                                        ((void(^)(NSObject*))mainResultsCallback)(callFunctionResultItem);
                                                        /*
                                                        mainResultsCallback = nil;
                                                        //mainFunctionCallback = nil;
                                                        mainContinueCallback = nil;*/
                                                    }
                                                //});
                                                return;
                                            }];
                                            return;
                                        } else if([function isEqualToString:@"inequality_strong"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext inequalityStrong:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                        } else if([function isEqualToString:@"equals_strong"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext equalsStrong:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                        } else if([function isEqualToString:@"inequality"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext inequality:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                        } else if([function isEqualToString:@"equals"]) {
                                            
                                            callFunctionResult = [(PHPScriptObject*)setContext equals:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                        } else if([function isEqualToString:@"greater"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext greater:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                        } else if([function isEqualToString:@"less"]) {
                                            //NSLog(@"less : %@", values);
                                            callFunctionResult = [(PHPScriptObject*)setContext less:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                        } else if([function isEqualToString:@"greater_equals"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext greaterEquals:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                        } else if([function isEqualToString:@"less_equals"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext lessEquals:[weakSelf getMutableArrayValueNil:values index:0] valueB:[weakSelf getMutableArrayValueNil:values index:1]];
                                        } else if([function isEqualToString:@"set_else_condition"]) {
                                            [(PHPMulticonditionalControl*)setContext setElseCondition:(PHPScriptEvaluationReference *)[weakSelf getMutableArrayValueNil:values index:0]];
                                            
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_condition"]) {
                                            [(PHPMulticonditionalControl*)setContext setCondition:[weakSelf getMutableArrayValueNil:values index:0] subRoutine:[weakSelf getMutableArrayValueNil:values index:1]];
                                            setCacheState = false;
                                            
                                        } else if([function isEqualToString:@"set_dictionary_value"]) {
                                            [(PHPScriptObject*)setContext setDictionaryValue:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1] context:lastCurrentFunctionContext];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"negative_value"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext negativeValue:[weakSelf getMutableArrayValueNil:values index:0]];
                                        } else if([function isEqualToString:@"negate_value"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext negateValue:[weakSelf getMutableArrayValueNil:values index:0]];
                                        } else if([function isEqualToString:@"set_access_flag"]) {
                                            //NSLog(@"set access flag : %@ - %@", [weakSelf getMutableArrayValueNil:values index:0], subParseObject[@"label"]);
                                            //NSObject* parScriptFunc = [weakSelf getMutableArrayValueNil:values index:1];
                                            /*if([parScriptFunc isKindOfClass:[PHPScriptFunction class]]) {
                                                NSLog(@"parscriptfunc : %@ ", parScriptFunc);
                                                NSLog(@"parscriptfunc : %@ ", [((PHPScriptFunction*)parScriptFunc) identifier]);
                                                
                                            }*/
                                            
                                            [(PHPScriptObject*)setContext setAccessFlag:[weakSelf getMutableArrayValueNil:values index:0] property:[weakSelf getMutableArrayValueNil:values index:1]];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"set_prototype"]) {
                                            [(PHPScriptObject*)setContext setPrototype:[weakSelf getMutableArrayValueNil:values index:0]];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"return_parameter_input"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext returnParameterInput:[weakSelf getMutableArrayValueNil:values index:0]];
                                            setCacheState = false;
                                            
                                        } else if([function isEqualToString:@"return_parameter_input_identifier_value"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext returnParameterInputIdentifierValue:[weakSelf getMutableArrayValueNil:values index:0] value:[weakSelf getMutableArrayValueNil:values index:1]];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"collect_parameters"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext collectParameters:[weakSelf getMutableArrayValueNil:values index:0]];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"return_result"]) {
                                            ////////////NSLog(@"return_result: %@ %@", setContext, [setContext class]);
                                            if(![setContext isKindOfClass:[PHPScriptObject class]]) {
                                                ////////////NSLog(@"set context is not phpscriptobject");
                                                //setContext = [[weakSelf globalContext] parseInputVariable:setContext];
                                            }
                                            /*if(subParseObject[@"returnResultIndex"] != nil) {
                                             long index = [subParseObject[@"returnResultIndex"] longLongValue];
                                             NSObject* valueItem = [weakSelf getMutableArrayValueNil:values index:0];
                                             if([valueItem isKindOfClass:[NSArray class]] && [(NSArray*)valueItem count] > index) {
                                             callFunctionResult = ((NSArray*)valueItem)[index];
                                             }
                                             } else {*/
                                            /*NSObject* objitem = [weakSelf getMutableArrayValueNil:values index:0];
                                             callFunctionResult = [(PHPScriptObject*)setContext returnResult:objitem b:nil];*/
                                            /*if(callFunctionResult != NULL) {
                                             subParseObject[@"returnResultIndex"] = @([((NSArray*)objitem) indexOfObject:callFunctionResult]);
                                             }*/
                                            callFunctionResult = [(PHPScriptObject*)setContext returnResult:[weakSelf getMutableArrayValueNil:values index:0] b:[weakSelf getMutableArrayValueNil:values index:1]];
                                            /*if(callFunctionResult != NULL) {
                                             subParseObject[@"returnResultIndex"] = ((NSDictionary*)callFunctionResult)[@"index"];
                                             callFunctionResult = ((NSDictionary*)callFunctionResult)[@"value"];
                                             }*/
                                            // }
                                            setCacheState = false;
                                            valuesCallbackResult = true;
                                        } else if([function isEqualToString:@"return_prop_result"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext returnPropResult:[weakSelf getMutableArrayValueNil:values index:0]];
                                            setCacheState = false;
                                            valuesCallbackResult = true;
                                        } else if([function isEqualToString:@"return_value_result"]) {
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext returnValueResult:[weakSelf getMutableArrayValueNil:values index:0]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] returnValueResult:[weakSelf getMutableArrayValueNil:values index:0]];
                                            }
                                            
                                            setCacheState = false;
                                            valuesCallbackResult = true;
                                        } else if([function isEqualToString:@"get_array_value_context"]) {
                                            ////NSLog(@"getarray values values : %@", values);
                                            if(![setContext isKindOfClass:[PHPScriptObject class]]) {
                                                ////////////NSLog(@"setContext arrayvaluecontext is not scriptobject");
                                                setContext = [[weakSelf globalContext] parseInputVariable:setContext];
                                            }
                                            
                                            callFunctionResult = [(PHPScriptObject*)setContext getArrayValueContext:[weakSelf getMutableArrayValueNil:values index:0] returnReference:[weakSelf getMutableArrayValueNil:values index:1] context:lastCurrentFunctionContext];
                                            setCacheState = false;
                                            
                                            /*if(!containedAsync) {
                                             subParseObject[@"variableReferenceItemCallback"] = ^{
                                             return [(PHPScriptObject*)setContext getArrayValueContext:[weakSelf getMutableArrayValueNil:values index:0] returnReference:[weakSelf getMutableArrayValueNil:values index:1] context:lastCurrentFunctionContext];
                                             };
                                             [[lastCurrentFunctionContext resetableParseObjects] addObject:subParseObject];
                                             }*/
                                            /*if(!containedAsync) {
                                             [(PHPScriptFunction*)lastCurrentFunctionContextCache parseObjectCaches][subParseObjectIndex] = @{
                                             @"type": @"variableReferenceItemCallback",
                                             @"value": ^{
                                             return [(PHPScriptObject*)setContext getArrayValueContext:[weakSelf getMutableArrayValueNil:values index:0] returnReference:[weakSelf getMutableArrayValueNil:values index:1] context:lastCurrentFunctionContext];
                                             }
                                             };
                                             }*/
                                            //[lastCurrentFunctionContext addIfNotResetableParseObjects:subParseObject];
                                            //NSLog(@"get array value context : %@", callFunctionResult);
                                        } else if([function isEqualToString:@"get_array_value_context_reference"]) {
                                            if(![setContext isKindOfClass:[PHPScriptObject class]]) {
                                                ////////////NSLog(@"setContext arrayvaluecontext is not scriptobject");
                                                setContext = [[weakSelf globalContext] parseInputVariable:setContext];
                                            }
                                            callFunctionResult = [(PHPScriptObject*)setContext getArrayValueContextReference:[weakSelf getMutableArrayValueNil:values index:0] returnReference:[weakSelf getMutableArrayValueNil:values index:1]];
                                            
                                            /*if(!containedAsync) {
                                             subParseObject[@"variableReferenceItemObject"] = callFunctionResult; //veitekki
                                             [[lastCurrentFunctionContext resetableParseObjects] addObject:subParseObject];
                                             }*/
                                            /*[(PHPScriptFunction*)lastCurrentFunctionContextCache parseObjectCaches][subParseObjectIndex] = @{
                                             @"type": @"variableReferenceItemObject",
                                             @"value":callFunctionResult
                                             };*/
                                            
                                            //[lastCurrentFunctionContext parseObjectCaches][subParseObjectIndex][@"variableReferenceItemObject"] = callFunctionResult;
                                            //[lastCurrentFunctionContext addIfNotResetableParseObjects:subParseObject];
                                            
                                            //[(PHPScriptObject*)setContext addResetableParseObject:subParseObject];
                                        } else if([function isEqualToString:@"return_last_prop_result"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext returnLastPropResult:[weakSelf getMutableArrayValueNil:values index:0]];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"new_instance"]) {
                                            //NSLog(@"new instance : %@", setContext);
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                //callFunctionResult =
                                                [(PHPScriptFunction*)setContext _newInstance:[weakSelf getMutableArrayValueNil:values index:0] parameterValues:[weakSelf getMutableArrayValueNil:values index:1] callback:^(NSObject* callFunctionResultItem) {
                                                    //NSLog(@"new instance item : %@", callFunctionResultItem);
                                                    //test-b
                                                    //dispatch_async([weakSelf messagesQueue], ^{
                                                        @autoreleasepool {
                                                            ((void(^)(NSObject*))mainResultsCallback)(callFunctionResultItem);
                                                            /*
                                                            mainResultsCallback = nil;
                                                            //mainFunctionCallback = nil;
                                                            mainContinueCallback = nil;*/
                                                        }
                                                    //});
                                                    return;
                                                }];
                                                return;
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                //callFunctionResult =
                                                [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] _newInstance:[weakSelf getMutableArrayValueNil:values index:0] parameterValues:[weakSelf getMutableArrayValueNil:values index:1] callback:^(NSObject* callFunctionResultItem) {
                                                    
                                                    //NSLog(@"new instance item : %@", callFunctionResultItem);
                                                    //test-b
                                                    //dispatch_async([weakSelf messagesQueue], ^{
                                                        @autoreleasepool {
                                                            ((void(^)(NSObject*))mainResultsCallback)(callFunctionResultItem);
                                                            /*
                                                            mainResultsCallback = nil;
                                                            //mainFunctionCallback = nil;
                                                            mainContinueCallback = nil;*/
                                                        }
                                                    //});
                                                    return;
                                                }];
                                                return;
                                            }
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"call_script_function_sub"]) {
                                            ////////////NSLog(@"in call callScriptFunctionSub sub: %@ - %@", setContext, [weakSelf getMutableArrayValueNil:values index:0]);
                                            /*PHPScriptFunction* lastFuncCalled = nil;
                                             if([[weakSelf getMutableArrayValueNil:values index:0] isKindOfClass:[PHPScriptFunction class]]) {
                                             lastFuncCalled = (PHPScriptFunction*)[weakSelf getMutableArrayValueNil:values index:0];
                                             
                                             } else if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                             lastFuncCalled = (PHPScriptFunction*)setContext;
                                             
                                             
                                             }*/
                                            
                                            /*NSLog(@"call : %@ - %@ - %@ - %@ - %@", setContext, lastParentContext,
                                             lastSetValidContext,
                                             preserveContext,
                                             lastCurrentFunctionContext);
                                             
                                             NSLog(@"call : %@ - %@ - %@ - %@ - %@", [(PHPScriptFunction*)setContext identifier],  [(PHPScriptFunction*) lastParentContext identifier],
                                             [(PHPScriptFunction*) lastSetValidContext identifier],
                                             [(PHPScriptFunction*) preserveContext identifier],
                                             [(PHPScriptFunction*) lastCurrentFunctionContext identifier]);*/
                                            
                                            //callFunctionResult =
                                            [(PHPScriptObject*)setContext callScriptFunctionSub:[weakSelf getMutableArrayValueNil:values index:0] parameterValues:[weakSelf getMutableArrayValueNil:values index:1] awaited:[weakSelf getMutableArrayValueNil:values index:2] returnObject:[weakSelf getMutableArrayValueNil:values index:3] interpretation:preserveContext callback:^(NSObject* callFunctionResultItem) {
                                                
                                                //test-b
                                                //dispatch_async([weakSelf messagesQueue], ^{
                                                    @autoreleasepool {
                                                        ((void(^)(NSObject*))mainResultsCallback)(callFunctionResultItem);
                                                        /*
                                                        mainResultsCallback = nil;
                                                        //mainFunctionCallback = nil;
                                                        mainContinueCallback = nil;*/
                                                    }
                                                //});
                                                return;
                                            }];
                                            return;
                                            /*if([lastFuncCalled toUnset]) {
                                             NSLog(@"unset : value");
                                             [lastFuncCalled unset:nil];
                                             }*/
                                            //[lastFuncCalled setParentContext:nil];
                                            //[lastFuncCalled clear]
                                            //scriptFunctionFunction = [scriptFunctionFunction copyScriptFunction];
                                            //[weakSelf clearRunningToUnset];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"call_script_function_sub_reference"]) {
                                            ////////////NSLog(@"in call callScriptFunctionSubReference sub: %@ - %@", setContext, [weakSelf getMutableArrayValueNil:values index:0]);
                                            callFunctionResult = [(PHPScriptObject*)setContext callScriptFunctionSubReference:[weakSelf getMutableArrayValueNil:values index:0] parameterValues:[weakSelf getMutableArrayValueNil:values index:1] awaited:[weakSelf getMutableArrayValueNil:values index:2] returnObject:[weakSelf getMutableArrayValueNil:values index:3]];
                                            
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"call_script_function_reference"]) {
                                            ////////////NSLog(@"in call callScriptFunctionReference sub: %@ - %@", setContext, [weakSelf getMutableArrayValueNil:values index:0]);
                                            if([setContext isKindOfClass:[PHPScriptFunction class]]) {
                                                callFunctionResult = [(PHPScriptFunction*)setContext callScriptFunctionReference:[weakSelf getMutableArrayValueNil:values index:0] parameterValues:[weakSelf getMutableArrayValueNil:values index:1] awaited:[weakSelf getMutableArrayValueNil:values index:2]];
                                            } else if([setContext isKindOfClass:[PHPScriptObject class]])  {
                                                callFunctionResult = [(PHPScriptFunction*)[(PHPScriptObject*)setContext parentContext] callScriptFunctionReference:[weakSelf getMutableArrayValueNil:values index:0] parameterValues:[weakSelf getMutableArrayValueNil:values index:1] awaited:[weakSelf getMutableArrayValueNil:values index:2]];
                                            }
                                            
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"call_script_function"]) {
                                            ////////////NSLog(@"in call callScriptFunction sub: %@ - %@", setContext, [weakSelf getMutableArrayValueNil:values index:0]);
                                            
                                            callFunctionResult = [(PHPScriptObject*)setContext callScriptFunction:[weakSelf getMutableArrayValueNil:values index:0] parameterValues:[weakSelf getMutableArrayValueNil:values index:1] awaited:[weakSelf getMutableArrayValueNil:values index:2]];
                                            
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"get_array_value"]) {
                                            if(![setContext isKindOfClass:[PHPScriptObject class]]) {
                                                ////////////NSLog(@"setContext arrayvaluecontext is not scriptobject");
                                                setContext = [[weakSelf globalContext] parseInputVariable:setContext];
                                            }
                                            ////NSLog(@"getarray values values : %@", values);
                                            callFunctionResult = [(PHPScriptObject*)setContext getArrayValue:[weakSelf getMutableArrayValueNil:values index:0] index:[weakSelf getMutableArrayValueNil:values index:1]];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"script_array_push"]) {
                                            [(PHPScriptObject*)setContext scriptArrayPush:[weakSelf getMutableArrayValueNil:values index:0]];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"delete_property_reference"]) {
                                            [(PHPScriptObject*)setContext deletePropertyReference:[weakSelf getMutableArrayValueNil:values index:0]];
                                            setCacheState = false;
                                        } else if([function isEqualToString:@"clone_object"]) {
                                            callFunctionResult = [(PHPScriptObject*)setContext cloneObject:[weakSelf getMutableArrayValueNil:values index:0]];
                                            setCacheState = false;
                                        }
                                    }
                                    
                                    /*if([setContext isKindOfClass:[PHPScriptObject class]]) {
                                     PHPScriptFunction* toClear = setContext;
                                     if(![toClear isKindOfClass:[PHPScriptFunction class]]) {
                                     toClear = [toClear parentContext];
                                     if(toClear != nil) {
                                     NSLog(@"to clear : %@", toClear);
                                     [toClear clearRunningToUnset];
                                     }
                                     }
                                     }*/
                                    //}
                                }
                                /*if(subParseObject[@"containsIdentifier"] == nil && subParseObject[@"contains_ValueDereference"] == nil && subParseObject[@"contains_FunctionCall"] == nil && callFunctionResult != nil) {
                                 NSObject* intermediateResultValue = [weakSelf toSubParseCache:callFunctionResult];
                                 if(intermediateResultValue != nil) {
                                 //lastCurrentFunctionContext
                                 subParseObject[@"intermediateResultValue"] = intermediateResultValue;
                                 //////NSLog(@"setIntermediatevalue : %@", callFunctionResult);
                                 }
                                 }*/
                                if(createdControl && control != NULL) {
                                    //NSObject* controlResult =
                                    //bool __block stopControl = false;
                                    [control run:(PHPScriptFunction*)context lastValidCondition:lastSetValidContext callback:^(NSObject* controlResult) {
                                        
                                        if(([controlResult isKindOfClass:[NSNumber class]] && [(NSNumber*)controlResult boolValue] != false) || [controlResult isKindOfClass:[PHPReturnResult class]]) {
                                            
                                            //test-a
                                            
                                            [[self queue] addOperationWithBlock:^{
                                                //dispatch_async([weakSelf messagesQueue], ^{
                                                @autoreleasepool {
                                                    ((void(^)(NSObject*))callback)(controlResult);
                                                    
                                                    /*
                                                     mainResultsCallback = nil;
                                                     mainFunctionCallback = nil;
                                                     mainContinueCallback = nil;
                                                     callback = nil;*/
                                                }
                                                //});
                                            }];
                                            //stopControl = true;
                                            return;
                                            //return controlResult;
                                        } else {
                                            
                                            //test-b
                                            //dispatch_async([weakSelf messagesQueue], ^{
                                                @autoreleasepool {
                                                    ((void(^)(NSObject*))mainResultsCallback)(callFunctionResult);
                                                    /*
                                                    mainResultsCallback = nil;
                                                    mainFunctionCallback = nil;
                                                    mainContinueCallback = nil;*/
                                                }
                                            //});
                                            return;
                                        }
                                    }];
                                    return;
                                    /*if(stopControl) {
                                     return;
                                     }*/
                                }
                            }
                        }
                        if(postFunction != NULL) {
                            
                            if([postFunction isEqualToString:@"reverse_array"]) {
                                
                                [context reverseArray];
                            }
                        }
                        //mainResultsCallback
                        if(callFunctionResult != nil) {
                            //test-b
                            //dispatch_async([weakSelf messagesQueue], ^{
                                @autoreleasepool {
                                    ((void(^)(NSObject*))mainResultsCallback)(callFunctionResult);
                                    /*
                                    mainResultsCallback = nil;
                                    mainFunctionCallback = nil;
                                    mainContinueCallback = nil;*/
                                }
                            //});
                            return;
                        }
                        
                        //test-a
                        
                        [[self queue] addOperationWithBlock:^{
                            //dispatch_async([weakSelf messagesQueue], ^{
                            @autoreleasepool {
                                ((void(^)(NSObject*))callback)(nil);
                                /*
                                 mainResultsCallback = nil;
                                 mainFunctionCallback = nil;
                                 mainContinueCallback = nil;
                                 callback = nil;*/
                            }
                            //});
                        }];
                        return;
                        /*if([context isKindOfClass:[PHPScriptFunction class]]) {
                         [(PHPScriptFunction*)context clearRunningToUnset];
                         }*/
                        /*if([context parentContext] != nil) {
                         if([[context parentContext] isKindOfClass:[PHPScriptFunction class]]) {
                         [(PHPScriptFunction*)[context parentContext] clearRunningToUnset];
                         }
                         }*/
                        //////NSLog(@"callFunction is: %@ %@", function, callFunctionResult);
                        
                    }
                    //((void(^)(NSObject*))callback)(nil);
                    //return;
                };
                //mainFunctionCallback = mainFunctionCallbackSet;
                //NSObject* __block returnValueResultStopExecution = nil;
                if([[weakSelf definition][subParseObject[@"label"]][@"variables"] count] == 0 || ([values count] == 0 && [weakSelf definition][subParseObject[@"label"]][@"exception"])) {
                    
                    //dispatch_async([weakSelf messagesQueue], ^{
                    //for(NSObject* subObject in subParseObject[@"sub_parse_objects"]) {
                    //id /*__block*/ variableIterationCallbackSet;
                    id variableIterationCallbackOuter;
                    //variableIterationCallbackSet = variableIterationCallbackWeak
                    variableIterationCallbackOuter = ^(long indexIterationVariable, NSObject* returnValueResultStopExecution, id variableIterationCallback) {
                        //id variableIterationCallback = variableIterationCallbackWeak;
                        NSObject* subObject = subParseObject[@"sub_parse_objects"][indexIterationVariable];
                        //////////NSLog(@"in callback 7");
                        //////////NSLog(@"in1 %@ - %@", subParseObject[@"label"], ((NSMutableDictionary*)subObject)[@"label"]);
                        bool storeVariable = false;
                        //bool storeVariable = true;
                        //NSLog(@"contains identifier : %@", ((NSMutableDictionary*)subObject)[@"containsIdentifier"]);
                        if(((NSMutableDictionary*)subObject)[@"containsIdentifier"] == nil) {
                            storeVariable = true;
                        }
                        if(returnValueResultStopExecution == nil) {
                            NSObject* /*__block*/ subValueResultItem;
                            if(((NSMutableDictionary*)subObject)[@"variableValueAlt"] != nil) {
                                subValueResultItem = ((NSMutableDictionary*)subObject)[@"variableValueAlt"];
                                //NSLog(@"from store: %@", subValueResultItem);
                            } else {
                                //////////NSLog(@"1context is: %@ - %@", context, @(threadCount));
                                //subValueResultItem =
                                //NSLog(@"call set: --");
                                //bool __block hasBeenSet = false;
                                //test-b
                                //dispatch_async([weakSelf messagesQueue], ^{
                                    
                                    long indexIterationVariableValue = indexIterationVariable + 1;
                                    [weakSelf execute:subObject context:context lastParentContextParseLabel:lastParentContextParseLabel lastParentContext:lastParentContext control:control subSwitches:nil lastSetValidContext:lastSetValidContext preventSetValidContext:preventSetValidContext preserveContext:preserveContext inParentContextSetting:inParentContextSetting lastCurrentFunctionContext:lastCurrentFunctionContext containedAsync:containedAsync callback:^(NSObject* intermediateRes) {
                                        //@synchronized (subObject) {
                                        
                                        NSObject* subValueResultItem = intermediateRes;
                                        //hasBeenSet = true;
                                        //NSLog(@"call set: ++");
                                        NSObject* returnValueResultStopExecution = nil;
                                        if(storeVariable) {
                                            ////////////NSLog(@"store: %@", subValueResultItem);
                                            ((NSMutableDictionary*)subObject)[@"variableValueAlt"] = subValueResultItem;
                                        }
                                        
                                        if([subValueResultItem isKindOfClass:[PHPReturnResult class]]) {
                                            returnValueResultStopExecution = subValueResultItem;
                                            //return subValueResultItem;
                                        } else {
                                            
                                            if(subValueResultItem != nil) {
                                                
                                                [values addObject:subValueResultItem];
                                            }
                                        }
                                        if(indexIterationVariableValue == [subParseObject[@"sub_parse_objects"] count]) {
                                            if(returnValueResultStopExecution == nil) {
                                                NSMutableArray* values_store1 = values;
                                                values = [[NSMutableArray alloc] init];
                                                
                                                [values addObject:values_store1];
                                            }
                                            //});
                                            if(returnValueResultStopExecution != nil) {
                                                
                                                //test-a
                                                //dispatch_async([weakSelf messagesQueue], ^{
                                                
                                                [[self queue] addOperationWithBlock:^{
                                                    @autoreleasepool {
                                                        ((void(^)(NSObject*))callback)(returnValueResultStopExecution);
                                                        /*callback = nil;*/
                                                    }
                                                }];
                                                //});
                                                return;
                                                //return returnValueResultStopExecution;
                                            }
                                            //test-b
                                            //dispatch_async([weakSelf messagesQueue], ^{
                                                @autoreleasepool {
                                                    ((void(^)(NSMutableArray*))mainFunctionCallback)(nil);/*
                                                    variableIterationCallback = nil;
                                                    mainFunctionCallback = nil;
                                                    mainContinueCallback = nil;*/
                                                }
                                            //});
                                            return;
                                        } else {
                                            //test-b
                                            //dispatch_async([weakSelf messagesQueue], ^{
                                                @autoreleasepool {
                                                    ((void(^)(long, NSObject*, id))variableIterationCallback)(indexIterationVariableValue, returnValueResultStopExecution, variableIterationCallback);
                                                }
                                            //});
                                            return;
                                        }
                                        //}
                                    } //lastFunctionContextValue:lastFunctionContextValue
                                    ];
                                //});
                                return;
                                
                                //if(subParseObject[@"is_constructor_node"] != nil) {
                                //if(!hasBeenSet) {
                                //if(indexIterationVariable == 0 && [subParseObject[@"label"] isEqualToString:@"Statement"] && [[(PHPScriptFunction*)[context parentContext] debugText] rangeOfString:@"function __construct()"].location == 0) {
                                /*NSLog(@"label : %@ - %@ - %@", ((NSDictionary*)subObject)[@"label"], ((NSDictionary*)subObject)[@"is_constructor_node"], [(PHPScriptFunction*)[context parentContext] debugText]);
                                 NSString* debugText = [weakSelf getText:[(NSNumber*)subParseObject[@"start_index"] intValue] stop:[(NSNumber*)subParseObject[@"stop_index"] intValue] isString:true parseObject:subParseObject];
                                 NSLog(@"debugText : %@", debugText);*/
                                /*} else {
                                 NSLog(@"has not been set but: %@ %@", subParseObject[@"label"], [(PHPScriptFunction*)[context parentContext] debugText]);
                                 }*/
                                /*} else {
                                 
                                 }*/
                                //return;
                                //NSLog(@"subvalueResultItem : %@", subValueResultItem);
                                //if([subValueResultItem isKindOfClass:[PHPScriptObject class]] && subValueResultItem != )
                                if(storeVariable) {
                                    ////////////NSLog(@"store: %@", subValueResultItem);
                                    ((NSMutableDictionary*)subObject)[@"variableValueAlt"] = subValueResultItem;
                                }
                            }
                            if([subValueResultItem isKindOfClass:[PHPReturnResult class]]) {
                                returnValueResultStopExecution = subValueResultItem;
                                //return subValueResultItem;
                            } else {
                                
                                if(subValueResultItem != nil) {
                                    
                                    [values addObject:subValueResultItem];
                                }
                            }
                            //////////NSLog(@"SubvalueResultItem %@ %@ %@", subParseObject[@"label"], subValueResultItem, ((NSMutableDictionary*)subObject)[@"label"]);
                        }
                        indexIterationVariable = indexIterationVariable+1;
                        if(indexIterationVariable == [subParseObject[@"sub_parse_objects"] count]) {
                            if(returnValueResultStopExecution == nil) {
                                NSMutableArray* values_store1 = values;
                                values = [[NSMutableArray alloc] init];
                                
                                [values addObject:values_store1];
                            }
                            //});
                            if(returnValueResultStopExecution != nil) {
                                
                                //test-a
                                [[self queue] addOperationWithBlock:^{
                                    //dispatch_async([weakSelf messagesQueue], ^{
                                    @autoreleasepool {
                                        ((void(^)(NSObject*))callback)(returnValueResultStopExecution);
                                        /*variableIterationCallback = nil;
                                         mainFunctionCallback = nil;
                                         mainContinueCallback = nil;*/
                                    }
                                    //});
                                }];
                                return;
                                //return returnValueResultStopExecution;
                            }
                            //test-b
                            //dispatch_async([weakSelf messagesQueue], ^{
                                @autoreleasepool {
                                    ((void(^)(NSMutableArray*))mainFunctionCallback)(nil);
                                    /*variableIterationCallback = nil;
                                    mainFunctionCallback = nil;*/
                                }
                            //});
                            return;
                        } else {
                            
                            //test-b
                            //dispatch_async([weakSelf messagesQueue], ^{
                                @autoreleasepool {
                                    ((void(^)(long, NSObject*, id))variableIterationCallback)(indexIterationVariable, returnValueResultStopExecution, variableIterationCallback);
                                }
                            //});
                            return;
                        }
                    };
                    //variableIterationCallback = variableIterationCallbackSet;
                    //test-b
                    //dispatch_async([weakSelf messagesQueue], ^{
                        @autoreleasepool {
                            ((void(^)(long, NSObject*, id))variableIterationCallbackOuter)(0, nil, variableIterationCallbackOuter);
                        }
                    //});
                    return;
                    
                    
                }
                //((void(^)(NSObject*))callback)(nil);
                //test-b
                //dispatch_async([weakSelf messagesQueue], ^{
                    @autoreleasepool {
                        ((void(^)(NSMutableArray*))mainFunctionCallback)(nil);
                        //mainFunctionCallback = nil;
                    }
                //});
                return;
            };
            
            
            //mainContinueCallback = mainContinueCallbackSet;
            
            id mainIterationReferenceCallbackOuter;
            //id mainIterationReferenceCallback;
            //id __weak __block mainIterationReferenceCallbackWeak;
            //mainIterationReferenceCallbackWeak =
            mainIterationReferenceCallbackOuter = ^(long mainIterationSetIndex, NSString* lastParentContextParseLabel, PHPScriptObject* context, PHPScriptObject* lastParentContext, id mainIterationReferenceCallback) {
                //id /*__block*/ mainIterationReferenceCallback = mainIterationReferenceCallbackWeak;
                NSMutableDictionary* variableReference = subParseObject[@"variable_references"][mainIterationSetIndex];
                long offset = 0;
                if(variableReference[@"offset"] != nil) {
                    offset = [(NSNumber*)variableReference[@"offset"] longValue];
                }
                if(variableReference[@"sub_context"] != nil || (setSubContextSub && variableReference[@"opt"] != nil)) {
                    NSObject* subObject;
                    //NSValue* myKey = [NSValue valueWithNonretainedObject:variableReference];
                    /*if(subParseObject[@"sub_parse_object_variables"][variableReference] != nil) {
                     subObject = subParseObject[@"sub_parse_object_variables"][variableReference];
                     } else {*/
                    subObject = variableReference[@"subParseObject"];//[weakSelf getSubParseObject:subParseObject nt:variableReference[@"non_terminal"] offset:offset];
                    /*subParseObject[@"sub_parse_object_variables"][variableReference] = subObject;
                     }*/
                    if(subObject != NULL) {
                        PHPScriptEvaluationReference* scriptReference;
                        NSMutableDictionary* /*__block*/ subObjectDict = (NSMutableDictionary*)subObject;
                        if(subObjectDict[@"scriptReference"] == nil) {
                            //NSLog(@"create script reference : %@", subObjectDict[@"label"]);
                            //NSMutableDictionary* __block variableReferenceBlock = variableReference;
                            scriptReference = [[PHPScriptEvaluationReference alloc] init];
                            [scriptReference setInterpretation:weakSelf];
                            [scriptReference setContextValue:context];
                            [scriptReference setSubObjectDict:subObject];
                            [scriptReference setLastCurrentFunctionContext:lastCurrentFunctionContext];
                            [scriptReference setLastSetValidContext:lastSetValidContext];
                            [scriptReference setPreventSetValidContext:preventSetValidContext];
                            [scriptReference setPreserveContext:preserveContext];
                            [scriptReference setInParentContextSetting:inParentContextSetting];
                            [scriptReference setIsAsync:containedAsync];
                            //[scriptReference setLastFunctionContextValue:lastFunctionContextValue];
                            //
                            /*if(!containedAsync) {
                             subObjectDict[@"scriptReference"] = scriptReference;
                             }*/
                            ////////////NSLog(@"created script reference");
                            //PHPInterpretation* __block selfBlock = self;
                            //PHPScriptObject* __block  contextBlock = context;
                            /*[scriptReference construct:0 subRoutine:^(PHPScriptFunction* callContext) {
                             PHPScriptObject* contextCopy = context;
                             
                             //if([callContext isKindOfClass:[NSNumber class]]) {
                             if([callContext isKindOfClass:[NSNumber class]] && [(NSNumber*)callContext isEqualToNumber:@0]) {
                             ////////////NSLog(@"CALL CONTEXT IS NUMBER %@", callContext);
                             //callContext = [weakSelf lastSetFunctionCallingContext];
                             }
                             if(callContext != NULL && callContext != nil && !([callContext isKindOfClass:[NSString class]] && [(NSString*) callContext isEqualToString:@"undefined"])) {
                             //[subObjectDict removeObjectForKey:@"scriptReference"];
                             contextCopy = callContext;
                             
                             } else if(variableReferenceBlock[@"sub_context"] != nil && [(NSNumber*)variableReferenceBlock[@"sub_context"] boolValue]) {
                             
                             
                             }
                             
                             if([contextCopy isKindOfClass:[PHPScriptFunction class]]) {
                             
                             } else {
                             
                             }
                             
                             //NSMutableDictionary* valueSubSwitches = nil;//subSwitches;
                             
                             PHPInterpretation* interpretationInstance = self;
                             
                             
                             NSObject* variableValue = [interpretationInstance execute:subObjectDict context:contextCopy lastParentContextParseLabel:nil lastParentContext:nil control:nil subSwitches:nil lastSetValidContext:lastSetValidContext preventSetValidContext:preventSetValidContext preserveContext:preserveContext inParentContextSetting:inParentContextSetting lastCurrentFunctionContext:lastCurrentFunctionContext];
                             
                             return variableValue;
                             }];*/
                            
                        } else {
                            scriptReference = subObjectDict[@"scriptReference"];
                            [scriptReference setContextValue:context];
                            //[scriptReference setSubObjectDict:subObject];
                            [scriptReference setLastCurrentFunctionContext:lastCurrentFunctionContext];
                            [scriptReference setLastSetValidContext:lastSetValidContext];
                        }
                        if(variableReference[@"sub_context"] != nil) {
                            
                            [values addObject:scriptReference];
                        } else {
                            
                            [subContextCallback addObject:scriptReference];
                        }
                    }
                } else {
                    //dispatch_async([weakSelf messagesQueue], ^{
                    NSObject* /*__block*/ variableValue = NULL;
                    bool setValueCallback = false;
                    if(variableReference[@"parse"] != nil) {
                        
                    }
                    if(variableReference[@"variableValue"] != nil) { //subParseObject[@"variableValue"]
                        variableValue = variableReference[@"variableValue"];
                    } else if(variableReference[@"parse"] != nil && [(NSNumber*)variableReference[@"parse"] boolValue]) {
                        NSObject* subObject;
                        //NSValue* myKey = [NSValue valueWithNonretainedObject:variableReference];
                        /*if(subParseObject[@"sub_parse_object_variables"][variableReference] != nil) {
                         subObject = subParseObject[@"sub_parse_object_variables"][variableReference];
                         } else {*/
                        subObject = variableReference[@"subParseObject"];//[weakSelf getSubParseObject:subParseObject nt:variableReference[@"non_terminal"] offset:offset];
                        /*subParseObject[@"sub_parse_object_variables"][variableReference] = subObject;
                         }*/
                        if(subObject != NULL) {
                            
                            //////////NSLog(@"2context is: %@ - %@", context, @(threadCount));
                            //variableValue =
                            //bool __block callbackReturnsResults = false;
                            //test-b
                            //dispatch_async([weakSelf messagesQueue], ^{
                                @autoreleasepool {
                                    [weakSelf execute:subObject context:context lastParentContextParseLabel:lastParentContextParseLabel lastParentContext:lastParentContext control:control subSwitches:nil lastSetValidContext:lastSetValidContext preventSetValidContext:preventSetValidContext preserveContext:preserveContext inParentContextSetting:inParentContextSetting lastCurrentFunctionContext:lastCurrentFunctionContext containedAsync:containedAsync
                                             callback:^(NSObject* variableValueInner) {
                                        //variableValue = variableValueInner;
                                        //callbackReturnsResults = true;
                                        NSObject* variableValue = variableValueInner;
                                        NSString* lastParentContextParseLabelValue = lastParentContextParseLabel;
                                        PHPScriptObject* lastParentContextValue = lastParentContext;
                                        PHPScriptObject* contextValue = context;
                                        bool setValueCallback = false;
                                        if(((NSMutableDictionary*)subObject)[@"containsIdentifier"] != nil) {
                                            setValueCallback = true;
                                        }
                                        //variableValue = intermediateRes;
                                        //NSLog(@"varaibleValue : %@ - %@ - %@ - %@ - %@", variableValue, variableReference[@"set_context"], variableReference[@"offset"], @([subParseObject[@"variable_references"] count]), @([subParseObject[@"variable_references"] indexOfObject:variableReference]));
                                        //variableReference in subParseObject[@"variable_references"])
                                        if(variableValue != NULL && variableValue != nil) {
                                            
                                            if(variableReference[@"set_context"] != nil && ([(NSNumber*)variableReference[@"set_context"] boolValue]
                                                                                            //||
                                                                                            //[weakSelf arrayHas:[[NSMutableArray alloc] initWithArray:[switchesSet allValues]] string:variableReference[@"set_context"]] != -1
                                                                                            //[[switchesSet allValues] indexOfObject:variableReference[@"set_context"]] != NSNotFound
                                                                                            ) && !([variableValue isKindOfClass:[PHPVariableReference class]] && [(PHPVariableReference*)variableValue ignoreSetContext])) {
                                                //NSObject* variableValueReference = variableValue;
                                                if([variableValue isKindOfClass:[PHPVariableReference class]]) {
                                                    variableValue = [(PHPVariableReference*)variableValue get:nil];
                                                }
                                                if(lastParentContext == NULL || lastParentContext == nil) {
                                                    
                                                    lastParentContextValue = context;
                                                    lastParentContextParseLabelValue = @"Value";
                                                }
                                                if(variableValue != NULL && ([variableValue isKindOfClass:[PHPScriptObject class]] || [variableValue isKindOfClass:[PHPScriptFunction class]])) {
                                                    
                                                    if([variableValue isKindOfClass:[PHPScriptObject class]]) {
                                                        
                                                        [(PHPScriptObject*)variableValue setInterpretationForObject:self];
                                                        
                                                    }
                                                    PHPScriptObject* scriptObjectVariablevalue = (PHPScriptObject*)variableValue;
                                                    //@synchronized (context) {
                                                    //////NSLog(@"reset functionContext: %@", [scriptObjectVariablevalue currentFunctionContext]);
                                                    contextValue = scriptObjectVariablevalue;
                                                    //}
                                                    //context = (PHPScriptObject*)variableValue;
                                                    //////////NSLog(@"setContext: %@ - %@", context, @(threadCount));
                                                }
                                            }
                                            
                                            if(variableValue != NULL && variableValue != nil) {
                                                
                                                [values addObject:variableValue];
                                                if(setValueCallback) {
                                                    
                                                } else {
                                                    @synchronized (subParseObject) {
                                                        
                                                    subParseObject[@"variableValue"] = variableValue;
                                                    }
                                                }
                                            }
                                        }
                                        long setMainIterationSetIndex = mainIterationSetIndex + 1;
                                        if(setMainIterationSetIndex < [subParseObject[@"variable_references"] count]) {
                                            //test-b
                                            //dispatch_async([weakSelf messagesQueue], ^{
                                                ((void(^)(long, NSString*, PHPScriptObject*, PHPScriptObject*, id))mainIterationReferenceCallback)(setMainIterationSetIndex, lastParentContextParseLabelValue, contextValue, lastParentContextValue, mainIterationReferenceCallback);
                                            //});
                                            return;
                                        } else {
                                            //NSLog(@"main continue callback");
                                            //test-b
                                            //dispatch_async([weakSelf messagesQueue], ^{
                                                ((void(^)(NSString*, PHPScriptObject*, PHPScriptObject*))mainContinueCallback)(lastParentContextParseLabelValue, contextValue, lastParentContextValue);
                                                //mainContinueCallback = nil;
                                                //mainIterationReferenceCallback = nil;
                                            //});
                                            return;
                                            //continueCallback;
                                        }
                                    }//lastFunctionContextValue:lastFunctionContextValue
                                    ];
                                }
                            //});
                            /*if(!callbackReturnsResults) {
                             NSLog(@"NO RESULT");
                             NSLog(@"varaibleValue : %@ - %@ - %@ - %@ - %@ - %@", variableValue, variableReference[@"set_context"], variableReference[@"offset"], @([subParseObject[@"variable_references"] count]), @([subParseObject[@"variable_references"] indexOfObject:variableReference]), ((NSDictionary*)subObject)[@"label"]);
                             NSString* debugText = [weakSelf getText:[(NSNumber*)subParseObject[@"start_index"] intValue] stop:[(NSNumber*)subParseObject[@"stop_index"] intValue] isString:true parseObject:subParseObject];
                             NSLog(@"debugText : %@", debugText);
                             //variableReference in subParseObject[@"variable_references"])
                             } else {
                             //return;
                             }*/
                            return;
                            //if(containedAsync) {
                            if(((NSMutableDictionary*)subObject)[@"containsIdentifier"] != nil) {
                                setValueCallback = true;
                            }
                            //}
                        }
                    } else if(variableReference[@"non_terminal"] != nil) {
                        /*if([weakSelf isCopy]) {
                         [weakSelf setDebugCounter:[weakSelf debugCounter]+1];
                         //////////////NSLog(@"debugCounter: %lu", [weakSelf debugCounter]);
                         
                         }
                         if([weakSelf debugCounter] == 32285) {
                         //////////////NSLog(@"subParseObject %@", subParseObject);
                         }*/
                        //variableValue = [weakSelf getValue:subParseObject name:variableReference[@"non_terminal"] offset:offset];
                        /*bool isString = false;
                         NSMutableDictionary* parseObject = variableReference[@"subParseObject"];
                         NSString* name = parseObject[@"label"];
                         if([name isEqualToString:@"StringContent"] || [name isEqualToString:@"Identifier"] || [name isEqualToString:@"AccessFlag"] || [name isEqualToString:@"ObjectDefinition"]) {
                         isString = true;
                         }
                         variableValue = [weakSelf getText:[(NSNumber*)parseObject[@"start_index"] intValue] stop:[(NSNumber*)parseObject[@"stop_index"] intValue] isString:isString parseObject:parseObject];*/
                        variableValue = variableReference[@"subParseObject"][@"text_value"];
                    } else {
                        variableValue = variableReference[@"value"];
                    }
                    if(variableValue != NULL && variableValue != nil) {
                        
                        if(variableReference[@"set_context"] != nil && ([(NSNumber*)variableReference[@"set_context"] boolValue]
                                                                        //||
                                                                        //[weakSelf arrayHas:[[NSMutableArray alloc] initWithArray:[switchesSet allValues]] string:variableReference[@"set_context"]] != -1
                                                                        //[[switchesSet allValues] indexOfObject:variableReference[@"set_context"]] != NSNotFound
                                                                        ) && !([variableValue isKindOfClass:[PHPVariableReference class]] && [(PHPVariableReference*)variableValue ignoreSetContext])) {
                            NSObject* variableValueReference = variableValue;
                            if([variableValue isKindOfClass:[PHPVariableReference class]]) {
                                variableValue = [(PHPVariableReference*)variableValue get:nil];
                            }
                            if(lastParentContext == NULL || lastParentContext == nil) {
                                
                                lastParentContext = context;
                                lastParentContextParseLabel = @"Value";
                            }
                            if(variableValue != NULL && ([variableValue isKindOfClass:[PHPScriptObject class]] || [variableValue isKindOfClass:[PHPScriptFunction class]])) {
                                
                                if([variableValue isKindOfClass:[PHPScriptObject class]]) {
                                    
                                    [(PHPScriptObject*)variableValue setInterpretationForObject:self];
                                    
                                }
                                PHPScriptObject* scriptObjectVariablevalue = (PHPScriptObject*)variableValue;
                                //@synchronized (context) {
                                /*@synchronized (scriptObjectVariablevalue) {//(context) {
                                 //ToJSON* toJSONTemp = [[ToJSON alloc] init];
                                 //////NSLog(@"scriptobjectvariable : %@ - %@", [toJSONTemp toJSON:scriptObjectVariablevalue], context);
                                 if(![context isKindOfClass:[PHPScriptFunction class]]) {
                                 [scriptObjectVariablevalue setCurrentFunctionContext:[context currentObjectFunctionContext]];
                                 } else {
                                 [scriptObjectVariablevalue setCurrentFunctionContext:context];
                                 }*/
                                //////NSLog(@"reset functionContext: %@", [scriptObjectVariablevalue currentFunctionContext]);
                                context = scriptObjectVariablevalue;
                                //}
                                //context = (PHPScriptObject*)variableValue;
                                //////////NSLog(@"setContext: %@ - %@", context, @(threadCount));
                            }
                        }
                        
                        if(variableValue != NULL && variableValue != nil) {
                            
                            [values addObject:variableValue];
                            if(setValueCallback) {
                                
                            } else {
                                @synchronized (subParseObject) {
                                    
                                subParseObject[@"variableValue"] = variableValue;
                                }
                            }
                        }
                    }
                    //});
                }
                mainIterationSetIndex++;
                if(mainIterationSetIndex < [subParseObject[@"variable_references"] count]) {
                    //test-b
                    //dispatch_async([weakSelf messagesQueue], ^{
                        @autoreleasepool {
                            ((void(^)(long, NSString*, PHPScriptObject*, PHPScriptObject*, id))mainIterationReferenceCallback)(mainIterationSetIndex, lastParentContextParseLabel, context, lastParentContext, mainIterationReferenceCallback);
                        }
                    //});
                    return;
                } else {
                    //NSLog(@"main continue callback");
                    //test-b
                    //dispatch_async([weakSelf messagesQueue], ^{
                        @autoreleasepool {
                            ((void(^)(NSString*, PHPScriptObject*, PHPScriptObject*))mainContinueCallback)(lastParentContextParseLabel, context, lastParentContext);
                            /*mainIterationReferenceCallback = nil;
                            mainContinueCallback = nil;*/
                        }
                    //});
                    return;
                    //continueCallback;
                }
                
            };
            //mainIterationReferenceCallback = mainIterationReferenceCallbackSet;
            
            if([subParseObject[@"variable_references"] count] > 0) {
                //test-b
                //dispatch_async([weakSelf messagesQueue], ^{
                    @autoreleasepool {
                        ((void(^)(long, NSString*, PHPScriptObject*, PHPScriptObject*, id))mainIterationReferenceCallbackOuter)(0, lastParentContextParseLabel, context, lastParentContext, mainIterationReferenceCallbackOuter);
                    }
                //});
                return;
            } else {
                //NSLog(@"main continue callback");
                //test-b
                //dispatch_async([weakSelf messagesQueue], ^{
                    @autoreleasepool {
                        ((void(^)(NSString*, PHPScriptObject*, PHPScriptObject*))mainContinueCallback)(lastParentContextParseLabel, context, lastParentContext);
                        //mainContinueCallback = nil;
                    }
                //});
                return;
                //continueCallback;
            }
            //};
            
            
            //((void(^)(NSString*, PHPScriptObject*, PHPScriptObject*))mainContinueCallback)(lastParentContextParseLabel, context, lastParentContext);
            //((void(^)(void))mainFunctionCallback)();
            return;
            //////////NSLog(@"continueExecution function is: %@ - %@", function, values);
            //mainFunctionCallback
            //////////NSLog(@"no callfunction result CallbackIS: %@ - %@ - %@", nil, subParseObject[@"label"], values);
        } else if([subParseObject[@"sub_parse_objects"] count] == 1) {
            //return
            //(NSObject*(^)(PHPScriptFunction *))
            //((void(^)(NSObject*))callback)(
            //test-b
            //dispatch_async([weakSelf messagesQueue], ^{
                
                @autoreleasepool {
                    [weakSelf execute:subParseObject[@"sub_parse_objects"][0] context:context lastParentContextParseLabel:lastParentContextParseLabel lastParentContext:lastParentContext control:control subSwitches:nil lastSetValidContext:lastSetValidContext preventSetValidContext:preventSetValidContext preserveContext:preserveContext inParentContextSetting:inParentContextSetting lastCurrentFunctionContext:lastCurrentFunctionContext containedAsync:containedAsync callback:callback //lastFunctionContextValue:lastFunctionContextValue
                    ];
                }
            //});
            return;
            //);
            /*NSObject* debugItem = [weakSelf execute:subParseObject[@"sub_parse_objects"][0] context:context lastParentContextParseLabel:lastParentContextParseLabel lastParentContext:lastParentContext control:control subSwitches:nil lastSetValidContext:lastSetValidContext preventSetValidContext:preventSetValidContext preserveContext:preserveContext inParentContextSetting:inParentContextSetting lastCurrentFunctionContext:lastCurrentFunctionContext containedAsync:containedAsync //lastFunctionContextValue:lastFunctionContextValue
             ];
             NSLog(@"debugItem : %@", debugItem);
             return debugItem;*/
        }
        
        //}
        /*}*/
        
        [[self queue] addOperationWithBlock:^{
            //test-a
            //dispatch_async([weakSelf messagesQueue], ^{
            @autoreleasepool {
                ((void(^)(NSObject*))callback)(nil);
                //callback = nil;
                //[callback autorel]
            }
        }];
        //});
        return;
    }//return nil;
}

- (NSObject*) getMutableArrayValueNil: (NSMutableArray*) arr index: (int) index {
    if([arr count] > index) {
        return arr[index];
    }
    return nil;
}
- (NSObject*) getArrayValueNil: (NSArray*) arr index: (int) index {
    if([arr count] > index) {
        return arr[index];
    }
    return nil;
}

- (long) arrayHas: (NSMutableArray*) array string: (NSString*) string {
    long index = 0;
    long index_result = -1;
    NSUInteger index2 = [array indexOfObject:string];//0;
    ////////////NSLog(@"arrayHas: %@ - %@", array, string);
    for(NSObject* item in array) {
        if([item isKindOfClass:[NSString class]]) {
            if([(NSString*)item isEqualToString:string]) {
                index_result = index;
                //return index;
            }
        }
        index++;
    }
    
    /*if(index2 == NSNotFound) {
        index2 = -1;
    }*/
    //////////NSLog(@"index1: %@ index2: %@ - arr: %@ item: %@", @(index_result), @(index2), array, string);
        
    return index_result;
    
    /*if(index2 == NSNotFound) {
        return -1;
    }
    return [@(index2) longLongValue];*/
}

//- (NSMutableDictionary*) getSubParseObjectAlt: (NSMutableDictionary*) parseObject nt: (NSObject*)

- (NSMutableDictionary*) getSubParseObject: (NSMutableDictionary*) parseObjects nt: (NSObject*) name offset: (long) offset {
    long setOffset = -1;
    /*if(parseObjects[@"set_sub_parse_variables"] != nil) {
        
    }*/
    if(parseObjects[@"sub_parse_objects_dict"] != nil) {
        ////////////NSLog(@"parse object: %@", [parseObjects[@"sub_parse_objects_dict"] allKeys]);
        //if([name isKindOfClass:[NSArray class]]) {
        if([name isKindOfClass:[NSArray class]]) {
            NSArray* nt = (NSArray*)name;
            for(NSString* ntValue in nt) {
                if(parseObjects[@"sub_parse_objects_dict"][ntValue] != nil) {
                    /*if(parseObjects[@"sub_parse_object_variables"][ntValue] == nil) {
                        parseObjects[@"sub_parse_object_variables"][ntValue] = [[NSMutableArray]]
                    }*/
                    return parseObjects[@"sub_parse_objects_dict"][ntValue][offset];
                }
            }
        } else {
            NSString* ntValue = (NSString*)name;
            return parseObjects[@"sub_parse_objects_dict"][ntValue][offset];
        }
    }
    /*for(NSMutableDictionary* parseObject in parseObjects) {
        if(([name isKindOfClass:[NSArray class]]
            //&& [self arrayHas:(NSMutableArray*)name string:parseObject[@"label"]] != -1
            && [(NSMutableArray*)name indexOfObject:parseObject[@"label"]] != NSNotFound
            ) || ([name isKindOfClass:[NSString class]] && [(NSString*)name isEqualToString:parseObject[@"label"]])) {
            setOffset++;
            if(offset == setOffset) {
                return parseObject;
            }
        }
    }*/
    return NULL;
}
- (NSObject*) getValue: (NSMutableDictionary*) parseObjects name: (NSString*) name offset: (long) offset {
    //long setOffset = -1;
    bool isString = false;
    if([name isEqualToString:@"StringContent"] || [name isEqualToString:@"Identifier"] || [name isEqualToString:@"AccessFlag"] || [name isEqualToString:@"ObjectDefinition"]) {
        isString = true;
    }
    /*if([self isCopy]) {

    }*/
    if(parseObjects[@"sub_parse_objects_dict"][name] != nil && parseObjects[@"sub_parse_objects_dict"][name][offset] != nil) {
        NSMutableDictionary* parseObject = parseObjects[@"sub_parse_objects_dict"][name][offset];
        /*if(parseObject[@"text_value"] != nil) {
            return parseObject[@"text_value"];
        }*/
        return [self getText:[(NSNumber*)parseObject[@"start_index"] intValue] stop:[(NSNumber*)parseObject[@"stop_index"] intValue] isString:isString parseObject:parseObject];
    }
    /*for(NSMutableDictionary* parseObject in parseObjects) {
        if([(NSString*)parseObject[@"label"] isEqualToString:name]) {
            setOffset++;
            if(offset == setOffset) {
            }
        }
    }*/
    return NULL;
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

- (NSObject*) getText: (int) startIndex stop: (int) stopIndex isString: (bool) isString parseObject: (NSMutableDictionary*) parseObject {
    if(parseObject[@"text_value"] != nil) {
        return parseObject[@"text_value"];
    }
    NSRange range = NSMakeRange([@(startIndex) unsignedIntValue], [@(stopIndex-startIndex) unsignedIntValue]);
    /*if([self isCopy]) {
        //////////////NSLog(@"range: %lu _ %lu", range.location, range.length);
    }*/
    NSObject* value = [[self source] substringWithRange:range];
    /*if([self isCopy]) {
        //////////////NSLog(@"value: %@", value);
        //////////////NSLog(@"self source length: %lu", [[self source] length]);
    }*/
    if(!isString) {
        value = [self makeIntoNumber:value];
    }

    if([value isEqualTo:@"true"]) {
        value = @true;
    } else if([value isEqualTo:@"false"]) {
        value = @false;
    } else if([value isEqualTo:@"NULL"]) {
        value = NULL;
    }
    parseObject[@"text_value"] = value;
    return value;
}

- (NSMutableDictionary*) getVariablesState: (NSMutableDictionary*) contextVariables {
    NSMutableDictionary* variablesResult = [[NSMutableDictionary alloc] init];
    for(NSObject* key in contextVariables) {
        if(![key isKindOfClass:[PHPScriptObject class]]) {
            variablesResult[key] = contextVariables[key];
        } else {
            NSObject* cacheValue = [(PHPScriptObject*)contextVariables[key] getCacheValue];
            if(cacheValue != nil) {
                variablesResult[key] = cacheValue;
            } else {
                ////NSLog(@"cacheValue is nil");
            }
        }
    }
    return variablesResult;
}

- (NSMutableDictionary*) getState: (PHPScriptFunction*) context {
    if([context isKindOfClass:[PHPScriptFunction class]]) {
        /*NSMutableDictionary* stateDescriptor = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* functionVariables = [context variables];
        if(subParseObject[@"containsIdentifierThis"] != nil) {
            stateDescriptor[@"this"] = [[context parentContext] ];
            stateDescriptor[@"variables"] = [self getVariablesState:functionVariables];
        }
        
        return stateDescriptor;*/
        return [self getVariablesState:[context variables]];
    } else {
        return [context getCacheValue];
    }
}
@end
