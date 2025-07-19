//
//  PHPIncludedObjects.m
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import "PHPStrings.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import <WebKit/WebKit.h>

@implementation PHPStrings
- (void) init: (PHPScriptFunction*) contextInput {
    [self initArrays];
    [self setGlobalObject:true];
    
    PHPScriptFunction* __block context = contextInput;
    PHPStrings* __block weakSelf = self;
    
    PHPScriptFunction* replace_range = [[PHPScriptFunction alloc] init];
    [replace_range initArrays];
    [self setDictionaryValue:@"replace_range" value:replace_range];
    [replace_range setPrototype:self];
    [replace_range setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSString* result;
        @autoreleasepool {
            
            NSString* inputA = (NSString*)values[0][0];
            NSString* replaceValue = (NSString*)values[0][1];
            NSNumber* location = (NSNumber*)values[0][2];
            NSNumber* length = (NSNumber*)values[0][3];
            if([values[0] count] > 4 && [(NSNumber*)values[0][4] boolValue]) {
                NSString* copyValue = @"";
                int counter = 0;
                while(counter < [length intValue]) {
                    copyValue = [copyValue stringByAppendingString:replaceValue];
                    counter++;
                }
                replaceValue = copyValue;
            }
            NSRange nsRange = NSMakeRange([location unsignedIntValue], [length unsignedIntValue]);
            result = [inputA stringByReplacingCharactersInRange:nsRange withString:replaceValue];
        }
        return result;
    } name:@"main"];
    
    PHPScriptFunction* substr = [[PHPScriptFunction alloc] init];
    [substr initArrays];
    [self setDictionaryValue:@"substr" value:substr];
    [substr setPrototype:self];
    [substr setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSString* results;
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            //////////NSLog(@"inputSubstr %@ _ %@", input, values);
            input = [weakSelf parseInputVariable:input];
            NSString* stringValue = [weakSelf makeIntoString:input];
            NSObject* inputStart = values[0][1];
            inputStart = [weakSelf parseInputVariable:inputStart];
            NSNumber* inputStartNumber = [self makeIntoNumber:inputStart];
            
            NSNumber* inputLengthNumber = @([stringValue length]-1);
            
            if([values[0] count] > 2) {
                NSObject* inputLength = values[0][2];
                inputLength = [weakSelf parseInputVariable:inputLength];
                inputLengthNumber = [self makeIntoNumber:inputLength];
            } else {
                inputLengthNumber = @([inputLengthNumber intValue] - [inputStartNumber intValue] + 1);
            }
            ////////////NSLog(@"inputs: %@ %@ %@", stringValue, inputStartNumber, inputLengthNumber);
            if([inputLengthNumber isLessThan:@0]) {
                inputLengthNumber = @([stringValue length] - [inputLengthNumber intValue]);
            }
            
            NSRange range = NSMakeRange([inputStartNumber intValue], [inputLengthNumber intValue]);
            ////////////NSLog(@"range: %lu - %lu", range.location, range.length);
            results = [stringValue substringWithRange:range];
        }
        return results;
    } name:@"main"];
    
    PHPScriptFunction* strlen = [[PHPScriptFunction alloc] init];
    [strlen initArrays];
    [self setDictionaryValue:@"strlen" value:strlen];
    [strlen setPrototype:self];
    [strlen setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSNumber* results;
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            //////////NSLog(@"input %@ _ %@", input, values);
            input = [weakSelf parseInputVariable:input];
            NSString* stringValue = [weakSelf makeIntoString:input];
            results = @([stringValue length]);
            //////////NSLog(@"strlen value: %@ - %@", stringValue, @([stringValue length]));
        }
        return results;
    } name:@"main"];
    
    PHPScriptFunction* lower = [[PHPScriptFunction alloc] init];
    [lower initArrays];
    [self setDictionaryValue:@"lower" value:lower];
    [lower setPrototype:self];
    [lower setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSString* results;
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            //////////NSLog(@"input %@ _ %@", input, values);
            input = [weakSelf parseInputVariable:input];
            NSString* stringValue = [weakSelf makeIntoString:input];
            //////////NSLog(@"strlen value: %@ - %@", stringValue, @([stringValue length]));
            results = [stringValue lowercaseString];
        }
        return results;
        //return @([stringValue length]);
    } name:@"main"];
    
    PHPScriptFunction* apos = [[PHPScriptFunction alloc] init];
    [apos initArrays];
    [self setDictionaryValue:@"apos" value:apos];
    [apos setPrototype:self];
    [apos setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        return @"'";
    } name:@"main"];
    
    PHPScriptFunction* character_set = [[PHPScriptFunction alloc] init];
    [character_set initArrays];
    [self setDictionaryValue:@"index_of_character_set" value:character_set];
    [character_set setPrototype:self];
    [character_set setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* results;
        @autoreleasepool {
            
            NSString* inputCharacters = (NSString*)[weakSelf makeIntoString:[weakSelf parseInputVariable:values[0][0]]];
            NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:inputCharacters];
            
            if([values[0] count] > 2) {
                set = [set invertedSet];
            }
            
            NSString* check_match = (NSString*)[weakSelf makeIntoString:[weakSelf parseInputVariable:values[0][1]]];
            NSRange range = [check_match rangeOfCharacterFromSet:set];
            results = [[self getInterpretation] makeIntoObjects:@{
                @"position": @(range.location),
                @"length_value": @(range.length),
            }];
        }
        return results;
    } name:@"main"];
    
    PHPScriptFunction* encaps_quotes = [[PHPScriptFunction alloc] init];
    [encaps_quotes initArrays];
    [self setDictionaryValue:@"encaps_quotes" value:encaps_quotes];
    [encaps_quotes setPrototype:self];
    [encaps_quotes setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSString* results;
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            //////////NSLog(@"input %@ _ %@", input, values);
            input = [weakSelf parseInputVariable:input];
            NSString* stringValue = [weakSelf makeIntoString:input];
            //////////NSLog(@"strlen value: %@ - %@", stringValue, @([stringValue length]));
            results = [@"'" stringByAppendingString:[stringValue stringByAppendingString:@"'"]];
            //return @([stringValue length]);
        }
        return results;
    } name:@"main"];
    
    PHPScriptFunction* str_split = [[PHPScriptFunction alloc] init];
    [str_split initArrays];
    [self setDictionaryValue:@"str_split" value:str_split];
    [str_split setPrototype:self];
    [str_split setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* results;
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            //////////NSLog(@"input %@ _ %@", input, values);
            input = [weakSelf parseInputVariable:input];
            NSString* stringValue = [weakSelf makeIntoString:input];
            
            NSMutableArray *array = [NSMutableArray array];
            for(int i = 0; i < [stringValue length]; i++) {
                [array addObject:[NSString stringWithFormat:@"%C", [stringValue characterAtIndex:i]]];
            }
            
            results = [[self_instance getInterpretation] makeIntoObjects:array];
        }
        return results;
    } name:@"main"];
    
    PHPScriptFunction* is_numeric = [[PHPScriptFunction alloc] init];
    [is_numeric initArrays];
    [self setDictionaryValue:@"is_numeric" value:is_numeric];
    [is_numeric setPrototype:self];
    [is_numeric setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* results;
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            //////////NSLog(@"input %@ _ %@", input, values);
            input = [weakSelf parseInputVariable:input];
            NSString* stringValue = [weakSelf makeIntoString:input];
            
            NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
            //////////NSLog(@"alphaNums: %@", alphaNums);
            NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:stringValue];
            //////////NSLog(@"inStringSet: %@", inStringSet);
            //////////NSLog(@"isNumeric: %@", name);
            bool isNumeric = [alphaNums isSupersetOfSet:inStringSet];
            //////////NSLog(@"strlen value: %@ - %@", stringValue, @([stringValue length]));
            results = @(isNumeric);
        }
        return results;
    } name:@"main"];
    
    /**/
    PHPScriptFunction* strrev = [[PHPScriptFunction alloc] init];
    [strrev initArrays];
    [self setDictionaryValue:@"strrev" value:strrev];
    [strrev setPrototype:self];
    [strrev setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* results;
        @autoreleasepool {
            ////////NSLog(@"strrev: %@", values);
            NSObject* input = values[0][0];
            input = [self_instance parseInputVariable:input];
            //input = [[self_instance interpretation] toJSON:input];
            if([input isKindOfClass:[NSString class]]) {
                NSString* path = (NSString*)input;
                ////////NSLog(@"to reversed String: %@", path);
                /*NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
                return [[self_instance interpretation] makeIntoObjects:dirs];*/
                //path = [path stringByApplyingTransform:NSStringTrans reverse:<#(BOOL)#>]
                //NSArray* characters = [path char]
                NSString *myString = path;
                NSMutableString *reversedString = [NSMutableString stringWithCapacity:[myString length]];

                [myString enumerateSubstringsInRange:NSMakeRange(0,[myString length])
                     options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                    [reversedString appendString:substring];
                }];
                ////////NSLog(@"reversed String: %@", reversedString);
                results = [[weakSelf interpretation] makeIntoObjects:reversedString];
                /*NSNumber* results = @(false);
                if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    results = @(true);
                }
                return results;//[[self_instance interpretation] makeIntoObjects:results];*/
            } else {
                results = @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
            }
        }
        return results;
    } name:@"main"];
    
    PHPScriptFunction* split = [[PHPScriptFunction alloc] init];
    [split initArrays];
    [self setDictionaryValue:@"split" value:split];
    [split setPrototype:self];
    [split setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* results;
        @autoreleasepool {
            
            
            NSObject* input = values[0][0];
            input = [self_instance resolveValueArray:input];
            while([input isKindOfClass:[NSMutableArray class]]) {
                input = ((NSMutableArray*)input)[0];
            }
            input = [self_instance resolveValueReferenceVariableArray:input];
            if([input isKindOfClass:[PHPScriptVariable class]]) {
                input = [(PHPScriptVariable*)input get];
            }
            input = [weakSelf makeIntoString:input];
            NSObject* delimiter = values[0][1];
            delimiter = [self_instance resolveValueArray:delimiter];
            while([delimiter isKindOfClass:[NSMutableArray class]]) {
                delimiter = ((NSMutableArray*)delimiter)[0];
            }
            delimiter = [self_instance resolveValueReferenceVariableArray:delimiter];
            if([delimiter isKindOfClass:[PHPScriptVariable class]]) {
                delimiter = [(PHPScriptVariable*)delimiter get];
            }
            delimiter = [weakSelf makeIntoString:delimiter];
            ////////////////////////////NSLog/@"variable isset result: %@", input);
            NSMutableArray* split = [[NSMutableArray alloc] initWithArray:[(NSString*)input componentsSeparatedByString:(NSString*)delimiter]];
            ////////////////////////NSLog/@"split: %@ - %@ - %@", input, delimiter, split);
            ////////NSLog(@"split result: %@", split);
            results = [[weakSelf interpretation] makeIntoObjects:split];
        }
        return results;
    } name:@"main"];
    
    
    PHPScriptFunction* trim = [[PHPScriptFunction alloc] init];
    [trim initArrays];
    [self setDictionaryValue:@"trim" value:trim];
    [trim setPrototype:self];
    [trim setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* results;
        @autoreleasepool {
            
            
            NSObject* input = values[0][0];
            input = [self_instance resolveValueArray:input];
            while([input isKindOfClass:[NSMutableArray class]]) {
                input = ((NSMutableArray*)input)[0];
            }
            input = [self_instance resolveValueReferenceVariableArray:input];
            if([input isKindOfClass:[PHPScriptVariable class]]) {
                input = [(PHPScriptVariable*)input get];
            }
            ////////////////////////NSLog/@"trim: %@", input);
            NSString *trimmedString = [(NSString*)input stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            ////////////////////////NSLog/@"trimmedString: %@", trimmedString);
            results = [[weakSelf interpretation] makeIntoObjects:trimmedString];
        }
        return results;
    } name:@"main"];
    
    /*PHPScriptFunction* quit_application = [[PHPScriptFunction alloc] init];
    [quit_application initArrays];
    [self setDictionaryValue:@"quit_application" value:quit_application];
    [quit_application setPrototype:self];
    [quit_application setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        [[NSApplication sharedApplication] terminate:self];
        return nil;
    } name:@"main"];*/
    
    PHPScriptFunction* strpos = [[PHPScriptFunction alloc] init];
    [strpos initArrays];
    [self setDictionaryValue:@"strpos" value:strpos];
    [strpos setPrototype:self];
    [strpos setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* results;
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            input = [self_instance resolveValueArray:input];
            while([input isKindOfClass:[NSMutableArray class]]) {
                input = ((NSMutableArray*)input)[0];
            }
            input = [self_instance resolveValueReferenceVariableArray:input];
            if([input isKindOfClass:[PHPScriptVariable class]]) {
                input = [(PHPScriptVariable*)input get];
            }
            NSString* stringValue = [context makeIntoString:input];
            
            NSObject* search = values[0][1];
            search = [self_instance resolveValueArray:search];
            while([search isKindOfClass:[NSMutableArray class]]) {
                search = ((NSMutableArray*)search)[0];
            }
            search = [self_instance resolveValueReferenceVariableArray:search];
            if([search isKindOfClass:[PHPScriptVariable class]]) {
                search = [(PHPScriptVariable*)input get];
            }
            NSString* stringValueSearch = [context makeIntoString:search];
            
            NSRange range = [stringValue rangeOfString:stringValueSearch];
            if(range.location == NSNotFound) {
                results = @(-1);
            } else {
                results = @(range.location);
            }
        }
        return results;
    } name:@"main"];
    
    PHPScriptFunction* compare = [[PHPScriptFunction alloc] init];
    [compare initArrays];
    //////////////////////////NSLog/@"set log");
    [self setDictionaryValue:@"compare" value:compare];
    [compare setPrototype:self];
    [compare setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* results;
        @autoreleasepool {
            
            NSObject* a = values[0][0];
            NSObject* b = values[0][1];
            
            NSString* stringA = [weakSelf makeIntoString:[weakSelf parseInputVariable:a]];
            NSString* stringB = [weakSelf makeIntoString:[weakSelf parseInputVariable:b]];
            
            NSComparisonResult res = [stringA compare:stringB];
            results =  @0;
            if(res == NSOrderedSame) {
                results = @0;
            } else if(res == NSOrderedAscending) {
                results =  @1;
            } else {
                results =  @-1;
            }
        }
        return results;
    } name:@"main"];
    
    /*PHPScriptFunction* strlen = [[PHPScriptFunction alloc] init];
    [strlen initArrays];
    [self setDictionaryValue:@"strlen" value:strlen];
    [strlen setPrototype:self];
    [strlen setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        //////////NSLog(@"input %@ _ %@", input, values);
        input = [weakSelf parseInputVariable:input];
        NSString* stringValue = [weakSelf makeIntoString:input];
        //////////NSLog(@"strlen value: %@ - %@", stringValue, @([stringValue length]));
        return @([stringValue length]);
    } name:@"main"];*/
    
    /*PHPScriptFunction* stringlength = [[PHPScriptFunction alloc] init];
    [stringlength initArrays];
    [self setDictionaryValue:@"stringlength" value:stringlength];
    [stringlength setPrototype:self];
    [stringlength setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        //////////NSLog(@"stringlength %@ _ %@", input, values);
        input = [weakSelf parseInputVariable:input];
        NSString* stringValue = [weakSelf makeIntoString:input];
        return @([stringValue length]);
    } name:@"main"];*/
    
    /*PHPScriptFunction* substr = [[PHPScriptFunction alloc] init];
    [substr initArrays];
    [self setDictionaryValue:@"substr" value:substr];
    [substr setPrototype:self];
    [substr setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        //////////NSLog(@"inputSubstr %@ _ %@", input, values);
        input = [weakSelf parseInputVariable:input];
        NSString* stringValue = [weakSelf makeIntoString:input];
        NSObject* inputStart = values[0][1];
        inputStart = [weakSelf parseInputVariable:inputStart];
        NSNumber* inputStartNumber = [self makeIntoNumber:inputStart];
        
        NSNumber* inputLengthNumber = @([stringValue length]-1);
        
        if([values[0] count] > 2) {
            NSObject* inputLength = values[0][2];
            inputLength = [weakSelf parseInputVariable:inputLength];
            inputLengthNumber = [self makeIntoNumber:inputLength];
        }
        ////////////NSLog(@"inputs: %@ %@ %@", stringValue, inputStartNumber, inputLengthNumber);
        if([inputLengthNumber isLessThan:@0]) {
            inputLengthNumber = @([stringValue length] - [inputLengthNumber intValue]);
        }
        
        NSRange range = NSMakeRange([inputStartNumber intValue], [inputLengthNumber intValue]);
        ////////////NSLog(@"range: %lu - %lu", range.location, range.length);
        return [stringValue substringWithRange:range];
    } name:@"main"];*/
    
    
    PHPScriptFunction* str_replace = [[PHPScriptFunction alloc] init];
    [str_replace initArrays];
    [self setDictionaryValue:@"str_replace" value:str_replace];
    [str_replace setPrototype:self];
    [str_replace setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* results;
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            input = [weakSelf parseInputVariable:input];
            NSString* stringValue = [weakSelf makeIntoString:input];
            
            NSObject* inputFind = values[0][1];
            inputFind = [weakSelf parseInputVariable:inputFind];
            NSString* inputFindValue = [weakSelf makeIntoString:inputFind];
            
            NSObject* inputReplace = values[0][2];
            inputReplace = [weakSelf parseInputVariable:inputReplace];
            NSString* inputReplaceValue = [weakSelf makeIntoString:inputReplace];
            
            results = [inputReplaceValue stringByReplacingOccurrencesOfString:stringValue withString:inputFindValue];
        }
        return results;
    } name:@"main"];
    
    PHPScriptFunction* join = [[PHPScriptFunction alloc] init];
    [join initArrays];
    [self setDictionaryValue:@"join" value:join];
    [join setPrototype:self];
    [join setClosure:^NSObject *(NSMutableArray* __weak values, PHPScriptFunction* __weak self_instance) {
        NSObject* results;
        @autoreleasepool {
            
            NSObject* input = values[0][0];
            input = [weakSelf parseInputVariable:input];
            NSArray* inputArray = [[weakSelf interpretation] toJSON:input];
            
            NSObject* inputFind = values[0][1];
            inputFind = [weakSelf parseInputVariable:inputFind];
            NSString* inputFindValue = [weakSelf makeIntoString:inputFind];
            
            NSString* result = [[NSString alloc] init];
            
            int index = 0;
            for(NSObject* part_item in inputArray) {
                NSString* part = [weakSelf makeIntoString:part_item];
                if(index > 0) {
                    result = [result stringByAppendingString:inputFindValue];
                }
                result = [result stringByAppendingString:part];
                index++;
            }
            results = result;
        }
        return results;
    } name:@"main"];
}
@end
