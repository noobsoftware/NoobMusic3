//
//  Preparser.h
//  noobtest
//
//  Created by siggi jokull on 3.7.2023.
//

#ifndef Preparser_h
#define Preparser_h
#import <Foundation/Foundation.h>


@interface Preparser : NSObject
@property(nonatomic) NSMutableArray* tokens;
@property(nonatomic) NSString* sourceText;
@property(nonatomic) NSMutableDictionary* rangeResults;
@property(nonatomic) NSMutableDictionary* strings;
@property(nonatomic) NSMutableDictionary* whiteSpaces;
@property(nonatomic) NSMutableDictionary* identifiers;
@property(nonatomic) NSMutableDictionary* numbers;
- (NSMutableDictionary*) preparseText: (NSString*) sourceText;
@end

#endif /* Preparser_h */
