//
//  TabMedia.m
//  noobtest
//
//  Created by siggi jokull on 25.2.2023.
//

#import "TabMedia.h"
#import "MediaTab.h"
#import "PHPScriptObject.h"
#import "PHPInterpretation.h"
/*#import <WebKit/WebKit.h>*/


@implementation TabMedia

- (NSNumber*) getDuration {
    @synchronized ([self player]) {
        @synchronized ([[self player] media]) {
            
            if([[self player] media] != nil) {
                VLCTime* time = [[[self player] media] length];
                return [time value];
            }
        }
    }
    return @-1;
}

- (void) dealloc {
    NSLog(@"dealloced tab media");
}

- (void) initWithVideoView: (VLCVideoView*) videoView  syncPlayer: (bool) syncPlayer {
    [self setCallbacks:[[NSMutableArray alloc] init]];
    [self setVideoView:videoView];
    //[[self videoView] option]
    if([self subtitlesDisabled]) { //@"--audio-desync=200",
        [self setPlayer:[[VLCMediaPlayer alloc] initWithOptions:@[@"--no-sub-autodetect-file", @"--sub-track=100", @"--freetype-opacity=0"]]];
        [[self player] setVideoView:[self videoView]];
    } else {
        [self setPlayer:[[VLCMediaPlayer alloc] initWithVideoView:[self videoView]]];
    }
    
    //[[self player] setScriptingProperties:<#(NSDictionary<NSString *,id> * _Nullable)#>]
    //[self player] setScriptingProperties:<#(NSDictionary<NSString *,id> * _Nullable)#>
    //[[self player] setCurrentVideoSubTitleIndex:100];
    [[self player] setDelegate:self];
    //[[self player] setVideoAspectRatio:"16:9"];
    //[[self player] setVideoAspectRatio:"16:9"];
    [self setWasPaused:false];
    //[[self player] setScriptingProperties:<#(NSDictionary<NSString *,id> * _Nullable)#>]
    //[[self player] set]
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerTimeChanged:) name:VLCMediaPlayerTimeChanged object:nil];
    /*VLCMedia* media = [[VLCMedia alloc] initWithPath:@"/Users/siggi/Movies/NewsRadio.S2Exx.Season.2.Outtakes.avi"];
    [[self player] setMedia:media];
    [[self player] play];*/
    [self setVolumeValue:70]; // 70
    [[[self player] audio] setVolume:[self volumeValue]];
    
    /*if(syncPlayer) {
        NSTimer *timer_mouse = [NSTimer scheduledTimerWithTimeInterval:10.5
                                                                target:[NSBlockOperation blockOperationWithBlock:^{*/
            /*Dictionary<string, string> status = new Dictionary<string, string>() {
             {
             "video_path",
             await this.current_tab_object.get_current_media()
             },
             {
             "current_position",
             //this.get_position_value().ToString()
             this.web.MediaPlayer.Position.ToString()
             },
             {
             "current_time",
             DateTimeOffset.Now.ToUnixTimeMilliseconds().ToString()
             },
             {
             "is_playing",
             this.web.MediaPlayer.IsPlaying.ToString()
             }
             };*/
            /*if([[self player] media] != nil) {
                NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970]*100;
                //float floatVal = [@([[self player] position]) floatValue];
                //NSString* fromFloat = [[NSString alloc] initWithFormat:@"%f", floatVal];
                NSDictionary* status = @{
                    @"video_path": @([[[[self player] media] url] fileSystemRepresentation]),
                    @"current_position": @([[self player] position]),
                    @"current_time": @([@(timeInSeconds) longLongValue]),
                    @"is_playing": @([[self player] isPlaying])
                };
                NSString *string = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:status options:NSJSONWritingWithoutEscapingSlashes error:nil] encoding:NSUTF8StringEncoding];
                ////////////NSLog(@"string: %@", string);
                @try {
                    
                    NSURL* containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.noob.player"];
                    NSString* containerPath = @([containerURL fileSystemRepresentation]);
                    containerPath = [containerPath stringByAppendingString:@"/sync_player.txt"];
                    ////////////NSLog(@"containerPath: %@", containerPath);
                    NSError* error;*/
                    //if([[NSFileManager defaultManager] isWritableFileAtPath:containerPath]) {
                        /*NSDistributedLock* lock = [[NSDistributedLock alloc] initWithPath:containerPath];
                        if([lock tryLock]) {
                            //atomically to yes?
                            
                            [string writeToFile:containerPath atomically:YES encoding:NSMacOSRomanStringEncoding error:&error];
                            [lock unlock];
                        }*/
                    //[string writeToFile:containerPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
                    /*NSURL totalURL = [[NSURL alloc] initFileURLWithPath:containerPath];
                    NSOutputStream* outputStream = [[NSOutputStream alloc] initWithURL:totalURL append:false];
                    [outputStream ]*/
                    //}
                    //[string writeToFile:containerPath atomically:YES error:&error];
                    /*////////////NSLog(@"error: %@", [error description]);
                } @catch(NSException* exc) {
                    ////////////NSLog(@"exception: %@", exc);
                }
            }*/
            //assign_sync
            /*NSURL* containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.noob.player"];
            containerURL = [containerURL URLByAppendingPathComponent:@"sync_player.txt"];
            ////////////NSLog(@"container Url: %@", [containerURL absoluteString]);
            NSError* error;
            if([[NSFileManager defaultManager] fileExistsAtPath:@([containerURL fileSystemRepresentation])]) {
                //NSDistributedLock* lock = [[NSDistributedLock alloc] initWithPath:@([containerURL fileSystemRepresentation])];
                NSString* read = [NSString stringWithContentsOfURL:containerURL encoding:NSUTF8StringEncoding error:&error];
                NSData* dataPost = [read dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* resultsPost = (NSDictionary*)[NSJSONSerialization
                                                        JSONObjectWithData:dataPost
                                                        options:0
                                                        error:&error];
                ////////////NSLog(@"results - %@", resultsPost);
                
            }*/
        /*}]
                                                              selector:@selector(main)
                                                              userInfo:nil
                                                               repeats:YES
        ];
    }*/
}

