//
//  MediaTab.h
//  noobtest
//
//  Created by siggi jokull on 24.2.2023.
//

#ifndef MediaTab_h
#define MediaTab_h
#import <Foundation/Foundation.h>
#import <VLCKit/VLCKit.h>
#import "PHPScriptObject.h"
@class PHPScriptFunction;
@class PHPReturnResult;
@class PHPScriptVariable;
@class PHPInterpretation;
@class PHPVariableReference;
@class LayoutBox;
@class ContentLayout;
@class TabMedia;
@class PHPMedia;

@interface MediaTab : PHPScriptObject
//@property(nonatomic) NSString* operatorValue;
//@property(nonatomic) PHPScriptFunction* context;
@property(nonatomic) PHPMedia* phpMedia;
@property(nonatomic) TabMedia* tabMedia;
@property(nonatomic) int mediaIndex;
@property(nonatomic) LayoutBox* layoutBox;
- (void) init: (PHPScriptFunction*) context contentLayout: (ContentLayout*) contentLayout;
@end

#endif /* MediaTab_h */

/*    */
