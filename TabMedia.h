//
//  TabMedia.h
//  noobtest
//
//  Created by siggi jokull on 25.2.2023.
//

#ifndef TabMedia_h
#define TabMedia_h

#import <Foundation/Foundation.h>
#import <VLCKit/VLCKit.h>
@class MediaTab;
@class PHPScriptObject;
@class PHPInterpretation;
/*@class WKWebView;*/

@interface TabMedia : NSObject<VLCMediaPlayerDelegate>
@property(nonatomic) NSMutableArray* callbacks;

//@property(nonatomic) MediaTab* mediaTab;
@property(nonatomic) VLCVideoView* videoView;
@property(nonatomic) VLCMediaList* playlist;
@property(nonatomic) VLCMediaPlayer* player;
@property(nonatomic) int volumeValue;
@property(nonatomic) NSOpenPanel* currentOpenPanel;
@property(nonatomic) bool wasPaused;
@property(nonatomic) bool subtitlesDisabled;
@property(nonatomic) bool wasPlayed;
@property(nonatomic) NSString* lastSetSyncTime;
@property(nonatomic) NSTimer* pausedTimer;
//@property(nonatomic) VLCMedia* lastMedia;
//@property(nonatomic) VLCMedia* currentMedia;
- (void) initWithVideoView: (VLCVideoView*) videoView  syncPlayer: (bool) syncPlayer;
- (void) pausePlayback;
- (void) closeTab;
- (void) playMedia: (NSString*) path subRoutine:(NSObject*(^)(int))subRoutine;
- (void) mediaPlayerStateChanged:(NSNotification *)aNotification;
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification;
- (void) setAsFront;
- (void) setAsBack;
- (void) toggleAudio;
- (void) setAudioVolume: (int) audioVolume;
- (NSNumber*) getDuration;
- (int) isPlaying;
- (NSMutableDictionary*) status: (bool) resetSync;
//- (NSMutableDictionary*) status;
- (void) setStatusValues: (NSMutableDictionary*) values;
- (void) dealloc;
- (void) unsetWasPaused;
@end

#endif /* TabMedia_h */
