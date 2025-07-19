//
//  JSParse.m
//  noobtest
//
//  Created by siggi jokull on 30.11.2022.
//

#import "JSParse.h"

@implementation JSParse


- (bool) containsIdentifier: (NSMutableDictionary*) parseObject {
    if(parseObject[@"sub_parse_objects"] != nil) {
        for(NSMutableDictionary* subParseObject in parseObject[@"sub_parse_objects"]) {
            if([subParseObject[@"label"] isEqualToString:@"Identifier"]) {
                parseObject[@"containsIdentifier"] = @true;
            }
            if([self containsIdentifier:subParseObject]) {
                parseObject[@"containsIdentifier"] = @true;
            }
        }
    }
    if(parseObject[@"containsIdentifier"] != nil) {
        return true;
    }
    return false;
}

- (bool) containsFunctionDefinition: (NSMutableDictionary*) parseObject {
    if(parseObject[@"sub_parse_objects"] != nil) {
        for(NSMutableDictionary* subParseObject in parseObject[@"sub_parse_objects"]) {
            if([subParseObject[@"label"] containsString:@"FunctionDefinition"]) {
                /* && subParseObject[@"text_value"] != nil && [subParseObject[@"text_value"] isEqualToString:@"this"]/*/
                parseObject[@"containsFunctionDefinition"] = @true;
            }
            if([self containsFunctionDefinition:subParseObject]) {
                parseObject[@"containsFunctionDefinition"] = @true;
            }
        }
    }
    if(parseObject[@"containsFunctionDefinition"] != nil) {
        return true;
    }
    return false;
}

- (bool) containsThis: (NSMutableDictionary*) parseObject {
    if(parseObject[@"sub_parse_objects"] != nil) {
        for(NSMutableDictionary* subParseObject in parseObject[@"sub_parse_objects"]) {
            if([subParseObject[@"label"] isEqualToString:@"Identifier"] && subParseObject[@"text_value"] != nil && [subParseObject[@"text_value"] isEqualToString:@"this"]) {
                parseObject[@"containsIdentifierThis"] = @true;
            }
            if([self containsThis:subParseObject]) {
                parseObject[@"containsIdentifierThis"] = @true;
            }
        }
    }
    if(parseObject[@"containsIdentifierThis"] != nil) {
        return true;
    }
    return false;
}

- (NSString*) preprocess: (NSString*) input {
    //////////////////NSLog(@"input length: %@", @([input length]));
    NSString* commentsRegex = @"\\/\\*.*?\\*\\/";
    NSError *error = NULL;
    NSRegularExpression *commentsRegexResult = [NSRegularExpression regularExpressionWithPattern:commentsRegex
                                                                                          options:NSRegularExpressionDotMatchesLineSeparators
                                                                                            error:&error];
    NSArray *commentsRegexItems = [commentsRegexResult matchesInString:input options:0 range:NSMakeRange(0, [input length])] ;
    ////NSLog(@"comments : %@", commentsRegexItems);
    long lastPosition = 0;
    long subtractions = 0;
    NSString* withoutComments = @"";
    
    //////NSLog(@"without Comments-- : %@", [input substringFromIndex:2650]);
    
    for(NSTextCheckingResult* match in commentsRegexItems) {
        //NSRange matchRange = [match replaceValueAtIndex:@(0) inPropertyWithKey:(nonnull NSString *) withValue:<#(nonnull id)#>];//[match rangeAtIndex:1];
        //NSUInteger matchRange = [match numberOfRanges];
        //////////////////////////NSLog/@"match: %lu", matchRange);
        NSRange range = [match range];
        NSRange withoutCommentsItem = NSMakeRange(lastPosition, range.location-lastPosition);
        NSString* subString = [input substringWithRange:withoutCommentsItem];
        subtractions += [subString length];
        //////NSLog(@"without Comments : %@", subString);
        withoutComments = [withoutComments stringByAppendingString:subString];
        lastPosition += withoutCommentsItem.length+range.length;
    }
    if(lastPosition < [input length]) {
        
        NSRange withoutCommentsItem = NSMakeRange(lastPosition, [input length]-lastPosition);
        NSString* subString = [input substringFromIndex:lastPosition];//[input substringWithRange:withoutCommentsItem];
        //////NSLog(@"without Comments : %@", subString);
        //////NSLog(@"without Comments : %@", [subString substringFromIndex:1650]);
        //withoutComments = subString;
        withoutComments = [withoutComments stringByAppendingString:subString];
    }
    
    input = withoutComments;
    //////NSLog(@"without Comments : %@", [input substringFromIndex:1650]);
    
    //////NSLog(@"input is : %@", input);
    
    [self setPreParsedTerminalIndex:[[NSMutableDictionary alloc] init]];
    NSArray* keywords = @[
        @"!/\\*.*?\\*/!s",
        @"<\\?\\s",
        @"\\s\\?>",
        //@"'.*'",
        //@"#",
        @"async\\s",
        @"private\\s",
        @"public\\s",
        @"protected\\s",
        @"function\\s",
        @"class\\s",
        @"return\\s",
        @"\\sextends\\s",
        @"\\sas\\s",
        @"else\\sif",
        @"new\\s",
        @"delete\\s",
        @"\\s+",
        @"#",
        //@"__HASH__"
    ];
    NSArray* replace = @[
        @"",
        @"",
        @"",
        //@"#",
        @"async#",
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
        @"delete#",
        @"",
        @" ",
        //@"__HASH__"
    ];
    int index = 0;
    NSString* regex_strings = @"'[^']*'";
    NSRegularExpression *regex_strings_result = [NSRegularExpression regularExpressionWithPattern:regex_strings
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *stringsArray = [regex_strings_result matchesInString:input options:0 range:NSMakeRange(0, [input length])] ;
    ////////////////////////////NSLog/@"stringsArray: %@", stringsArray);
    for(NSTextCheckingResult* match in stringsArray) {
        //NSRange matchRange = [match replaceValueAtIndex:@(0) inPropertyWithKey:<#(nonnull NSString *)#> withValue:<#(nonnull id)#>];//[match rangeAtIndex:1];
        NSUInteger matchRange = [match numberOfRanges];
        ////////////////////////////NSLog/@"match: %lu", matchRange);
        NSRange range = [match range];
        //////////////////////////////NSLog/@"match: %@", range);
        
        NSString* subString = [input substringWithRange:range];
        NSString* hashedString = [subString stringByReplacingOccurrencesOfString:@" " withString:@"#"];
        ////////////////////////////NSLog/@"sub: %@ - %@", subString, hashedString);
        input = [input stringByReplacingCharactersInRange:range withString:hashedString];
    }

    for(NSObject* regex in keywords) {
        //NSString *regexToReplaceRawLinks = @"(\\b(https?):\\/\\/[-A-Z0-9+&@#\\/%?=~_|!:,.;]*[-A-Z0-9+&@#\\/%=~_|])";
        NSString* regexToReplace = (NSString*)regex;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexToReplace
                                                                               options:nil
                                                                                 error:&error];
        
        //NSString *string = @"Sync your files to your Google Docs with a folder on your desktop.  Like Dropbox.  Good choice, Google storage is cheap. http://ow.ly/4OaOo";
        
        input = [regex stringByReplacingMatchesInString:input
                                                                   options:0
                                                                     range:NSMakeRange(0, [input length])
                                           withTemplate:replace[index]];
                                                              //withTemplate:@"<a href=\"$1\">$1</a>"];
        
        index++;
    }
    ////////////////////////NSLog/@"%@", input);
    //////////////////NSLog(@"terminalDict: %@", terminalDictionary);
    //////////////////NSLog(@"input length: %@", @([input length]));
    return input;
}


- (NSURL*) getContainer {
    
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSError *error;
    NSURL* containerURL = [fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask][0];
    
    return containerURL;
}

- (NSURL*) getSourceLocation {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL* containerURL = [self getContainer];
    containerURL = [containerURL URLByAppendingPathComponent:@"source"];
    if(![fileManager fileExistsAtPath:@([containerURL fileSystemRepresentation])]) {
        [fileManager createDirectoryAtURL:containerURL withIntermediateDirectories:true attributes:nil error:nil];
    }
    return containerURL;
}

