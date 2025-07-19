//
//  ClickVideoView.h
//  noobtest
//
//  Created by siggi jokull on 28.2.2023.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <VLCKit/VLCKit.h>
#import <WebKit/WebKit.h>
@class PHPScriptFunction;
@class PHPMedia;
@class MediaTab;
@class PHPReturnResult;

@interface ClickVideoView : VLCVideoView
@property(nonatomic) WKWebView* web;
@property(nonatomic) PHPMedia* phpMedia;
@property(nonatomic) MediaTab* mediaTab;
@property(nonatomic) NSMutableArray* callbacks;
- (void) mouseDown:(NSEvent *)event;
- (void) initArrays;
/*@property(nonatomic) NSArray *clickEventHandlers;
- (void) addClickEventHandlers:(void(^)(NSEvent *))callback;

- (void) mouseEntered:(NSEvent *)event;*/

/*@property(nonatomic, copy) NSString *open_folder_path_value;
- (double) volume;
- (NSString*) get_open_folder_path_value;
- (void) selectFileButtonAction;
- (NSString*) app_group_container: (NSString*) app_group_name;
- (void) set_events;
- (void) set_window:(NSString*) title;*/
//- (void)click_callback:(void(^)(NSEvent *))callback;

@end
