//
//  JSParse.h
//  noobtest
//
//  Created by siggi jokull on 30.11.2022.
//

#import <Foundation/Foundation.h>
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import "Preparser.h"

@interface JSParse : NSObject
@property(nonatomic) NSMutableDictionary* resultsDefinition;
@property(nonatomic) NSDictionary* language;
@property(nonatomic) NSString* sourceText;
@property(nonatomic) NSMutableArray* text;
@property(nonatomic) NSMutableDictionary* subStateIndex;
@property(nonatomic) NSMutableDictionary* regexDefinitions;
@property(nonatomic) NSMutableArray* skipChars;
@property(nonatomic) NSMutableArray* storeStates;
@property(nonatomic) NSMutableDictionary* endcharDefinitions;
@property(nonatomic) NSMutableDictionary* parseObjectItems;
@property(nonatomic) NSNumber* lastCurrentStepStart;
@property(nonatomic) NSNumber* currentStepStart;
@property(nonatomic) NSNumber* currentStepStop;
@property(nonatomic) NSNumber* stateDepthValue;
@property(nonatomic) NSString* lastValidState;
@property(nonatomic) NSMutableDictionary* stateDepth;
//sub_state_terminal_index
@property(nonatomic) NSMutableDictionary* subStateTerminalIndex;
//sub_state_regex_index
@property(nonatomic) NSMutableArray* subStateRegexIndex;
@property(nonatomic) NSArray* delimitRegex;
@property(nonatomic) NSMutableDictionary* terminalIndex;
@property(nonatomic) NSMutableDictionary* preParsedTerminalIndex;
@property(nonatomic) NSDictionary* postProcessingDefinition;
@property(nonatomic) NSMutableArray* parse_results;
@property(nonatomic) NSString* mainString;
@property(nonatomic) NSMutableDictionary* strings;
@property(nonatomic) NSMutableDictionary* whiteSpaces;
@property(nonatomic) NSMutableDictionary* identifiers;
@property(nonatomic) NSMutableDictionary* numbers;
//@property(nonatomic) NSArray *clickEventHandlers;
//- (void) addClickEventHandlers:(void(^)(NSEvent *))callback;
- (void) run: (PHPInterpretation*) interpret callback: (id) callback;
- (void) start;
- (NSMutableArray*) parse:(NSString*)input withLanguage:(NSDictionary*)language;
- (void) varDump: (NSObject*) object;
@end
