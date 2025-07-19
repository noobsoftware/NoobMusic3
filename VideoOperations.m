//
//  VideoOperations.m
//  noobtest
//
//  Created by siggi on 6.2.2024.
//

#import "VideoOperations.h"
#import "PHPScriptFunction.h"
#import "PHPMath.h"
/*@implementation VideoOperations
- (void)audioLevel {
    NSNumber* progressValue =
        [[self math] mult:(@([@([[self results] count]) doubleValue] /
                             [[self totalLength] doubleValue]))
                        b:@100];
    [[self progressCallback]
        callCallback:[[NSMutableArray alloc] initWithArray:@[ progressValue ]]];
    if ([@([[self filepaths] count]) isEqualTo:@0]) {
        [[self callback] callCallback:[[NSMutableArray alloc]
                                          initWithArray:@[ [self results] ]]];

    } else {
        NSString* filepath = [[self filepaths] firstObject];
        NSNumber* zero = @0;
        [[self filepaths] removeObjectAtIndex:[zero intValue]];
        NSString* command = [@"-i \""
            stringByAppendingString:
                [filepath stringByAppendingString:
                              @"\" -filter:a volumedetect -f null /dev/null"]];
        VideoOperations* selfInstance = self;
        void (^completeCallback)(FFmpegSession*) = ^(FFmpegSession* session) {
          SessionState* state = [session getState];
          ReturnCode* returnCode = [session getReturnCode];
          [selfInstance audioLevel];
        };
        void (^logCallback)(Log*) = ^(Log* log) {
          NSString* logValue = [log getMessage];
          NSRange range = [logValue rangeOfString:@"max_volume:"];
          NSNumber* NSNotFoundValue = @(NSNotFound);
          if (![@(range.location) isEqualTo:NSNotFoundValue]) {
              NSMutableArray* split =
                  [logValue componentsSeparatedByString:@"max_volume: "];
              [[self results] addObject:split[1]];
              NSLog(@"log value : %@", split[1]);
          }
        };
        FFmpegSession* session = [FFmpegKit executeAsync:command
                                    withCompleteCallback:completeCallback
                                         withLogCallback:logCallback
                                  withStatisticsCallback:nil];
    }
}
- (void)audioLevels:(NSMutableArray*)filepaths
            callback:(PHPScriptFunction*)callback
    progressCallback:(PHPScriptFunction*)progressCallback {
    [self setMath:[[PHPMath alloc] init]];
    [self setResults:[[NSMutableArray alloc] initWithArray:@[]]];
    [self setFilepaths:filepaths];
    [self setTotalLength:@([filepaths count])];
    [self setCallback:callback];
    [self setProgressCallback:progressCallback];
    [self audioLevel];
}
@end
*/
@implementation VideoOperations
- (void)audioLevel {
    NSNumber* progressValue =
        [[self math] mult:(@([@([[self results] count]) doubleValue] /
                             [[self totalLength] doubleValue]))
                        b:@100];
    [[self progressCallback]
        callCallback:[[NSMutableArray alloc] initWithArray:@[ progressValue ]]];
    if ([@([[self filepaths] count]) isEqualTo:@0]) {
        NSMutableArray* completedResults =
            [[NSMutableArray alloc] initWithArray:@[]];
        NSNumber* key = @0;
        for (NSObject* resultsItem in [self results]) {
            [completedResults
                addObject:[[NSMutableDictionary alloc] initWithDictionary:@{
                    @"max_audio_level" : resultsItem,
                    @"audio_level" : [self resultsMean][[key intValue]],
                    @"path" : [self filepathsTotal][[key intValue]][@"path"],
                    @"id" : [self filepathsTotal][[key intValue]][@"id"]
                }]];
            key = @([key doubleValue] + 1);
        }
        [[self callback] callCallback:[[NSMutableArray alloc]
                                          initWithArray:@[ completedResults ]]];

    } else {
        NSString* filepath = [[self filepaths] firstObject][@"path"];
        NSArray* splitA = [filepath componentsSeparatedByString:@"\""];
        filepath = [splitA componentsJoinedByString:@"\"'\"'\""];
        NSNumber* zero = @0;
        [[self filepaths] removeObjectAtIndex:[zero intValue]];
        NSString* command = [@"-i \""
            stringByAppendingString:
                [filepath stringByAppendingString:
                              @"\" -filter:a volumedetect -f null /dev/null"]];
        VideoOperations* selfInstance = self;
        void (^completeCallback)(FFmpegSession*) = ^(FFmpegSession* session) {
          SessionState* state = [session getState];
          ReturnCode* returnCode = [session getReturnCode];
          [selfInstance audioLevel];
        };
        void (^logCallback)(Log*) = ^(Log* log) {
          NSString* logValue = [log getMessage];
          NSRange range = [logValue rangeOfString:@"max_volume: "];
          NSNumber* NSNotFoundValue = @(NSNotFound);
          if (![@(range.location) isEqualTo:NSNotFoundValue]) {
              NSMutableArray* split =
                  [logValue componentsSeparatedByString:@"max_volume: "];
              [[self results] addObject:split[1]];
          }
          range = [logValue rangeOfString:@"mean_volume: "];
          if (![@(range.location) isEqualTo:NSNotFoundValue]) {
              NSMutableArray* split =
                  [logValue componentsSeparatedByString:@"mean_volume: "];
              [[self resultsMean] addObject:split[1]];
          }
        };
        void (^statsCallback)(Statistics*) = ^(Statistics* statistics) {
          NSLog(@"test");
        };
        FFmpegSession* session = [FFmpegKit executeAsync:command
                                    withCompleteCallback:completeCallback
                                         withLogCallback:logCallback
                                  withStatisticsCallback:nil];
    }
}
- (void)audioLevels:(NSMutableArray*)filepaths
            callback:(PHPScriptFunction*)callback
    progressCallback:(PHPScriptFunction*)progressCallback {
    [self setMath:[[PHPMath alloc] init]];
    [self setResults:[[NSMutableArray alloc] initWithArray:@[]]];
    [self setResultsMean:[[NSMutableArray alloc] initWithArray:@[]]];
    [self setFilepaths:filepaths];
    [self setFilepathsTotal:[[NSMutableArray alloc] initWithArray:filepaths]];
    [self setTotalLength:@([filepaths count])];
    [self setCallback:callback];
    [self setProgressCallback:progressCallback];
    [self audioLevel];
}
@end
