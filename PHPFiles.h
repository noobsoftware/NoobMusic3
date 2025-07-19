//
//  PHPMedia.h
//  noobtest
//
//  Created by siggi jokull on 24.2.2023.
//
#import <Foundation/Foundation.h>
#import "PHPScriptObject.h"
@class PHPScriptFunction;
@class PHPReturnResult;
@class PHPScriptVariable;
@class PHPInterpretation;
@class PHPVariableReference;
@class FolderOperations;
@class PHPSearch;

@interface PHPFiles : PHPScriptObject
//@property(nonatomic) NSString* operatorValue;
@property(nonatomic) bool commandKeyDown;
- (void) init: (PHPScriptFunction*) context;
@end