- (void) start  {
    NSString* language = nil;
    [self setStoreStates:@[@"ValueObjectDereferenceWrap", @"ValueDereferenceWrap", @"FollowingObjectFunctionCall", @"ValueDereferenceContinue"]];
    [self setParseObjectItems:[[NSMutableDictionary alloc] init]];
    [self setCurrentStepStart:@0];
    [self setLastCurrentStepStart:@0];
    [self setSkipChars:[[NSMutableArray alloc] initWithArray:@[
        @"}",
        @"]",
        @")",
        @";"
        /*@"{",
        @"[",,*/
    ]]];
    [self setEndcharDefinitions:[[NSMutableDictionary alloc] initWithDictionary:@{
        
    }]];
    [self setRegexDefinitions:[[NSMutableDictionary alloc] initWithDictionary:@{
        @"VariableDefinition": @"\\$[_a-z0-9]+(\\=((\\$)?[a-z0-9(\\-\\>'\\[\\])]+))*",
        //@"VariableAssignment": @"(\\$)?[_a-z0-9\\-\\>'\\[\\]]+\\=",
        //@"VariableAssignmentAppend": @"\\$[a-z0-9(\\-\\>\\\"\\[\\])]+\\.\\=.+"
        //@"VariableAssignmentAppend": @"\\.\\=",
        /*@"ValueDivision": @"(\\$)?[_a-z0-9\\-\\>'\\[\\]]+\\/(\\$)?[_a-z0-9\\-\\>'\\[\\]]+",
        @"ValueModulo": @"(\\$)?[_a-z0-9\\-\\>'\\[\\]]+%(\\$)?[_a-z0-9\\-\\>'\\[\\]]+",
        @"ValueSubtraction": @"(\\$)?[_a-z0-9\\-\\>'\\[\\]]+\\-(\\$)?[_a-z0-9\\-\\>'\\[\\]]+",
        @"IdentifierAppend": @"(\\$)?[_a-z0-9\\-\\>'\\[\\]]+\\+(\\$)?[_a-z0-9\\-\\>'\\[\\]]+",*/
        @"ValueDivision": @".*\\/",
        @"ValueModulo": @".*%",
        @"ValueSubtraction": @".*\\-",
        @"ValueAppend": @".*\\+",
        @"ValueAppendString": @".*\\.",
        @"IdentifierPush": @".*\\[\\]\\=",
        //@"IdentifierPush": @".*\\[\\]\\=",
        @"NewValue": @"new\\s[_a-z0-9]+",
        @"ReturnStatement": @"return\\s",
        //@"IfStatement": @"if(.*){",
        
        @"ValueParanthesis": @"\\(.+\\)",
        @"ValueObjectDereference": @"^(?!(\\[|\\])$)[_a-z0-9]+\\[.+\\]$",
        @"ValueDereferenceContinueSub": @"\\[.+\\]|\\-\\>[_a-z0-9]+",
        @"FunctionDefinition": @"(async\\s)?function\\([\\$_a-z0-9\\,]*\\)\\{",
        @"NamedFunctionDefinition": @"(async\\s)?function\\s[_a-z0-9]+\\([\\$_a-z0-9\\,(\\=\\S)?]*\\)\\{",
        @"WhileLoop": @"while\\(.+\\)\\{",
        @"ForEach": @"foreach\\(.+as.+\\)\\{",
        @"ObjectDefinition": @"\\[.*\\]",
        @"FunctionCall": @"[_a-z0-9]+\\(.*\\)",
    }]];
    NSData* data = [[NSData alloc] initWithBase64EncodedString:@"eyJzdGFydF9zdGF0ZXMiOlsiU2NyaXB0U3RhdGVtZW50Il0sInN0YXRlcyI6eyJTY3JpcHRTdGF0ZW1lbnQiOltbeyJub25fdGVybWluYWwiOiJDbGFzc0RlZmluaXRpb24ifSx7Im5vbl90ZXJtaW5hbCI6IlNjcmlwdFN0YXRlbWVudCIsIm9wdCI6dHJ1ZX1dLFt7Im5vbl90ZXJtaW5hbCI6IlN0YXRlbWVudExpc3QifV1dLCJFeHRlbmRzU3RhdGVtZW50IjpbW3sibm9uX3Rlcm1pbmFsIjoiV2hpdGVTcGFjZSJ9LHsidGVybWluYWwiOiJleHRlbmRzIn0seyJub25fdGVybWluYWwiOiJXaGl0ZVNwYWNlIn0seyJub25fdGVybWluYWwiOiJDbGFzc0lkZW50aWZpZXJSZWZlcmVuY2UifV1dLCJBY2Nlc3NGbGFnIjpbW3sidGVybWluYWwiOiJwcml2YXRlIn1dLFt7InRlcm1pbmFsIjoicHJvdGVjdGVkIn1dLFt7InRlcm1pbmFsIjoicHVibGljIn1dXSwiQ2xhc3NCb2R5IjpbW3sibm9uX3Rlcm1pbmFsIjoiQWNjZXNzRmxhZyJ9LHsibm9uX3Rlcm1pbmFsIjoiV2hpdGVTcGFjZSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFyaWFibGVEZWZpbml0aW9uIn0seyJub25fdGVybWluYWwiOiJDbGFzc0JvZHkiLCJvcHQiOnRydWV9XSxbeyJub25fdGVybWluYWwiOiJBY2Nlc3NGbGFnIn0seyJub25fdGVybWluYWwiOiJXaGl0ZVNwYWNlIn0seyJub25fdGVybWluYWwiOiJOYW1lZEZ1bmN0aW9uRGVmaW5pdGlvbiJ9LHsibm9uX3Rlcm1pbmFsIjoiQ2xhc3NCb2R5Iiwib3B0Ijp0cnVlfV1dLCJDbGFzc0RlZmluaXRpb24iOltbeyJ0ZXJtaW5hbCI6ImNsYXNzIn0seyJub25fdGVybWluYWwiOiJXaGl0ZVNwYWNlIn0seyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyIn0seyJub25fdGVybWluYWwiOiJFeHRlbmRzU3RhdGVtZW50Iiwib3B0Ijp0cnVlfSx7InRlcm1pbmFsIjoieyJ9LHsibm9uX3Rlcm1pbmFsIjoiQ2xhc3NCb2R5Iiwib3B0Ijp0cnVlfSx7InRlcm1pbmFsIjoifSJ9XV0sIldoaXRlU3BhY2UiOltbeyJyZWdleCI6WyIgIl19XV0sIlNvdXJjZUNoYXJhY3RlciI6W10sIlN0YXRlbWVudCI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhcmlhYmxlRGVmaW5pdGlvbiJ9XSxbeyJub25fdGVybWluYWwiOiJWYXJpYWJsZUFzc2lnbm1lbnRHcm91cCJ9LHsidGVybWluYWwiOiI7In1dLFt7Im5vbl90ZXJtaW5hbCI6IlJldHVyblN0YXRlbWVudCJ9XSxbeyJub25fdGVybWluYWwiOiJWYWx1ZSJ9LHsidGVybWluYWwiOiI7In1dLFt7Im5vbl90ZXJtaW5hbCI6IldoaWxlTG9vcCJ9XSxbeyJub25fdGVybWluYWwiOiJJZlN0YXRlbWVudCJ9XSxbeyJub25fdGVybWluYWwiOiJGb3JMb29wIn1dLFt7Im5vbl90ZXJtaW5hbCI6IkZvckVhY2gifV1dLCJTdHJvbmdJbmVxdWFsVmFsdWVDb25kaXRpb24iOltbeyJub25fdGVybWluYWwiOiJWYWx1ZU5vQ29uZGl0aW9uIn0seyJ0ZXJtaW5hbCI6IiE9PSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiJ9XV0sIlN0cm9uZ0VxdWFsVmFsdWVDb25kaXRpb24iOltbeyJub25fdGVybWluYWwiOiJWYWx1ZU5vQ29uZGl0aW9uIn0seyJ0ZXJtaW5hbCI6Ij09PSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiJ9XV0sIkluZXF1YWxWYWx1ZUNvbmRpdGlvbiI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9Db25kaXRpb24ifSx7InRlcm1pbmFsIjoiIT0ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9Db25kaXRpb24ifV1dLCJFcXVhbFZhbHVlQ29uZGl0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiJ9LHsidGVybWluYWwiOiI9PSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiJ9XV0sIkdyZWF0ZXJWYWx1ZUNvbmRpdGlvbiI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9Db25kaXRpb24ifSx7InRlcm1pbmFsIjoiPiJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiJ9XV0sIkxlc3NWYWx1ZUNvbmRpdGlvbiI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9Db25kaXRpb24ifSx7InRlcm1pbmFsIjoiPCJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiJ9XV0sIkdyZWF0ZXJFcXVhbFZhbHVlQ29uZGl0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiJ9LHsidGVybWluYWwiOiI+PSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiJ9XV0sIkxlc3NFcXVhbFZhbHVlQ29uZGl0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiJ9LHsidGVybWluYWwiOiI8PSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiJ9XV0sIlZhbHVlQ29uZGl0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiU3Ryb25nRXF1YWxWYWx1ZUNvbmRpdGlvbiJ9XSxbeyJub25fdGVybWluYWwiOiJTdHJvbmdJbmVxdWFsVmFsdWVDb25kaXRpb24ifV0sW3sibm9uX3Rlcm1pbmFsIjoiRXF1YWxWYWx1ZUNvbmRpdGlvbiJ9XSxbeyJub25fdGVybWluYWwiOiJJbmVxdWFsVmFsdWVDb25kaXRpb24ifV0sW3sibm9uX3Rlcm1pbmFsIjoiR3JlYXRlclZhbHVlQ29uZGl0aW9uIn1dLFt7Im5vbl90ZXJtaW5hbCI6Ikxlc3NWYWx1ZUNvbmRpdGlvbiJ9XSxbeyJub25fdGVybWluYWwiOiJHcmVhdGVyRXF1YWxWYWx1ZUNvbmRpdGlvbiJ9XSxbeyJub25fdGVybWluYWwiOiJMZXNzRXF1YWxWYWx1ZUNvbmRpdGlvbiJ9XSxbeyJub25fdGVybWluYWwiOiJWYWx1ZU5vQ29uZGl0aW9uIn1dXSwiQ29uZGl0aW9uV3JhcCI6W1t7Im5vbl90ZXJtaW5hbCI6IkNvbmRpdGlvbiJ9XV0sIkNvbmRpdGlvbiI6W1t7Im5vbl90ZXJtaW5hbCI6IkFuZENvbmRpdGlvbiJ9XSxbeyJub25fdGVybWluYWwiOiJPckNvbmRpdGlvbiJ9XSxbeyJub25fdGVybWluYWwiOiJWYWx1ZUNvbmRpdGlvbiJ9XV0sIk9yQ29uZGl0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVDb25kaXRpb24ifSx7InRlcm1pbmFsIjoifHwifSx7Im5vbl90ZXJtaW5hbCI6IkNvbmRpdGlvbiJ9XV0sIkFuZENvbmRpdGlvbiI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhbHVlQ29uZGl0aW9uIn0seyJ0ZXJtaW5hbCI6IiYmIn0seyJub25fdGVybWluYWwiOiJDb25kaXRpb24ifV1dLCJJZlN0YXRlbWVudCI6W1t7InRlcm1pbmFsIjoiaWYifSx7InRlcm1pbmFsIjoiKCJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifSx7InRlcm1pbmFsIjoiKSJ9LHsidGVybWluYWwiOiJ7In0seyJub25fdGVybWluYWwiOiJTdGF0ZW1lbnRMaXN0Iiwib3B0Ijp0cnVlfSx7InRlcm1pbmFsIjoifSJ9LHsibm9uX3Rlcm1pbmFsIjoiRWxzZUlmU3RhdGVtZW50R3JvdXAiLCJvcHQiOnRydWV9XV0sIkVsc2VJZlN0YXRlbWVudEdyb3VwIjpbW3sibm9uX3Rlcm1pbmFsIjoiRWxzZUlmU3RhdGVtZW50In1dLFt7Im5vbl90ZXJtaW5hbCI6IkVsc2VTdGF0ZW1lbnQifV1dLCJFbHNlU3RhdGVtZW50IjpbW3sidGVybWluYWwiOiJlbHNlIn0seyJ0ZXJtaW5hbCI6InsifSx7Im5vbl90ZXJtaW5hbCI6IlN0YXRlbWVudExpc3QiLCJvcHQiOnRydWV9LHsidGVybWluYWwiOiJ9In1dXSwiRWxzZUlmU3RhdGVtZW50IjpbW3sidGVybWluYWwiOiJlbHNlIGlmIn0seyJ0ZXJtaW5hbCI6IigifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn0seyJ0ZXJtaW5hbCI6IikifSx7InRlcm1pbmFsIjoieyJ9LHsibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsIm9wdCI6dHJ1ZX0seyJ0ZXJtaW5hbCI6In0ifSx7Im5vbl90ZXJtaW5hbCI6IkVsc2VJZlN0YXRlbWVudEdyb3VwIiwib3B0Ijp0cnVlfV1dLCJSZXR1cm5TdGF0ZW1lbnQiOltbeyJ0ZXJtaW5hbCI6InJldHVybiJ9LHsibm9uX3Rlcm1pbmFsIjoiV2hpdGVTcGFjZSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifSx7InRlcm1pbmFsIjoiOyJ9XV0sIk5ld1N0YXRlbWVudCI6W1t7InRlcm1pbmFsIjoibmV3In0seyJub25fdGVybWluYWwiOiJXaGl0ZVNwYWNlIn0seyJub25fdGVybWluYWwiOiJDbGFzc0lkZW50aWZpZXJSZWZlcmVuY2UifSx7InRlcm1pbmFsIjoiKCJ9LHsibm9uX3Rlcm1pbmFsIjoiUGFyYW1ldGVyVmFsdWVzQ29uc3RydWN0b3IiLCJvcHQiOnRydWV9LHsidGVybWluYWwiOiIpIn1dXSwiU3RhdGVtZW50TGlzdCI6W1t7Im5vbl90ZXJtaW5hbCI6IlN0YXRlbWVudCJ9LHsibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsIm9wdCI6dHJ1ZX1dXSwiUmVzZXJ2ZWRLZXl3b3JkcyI6WyJjbGFzcyAiLCJwcml2YXRlICIsInB1YmxpYyAiLCJwcm90ZWN0ZWQgIiwidmFyICIsInRydWUiLCJmYWxzZSIsImZ1bmN0aW9uIiwiZnVuY3Rpb24oKSIsImZ1bmN0aW9uKCIsImF3YWl0ICIsImFzeW5jICIsInJldHVybiAiLCJuZXcgIiwiZGVsZXRlICIsImV4dGVuZHMgIl0sIkNsYXNzSWRlbnRpZmllclJlZmVyZW5jZSI6W1t7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXIifV1dLCJJZGVudGlmaWVyUmVmZXJlbmNlIjpbW3sidGVybWluYWwiOiIkIn0seyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyIn1dXSwiUHJlZml4ZWRJZGVudGlmaWVyIjpbW3sidGVybWluYWwiOiIkIn0seyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyIn0seyJ0ZXJtaW5hbCI6Ij0ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn1dLFt7InRlcm1pbmFsIjoiJCJ9LHsibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllciJ9XV0sIklkZW50aWZpZXIiOltbeyJyZWdleCI6WyJhIiwiYiIsImMiLCJkIiwiZSIsImYiLCJnIiwiaCIsImkiLCJqIiwiayIsImwiLCJtIiwibiIsIm8iLCJwIiwicSIsInIiLCJzIiwidCIsInUiLCJ2IiwidyIsIngiLCJ5IiwieiIsIjAiLCIxIiwiMiIsIjMiLCI0IiwiNSIsIjYiLCI3IiwiOCIsIjkiLCJfIl0sInN0b3BfcmVnZXgiOlsiJyIsIlwiIiwiLSIsIiAiLCI9IiwiKyIsIigiLCIpIiwieyIsIn0iLCIuIiwiPCIsIj4iLCImIiwifCIsIlsiLCJdIl0sIm5vdCI6IlJlc2VydmVkS2V5d29yZHMiLCJub3Rfc3RhcnRzd2l0aCI6Ik51bWJlciJ9XV0sIkZpcnN0QXJyYXlJdGVtIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWUifSx7Im5vbl90ZXJtaW5hbCI6IkFycmF5SXRlbXMiLCJvcHQiOnRydWV9XV0sIkFycmF5SXRlbXMiOltbeyJ0ZXJtaW5hbCI6IiwifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn0seyJub25fdGVybWluYWwiOiJBcnJheUl0ZW1zIiwib3B0Ijp0cnVlfV0sW3sidGVybWluYWwiOiIsIn1dXSwiVmFsdWVOb0NvbmRpdGlvbiI6W1t7Im5vbl90ZXJtaW5hbCI6Ik5VTEwifV0sW3sibm9uX3Rlcm1pbmFsIjoiTnVtYmVyIn1dLFt7Im5vbl90ZXJtaW5hbCI6IlN0cmluZyJ9XSxbeyJub25fdGVybWluYWwiOiJWYWx1ZUFwcGVuZCJ9XSxbeyJub25fdGVybWluYWwiOiJWYWx1ZUFwcGVuZFN0cmluZyJ9XSxbeyJub25fdGVybWluYWwiOiJCb29sZWFuIn1dLFt7Im5vbl90ZXJtaW5hbCI6IlZhcmlhYmxlQXNzaWdubWVudEdyb3VwIn1dLFt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlUGFyYW50aGVzaXMifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOZWdhdGVkIn1dLFt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlRGVyZWZlcmVuY2VXcmFwIn1dLFt7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifV1dLCJWYWx1ZU5vQWRkaXRpb24iOltbeyJub25fdGVybWluYWwiOiJOVUxMIn1dLFt7Im5vbl90ZXJtaW5hbCI6Ik51bWJlciJ9XSxbeyJub25fdGVybWluYWwiOiJTdHJpbmcifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFyaWFibGVBc3NpZ25tZW50R3JvdXAifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVQYXJhbnRoZXNpcyJ9XSxbeyJub25fdGVybWluYWwiOiJWYWx1ZURlcmVmZXJlbmNlV3JhcCJ9XSxbeyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyUmVmZXJlbmNlIn1dXSwiVmFsdWVJZGVudGlmaWVyIjpbW3sibm9uX3Rlcm1pbmFsIjoiRnVuY3Rpb25DYWxsUmVmZXJlbmNlIn1dLFt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlRGVyZWZlcmVuY2VXcmFwUmVmZXJlbmNlIn1dLFt7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifV1dLCJWYWx1ZUlkZW50aWZpZXIyIjpbW3sibm9uX3Rlcm1pbmFsIjoiRnVuY3Rpb25DYWxsUmVmZXJlbmNlIn1dLFt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlRGVyZWZlcmVuY2VXcmFwIn1dLFt7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifV1dLCJOVUxMIjpbW3sidGVybWluYWwiOiJOVUxMIn1dXSwiTmV3VmFsdWUiOltbeyJ0ZXJtaW5hbCI6Im4ifSx7InRlcm1pbmFsIjoiZSJ9LHsidGVybWluYWwiOiJ3In0seyJub25fdGVybWluYWwiOiJXaGl0ZVNwYWNlIn0seyJub25fdGVybWluYWwiOiJWYWx1ZUlkZW50aWZpZXJOZXdXcmFwMiJ9XV0sIlZhbHVlSWRlbnRpZmllck5ld1dyYXAyIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVJZGVudGlmaWVyMiJ9XV0sIlZhbHVlSWRlbnRpZmllck5ld1dyYXAiOltbeyJub25fdGVybWluYWwiOiJGdW5jdGlvbkNhbGxSZWZlcmVuY2UifV1dLCJWYWx1ZU5vRGVyZWZlcmVuY2UiOltbeyJub25fdGVybWluYWwiOiJGdW5jdGlvbkRlZmluaXRpb24ifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVQYXJhbnRoZXNpcyJ9XSxbeyJub25fdGVybWluYWwiOiJTdHJpbmcifV0sW3sibm9uX3Rlcm1pbmFsIjoiT2JqZWN0RGVmaW5pdGlvbiJ9XV0sIlZhbHVlTXVsdGlwbGljYXRpb24iOltbeyJub25fdGVybWluYWwiOiJWYWx1ZU5vQWRkaXRpb24ifSx7InRlcm1pbmFsIjoiKiJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifV1dLCJWYWx1ZSI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTXVsdGlwbGljYXRpb24ifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVBcHBlbmQifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVBcHBlbmRTdHJpbmcifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVTdWJ0cmFjdGlvbiJ9XSxbeyJub25fdGVybWluYWwiOiJWYWx1ZURpdmlzaW9uIn1dLFt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTW9kdWxvIn1dLFt7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJQdXNoIn1dLFt7Im5vbl90ZXJtaW5hbCI6IkJvb2xlYW5BbmRDb25kaXRpb24ifV0sW3sibm9uX3Rlcm1pbmFsIjoiTnVtYmVyIn1dLFt7Im5vbl90ZXJtaW5hbCI6IlN0cmluZyJ9XSxbeyJub25fdGVybWluYWwiOiJOZXdTdGF0ZW1lbnQifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVEZXJlZmVyZW5jZVdyYXAifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFyaWFibGVBc3NpZ25tZW50R3JvdXAifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVQYXJhbnRoZXNpcyJ9XSxbeyJub25fdGVybWluYWwiOiJWYWx1ZU5lZ2F0ZWQifV0sW3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllclJlZmVyZW5jZSJ9XSxbeyJub25fdGVybWluYWwiOiJEZWxldGVWYWx1ZURlcmVmZXJlbmNlIn1dLFt7Im5vbl90ZXJtaW5hbCI6IkFycmF5U3ByZWFkT3BlcmF0b3IifV0sW3sibm9uX3Rlcm1pbmFsIjoiT2JqZWN0U3ByZWFkT3BlcmF0b3IifV1dLCJJZGVudGlmaWVyUHVzaCI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhbHVlSWRlbnRpZmllciJ9LHsidGVybWluYWwiOiJbXT0ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn1dXSwiT2JqZWN0U3ByZWFkT3BlcmF0b3IiOltbeyJ0ZXJtaW5hbCI6InsuLi4ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlSWRlbnRpZmllciJ9LHsidGVybWluYWwiOiJ9In1dXSwiQXJyYXlTcHJlYWRPcGVyYXRvciI6W1t7InRlcm1pbmFsIjoiWy4uLiJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVJZGVudGlmaWVyIn0seyJ0ZXJtaW5hbCI6Il0ifV1dLCJEZWxldGVWYWx1ZURlcmVmZXJlbmNlIjpbW3sidGVybWluYWwiOiJkZWxldGUifSx7Im5vbl90ZXJtaW5hbCI6IldoaXRlU3BhY2UifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlSWRlbnRpZmllciJ9XV0sIlR5cGVvZlZhbHVlIjpbW3sidGVybWluYWwiOiJ0eXBlb2YifSx7Im5vbl90ZXJtaW5hbCI6IldoaXRlU3BhY2UifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9BZGRpdGlvbiJ9XV0sIlZhbHVlQXBwZW5kU3RyaW5nIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0FkZGl0aW9uIn0seyJ0ZXJtaW5hbCI6Ii4ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn1dXSwiVmFsdWVBcHBlbmQiOltbeyJub25fdGVybWluYWwiOiJWYWx1ZU5vQWRkaXRpb24ifSx7InRlcm1pbmFsIjoiKyJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifV1dLCJPYmplY3RDYWxsQXBwZW5kIjpbW3sibm9uX3Rlcm1pbmFsIjoiT2JqZWN0Q2FsbFdyYXAifSx7InRlcm1pbmFsIjoiKyJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifV1dLCJPYmplY3RDYWxsV3JhcCI6W1t7Im5vbl90ZXJtaW5hbCI6IkF3YWl0Iiwib3B0Ijp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6Ik9iamVjdENhbGwifV1dLCJPYmplY3RDYWxsQ29udGludWUiOltbeyJ0ZXJtaW5hbCI6Ii4ifSx7Im5vbl90ZXJtaW5hbCI6Ik9iamVjdENhbGwifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZSIsIm9wdCI6dHJ1ZX1dLFt7InRlcm1pbmFsIjoiLiJ9LHsibm9uX3Rlcm1pbmFsIjoiT2JqZWN0RnVuY3Rpb25DYWxsVmFsdWUifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZSIsIm9wdCI6dHJ1ZX1dLFt7InRlcm1pbmFsIjoiLiJ9LHsibm9uX3Rlcm1pbmFsIjoiT2JqZWN0SWRlbnRpZmllclJlZmVyZW5jZSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlIiwib3B0Ijp0cnVlfV1dLCJPYmplY3RDYWxsIjpbW3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllclJlZmVyZW5jZSJ9LHsidGVybWluYWwiOiIuIn0seyJub25fdGVybWluYWwiOiJPYmplY3RDYWxsIn1dLFt7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifSx7InRlcm1pbmFsIjoiLiJ9LHsibm9uX3Rlcm1pbmFsIjoiT2JqZWN0RnVuY3Rpb25DYWxsVmFsdWUifV0sW3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllclJlZmVyZW5jZSJ9LHsidGVybWluYWwiOiIuIn0seyJub25fdGVybWluYWwiOiJPYmplY3RDYWxsVmFsdWUifV1dLCJPYmplY3RDYWxsVmFsdWUiOltbeyJub25fdGVybWluYWwiOiJPYmplY3RJZGVudGlmaWVyUmVmZXJlbmNlIn1dXSwiT2JqZWN0RnVuY3Rpb25DYWxsVmFsdWUiOltbeyJub25fdGVybWluYWwiOiJPYmplY3RGdW5jdGlvbkNhbGwifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVPYmplY3REZXJlZmVyZW5jZVdyYXAifV1dLCJPYmplY3RJZGVudGlmaWVyUmVmZXJlbmNlIjpbW3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllciJ9XV0sIkZ1bmN0aW9uQ2FsbFN1YnRyYWN0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiRnVuY3Rpb25DYWxsIn0seyJ0ZXJtaW5hbCI6Ii0ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn1dXSwiRnVuY3Rpb25DYWxsRGl2aXNpb24iOltbeyJub25fdGVybWluYWwiOiJGdW5jdGlvbkNhbGwifSx7InRlcm1pbmFsIjoiXC8ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn1dXSwiRnVuY3Rpb25DYWxsQXBwZW5kIjpbW3sibm9uX3Rlcm1pbmFsIjoiRnVuY3Rpb25DYWxsIn0seyJ0ZXJtaW5hbCI6IisifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn1dXSwiQXdhaXQiOltbeyJ0ZXJtaW5hbCI6ImF3YWl0In0seyJub25fdGVybWluYWwiOiJXaGl0ZVNwYWNlIn1dXSwiT2JqZWN0RnVuY3Rpb25DYWxsIjpbW3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllclJlZmVyZW5jZSJ9LHsidGVybWluYWwiOiIoIn0seyJub25fdGVybWluYWwiOiJQYXJhbWV0ZXJWYWx1ZXMiLCJvcHQiOnRydWV9LHsidGVybWluYWwiOiIpIn0seyJub25fdGVybWluYWwiOiJGb2xsb3dpbmdPYmplY3RGdW5jdGlvbkNhbGwiLCJvcHQiOnRydWV9XSxbeyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyUmVmZXJlbmNlIn0seyJ0ZXJtaW5hbCI6IigifSx7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlclZhbHVlcyIsIm9wdCI6dHJ1ZX0seyJ0ZXJtaW5hbCI6IikifSx7Im5vbl90ZXJtaW5hbCI6Ik9iamVjdENhbGxDb250aW51ZSIsIm9wdCI6dHJ1ZX1dXSwiRm9sbG93aW5nT2JqZWN0RnVuY3Rpb25DYWxsUmVmZXJlbmNlIjpbW3sidGVybWluYWwiOiIoIn0seyJub25fdGVybWluYWwiOiJQYXJhbWV0ZXJWYWx1ZXMiLCJvcHQiOnRydWV9LHsidGVybWluYWwiOiIpIn1dXSwiRm9sbG93aW5nT2JqZWN0RnVuY3Rpb25DYWxsIjpbW3sidGVybWluYWwiOiIoIn0seyJub25fdGVybWluYWwiOiJQYXJhbWV0ZXJWYWx1ZXMiLCJvcHQiOnRydWV9LHsidGVybWluYWwiOiIpIn0seyJub25fdGVybWluYWwiOiJGb2xsb3dpbmdPYmplY3RGdW5jdGlvbkNhbGwiLCJvcHQiOnRydWV9XSxbeyJ0ZXJtaW5hbCI6IigifSx7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlclZhbHVlcyIsIm9wdCI6dHJ1ZX0seyJ0ZXJtaW5hbCI6IikifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZSIsIm9wdCI6dHJ1ZX1dXSwiSW5saW5lRnVuY3Rpb25EZWZpbml0aW9uQ2FsbCI6W1t7Im5vbl90ZXJtaW5hbCI6IkZ1bmN0aW9uRGVmaW5pdGlvbk5vQXN5bmMifSx7InRlcm1pbmFsIjoiKCJ9LHsibm9uX3Rlcm1pbmFsIjoiUGFyYW1ldGVyVmFsdWVzIiwib3B0Ijp0cnVlfSx7InRlcm1pbmFsIjoiKSJ9LHsibm9uX3Rlcm1pbmFsIjoiRm9sbG93aW5nT2JqZWN0RnVuY3Rpb25DYWxsIiwib3B0Ijp0cnVlfV1dLCJGdW5jdGlvbkNhbGxSZWZlcmVuY2UiOltbeyJub25fdGVybWluYWwiOiJBd2FpdCIsIm9wdCI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyUmVmZXJlbmNlIn0seyJ0ZXJtaW5hbCI6IigifSx7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlclZhbHVlcyIsIm9wdCI6dHJ1ZX0seyJ0ZXJtaW5hbCI6IikifSx7Im5vbl90ZXJtaW5hbCI6IkZvbGxvd2luZ09iamVjdEZ1bmN0aW9uQ2FsbCIsIm9wdCI6dHJ1ZX1dLFt7Im5vbl90ZXJtaW5hbCI6IkF3YWl0Iiwib3B0Ijp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifSx7InRlcm1pbmFsIjoiKCJ9LHsibm9uX3Rlcm1pbmFsIjoiUGFyYW1ldGVyVmFsdWVzIiwib3B0Ijp0cnVlfSx7InRlcm1pbmFsIjoiKSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlIiwib3B0Ijp0cnVlfV1dLCJGdW5jdGlvbkNhbGwiOltbeyJub25fdGVybWluYWwiOiJBd2FpdCIsIm9wdCI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyUmVmZXJlbmNlIn0seyJ0ZXJtaW5hbCI6IigifSx7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlclZhbHVlcyIsIm9wdCI6dHJ1ZX0seyJ0ZXJtaW5hbCI6IikifSx7Im5vbl90ZXJtaW5hbCI6IkZvbGxvd2luZ09iamVjdEZ1bmN0aW9uQ2FsbCIsIm9wdCI6dHJ1ZX1dLFt7Im5vbl90ZXJtaW5hbCI6IkF3YWl0Iiwib3B0Ijp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifSx7InRlcm1pbmFsIjoiKCJ9LHsibm9uX3Rlcm1pbmFsIjoiUGFyYW1ldGVyVmFsdWVzIiwib3B0Ijp0cnVlfSx7InRlcm1pbmFsIjoiKSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlIiwib3B0Ijp0cnVlfV1dLCJQYXJhbWV0ZXJWYWx1ZXNDb25zdHJ1Y3RvciI6W1t7Im5vbl90ZXJtaW5hbCI6IkZpcnN0UGFyYW1ldGVyVmFsdWUifSx7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlclZhbHVlIiwib3B0Ijp0cnVlfV1dLCJQYXJhbWV0ZXJWYWx1ZXMiOltbeyJub25fdGVybWluYWwiOiJGaXJzdFBhcmFtZXRlclZhbHVlIn0seyJub25fdGVybWluYWwiOiJQYXJhbWV0ZXJWYWx1ZSIsIm9wdCI6dHJ1ZX1dXSwiRmlyc3RQYXJhbWV0ZXJWYWx1ZSI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn0seyJub25fdGVybWluYWwiOiJQYXJhbWV0ZXJWYWx1ZSIsIm9wdCI6dHJ1ZX1dXSwiUGFyYW1ldGVyVmFsdWUiOltbeyJ0ZXJtaW5hbCI6IiwifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn0seyJub25fdGVybWluYWwiOiJQYXJhbWV0ZXJWYWx1ZSIsIm9wdCI6dHJ1ZX1dXSwiRnVuY3Rpb25MZWZ0IjpbXSwiT2JqZWN0U3RhdGVtZW50TGlzdCI6W1t7Im5vbl90ZXJtaW5hbCI6IkZpcnN0T2JqZWN0U3RhdGVtZW50In0seyJub25fdGVybWluYWwiOiJPYmplY3RTdGF0ZW1lbnQiLCJvcHQiOnRydWV9XV0sIlByb3BlcnR5TmFtZSI6W1t7Im5vbl90ZXJtaW5hbCI6Ik51bWJlciJ9XSxbeyJub25fdGVybWluYWwiOiJTdHJpbmcifV1dLCJGaXJzdE9iamVjdFN0YXRlbWVudCI6W1t7Im5vbl90ZXJtaW5hbCI6IlByb3BlcnR5TmFtZSJ9LHsidGVybWluYWwiOiI9PiJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWUifV1dLCJPYmplY3RTdGF0ZW1lbnQiOltbeyJ0ZXJtaW5hbCI6IiwifSx7Im5vbl90ZXJtaW5hbCI6IlByb3BlcnR5TmFtZSJ9LHsidGVybWluYWwiOiI9PiJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifSx7Im5vbl90ZXJtaW5hbCI6Ik9iamVjdFN0YXRlbWVudCIsIm9wdCI6dHJ1ZX1dLFt7InRlcm1pbmFsIjoiLCJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifSx7Im5vbl90ZXJtaW5hbCI6Ik9iamVjdFN0YXRlbWVudCIsIm9wdCI6dHJ1ZX1dXSwiT2JqZWN0RGVmaW5pdGlvbiI6W1t7InRlcm1pbmFsIjoiWyJ9LHsibm9uX3Rlcm1pbmFsIjoiT2JqZWN0U3RhdGVtZW50TGlzdCIsIm9wdCI6dHJ1ZX0seyJ0ZXJtaW5hbCI6Il0ifV1dLCJBc3luY0Z1bmN0aW9uUHJlZml4IjpbW3sidGVybWluYWwiOiJhc3luYyJ9LHsibm9uX3Rlcm1pbmFsIjoiV2hpdGVTcGFjZSJ9XV0sIkZvckVhY2giOltbeyJ0ZXJtaW5hbCI6ImZvcmVhY2gifSx7InRlcm1pbmFsIjoiKCJ9LHsibm9uX3Rlcm1pbmFsIjoiRm9yZWFjaFNldHRpbmdzIn0seyJ0ZXJtaW5hbCI6IikifSx7InRlcm1pbmFsIjoieyJ9LHsibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsIm9wdCI6dHJ1ZX0seyJ0ZXJtaW5hbCI6In0ifV1dLCJGb3JlYWNoU2V0dGluZ3MiOltbeyJub25fdGVybWluYWwiOiJGb3JlYWNoU2V0dGluZ3MxIn1dLFt7Im5vbl90ZXJtaW5hbCI6IkZvcmVhY2hTZXR0aW5nczIifV1dLCJGb3JlYWNoU2V0dGluZ3MyIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWUifSx7Im5vbl90ZXJtaW5hbCI6IldoaXRlU3BhY2UifSx7InRlcm1pbmFsIjoiYXMifSx7Im5vbl90ZXJtaW5hbCI6IldoaXRlU3BhY2UifSx7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifV1dLCJGb3JlYWNoU2V0dGluZ3MxIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWUifSx7Im5vbl90ZXJtaW5hbCI6IldoaXRlU3BhY2UifSx7InRlcm1pbmFsIjoiYXMifSx7Im5vbl90ZXJtaW5hbCI6IldoaXRlU3BhY2UifSx7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifSx7InRlcm1pbmFsIjoiPT4ifSx7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifV1dLCJLZXlBcnJvdyI6W1t7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifSx7InRlcm1pbmFsIjoiPT4ifV1dLCJGb3JMb29wIjpbW3sidGVybWluYWwiOiJmb3IifSx7InRlcm1pbmFsIjoiKCJ9LHsibm9uX3Rlcm1pbmFsIjoiRm9yU2V0dGluZ3MifSx7InRlcm1pbmFsIjoiKSJ9LHsidGVybWluYWwiOiJ7In0seyJub25fdGVybWluYWwiOiJTdGF0ZW1lbnRMaXN0Iiwib3B0Ijp0cnVlfSx7InRlcm1pbmFsIjoifSJ9XV0sIkZvclNldHRpbmdzIjpbW3sibm9uX3Rlcm1pbmFsIjoiRm9yIn1dXSwiRm9yIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFyaWFibGVEZWZpbml0aW9uIn0seyJub25fdGVybWluYWwiOiJWYWx1ZSJ9LHsidGVybWluYWwiOiI7In0seyJub25fdGVybWluYWwiOiJWYXJpYWJsZUFzc2lnbm1lbnRHcm91cCJ9XV0sIkZvck9mIjpbW3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllclJlZmVyZW5jZSJ9LHsibm9uX3Rlcm1pbmFsIjoiV2hpdGVTcGFjZSJ9LHsidGVybWluYWwiOiJvZiJ9LHsibm9uX3Rlcm1pbmFsIjoiV2hpdGVTcGFjZSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifV1dLCJGb3JJbiI6W1t7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifSx7Im5vbl90ZXJtaW5hbCI6IldoaXRlU3BhY2UifSx7InRlcm1pbmFsIjoiaW4ifSx7Im5vbl90ZXJtaW5hbCI6IldoaXRlU3BhY2UifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn1dXSwiV2hpbGVMb29wIjpbW3sidGVybWluYWwiOiJ3aGlsZSJ9LHsidGVybWluYWwiOiIoIn0seyJub25fdGVybWluYWwiOiJDb25kaXRpb24ifSx7InRlcm1pbmFsIjoiKSJ9LHsidGVybWluYWwiOiJ7In0seyJub25fdGVybWluYWwiOiJTdGF0ZW1lbnRMaXN0In0seyJ0ZXJtaW5hbCI6In0ifV1dLCJGdW5jdGlvbkRlZmluaXRpb25Ob0FzeW5jIjpbW3sidGVybWluYWwiOiJmdW5jdGlvbiJ9LHsidGVybWluYWwiOiIoIn0seyJub25fdGVybWluYWwiOiJQYXJhbWV0ZXJJbnB1dHMiLCJvcHQiOnRydWV9LHsidGVybWluYWwiOiIpIn0seyJ0ZXJtaW5hbCI6InsifSx7Im5vbl90ZXJtaW5hbCI6IlN0YXRlbWVudExpc3QiLCJvcHQiOnRydWV9LHsidGVybWluYWwiOiJ9In1dXSwiTmFtZWRGdW5jdGlvbkRlZmluaXRpb24iOltbeyJ0ZXJtaW5hbCI6ImZ1bmN0aW9uIn0seyJub25fdGVybWluYWwiOiJXaGl0ZVNwYWNlIn0seyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyIn0seyJ0ZXJtaW5hbCI6IigifSx7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlcklucHV0cyIsIm9wdCI6dHJ1ZX0seyJ0ZXJtaW5hbCI6IikifSx7InRlcm1pbmFsIjoieyJ9LHsibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsIm9wdCI6dHJ1ZX0seyJ0ZXJtaW5hbCI6In0ifV1dLCJGdW5jdGlvbkRlZmluaXRpb24iOltbeyJub25fdGVybWluYWwiOiJBc3luY0Z1bmN0aW9uUHJlZml4Iiwib3B0Ijp0cnVlfSx7InRlcm1pbmFsIjoiZnVuY3Rpb24ifSx7InRlcm1pbmFsIjoiKCJ9LHsibm9uX3Rlcm1pbmFsIjoiUGFyYW1ldGVySW5wdXRzIiwib3B0Ijp0cnVlfSx7InRlcm1pbmFsIjoiKSJ9LHsidGVybWluYWwiOiJ7In0seyJub25fdGVybWluYWwiOiJTdGF0ZW1lbnRMaXN0Iiwib3B0Ijp0cnVlfSx7InRlcm1pbmFsIjoifSJ9XV0sIlBhcmFtZXRlcklucHV0cyI6W1t7Im5vbl90ZXJtaW5hbCI6IkZpcnN0UGFyYW1ldGVySW5wdXQifSx7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlcklucHV0Iiwib3B0Ijp0cnVlfV1dLCJGaXJzdFBhcmFtZXRlcklucHV0IjpbW3sibm9uX3Rlcm1pbmFsIjoiUHJlZml4ZWRJZGVudGlmaWVyIn1dXSwiUGFyYW1ldGVySW5wdXQiOltbeyJ0ZXJtaW5hbCI6IiwifSx7Im5vbl90ZXJtaW5hbCI6IlByZWZpeGVkSWRlbnRpZmllciJ9LHsibm9uX3Rlcm1pbmFsIjoiUGFyYW1ldGVySW5wdXQiLCJvcHQiOnRydWV9XV0sIkJvb2xlYW5BZGRpdGlvbiI6W1t7Im5vbl90ZXJtaW5hbCI6IkJvb2xlYW4ifSx7InRlcm1pbmFsIjoiKyJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifV1dLCJCb29sZWFuQW5kQ29uZGl0aW9uV3JhcE5lZ2F0ZWQiOltbeyJ0ZXJtaW5hbCI6IiEifSx7Im5vbl90ZXJtaW5hbCI6IkJvb2xlYW5BbmRDb25kaXRpb24ifV1dLCJCb29sZWFuQW5kQ29uZGl0aW9uV3JhcCI6W1t7Im5vbl90ZXJtaW5hbCI6IkJvb2xlYW5BbmRDb25kaXRpb25XcmFwTmVnYXRlZCJ9XSxbeyJub25fdGVybWluYWwiOiJCb29sZWFuQW5kQ29uZGl0aW9uIn1dXSwiQm9vbGVhbkFuZENvbmRpdGlvbiI6W1t7Im5vbl90ZXJtaW5hbCI6IkNvbmRpdGlvbiJ9XSxbeyJub25fdGVybWluYWwiOiJCb29sZWFuIn1dXSwiQm9vbGVhbiI6W1t7InRlcm1pbmFsIjoidHJ1ZSJ9XSxbeyJ0ZXJtaW5hbCI6ImZhbHNlIn1dXSwiVmFsdWVQYXJhbnRoZXNpc1N1YnRyYWN0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVQYXJhbnRoZXNpcyJ9LHsidGVybWluYWwiOiItIn0seyJub25fdGVybWluYWwiOiJWYWx1ZSJ9XV0sIlZhbHVlUGFyYW50aGVzaXNEaXZpc2lvbiI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhbHVlUGFyYW50aGVzaXMifSx7InRlcm1pbmFsIjoiXC8ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn1dXSwiVmFsdWVQYXJhbnRoZXNpc0FkZGl0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVQYXJhbnRoZXNpcyJ9LHsidGVybWluYWwiOiIrIn0seyJub25fdGVybWluYWwiOiJWYWx1ZSJ9XV0sIlZhbHVlTmVnYXRpdmUiOltbeyJ0ZXJtaW5hbCI6Ii0ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9BZGRpdGlvbiJ9XV0sIlZhbHVlTmVnYXRlZCI6W1t7InRlcm1pbmFsIjoiISJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiJ9XV0sIlZhbHVlRGVyZWZlcmVuY2VXcmFwUmVmZXJlbmNlIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVEZXJlZmVyZW5jZSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlIiwib3B0Ijp0cnVlfV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVEZXJlZmVyZW5jZSJ9LHsibm9uX3Rlcm1pbmFsIjoiRm9sbG93aW5nT2JqZWN0RnVuY3Rpb25DYWxsIiwib3B0Ijp0cnVlfV1dLCJWYWx1ZURlcmVmZXJlbmNlV3JhcCI6W1t7Im5vbl90ZXJtaW5hbCI6IkF3YWl0Iiwib3B0Ijp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlRGVyZWZlcmVuY2UifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZSIsIm9wdCI6dHJ1ZX1dLFt7Im5vbl90ZXJtaW5hbCI6IkF3YWl0Iiwib3B0Ijp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlRGVyZWZlcmVuY2UifSx7Im5vbl90ZXJtaW5hbCI6IkZvbGxvd2luZ09iamVjdEZ1bmN0aW9uQ2FsbCIsIm9wdCI6dHJ1ZX1dXSwiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlU3ViIjpbW3sidGVybWluYWwiOiJbIn0seyJub25fdGVybWluYWwiOiJWYWx1ZSJ9LHsidGVybWluYWwiOiJdIn1dLFt7InRlcm1pbmFsIjoiLT4ifSx7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXIifV1dLCJWYWx1ZURlcmVmZXJlbmNlQ29udGludWUiOltbeyJub25fdGVybWluYWwiOiJWYWx1ZURlcmVmZXJlbmNlQ29udGludWVTdWIifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZSIsIm9wdCI6dHJ1ZX1dLFt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZVN1YiJ9LHsibm9uX3Rlcm1pbmFsIjoiRm9sbG93aW5nT2JqZWN0RnVuY3Rpb25DYWxsIiwib3B0Ijp0cnVlfV1dLCJWYWx1ZURlcmVmZXJlbmNlIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0RlcmVmZXJlbmNlIn0seyJub25fdGVybWluYWwiOiJWYWx1ZURlcmVmZXJlbmNlQ29udGludWVTdWIiLCJvcHQiOnRydWV9XSxbeyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyUmVmZXJlbmNlIn0seyJub25fdGVybWluYWwiOiJWYWx1ZURlcmVmZXJlbmNlQ29udGludWVTdWIifV0sW3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllclJlZmVyZW5jZSJ9XV0sIlZhbHVlT2JqZWN0RGVyZWZlcmVuY2VXcmFwIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVPYmplY3REZXJlZmVyZW5jZSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlIn1dLFt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlT2JqZWN0RGVyZWZlcmVuY2UifSx7Im5vbl90ZXJtaW5hbCI6Ik9iamVjdENhbGxDb250aW51ZSIsIm9wdCI6dHJ1ZX1dXSwiVmFsdWVPYmplY3REZXJlZmVyZW5jZSI6W1t7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UifSx7InRlcm1pbmFsIjoiWyJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifSx7InRlcm1pbmFsIjoiXSJ9XV0sIlZhbHVlUGFyYW50aGVzaXMiOltbeyJ0ZXJtaW5hbCI6IigifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn0seyJ0ZXJtaW5hbCI6IikifV1dLCJJZGVudGlmaWVyQXBwZW5kIjpbW3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllclJlZmVyZW5jZSJ9LHsidGVybWluYWwiOiIrIn0seyJub25fdGVybWluYWwiOiJWYWx1ZSJ9XV0sIlN0cmluZ0FwcGVuZCI6W1t7Im5vbl90ZXJtaW5hbCI6IlN0cmluZyJ9LHsidGVybWluYWwiOiIrIn0seyJub25fdGVybWluYWwiOiJWYWx1ZSJ9XV0sIlN0cmluZyI6W1t7InRlcm1pbmFsIjoiJyJ9LHsibm9uX3Rlcm1pbmFsIjoiU3RyaW5nQ29udGVudCIsIm9wdCI6dHJ1ZX0seyJ0ZXJtaW5hbCI6IicifV1dLCJTdHJpbmdDb250ZW50IjpbW3sicmVnZXgiOlsiYWxsIl0sInN0b3BfcmVnZXgiOlsiXCIiLCInIl0sImRlbGltaXRfcmVnZXgiOltdfV1dLCJWYWx1ZVN1YnRyYWN0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0FkZGl0aW9uIiwib3B0Ijp0cnVlfSx7InRlcm1pbmFsIjoiLSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifV1dLCJWYWx1ZU1vZHVsbyI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9BZGRpdGlvbiJ9LHsidGVybWluYWwiOiIlIn0seyJub25fdGVybWluYWwiOiJWYWx1ZSJ9XV0sIlZhbHVlRGl2aXNpb24iOltbeyJub25fdGVybWluYWwiOiJWYWx1ZU5vQWRkaXRpb24ifSx7InRlcm1pbmFsIjoiXC8ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn1dXSwiTnVtYmVyIjpbW3sicmVnZXgiOlsiMCIsIjEiLCIyIiwiMyIsIjQiLCI1IiwiNiIsIjciLCI4IiwiOSJdfV1dLCJWYXJpYWJsZUFzc2lnbm1lbnRHcm91cCI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhcmlhYmxlQXNzaWdubWVudEluY3JlbWVudCJ9XSxbeyJub25fdGVybWluYWwiOiJWYXJpYWJsZUFzc2lnbm1lbnREZWNyZW1lbnQifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFyaWFibGVBc3NpZ25tZW50QWRkaXRpb24ifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFyaWFibGVBc3NpZ25tZW50U3VidHJhY3Rpb24ifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFyaWFibGVBc3NpZ25tZW50TXVsdGlwbGljYXRpb24ifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFyaWFibGVBc3NpZ25tZW50RGl2aXNpb24ifV0sW3sibm9uX3Rlcm1pbmFsIjoiVmFyaWFibGVBc3NpZ25tZW50QXBwZW5kIn1dLFt7Im5vbl90ZXJtaW5hbCI6IlZhcmlhYmxlQXNzaWdubWVudCJ9XV0sIlZhcmlhYmxlQXNzaWdubWVudEluY3JlbWVudCI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhbHVlSWRlbnRpZmllciJ9LHsidGVybWluYWwiOiIrKyJ9XV0sIlZhcmlhYmxlQXNzaWdubWVudERlY3JlbWVudCI6W1t7Im5vbl90ZXJtaW5hbCI6IlZhbHVlSWRlbnRpZmllciJ9LHsidGVybWluYWwiOiItLSJ9XV0sIlZhcmlhYmxlQXNzaWdubWVudEFkZGl0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVJZGVudGlmaWVyIn0seyJ0ZXJtaW5hbCI6Iis9In0seyJub25fdGVybWluYWwiOiJWYWx1ZSJ9XV0sIlZhcmlhYmxlQXNzaWdubWVudFN1YnRyYWN0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVJZGVudGlmaWVyIn0seyJ0ZXJtaW5hbCI6Ii09In0seyJub25fdGVybWluYWwiOiJWYWx1ZSJ9XV0sIlZhcmlhYmxlQXNzaWdubWVudE11bHRpcGxpY2F0aW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVJZGVudGlmaWVyIn0seyJ0ZXJtaW5hbCI6Iio9In0seyJub25fdGVybWluYWwiOiJWYWx1ZSJ9XV0sIlZhcmlhYmxlQXNzaWdubWVudERpdmlzaW9uIjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVJZGVudGlmaWVyIn0seyJ0ZXJtaW5hbCI6IlwvPSJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUifV1dLCJWYXJpYWJsZUFzc2lnbm1lbnRBcHBlbmQiOltbeyJub25fdGVybWluYWwiOiJWYWx1ZUlkZW50aWZpZXIifSx7InRlcm1pbmFsIjoiLj0ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn1dXSwiVmFyaWFibGVBc3NpZ25tZW50IjpbW3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVJZGVudGlmaWVyIn0seyJ0ZXJtaW5hbCI6Ij0ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn1dXSwiVmFyaWFibGVEZWZpbml0aW9uIjpbW3sidGVybWluYWwiOiIkIn0seyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyIn0seyJ0ZXJtaW5hbCI6Ij0ifSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIn0seyJ0ZXJtaW5hbCI6IjsifV0sW3sidGVybWluYWwiOiIkIn0seyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyIn0seyJ0ZXJtaW5hbCI6IjsifV1dfX0=" options:0];
    NSError* error;
    ////////////////////////////////////NSLog/@"test123");
    NSDictionary* results = (NSDictionary*)[NSJSONSerialization
                                            JSONObjectWithData:data
                                            options:0
                                            error:&error];
    
    NSArray* start_states = (NSArray*)results[@"start_states"];
    //[self setStateDepth:[[NSMutableDictionary alloc] init]];
    for(NSString* startState in start_states) {
        //[self setDepthValues:startState depth:0 dict:results];
        //////////////////////////////NSLog/@"start state: %@", startState);
    }
    ////////////////////////////////////NSLog/@"test123");
    ////////////////////////////////////NSLog/@"test: %@", (NSString*)start_states[0]);
    //NSError error;
    //NSString* input = @"";
    //NSString* input = @"var value=1;";
    //NSString *input = @"class base{public $b=1;public function init($b){$this->b=$b;$c=$this->b;$object->log($this->b);$object->log('test123');}public function __construct($input_x){$this->init($input_x);}}$main_instance=new base(31);";
    //NSString* input = @"class app{public $ab;public function __construct($input_b,$base){$this->ab=$input_b;$object->log($this->ab);$base->test_call(11);}}class base{public function __construct($input_x){$app=new app($input_x,$this);}public function test_call($value){$object->log($value);}}$base_instance=new base(31);";
    //NSString* input = @"class app{public $ab;public function __construct($input_b,$base){$this->ab=$input_b;$object->log($this->ab);$base->test_call(11);}}class base{public function __construct($input_x){$app=new app($input_x,$this);}public function test_call($value){$func=function($value_b){$value_b=$value.$value_b;$object->log($value);$object->log($value_b);return $value_b;};$result=$func(13);$arr_test=[$result,$result+1,$result.'31'];foreach($arr_test as $key=>$value){$string_concat='key:'.$key.'-'.$value;$object->log($string_concat);}}}$base_instance=new base(31);";
    /*NSString* input = @"class app{public $ab;public function __construct($input_b,$base){$this->ab=$input_b;$object->log($this->ab);$base->test_call(11);}}class base{public function __construct($input_x){$app=new app($input_x,$this);}public function test_call($value){$func=function($value_b){$value_b=$value.$value_b;$object->log($value);$object->log($value_b);return $value_b;};$result=$func(13);$arr_test=[$result,$result+1,$result.'31'];foreach($arr_test as $key=>$value){$string_concat='key:'.$key.'-'.$value;$object->log($string_concat);}return 0;}}$base_instance=new base(31);";*/
    //NSString* input = @"class app_base{protected $value_base=9;}class app extends app_base{public $ab;public function __construct($input_b,$base){$object->log($this->value_base);$this->ab=$input_b;$object->log($this->ab);$base->test_call(11);}}class base{public function __construct($input_x){$app=new app($input_x,$this);}public function test_call($value){$func=function($value_b){$value_b=$value.$value_b;$object->log($value);$object->log($value_b);return $value_b;};$result=$func(13);$arr_test=[$result,$result+1,$result.'31','last_item',[[0,3],1]];$arr_test[5]=14;$arr_test[1]=7;$arrtest2=[];$arrtest2[0]=3;$object->log($object->toJSON($arr_test));foreach($arrtest2 as $key=>$value){$string_concat='key:'.$key.'-'.$value;$object->log($string_concat);}}}$base_instance=new base(31);";
    /*NSString* input = @"\
     class app_base {\
     protected $value_base = 9;\
     }\
     class app extends app_base {\
     public $ab;\
     public function __construct($input_b, $base) {\
     $console->log($this->value_base);\
     $this->ab = $input_b;\
     $console->log($this->ab);\
     $base->test_call(11);\
     }\
     }\
     ";*/
    NSError* read_file_error;
    NSString* input = [[NSString alloc] init];
    NSString* path = [[NSBundle mainBundle]
                      pathForResource:@"app" ofType:@"php"];
    /*NSString* path = [[NSBundle mainBundle]
                      pathForResource:@"app" ofType:@"php"];
    ////////////////////////////NSLog/@"path: %@", path);
    input = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&read_file_error];
    ////////////////////////////NSLog/@"input: %@", input);
    input = [self preprocess:input];*/
    NSArray* files = @[
            @"streamline2/preg_split",
            @"streamline2/style_manager",
            @"streamline2/css_parser",
            @"streamline2/html_parser",
            @"streamline2/html_element",
            @"streamline2/dom",
            @"item",
            @"additional_locations",
            @"collections",
            @"indexing",
            @"media_handler",
            @"main",
            @"app",
        ];
    
    //input = [self preprocess:input];
    //NSString* input = [[NSString alloc] init];
    for(NSString* file in files) {
        //NSURL* path = [[NSURL alloc] initWithString:file];
        //NSString* pathName = [[path lastPathComponent] stringByDeletingPathExtension];
        path = [[NSBundle mainBundle] pathForResource:file ofType:@"php"];
        //////////////////NSLog(@"add file : %@", path);
        NSString* addition = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&read_file_error];
        addition = [self preprocess:addition];
        input = [input stringByAppendingString:addition];
    }
    
    /*NSURL* sourceLocation = [self getSourceLocation];
    //input = [self preprocess:input];
    //NSString* input = [[NSString alloc] init];
    for(NSString* file in files) {
        //NSURL* path = [[NSURL alloc] initWithString:file];
        //NSString* pathName = [[path lastPathComponent] stringByDeletingPathExtension];
        //path = [[NSBundle mainBundle] pathForResource:file ofType:@"php"];
        NSURL* pathURL = [[sourceLocation URLByAppendingPathComponent:file] URLByAppendingPathExtension:@"php"];
        NSString* pathLocation = @([pathURL fileSystemRepresentation]);
        NSLog(@"add file : %@", pathLocation);
        NSString* addition = [[NSString alloc] initWithContentsOfFile:pathLocation encoding:NSUTF8StringEncoding error:&read_file_error];
        //NSLog(@"addition : %@", addition);
        addition = [self preprocess:addition];
        input = [input stringByAppendingString:addition];
    }*/
    
    
    
    Preparser* preparser = [[Preparser alloc] init];
    NSMutableDictionary* terminalDictionary = [preparser preparseText:input];
    [self setTerminalIndex:[[NSMutableDictionary alloc] init]];
    [[self terminalIndex] addEntriesFromDictionary:terminalDictionary];
    [self setPreParsedTerminalIndex:[preparser rangeResults]];
    [self setStrings:[preparser strings]];
    [self setWhiteSpaces:[preparser whiteSpaces]];
    [self setIdentifiers:[preparser identifiers]];
    [self setNumbers:[preparser numbers]];
    ////////////////////////////NSLog/@"read file");
    //return;
    //NSString* input = @"$object->log(13)";
    //$this->init(3);
    
    //NSString* input = @"class inso{private $b;public function __construct($b){$this->b=$b;}public function get_b(){return $this->b;}public function calculate($a,$b){$c=$a+$b;$c--;return $c;}public function init($a_value){$another=new another($a_value);$result=$another->get()->results;$arr=[1,2,3,4];$value=$arr[0];$value2=$result[0]->get();$value=$this->b;return $value;}}$inso_instance=new inso(1);$results=$inso->calculate(3,5);$instance=new inso(3);$result=$instance->init(4);";
    //class basetest{protected $c=1;protected $var_priv=2;}
    //app.assign_root(app);console.log('appinit');app.init();
    //[[NSString alloc] initWithContentsOfFile:@"/Users/siggi/Documents/MAUI/noobtorrentmaui/noobtorrent/app.js" encoding:NSUnicodeStringEncoding error:&error];
    ////////////////////////////////NSLog/@"%@", input);
    [self initArrays];
    /*
     NSMutableArray* test = [self strSplit:@"test 123 123"];
     for(NSString* test_value in test) {
     ////////////////////////////////////NSLog/@"char: %@", test_value);
     }
     bool result = [self arrayContains:test string:@"x"];
     ////////////////////////////////////NSLog/@"result: %d", result);*/
    
    NSString* postProcessingString = @"{\"ValueDereferenceWrapReference\":{\"last_node\":{\"from\":\"ValueDereferenceContinueSub\",\"to\":\"ValueDereferenceContinueSubReference\"}},\"FunctionCallReference\":{\"last_node\":{\"from\":\"FollowingObjectFunctionCall\",\"to\":\"FollowingObjectFunctionCallReference\"}},\"FunctionCallReference_2\":{\"last_node\":{\"from\":\"ValueDereferenceContinueSub\",\"to\":\"ValueDereferenceContinueSubReference\"}},\"ValueDereferenceWrapReference_2\":{\"last_node\":{\"from\":\"FollowingObjectFunctionCall\",\"to\":\"FollowingObjectFunctionCallReference\"}},\"ValueIdentifierNewWrap2\":{\"all_nodes\":{\"from\":\"ValueDereferenceWrap\",\"to\":\"ValueDereferenceWrapReference\"}},\"ValueDereferenceWrapReference_3\":{\"last_node\":{\"from\":\"IdentifierReference\",\"to\":\"IdentifierReferenceIgnore\"}}}";
    
    NSData* dataPost = [postProcessingString dataUsingEncoding:NSUTF8StringEncoding];
    //NSError* error;
    ////////////////////////////////////NSLog/@"test123");
    NSDictionary* resultsPost = (NSDictionary*)[NSJSONSerialization
                                                JSONObjectWithData:dataPost
                                                options:0
                                                error:&error];
    //////////////////////////////NSLog/@"error, %@", error);
    //////////////////////////////NSLog/@"postProccessingValidation: %@", resultsPost[@"ValueDereferenceWrapReference"][@"last_node"][@"from"]);
    
    [self setPostProcessingDefinition:resultsPost];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray* parse_results;
    NSURL* containerPathFile = [self getContainerPath];
    //if(![fileManager fileExistsAtPath:@([containerPathFile fileSystemRepresentation])]) {
        parse_results = [self parse:input withLanguage:results];
        /*[parse_results writeToURL:containerPathFile error:&error];
        ////NSLog(@"not use file");*/
    /*} else {
        [self setParse:input withLanguage:results];
        parse_results = [[NSMutableArray alloc] initWithContentsOfURL:containerPathFile];
        ////NSLog(@"used file");
    }*/
    //////NSLog(@"parse results : %@", parse_results);
    
    if(parse_results == NULL) {
        //////////////NSLog(@"is null");
        return;
    }
    [self setParse_results:parse_results];
    [self setMainString:input];
}

