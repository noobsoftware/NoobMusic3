//
//  PHPMedia.h
//  noobtest
//
//  Created by siggi jokull on 24.2.2023.
//
#import <Foundation/Foundation.h>
#import "PHPScriptObject.h"
#import "MediaTab.h"
@class PHPScriptFunction;
@class PHPReturnResult;
@class PHPScriptVariable;
@class PHPInterpretation;
@class PHPVariableReference;
@class ContentLayout;
@class PHPVideoOperations;
@class PHPLayoutItem;

@interface PHPMedia : PHPScriptObject
//@property(nonatomic) NSString* operatorValue;
@property(nonatomic) bool commandKeyDown;
@property(nonatomic) ContentLayout* contentLayout;
//@property(nonatomic) NSMutableArray* 
- (void) init: (PHPScriptFunction*) context;
- (void) chooseScreensAlt: (MediaTab*) mediaTab;
- (MediaTab*) getCurrentMediaTab;
@end
