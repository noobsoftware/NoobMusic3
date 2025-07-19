//
//  PHPIncludedObjects.m
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import "PHPData.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "DBConnection.h"

@implementation PHPData
- (void) init: (PHPScriptFunction*) contextInput sql: (DBConnection*) sqlInput {
    
    PHPScriptFunction* __block context = contextInput;
    DBConnection* __block sql = sqlInput;
    PHPData* __block weakSelf = self;
    
    /*PHPScriptFunction* __weak context = contextInput;
    DBConnection* __weak sql = sqlInput;*/
    //PHPData* __weak weakSelf = self;
    
    [self initArrays];
    [self setGlobalObject:true];
    PHPScriptFunction* executeQuery = [[PHPScriptFunction alloc] init];
    [executeQuery initArrays];
    [self setDictionaryValue:@"execute" value:executeQuery];
    [executeQuery setPrototype:self];
    [executeQuery setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        //return @"NULL";
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            input = [self_instance resolveValueReferenceVariableArray:input];
            /*while([input isKindOfClass:[NSMutableArray class]]) {
             input = ((NSMutableArray*)input)[0];
             }
             if([input isKindOfClass:[PHPReturnResult class]]) {
             input = [(PHPReturnResult*)input result];
             }
             if([input isKindOfClass:[PHPScriptVariable class]]) {
             input = [(PHPScriptVariable*)input get];
             }*/
            /*if([input isKindOfClass:[PHPScriptObject class]]) {
             ToJSON* toJSON = [[ToJSON alloc] init];
             NSMutableDictionary* inputValues = [toJSON toJSON:input];
             }*/
            if([input isKindOfClass:[NSString class]]) {
                NSString* query = (NSString*)input;
                query = [query stringByReplacingOccurrencesOfString:@"DEL FROM " withString:@"DELETE FROM "];
                //query = [query stringByReplacingOccurrencesOfString:@"CTABLE " withString:@"CREATE TABLE IF NOT EXISTS "];
                
                NSObject* dict = nil;
                if([values[0] count] > 1 && values[0][1] != nil) {
                    dict = values[0][1];
                    dict = [self_instance resolveValueReferenceVariableArray:dict];
                }
                NSMutableDictionary* valuesDictionary = nil;
                //if(![valuesDictionary isKindOfClass:[PHPScriptObject class]]) {
                if([dict isKindOfClass:[NSString class]]) {
                    //valuesDictionary = [[NSMutableDictionary alloc] init];
                    //////////////////////////NSLog/@"is string");
                    dict = [[PHPScriptObject alloc] init];
                } else {
                    //valuesDictionary = (NSMutableDictionary*)[[self interpretation] toJSON:dict];
                }
                if(dict == nil) {
                    dict = [[weakSelf getInterpretation] makeIntoObjects:[[NSMutableDictionary alloc] init]];
                }
                NSNumber* flagUserIdProtection = @false;
                if([values[0] count] > 2 && values[0][2] != nil) {
                    flagUserIdProtection = (NSNumber*)values[0][2];
                }
                @synchronized (sql) {
                    
                    [sql executeQuery:query values:(PHPScriptObject*)dict];
                }
            }
        }
        return @"NULL";
    } name:@"main"];
    
    
    PHPScriptFunction* getRows = [[PHPScriptFunction alloc] init];
    [getRows initArrays];
    [self setDictionaryValue:@"get_rows" value:getRows];
    [getRows setPrototype:self];
    [getRows setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSMutableArray* arrResults = [[NSMutableArray alloc] init];
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            input = [self_instance parseInputVariable:input];
            NSObject* dict = nil;
            if([values[0] count] > 1) { // && values[0][1] != nil
                dict = values[0][1];
                dict = [self_instance parseInputVariable:dict];
                if([dict isKindOfClass:[NSString class]]) {
                    if([dict isEqualTo:@"[]"]) {
                        dict = [[PHPScriptObject alloc] init];
                    }
                }
            }/* else {
                dict = [[weakSelf getInterpretation] makeIntoObjects:[[NSMutableDictionary alloc] init]];
            }*/
            /*NSNumber* returnAsNative = @false;
            if([values[0] count] == 3) {
                returnAsNative = values[0][2];
            }*/
            //NSMutableDictionary* valuesDictionary = nil;
            if([input isKindOfClass:[NSString class]]) {
                //if(![valuesDictionary isKindOfClass:[PHPScriptObject class]]) {
                /*if([dict isKindOfClass:[NSString class]]) {
                    //valuesDictionary = [[NSMutableDictionary alloc] init];
                    //////////////////////////NSLog/@"is string");
                    dict = [[PHPScriptObject alloc] init];
                } else {
                    //valuesDictionary = (NSMutableDictionary*)[[self interpretation] toJSON:dict];
                }*/
                //////////////////////////NSLog/@"kind of valuesDictionary: %@", [valuesDictionary class]);
                /*if([valuesDictionary isKindOfClass:[NSArray class]]) {
                 valuesDictionary = [[NSMutableDictionary alloc] init];
                 }*/
                //////////////////////////NSLog/@"valuesDictionary: %@", valuesDictionary);
                /*NSNumber* flagUserIdProtection = @false;
                if([values[0] count] > 2 && values[0][2] != nil) {
                    flagUserIdProtection = (NSNumber*)values[0][2];
                }*/
                @synchronized (sql) {
                    //NSLog(@"input : %@ - %@", input, dict);
                    arrResults = [sql fetchResults:(NSString *)input values:dict]; //nil;
                    //NSLog(@"arr results : %@", arrResults);
                    /*if([returnAsNative boolValue]) {
                     return arrResults;
                     }*/
                    /*if([returnAsNative boolValue]) {
                     NSLog(@"return null");
                     return @"NULL";
                     } else {
                     arrResults = [sql fetchResults:(NSString *)input values:dict];
                     }*/
                    //return [[weakSelf interpretation] makeIntoObjects:arrResults];
                }
            }
        }
        return [[weakSelf interpretation] makeIntoObjects:arrResults];
    } name:@"main"];
    
    PHPScriptFunction* get_row = [[PHPScriptFunction alloc] init];
    [get_row initArrays];
    [self setDictionaryValue:@"get_row" value:get_row];
    [get_row setPrototype:self];
    [get_row setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* returnResult = @"NULL";
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            input = [self_instance resolveValueReferenceVariableArray:input];
            NSObject* dict = nil;
            if([values[0] count] > 1 && values[0][1] != nil) {
                dict = values[0][1];
                dict = [self_instance resolveValueReferenceVariableArray:dict];
            } else {
                dict = [[weakSelf getInterpretation] makeIntoObjects:[[NSMutableDictionary alloc] init]];
            }
            /*NSNumber* returnAsNative = @false;
            if([values[0] count] == 3) {
                returnAsNative = values[0][2];
            }*/
            NSMutableDictionary* valuesDictionary = nil;
            if([input isKindOfClass:[NSString class]]) {
                //if(![valuesDictionary isKindOfClass:[PHPScriptObject class]]) {
                if([dict isKindOfClass:[NSString class]]) {
                    //valuesDictionary = [[NSMutableDictionary alloc] init];
                    //////////////////////////NSLog/@"is string");
                    dict = [[PHPScriptObject alloc] init];
                } else {
                    //valuesDictionary = (NSMutableDictionary*)[[self interpretation] toJSON:dict];
                }
                //////////////////////////NSLog/@"kind of valuesDictionary: %@", [valuesDictionary class]);
                /*if([valuesDictionary isKindOfClass:[NSArray class]]) {
                 valuesDictionary = [[NSMutableDictionary alloc] init];
                 }*/
                //////////////////////////NSLog/@"valuesDictionary: %@", valuesDictionary);
                /*NSNumber* flagUserIdProtection = @false;
                if([values[0] count] > 2 && values[0][2] != nil) {
                    flagUserIdProtection = (NSNumber*)values[0][2];
                }*/
                @synchronized (sql) {
                    NSArray* resultArr = [sql fetchResults:(NSString *)input values:dict];
                    /*if([returnAsNative boolValue]) {
                        
                        if([resultArr count] > 0) {
                            return resultArr[0];
                        }
                        return NULL;
                    }*/
                    if([resultArr count] > 0) {
                        returnResult = [[weakSelf interpretation] makeIntoObjects:resultArr[0]];
                    }
                }
                //return [[self interpretation] makeIntoObjects:resultArr];
            }
        }
        return returnResult;//[[self interpretation] makeIntoObjects:NULL];
    } name:@"main"];
    
    PHPScriptFunction* tableColumns = [[PHPScriptFunction alloc] init];
    [tableColumns initArrays];
    [self setDictionaryValue:@"table_columns" value:tableColumns];
    [tableColumns setPrototype:self];
    [tableColumns setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* returnResults = @"NULL";
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            input = [self_instance resolveValueReferenceVariableArray:input];
            NSString* table_name = (NSString*)input;
            /*input = [self_instance resolveValueReferenceVariableArray:input];
             if([input isKindOfClass:[NSString class]]) {
             return [[self interpretation] makeIntoObjects:[sql fetchResults:(NSString *)input]];
             }*/
            //////////////////////NSLog/@"table_columns: %@", table_name);
            //[sql executeQuery:@"DROP TABLE IF EXISTS table_info" values:@[]];
            //TEMPORARY
            //NSString* queryString = [NSString stringWithFormat:@"DROP TABLE IF EXISTS table_info; CREATE  TABLE table_info as SELECT * FROM pragma_table_info('%@');", table_name];
            //NSString* queryString = @"DROP TABLE IF EXISTS table_info; CREATE TEMPORARY TABLE table_info as SELECT * FROM pragma_table_info(?);";
            //[sql executeQuery:queryString values:@[]];
            //NSString* query = @"SELECT name FROM table_info";
            NSString* query = [NSString stringWithFormat:@"SELECT * FROM pragma_table_info('%@')", table_name];
            //////////////////////NSLog/@"query: %@", query);
            @synchronized (sql) {
                NSMutableArray* columnsResult = [sql fetchResults:query values:[[PHPScriptObject alloc] init]];
                //NSMutableArray* columnsResult = [sql fetchResults:queryString values:@{@"table_name": table_name}];
                //////////////////////NSLog/@"columnsResult: %@", columnsResult);
                NSMutableArray* columns = [[NSMutableArray alloc] init];
                for(NSDictionary* row in columnsResult) {
                    [columns addObject:row[@"name"]];
                }
                //////////////////NSLog/@"columns: %@", columns);
                NSObject* result = [[weakSelf interpretation] makeIntoObjects:columns];
                //////////////////NSLog/@"result: %@", result);
                //////////////////NSLog/@"kindofClass: %@", [result class]);
                returnResults = result;
            }
        }
        return returnResults;
    } name:@"main"];
    
    PHPScriptFunction* insert = [[PHPScriptFunction alloc] init];
    [insert initArrays];
    [self setDictionaryValue:@"_" value:insert];
    [insert setPrototype:self];
    [insert setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        ////////////////////////////NSLog/@"values input: %@", values);
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            input = [self_instance resolveValueReferenceVariableArray:input];
            NSObject* valuesDict = values[0][1];
            ////////NSLog(@"class type: %@", [valuesDict class]);
            //////////////////////////NSLog/@"valuesDict: %@", valuesDict);
            //NSDictionary* valuesDictionary = (NSDictionary*)[[self interpretation] toJSON:valuesDict];
            //////////////////////////NSLog/@"valuesdict: %@", valuesDictionary);
            //NSLog(@"insert  : %@  - %@", input, [[self getInterpretation] toJSON:valuesDict]);
            @synchronized (sql) {
                [sql insertData:(NSString*)input values:valuesDict];
            }
        }
        //[sql executeQuery:(NSString*)input values:(PHPScriptObject*)valuesDict];
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* generate_uuid = [[PHPScriptFunction alloc] init];
    [generate_uuid initArrays];
    [self setDictionaryValue:@"generate_uuid" value:generate_uuid];
    [generate_uuid setPrototype:self];
    [generate_uuid setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        /*NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        NSObject* valuesDict = values[0][1];
        NSDictionary* valuesDictionary = [[self interpretation] makeIntoObjects:[sql fetchResults:valuesDict]];
        [sql insertData:(NSString*)input values:valuesDictionary];
        return nil;*/
        //return [sql lastInsertRowId];
        NSString *uuid = [[NSString alloc] initWithString:[[NSUUID UUID] UUIDString]];
        uuid = [uuid mutableCopy];
        return uuid;
    } name:@"main"];
    
    //NSString *uuid = [[NSUUID UUID] UUIDString];
    
    PHPScriptFunction* lastInsertId = [[PHPScriptFunction alloc] init];
    [lastInsertId initArrays];
    [self setDictionaryValue:@"last_insert_id" value:lastInsertId];
    [lastInsertId setPrototype:self];
    [lastInsertId setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        /*NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        NSObject* valuesDict = values[0][1];
        NSDictionary* valuesDictionary = [[self interpretation] makeIntoObjects:[sql fetchResults:valuesDict]];
        [sql insertData:(NSString*)input values:valuesDictionary];
        return nil;*/
        @synchronized (sql) {
            
            return [sql lastInsertRowId];
        }
    } name:@"main"];
    
    /*PHPScriptFunction* toJSON = [[PHPScriptFunction alloc] init];
    [toJSON initArrays];
    ////////////////////////////NSLog/@"set toJSON");
    [self setDictionaryValue:@"toJSON" value:toJSON];
    [toJSON setPrototype:self];
    [toJSON setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        ////////////////////////////NSLog/@"set log");
        ////////////////////////////NSLog/@"JSONinput: %@", values);
        ////////////////////////////NSLog/@"log values: %@", values);
        NSObject* input = values[0][0];
        ////////////////////////////NSLog/@"JSONinput: %@", input);
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        if([input isKindOfClass:[PHPReturnResult class]]) {
            input = [(PHPReturnResult*)input result];
        }
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }
        ////////////////////////////NSLog/@"inside toJSON");
        NSObject* result = [[weakSelf interpretation] toJSON:input];
        NSString *string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:result options:0 error:nil] encoding:NSUTF8StringEncoding];
        ////////////////////////////NSLog/@"res: %@", result);
        return string;
        ////////////////////////////NSLog/@"output: %@", input);
        //return nil;
    } name:@"main"];*/
    //[var_dump setClosures:<#(NSMutableDictionary *)#>]
}
@end