- (void) setDepthValues: (NSString*) state depth: (int) depth dict: (NSDictionary*) dict {
    /*if([self stateDepth] == nil) {
        [self setStateDepth:[[NSMutableDictionary alloc] init]];
    }*/
    //NSLog(@"state : %@", state);
    if(dict[@"states"][state] == nil || [self stateDepth][state] != nil) {
        return;
    }
    [self stateDepth][state] = @(depth);
    for(NSArray* keyWrap in dict[@"states"][state]) {
        //NSLog(@"dict keywrap : %@", keyWrap);
        //for(NSArray* key in keyWrap) {
            //NSLog(@"dict key : %@", key);
            for(NSDictionary* definitionItem in keyWrap) {
                //NSLog(@"dict definitionItem : %@", definitionItem);
                if(definitionItem[@"non_terminal"] != nil) {
                    [self setDepthValues:definitionItem[@"non_terminal"] depth:depth+1 dict:dict];
                }
            }
        //}
    }
}


- (void) run: (PHPInterpretation*) interpret callback: (id) callback {
    ////////////////////
///
    NSMutableArray* parse_results = [self parse_results];
    //////////////////NSLog(@" count: %lu", [parse_results count]);
    NSString* input = [self mainString];
    NSError* error;
    NSString *string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parse_results options:0 error:nil] encoding:NSUTF8StringEncoding];
    //////////////////////////////NSLog/@"results: %@", string);
   
    //return;
    
    NSData* dataDefinition = [[NSData alloc] initWithBase64EncodedString:@"eyJGaXJzdFBhcmFtZXRlcklucHV0Ijp7ImZ1bmN0aW9uIjoicmV0dXJuX3BhcmFtZXRlcl9pbnB1dCIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiUHJlZml4ZWRJZGVudGlmaWVyIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiRmlyc3RQYXJhbWV0ZXJJbnB1dCIsInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9XX0sIlBhcmFtZXRlcklucHV0Ijp7ImZ1bmN0aW9uIjoiY29sbGVjdF9wYXJhbWV0ZXJzIiwidmFyaWFibGVzIjpbXX0sIlByZWZpeGVkSWRlbnRpZmllciI6eyJmdW5jdGlvbiI6InJldHVybl9wYXJhbWV0ZXJfaW5wdXRfaWRlbnRpZmllcl92YWx1ZSIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllciJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZSwib3B0Ijp0cnVlfV19LCJJZGVudGlmaWVyUHVzaCI6eyJmdW5jdGlvbiI6InNjcmlwdF9wdXNoX2FycmF5IiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZUlkZW50aWZpZXIiLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfV19LCJWYWx1ZURlcmVmZXJlbmNlV3JhcCI6eyJmdW5jdGlvbiI6InJldHVybl9yZXN1bHRfZGVyZWZlcmVuY2UiLCJwcmVzZXJ2ZV9jb250ZXh0Ijp0cnVlLCJzZXRfY29udGV4dF9zdWIiOnRydWUsIndyYXBfdmFsdWVzIjp0cnVlLCJzd2l0Y2hlcyI6W3sibm9uX3Rlcm1pbmFsIjoiQXdhaXQiLCJzdWJfcGFyc2UiOiJGb2xsb3dpbmdPYmplY3RGdW5jdGlvbkNhbGwifV0sInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVEZXJlZmVyZW5jZSIsInBhcnNlIjp0cnVlLCJzZXRfY29udGV4dCI6dHJ1ZX0seyJub25fdGVybWluYWwiOlsiRm9sbG93aW5nT2JqZWN0RnVuY3Rpb25DYWxsIiwiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlIl0sInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9XX0sIlZhbHVlRGVyZWZlcmVuY2VXcmFwUmVmZXJlbmNlIjp7ImZ1bmN0aW9uIjoicmV0dXJuX3Jlc3VsdF9kZXJlZmVyZW5jZSIsInNldF9jb250ZXh0X3N1YiI6dHJ1ZSwid3JhcF92YWx1ZXMiOnRydWUsInN3aXRjaGVzIjpbXSwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOlsiVmFsdWVEZXJlZmVyZW5jZSJdLCJwYXJzZSI6dHJ1ZSwic2V0X2NvbnRleHQiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjpbIkZvbGxvd2luZ09iamVjdEZ1bmN0aW9uQ2FsbCIsIkZvbGxvd2luZ09iamVjdEZ1bmN0aW9uQ2FsbFJlZmVyZW5jZSIsIlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZSJdLCJwYXJzZSI6dHJ1ZSwib3B0Ijp0cnVlfV19LCJWYWx1ZVBhcmFudGhlc2lzIjp7ImZ1bmN0aW9uIjoic2V0X3BhcmFudGhlc2lzIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfV19LCJWYXJpYWJsZUFzc2lnbm1lbnRJbmNyZW1lbnQiOnsiZnVuY3Rpb24iOiJzZXRfdmFyaWFibGVfaW5jcmVtZW50IiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZUlkZW50aWZpZXIiLCJwYXJzZSI6dHJ1ZX1dfSwiVmFyaWFibGVBc3NpZ25tZW50RGVjcmVtZW50Ijp7ImZ1bmN0aW9uIjoic2V0X3ZhcmlhYmxlX2RlY3JlbWVudCIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVJZGVudGlmaWVyIiwicGFyc2UiOnRydWV9XX0sIlZhcmlhYmxlQXNzaWdubWVudEFkZGl0aW9uIjp7ImZ1bmN0aW9uIjoic2V0X3ZhcmlhYmxlX3ZhbHVlX2FkZGl0aW9uIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOlsiVmFsdWVJZGVudGlmaWVyIiwiVmFsdWVJZGVudGlmaWVyMiJdLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfV19LCJWYXJpYWJsZUFzc2lnbm1lbnRTdWJ0cmFjdGlvbiI6eyJmdW5jdGlvbiI6InNldF92YXJpYWJsZV92YWx1ZV9zdWJ0cmFjdGlvbiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjpbIlZhbHVlSWRlbnRpZmllciIsIlZhbHVlSWRlbnRpZmllcjIiXSwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZX1dfSwiVmFyaWFibGVBc3NpZ25tZW50TXVsdGlwbGljYXRpb24iOnsiZnVuY3Rpb24iOiJzZXRfdmFyaWFibGVfdmFsdWVfbXVsdGlwbGljYXRpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6WyJWYWx1ZUlkZW50aWZpZXIiLCJWYWx1ZUlkZW50aWZpZXIyIl0sInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9XX0sIlZhcmlhYmxlQXNzaWdubWVudERpdmlzaW9uIjp7ImZ1bmN0aW9uIjoic2V0X3ZhcmlhYmxlX3ZhbHVlX2RpdmlzaW9uIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOlsiVmFsdWVJZGVudGlmaWVyIiwiVmFsdWVJZGVudGlmaWVyMiJdLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfV19LCJWYXJpYWJsZUFzc2lnbm1lbnRBcHBlbmQiOnsiZnVuY3Rpb24iOiJzZXRfdmFyaWFibGVfdmFsdWVfYXBwZW5kIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOlsiVmFsdWVJZGVudGlmaWVyIiwiVmFsdWVJZGVudGlmaWVyMiJdLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfV19LCJWYXJpYWJsZUFzc2lnbm1lbnQiOnsiZnVuY3Rpb24iOiJzZXRfdmFyaWFibGVfdmFsdWUiLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6WyJWYWx1ZUlkZW50aWZpZXIiLCJWYWx1ZUlkZW50aWZpZXIyIl0sInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9XX0sIlZhcmlhYmxlRGVmaW5pdGlvbiI6eyJmdW5jdGlvbiI6InNldF92YXJpYWJsZV92YWx1ZV9pbl9jb250ZXh0IiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyIn0seyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9XX0sIk51bWVyaWNTdWJ0cmFjdGlvbiI6eyJmdW5jdGlvbiI6Im51bWVyaWNfc3VidHJhY3Rpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6Ik51bWJlciJ9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZX1dfSwiVmFsdWVEaXZpc2lvbiI6eyJmdW5jdGlvbiI6Im51bWVyaWNfZGl2aXNpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9BZGRpdGlvbiIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9XX0sIlZhbHVlQXBwZW5kU3RyaW5nIjp7ImZ1bmN0aW9uIjoic3RyaW5nX2FkZGl0aW9uIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZU5vQWRkaXRpb24iLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfV19LCJWYWx1ZU11bHRpcGxpY2F0aW9uIjp7ImZ1bmN0aW9uIjoibnVtZXJpY19tdWx0aXBsaWNhdGlvbiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0FkZGl0aW9uIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZX1dfSwiVmFsdWVBcHBlbmQiOnsiZnVuY3Rpb24iOiJudW1lcmljX2FkZGl0aW9uIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZU5vQWRkaXRpb24iLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfV19LCJWYWx1ZVN1YnRyYWN0aW9uIjp7ImZ1bmN0aW9uIjoibnVtZXJpY19zdWJ0cmFjdGlvbiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0FkZGl0aW9uIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZX1dfSwiVmFsdWVNb2R1bG8iOnsiZnVuY3Rpb24iOiJudW1lcmljX21vZHVsbyIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0FkZGl0aW9uIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZX1dfSwiTnVtZXJpY0FkZGl0aW9uIjp7ImZ1bmN0aW9uIjoibnVtZXJpY19hZGRpdGlvbiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiTnVtYmVyIn0seyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfV19LCJPYmplY3RDYWxsQXBwZW5kIjp7ImZ1bmN0aW9uIjoibnVtZXJpY19hZGRpdGlvbiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiT2JqZWN0Q2FsbCIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9XX0sIlN0cmluZ0FwcGVuZCI6eyJmdW5jdGlvbiI6Im51bWVyaWNfYWRkaXRpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlN0cmluZyIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9XX0sIklkZW50aWZpZXJBcHBlbmQiOnsiZnVuY3Rpb24iOiJudW1lcmljX2FkZGl0aW9uIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyUmVmZXJlbmNlIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZX1dfSwiVmFsdWVQYXJhbnRoZXNpc1N1YnRyYWN0aW9uIjp7ImZ1bmN0aW9uIjoibnVtZXJpY19zdWJ0cmFjdGlvbiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVQYXJhbnRoZXNpcyIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9XX0sIlZhbHVlUGFyYW50aGVzaXNEaXZpc2lvbiI6eyJmdW5jdGlvbiI6Im51bWVyaWNfZGl2aXNpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlUGFyYW50aGVzaXMiLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfV19LCJWYWx1ZVBhcmFudGhlc2lzQWRkaXRpb24iOnsiZnVuY3Rpb24iOiJudW1lcmljX2FkZGl0aW9uIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZVBhcmFudGhlc2lzIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZX1dfSwiRnVuY3Rpb25DYWxsU3VidHJhY3Rpb24iOnsiZnVuY3Rpb24iOiJudW1lcmljX3N1YnRyYWN0aW9uIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJGdW5jdGlvbkNhbGwiLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfV19LCJGdW5jdGlvbkNhbGxEaXZpc2lvbiI6eyJmdW5jdGlvbiI6Im51bWVyaWNfZGl2aXNpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IkZ1bmN0aW9uQ2FsbCIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9XX0sIkZ1bmN0aW9uQ2FsbEFwcGVuZCI6eyJmdW5jdGlvbiI6Im51bWVyaWNfYWRkaXRpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IkZ1bmN0aW9uQ2FsbCIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9XX0sIk9iamVjdElkZW50aWZpZXJSZWZlcmVuY2UiOnsiZnVuY3Rpb24iOiJzZXRfcHJvcGVydHlfcmVmZXJlbmNlIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyIn1dfSwiQ2xhc3NJZGVudGlmaWVyUmVmZXJlbmNlIjp7ImZ1bmN0aW9uIjoic2V0X2NsYXNzX3JlZmVyZW5jZSIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllciJ9XX0sIklkZW50aWZpZXJSZWZlcmVuY2UiOnsiZnVuY3Rpb24iOiJzZXRfdmFyaWFibGVfcmVmZXJlbmNlIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyIn1dfSwiSWRlbnRpZmllclJlZmVyZW5jZUlnbm9yZSI6eyJmdW5jdGlvbiI6InNldF92YXJpYWJsZV9yZWZlcmVuY2VfaWdub3JlIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyIn1dfSwiU3RyaW5nIjp7ImZ1bmN0aW9uIjoic2V0X3N0cmluZyIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiU3RyaW5nQ29udGVudCJ9XX0sIkZvckxvb3AiOnsiZnVuY3Rpb24iOiJjcmVhdGVfZm9yX2xvb3AiLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IkZvclNldHRpbmdzIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsInBhcnNlIjp0cnVlLCJzdWJfY29udGV4dCI6ZmFsc2UsIm9wdCI6dHJ1ZX1dfSwiRm9yU2V0dGluZ3MiOnsiZnVuY3Rpb24iOiJzZXRfY29udHJvbF9zd2l0Y2hlcyIsInN3aXRjaGVzIjpbeyJub25fdGVybWluYWwiOiJGb3IifV0sInZhcmlhYmxlcyI6W119LCJGb3IiOnsiZnVuY3Rpb24iOiJzZXRfY29uZGl0aW9uIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYXJpYWJsZURlZmluaXRpb24iLCJwYXJzZSI6dHJ1ZSwic3ViX2NvbnRleHQiOmZhbHNlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWUsInN1Yl9jb250ZXh0IjpmYWxzZX0seyJub25fdGVybWluYWwiOiJWYXJpYWJsZUFzc2lnbm1lbnRHcm91cCIsInBhcnNlIjp0cnVlLCJzdWJfY29udGV4dCI6ZmFsc2V9XX0sIkZvck9mIjp7ImZ1bmN0aW9uIjoic2V0X2NvbmRpdGlvbiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllclJlZmVyZW5jZSIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9XX0sIkZvckluIjp7ImZ1bmN0aW9uIjoic2V0X2NvbmRpdGlvbiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllclJlZmVyZW5jZSIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9XX0sIldoaWxlTG9vcCI6eyJmdW5jdGlvbiI6ImNyZWF0ZV93aGlsZV9sb29wIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJDb25kaXRpb24iLCJwYXJzZSI6dHJ1ZSwic3ViX2NvbnRleHQiOmZhbHNlfSx7Im5vbl90ZXJtaW5hbCI6IlN0YXRlbWVudExpc3QiLCJwYXJzZSI6dHJ1ZSwic3ViX2NvbnRleHQiOmZhbHNlfV19LCJPckNvbmRpdGlvbiI6eyJmdW5jdGlvbiI6Im9yX2NvbmRpdGlvbiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVDb25kaXRpb24iLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJDb25kaXRpb24iLCJwYXJzZSI6dHJ1ZSwic3ViX2NvbnRleHQiOnRydWV9XX0sIkFuZENvbmRpdGlvbiI6eyJmdW5jdGlvbiI6ImFuZF9jb25kaXRpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlQ29uZGl0aW9uIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiQ29uZGl0aW9uIiwicGFyc2UiOnRydWUsInN1Yl9jb250ZXh0Ijp0cnVlfV19LCJTdHJvbmdJbmVxdWFsVmFsdWVDb25kaXRpb24iOnsiZnVuY3Rpb24iOiJpbmVxdWFsaXR5X3N0cm9uZyIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9Db25kaXRpb24iLCJwYXJzZSI6dHJ1ZSwib2Zmc2V0IjoxfV19LCJTdHJvbmdFcXVhbFZhbHVlQ29uZGl0aW9uIjp7ImZ1bmN0aW9uIjoiZXF1YWxzX3N0cm9uZyIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9Db25kaXRpb24iLCJwYXJzZSI6dHJ1ZSwib2Zmc2V0IjoxfV19LCJJbmVxdWFsVmFsdWVDb25kaXRpb24iOnsiZnVuY3Rpb24iOiJpbmVxdWFsaXR5IiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZU5vQ29uZGl0aW9uIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiIsInBhcnNlIjp0cnVlLCJvZmZzZXQiOjF9XX0sIkVxdWFsVmFsdWVDb25kaXRpb24iOnsiZnVuY3Rpb24iOiJlcXVhbHMiLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9Db25kaXRpb24iLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJWYWx1ZU5vQ29uZGl0aW9uIiwicGFyc2UiOnRydWUsIm9mZnNldCI6MX1dfSwiR3JlYXRlclZhbHVlQ29uZGl0aW9uIjp7ImZ1bmN0aW9uIjoiZ3JlYXRlciIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9Db25kaXRpb24iLCJwYXJzZSI6dHJ1ZSwib2Zmc2V0IjoxfV19LCJMZXNzVmFsdWVDb25kaXRpb24iOnsiZnVuY3Rpb24iOiJsZXNzIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZU5vQ29uZGl0aW9uIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiIsInBhcnNlIjp0cnVlLCJvZmZzZXQiOjF9XX0sIkdyZWF0ZXJFcXVhbFZhbHVlQ29uZGl0aW9uIjp7ImZ1bmN0aW9uIjoiZ3JlYXRlcl9lcXVhbHMiLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9Db25kaXRpb24iLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJWYWx1ZU5vQ29uZGl0aW9uIiwicGFyc2UiOnRydWUsIm9mZnNldCI6MX1dfSwiTGVzc0VxdWFsVmFsdWVDb25kaXRpb24iOnsiZnVuY3Rpb24iOiJsZXNzX2VxdWFscyIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0NvbmRpdGlvbiIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9Db25kaXRpb24iLCJwYXJzZSI6dHJ1ZSwib2Zmc2V0IjoxfV19LCJJZlN0YXRlbWVudCI6eyJmdW5jdGlvbiI6ImNyZWF0ZV9pZl9zdGF0ZW1lbnQiLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsInBhcnNlIjp0cnVlLCJzdWJfY29udGV4dCI6ZmFsc2V9LHsibm9uX3Rlcm1pbmFsIjoiRWxzZUlmU3RhdGVtZW50R3JvdXAiLCJwYXJzZSI6dHJ1ZX1dfSwiRWxzZVN0YXRlbWVudCI6eyJmdW5jdGlvbiI6InNldF9lbHNlX2NvbmRpdGlvbiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsInBhcnNlIjp0cnVlLCJzdWJfY29udGV4dCI6ZmFsc2V9XX0sIkVsc2VJZlN0YXRlbWVudCI6eyJmdW5jdGlvbiI6InNldF9jb25kaXRpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsInBhcnNlIjp0cnVlLCJzdWJfY29udGV4dCI6ZmFsc2V9LHsibm9uX3Rlcm1pbmFsIjoiRWxzZUlmU3RhdGVtZW50R3JvdXAiLCJwYXJzZSI6dHJ1ZX1dfSwiRnVuY3Rpb25EZWZpbml0aW9uTm9Bc3luYyI6eyJmdW5jdGlvbiI6ImNyZWF0ZV9zY3JpcHRfZnVuY3Rpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlcklucHV0cyIsInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsInBhcnNlIjp0cnVlLCJzdWJfY29udGV4dCI6dHJ1ZX1dfSwiTmFtZWRGdW5jdGlvbkRlZmluaXRpb24iOnsiZnVuY3Rpb24iOiJjcmVhdGVfbmFtZWRfc2NyaXB0X2Z1bmN0aW9uIiwic3dpdGNoZXMiOlt7Im5vbl90ZXJtaW5hbCI6IkFzeW5jRnVuY3Rpb25QcmVmaXgifV0sInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllciIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlcklucHV0cyIsInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsInBhcnNlIjp0cnVlLCJzdWJfY29udGV4dCI6dHJ1ZX1dfSwiRnVuY3Rpb25EZWZpbml0aW9uIjp7ImZ1bmN0aW9uIjoiY3JlYXRlX3NjcmlwdF9mdW5jdGlvbiIsInN3aXRjaGVzIjpbeyJub25fdGVybWluYWwiOiJBc3luY0Z1bmN0aW9uUHJlZml4In1dLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlcklucHV0cyIsInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsInBhcnNlIjp0cnVlLCJzdWJfY29udGV4dCI6dHJ1ZX1dfSwiRmlyc3RPYmplY3RTdGF0ZW1lbnQiOnsiZnVuY3Rpb24iOiJzZXRfZGljdGlvbmFyeV92YWx1ZSIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiUHJvcGVydHlOYW1lIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZX1dfSwiT2JqZWN0U3RhdGVtZW50Ijp7ImZ1bmN0aW9uIjoic2V0X2RpY3Rpb25hcnlfdmFsdWUiLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlByb3BlcnR5TmFtZSIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiT2JqZWN0U3RhdGVtZW50IiwicGFyc2UiOnRydWUsIm9wdCI6dHJ1ZX1dfSwiVmFsdWVOZWdhdGl2ZSI6eyJmdW5jdGlvbiI6Im5lZ2F0aXZlX3ZhbHVlIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfV19LCJWYWx1ZU5lZ2F0ZWQiOnsiZnVuY3Rpb24iOiJuZWdhdGVfdmFsdWUiLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlTm9Db25kaXRpb24iLCJwYXJzZSI6dHJ1ZX1dfSwiQ2xhc3NCb2R5Ijp7ImZ1bmN0aW9uIjoic2V0X2FjY2Vzc19mbGFnIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJBY2Nlc3NGbGFnIn0seyJub25fdGVybWluYWwiOlsiVmFyaWFibGVEZWZpbml0aW9uIiwiTmFtZWRGdW5jdGlvbkRlZmluaXRpb24iXSwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiQ2xhc3NCb2R5IiwicGFyc2UiOnRydWUsIm9wdCI6dHJ1ZX1dfSwiRXh0ZW5kc1N0YXRlbWVudCI6eyJmdW5jdGlvbiI6InNldF9wcm90b3R5cGUiLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IkNsYXNzSWRlbnRpZmllclJlZmVyZW5jZSIsInBhcnNlIjp0cnVlfV19LCJDbGFzc0RlZmluaXRpb24iOnsiZnVuY3Rpb24iOiJjcmVhdGVfc2NyaXB0X29iamVjdCIsInNldF9wb3N0X2Z1bmN0aW9uIjoic2V0X29iamVjdF9pZGVudGlmaWVyIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiRXh0ZW5kc1N0YXRlbWVudCIsInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiQ2xhc3NCb2R5IiwicGFyc2UiOnRydWV9XX0sIk9iamVjdERlZmluaXRpb24iOnsiZnVuY3Rpb24iOiJjcmVhdGVfc2NyaXB0X29iamVjdCIsInBvc3RfZnVuY3Rpb24iOiJyZXZlcnNlX2FycmF5IiwidmFyaWFibGVzIjpbXX0sIlBhcmFtZXRlcklucHV0cyI6eyJmdW5jdGlvbiI6ImNvbGxlY3RfcGFyYW1ldGVycyIsInZhcmlhYmxlcyI6W119LCJQYXJhbWV0ZXJWYWx1ZXNDb25zdHJ1Y3RvciI6eyJmdW5jdGlvbiI6ImNvbGxlY3RfcGFyYW1ldGVycyIsInZhcmlhYmxlcyI6W119LCJQYXJhbWV0ZXJWYWx1ZXMiOnsicGFyZW50X2NvbnRleHQiOnRydWUsImZ1bmN0aW9uIjoiY29sbGVjdF9wYXJhbWV0ZXJzIiwidmFyaWFibGVzIjpbXX0sIkZpcnN0UGFyYW1ldGVyVmFsdWUiOnsiZnVuY3Rpb24iOiJjb2xsZWN0X3BhcmFtZXRlcnMiLCJ2YXJpYWJsZXMiOltdfSwiUGFyYW1ldGVyVmFsdWUiOnsiZnVuY3Rpb24iOiJjb2xsZWN0X3BhcmFtZXRlcnMiLCJ2YXJpYWJsZXMiOltdfSwiT2JqZWN0U3RhdGVtZW50TGlzdCI6eyJmdW5jdGlvbiI6Im51bGwiLCJ2YXJpYWJsZXMiOltdfSwiU3RhdGVtZW50TGlzdCI6eyJmdW5jdGlvbiI6InJldHVybl9yZXN1bHQiLCJ2YXJpYWJsZXMiOltdfSwiU3RhdGVtZW50Ijp7ImV4Y2VwdGlvbiI6dHJ1ZSwiZnVuY3Rpb24iOiJyZXR1cm5fcmVzdWx0IiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJSZXR1cm5TdGF0ZW1lbnQiLCJwYXJzZSI6dHJ1ZX1dfSwiT2JqZWN0RnVuY3Rpb25DYWxsVmFsdWUiOnsiZnVuY3Rpb24iOiJyZXR1cm5fcHJvcF9yZXN1bHQiLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6WyJPYmplY3RGdW5jdGlvbkNhbGwiLCJWYWx1ZU9iamVjdERlcmVmZXJlbmNlV3JhcCJdLCJwYXJzZSI6dHJ1ZX1dfSwiT2JqZWN0Q2FsbFZhbHVlIjp7ImZ1bmN0aW9uIjoicmV0dXJuX3Byb3BfcmVzdWx0IiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJPYmplY3RJZGVudGlmaWVyUmVmZXJlbmNlIiwicGFyc2UiOnRydWV9XX0sIk9iamVjdENhbGxXcmFwIjp7ImZ1bmN0aW9uIjoicmV0dXJuX3ZhbHVlX3Jlc3VsdCIsInN3aXRjaGVzIjpbeyJub25fdGVybWluYWwiOiJBd2FpdCIsInN1Yl9wYXJzZSI6Ik9iamVjdEZ1bmN0aW9uQ2FsbCJ9XSwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJPYmplY3RDYWxsIiwicGFyc2UiOnRydWV9XX0sIlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZVN1YiI6eyJmdW5jdGlvbiI6ImdldF9hcnJheV92YWx1ZV9jb250ZXh0Iiwic2V0X2NvbnRleHRfc3ViIjp0cnVlLCJpZ25vcmVfZW1wdHkiOnRydWUsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjpbIlZhbHVlIiwiSWRlbnRpZmllciJdLCJwYXJzZSI6dHJ1ZX1dfSwiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlU3ViUmVmZXJlbmNlIjp7ImZ1bmN0aW9uIjoiZ2V0X2FycmF5X3ZhbHVlX2NvbnRleHRfcmVmZXJlbmNlIiwiaWdub3JlX2VtcHR5Ijp0cnVlLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6WyJWYWx1ZSIsIklkZW50aWZpZXIiXSwicGFyc2UiOnRydWV9XX0sIlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZSI6eyJmdW5jdGlvbiI6InJldHVybl9yZXN1bHRfZGVyZWZlcmVuY2UiLCJ3cmFwX3ZhbHVlcyI6dHJ1ZSwiaWdub3JlX2VtcHR5Ijp0cnVlLCJzd2l0Y2hlcyI6W10sInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjpbIlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZVN1YiIsIlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZVN1YlJlZmVyZW5jZSJdLCJwYXJzZSI6dHJ1ZSwic2V0X2NvbnRleHQiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjpbIlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZSIsIkZvbGxvd2luZ09iamVjdEZ1bmN0aW9uQ2FsbCIsIkZvbGxvd2luZ09iamVjdEZ1bmN0aW9uQ2FsbFJlZmVyZW5jZSJdLCJwYXJzZSI6dHJ1ZSwib3B0Ijp0cnVlfV19LCJPYmplY3RDYWxsQ29udGludWUiOnsiZnVuY3Rpb24iOiJyZXR1cm5fcHJvcF9yZXN1bHQiLCJ3cmFwX3ZhbHVlcyI6dHJ1ZSwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOlsiT2JqZWN0SWRlbnRpZmllclJlZmVyZW5jZSIsIk9iamVjdENhbGwiLCJPYmplY3RGdW5jdGlvbkNhbGxWYWx1ZSJdLCJwYXJzZSI6dHJ1ZSwic2V0X2NvbnRleHQiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlIiwicGFyc2UiOnRydWUsIm9wdCI6dHJ1ZX1dfSwiT2JqZWN0Q2FsbCI6eyJmdW5jdGlvbiI6InJldHVybl9sYXN0X3Byb3BfcmVzdWx0Iiwid3JhcF92YWx1ZXMiOnRydWUsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllclJlZmVyZW5jZSIsInBhcnNlIjp0cnVlLCJzZXRfY29udGV4dCI6dHJ1ZX0seyJub25fdGVybWluYWwiOlsiT2JqZWN0Q2FsbFZhbHVlIiwiT2JqZWN0Q2FsbCIsIk9iamVjdEZ1bmN0aW9uQ2FsbFZhbHVlIl0sInBhcnNlIjp0cnVlfV19LCJOZXdTdGF0ZW1lbnQiOnsiZnVuY3Rpb24iOiJuZXdfaW5zdGFuY2UiLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IkNsYXNzSWRlbnRpZmllclJlZmVyZW5jZSIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlclZhbHVlc0NvbnN0cnVjdG9yIiwib3B0Ijp0cnVlLCJwYXJzZSI6dHJ1ZX1dfSwiUmV0dXJuU3RhdGVtZW50Ijp7ImZ1bmN0aW9uIjoicmV0dXJuX3ZhbHVlX3Jlc3VsdCIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZX1dfSwiSW5saW5lRnVuY3Rpb25EZWZpbml0aW9uQ2FsbCI6eyJmdW5jdGlvbiI6ImNhbGxfc2NyaXB0X2Z1bmN0aW9uX3N1YiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiRnVuY3Rpb25EZWZpbml0aW9uTm9Bc3luYyIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IlBhcmFtZXRlclZhbHVlcyIsInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiRm9sbG93aW5nT2JqZWN0RnVuY3Rpb25DYWxsIiwicGFyc2UiOnRydWUsIm9wdCI6dHJ1ZX1dfSwiT2JqZWN0RnVuY3Rpb25DYWxsIjp7ImZ1bmN0aW9uIjoiY2FsbF9zY3JpcHRfZnVuY3Rpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UiLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJQYXJhbWV0ZXJWYWx1ZXMiLCJwYXJzZSI6dHJ1ZSwib3B0Ijp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IkZvbGxvd2luZ09iamVjdEZ1bmN0aW9uQ2FsbCIsInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9XX0sIkZvbGxvd2luZ09iamVjdEZ1bmN0aW9uQ2FsbFJlZmVyZW5jZSI6eyJmdW5jdGlvbiI6ImNhbGxfc2NyaXB0X2Z1bmN0aW9uX3N1Yl9yZWZlcmVuY2UiLCJpZ25vcmVfZW1wdHkiOnRydWUsInNldF9jb250ZXh0X3N1YiI6dHJ1ZSwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJQYXJhbWV0ZXJWYWx1ZXMiLCJwYXJzZSI6dHJ1ZX1dfSwiRm9sbG93aW5nT2JqZWN0RnVuY3Rpb25DYWxsIjp7ImZ1bmN0aW9uIjoiY2FsbF9zY3JpcHRfZnVuY3Rpb25fc3ViIiwiaWdub3JlX2VtcHR5Ijp0cnVlLCJzZXRfY29udGV4dF9zdWIiOnRydWUsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiUGFyYW1ldGVyVmFsdWVzIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjpbIlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZSIsIkZvbGxvd2luZ09iamVjdEZ1bmN0aW9uQ2FsbCJdLCJwYXJzZSI6dHJ1ZSwib3B0Ijp0cnVlfV19LCJGdW5jdGlvbkNhbGxSZWZlcmVuY2UiOnsiZnVuY3Rpb24iOiJjYWxsX3NjcmlwdF9mdW5jdGlvbl9yZWZlcmVuY2UiLCJzZXRfY29udGV4dF9zdWIiOnRydWUsInN3aXRjaGVzIjpbeyJub25fdGVybWluYWwiOiJBd2FpdCJ9XSwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyUmVmZXJlbmNlIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiUGFyYW1ldGVyVmFsdWVzIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjpbIlZhbHVlRGVyZWZlcmVuY2VDb250aW51ZSIsIkZvbGxvd2luZ09iamVjdEZ1bmN0aW9uQ2FsbCJdLCJwYXJzZSI6dHJ1ZSwib3B0Ijp0cnVlfV19LCJGdW5jdGlvbkNhbGwiOnsiZnVuY3Rpb24iOiJjYWxsX3NjcmlwdF9mdW5jdGlvbiIsInNldF9jb250ZXh0X3N1YiI6dHJ1ZSwic3dpdGNoZXMiOlt7Im5vbl90ZXJtaW5hbCI6IkF3YWl0In1dLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UiLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJQYXJhbWV0ZXJWYWx1ZXMiLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOlsiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlIiwiRm9sbG93aW5nT2JqZWN0RnVuY3Rpb25DYWxsIl0sInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9XX0sIlZhbHVlRGVyZWZlcmVuY2UiOnsiZnVuY3Rpb24iOiJyZXR1cm5fcmVzdWx0X2RlcmVmZXJlbmNlIiwid3JhcF92YWx1ZXMiOnRydWUsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjpbIklkZW50aWZpZXJSZWZlcmVuY2UiLCJWYWx1ZU5vRGVyZWZlcmVuY2UiLCJJZGVudGlmaWVyUmVmZXJlbmNlSWdub3JlIl0sInBhcnNlIjp0cnVlLCJzZXRfY29udGV4dCI6dHJ1ZX0seyJub25fdGVybWluYWwiOlsiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlU3ViIiwiVmFsdWVEZXJlZmVyZW5jZUNvbnRpbnVlU3ViUmVmZXJlbmNlIl0sInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9XX0sIlZhbHVlT2JqZWN0RGVyZWZlcmVuY2VXcmFwIjp7ImZ1bmN0aW9uIjoicmV0dXJuX3Jlc3VsdF9kZXJlZmVyZW5jZSIsIndyYXBfdmFsdWVzIjp0cnVlLCJzd2l0Y2hlcyI6W3sibm9uX3Rlcm1pbmFsIjoiT2JqZWN0Q2FsbENvbnRpbnVlIn1dLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlT2JqZWN0RGVyZWZlcmVuY2UiLCJwYXJzZSI6dHJ1ZSwic2V0X2NvbnRleHQiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiT2JqZWN0Q2FsbENvbnRpbnVlIiwicGFyc2UiOnRydWUsIm9wdCI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJWYWx1ZURlcmVmZXJlbmNlQ29udGludWUiLCJwYXJzZSI6dHJ1ZSwib3B0Ijp0cnVlfV19LCJWYWx1ZU9iamVjdERlcmVmZXJlbmNlIjp7ImZ1bmN0aW9uIjoiZ2V0X2FycmF5X3ZhbHVlIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyUmVmZXJlbmNlIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZX1dfSwiQXJyYXkiOnsiZnVuY3Rpb24iOiJjcmVhdGVfc2NyaXB0X29iamVjdCIsInZhcmlhYmxlcyI6W119LCJGaXJzdEFycmF5SXRlbSI6eyJmdW5jdGlvbiI6InNjcmlwdF9hcnJheV9wdXNoIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZSIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IkFycmF5SXRlbXMiLCJwYXJzZSI6dHJ1ZSwib3B0Ijp0cnVlfV19LCJBcnJheUl0ZW1zIjp7ImZ1bmN0aW9uIjoic2NyaXB0X2FycmF5X3B1c2giLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiQXJyYXlJdGVtcyIsInBhcnNlIjp0cnVlLCJvcHQiOnRydWV9XX0sIlR5cGVvZlZhbHVlIjp7ImZ1bmN0aW9uIjoiZ2V0X3R5cGVvZiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWVOb0FkZGl0aW9uIiwicGFyc2UiOnRydWV9XX0sIkRlbGV0ZVZhbHVlRGVyZWZlcmVuY2UiOnsiZnVuY3Rpb24iOiJkZWxldGVfcHJvcGVydHlfcmVmZXJlbmNlIiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZUlkZW50aWZpZXIiLCJwYXJzZSI6dHJ1ZX1dfSwiT2JqZWN0U3ByZWFkT3BlcmF0b3IiOnsiZnVuY3Rpb24iOiJjbG9uZV9vYmplY3QiLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlSWRlbnRpZmllciIsInBhcnNlIjp0cnVlfV19LCJBcnJheVNwcmVhZE9wZXJhdG9yIjp7ImZ1bmN0aW9uIjoiY2xvbmVfb2JqZWN0IiwidmFyaWFibGVzIjpbeyJub25fdGVybWluYWwiOiJWYWx1ZUlkZW50aWZpZXIiLCJwYXJzZSI6dHJ1ZX1dfSwiU2NyaXB0U3RhdGVtZW50Ijp7ImZ1bmN0aW9uIjoibnVsbCIsInZhcmlhYmxlcyI6W119LCJGb3JFYWNoIjp7ImZ1bmN0aW9uIjoiY3JlYXRlX2ZvcmVhY2hfbG9vcCIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiRm9yZWFjaFNldHRpbmdzIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiU3RhdGVtZW50TGlzdCIsInBhcnNlIjp0cnVlLCJzdWJfY29udGV4dCI6ZmFsc2UsIm9wdCI6dHJ1ZX1dfSwiRm9yZWFjaFNldHRpbmdzMSI6eyJmdW5jdGlvbiI6InNldF9jb25kaXRpb24iLCJ2YXJpYWJsZXMiOlt7Im5vbl90ZXJtaW5hbCI6IlZhbHVlIiwicGFyc2UiOnRydWV9LHsibm9uX3Rlcm1pbmFsIjoiSWRlbnRpZmllclJlZmVyZW5jZSIsInBhcnNlIjp0cnVlfSx7Im5vbl90ZXJtaW5hbCI6IklkZW50aWZpZXJSZWZlcmVuY2UiLCJwYXJzZSI6dHJ1ZSwib2Zmc2V0IjoxfV19LCJGb3JlYWNoU2V0dGluZ3MyIjp7ImZ1bmN0aW9uIjoic2V0X2NvbmRpdGlvbiIsInZhcmlhYmxlcyI6W3sibm9uX3Rlcm1pbmFsIjoiVmFsdWUiLCJwYXJzZSI6dHJ1ZX0seyJub25fdGVybWluYWwiOiJJZGVudGlmaWVyUmVmZXJlbmNlIiwicGFyc2UiOnRydWV9XX19" options:0];
    
    //NSData* dataDefinition = [languageDefinition dataUsingEncoding:NSUTF8StringEncoding];
    //NSError* error;
    ////////////////////////////////////NSLog/@"test123");
    NSMutableDictionary* resultsDefinition = (NSMutableDictionary*)[NSJSONSerialization
                                            JSONObjectWithData:dataDefinition
                                            options:0
                                            error:&error];
    [self setResultsDefinition:resultsDefinition];
    //PHPInterpretation* interpret = [[PHPInterpretation alloc] init];
    
    
    
    [self assignDictValues:parse_results];
    [self containsIdentifier:parse_results[0]];
    [self containsThis:parse_results[0]];
    [self containsFunctionDefinition:parse_results[0]];
    [interpret construct:parse_results definition:resultsDefinition source:input];
    PHPScriptFunction* globalContext = [interpret start:nil callback:callback];
    //[interpret decouple];
    
    
    /*NSString *input_init = @"$main_instance=new base(1);";
    //NSString *input_init = @"$object->log(3)";
    NSMutableArray* parse_results_init = [self parse:input_init withLanguage:results];
    //////////////////////////////NSLog/@"parse init count: %lu", [parse_results count]);
    [interpret construct:parse_results_init definition:resultsDefinition source:input_init];
    [interpret start:globalContext];*/
    //////////////////////////////NSLog/@"classes output: %@", [globalContext dictionary]);
    //////////////////////////////NSLog/@"classes output: %@", [globalContext variables]);
    //////////////////////////////NSLog/@"classes output: %@", [globalContext classes]);
    
    //PHPScriptObject* instance = [globalContext dictionary][@"main_instance"];
    //PHPVariableReference* res = (PHPVariableReference*)[instance getDictionaryValue:@"b" returnReference:@false createIfNotExists:@false];
    ////////////////////////////////NSLog/@"res: %@", res);
    ////////////////////////////////NSLog/@"res: %@", [res get]);
    //[self varDump:];
    //PHPScriptFunction* main_instance = [globalContext variables][@"main_instance"];
    ////////////////////////////////NSLog/@" value of b: %@", main_instance);
    
    //return;
    
    /*NSMutableDictionary* classes = [globalContext classes];
    for(NSObject* class in classes) {
        //////////////////////////////NSLog/@"Class: %@", class);
    }
    
    
    //////////////////////////////NSLog/@"launch base");
    //////////////////////////////NSLog/@"count from globalContext: %lu", [[globalContext getClassesAsValue] count]);
    PHPScriptObject* classObject = [globalContext setClassReference:@"base"];
    ////////////////////////////////NSLog/@"%@", [classObject getDictionaryValues])
    NSMutableDictionary* dictionary = (NSMutableDictionary*)[classObject getDictionary];
    //////////////////////////////NSLog/@"dict items");
    for(NSObject* dict_item in dictionary) {
        //////////////////////////////NSLog/@"dict_item: %@", dict_item);
    }
    PHPScriptObject* instance = [globalContext newInstance:classObject parameterValues:nil];
    
    
    ////////////////////////////////NSLog/@"%@", [)
    PHPVariableReference* res = (PHPVariableReference*)[instance getDictionaryValue:@"b" returnReference:@false createIfNotExists:@false];
    //////////////////////////////NSLog/@"value from class: %@", res);
    NSObject* res2 = [res get];
    NSString* identifier = [res identifier];
    //////////////////////////////NSLog/@"value from class: %@", identifier);
    //////////////////////////////NSLog/@"value from class: %@", res2);*/
    /*res2 = [(PHPVariableReference*)res2 get];
    //////////////////////////////NSLog/@"value from class: %@", res2);
    res2 = [(PHPVariableReference*)res2 get];
    //////////////////////////////NSLog/@"value from class: %@", res2);*/
    //////////////////////////////NSLog/@"launch base");
}

