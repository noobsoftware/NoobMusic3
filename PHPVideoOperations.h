//
//  PHPVideoOperations.h
//  noobtest
//
//  Created by siggi on 7.2.2024.
//

#ifndef PHPVideoOperations_h
#define PHPVideoOperations_h

#import <Foundation/Foundation.h>
#import "PHPScriptObject.h"
#import "VideoOperations.h"
@class PHPScriptFunction;
@class PHPReturnResult;
@class PHPInterpretation;


@interface PHPVideoOperations : PHPScriptObject
- (void) init: (PHPScriptFunction*) context;
@end

#endif /* PHPVideoOperations_h */
