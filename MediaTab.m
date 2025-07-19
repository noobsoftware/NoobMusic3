//
//  PHPIncludedObjects.m
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import "MediaTab.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import "LayoutBox.h"
#import "ContentLayout.h"
#import "TabMedia.h"
#import "PHPMedia.h"

@implementation MediaTab


- (void) dealloc {
    NSLog(@"dealloced tab mediatab");
}

- (void) init: (PHPScriptFunction*) context contentLayout: (ContentLayout*) contentLayout {
    [self initArrays];
    if([contentLayout isKindOfClass:[LayoutBox class]]) {
        [self setLayoutBox:contentLayout];
    } else {
        [self setLayoutBox:[[LayoutBox alloc] init]];
        [[self layoutBox] setIsVideoView:true];
        [contentLayout addVideoViewLayout:[self layoutBox]];
    }
    
    [self setTabMedia:[[TabMedia alloc] init]];
    [self setInterpretation:[context interpretation]];
    bool syncPlayer = false;
    /*if([[[[self layoutBox] parent] children] count] == 1) {
        syncPlayer = true;
    }*/
    [[self tabMedia] setSubtitlesDisabled:true];
    if([[self interpretation] properties][@"disableSubtitles"] != nil && [[[self interpretation] properties][@"disableSubtitles"] boolValue]) {
        [[self tabMedia] setSubtitlesDisabled:true];
    } else {
        [[self tabMedia] setSubtitlesDisabled:false];
    
    }
    [[self tabMedia] initWithVideoView:(VLCVideoView*)[[self layoutBox] mainView] syncPlayer:syncPlayer];
    //[[self tabMedia] setMediaTab:self];
    ClickVideoView* clickVideoView = (ClickVideoView*)[[self layoutBox] mainView];
    [clickVideoView initArrays];
    [clickVideoView setPhpMedia:[self phpMedia]];
    [clickVideoView setMediaTab:self];
    
    [self setParentContext:context];
    
    PHPScriptFunction* set_click_callback = [[PHPScriptFunction alloc] init];
    [set_click_callback initArrays];
    [self setDictionaryValue:@"register_callback" value:set_click_callback];
    [set_click_callback setPrototype:self];
    [set_click_callback setClosure:^NSObject*(NSMutableArray* values, PHPScriptFunction* self_instance) {
        //////////////////NSLog/@"set click callback input %@", values);
        NSObject* input = values[0][0];
        //////////////////NSLog/@"set click callback input %@", input);
        PHPScriptFunction* callback = (PHPScriptFunction*)input;
        //[clickVideoView setCallbacks:@[callback]];
        [[clickVideoView callbacks] addObject:callback];
        @synchronized ([self tabMedia]) {
            
            [[[self tabMedia] callbacks] addObject:callback];
        }
        
        /*NSLog(@"callback is %@", [callback debugText]);
        
        NSLog(@"callbacks : %@ - %@  added: %@", [clickVideoView callbacks], [[self tabMedia] callbacks], callback);*/
        
        //[callback callScriptFunctionSub:NULL parameterValues:nil awaited:nil returnObject:nil];
        /*input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        input = [self_instance resolveValueReferenceVariableArray:input];*/
        //[[self tabMedia] pausePlayback];
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* status = [[PHPScriptFunction alloc] init];
    [status initArrays];
    [self setDictionaryValue:@"status" value:status];
    [status setPrototype:self];
    [status setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        @synchronized ([self tabMedia]) {
            /*NSObject* input = values[0][0];
             input = [self_instance resolveValueReferenceVariableArray:input];
             while([input isKindOfClass:[NSMutableArray class]]) {
             input = ((NSMutableArray*)input)[0];
             }
             input = [self_instance resolveValueReferenceVariableArray:input];*/
            bool resetSync = false;
            if([values[0] count] > 0 && [values[0][0] boolValue]) {
                resetSync = true;
            }
            NSMutableDictionary* firstResults = [[self tabMedia] status:resetSync];
            //////////////NSLog(@"firstResults %@", firstResults);
            NSObject* obj_results = [[self interpretation] makeIntoObjects:firstResults];
            //////////////NSLog(@"phpscriptobject - %@ - %@", obj_results, [obj_results class]);
            //////////////NSLog(@"to json test: - %@", [[self interpretation] toJSON:obj_results]);
            return obj_results;
        }
    } name:@"main"];
    
    
    PHPScriptFunction* status_value = [[PHPScriptFunction alloc] init];
    [status_value initArrays];
    [self setDictionaryValue:@"status_value" value:status_value];
    [status_value setPrototype:self];
    [status_value setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        @synchronized ([self tabMedia]) {
            NSObject* input = values[0][0];
            input = [self_instance resolveValueReferenceVariableArray:input];
            while([input isKindOfClass:[NSMutableArray class]]) {
                input = ((NSMutableArray*)input)[0];
            }
            input = [self_instance resolveValueReferenceVariableArray:input];
            if([input isKindOfClass:[PHPScriptObject class]]) {
                NSMutableDictionary* toDict = (NSMutableDictionary*)[[self interpretation] toJSON:input];
                [[self tabMedia] setStatusValues:toDict];
            }
        }
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* pause = [[PHPScriptFunction alloc] init];
    [pause initArrays];
    [self setDictionaryValue:@"pause" value:pause];
    [pause setPrototype:self];
    [pause setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        /*NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        input = [self_instance resolveValueReferenceVariableArray:input];*/
        @synchronized ([self tabMedia]) {
            [[self tabMedia] pausePlayback];
        }
        return nil;
    } name:@"main"];
    
    
    PHPScriptFunction* play = [[PHPScriptFunction alloc] init];
    [play initArrays];
    [self setDictionaryValue:@"play" value:play];
    [play setPrototype:self];
    [play setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        input = [self_instance resolveValueReferenceVariableArray:input];
        
        NSString* path = (NSString*)input;
        //////////////////NSLog/@"path: %@", path);
        //dispatch_async(dispatch_get_main_queue(), ^{
        
        @synchronized ([self tabMedia]) {
            [[self tabMedia] playMedia:path subRoutine:nil];
        }
        //});
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* fade_in = [[PHPScriptFunction alloc] init];
    [fade_in initArrays];
    [self setDictionaryValue:@"fade_in" value:fade_in];
    [fade_in setPrototype:self];
    [fade_in setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        /*NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        input = [self_instance resolveValueReferenceVariableArray:input];*/
        //[[self tabMedia] pausePlayback];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[self layoutBox] fade_in];
        });
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* fade_out = [[PHPScriptFunction alloc] init];
    [fade_out initArrays];
    [self setDictionaryValue:@"fade_out" value:fade_out];
    [fade_out setPrototype:self];
    [fade_out setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        /*NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        input = [self_instance resolveValueReferenceVariableArray:input];*/
        //[[self tabMedia] pausePlayback];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[self layoutBox] fade_out];
        });
        return nil;
    } name:@"main"];
   
    PHPScriptFunction* fill_view = [[PHPScriptFunction alloc] init];
    [fill_view initArrays];
    [self setDictionaryValue:@"fill_view" value:fill_view];
    [fill_view setPrototype:self];
    [fill_view setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        //NSObject* input = values[0][0];
        /*input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        input = [self_instance resolveValueReferenceVariableArray:input];*/
        //[[self tabMedia] pausePlayback];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[self layoutBox] fillView];
        });
        return nil;
    } name:@"main"];

    
    PHPScriptFunction* fade_switch = [[PHPScriptFunction alloc] init];
    [fade_switch initArrays];
    [self setDictionaryValue:@"fade_switch" value:fade_switch];
    [fade_switch setPrototype:self];
    [fade_switch setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSObject* input = values[0][0];
        /*input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        input = [self_instance resolveValueReferenceVariableArray:input];*/
        //[[self tabMedia] pausePlayback];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[self layoutBox] fadeSwitch:[(MediaTab*)input layoutBox]];
        });
        return nil;
    } name:@"main"];
    
    
    PHPScriptFunction* close = [[PHPScriptFunction alloc] init];
    [close initArrays];
    [self setDictionaryValue:@"close" value:close];
    [close setPrototype:self];
    [close setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^{
            @synchronized ([self tabMedia]) {
                [[self tabMedia] closeTab];
                [[[self layoutBox] mainView] removeFromSuperview];
                [contentLayout removeChild:[self layoutBox]];
            }
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* resetSync = [[PHPScriptFunction alloc] init];
    [resetSync initArrays];
    [self setDictionaryValue:@"reset_sync" value:resetSync];
    [resetSync setPrototype:self];
    [resetSync setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        @synchronized ([self tabMedia]) {
            [[self tabMedia] setWasPlayed:true];
        }
        //dispatch_sync(dispatch_get_main_queue(), ^{
            /*[[self tabMedia] closeTab];
            [[[self layoutBox] mainView] removeFromSuperview];
            [contentLayout removeChild:[self layoutBox]];*/
        //});
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* setAsFront = [[PHPScriptFunction alloc] init];
    [setAsFront initArrays];
    [self setDictionaryValue:@"front" value:setAsFront];
    [setAsFront setPrototype:self];
    [setAsFront setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        /*[[self tabMedia] closeTab];
        [[[self layoutBox] mainView] removeFromSuperview];
        [contentLayout removeChild:[self layoutBox]];*/
        
        @synchronized ([self tabMedia]) {
            [[self tabMedia] setAsFront];
        }
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* set_as_back = [[PHPScriptFunction alloc] init];
    [set_as_back initArrays];
    [self setDictionaryValue:@"back" value:set_as_back];
    [set_as_back setPrototype:self];
    [set_as_back setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        /*[[self tabMedia] closeTab];
        [[[self layoutBox] mainView] removeFromSuperview];
        [contentLayout removeChild:[self layoutBox]];*/
        //////////////////NSLog/@"set as back");
        @synchronized ([self tabMedia]) {
            [[self tabMedia] setAsBack];
        }
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* toggle_audio = [[PHPScriptFunction alloc] init];
    [toggle_audio initArrays];
    [self setDictionaryValue:@"toggle_audio" value:toggle_audio];
    [toggle_audio setPrototype:self];
    [toggle_audio setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        @synchronized ([self tabMedia]) {
            [[self tabMedia] toggleAudio];
        }
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* set_volume = [[PHPScriptFunction alloc] init];
    [set_volume initArrays];
    [self setDictionaryValue:@"set_volume" value:set_volume];
    [set_volume setPrototype:self];
    [set_volume setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        //[[self tabMedia] toggleAudio];
        
        @synchronized ([self tabMedia]) {
            NSObject* input = values[0][0];
            input = [self_instance resolveValueReferenceVariableArray:input];
            /*while([input isKindOfClass:[NSMutableArray class]]) {
             input = ((NSMutableArray*)input)[0];
             }*/
            input = [self_instance resolveValueReferenceVariableArray:input];
            NSNumber* numberValue = [self makeIntoNumber:input];
            ////////////NSLog(@"number value: %@", numberValue);
            [[self tabMedia] setAudioVolume:[numberValue intValue]];
        }
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* get_volume = [[PHPScriptFunction alloc] init];
    [get_volume initArrays];
    [self setDictionaryValue:@"get_volume" value:get_volume];
    [get_volume setPrototype:self];
    [get_volume setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        @synchronized ([self tabMedia]) {
            return @([[self tabMedia] volumeValue]);
        }
    } name:@"main"];
    
    PHPScriptFunction* is_playing = [[PHPScriptFunction alloc] init];
    [is_playing initArrays];
    [self setDictionaryValue:@"is_playing" value:is_playing];
    [is_playing setPrototype:self];
    [is_playing setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        @synchronized ([self tabMedia]) {
            return @([[self tabMedia] isPlaying]);
        }
    } name:@"main"];
    
    
    PHPScriptFunction* currentTime = [[PHPScriptFunction alloc] init];
    [currentTime initArrays];
    [self setDictionaryValue:@"time" value:currentTime];
    [currentTime setPrototype:self];
    [currentTime setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        @synchronized ([self tabMedia]) {
            NSNumber* returnValue = @0;
            @synchronized ([[self tabMedia] player]) {
                if([[[self tabMedia] player] canPause]) {
                    @synchronized ([[[self tabMedia] player] time]) {
                        
                        
                        VLCTime* timeValue = [[[self tabMedia] player] time];
                        @synchronized (timeValue) {
                            NSNumber* timeValueValue = [timeValue value];
                            @synchronized (timeValueValue) {
                                
                                returnValue = @([timeValueValue floatValue]);
                            }
                            //returnValue = @([[[[self tabMedia] player] time] value].floatValue);
                        }
                    }
                }
            }
            return [[self interpretation] makeIntoObjects:returnValue];
        }
    } name:@"main"];
    
    PHPScriptFunction* totalTime = [[PHPScriptFunction alloc] init];
    [totalTime initArrays];
    [self setDictionaryValue:@"total_time" value:totalTime];
    [totalTime setPrototype:self];
    [totalTime setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        @synchronized ([self tabMedia]) {
            NSNumber* returnValue = @0;
            @synchronized ([[self tabMedia] player]) {
                if([[[self tabMedia] player] canPause]) {
                    returnValue = @([[[[[self tabMedia] player] media] length] value].floatValue);
                }
            }
            return [[self interpretation] makeIntoObjects:returnValue];
        }
    } name:@"main"];
    
    PHPScriptFunction* setTime = [[PHPScriptFunction alloc] init];
    [setTime initArrays];
    [self setDictionaryValue:@"set_time" value:setTime];
    [setTime setPrototype:self];
    [setTime setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSNumber* setTimeValue = [self_instance makeIntoNumber:[[self interpretation] toJSON:[self_instance parseInputVariable:values[0][0]]]];
        
        @synchronized ([[self tabMedia] player]) {
            if([[[self tabMedia] player] canPause]) {
                //VLCTime* vlcTime = [[VLCTime alloc] initWithNumber:setTimeValue];
                
                @synchronized ([self tabMedia]) {
                    if([values[0] count] == 1) {
                        [[[self tabMedia] player] setPosition:[setTimeValue floatValue]];
                    } else {
                        VLCTime* vlcTime = [[VLCTime alloc] initWithNumber:setTimeValue];
                        [[[self tabMedia] player] setTime:vlcTime];
                    }
                }
            } else {
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                                  target:[NSBlockOperation blockOperationWithBlock:^{
                    
                    @synchronized ([self tabMedia]) {
                        if([[[self tabMedia] player] canPause]) {
                            if([values[0] count] == 1) {
                                [[[self tabMedia] player] setPosition:[setTimeValue floatValue]];
                            } else {
                                VLCTime* vlcTime = [[VLCTime alloc] initWithNumber:setTimeValue];
                                [[[self tabMedia] player] setTime:vlcTime];
                            }
                        } else {
                        }
                    }
                }]
                                                                selector:@selector(main)
                                                                userInfo:nil
                                                                 repeats:NO
                ];
            }
        }
        return nil;
    } name:@"main"];
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
    
    //[self changeAndPlay:self];
    /*PHPScriptFunction* get_date = [[PHPScriptFunction alloc] init];
    [get_date initArrays];
    //////////////////////////NSLog/@"set log");
    [self setDictionaryValue:@"get_date" value:get_date];
    [get_date setPrototype:self];
    [get_date setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        input = [self_instance resolveValueReferenceVariableArray:input];
        return nil;
    } name:@"main"];*/
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    /*[[self playlist] removeObserver:self forKeyPath:@"media"];

    [player pause];
    [player setMedia:nil];*/
}

    
    /*[self setMediaIndex:0];
    if(![[self player] isPlaying]) {
        [[self player] play];
    }*/
    /*if ([playlistOutline selectedRow] != mediaIndex) {
        [self setMediaIndex:[playlistOutline selectedRow]];
        if (![player isPlaying])
            [player play];
    }*/

/*- (void)setMediaIndex:(int)value {
    if ([[self playlist] count] <= 0)
        return;

    if (value < 0)
        value = 0;
    if (value > [[self playlist] count] - 1)
        value = [[self playlist] count] - 1;

    [self setMediaIndex:value];
    [[self player] setMedia:[[self playlist] mediaAtIndex:[self mediaIndex]]];
}

- (void)play:(id)sender {
    [self setMediaIndex:[self mediaIndex]+1];
    if (![[self player] isPlaying] && [[self playlist] count] > 0) {
        [[self player] play];
    }
}

- (void)pause:(id)sender {
    //////////////////////NSLog/@"Sending pause message to media player...");
    [[self player] pause];
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
}*/
@end
