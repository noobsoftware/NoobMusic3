//
//  PHPReturnResult.h
//  noobtest
//
//  Created by siggi jokull on 1.12.2022.
//
#import <Foundation/Foundation.h>
@class PHPScriptVariable;
@class PHPScriptObject;
@class PHPInterpretation;

@interface PHPReturnResult : NSObject
@property(nonatomic) NSObject*  result;
@property(nonatomic) PHPInterpretation* interpretation;
- (void) construct: (NSObject*) value;
- (NSObject*) get;
@end
