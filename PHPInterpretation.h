//
//  PHPInterpretation.h
//  noobtest
//
//  Created by siggi jokull on 1.12.2022.
//

#import <Foundation/Foundation.h>
#import "PHPScriptFunction.h"
#import "ToJSON.h"
#import "PHPUndefined.h"
@class PHPFiles;
@class PHPControl;
@class PHPMulticonditionalControl;
@class PHPLoopControl;
@class PHPForLoopControl;
@class PHPIncludedObjects;
@class PHPScriptVariable;
@class PHPStrings;
@class PHPData;
@class PHPDates;
@class PHPMedia;
@class PHPDataWrap;
@class WKWebView;
@class DBConnection;
@class JSParse;
@class WKMessages;
@class PHPMetadataItem;
@class PHPLayoutItem;
//@class PHPCallbackReference;
/*
 gera afrit af intepretation, gera setIntepretation a scriptFunction vid async call
*/
@interface PHPInterpretation : NSObject
@property(nonatomic) PHPLayoutItem* mainLayoutItem;
//@property(nonatomic) NSDictionary* language;
@property(atomic) NSMutableArray* toUnset;
@property(nonatomic) NSMutableDictionary* properties;
@property(nonatomic) JSParse* jsParse;
@property(nonatomic) long debugCounter;
@property(nonatomic) bool isCopy;
@property(nonatomic) WKWebView* webView;
@property(nonatomic) dispatch_queue_t messagesQueue;//dispatch_queue_t messagesQueue;
//@property(nonatomic) dispatch_queue_t messagesQueueAlt;
@property(nonatomic) dispatch_queue_t timeQueue;//dispatch_queue_t messagesQueue;
//@property(nonatomic) NSOperationQueue* queueMain;
@property(nonatomic) NSMutableArray* parsedTree;
@property(nonatomic) NSMutableDictionary* definition;
@property(nonatomic) NSString* source;
@property(nonatomic) PHPScriptFunction* __strong globalContext;
@property(nonatomic) PHPScriptFunction* currentContext;
@property(nonatomic) PHPScriptFunction* lastSetFunctionCallingContext;
@property(nonatomic) NSMutableArray* toJSONRecursionDetection;
@property(nonatomic) long threadCounter;
@property(nonatomic) NSArray* affectualFunctions;
@property(nonatomic) WKMessages* wkmessages;
@property(nonatomic) NSMutableDictionary* jsonState;
@property(nonatomic) NSMutableDictionary* globalCache;
@property(nonatomic) PHPIncludedObjects* mainObjectItem;
@property(nonatomic) PHPMedia* currentPHPMedia;
@property(nonatomic) NSOperationQueue* queue;
@property(atomic) NSMutableArray* currentlyRunningOperations;
//- (void) loadImage;
- (void) addWsConnection: (NSObject*) input;
- (void) receiveRequest: (NSObject*) input callback: (PHPScriptFunction*) callback;
- (void) receiveDataDict: (NSObject*) input callback: (id) callback;
//- (NSDictionary*) receiveDataDict: (NSObject*) input function: (NSString*) function;
- (NSString*) decouple;
- (NSMutableArray*) getArrayKeys: (NSDictionary*) values;
- (bool) isUndefined: (NSObject*) value;
- (PHPInterpretation*) copyIntepretation;
- (WKWebView*) getWebView;
- (void) construct: (NSMutableArray*) parsedTree definition: (NSMutableDictionary*) definition source: (NSString*) source;
- (NSObject*) toJSON: (NSObject*) input;
- (NSString*) toJSONString: (NSObject*) input;
- (NSObject*) makeIntoObjects: (NSObject*)  input;
//- (NSString*) receiveData: (NSObject*) input;
- (void) receiveData:(NSObject *)input callback:(id)callback;
//- (NSObject*) jsonState;
- (NSMutableDictionary*) removeWhiteSpace: (NSMutableDictionary*) node;
- (PHPScriptFunction*) start: (PHPScriptFunction*) globalContext callback: (id) callback;
- (void) initGlobalContext;
- (void) setPHPData: (PHPDataWrap*) phpData;
- (void) setPHPMedia: (PHPMedia*) phpMedia;
- (void) setPHPItem: (PHPScriptObject*) phpItem name: (NSString*) name;
- (void) execute: (NSMutableDictionary*) subParseObject context: (PHPScriptObject*) context lastParentContextParseLabel: (NSString*) lastParentContextParseLabel lastParentContext: (PHPScriptObject*) lastParentContext control: (PHPControl*) control subSwitches: (NSMutableDictionary*) subSwitches lastSetValidContext: (PHPScriptFunction*) lastSetValidContext preventSetValidContext: (NSNumber*) preventSetValidContext preserveContext: (PHPScriptObject*) preserveContext inParentContextSetting: (NSNumber*) inParentContextSetting lastCurrentFunctionContext: (PHPScriptFunction*) lastCurrentFunctionContext containedAsync: (bool) containedAsync callback: (id) callback;
- (long) arrayHas: (NSMutableArray*) array string: (NSString*) string;
- (NSMutableDictionary*) getSubParseObject: (NSMutableDictionary*) parseObjects nt: (NSObject*) name offset: (long) offset;
- (NSObject*) getValue: (NSMutableDictionary*) parseObjects name: (NSString*) name offset: (long) offset;
- (NSObject*) getText: (int) startIndex stop: (int) stopIndex isString: (bool) isString parseObject: (NSMutableDictionary*) parseObject;
- (NSMutableDictionary*) getState: (PHPScriptFunction*) context;
//- (bool) constructFromFile;
@end