- (NSURL*) getContainerPath {
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSError *error;
    NSURL* containerURL = [fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask][0];
    
    containerURL = [containerURL URLByAppendingPathComponent:@"parsed"];
    
    if(![fileManager fileExistsAtPath:@([containerURL fileSystemRepresentation])]) {
        [fileManager createDirectoryAtURL:containerURL withIntermediateDirectories:true attributes:nil error:nil];
    }
    
    NSString* parsedFileName = [@"parsed" stringByAppendingString:version];
    parsedFileName = [parsedFileName stringByAppendingString:@".txt"];
    
    containerURL = [containerURL URLByAppendingPathComponent:parsedFileName];
    return containerURL;
}

- (void) assignDictValues: (NSObject*) parseResults {
    if([parseResults isKindOfClass:[NSMutableArray class]]) {
        [self assignDictValues:((NSMutableArray*)parseResults)[0]];
    } else {
        NSMutableDictionary* parseItem = (NSMutableDictionary*)parseResults;
        NSMutableArray* variableReferences = [self resultsDefinition][parseItem[@"label"]][@"variables"];
        parseItem[@"nsvalue"] = [NSValue valueWithNonretainedObject:parseItem];
        if(parseItem[@"sub_parse_objects"] != nil && [parseItem[@"sub_parse_objects"] count] > 0) {
            parseItem[@"cache_states"] = [[NSMutableDictionary alloc] init];
            //parseItem[@"sub_parse_object_variables"] = [NSMapTable weakToStrongObjectsMapTable];
            parseItem[@"sub_parse_objects_dict"] = [[NSMutableDictionary alloc] init];
            //NSMutableDictionary* parseItemCounts = [[NSMutableDictionary alloc] init];
            for(NSMutableDictionary* subParseObject in parseItem[@"sub_parse_objects"]) {
                NSString* label = subParseObject[@"label"];
                if(parseItem[@"sub_parse_objects_dict"][label] == nil) {
                    parseItem[@"sub_parse_objects_dict"][label] = [[NSMutableArray alloc] init];
                }
                [parseItem[@"sub_parse_objects_dict"][label] addObject:subParseObject];
                //parseItem[@"sub_parse_objects_dict"][label] = subParseObject;
                [self assignDictValues:subParseObject];
            }
            parseItem[@"variable_references"] = [[NSMutableArray alloc] init];
            for(NSMutableDictionary* variableReference in variableReferences) {
                long offset = 0;
                if(variableReference[@"offset"] != nil) {
                    offset = [variableReference[@"offset"] longValue];
                }
                NSMutableDictionary* subParseObject = [self getSubParseObject:parseItem nt:variableReference[@"non_terminal"]  offset:offset];
                if(subParseObject != NULL) {
                    NSMutableDictionary* varRefCopy = [[NSMutableDictionary alloc] initWithDictionary:variableReference];
                    varRefCopy[@"subParseObject"] = subParseObject;
                    [parseItem[@"variable_references"] addObject:varRefCopy];
                }
            }
        } else if(parseItem[@"sub_parse_objects"] == nil || [parseItem[@"sub_parse_objects"] count] == 0) {
            bool isString = false;
            NSMutableDictionary* subParseObject = parseItem;
            if([subParseObject[@"label"] isEqualToString:@"StringContent"] || [subParseObject[@"label"] isEqualToString:@"Identifier"] || [subParseObject[@"label"] isEqualToString:@"AccessFlag"] || [subParseObject[@"label"] isEqualToString:@"ObjectDefinition"]) {
                isString = true;
            }
            [self getText:[subParseObject[@"start_index"] intValue] stop:[subParseObject[@"stop_index"] intValue] isString:isString parseObject:subParseObject];
        }
    }
}

