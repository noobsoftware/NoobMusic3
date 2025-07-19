#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
@class PHPScriptFunction;
@class PHPInterpretation;
@class PHPSearch;

@interface FindFiles : NSObject

@property(nonatomic) NSString* tag;
@property(nonatomic) NSMetadataQuery* query;
@property(nonatomic) PHPScriptFunction* initalCallback;
@property(nonatomic) PHPScriptFunction* updateCallback;
@property(nonatomic) PHPInterpretation* interpretation;
@property(nonatomic) PHPSearch* instance;
@property(nonatomic) NSObject* lastGather;
//@property (copy) void (^completionHandler)(NSArray*);
//- (void) startSearch: (NSString*) predicate arguments: (NSArray*) arguments;
- (void) startSearch: (NSString*) predicate arguments: (NSArray*) arguments searchScopes: (NSArray*) searchScopes;
- (void) stopSearch;
- (void) restartSearch;
@end
