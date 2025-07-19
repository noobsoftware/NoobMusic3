//
//  PHPMedia.h
//  noobtest
//
//  Created by siggi jokull on 24.2.2023.
//
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "PHPScriptObject.h"
@class PHPScriptFunction;
@class PHPReturnResult;
@class PHPScriptVariable;
@class PHPInterpretation;
@class PHPVariableReference;

@interface PHPMetadataItem : PHPScriptObject
//@property(nonatomic) NSString* operatorValue;
@property(nonatomic) NSMetadataItem* item;
- (void) init: (PHPScriptFunction*) context;
- (void) setItemValue: (NSMetadataItem*) item;
@end