- (NSObject*) getText: (int) startIndex stop: (int) stopIndex isString: (bool) isString parseObject: (NSMutableDictionary*) parseObject {
    if(parseObject[@"text_value"] != nil) {
        return parseObject[@"text_value"];
    }
    NSRange range = NSMakeRange([@(startIndex) unsignedIntValue], [@(stopIndex-startIndex) unsignedIntValue]);
    /*if([self isCopy]) {
        //////////////NSLog(@"range: %lu _ %lu", range.location, range.length);
    }*/
    NSObject* value = [[self sourceText] substringWithRange:range];
    ////////////NSLog(@"value: %@", value);
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
    } else if([value isEqual:@"NULL"]) {
        value = [[NSNull alloc] init];
    }
    parseObject[@"text_value"] = value;
    return value;
}

- (NSNumber*) makeIntoNumber: (NSObject*) value {
    if([value isKindOfClass:[NSString class]]) {
        NSString* stringValue = (NSString*)value;
        if([stringValue isEqualToString:@"true"]) {
            return [[NSNumber alloc] initWithBool:true];
        } else if([stringValue isEqualToString:@"false"]) {
            return [[NSNumber alloc] initWithBool:false];
        } else if([stringValue isEqualToString:@"undefined"]) {
            return [[NSNumber alloc] initWithBool:false];
        }
        return [[NSNumber alloc] initWithDouble:[(NSString*)value doubleValue]];
    } else if([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    return [[NSNumber alloc] initWithDouble:0];
}

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

- (void) varDump: (NSObject*) object {
    NSString *string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:object options:0 error:nil] encoding:NSUTF8StringEncoding];
    //////////////////////////////NSLog/@"results: %@", string);
}

