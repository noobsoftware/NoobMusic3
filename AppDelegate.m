//
//  AppDelegate.m
//  noobtest
//
//  Created by siggi on 24.11.2022.
//

#import "AppDelegate.h"
#import "PHPInterpretation.h"
#import "PHPData.h"
#import "PHPMedia.h"
#import "PHPDataWrap.h"

#import "VideoOperations.h"

#import "TabMediaMirror.h"
#import "TabMedia.h"
#import "MediaTab.h"

#import "AdditionalWindowDelegate.h"
#import "PHPIncludedObjects.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching_depr:(NSNotification *)aNotification {
    
}

- (bool) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return true;
}

- (void) windowDidEnterFullScreen:(NSNotification *)notification {
    PHPScriptFunction* callback = (PHPScriptFunction*)[(PHPIncludedObjects*)[[self mainInterpretation] mainObjectItem] globalCallbacks][@"fullscreen"];
    [callback callCallback:@[]];
}

- (void) windowDidExitFullScreen:(NSNotification *)notification {
    PHPScriptFunction* callback = (PHPScriptFunction*)[(PHPIncludedObjects*)[[self mainInterpretation] mainObjectItem] globalCallbacks][@"exit_fullscreen"];
    [callback callCallback:@[]];
    
}

/*- (void) windowDidEnterFullScreen:(NSNotification *)notification {
    [[self mainWeb] evaluateJavaScript:@"app.fullscreen();" completionHandler:^(id _Nullable mainInput, NSError * _Nullable error) {
        //////////////NSLog(@"error");
    }];
    [[self mainContentLayout] setFullScreen];
}

- (void) windowDidExitFullScreen:(NSNotification *)notification {
    [[self mainWeb] evaluateJavaScript:@"app.exit_fullscreen();" completionHandler:^(id _Nullable mainInput, NSError * _Nullable error) {
        //////////////NSLog(@"error");
    }];
    [[self mainContentLayout] setNonFullScreen];
}*/

/*-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSString* message_body = [message body];
    ////////////////////////NSLog/@"message body");
}*/

- (NSMutableArray*) splice: (NSMutableArray*) arr index: (NSNumber*) index count : (NSNumber*) count {
    NSRange range = NSMakeRange([index longLongValue], [count longLongValue]);
    
    NSMutableArray* result = [[NSMutableArray alloc] initWithArray:[arr subarrayWithRange:range]];
    [arr removeObjectsInRange:range];
    return result;
}

- (NSMutableArray*) concat: (NSMutableArray*) arr arr2: (NSMutableArray*) arr2 {
    return [[NSMutableArray alloc] initWithArray:[arr arrayByAddingObjectsFromArray:arr2]];
}

/*- (void) applicationWillFinishLaunching:(NSNotification *)notification {
    
    PHPInterpretation* mainInterpretation = [[PHPInterpretation alloc] init];
    [mainInterpretation initGlobalContext];
    [self setMainInterpretation:mainInterpretation];
    
    
    JSParse* js_parse = [JSParse alloc];
    [js_parse start];
    [self setJs_parse:js_parse];
    
    
    NSWindow* window = [[NSApplication sharedApplication] windows][0];
    [window setAlphaValue:0];
}*/

- (void) applicationWillFinishLaunching:(NSNotification *)notification {
    
    /*PHPInterpretation* mainInterpretation = [[PHPInterpretation alloc] init];
    [mainInterpretation initGlobalContext];
    [self setMainInterpretation:mainInterpretation];
    
    
    JSParse* js_parse = [JSParse alloc];
    [js_parse start];
    [self setJs_parse:js_parse];*/
    
    [self loadAppStart];
    
    
    NSWindow* window = [[NSApplication sharedApplication] windows][0];
    [window setAlphaValue:0];
}

- (void) restartApp {
    [[self wkMessages] setPrevent:true];
    [[self viewTimer] invalidate];
    [self setViewTimer:nil];
    [self loadAppStart];
    [self continueLoad];
}

- (void) loadAppStart {
    PHPInterpretation* mainInterpretation = [[PHPInterpretation alloc] init];
    [mainInterpretation initGlobalContext];
    [self setMainInterpretation:mainInterpretation];
    
    
    JSParse* js_parse = [JSParse alloc];
    [js_parse start];
    [self setJs_parse:js_parse];
}