- (NSMutableDictionary*) status: (bool) resetSync {
    @synchronized ([self player]) {
        @synchronized ([[self player] time]) {
            
            VLCTime* timeValue = [[self player] time];
            @synchronized (timeValue) {
                NSNumber* timeValueValue = [timeValue value];
                @synchronized (timeValueValue) {
                    
                    //NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
                    NSDate* now = [NSDate date];//NSDate.now;
                    //NSDateComponents now_comps = [[NSDateComponents alloc] init];
                    /*NSDateComponents* now_comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:now];
                     //[now_comps setD])
                     NSDateComponents *comps = [[NSDateComponents alloc] init];
                     [comps setDay:[now_comps day]];
                     [comps setMonth:[now_comps month]];
                     [comps setYear:[now_comps year]];
                     NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];*/
                    //NSDate* last_hour = [[NSDate.now set]]
                    
                    NSDate *date = [NSDate date];//NSDate.now;
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
                    NSInteger hour = [components hour];
                    NSInteger minute = [components minute];
                    [components setSecond:0];
                    [components setMinute:0];
                    NSDate* lastHour = [[NSCalendar currentCalendar] dateFromComponents:components];
                    ////////////NSLog(@"date string - %@", lastHour);
                    ///
                    double longTime = [NSDate.now timeIntervalSinceReferenceDate]+5;
                    //resetSync ||
                    if([[self player] isPlaying] && [[self player] media] != nil && timeValue != VLCTime.nullTime) {
                        NSDictionary* status = @{
                            @"video_path": @([[[[self player] media] url] fileSystemRepresentation]),
                            @"current_position_text": [timeValueValue stringValue],
                            @"current_time_text": [@(longTime) stringValue],
                            @"is_playing": @([@([[self player] isPlaying]) boolValue])
                        };
                        
                        if(resetSync) {
                            //[[self player] pause];
                            NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:longTime];//[NSDate.now dateByAddingTimeInterval:15];
                            
                            NSLog(@"reset sync : %@", newDate);
                            
                            /*NSTimer *timer_mouse = [[NSTimer alloc] initWithFireDate:newDate //interval:nil //scheduledTimerWithTimeInterval:6.5
                             target:[NSBlockOperation blockOperationWithBlock:^{
                             }]
                             selector:@selector(main)
                             userInfo:nil
                             repeats:NO
                             ];*/
                            
                            /*NSTimer* timer = [[NSTimer alloc] initWithFireDate:newDate interval:0 target:[NSBlockOperation blockOperationWithBlock:^{
                             
                             double set_pos = [status[@"current_position_text"] doubleValue];
                             VLCTime* set_time = [[VLCTime alloc] initWithNumber:@(set_pos)];
                             [[self player] setTime:set_time];
                             [[self player] play];
                             }] selector:@selector(main) userInfo:nil repeats:YES];*/
                            NSTimer* timer = [[NSTimer alloc] initWithFireDate:newDate interval:0 repeats:NO block:^(NSTimer*timer){
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NSLog(@"call reset sync : %@", newDate);
                                    
                                    double set_pos = [status[@"current_position_text"] doubleValue];
                                    @synchronized ([self player]) {
                                        
                                        VLCTime* set_time = [[VLCTime alloc] initWithNumber:@(set_pos)];
                                        [[self player] setTime:set_time];
                                        [[self player] play];
                                    }
                                });
                            }];
                            [[NSRunLoop mainRunLoop] addTimer: timer forMode: NSDefaultRunLoopMode];
                        }
                        
                        //[self player] position
                        ////////////NSLog(@"status  - %@", status);
                        return [[NSMutableDictionary alloc] initWithDictionary:status];
                    }
                    return [[NSMutableDictionary alloc] initWithDictionary:@{
                        @"is_playing": @(false)
                    }];
                }
            }
        }
    }
}

