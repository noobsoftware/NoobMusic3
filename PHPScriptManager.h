//
//  PHPScriptManager.h
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//


#import <Foundation/Foundation.h>

@interface PHPScriptManager : NSObject
@property(nonatomic) NSArray* keywords;
@property(nonatomic) NSArray* replace;
- (void) run: (NSString*) text;
- (NSString*) pregReplace: (NSString*) regexPattern input: (NSString*) string replace: (NSString*) replaceValue;
@end
