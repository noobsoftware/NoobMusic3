//
//  ViewController.h
//  noobtest
//
//  Created by siggi on 24.11.2022.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "ClickView.h"
#import "JSParse.h"
#import "PHPScriptManager.h"
#import "WindowManager.h"
#import "StackLayout.h"
#import "ContentLayout.h"

@interface ViewController : NSViewController

@property(nonatomic) ClickView* stackView;
@property(nonatomic) NSVisualEffectView* mainView;
- (void) set_window:(NSString*) title;
@end