- (NSMutableArray*) postProcess: (NSMutableArray*) children setTransformations: (NSMutableDictionary*) setTransformations parentIsLast: (bool) parentIsLast {
    if(setTransformations == nil) {
        setTransformations = [[NSMutableDictionary alloc] init];
    }
    for(NSString* transformationKey in setTransformations) {
        NSMutableDictionary* transformation = setTransformations[transformationKey];
        if(transformation[@"swap"] != nil && [children count] == 2) {
            if([(NSString*)(children[0][@"label"]) isEqualToString:transformation[@"swap"][@"from"]]) {
                NSMutableArray* newChildren = [[NSMutableArray alloc] init];
                for(NSObject* child in [children reverseObjectEnumerator]) {
                    [newChildren addObject:child];
                }
                children = newChildren;
            }
        }
    }
    long key = 0;
    NSMutableArray* newChildren2 = [[NSMutableArray alloc] init];
    for(NSDictionary* child_immutable in children) {
        NSMutableDictionary* child = [[NSMutableDictionary alloc] initWithDictionary:child_immutable];
        bool isLast = false;
        if(key == [children count]-1) {
            isLast = true;
        }
        for(NSString* transformationKey in setTransformations) {
            NSMutableDictionary* transformation = setTransformations[transformationKey];
            if(transformation[@"last_node"] != nil && isLast && parentIsLast) {
                if([(NSString*)(transformation[@"last_node"][@"from"]) isEqualToString:(NSString*)(child[@"label"])]) {
                    //child[@"label"] = transformation[@"last_node"][@"to"];
                    [child setObject:transformation[@"last_node"][@"to"] forKey:@"label"];
                    //////////////////////////////NSLog/@"child label: %@", child[@"label"]);
                }
            }
            if(transformation[@"all_nodes"] != nil) {
                if([(NSString*)transformation[@"all_nodes"][@"from"] isEqualToString:(NSString*)(child[@"label"])]) {
                    //child[@"label"] = transformation[@"all_nodes"][@"to"];
                    [child setObject:transformation[@"all_nodes"][@"to"] forKey:@"label"];
                    //////////////////////////////NSLog/@"child label: %@", child[@"label"]);
                }
            }
        }
        NSArray* labels = @[child[@"label"], [(NSString*)child[@"label"] stringByAppendingString:@"_2"], [(NSString*)child[@"label"] stringByAppendingString:@"_3"]];
        for(NSString* childLabel in labels) {
            ////////////////////////////////NSLog/@"child label: %@", childLabel);
            if([self postProcessingDefinition][childLabel] != nil) {
                if(setTransformations[childLabel] == nil) {
                    //setTransformations[childLabel] = [self postProcessingDefinition][childLabel];
                    [setTransformations setObject:[self postProcessingDefinition][childLabel] forKey:childLabel];
                }
            }
        }
        child[@"sub_parse_objects"] = [self postProcess:(NSMutableArray*)child[@"sub_parse_objects"] setTransformations:[[NSMutableDictionary alloc] initWithDictionary:setTransformations] parentIsLast:isLast];
        [newChildren2 addObject:child];
        key++;
    }
    return newChildren2;
}

