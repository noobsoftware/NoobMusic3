//
//  Preparser.m
//  noobtest
//
//  Created by siggi jokull on 3.7.2023.
//

#import "Preparser.h"

@implementation Preparser


- (NSMutableDictionary*) preparseText: (NSString*) sourceText {
    NSString* input = [[NSString alloc] initWithString:sourceText];
    
    
    
    
    //[sourceText stringByAppendingString:@""];
    NSMutableDictionary* results = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* resultsRange = [[NSMutableDictionary alloc] init];
    /*
     @"private#",
     @"public#",
     @"protected#",
     @"function#",
     @"class#",
     @"return#",
     @"#extends#",
     @"#as#",
     @"else#if",
     @"new#",
     @"delete#",*/
    NSMutableArray* terminal_strings = [[NSMutableArray alloc] initWithArray:@[
        @"\\$",
        @"\\(",
        @"\\)",
        @"public\\s",
        @"private\\s",
        @"function",
        @"extends\\s",
        @"protected\\s",
        @"\\[\\.\\.\\.",
        @"delete\\s",
        @"foreach",
        @"while",
        @"for",
        @"\\-\\>",
        @"%",
        @"\\{",
        @"\\}",
        @",",
        @"NULL",
        @"\\[\\]\\=",
        @";",
        @"async\\s",
        @"class\\s",
        @"\\sas\\s",
        @"await\\s",
        @"return\\s",
        @"\\[",
        @"\\]",
        @"\\!\\=\\=",
        @"\\=\\=\\=",
        @"\\!\\=",
        @"\\=\\=",
        @"new\\s",
        @"if",
        @"else\\sif",
        @"else",
        @"\\|\\|",
        @"&&",
        @"\\+\\=",
        @"\\-\\=",
        @"\\*\\=",
        @"\\/\\=",
        @"\\.\\=",
        @"\\.",
        @"\\=\\>",
        @"\\<\\=",
        @"\\>\\=",
        @"\\<",
        @"\\>",
        @"\\=",
        @"\\!",
        //@"'",
        //@"+=",
        //@"-=",
        @"\\=",
        @"\\+\\+",
        @"\\-\\-",
        @"\\+",
        @"\\-",
        @"\\/",
        @"\\*",
        @"false",
        @"true",
        //@"\\s",
        
    ]];
    
    NSError *error = NULL;
    //[self setStrings:[[NSMutableDictionary alloc] init]];
    NSMutableDictionary* strings = [[NSMutableDictionary alloc] init];
    NSString* stringCapture = @"(['])((?:\\\\\\1|(?:(?!\\1)).)*)(\\1)";
    NSRegularExpression *regex_strings_result = [NSRegularExpression regularExpressionWithPattern:stringCapture
                                                                                          options:NSRegularExpressionCaseInsensitive
                                                                                            error:&error];
    NSArray *stringsArray = [regex_strings_result matchesInString:input options:0 range:NSMakeRange(0, [input length])] ;
    //////////////////////////NSLog/@"stringsArray: %@", stringsArray);
    for(NSTextCheckingResult* match in stringsArray) {
        //NSRange matchRange = [match replaceValueAtIndex:@(0) inPropertyWithKey:<#(nonnull NSString *)#> withValue:<#(nonnull id)#>];//[match rangeAtIndex:1];
        NSUInteger matchRange = [match numberOfRanges];
        //////////////////////////NSLog/@"match: %lu", matchRange);
        NSRange range = [match range];
        ////////////////////////////NSLog/@"match: %@", range);
        NSString* subString = [input substringWithRange:range];
        if(strings[@(range.location)] == nil) {
            strings[@(range.location)] = @{
                @"length": @(range.length),
                @"value": subString
            };
            //input = [self replaceWithHash:input range:range];
            //////////////NSLog(@"string found!");
        }
    }
    [self setStrings:strings];
    
    [self findIdentifiers:input];
    
    NSString* regexSuffix = @"(?=([^']*'[^']*')*[^']*$)";
    for(NSString* terminalString in terminal_strings) {
        NSString* regex_strings = [terminalString stringByAppendingString:regexSuffix];
        NSRegularExpression *regex_strings_result = [NSRegularExpression regularExpressionWithPattern:regex_strings
                                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                                error:&error];
        NSArray *stringsArray = [regex_strings_result matchesInString:input options:0 range:NSMakeRange(0, [input length])] ;
        //////////////////////////NSLog/@"stringsArray: %@", stringsArray);
        for(NSTextCheckingResult* match in stringsArray) {
            //NSRange matchRange = [match replaceValueAtIndex:@(0) inPropertyWithKey:<#(nonnull NSString *)#> withValue:<#(nonnull id)#>];//[match rangeAtIndex:1];
            NSUInteger matchRange = [match numberOfRanges];
            //////////////////////////NSLog/@"match: %lu", matchRange);
            NSRange range = [match range];
            ////////////////////////////NSLog/@"match: %@", range);
            NSString* subString = [input substringWithRange:range];
            //////////////NSLog(@"substring: %@", subString);
            //////////////NSLog(@"matchRange: %lu %lu", range.length, range.location);
            //////////////NSLog(@"%@", regex_strings);
            NSString* startChar = [subString substringWithRange:NSMakeRange(0, 1)];//[@([subString characterAtIndex:0]) stringValue];
            NSString* endChar = [subString substringWithRange:NSMakeRange([subString length]-1, 1)];//[@([subString characterAtIndex:[subString length]-1]) stringValue];
            long location = range.location;
            long length = range.length;
            int perform_split = -1;
            if([startChar isEqualToString:@" "]) {
                location++;
                length--;
                perform_split = 1;
            }
            if([endChar isEqualToString:@" "]) {
                length--;
                perform_split++;
            }
            //////////////NSLog(@" startchar %@ endchar %@", startChar, endChar);
            if(perform_split >= 0) {
                NSArray* split = [subString componentsSeparatedByString:@" "];
                if(perform_split == 2) {
                    subString = split[1];
                } else {
                    subString = split[0];
                }
            }
            
            //////////////NSLog(@"subString: %@", subString);
            if(resultsRange[@(location)] == nil && strings[@(location)] == nil && [self identifiers][@(location)] == nil) {
                NSMutableDictionary* dictResult = [[NSMutableDictionary alloc] initWithDictionary:@{
                    @"length": @(length),
                    @"value": subString
                }];
                resultsRange[@(location)] = dictResult;
                
                /*long counter = 0;
                long offset = location;
                while(counter < length) {
                    results[@(offset)] = [subString substringWithRange:NSMakeRange(counter, 1)];//@([subString characterAtIndex:counter]);
                    offset++;
                    counter++;
                }*/
                //input = [self replaceWithHash:input range:NSMakeRange(location, length)];
            }
            //NSString* hashedString = [subString stringByReplacingOccurrencesOfString:@" " withString:@"#"];
            //////////////////////////NSLog/@"sub: %@ - %@", subString, hashedString);
            //input = [input stringByReplacingCharactersInRange:range withString:hashedString];
        }
    }
    /*for(NSNumber* location in resultsRange) {
        NSNumber* length = resultsRange[location][@"length"];
        input = [self replaceWithHash:input range:NSMakeRange([location longLongValue], [length longLongValue])];
    }*/
    //[self findNumbers:input];
    
    [self setRangeResults:resultsRange];
    [self findWhiteSpaces:input];
    return results;
}

