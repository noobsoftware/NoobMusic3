//
//  LayoutBox.h
//  noobtest
//
//  Created by siggi jokull on 4.12.2022.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "ClickView.h"
#import "ScrollView.h"
#import <Quartz/Quartz.h>
#import "ClickVideoView.h"
#import <WebKit/WebKit.h>
//#import <VLCKit/VLCKit.h>
@class VLCVideoView;
@class ContentLayout;
@class PHPLayoutItem;
@class PHPInterpretation;

@interface LayoutBox : NSObject
@property(nonatomic) ContentLayout* contentLayout;
@property(nonatomic) bool isVideoView;
@property(nonatomic) NSView* mainView;
@property(nonatomic) NSScrollView* scrollView;
@property(nonatomic) NSTextField* textField;
@property(nonatomic) NSString* stringContent;

@property(nonatomic) bool preventReverse;
@property(nonatomic) bool isReverse;
//@property(nonatomic) NSDictionary* language;
//@property(nonatomic) int orientation;
//@property(nonatomic) int spacing;
//@property(nonatomic) bool hasScroll;
@property(nonatomic) double x;
@property(nonatomic) double y;
@property(nonatomic) bool resizeChildToSize;
@property(nonatomic) double setHeight;
@property(nonatomic) double setWidth;
@property(nonatomic) bool direction;
@property(nonatomic) bool orientation;
@property(nonatomic) int overflow;
@property(nonatomic) int heightType;
@property(nonatomic) int widthType;
@property(nonatomic) bool display;
@property(nonatomic) NSString* id;
@property(nonatomic) NSMutableArray* classes;
@property(nonatomic) int horizontalAlignment;
@property(nonatomic) int verticalAlignment;
@property(nonatomic) NSMutableArray* setRectangle;
@property(nonatomic) NSMutableArray* rectangleType;
@property(nonatomic) NSMutableArray* rectangleSubtraction;
@property(nonatomic) NSMutableArray* rectangleAddition;
@property(nonatomic) NSMutableArray* children;
@property(nonatomic) LayoutBox* parent;

@property(nonatomic) double calculatedHeight;
@property(nonatomic) double calculatedWidth;
@property(nonatomic) double calculatedHorizontalEnd;
@property(nonatomic) double calculatedVerticalEnd;
@property(nonatomic) double calculatedHorizontalPosition;
@property(nonatomic) double calculatedVerticalPosition;

@property(nonatomic) NSMutableArray* animationViews;
@property(nonatomic) NSMutableArray* animationRects;
@property(nonatomic) NSArray* animationLayoutBoxes;
@property(nonatomic) NSMutableArray* animationCallbacks;
@property(nonatomic) bool isAnimated;
@property(nonatomic) NSView* lastSetChildRoot;

@property(nonatomic) CGRect calculatedResultValue;
@property(nonatomic) PHPLayoutItem* layoutItem;
//- (void) recalculateLayout;
- (WKWebView*) assignWebView: (long) index;
-(void)transform: (NSMutableArray*) views rects: (NSMutableArray*) rects time: (double) timeValue a:(double) a b:(double) b c:(double) c d:(double) d callbacks: (NSArray*) callbacks;
- (void) recalculateLayout;
- (void) recalculateLayout: (bool) animate animateTime: (double) animateTime easingA: (double) a easingB: (double) b easingC: (double) c easingD: (double) d callbacks:(NSArray*) callbacks layoutBoxes: (NSArray*) layoutBoxes;
- (void) setBox: (NSDictionary*) setValues;
- (NSRect) getResultValues: (bool) forScroll;
- (NSView*) make: (bool) returnReverse isRootCall: (bool) isRootCall; //: (ClickView*) parentContainer contentLayout: (ContentLayout*) contentLayout;
- (void) setParentForChildren;
- (LayoutBox*) getPreviousElement: (LayoutBox*) element;
- (double) getHorizontalEnd;
- (double) getHorizontalPosition;
- (double) getVerticalEnd;
- (int) getRemainingChildrenCount: (LayoutBox*) element;
- (double) getVerticalPosition;
- (double) getHeight: (bool) returnSetHeight forScroll: (bool) forScroll;
- (double) getHeightSub: (bool) returnSetHeight forScroll: (bool) forScroll;
- (double) getWidth: (bool) return_set_width;
- (double) getWidthSub: (bool) return_set_width;
- (void) addChildren: (NSArray*) children;
- (void) fade_out;
- (void) fade_in;
- (void) fadeSwitch: (LayoutBox*) switchItem;
- (void) removeChild: (LayoutBox*) child;
- (void) fillView;
//- (NSDictionary*) getBox;
@end

