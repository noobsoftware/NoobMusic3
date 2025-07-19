//
//  PHPScriptVariable.h
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//

#import <Foundation/Foundation.h>

@interface PHPScriptVariable : NSObject
@property(nonatomic) NSString* datatype;
@property(nonatomic) NSObject* value;
- (void) construct: (NSString*) dataType value: (NSObject*) value;
- (NSObject*) get;
@end
