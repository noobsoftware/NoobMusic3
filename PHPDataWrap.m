//
//  PHPDataWrap.m
//  noobtest
//
//  Created by siggi jokull on 1.3.2023.
//


#import "PHPDataWrap.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import "DBConnection.h"
#import "PHPData.h"

@implementation PHPDataWrap
- (void) init: (PHPScriptFunction*) context instances: (NSDictionary*) instances {
    [self initArrays];
    
    /*[self setLayoutBox:[[LayoutBox alloc] init]];
     [[self layoutBox] setIsVideoView:true];
     [contentLayout addVideoViewLayout:[self layoutBox]];
     
     [self setTabMedia:[[TabMedia alloc] init]];
     [[self tabMedia] initWithVideoView:(VLCVideoView*)[[self layoutBox] mainView]];
     
     ClickVideoView* clickVideoView = (ClickVideoView*)[[self layoutBox] mainView];*/
    
    PHPScriptFunction* get_instance = [[PHPScriptFunction alloc] init];
    [get_instance initArrays];
    [self setDictionaryValue:@"fetch" value:get_instance];
    [get_instance setPrototype:self];
    [get_instance setClosure:^NSObject*(NSMutableArray* values, PHPScriptFunction* __weak self_instance) {
        ////////////////////NSLog/@"get instance: %@", values);
        NSObject* input = values[0][0];
        input = [context resolveValueReferenceVariableArray:input];
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }
        NSString* input_instance = (NSString*)input;
        ////////////////////NSLog/@"get instance: %@", input_instance);
        return [[self getInterpretation] makeIntoObjects:instances[input_instance]];
    } name:@"main"];
    
    /*PHPScriptFunction* fetchfile = [[PHPScriptFunction alloc] init];
    [fetchfile initArrays];
    [self setDictionaryValue:@"fetchfile" value:fetchfile];
    [fetchfile setPrototype:self];
    [fetchfile setClosure:^NSObject*(NSMutableArray* values, PHPScriptFunction* __weak self_instance) {
        ////////////////////NSLog/@"get instance: %@", values);
        NSObject* input = values[0][0];
        input = [context resolveValueReferenceVariableArray:input];
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }
        NSString* input_instance = (NSString*)input;
        if(![[NSFileManager defaultManager] fileExistsAtPath:input_instance]) {
            return nil;
        }
            
        ////////////////////NSLog/@"get instance: %@", input_instance);
        //return instances[input_instance];
        DBConnection* sqlCinema = [[DBConnection alloc] init];
        [sqlCinema initializeDatabaseWithPath:input_instance callback:^{
            
        }];
        PHPData* phpDataCinema = [[PHPData alloc] init];
        [phpDataCinema init:context sql:sqlCinema];
        [phpDataCinema setInterpretation:[context interpretation]];
        return phpDataCinema;
    } name:@"main"];*/
}
@end
