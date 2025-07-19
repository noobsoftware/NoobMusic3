//
//  PHPIncludedObjects.h
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import <Foundation/Foundation.h>
#import "PHPScriptObject.h"
#import "PHPMath.h"
@class PHPScriptFunction;
@class PHPReturnResult;
@class PHPScriptVariable;
@class PHPInterpretation;
@class PHPVariableReference;
@class WKWebView;
@class PHPRegex;
@class PHPStrings;
@class WKMessages;
@class GeneralOperations;
//@class PHPIntervalItem;
//@class PHPActionHandler;
@class WSServer;

@interface PHPIncludedObjects : PHPScriptObject
@property(nonatomic) NSMutableDictionary* globalCallbacks;
//@property(nonatomic) NSString* operatorValue;
@property(nonatomic) WSServer* serverWebsockets;
@property(nonatomic) NSOperationQueue* queue;
- (void) init: (PHPScriptFunction*) context;
@end