/*function post_process($children, $set_transformations=[], $parent_is_last=false) {
 foreach($set_transformations as $transformation) {
     if(isset($transformation['swap']) && count($children) == 2) {
         if($children[0]['label'] == $transformation['swap']['from']) {
             $children = array_reverse($children);
             //var_dump("apply children_swap");
         }
     }
 }
 foreach($children as $key => $child) {
     $is_last = false;
     if($key == count($children)-1) {
         $is_last = true;
     }
     foreach($set_transformations as $transformation) {
         if(isset($transformation['last_node']) && $is_last && $parent_is_last) {
             if($transformation['last_node']['from'] == $child['label']) {
                 $children[$key]['label'] = $transformation['last_node']['to'];
             }
         }
         if(isset($transformation['all_nodes'])) {
             if($transformation['all_nodes']['from'] == $child['label']) {
                 $children[$key]['label'] = $transformation['all_nodes']['to'];
             }
         }
     }
     $child = $children[$key];
     $labels = [$child['label'], $child['label'].'_2', $child['label'].'_3'];
     foreach($labels as $child_label) {
         if(isset($this->post_processing_definition[$child_label])) {
             if(!isset($set_transformations[$child_label])) {
                 $set_transformations[$child_label] = $this->post_processing_definition[$child_label];
             }
         }
     }
     $children[$key]['sub_parse_objects'] = $this->post_process($child['sub_parse_objects'], $set_transformations, $is_last);
 }
 return $children;
}*/

- (void) initArrays {
    //[' ', ';', '(', ')', '[', ']', ',', ':'];
    [self setDelimitRegex:@[@" ", @";", @"(", @")", @",", @":"]]; // @"[", @"]",
    //[self setDelimitRegex:[[NSArray alloc] init]];
    //[[self delimitRegex] arrayByAddingObject:];
    [self setSubStateRegexIndex:[[NSMutableArray alloc] init]];
    [self setSubStateIndex:[[NSMutableDictionary alloc] init]];
    [self setSubStateTerminalIndex:[[NSMutableDictionary alloc] init]];
}

- (NSMutableArray*) strSplit: (NSString*) input {
    NSMutableArray *letterArray = [[NSMutableArray alloc] init];
    [input enumerateSubstringsInRange:NSMakeRange(0, [input length])
                                options:(NSStringEnumerationByComposedCharacterSequences)
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [letterArray addObject:substring];
    }];
    return letterArray;
}

- (void) setParse: (NSString*) input  withLanguage:(NSDictionary*)language {
    [self setLanguage:language];
    [self setSourceText:input];
    [self setText:[self strSplit:input]];
}

- (NSMutableArray*) parse:(NSString*)input withLanguage:(NSDictionary*)language  {
    [self setLanguage:language];
    [self setSourceText:input];
    [self setText:[self strSplit:input]];
    //return NULL;
    NSArray* start_states = (NSArray*)language[@"start_states"];
    int index = 0;
    NSDictionary* set_index = NULL;
    //////////////////////////////NSLog/@"input: %@", input);
    NSMutableArray* parse_objects = [[NSMutableArray alloc] init];
    while(index < [[self text] count]) {
        /*for(NSString* start_state_key in start_states) {
            NSString* state = (NSString*)(start_states[start_state_key]);
            
            
        }*/
        for(NSString* state in start_states) {
            set_index = [self subParse:state index:index];
            if(set_index != NULL) {
                [parse_objects addObject:set_index];
                index = [(NSNumber*)set_index[@"stop_index"] intValue];
                //////////////////////////////NSLog/@"index: %d", index);
            } else {
                
                //////////////////////////////NSLog/@"index: is null1");
            }
        }
        if(set_index == NULL) {
            //////////////////////////////NSLog/@"set index is null");
            return NULL;
        }
    }
    /*for(NSString* sub_key in [self language][@"states"]) {
        NSDictionary* value = (NSDictionary*)[self language][@"states"][sub_key];
        
    }*/
    //////////////////////////////NSLog/@"parseCount: %lu", [parse_objects count]);
    return [self postProcess:parse_objects setTransformations:nil parentIsLast:false];
    //return parse_objects;
}


- (bool) arrayContains:(NSArray*) array string:(NSString*) value {
    ////////////////////////////////NSLog/@"arr: %@", array);
    ////////////////////////////////NSLog/@"val: %@", value);
    for(NSString* sub_state in array) {
        if([value isEqualToString:sub_state]) {
            return true;
        }
    }
    return false;
}

- (bool) mutableArrayContains:(NSMutableArray*) array string:(NSString*) value {
    ////////////////////////////////NSLog/@"arr: %@", array);
    ////////////////////////////////NSLog/@"val: %@", value);
    for(NSString* sub_state in array) {
        if([value isEqualToString:sub_state]) {
            return true;
        }
    }
    return false;
}
//function sub_parse($state=NULL, $index=NULL,
- (NSDictionary*) subParse:(NSString*) state index:(int) index {
    NSArray* definition = [self language][@"states"][state];
    ////////////////////////////////NSLog/@"def");
    int start_index = index;
    
    if(index >= [[self text] count]) {
        return NULL;
    }
    if(index < [[self currentStepStart] intValue]) { //&& index != 0
        //NSLog(@"stop subparse : %@ - %@", state, @(index));
        return NULL;
    }
    /*if([[self currentStepStart] intValue] != [[self currentStepStop] intValue] && index >= [[self currentStepStart] intValue] && index < [[self currentStepStop] intValue]) { //&& index != 0
        NSLog(@"stop subparse2 : %@ - %@ - %@", state, @(index), @{
            @"self current start": [self currentStepStart],
            @"self current stop": [self currentStepStop],
        });
        return NULL;
    }*/
    //[self setCurrentStepStart:@(index)];
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSArray* return_all_results = @[@"ValueObjectDereferenceWrap", @"ValueDereferenceWrap", @"FollowingObjectFunctionCall", @"ValueDereferenceContinue"];
    int set_sub_state_index = 0;
    /*if(index == [[self currentStepStart] intValue] && [[self currentStepStart] intValue] != 0) {
        //NSLog(@"same : %@ - %@ _ %@ - %@", state, [self lastValidState], [self stateDepth][state], [self stateDepthValue]);
        return NULL;
    }*/
    for(NSArray* sub_state in definition) {
        ////////////////////////////////NSLog/@"def");
        NSDictionary* set_result = [self subState:sub_state startIndex:start_index state:state setSubStateIndex:set_sub_state_index];
        ////////////////////////////////NSLog/@"def");
        if([self arrayContains:return_all_results string:state]) {
            if(set_result != NULL) {
                //[self setCurrentStepStart:set_result[@"stop_index"]];
                [results addObject:set_result];
            }
        } else if(set_result != NULL) {
            //[self setLastCurrentStepStart:[self currentStepStart]];
            //[self setCurrentStepStart:set_result[@"stop_index"]];
            [self setCurrentStepStart:set_result[@"start_index"]];
            /*[self setCurrentStepStop:set_result[@"stop_index"]];*/
            //[self setCurrentStepStart:@(index-1)];
            return set_result;
        }
        set_sub_state_index++;
    }
    if(![self arrayContains:return_all_results string:state]) {
        //[self setCurrentStepStart:@(index-1)];
        //[self setCurrentStepStart:[self lastCurrentStepStart]];
        [self setCurrentStepStart:@(-1)];
        //[self setCurrentStepStop:@-1];
        //[self setCurrentStepStart:@(index)];
        return NULL;
    }
    int longest = -1;
    NSMutableDictionary* result_return = NULL;
    for(NSMutableDictionary* result in results) {
        if([(NSNumber*)result[@"stop_index"] intValue] > longest || longest == -1) {
            longest = [(NSNumber*)result[@"stop_index"] intValue];
            result_return = result;
        }
    }
    if(result_return != NULL) {
        //[self setLastCurrentStepStart:@(-1)];
        //[self setLastCurrentStepStart:@(index-1)];
        
        //[self setCurrentStepStart:result_return[@"start_index"]];
        //[self setCurrentStepStop:result_return[@"stop_index"]];
        [self setCurrentStepStart:result_return[@"stop_index"]];
        //[self setCurrentStepStop:result_return[@"stop_index"]];
        //[self setCurrentStepStop:@-1];
    } else {
        //[self setCurrentStepStart:@(-1)];
        //[self setCurrentStepStart:[self lastCurrentStepStart]];
        //[self setCurrentStepStart:@(-1)];
    }
    return result_return;
    /*
     if(!in_array($state, $return_all_results)) {
         return false;
     }
     $longest = -1;
     $result_return = false;
     foreach($results as $result) {
         if($result['stop_index'] > $longest || $longest == -1) {
             $longest = $result['stop_index'];
             $result_return = $result;
         }
     }
     return $result_return;*/
    return NULL;
}

/*
 private function has_index_terminal($index, $terminal) {
     if(isset($this->sub_state_terminal_index[$index])) {
         return true;
     }
     return false;
 }
 private function has_index_regex($start_index, $state) {
     foreach($this->sub_state_regex_index as $sub_state_regex_item) {
         if($sub_state_regex_item['start_index'] == $start_index && $sub_state_regex_item['state'] == $state) {
             return $sub_state_regex_item;
         }
     }
     return false;
 }*/

- (bool) hasIndex: (int) index terminal:(NSString*) terminal {
    NSString* index_string = [@(index) stringValue];
    if([[self subStateTerminalIndex] objectForKey:index_string] != nil) {
        return true;
    }
    return false;
}

- (NSDictionary*) hasIndex: (int) start_index state: (NSString*) state {
    for(NSDictionary* sub_state_regex_item in [self subStateRegexIndex]) {
        //NSDictionary* sub_state_regex_item = [self subStateRegexIndex][sub_state_regex_key];
        if([(NSNumber*)sub_state_regex_item[@"start_index"] intValue] == start_index && [(NSString*)sub_state_regex_item[@"state"] isEqualToString:state]) {
            return sub_state_regex_item;
        }
    }
    return NULL;
}

