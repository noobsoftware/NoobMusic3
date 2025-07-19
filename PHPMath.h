//
//  PHPIncludedObjects.h
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import <Foundation/Foundation.h>
#import "PHPScriptObject.h"
@class PHPScriptFunction;
@class PHPReturnResult;
@class PHPScriptVariable;
@class PHPInterpretation;
@class PHPVariableReference;
@class WKWebView;


@interface PHPMath : PHPScriptObject
//@property(nonatomic) NSString* operatorValue;
- (void) init: (PHPScriptFunction*) context;
- (NSNumber*) mult: (NSNumber*) a b: (NSNumber*) b;
@end
