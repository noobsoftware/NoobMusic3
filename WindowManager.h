//
//  WindowManager.h
//  noobtest
//
//  Created by siggi jokull on 3.12.2022.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface WindowManager : NSObject<NSWindowDelegate> //NSApplicationDelegate, //NSWindowController
//@property (atomic) NSWindow *window;
//@property (weak) IBOutlet NSWindow *window;
- (void) windowDidResize: (NSNotification*) notification;
- (void) windowDidEnterFullScreen:(NSNotification *)notification;
- (void) testFun: (NSString*) input;
- (void) windowDidExpose:(NSNotification *)notification;
@end