- (void) setStatusValues: (NSMutableDictionary*) values {
    @synchronized ([self player]) {
        
    if([self currentOpenPanel] != nil) { // && [[self currentOpenPanel] isVisible]
        return;
    }
    if(![values[@"is_playing"] boolValue] && [[self player] canPause]) {
        [[self player] pause];
        return;
    }
    double constValue = 0;
    if(![[self player] isPlaying] || ![@([[[[self player] media] url] fileSystemRepresentation]) isEqualToString:values[@"video_path"]]) {
        [self playMedia:values[@"video_path"] subRoutine:^NSObject *(int i) {
            /*NSDate *date = [NSDate date];//NSDate.now;
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
            NSInteger hour = [components hour];
            NSInteger minute = [components minute];
            [components setSecond:0];
            [components setMinute:0];
            NSDate* lastHour = [[NSCalendar currentCalendar] dateFromComponents:components];
            ////////////NSLog(@"date string - %@", lastHour);
            [lastHour dateByAddingTimeInterval:[values[@"current_time_text"] doubleValue]];*/
            NSDate* lastHour = [NSDate dateWithTimeIntervalSinceReferenceDate:[values[@"current_time_text"] doubleValue]];
            //NSDate* lastHour = [[NSDate alloc] initWithTimeIntervalSince1970:[values[@"current_time_text"] doubleValue]];
            
            /*NSTimeInterval timeInSeconds = [lastHour timeIntervalSinceNow]*1000;
            double time_subtraction = (-timeInSeconds)-(-[values[@"current_time_text"] doubleValue]*1000);
            //double position = [[self player] position];
            double set_pos = [values[@"current_position_text"] doubleValue] + time_subtraction + constValue;
            
            //if(fabs(position - set_pos) > 0.0001) {
                VLCTime* set_time = [[VLCTime alloc] initWithNumber:@(set_pos)];
                [[self player] setTime:set_time];
            //}*/
            //NSDate* newDate = [[NSDate alloc] dateByAddingTimeInterval:<#(NSTimeInterval)#>]
            
            /*NSTimer* timer = [[NSTimer alloc] initWithFireDate:lastHour interval:0 target:[NSBlockOperation blockOperationWithBlock:^{
                    
                double set_pos = [values[@"current_position_text"] doubleValue];
                VLCTime* set_time = [[VLCTime alloc] initWithNumber:@(set_pos)];
                [[self player] setTime:set_time];
                [[self player] play];
            }] selector:@selector(main) userInfo:nil repeats:YES];*/
            NSLog(@"befor fire : %@", lastHour);
            NSTimer* timer = [[NSTimer alloc] initWithFireDate:lastHour interval:0 repeats:NO block:^(NSTimer*timer) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"in fire : %@", lastHour);
                    double set_pos = [values[@"current_position_text"] doubleValue];
                    VLCTime* set_time = [[VLCTime alloc] initWithNumber:@(set_pos)];
                    [[self player] setTime:set_time];
                    [[self player] play];
                });
            }];
            [[NSRunLoop mainRunLoop] addTimer: timer forMode: NSDefaultRunLoopMode];
            
            ////////////NSLog(@"%@", values);
            ////////////NSLog(@"time in ms: %f time subtraction: %f set_pos: %f", timeInSeconds, time_subtraction, set_pos);
            if([values[@"is_playing"] boolValue] && ![[self player] isPlaying]) {
                [[self player] play];
            } else if(![values[@"is_playing"] boolValue] && [[self player] isPlaying]) {
                [[self player] pause];
            }
            return nil;
        }];
    } else {
        /*NSDate *date = [NSDate date];//NSDate.now;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        [components setSecond:0];
        [components setMinute:0];
        NSDate* lastHour = [[NSCalendar currentCalendar] dateFromComponents:components];
        ////////////NSLog(@"date string - %@", lastHour);
        [lastHour dateByAddingTimeInterval:[values[@"current_time_text"] doubleValue]];
        */
        
        NSDate* lastHour = [NSDate dateWithTimeIntervalSinceReferenceDate:[values[@"current_time_text"] doubleValue]];
        //NSDate* lastHour = [[NSDate alloc] initWithTimeIntervalSince1970:[values[@"current_time_text"] doubleValue]];
        /*NSTimeInterval timeInSeconds = [lastHour timeIntervalSinceNow]*1000;
        double time_subtraction = (-timeInSeconds)-(-[values[@"current_time_text"] doubleValue]*1000);
        double position = [[[self player] time].value doubleValue];
        double set_pos = [values[@"current_position_text"] doubleValue] + time_subtraction + constValue;
        
        if(fabs(position - set_pos) > 50) {
            VLCTime* set_time = [[VLCTime alloc] initWithNumber:@(set_pos)];
            [[self player] setTime:set_time];
        }*/
        
        NSLog(@"before fire : %@", lastHour);
        NSTimer* timer = [[NSTimer alloc] initWithFireDate:lastHour interval:0 repeats:NO block:^(NSTimer*timer){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"in fire : %@", lastHour);
                double set_pos = [values[@"current_position_text"] doubleValue];
                VLCTime* set_time = [[VLCTime alloc] initWithNumber:@(set_pos)];
                [[self player] setTime:set_time];
                [[self player] play];
            });
        }];
        [[NSRunLoop mainRunLoop] addTimer: timer forMode: NSDefaultRunLoopMode];
        ////////////NSLog(@"%@", values);
        ////////////NSLog(@"time in ms: %f time subtraction: %f set_pos: %f", timeInSeconds, time_subtraction, set_pos);
        if([values[@"is_playing"] boolValue] && ![[self player] isPlaying]) {
            [[self player] play];
        } else if(![values[@"is_playing"] boolValue] && [[self player] isPlaying]) {
            [[self player] pause];
        }
        //[timer fire];
    }
    }
}