- (void) continueLoad {
    PHPInterpretation* mainInterpretation = [self mainInterpretation];
    /*[[self wkMessages] setInterpretation:mainInterpretation];
    [mainInterpretation setWkmessages:[self wkMessages]];
    [mainInterpretation setWebView:[self mainWeb]];*/
    /*DBConnection* sql = [[DBConnection alloc] init];
    [sql setInterpretation:mainInterpretation];
    [sql initializeDatabase:@"main_av.db"];
    PHPData* phpData = [[PHPData alloc] init];
    [phpData init:[mainInterpretation currentContext] sql:sql];
    [phpData setInterpretation:mainInterpretation];
    
    
    
    PHPDataWrap* phpDataWrap = [[PHPDataWrap alloc] init];
    [phpDataWrap init:[mainInterpretation currentContext] instances:@{
        @"main": phpData,
    }];*/
    DBConnection* sql = [[DBConnection alloc] init];
    [sql setInterpretation:mainInterpretation];
    [sql initializeDatabase:@"NoobMusic.db"];
    //[sql executeQuery:@"" values:nil];
    
    
    
    PHPData* phpData = [[PHPData alloc] init];
    [phpData init:[mainInterpretation currentContext] sql:sql];
    [phpData setInterpretation:mainInterpretation];
    
    /*DBConnection* sqlCinema = [[DBConnection alloc] init];
    [sqlCinema setInterpretation:mainInterpretation];
    [sqlCinema initializeDatabase:@"NoobCinema.db"];
    PHPData* phpDataCinema = [[PHPData alloc] init];
    [phpDataCinema init:[mainInterpretation currentContext] sql:sqlCinema];
    [phpDataCinema setInterpretation:mainInterpretation];
    
    DBConnection* sqlTV = [[DBConnection alloc] init];
    
    [sqlTV setInterpretation:mainInterpretation];
    [sqlTV initializeDatabase:@"NoobTV.db"];
    PHPData* phpDataTV = [[PHPData alloc] init];
    [phpDataTV init:[mainInterpretation currentContext] sql:sqlTV];
    [phpDataTV setInterpretation:mainInterpretation];*/
    
    PHPDataWrap* phpDataWrap = [[PHPDataWrap alloc] init];
    [phpDataWrap init:[mainInterpretation currentContext] instances:@{
        @"main": phpData,
        //@"cinema": phpDataCinema,
        //@"tv": phpDataTV
    }];
    
    //[mainInterpretation setWkmessages:[self wkMessages]];
    //////////////////NSLog/@"init sql complete");
    
    [mainInterpretation setPHPData:phpDataWrap];
    
    PHPMedia* phpMedia = [[PHPMedia alloc] init];
    [phpMedia init:[mainInterpretation currentContext]];
    [phpMedia setContentLayout:[self mainContentLayout]];
    [mainInterpretation setPHPMedia:phpMedia];
    
    
    PHPIncludedObjects* mainObject = [[self mainInterpretation] mainObjectItem];
    [mainObject setInterpretation:mainInterpretation];
    
    PHPScriptFunction* reload_app = [[PHPScriptFunction alloc] init];
    [reload_app initArrays];
    [mainObject setDictionaryValue:@"reload_app" value:reload_app];
    [reload_app setPrototype:mainObject];
    [reload_app setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSLog(@"restart app");
        [self restartApp];
        //[[NSApplication sharedApplication] terminate:self];
        return nil;
    } name:@"main"];
    
    //var WKWebView
    [_js_parse run:[self mainInterpretation] callback:^{
        NSLog(@"ran");
    }];
    
    
    
    //if(![mainInterpretation constructFromFile]) {
    /*[[self wkMessages] setPrevent:false];
    [[self mainWeb] setNavigationDelegate:self];
    /*NSURL* nsurl = [[NSURL alloc] initWithString:@"http://127.0.0.1/index_output.html"];
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:nsurl];
    [[self mainWeb] loadRequest:req];
    
    NSString* pathhtml = [[NSBundle mainBundle] pathForResource:@"index_output"
                                                     ofType:@"html"];
    
    NSURL* fileURLHTML = [[NSURL alloc] initFileURLWithPath:pathhtml];
     ////////////NSLog(@"fileurlhtml: %@ - %@", fileURLHTML, pathhtml);
     
    [[self mainWeb] loadFileURL:fileURLHTML allowingReadAccessToURL:fileURLHTML];//*/
    
    /*[self setViewTimer:[NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:[NSBlockOperation blockOperationWithBlock:^{
        //return;
        //CGEventSourceRef source = CGEventSourceCreate(CGEventSourceGetSourceStateID(NULL));
        double seconds = CGEventSourceSecondsSinceLastEventType(kCGEventSourceStateCombinedSessionState, kCGEventMouseMoved);
        ////////////////////NSLog/@"seconds : %f", seconds);
        if(seconds > 1.5 || [[NSApplication sharedApplication] keyWindow] == nil) {
            NSString* callString = @"app.controls.hide_controls();";
            if([[NSApplication sharedApplication] keyWindow] == nil) {
                callString = @"app.controls.hide_controls(1);";
            }
            [_mainWeb evaluateJavaScript:callString completionHandler:^(id _Nullable, NSError * _Nullable error) {
                
            }];
            //(([self styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask)
            if([[NSApplication sharedApplication] keyWindow] != nil) {
                if(([[[NSApplication sharedApplication] keyWindow] styleMask] & NSWindowStyleMaskFullScreen) == NSWindowStyleMaskFullScreen) {
                    [NSCursor setHiddenUntilMouseMoves:true];
                }
            }
            //if fullscreen
            //NSCursor.SetHiddenUntilMouseMoves(true);
        } else {
            [_mainWeb evaluateJavaScript:@"app.controls.display_controls();" completionHandler:^(id _Nullable, NSError * _Nullable error) {
                
            }];
        }
            //[[self mainContentLayout] recalculateLayout:[[self mainContentView] frame]];
        }]
          selector:@selector(main)
          userInfo:nil
          repeats:YES
    ]];*/

    /*UIGraphicsBeginImageContextWithOptions(drawView.bounds.size, NO, 0.0);
     [[drawView layer] renderInContext:UIGraphicsGetCurrentContext()];
     UIImage *ViewImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();

     NSData *pngData = UIImagePNGRepresentation(ViewImage);
     [pngData writeToFile:@"/Users/_username_/Desktop/Image@2x.png" atomically:NO];

     // Low resolution
     UIGraphicsBeginImageContext(drawView.bounds.size);
     [[drawView layer] renderInContext:UIGraphicsGetCurrentContext()];
     ViewImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();

     pngData = UIImagePNGRepresentation(ViewImage);
     [pngData writeToFile:@"/Users/_username_/Desktop/Image.png" atomically:NO];
     */
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    /*NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.7
                                                      target:[NSBlockOperation blockOperationWithBlock:^{
        
        //[[self mainContentLayout] recalculateLayout:[[self mainContentView] frame]];
            //[self addNewWindow];
        }]
          selector:@selector(main)
          userInfo:nil
          repeats:NO
    ];*/
    //[_js_parse run:[self mainInterpretation]];
}

