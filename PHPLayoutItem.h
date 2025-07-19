//
//  PHPLayoutItem.h
//  noobtest
//
//  Created by siggi on 14.1.2025.
//

#ifndef PHPLayoutItem_h
#define PHPLayoutItem_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "PHPScriptObject.h"
//@class PHPScriptObject;
@class PHPScriptFunction;
@class PHPInterpretation;
@class LayoutBox;
@class ContentLayout;
@class PHPWebView;

@interface PHPLayoutItem : PHPScriptObject
@property(nonatomic) LayoutBox* layoutBox;
- (void) init: (PHPScriptFunction*) context;
//@property(nonatomic) NSDictionary* language;
//@property(nonatomic) int orientation;
//@property(nonatomic) int spacing;

@end

#endif /* PHPLayoutItem_h */
