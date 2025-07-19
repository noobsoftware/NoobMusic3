//
//  ClickView.h
//  noobtest
//
//  Created by siggi on 25.11.2022.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

@interface ClickView : NSView
/*@property(nonatomic) NSArray *clickEventHandlers;
- (void) addClickEventHandlers:(void(^)(NSEvent *))callback;
- (void) mouseDown:(NSEvent *)event;
- (void) mouseEntered:(NSEvent *)event;*/

/*@property(nonatomic, copy) NSString *open_folder_path_value;
- (double) volume;
- (NSString*) get_open_folder_path_value;
- (void) selectFileButtonAction;
- (NSString*) app_group_container: (NSString*) app_group_name;
- (void) set_events;
- (void) set_window:(NSString*) title;*/
//- (void)click_callback:(void(^)(NSEvent *))callback;
@property(nonatomic) NSTimer* viewTimer;
- (BOOL) acceptsFirstResponder;
- (BOOL) canBecomeKeyView;

//- (void) mouseDown:(NSEvent *)event;
- (WKWebView*) assignWebView: (long) index;
//- (NSTimer*) viewTimer;
@end