- (NSMutableArray*) generate: (NSMutableArray*) values {
    if([values count] == 1) {
        return [[NSMutableArray alloc] initWithArray:@[values]];
    }
    NSMutableArray* result = [[NSMutableArray alloc] init];
    long key = 0;
    for(NSNumber* value in values) {
        NSMutableArray* arrangement = [[NSMutableArray alloc] initWithArray:@[value]];
        NSMutableArray* subset = [[NSMutableArray alloc] initWithArray:values];
        [self splice:subset index:@(key) count:@(1)];
        NSMutableArray* generated = [self generate:subset];
        for(NSMutableArray* sub_arrangement in generated) {
            [result addObject:[self concat:arrangement arr2:sub_arrangement]];
        }
        key++;
    }
    return result;
}

/*- (void) callprint {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSURL* containerURL = [fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask][0];
    containerURL = [containerURL URLByAppendingPathComponent:@"screenLive"];
    //[containerURL ]
    if(![fileManager fileExistsAtPath:@([containerURL fileSystemRepresentation])]) {
        [fileManager createDirectoryAtURL:containerURL withIntermediateDirectories:true attributes:nil error:nil];
    }
    //containerURL = [containerURL URLByAppendingPathComponent:@"screen"];
    NSString* libraryLocation = @([containerURL fileSystemRepresentation]);
    
    
    
    MediaTab* mediaTab = [[[self mainInterpretation] currentPHPMedia] getCurrentMediaTab];
    //NSLog(@"media tab : %@", mediaTab);
    if(mediaTab != nil) {
        
        //vantar interleaved index
        //NSString* filenameRemove;
        NSString* filename;
        NSString* filenameRemove = [libraryLocation stringByAppendingPathComponent:@"1.png"];
        filename = [libraryLocation stringByAppendingPathComponent:@"0.png"];
      
        NSString* valueFilename = nil;
        if(![fileManager fileExistsAtPath:filenameRemove]) {
            valueFilename = filename;
        }
        if(mediaTab != nil && [mediaTab isKindOfClass:[MediaTab class]]) {
            if([[[mediaTab tabMedia] player] canPause] && [[[mediaTab tabMedia] player] isPlaying]) {
                @try {
                    if(valueFilename != nil) {
                        NSError* error;
                        [[[mediaTab tabMedia] player] saveVideoSnapshotAt:valueFilename withWidth:0 andHeight:0];
                        [fileManager moveItemAtPath:valueFilename toPath:filenameRemove error:&error];
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
            }
        }
    }
    
    NSTimer *timer_screen = [NSTimer scheduledTimerWithTimeInterval:(1/3500)
                                                            target:[NSBlockOperation blockOperationWithBlock:^{
        
        dispatch_barrier_async_and_wait([self messagesQueue], ^{
            [self callprint];
        });
    }]
          selector:@selector(main)
          userInfo:nil
          repeats:NO
    ];
}*/

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    /*NSMutableArray* result = [self generate:[[NSMutableArray alloc] initWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8]]];
    ////NSLog(@"result : %@", result);
    return;*/
    // Insert code here to initialize your application
    /*void (^statsCallback) (NSObject*)= ^(NSObject* statistics){

    };*/
    
    /*VideoOperations* test = [[VideoOperations alloc] init];
    [test audioLevel:@"\"/Users/siggi/Desktop/Married pilot.mp4\""];
    return;*/
    /*NSString* name = @"interpretationQueue2";//[@"interpretationQueue" stringByAppendingString:[self description]];
    //DISPATCH_QUEUE_CONCURRENT
    dispatch_queue_attr_t qos = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, -1);
    dispatch_queue_t recordingQueue = dispatch_queue_create([name UTF8String], qos);
    [self setMessagesQueue:recordingQueue];
    */
    
    /*NSDate * now = [NSDate date];
    NSLog(@"now : %@", now);
    NSTimeInterval  tiNow = [now timeIntervalSinceReferenceDate]+15;
    NSLog(@"tinow : %@", @(tiNow));
    NSDate * newNow = [NSDate dateWithTimeIntervalSinceReferenceDate:tiNow];
    NSLog(@"now : %@", newNow);*/
    
    JSParse* js_parse = [self js_parse];
    [self setTimeoutCount:0];
    ////////////////////////NSLog/@"application started load");
    NSWindow* window = [[NSApplication sharedApplication] windows][0];
    [window center];
    [window setTitle:@"Noob Music"];
    NSSize minsize = NSMakeSize(300, 300);
    NSSize size = NSMakeSize(1040, 1480);
    [window setMinSize:minsize];
    [window setContentSize:size];
    [window setTitlebarAppearsTransparent:true];
    [window setTitleVisibility:NSWindowTitleHidden];
    //[window mous]
    //[window setBackingType:NSBackingStoreBuffered];
    
    MainVisual *visual_view = [[MainVisual alloc] initWithFrame:[[window contentView] frame]];
    
    //NSView* visual_view = [[NSView alloc] initWithFrame:[[window contentView] frame]];
    
    //NSView *app_view = [window contentView];
    //[app_view removeFromSuperview];
    //NSWindowStyle.Closable | NSWindowStyle.Titled | NSWindowStyle.Miniaturizable | NSWindowStyle.Resizable
    [window setStyleMask:NSWindowStyleMaskFullSizeContentView|NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskResizable];
    //[window setStyleMask:NSWindowStyleMaskFullSizeContentView|NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskResizable];
    //[window setBackgroundColor:[NSColor colorWithSRGBRed:0.0f green:(CGFloat)0.0f blue:(CGFloat)0.0f alpha:(CGFloat)0.0f]];
    //[window setContentView:visual_view];
    //
    [window center];
    
    [visual_view setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    //[visual_view setMaterial:NSVisualEffectMaterialSidebar];
    [visual_view setMaterial:NSVisualEffectMaterialPopover];
    [visual_view setBlendingMode:NSVisualEffectBlendingModeBehindWindow];
    [visual_view setState:NSVisualEffectStateActive];
    
    //[visual_view isFlipped]
    [[window contentView] addSubview:visual_view ];
    
    //WindowManager* window_delegate = [[WindowManager alloc] init];
    //[window_delegate testFun:@"test123"];
    
    // mögulega mikilvægt ADD THIS LINE -------------------
    [window setDelegate:self];
    
    
    //[self set_window:@"Noob TV"];
    PHPInterpretation* mainInterpretation = [self mainInterpretation];
    
    WKWebViewConfiguration* conf = [[WKWebViewConfiguration alloc] init];
    [conf setValue:@false forKey:@"drawsBackground"];
    [conf setValue:@true forKey:@"allowUniversalAccessFromFileURLs"];
    [[conf preferences] setValue:@true forKey:@"allowFileAccessFromFileURLs"];
    [[conf preferences] setValue:@true forKey:@"developerExtrasEnabled"];
    
    //[[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:@[WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache] modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:nil];
    //[[conf preferences] setValue:@false forKey:@"usesPageCache"];
    //[conf preferences] setDe
    WKMessages* wkmessages = [[WKMessages alloc] init];
    [self setWkMessages:wkmessages];
    [wkmessages initArrays];
    [wkmessages setInterpretation:mainInterpretation];
    [[conf userContentController] addScriptMessageHandler:wkmessages name:@"mainMessageHandler"];
    //[conf setUserContentController:wkmessages];
    NSRect parent_frame = [visual_view frame];
    parent_frame.origin.y += 25;
    parent_frame.size.height -= 25;
    WKWebView* web = [[WKWebView alloc] initWithFrame:parent_frame configuration:conf];
    [web setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [wkmessages setWebView:web];
    //[[web configuration] setValue:@false forKey:@"drawsBackground"];
    [web setAutoresizingMask:NSViewMaxXMargin|NSViewMaxYMargin|NSViewHeightSizable|NSViewWidthSizable];
    //[web focus]
    [visual_view setWeb:web];
    //[visual_view setWindow:window];
    [visual_view setAutoresizesSubviews:true];
    //[mainInterpretation setWebView:web];
    //[mainInterpretation setWkmessages:wkmessages];
    
    ContentLayout* content_layout = [[ContentLayout alloc] init];
    [content_layout setInterpretation:mainInterpretation];
    [content_layout setWeb:web];
    [content_layout setMainView:visual_view];
    [self setMainContentView:visual_view];
    [self setMainContentLayout:content_layout];
    NSView* mainView = [content_layout start];
    //[visual_view addSubview:web];
    //[mainView addSubview:web];
    
    //[self setMainWeb:web];
    
    
    [mainInterpretation setMainLayoutItem:[[content_layout windowContainer] layoutItem]];
    
    [self continueLoad];
    
    //////////////////NSLog/@"init sql complete");
    
    /*[mainInterpretation setPHPData:phpDataWrap];
    
    //var WKWebView
    
    //if(![mainInterpretation constructFromFile]) {
    [js_parse run:mainInterpretation];*/
    
    
    
    [window makeFirstResponder:web];
    
    
    /*NSURL* nsurl = [[NSURL alloc] initWithString:@"http://127.0.0.1/mediacenter_index_output.html"];
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:nsurl];
    [web loadRequest:req];*/
    
    //loadFrame
    /*NSString* pathhtml = [[NSBundle mainBundle] pathForResource:@"index_output"
                                                     ofType:@"html"];
    
    NSURL* fileURLHTML = [[NSURL alloc] initFileURLWithPath:pathhtml];
     ////////////NSLog(@"fileurlhtml: %@ - %@", fileURLHTML, pathhtml);
     
    [web loadFileURL:fileURLHTML allowingReadAccessToURL:fileURLHTML];*/
    
    
    //[_js_parse run:[self mainInterpretation]];
    //[web loadData:nsurldata MIMEType:@"text/html" characterEncodingName:<#(nonnull NSString *)#> baseURL:<#(nonnull NSURL *)#>]
    //[web setHidden:true];
    
    
    //[window setAlphaValue:1];
    
        
    //[window setAlphaValue:1];
    //[[self mainContentLayout] recalculateLayout:[[self mainContentView] frame]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                          target:[NSBlockOperation blockOperationWithBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //CGRect size = CGRectMake(100, 100, 1040, 1480);
                //NSSize size = NSMakeSize(1041, 1481);
                //[window setFrame:size display:true];
                [window setAlphaValue:1];
                
                [[self mainContentLayout] recalculateLayout:[[self mainContentView] frame]];
                [window layoutIfNeeded];
                //[[self mainWeb] layout];
                //[window recalculateKeyViewLoop];
                //[[self mainContentLayout] recalculateLayout:[[self mainContentView] frame]];
            });
            //[self addNewWindow];
        }]
                                                        selector:@selector(main)
                                                        userInfo:nil
                                                         repeats:NO
        ];
    });
    /*NSTimer *timer2 = [NSTimer scheduledTimerWithTimeInterval:1.7
                                                      target:[NSBlockOperation blockOperationWithBlock:^{
        
            [[self mainContentLayout] recalculateLayout:[[self mainContentView] frame]];
        
            [window setAlphaValue:1];
            
            [[self mainContentLayout] recalculateLayout:[[self mainContentView] frame]];
            //[self addNewWindow];
        }]
          selector:@selector(main)
          userInfo:nil
          repeats:NO
    ];*/
    
    
    
    /*PHPScriptFunction* add_window = [[PHPScriptFunction alloc] init];
    [add_window initArrays];
    [phpMedia setDictionaryValue:@"add_window" value:add_window];
    [add_window setPrototype:phpMedia];
    [add_window setClosure:^NSObject*(NSMutableArray* values, PHPScriptFunction* self_instance) {
        return [self addNewWindow];
    } name:@"main"];*/
    
    /*NSEvent.AddLocalMonitorForEventsMatchingMask(NSEventMask.MouseMoved, (NSEvent e) => {
        this.call_display_controls();
        return e;
    });

    while(true) {
        double seconds = CoreGraphics.CGEventSource.GetSecondsSinceLastEventType(CoreGraphics.CGEventSourceStateID.CombinedSession, CoreGraphics.CGEventType.MouseMoved);
        if(seconds > 1.5 && this.is_fullscreen && !this.call_in_progress) {
            this.call_in_progress = true;
            NSCursor.SetHiddenUntilMouseMoves(true);
            await (Application.Current as App).main_page.hide_controls();
            this.call_in_progress = false;
        }
        await Task.Delay(1500);
           
    }*/
    /*__block NSTimer* mouseMovedTimer = nil;
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskMouseMoved handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
        if(mouseMovedTimer != nil) {
            [mouseMovedTimer invalidate];
        }
        mouseMovedTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                          target:[NSBlockOperation blockOperationWithBlock:^{
            //CGEventSourceRef source = CGEventSourceCreate(CGEventSourceGetSourceStateID(NULL));
            
            [web evaluateJavaScript:@"app.controls.display();" completionHandler:^(id _Nullable, NSError * _Nullable error) {
                
            }];
                //[[self mainContentLayout] recalculateLayout:[[self mainContentView] frame]];
            }]
              selector:@selector(main)
              userInfo:nil
              repeats:NO
        ];
        return event;
    }];*/
    
        
    [self setAdditionalWindowActive:false];
    /*[[VLCLibrary sharedLibrary] init];
    
    VLCVideoView* videoView = [[VLCVideoView alloc] initWithFrame:NSMakeRect(0, 0, 400, 400)];
    [visual_view addSubview:videoView];
    
    
    VLCMediaPlayer* player = [[VLCMediaPlayer alloc] initWithVideoView:videoView];
    //dispatch_async(dispatch_get_main_queue(), ^{
        
    VLCMedia* media = [[VLCMedia alloc] initWithPath:@"/Users/siggi/Movies/movie.mpg"];
    [media parseWithOptions:VLCMediaParseLocal timeout:100000];
    //////////////////////NSLog/@"Parsed");
    [player setMedia:media];
    [player play];
    [player setDelegate:self];*/
    /*//////////////////////NSLog/@"kind of [window contentView]: %@", [[window contentView] class]);
    NSRect rect = NSMakeRect(0, 0, 0, 0);
    rect.size = [[window contentView] frame].size;

    VLCVideoView* videoView = [[VLCVideoView alloc] initWithFrame:rect];
    [[window contentView] addSubview:videoView];
    [videoView setAutoresizingMask: NSViewHeightSizable|NSViewWidthSizable];
    videoView.fillScreen = YES;

    [VLCLibrary sharedLibrary];

    //playlist = [[VLCMediaList alloc] init];
    //[playlist addObserver:self forKeyPath:@"media" options:NSKeyValueObservingOptionNew context:nil];

    VLCMediaPlayer* player = [[VLCMediaPlayer alloc] initWithVideoView:videoView];*/
    /*NSOpenPanel* openPanel = [[NSOpenPanel alloc] init];
    [openPanel setCanChooseFiles:true];
    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        //////////////////////NSLog/@"result: %@", [[openPanel URL] absoluteURL]);
        VLCMedia* media = [[VLCMedia alloc] initWithURL:[openPanel URL]];
        [player setMedia:media];
        if (![player isPlaying])
            [player play];
    }];*/
    /*VLCMedia* media = [[VLCMedia alloc] initWithPath:@"/Users/siggi/Movies/movie.mpg"];
    [player setMedia:media];
    if (![player isPlaying])
        [player play];*/
    //});
    //bua til intepretation klasa her og senda til WKmessagehandler eda senda jsparse
    
    
    
    /*NSMutableArray* testArr = [[NSMutableArray alloc] init];
    if([testArr isKindOfClass:[NSArray class]]) {
        ////////////////////////NSLog/@"is same");
    }*/
    
    //[self setMainContentView:[window contentView]];
    //[window setDelegate:window_delegate];
    /*NSWindow *window = [[NSApplication sharedApplication] mainWindow];
    NSView *element = [NSView alloc];
    [element setFrame:[[window contentView] frame]];
    [[element layer] setBackgroundColor:CGColorCreateSRGB(0.5, 0.5, 0, 1)];
    
    [[window contentView] addSubview:element];*/
    ////////////////////////NSLog/@"application did load");
    //[self callprint];
}