- (NSString*) replaceWithHash: (NSString*) input range: (NSRange) range {
    NSString* hashString = @"";
    int counter = 0;
    while(counter < range.length) {
        hashString = [hashString stringByAppendingString:@"#"];
        counter++;
    }
    return [input stringByReplacingCharactersInRange:range withString:hashString];
}

//
- (void) findIdentifiers: (NSString*) input {
    NSMutableDictionary* strings = [[NSMutableDictionary alloc] init];
    NSString* stringCapture = @"(\\$|\\-\\>|function\\s)[_a-z0-9]+";//@"[_a-z0-9]+";
    NSError* error;
    NSRegularExpression *regex_strings_result = [NSRegularExpression regularExpressionWithPattern:stringCapture
                                                                                          options:NSRegularExpressionCaseInsensitive
                                                                                            error:&error];
    NSArray *stringsArray = [regex_strings_result matchesInString:input options:0 range:NSMakeRange(0, [input length])] ;
    //////////////////////////NSLog/@"stringsArray: %@", stringsArray);
    for(NSTextCheckingResult* match in stringsArray) {
        //NSRange matchRange = [match replaceValueAtIndex:@(0) inPropertyWithKey:<#(nonnull NSString *)#> withValue:<#(nonnull id)#>];//[match rangeAtIndex:1];
        NSUInteger matchRange = [match numberOfRanges];
        //////////////////////////NSLog/@"match: %lu", matchRange);
        NSRange range = [match range];
        ////////////////////////////NSLog/@"match: %@", range);
        NSString* subString = [input substringWithRange:range];
        long location = range.location;
        long length = range.length;
        if([subString containsString:@"$"]) {
            location++;
            length--;
            subString = [subString substringWithRange:NSMakeRange(1, [subString length]-1)];
        } else if([subString containsString:@"->"]) {
            location += 2;
            length -= 2;
            subString = [subString substringWithRange:NSMakeRange(2, [subString length]-2)];
        } else if([subString containsString:@"function "]) {
            location += 9;
            length -= 9;
            subString = [subString substringWithRange:NSMakeRange(9, [subString length]-9)];
        }
        if(strings[@(location)] == nil && [self strings][@(location)] == nil) { //} && [self rangeResults][@(location)] == nil) {
            strings[@(location)] = @{
                @"length": @(length),
                @"value": subString
            };
            //////////////NSLog(@"identifier found! %@", subString);
            //input = [self replaceWithHash:input range:NSMakeRange(location, length)];
        }
    }
    [self setIdentifiers:strings];
}


