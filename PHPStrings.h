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


@interface PHPStrings : PHPScriptObject
//@property(nonatomic) NSString* operatorValue;
- (void) init: (PHPScriptFunction*) context;
@end