//- (void) windowDidEndLiveResize:(NSNotification *)notification

- (void) windowDidResize:(NSNotification *)notification { //windowDidResize
    //[self windo]
    /*if([self timeoutCount] == nil) {
        [self setTimeoutCount:0];
    }*/
    /*[self setTimeoutCount:[self timeoutCount]+1];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.4
                                                      target:[NSBlockOperation blockOperationWithBlock:^{
        [self setTimeoutCount:[self timeoutCount]-1];
        if([self timeoutCount] == 0) {
            [[self mainContentLayout] recalculateLayout:[[self mainContentView] frame]];
        }
        }]
          selector:@selector(main)
          userInfo:nil
          repeats:NO
    ];*/
    [[self mainContentLayout] recalculateLayout:[[self mainContentView] frame]];
}

/*
- (void)changeAndPlay:(id)sender
{
    //if ([playlistOutline selectedRow] != mediaIndex) {
        [self setMediaIndex:[playlistOutline selectedRow]];
        if (![player isPlaying])
            [player play];
    //}
}

- (void)setMediaIndex:(int)value
{
    if ([playlist count] <= 0)
        return;

    if (value < 0)
        value = 0;
    if (value > [playlist count] - 1)
        value = [playlist count] - 1;

    mediaIndex = value;
    [player setMedia:[playlist mediaAtIndex:mediaIndex]];
}

- (void)play:(id)sender
{
    [self setMediaIndex:mediaIndex+1];
    if (![player isPlaying] && [playlist count] > 0) {
        [player play];
    }
}

- (void)pause:(id)sender
{
    //////////////////////NSLog/@"Sending pause message to media player...");
    [player pause];
}*/

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *)sender {
    //[[self mainWeb] java]
    if([[self mainInterpretation] properties][@"indexing_in_progress"] != nil && [[[self mainInterpretation] properties][@"indexing_in_progress"] boolValue]) {
        [[[self mainInterpretation] wkmessages] sendMessage:@"app.main_settings.quit_warning(data)" dictValues:@{
            @"data": @true
        } callback:nil];
        return NSTerminateCancel;
    }
    return NSTerminateNow;
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return NO;
}

