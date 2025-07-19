//
//  ContentLayout.h
//  noobtest
//
//  Created by siggi jokull on 3.12.2022.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "ClickView.h"
#import "JSParse.h"
#import "PHPScriptManager.h"
#import "WindowManager.h"
#import "StackLayout.h"
#import "MainVisual.h"
#import <Quartz/Quartz.h>
#import "LayoutBox.h"
#import "RootLayoutBox.h"
#import "ScrollView.h"
#import "TableView.h"
@class LayoutVideoView;
@class WKWebView;
@class PHPLayoutItem;

@interface ContentLayout : NSObject
@property(nonatomic) WKWebView* web;
@property(nonatomic) NSView* mainView;
@property(nonatomic) LayoutBox* rootLayoutBox;
@property(nonatomic) ClickView* rootClickView;
@property(nonatomic) TableView* tableView;
@property(nonatomic) NSMutableArray* animationViews;
@property(nonatomic) NSMutableArray* animationRects;
@property(nonatomic) NSMutableArray* animationCallbacks;
@property(nonatomic) RootLayoutBox* mainRoot;
@property(nonatomic) double animationTime;
@property(nonatomic) double a;
@property(nonatomic) double b;
@property(nonatomic) double c;
@property(nonatomic) double d;
@property(nonatomic) LayoutBox* videoViewLayoutBox;
@property(nonatomic) ClickView* videoViewClickView;
@property(nonatomic) LayoutBox* windowContainer;
@property(nonatomic) PHPInterpretation* interpretation;
//@property(nonatomic) NSDictionary* language;
//@property(nonatomic) int orientation;
//@property(nonatomic) int spacing;
- (void) makeLayout: (LayoutBox*) box1;
- (CGColorRef) randomColor;
- (void) transform: (NSArray*) views;
- (void) recalculateLayout: (NSRect) frame;
- (NSView*) start;
- (void) addVideoViewLayout: (LayoutBox*) videoViewLayout;
- (double) chooseScreens;
- (void) removeChild: (LayoutBox*) videoViewLayout;
- (void) setWebViewAbove;
- (void) resetVideoViewSizes;
- (void) chooseScreensAlt: (LayoutBox*) layoutBox;
- (void) setFullScreen;
- (void) setNonFullScreen;
@end