- (void) takeScreenshot {
    [[self player] saveVideoSnapshotAt:@"filepath" withWidth:300 andHeight:300];
}

- (int) isPlaying {
    @synchronized ([self player]) {
        
    if([[self player] isPlaying]) {
        return 1;
    }
    }
    return 0;
}

- (void) toggleAudio {
    /*if([self volumeValue] == 0) {
        [self setVolumeValue:70];
    } else {
        [self setVolumeValue:0];
    }
    [[[self player] audio] setVolume:[self volumeValue]];*/
    @synchronized ([self player]) {
        if([[[self player] audio] volume] == 0) {
            [[[self player] audio] setVolume:[self volumeValue]];
        } else {
            [[[self player] audio] setVolume:0];
        }
    }
}

- (void) setAudioVolume: (int) audioVolume {
    @synchronized ([self player]) {
        [self setVolumeValue:audioVolume];
        [[[self player] audio] setVolume:[self volumeValue]];
    }
}

- (void) setAsFront {
    @synchronized ([self player]) {
        [[[self player] audio] setVolume:[self volumeValue]];
    }
}

- (void) setAsBack {
    @synchronized ([self player]) {
        [[[self player] audio] setVolume:0];
    }
}

- (void) mediaPlayerStateChanged: (NSNotification*) aNotification {
    //[[self player] position]
    /*float current_time = [[self player].time.value floatValue];
    float duration = [[self player].media.length.value floatValue];
    if([[self player] state] == 6 && ([[self player] position] >= 0.999 || duration-current_time <= 2000)) {
        NSObject* callback = [self callbacks][2];
        PHPScriptFunction* function = (PHPScriptFunction*)callback;
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        [function callScriptFunctionSub:arr parameterValues:nil awaited:nil returnObject:nil];
        
    }*/
    
    @synchronized ([self player]) {
        /*VLCTime* timeValue = [[self player] time];
        @synchronized (timeValue) {
            NSNumber* timeValueValue = [timeValue value];
            @synchronized (timeValueValue) {*/
                
                //float current_time = [timeValueValue floatValue];
                //float duration = [[[[[self player] media] length] value] floatValue];
                //float remainingTime = -[[[self player] remainingTime].value floatValue];
                //NSLog(@"is END? %@", @([[self player] state]));
                /*if([[self player] state] == VLCMediaPlayerStatePlaying && [self getDuration] != nil) {
                    PHPScriptFunction* callbackPlaying = (PHPScriptFunction*)[self callbacks][3];
                    [callbackPlaying callCallback:@[[self getDuration]]];
                }*/
                if([[self player] state] == 6) { //[self canPlayNew]
                    bool isEnd = false;
                    //NSLog(@"current_time: ISEND %f %f %f %f %f", current_time, duration, remainingTime, (duration-current_time), [[self player] position]);
                    if(![self wasPaused]) {
                        // && ([[self player] position] >= 0.999 || duration-current_time <= 2000 || remainingTime <= 2000)
                        ////////////NSLog(@"isEND set");
                        isEnd = true;
                    } else {
                        [self setWasPaused:false];
                    }/* else if(current_time < duration) {
                      //////////NSLog(@"inside skiptest");
                      int setInt = [[self player] time].intValue+1000;
                      VLCTime* nextTime = [[VLCTime alloc] initWithInt:setInt];
                      //////////NSLog(@"nextTime: %@ - %d", nextTime, setInt);
                      [[self player] setTime:nextTime];
                      [[self player] remainingTime];
                      //////////NSLog(@"nextTime: %@ - %d", [[self player] time], [[self player] time].intValue);
                      [[self player] pause];
                      if([[self player] time].intValue < setInt) {
                      //////////NSLog(@"inside skiptest valid");
                      isEnd = true;
                      }
                      }*/
                    if(isEnd) {
                        //NSLog(@"is END");
                        /*for(PHPScriptFunction* func in [self callbacks]) {
                         NSLog(@"func : %@", [func debugText]);
                         }*/
                        NSObject* callback = [self callbacks][2]; //2
                        PHPScriptFunction* function = (PHPScriptFunction*)callback;
                        //NSLog(@"function : %@", [function debugText]);
                        NSMutableArray* arr = [[NSMutableArray alloc] init];
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            [function callScriptFunctionSub:arr parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:nil];
                        });
                    }
                }
            /*}
        }*/
    }
}