- (NSDictionary*) subState: (NSArray*) sub_state startIndex: (int) start_index state: (NSString*) state setSubStateIndex: (int) set_sub_state_index {
    //NSString* start_index_key = [@(start_index) stringValue];//[[NSString alloc]
    ////////////////////////////////NSLog/@"def");
    //NSArray* stringStates = @[@"ValueNoCondition", @"ValueNoAddition", @"ValueNoDereference", @"Value", @"PropertyName", @"StringAppend"];
    /*if([state isEqualToString:@"String"]) {
        ////////////////NSLog(@"state string: %d %@", start_index, [self strings][@(start_index)]);
    }*/
    if([self parseObjectItems][@(start_index)] != nil && [self parseObjectItems][@(start_index)][state] != nil) {
        //NSLog(@"return %@", state);
        [self setSubStateRegexIndex:[[NSMutableArray alloc] init]];
        return [self parseObjectItems][@(start_index)][state];
    }
    if([self identifiers][@(start_index)] != nil && [state isEqualToString:@"Identifier"]) {
        ////////////////NSLog(@"is identifier");
        long stop_index = start_index+[[self identifiers][@(start_index)][@"length"] longLongValue];
        NSArray* subParseObjects = @[];
        NSDictionary* parse_object = @{
            @"start_index": @(start_index),
            @"stop_index": @(stop_index),
            @"label": @"Identifier",
            @"sub_parse_objects": subParseObjects
        };
        [self setSubStateRegexIndex:[[NSMutableArray alloc] init]];
        return parse_object;
    }
    /*if([self numbers][@(start_index)] != nil && [state isEqualToString:@"Number"]) {
        ////////////////NSLog(@"set whitespace--");
        long stop_index = start_index+[[self numbers][@(start_index)][@"length"] longLongValue];
        NSArray* subParseObjects = @[];
        
        NSDictionary* parse_object = @{
            @"start_index": @(start_index),
            @"stop_index": @(stop_index),
            @"label": @"Number",
            @"sub_parse_objects": subParseObjects
        };
        [self setSubStateRegexIndex:[[NSMutableArray alloc] init]];
        return parse_object;
    }*/
    if([self whiteSpaces][@(start_index)] != nil && [state isEqualToString:@"WhiteSpace"]) {
        ////////////////NSLog(@"set whitespace--");
        long stop_index = start_index+[[self whiteSpaces][@(start_index)][@"length"] longLongValue];
        NSArray* subParseObjects = @[];
        /*if(stop_index == start_index+1) {
            
        } else {
            long string_content_index = start_index+1;
            long string_content_stop = stop_index-1;
            subParseObjects = @[
                @{
                    @"start_index": @(string_content_index),
                    @"stop_index": @(string_content_stop),
                    @"label": @"StringContent",
                    @"sub_parse_objects": @[]
                }
            ];
        }*/
        NSDictionary* parse_object = @{
            @"start_index": @(start_index),
            @"stop_index": @(stop_index),
            @"label": @"WhiteSpace",
            @"sub_parse_objects": subParseObjects
        };
        [self setSubStateRegexIndex:[[NSMutableArray alloc] init]];
        return parse_object;
    }
    if([self strings][@(start_index)] != nil && [state isEqualToString:@"String"]) {
        ////////////////NSLog(@"set string--");
        long stop_index = start_index+[[self strings][@(start_index)][@"length"] longLongValue];
        NSArray* subParseObjects = @[];
        if(stop_index == start_index+1) {
            
        } else {
            long string_content_index = start_index+1;
            long string_content_stop = stop_index-1;
            subParseObjects = @[
                @{
                    @"start_index": @(string_content_index),
                    @"stop_index": @(string_content_stop),
                    @"label": @"StringContent",
                    @"sub_parse_objects": @[]
                }
            ];
        }
        NSDictionary* parse_object = @{
            @"start_index": @(start_index),
            @"stop_index": @(stop_index),
            @"label": @"String",
            @"sub_parse_objects": subParseObjects
        };
        [self setSubStateRegexIndex:[[NSMutableArray alloc] init]];
        return parse_object;
    }
    NSString* start_index_string = [@(start_index) stringValue];
    NSString* set_sub_state_index_string = [@(set_sub_state_index) stringValue];
    //[self subStateIndex][start_index_string][state][set_sub_state_index_string]
    if([[self subStateIndex] objectForKey:start_index_string] != nil && [[[self subStateIndex] objectForKey:start_index_string][state] objectForKey:set_sub_state_index_string] != nil) {
        return NULL;
    }
    NSRange firstCharRange = NSMakeRange(start_index, 1);
    NSString* firstChar = [[self sourceText] substringWithRange:firstCharRange];
    if([[self skipChars] indexOfObject:firstChar] != NSNotFound) {
        //NSLog(@"firstchar : %@", firstChar);
        if([self subStateIndex][start_index_string] == nil) {
            [self subStateIndex][start_index_string] = [[NSMutableDictionary alloc] init];
        }
        if([self subStateIndex][start_index_string][state] == nil) {
            [self subStateIndex][start_index_string][state] = [[NSMutableDictionary alloc] init];
        }
        [self subStateIndex][start_index_string][state][set_sub_state_index_string] = @(true);

       
        return NULL;
    }
    NSUInteger startFrom = start_index;
    NSString* subStringFromStart = nil;
    /*if([self endcharDefinitions][state] != nil || [self regexDefinitions][state] != nil) {
        subStringFromStart = [[self sourceText] substringFromIndex:startFrom];
    }
    if([self endcharDefinitions][state] != nil) {
        NSRange rangeOfSemicolon = [subStringFromStart rangeOfString:[self endcharDefinitions][state]];
        if(start_index > [[self currentStepStart] intValue] && start_index+rangeOfSemicolon.location < [[self currentStepStop] intValue]) {
            return NULL;
        }
    }*/
    if([self regexDefinitions][state] != nil) {
        NSError* error = nil;
        NSString* stringCapture = [self regexDefinitions][state];//[[self text] sub]
        subStringFromStart = [[self sourceText] substringFromIndex:startFrom];
        NSRange rangeOfSemicolon = [subStringFromStart rangeOfString:@";"];
        subStringFromStart = [subStringFromStart substringToIndex:rangeOfSemicolon.location];
        NSRegularExpression *regex_strings_result = [NSRegularExpression regularExpressionWithPattern:stringCapture
                                                                                              options:0
                                                                                                error:&error];
        /*NSArray *stringsArray = [regex_strings_result matchesInString:subStringFromStart options:0 range:NSMakeRange(0, [subStringFromStart length])];
        if([stringsArray count] == 0) {
            return NULL;
        }*/
        NSTextCheckingResult *match = [regex_strings_result firstMatchInString:subStringFromStart options:NSMatchingAnchored range:NSMakeRange(0, [subStringFromStart length])];
        if(!match) {
            
            if([self subStateIndex][start_index_string] == nil) {
                [self subStateIndex][start_index_string] = [[NSMutableDictionary alloc] init];
            }
            if([self subStateIndex][start_index_string][state] == nil) {
                [self subStateIndex][start_index_string][state] = [[NSMutableDictionary alloc] init];
            }
            [self subStateIndex][start_index_string][state][set_sub_state_index_string] = @(true);

           
            //NSLog(@"match : %@ - %@ - %@", subStringFromStart, match, state);
            return NULL;
        }/* else {
            NSLog(@"not match : %@", subStringFromStart);
        }*//* else {
            if(match.range.location == NSNotFound || match.range.length == 0) {
                //NSLog(@"match range : %@", @(match.range.length));
                return NULL;
            }
        }*/
    }
    /*if([[self currentStepStop] intValue] != 0 && start_index < [[self currentStepStop] intValue]) {//} && start_index > [[self currentStepStart] intValue]) { //}] && [[self stateDepth][state] intValue] < [[self stateDepthValue] intValue]) {
        
        NSLog(@"code : %@", [[self sourceText] substringWithRange:NSMakeRange(start_index, [[self currentStepStop] intValue]-start_index)]);
        NSLog(@"state : %@ - %@ - %@", state, @(start_index), [self currentStepStop]);
        
        if([self parseObjectItems][@(start_index)] != nil && [self parseObjectItems][@(start_index)][state] != nil) {
            //NSLog(@"return %@", [self parseObjectItems][@(start_index)][state]);
            [self setSubStateRegexIndex:[[NSMutableArray alloc] init]];
            return [self parseObjectItems][@(start_index)][state];
        }
        
        //return NULL;
    }*/
    //if(start_index > [[self currentStepStart] intValue] && start_index < [[self currentStepStop] intValue]) { //} && [[self stateDepth][state] intValue] > [[self stateDepthValue] intValue]) {
    
    /*if(start_index < [[self currentStepStart] intValue] && [self stateDepth][state] > [self stateDepthValue]) {
        NSLog(@"state : %@ - %@ - %@ - lastvalid: %@ - depth: %@ statedepth: %@", state, @(start_index), [self currentStepStart], [self lastValidState], [self stateDepthValue], [self stateDepth][state]);
        return NULL;
    }*/
    ////////////////////////////////NSLog/@"def2");
    NSMutableArray* sub_parse_objects = [[NSMutableArray alloc] init];
    int index = start_index;
    bool sub_state_valid = true;
    NSArray* sub_state_value = sub_state;
    for(NSDictionary* element in sub_state_value) {
        ////////////////////////////////NSLog/@"element");
        //////////////////////////////////////NSLog/@"is nil?");
        //////////////////////////////////NSLog/@"regexvalue: %@ ",[element objectForKey:@"regex"]);
        
        if([element objectForKey:@"regex"] != nil) {
            ////////////////////////////////NSLog/@"regex: %@", element[@"regex"]);
            NSDictionary* has_index = [self hasIndex:start_index state:state];
            if(has_index != NULL) {
                if([(NSNumber*)[has_index objectForKey:@"result"] intValue] == -1) {
                    //////////////////////////////NSLog/@"is -1");
                    sub_state_valid = false;
                } else {
                    index = [(NSNumber*)has_index[@"result"] intValue];
                }
                
            } else {
                NSArray* regex_value = (NSArray*)element[@"regex"];
                NSMutableArray* not = [[NSMutableArray alloc] init];
                //NSString* string_part;
                //regex_value = [regex_value stringByAppendingString:@"+"];
                if([element objectForKey:@"not"] != nil) {
                    if([self language][@"states"][element[@"not"]] != nil) { //[element[@"not"] isKindOfClass:[NSArray class]] &&
                        not = (NSMutableArray*)[self language][@"states"][element[@"not"]];
                        int not_key = 0;
                        NSMutableArray* not_replace = [[NSMutableArray alloc] init];
                        for(NSString* not_value in not) {
                            //not[not_key] = [self strSplit:not_value];
                            //[not_replace setValue:[self strSplit:not_value] forKey:not_key];
                            [not_replace addObject:[self strSplit:not_value]];
                            not_key++;
                        }
                        not = not_replace;
                    }
                }
                ////////////////////////////////////NSLog/@"in1");
                int perform_continue = 1;
                int set_index = index;
                NSArray* delimit_regex = [self delimitRegex];
                if([element objectForKey:@"delimit_regex"] != nil) {
                    delimit_regex = [element objectForKey:@"delimit_regex"];
                }
                NSArray* stop_regex = [[NSArray alloc] init];
                if([element objectForKey:@"stop_regex"] != nil) {
                    stop_regex = [element objectForKey:@"stop_regex"];
                }
                ////////////////////////////////////NSLog/@"in1");
                //////////////////////////////////////NSLog/@"in2");
                //if([regex_value compare:@"/\\s/"]) {
                if([(NSString*)(regex_value[0]) isEqualToString:@" "]) {
                    ////////////////////////////////////NSLog/@"inempty");
                    //regex_value = @"\\s+";
                    /*NSString* character = [self text][set_index];
                    NSError *error = NULL;
                    NSRegularExpression *regex =
                    [NSRegularExpression regularExpressionWithPattern:regex_value
                                                              options:0
                                                                error:&error];
                    
                    NSUInteger numberOfMatches = [regex numberOfMatchesInString:character
                                                                        options:0
                                                                          range:NSMakeRange(0, [character length])];
                    if(numberOfMatches > 0) {
                        set_index++;
                    } else {
                        perform_continue = -2;
                    }*/
                    NSString* regex_value_string = (NSString*)(regex_value[0]);
                    NSString* character = [self text][set_index];
                    
                    if([character isEqualToString:regex_value_string]) {
                        set_index++;
                    } else {
                        perform_continue = -2;
                    }
                    /*$character = $this->text[$set_index]; //
                     $matches = [];
                     if($character == $regex_value) {
                         $matches[] = $character;
                     }
                     if(count($matches) > 0) {
                         $set_index++;
                     } else {
                         $continue = 'invalid';
                     }*/
                } else {
                    ////////////////////////////////////NSLog/@"in3");
                    int counter = 0;
                    while(perform_continue == 1 && set_index < [[self text] count]) {
                        NSString* character = [self text][set_index];
                        /*foreach($not as $not_key => $not_value) {
                             $not_character = array_splice($not[$not_key], 0, 1);
                             if($not_character[0] != $character) {
                                 unset($not[$not_key]);
                             }
                         }*/
                        int not_key = 0;
                        //NSMutableArray* not_store = [NSMutableArray arrayWithArray:not];
                        NSMutableDictionary* not_store = [[NSMutableDictionary alloc] init];
                        int set_not_index = 0;
                        for(NSObject* notItem in not) {
                            [not_store setObject:notItem forKey:[@(set_not_index) stringValue]];
                            set_not_index++;
                        }
                        ////////////////////////////////////NSLog/@"count not: %d count not_store: %d", [not count], [not_store count]);
                        /*int not_remove_key = 0;
                        for(NSMutableArray* not_value in not_store) {
                            NSString* not_character = not_value[0];
                            //[not_value removeObjectAtIndex:0];
                            [not[not_key] removeObjectAtIndex:0];
                            //if(not_character)
                            if(![not_character isEqualToString:character]) {
                                //////////////////////////////////////NSLog/@"!not key: %d", not_key);
                                [not removeObjectAtIndex:not_remove_key];
                                //not_key--;
                            } else {
                                not_remove_key++;
                                not_key++;
                            }
                            //////////////////////////////////////NSLog/@"not key: %d", not_key);
                        }*/
                        //int not_key = 0;
                        for(NSMutableArray* not_value in not) {
                            NSString* not_character = not_store[[@(not_key) stringValue]][0];//not_value[0];
                            ////////////////////////////////NSLog/@"not character: %@", not_character);
                            [not_store[[@(not_key) stringValue]] removeObjectAtIndex:0];
                            if(![not_character isEqualToString:character]) {
                                [not_store removeObjectForKey:[@(not_key) stringValue]];
                            }
                            not_key++;
                        }
                        for(NSString* notkey_value in not_store) {
                            if([not_store[notkey_value] count] == 0) {
                                //////////////////////////////NSLog/@"count is zero %@", notkey_value);
                            }
                        }
                        not = (NSMutableArray*)[not_store allValues];
                        /*foreach($not as $not_key => $not_value) {
                             //var_dump("notValue:", $not_value);
                             $not_character = array_splice($not[$not_key], 0, 1);
                             //var_dump($not_character);
                             if($not_character[0] != $character) {
                                 unset($not[$not_key]);
                             }
                         }*/
                        if([not count] > 0) {
                            for(NSMutableArray* not_string_array in not) {
                                if([not_string_array count] == 0) {
                                    //////////////////////////////NSLog/@"is not_string_array count 0");
                                    perform_continue = -2;
                                }
                            }
                        }
                        if(counter == 0 && [element objectForKey:@"not_starts_with"] != nil) {
                            if([[NSCharacterSet decimalDigitCharacterSet] doesContain:character]) {
                                //////////////////////////////NSLog/@"is decimal");
                                perform_continue = -2;
                            }
                        }
                        if(perform_continue == 1) {
                            //////////////////////////////////NSLog/@" delimitregex: %@", delimit_regex);
                            if([self arrayContains:delimit_regex string:character]) {
                                //////////////////////////////NSLog/@"delimit");
                                perform_continue = -1;
                            } else if([self arrayContains:stop_regex string:character]) {
                                //////////////////////////////NSLog/@"stop");
                                perform_continue = -1;
                            } else {
                                /*NSError *error = NULL;
                                NSRegularExpression *regex_valid_matches =
                                [NSRegularExpression regularExpressionWithPattern:regex_value
                                                                          options:0
                                                                            error:&error];
                                
                                NSUInteger valid_matches = [regex_valid_matches numberOfMatchesInString:character
                                                                                                options:0
                                                                                                  range:NSMakeRange(0, [character length])];
                                if(valid_matches > 0) {
                                    set_index++;
                                } else {
                                    perform_continue = -1;
                                }*/
                                //NSMutableArray* valid_matches = [[NSMutableArray alloc] init];
                                if([(NSString*)(regex_value[0]) isEqualToString:@"all"] || [self arrayContains:regex_value string:[character lowercaseString]]) {
                                    set_index++;
                                } else {
                                    perform_continue = -1;
                                }
                                /*$valid_matches = [];
                                //preg_match($regex_value, $character, $valid_matches);
                                //var_dump(strtolower($character), $regex_value);
                                if($regex_value == 'all' || (is_array($regex_value) && in_array(strtolower($character), $regex_value))) {
                                    $valid_matches[] = $character;
                                }
                                //var_dump($valid_matches);
                                if(count($valid_matches) > 0) { //&& strlen($valid_matches[0]) > 0 //&& strlen($valid_matches[0]) > 0)
                                    ////debug::debug($valid_matches);
                                    $set_index++;
                                } else {
                                    $continue = false;
                                }*/
                            }
                        }
                        counter++;
                    }
                }
                if(perform_continue == -2 || set_index == index) {
                    sub_state_valid = false;
                    [[self subStateRegexIndex] addObject:@{
                        @"start_index": [NSNumber numberWithInt:start_index],
                        @"state": state,
                        @"result": [NSNumber numberWithInt:-1]
                    }];
                } else {
                    index = set_index;
                    [[self subStateRegexIndex] addObject:@{
                        @"start_index": [NSNumber numberWithInt:start_index],
                        @"state": state,
                        @"result": [NSNumber numberWithInt:set_index]
                    }];
                }
            }
        } else if([element objectForKey:@"non_terminal"] != nil) {
            ////////////////////////////////NSLog/@"non_terminal %@", element[@"non_terminal"]);
            //////////////////////////////////////NSLog/@"non_terminal");
            NSMutableArray* not_2 = [[NSMutableArray alloc] init];
            if([element objectForKey:@"not"] != nil) {
                not_2 = element[@"not"];
                if([self arrayContains:not_2 string:[self text][index]]) {
                    sub_state_valid = false;
                }
            }
            NSMutableArray* not_nt = [[NSMutableArray alloc] init];
            if([element objectForKey:@"not_nt"] != nil) {
                not_nt = element[@"not_nt"];
                for(NSString* non_terminal_not in not_nt) {
                    NSDictionary* sub_not_parse = [self subParse:non_terminal_not index:index];
                    if(sub_not_parse != NULL) {
                        sub_state_valid = false;
                    }
                }
            }
            if(sub_state_valid) {
                /*if([(NSString*)element[@"non_terminal"] compare:@"SourceCharacter"]) {
                    ////////////////////////////////////NSLog/@"SourceCharacter in nt");
                    int sub_parse_valid = [self subParseAlt:not_2 index:index];
                    if(sub_parse_valid != -1) {
                        [sub_parse_objects addObject:@{
                            @"start_index": [NSNumber numberWithInt:index],
                            @"stop_index": [NSNumber numberWithInt:sub_parse_valid],
                            @"label": @"SourceCharacter",
                            @"sub_parse_objects": @[]
                        }];
                        index = sub_parse_valid;
                    } else {
                        sub_state_valid = false;
                    }
                } else {*/
                    //////////////////////////////////////NSLog/@"sub parse call");
                    NSDictionary* sub_parse_valid = [self subParse:element[@"non_terminal"] index:index];
                    if(sub_parse_valid != NULL) {
                        //////////////////////////////////////NSLog/@"add to array");
                        [sub_parse_objects addObject:sub_parse_valid];
                        index = [(NSNumber*)sub_parse_valid[@"stop_index"] intValue];
                        //////////////////////////////////////NSLog/@"add to array");
                    } else {
                        /*[self setCurrentStepStop:@(-1)];
                        [self setCurrentStepStart:@(-1)];*/
                        if([element objectForKey:@"opt"] == nil || ([element objectForKey:@"opt"] != nil && [(NSNumber*)element[@"opt"] boolValue] != true)) {
                            sub_state_valid = false;
                        }
                    }
                //}
            }
        } else if([element objectForKey:@"terminal"] != nil) {
            ////////////////////////////////NSLog/@"terminal");
            ////////////////NSLog(element[@"terminal"]);
            int set_index = index;
            
            bool valid = true;
            ////////////////NSLog(@"set_index: %@ - %@ - %@", @(set_index), [self preParsedTerminalIndex][@(set_index)], element[@"terminal"]);
            ////////////////NSLog(@"range: %@", [[self sourceText] substringWithRange:NSMakeRange(0, set_index)]);
            if([self preParsedTerminalIndex][@(set_index)] != nil && [element[@"terminal"] isEqualToString:[self preParsedTerminalIndex][@(set_index)][@"value"]]) {
                set_index += [[self preParsedTerminalIndex][@(set_index)][@"length"] intValue];
                index = set_index;
                ////////////////NSLog(@"ins1 %@", @(index));
            } else if(false) {
                NSMutableArray* not = [[NSMutableArray alloc] init];
                if([element objectForKey:@"not"] != nil) {
                    not = element[@"not"];
                }
                NSMutableDictionary* terminal_index = [[NSMutableDictionary alloc] init];
                NSMutableArray* terminal_split = [self strSplit:element[@"terminal"]];
                for(NSString* terminal_char in terminal_split) {
                    if([self text][set_index] != nil && [[self text][set_index] isEqualToString:terminal_char] && ![self arrayContains:not string:[self text][set_index]]) {
                        terminal_index[@(set_index)] = terminal_char;
                        set_index++;
                    } else {
                        valid = false;
                    }
                    ////////////////////////////////////NSLog/@"terminal_char");
                    ////////////////////////////////////NSLog/@"%@", terminal_char);
                    ////////////////////////////////////NSLog/@"valid: %d", valid);
                }
                if(set_index == index) {
                    valid = false;
                }
                if(valid) {
                    [[self terminalIndex] addEntriesFromDictionary:terminal_index];
                    index = set_index;
                } else {
                    sub_state_valid = false;
                }
            } else {
                valid = false;
                sub_state_valid = false;
            }
            ////////////////////////////////////NSLog/@"sub_state_valid: %d", sub_state_valid);
        }
        if(!sub_state_valid) {
            break;
        }
    }
    ////////////////////////////////////NSLog/@"sub_state_valid_2: %d", sub_state_valid);
    if(sub_state_valid) {
        //////////////////NSLog(@"sub_state_valid");
        //////////////////NSLog(@" nt: %@ ", (NSString*)state);
        /*if([state isEqualToString:@"Statement"]) {
            [self setCurrentStepStart:@(start_index)];
        }*/
        
        /*[self setCurrentStepStart:@(start_index)];
        [self setCurrentStepStop:@(index)];
        [self setStateDepthValue:[self stateDepth][state]];
        [self setLastValidState:state];*/
        //[self setCurrentStepStop:@(-1)];
        [self setCurrentStepStop:@(index)];
        
        //NSLog(@"setparseobject status : stepstart %@ depthvalue %@", [self currentStepStart], [self stateDepthValue]);
        
        NSDictionary* parse_object = @{
            @"start_index": @(start_index),
            @"stop_index": @(index),
            @"label": state,
            @"sub_parse_objects": sub_parse_objects
        };
        if([[self storeStates] indexOfObject:state] == NSNotFound) {
            if([self parseObjectItems][@(start_index)] == nil) {
                [self parseObjectItems][@(start_index)] = [[NSMutableDictionary alloc] init];
            }
            [self parseObjectItems][@(start_index)][state] = parse_object;
        }
        //////////////////NSLog(@"parse: %@", parse_object);
        [self setSubStateRegexIndex:[[NSMutableArray alloc] init]];
        return parse_object;
    }
    [self setCurrentStepStop:@(start_index)];
    //[self setCurrentStepStart:@-1];
    ////////////////////////////////NSLog/@"sub_state_invalid");
    ////////////////NSLog(state);
    if([self subStateIndex][start_index_string] == nil) {
        [self subStateIndex][start_index_string] = [[NSMutableDictionary alloc] init];
    }
    if([self subStateIndex][start_index_string][state] == nil) {
        [self subStateIndex][start_index_string][state] = [[NSMutableDictionary alloc] init];
    }
    [self subStateIndex][start_index_string][state][set_sub_state_index_string] = @(true);

   
    return NULL;
}

- (int) subParseAlt:(NSArray*) not index: (int)index {
    if([self arrayContains:not string:[self text][index]]) {
        index++;
    } else {
        return -1;
    }
    return index;
}
/*
 function sub_parse_alt($not, $index) {
     if(!in_array($this->text[$index], $not)) {
         $index++;
     } else {
         return false;
     }
     return $index;
 }*/

@end