- (void) findNumbers: (NSString*) input {
    NSMutableDictionary* strings = [[NSMutableDictionary alloc] init];
    NSString* stringCapture = @"[0-9]";
    NSError* error;
    NSRegularExpression *regex_strings_result = [NSRegularExpression regularExpressionWithPattern:stringCapture
                                                                                          options:NSRegularExpressionCaseInsensitive
                                                                                            error:&error];
    NSArray *stringsArray = [regex_strings_result matchesInString:input options:0 range:NSMakeRange(0, [input length])] ;
    //////////////////////////NSLog/@"stringsArray: %@", stringsArray);
    for(NSTextCheckingResult* match in stringsArray) {
        //NSRange matchRange = [match replaceValueAtIndex:@(0) inPropertyWithKey:<#(nonnull NSString *)#> withValue:<#(nonnull id)#>];//[match rangeAtIndex:1];
        NSUInteger matchRange = [match numberOfRanges];
        //////////////////////////NSLog/@"match: %lu", matchRange);
        NSRange range = [match range];
        ////////////////////////////NSLog/@"match: %@", range);
        NSString* subString = [input substringWithRange:range];
        if(strings[@(range.location)] == nil) {
            strings[@(range.location)] = @{
                @"length": @(range.length),
                @"value": subString
            };
            //input = [self replaceWithHash:input range:range];
            //////////////NSLog(@"whitepace found!");
        }
    }
    [self setNumbers:strings];
}

- (void) findWhiteSpaces: (NSString*) input {
    NSMutableDictionary* strings = [[NSMutableDictionary alloc] init];
    NSString* stringCapture = @"\\s";
    NSError* error;
    NSRegularExpression *regex_strings_result = [NSRegularExpression regularExpressionWithPattern:stringCapture
                                                                                          options:NSRegularExpressionCaseInsensitive
                                                                                            error:&error];
    NSArray *stringsArray = [regex_strings_result matchesInString:input options:0 range:NSMakeRange(0, [input length])] ;
    //////////////////////////NSLog/@"stringsArray: %@", stringsArray);
    for(NSTextCheckingResult* match in stringsArray) {
        //NSRange matchRange = [match replaceValueAtIndex:@(0) inPropertyWithKey:<#(nonnull NSString *)#> withValue:<#(nonnull id)#>];//[match rangeAtIndex:1];
        NSUInteger matchRange = [match numberOfRanges];
        //////////////////////////NSLog/@"match: %lu", matchRange);
        NSRange range = [match range];
        ////////////////////////////NSLog/@"match: %@", range);
        NSString* subString = [input substringWithRange:range];
        if(strings[@(range.location)] == nil) {
            strings[@(range.location)] = @{
                @"length": @(range.length),
                @"value": subString
            };
            //input = [self replaceWithHash:input range:range];
            //////////////NSLog(@"whitepace found!");
        }
    }
    [self setWhiteSpaces:strings];
}

@end