/*- (void)mediaPlayerTimeChanged: (NSNotification*) aNotification {
    VLCMediaPlayer *player = [aNotification object];
    @synchronized (player) {
        VLCTime *currentTime = player.time;
    }
    
    
}*/


- (void) pausePlayback {
    @synchronized ([self player]) {
        
    if([[self player] canPause]) {
        if([[self player] isPlaying]) {
            [self setWasPaused:true];
            [[self player] pause];
            /*NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                              target:[NSBlockOperation blockOperationWithBlock:^{
                
                [self setWasPaused:false];
                }]
                  selector:@selector(main)
                  userInfo:nil
                  repeats:NO
            ];*/
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                                  target:self
                                                                selector:@selector(unsetWasPaused)
                                                                userInfo:nil
                                                                 repeats:NO
                ];
            });
        } else {
            [[self player] play];
        }
    }
    }
}

- (void) unsetWasPaused {
    [self setWasPaused:false];
}

- (void) closeTab {
    //dispatch_sync(dispatch_get_main_queue(), ^{
    @synchronized ([self player]) {
        
        if([[self player] canPause]) {
            if([[self player] isPlaying]) {
                [[self player] pause];
            }
        }
        [[self player] setMedia:nil];
    }
    //});
    //[[self player] release];
    
}

