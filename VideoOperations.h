//
//  VideoOperations.h
//  noobtest
//
//  Created by siggi on 6.2.2024.
//

#ifndef VideoOperations_h
#define VideoOperations_h

#import <Foundation/Foundation.h>
#import <FFmpegKit/FFmpegKit.h>
@class PHPScriptFunction;
@class PHPMath;

@interface VideoOperations : NSObject
- (void )audioLevel;
@property (nonatomic) NSMutableArray* results;
@property (nonatomic) NSMutableArray* resultsMean;
@property (nonatomic) NSMutableArray* filepaths;
@property (nonatomic) NSMutableArray* filepathsTotal;
@property (nonatomic) PHPScriptFunction*callback;
@property (nonatomic) PHPScriptFunction*progressCallback;
@property (nonatomic) PHPMath*math;
@property (nonatomic) NSNumber* totalLength;
- (void )audioLevels: (NSMutableArray* ) filepaths callback: (PHPScriptFunction*) callback progressCallback: (PHPScriptFunction*) progressCallback ;
@end

#endif /* VideoOperations_h */
