//
//  PHPDates.h
//  noobtest
//
//  Created by siggi jokull on 23.2.2023.
//

#import <Foundation/Foundation.h>
#import "PHPScriptObject.h"
@class PHPScriptFunction;
@class PHPReturnResult;
@class PHPScriptVariable;
@class PHPInterpretation;
@class PHPVariableReference;
@class NoobCalendar;


@interface PHPDates : PHPScriptObject
//@property(nonatomic) NSString* operatorValue;
- (void) init: (PHPScriptFunction*) context;
@end