- (void) test {
    /*[[self videoView] sortSubviewsUsingFunction:(NSComparisonResult(*)(NSView*, NSView*, void*))(^(NSView* view1, NSView* view2, void* context) {
        
    }) context:nil];*/
}

- (void) playMedia: (NSString*) path subRoutine:(NSObject*(^)(int))subRoutine {
    ////////NSLog(@"playmedia %@", path);
    bool is_dir = false;
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&is_dir]) {
        return;
    }
    if(is_dir) {
        return;
    }
    if(![[NSFileManager defaultManager] isReadableFileAtPath:path]) {
        //[[NSFileManager defaultManager]
        NSError* error = nil;
        //////////////////NSLog/@"not readable");
        ///
        dispatch_async(dispatch_get_main_queue(), ^{
            NSOpenPanel* openPanel = [[NSOpenPanel alloc] init];
            [self setCurrentOpenPanel:openPanel];
            //[openPanel setCanChooseFiles:true];
            NSURL* directoryUrl = [[NSURL alloc] initFileURLWithPath:path];
            directoryUrl = [directoryUrl URLByDeletingLastPathComponent];
            //if([directoryUrl ])
            BOOL isDir = NO;
            if([[NSFileManager defaultManager]
                fileExistsAtPath:[directoryUrl path] isDirectory:&isDir] && isDir){
                [openPanel setDirectoryURL:directoryUrl];
            }
            [openPanel setCanChooseDirectories:true];
            [openPanel setAllowsMultipleSelection:false];
            [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
                NSURL* url = [openPanel URL];
                /*NSData* data = [url bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
                 [[NSUserDefaults standardUserDefaults] setURL:url forKey:@"bookmark"];*/
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self playMedia:path subRoutine:subRoutine];
                });
            }];
        });
        /*NSURL* url = [[NSURL alloc] initFileURLWithPath:path];
        
        @try {
            //let url = try (NSURL(resolvingBookmarkData: data, options: [.withoutUI, .withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale) as URL)
            [url startAccessingSecurityScopedResource];
        } @catch (NSException *exception) {
            
        }*/
    } else {
        [self setCurrentOpenPanel:nil];
        //[[self player] pause];
        /*if([self lastMedia] != nil) {
            [[self lastMedia] release];
            [self setLastMedia:nil];
        }*/
        dispatch_async(dispatch_get_main_queue(), ^{
            VLCMedia* media = [[VLCMedia alloc] initWithPath:path];
            //[self setLastMedia:media];
            
            //[media addOption:@"--no-sub-autodetect-file"];
            //[media addOption:@"--sub-track=100"];
            //[media addOption:@"--freetype-opacity=0"];
            //[media addOption:@"--sub-track=nosub"];
            //--key-subtitle-toggle s
            //[[self player] setCurrentVideoSubTitleIndex:-1];
            @synchronized ([self player]) {
                
            [[self player] setMedia:media];
            [[self player] play];
            //[[self player] setCurrentVideoSubTitleIndex:100];
            //[media dealloc];
            if(subRoutine != nil) {
                subRoutine(0);
            }
            }
        });
        //[[self player] setCurrentVideoSubTitleIndex:100];
    }
    //}
    //});
}

/*- (void) dealloc {
    [[self player] setMedia:nil];
    //[[self lastMedia] release];
    [[self player] release];
    [[self videoView] release];
    [super dealloc];
}*/

@end

/*[self setVideoView:(VLCVideoView*)[[self layoutBox] mainView]];
 [contentLayout addVideoViewLayout:[self layoutBox]];
 //[[self videoView] setAutoresizingMask: NSViewHeightSizable|NSViewWidthSizable];
 
 [self setPlaylist:[[VLCMediaList alloc] init]];
 //[[self playlist] addMedia:media];
 //id lib = [VLCLibrary sharedLibrary];
 [self setPlayer:[[VLCMediaPlayer alloc] initWithVideoView:[self videoView]]];
 //[[self player] setDelegate:self];
 dispatch_async(dispatch_get_main_queue(), ^{
     VLCMedia* media = [[VLCMedia alloc] initWithPath:@"/Users/siggi/Movies/NewsRadio.S2Exx.Season.2.Outtakes.avi"];
     [[self player] setMedia:media];
     [[self player] play];
 });*/
