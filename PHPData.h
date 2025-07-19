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
@class DBConnection;


@interface PHPData : PHPScriptObject
//@property(nonatomic) NSString* operatorValue;
- (void) init: (PHPScriptFunction*) context sql: (DBConnection*) sql;
@end
