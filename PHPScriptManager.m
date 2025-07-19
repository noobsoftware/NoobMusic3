//
//  PHPScriptManager.m
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//
#import "PHPScriptManager.h"

@implementation PHPScriptManager

- (void) run: (NSString*) text {
    text = [self pregReplace:@"\\s+" input:text  replace:@" "];
    /*NSString *regexToReplaceRawLinks = @"\\[.+?\\|(.+?)\\]";

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexToReplaceRawLinks
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];

    NSString *string = @"[id123|Some Name]";

    NSString *modifiedString = [regex stringByReplacingMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])
                                                          withTemplate:@"$1"];*/
    /*    protected $keywords = [
     '/private\s/',
     '/public\s/',
     '/protected\s/',
     '/function\s/',
     '/class\s/',
     '/\sextends\s/',
     '/return\s/',
     '/\sas\s/',
     '/else\sif/',
     '/new\s/',
     '/\s+/',
 ];
 protected $replace = [
     'private#',
     'public#',
     'protected#',
     'function#',
     'class#',
     '#extends#',
     'return#',
     '#as#',
     'else#if',
     'new#',
     ''
 ];;*/
    [self setKeywords:@[
        @"private\\s",
        @"public\\s",
        @"protected\\s",
        @"function\\s",
        @"class\\s",
        @"\\sextends\\s",
        @"return\\s",
        @"\\sas\\s",
        @"else\\sif",
        @"new\\s",
        @"\\s+"
    ]];
    [self setReplace:@[
        @"private#",
        @"public#",
        @"protected#",
        @"function#",
        @"class#",
        @"#extends#",
        @"return#",
        @"#as#",
        @"else#if",
        @"new#",
        @""
    ]];
    int index = 0;
    for(NSString* keyword in [self keywords]) {
        NSString* replace = [self replace][index];
        text = [self pregReplace:keyword input:text  replace:replace];
        index++;
    }
    ////////////////////////NSLog/@"%@", text);
}

- (NSString*) pregReplace: (NSString*) regexPattern input: (NSString*) string replace: (NSString*) replaceValue {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];

    //NSString *string = @"[id123|Some Name]";

    NSString *modifiedString = [regex stringByReplacingMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])
                                                          withTemplate:replaceValue];
    //NSString* modifierString = [regex matchesInString:string options:NSMatchingWithTransparentBounds range:<#(NSRange)#>]
    return modifiedString;
}

@end
