//
//  MainVisual.h
//  noobtest
//
//  Created by siggi jokull on 3.12.2022.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface MainVisual : NSVisualEffectView
//@property(nonatomic) NSDictionary* language;
//@property(nonatomic) int orientation;
//@property(nonatomic) int spacing;
@property(nonatomic) WKWebView* web;
@property(nonatomic) NSWindow* window;
- (BOOL) acceptsFirstResponder;
- (BOOL) canBecomeKeyView;
- (void) mouseDown:(NSEvent *)event;
@end