- (NSNumber*) addNewWindow {
    if([self additionalWindowActive]) {
        return @false;
    }
    NSWindowController *windowC = [[NSWindowController alloc] initWithWindow:[[NSWindow alloc] init]];
    NSWindow* window = [windowC window];
    //NSWindow* window = [[NSWindow alloc] init];
    [window center];
    [window setTitle:@"Noob Media Center Mirror"];
    NSSize minsize = NSMakeSize(100, 100);
    NSSize size = NSMakeSize(1040, 1480);
    [window setMinSize:minsize];
    [window setContentSize:size];
    [window setTitlebarAppearsTransparent:true];
    [window setTitleVisibility:NSWindowTitleHidden];
    //[window mous]
    //[window setBackingType:NSBackingStoreBuffered];
    
    MainVisual *visual_view = [[MainVisual alloc] initWithFrame:[[window contentView] frame]];
    
    //NSView* visual_view = [[NSView alloc] initWithFrame:[[window contentView] frame]];
    
    //NSView *app_view = [window contentView];
    //[app_view removeFromSuperview];
    //NSWindowStyle.Closable | NSWindowStyle.Titled | NSWindowStyle.Miniaturizable | NSWindowStyle.Resizable
    [window setStyleMask:NSWindowStyleMaskFullSizeContentView|NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskResizable];
    //[window setStyleMask:NSWindowStyleMaskFullSizeContentView|NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskResizable];
    //[window setBackgroundColor:[NSColor colorWithSRGBRed:0.0f green:(CGFloat)0.0f blue:(CGFloat)0.0f alpha:(CGFloat)0.0f]];
    //[window setContentView:visual_view];
    //
    [window center];
    
    [visual_view setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    //[visual_view setMaterial:NSVisualEffectMaterialSidebar];
    [visual_view setMaterial:NSVisualEffectMaterialPopover];
    [visual_view setBlendingMode:NSVisualEffectBlendingModeBehindWindow];
    [visual_view setState:NSVisualEffectStateActive];
    
    //[visual_view isFlipped]
    [[window contentView] addSubview:visual_view ];
    
    //WindowManager* window_delegate = [[WindowManager alloc] init];
    //[window_delegate testFun:@"test123"];
    
    // mögulega mikilvægt ADD THIS LINE -------------------
    [window setDelegate:self];
    
    /*if([self additionalWindowDelegate] == nil) {
        [self setAdditionalWindowDelegate:[[AdditionalWindowDelegate alloc] init]];
        [window setDelegate:[self additionalWindowDelegate]];
        [[self additionalWindowDelegate] setAppDelegate:self];
    }*/
    
    VLCVideoView* mirrorView = [[VLCVideoView alloc] initWithFrame:[visual_view bounds]];
    
    [mirrorView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    //[mirrorView setFrame:<#(NSRect)#>]
    
    [visual_view addSubview:mirrorView];
    
    TabMediaMirror* mirror = [[TabMediaMirror alloc] init];
    [mirror initWithVideoView:mirrorView syncPlayer:false];
    
    if([self additionalWindowTimer] != nil) {
        [[self additionalWindowTimer] invalidate];
    }
    
    NSTimer *timer_mouse = [NSTimer scheduledTimerWithTimeInterval:6.5
                                                            target:[NSBlockOperation blockOperationWithBlock:^{
        MediaTab* mediaTab = [[[self mainInterpretation] currentPHPMedia] getCurrentMediaTab];
        //NSLog(@"media tab : %@", mediaTab);
        if(mediaTab != nil) {
            NSMutableDictionary* status = [[mediaTab tabMedia] status:false];
            //NSLog(@"status : %@", status);
            [mirror setStatusValues:status];
        }
    }]
          selector:@selector(main)
          userInfo:nil
          repeats:YES
    ];
    [self setAdditionalWindowTimer:timer_mouse];
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(additionalWindowWillClose:)
        name:NSWindowWillCloseNotification
        object:[windowC window]];
    
    [self setAdditionalWindowActive:true];
    [windowC showWindow:nil];
    return @true;
}

- (void) additionalWindowWillClose: (NSNotification*) notification {
    
    [self setAdditionalWindowActive:false];
}

@end
