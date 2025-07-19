//
//  PHPIncludedObjects.m
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import "PHPSearch.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import <WebKit/WebKit.h>
#import "FindFiles.h"

@implementation PHPSearch
- (void) init: (PHPScriptFunction*) context {
    [self initArrays];
    [self setGlobalObject:true];
    
    [self setSubResults:[[NSMutableDictionary alloc] init]];
    
    /*b*/
    PHPScriptFunction* new_search_b = [[PHPScriptFunction alloc] init];
    [new_search_b initArrays];
    [self setDictionaryValue:@"new_search_b" value:new_search_b];
    [new_search_b setPrototype:self];
    [new_search_b setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSString* predicate = values[0][0];
        PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][1];
        PHPScriptObject* locations = (PHPScriptObject*)values[0][2];
        
        PHPScriptFunction* initialCallback = (PHPScriptFunction*)values[0][3];
        PHPScriptFunction* updateCallback = (PHPScriptFunction*)values[0][4];
        
        NSLog(@"self interpretation: %@ - %@", [self interpretation], self);
        
        NSArray* arguments = (NSArray*)[[self interpretation] toJSON:scriptObject];
        NSArray* searchScopes = (NSArray*)[[self interpretation] toJSON:locations];
        
        NSLog(@"new_search : %@ - %@ - %@", predicate, arguments, searchScopes);
        
        FindFiles* find = [[FindFiles alloc] init];
        [find setInstance:self];
        [self setCurrentSearchB:find];
        [find setInterpretation:[self interpretation]];
        [find setInitalCallback:initialCallback];
        [find setUpdateCallback:updateCallback];
        [find startSearch:predicate arguments:arguments searchScopes:searchScopes];
        
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* stop_search_b = [[PHPScriptFunction alloc] init];
    [stop_search_b initArrays];
    [self setDictionaryValue:@"stop_search_b" value:stop_search_b];
    [stop_search_b setPrototype:self];
    [stop_search_b setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        [[self currentSearchB] stopSearch];
        return nil;
    } name:@"main"];
    
    
    PHPScriptFunction* new_search = [[PHPScriptFunction alloc] init];
    [new_search initArrays];
    [self setDictionaryValue:@"new_search" value:new_search];
    [new_search setPrototype:self];
    [new_search setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSString* predicate = values[0][0];
        PHPScriptObject* scriptObject = (PHPScriptObject*)values[0][1];
        PHPScriptObject* locations = (PHPScriptObject*)values[0][2];
        
        PHPScriptFunction* initialCallback = (PHPScriptFunction*)values[0][3];
        PHPScriptFunction* updateCallback = (PHPScriptFunction*)values[0][4];
        
        NSLog(@"self interpretation: %@ - %@", [self interpretation], self);
        
        NSArray* arguments = (NSArray*)[[self interpretation] toJSON:scriptObject];
        NSArray* searchScopes = (NSArray*)[[self interpretation] toJSON:locations];
        
        NSLog(@"new_search : %@ - %@ - %@", predicate, arguments, searchScopes);
        
        FindFiles* find = [[FindFiles alloc] init];
        [find setInstance:self];
        [self setCurrentSearch:find];
        [find setInterpretation:[self interpretation]];
        [find setInitalCallback:initialCallback];
        [find setUpdateCallback:updateCallback];
        [find startSearch:predicate arguments:arguments searchScopes:searchScopes];
        
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* stop_search = [[PHPScriptFunction alloc] init];
    [stop_search initArrays];
    [self setDictionaryValue:@"stop_search" value:stop_search];
    [stop_search setPrototype:self];
    [stop_search setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        [[self currentSearch] stopSearch];
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* getResults = [[PHPScriptFunction alloc] init];
    [getResults initArrays];
    [self setDictionaryValue:@"get_results" value:getResults];
    [getResults setPrototype:self];
    [getResults setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSNumber* key = nil;
        NSString* predicate = nil;
        if([values[0] count] == 1) {
            key = values[0][0];
            return [[self interpretation] makeIntoObjects:[self subResults][key]];
        } else if([values[0] count] == 3) {
            //key = values[0][0];//@([(NSNumber*)values[0][0] intValue] - 1);
            predicate = values[0][0];
            //NSMutableArray* results = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)[self subResults][key]];
            NSArray* arguments = (NSArray*)[[self interpretation] toJSON:values[0][1]];
            NSMutableArray* results = (NSMutableArray*)[[self interpretation] toJSON:values[0][2]];
            NSMutableArray* original = [[NSMutableArray alloc] initWithArray:results];
            //predicate = @"SELF.kMDItemPath LIKE[cd] %@";
            
            
            
            NSPredicate* predicateValue = [NSPredicate predicateWithFormat:predicate argumentArray:arguments];
            [results filterUsingPredicate:predicateValue];
            
            
            NSMutableArray* indicies = [[NSMutableArray alloc] init];
            for(NSMutableDictionary* item in results) {
                [indicies addObject:@([original indexOfObject:item])];
            }
            NSDictionary* resultsWrap = @{
                @"results": results,
                @"indicies": indicies
            };
            NSLog(@"res:  %@", resultsWrap);
            return [[self interpretation] makeIntoObjects:resultsWrap];
        } else {
            NSMutableArray* results = [self subResults][@(0)];
            return [[self interpretation] makeIntoObjects:results];
            /*if([self currentSearch] == nil) {
                return [[PHPScriptObject alloc] init];
            }
            return [[self interpretation] makeIntoObjects:[[[self currentSearch] query] results]];*/
        }
        return [[PHPScriptObject alloc] init];
    } name:@"main"];
    
    
}
@end
