//
//  JSEngine.h
//  noobtest
//
//  Created by siggi jokull on 1.12.2022.
//
#import <Foundation/Foundation.h>

@class PHPScriptObject;
@class PHPScriptFunction;
@class PHPVariableReference;
@class PHPUndefined;

@interface ToJSON : NSObject
@property(nonatomic) NSMutableArray* toJSONRecursionDetection;
@property(nonatomic) bool assignCacheNodes;
- (NSObject*) toJSONSub: (NSObject*) input;
- (NSString*) toJSONString: (NSObject*) input;
- (NSObject*) toJSON: (NSObject*) input;
//@property(nonatomic) NSDictionary* language;
@end
