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
@class FindFiles;

@interface PHPSearch : PHPScriptObject
//@property(nonatomic) NSString* operatorValue;
@property(nonatomic) FindFiles* currentSearch;
@property(nonatomic) FindFiles* currentSearchB;
@property(nonatomic) NSMutableDictionary* subResults;
- (void) init: (PHPScriptFunction*) context;
@end
