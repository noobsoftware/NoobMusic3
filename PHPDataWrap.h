//
//  PHPDataWrap.h
//  noobtest
//
//  Created by siggi jokull on 1.3.2023.
//


#import <Foundation/Foundation.h>
#import "PHPScriptObject.h"
@class PHPScriptFunction;
@class PHPReturnResult;
@class PHPScriptVariable;
@class PHPInterpretation;
@class PHPVariableReference;
@class DBConnection;
@class PHPData;

@interface PHPDataWrap : PHPScriptObject
- (void) init: (PHPScriptFunction*) context instances: (NSDictionary*) instances;
@end

