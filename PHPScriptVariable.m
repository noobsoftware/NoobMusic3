//
//  PHPScriptVariable.m
//  noobtest
//
//  Created by siggi jokull on 2.12.2022.
//

#import "PHPScriptVariable.h"

@implementation PHPScriptVariable
- (void) construct: (NSString*) datatype value: (NSObject*) value {
    [self setDatatype:datatype];
    [self setValue:value];
}
- (NSObject*) get {
    return [self value];
}
@end

