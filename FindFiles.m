#import "FindFiles.h"
#import "PHPScriptFunction.h"
#import "PHPInterpretation.h"
#import "PHPSearch.h"

/*@interface FindTaggedFiles()
@property (copy) void (^completionHandler)(NSArray*);
@end*/

@implementation FindFiles
/*
-(id)initWithTag:(NSString *)tag withHandler:(void (^)(NSArray *))handler
{
    self = [super init];
    _completionHandler = handler;
    //self->_tag = tag;
    [self setTag:tag];
    return self;
}

- (void) initWithTagA {
    [self setTag:@"test"];
}*/

- (void) stopSearch {
    if([self query] != nil) {
        @synchronized ([self query]) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [[self query] stopQuery];
                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:NSMetadataQueryDidUpdateNotification
                                                              object:[self query]];
                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:NSMetadataQueryDidFinishGatheringNotification
                                                              object:[self query]];
                [self setQuery:nil];
            });
        }
    }
}

- (void) startSearch: (NSString*) predicate arguments: (NSArray*) arguments searchScopes: (NSArray*) searchScopes {
    //dispatch_async(dispatch_get_main_queue(), ^{
    if([self query] != nil) {
        [[self query] stopQuery];
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self setQuery:[[NSMetadataQuery alloc] init]];
        //[[self query] stopQuery];
        
        //[[self query] stopQuery];
        //[[self query] enableUpdates];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDidUpdate:) name:NSMetadataQueryDidUpdateNotification object:[self query]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initalGatherComplete:) name:NSMetadataQueryDidFinishGatheringNotification object:[self query]];
        
        //[[self query] dire]
        
        NSPredicate *searchPredicate;
        //NSString* predicate = [NSString stringWithFormat:@"kMDItemUserTags == '%@'", [self tag] ];
        //NSString* predicate = @"kMDItemUserTags == %@";
        //searchPredicate = [NSPredicate predicateWithFormat:predicate, [self tag]];
        //searchPredicate = [NSPredicate predicateWithFormat:predicate arguments:[@[[self tag]] ]];
        //NSLog(@"search %@, %@ %@", predicate, arguments, searchScopes);
        NSMutableArray* inArray = [[NSMutableArray alloc] init];
        for(NSObject* item in arguments) {
            //NSLog(@"item is : %@ - %@", item, [item class]);
            if([item isKindOfClass:[NSArray class]]) {
                for(NSObject* subitem in (NSArray*)item) {
                    //NSLog(@"item is : %@ - %@", subitem, [subitem class]);
                }
            }
            if([item isKindOfClass:[NSDictionary class]]) {
                NSDictionary* dictValue = (NSDictionary*)item;
                if(dictValue[@"date_value"] != nil) {
                    @try {
                        NSMutableArray* itemObj = [[NSMutableArray alloc] init];
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"yyyy-MM-dd"];
                        NSDate *date = [dateFormat dateFromString:dictValue[@"date_value"]];
                        [inArray addObject:date];
                        //NSLog(@"setDate : %@", date);
                    } @catch(NSException* exception) {
                        [inArray addObject:dictValue[@"date_value"]];
                    }
                } else if(dictValue[@"date"] != nil) {
                    /*NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                     [formatter dateFromString:dictValue[@"date"][0]];
                     NSDateFormatter* formatterB = [[NSDateFormatter alloc] init];
                     [formatterB dateFromString:dictValue[@"date"][1]];*/
                    //NSLog(@"itemObj: %@", dictValue);
                    /*NSArray* itemObj = @[
                     [[NSDate alloc] initWithString:dictValue[@"date"][0]],
                     [[NSDate alloc] initWithString:dictValue[@"date"][1]]
                     ];*/
                    NSMutableArray* itemObj = [[NSMutableArray alloc] init];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    NSDate *date = [dateFormat dateFromString:dictValue[@"date"][0]];
                    [itemObj addObject:date];
                    NSDate *dateB = [dateFormat dateFromString:dictValue[@"date"][1]];
                    [itemObj addObject:dateB];
                    
                    //NSLog(@"itemObj: %@", itemObj);
                    [inArray addObject:itemObj];
                }
            } else {
                [inArray addObject:item];
            }
        }
        //NSLog(@"inarray : %@", inArray);
        searchPredicate = [NSPredicate predicateWithFormat:predicate argumentArray:inArray]; //@[[self tag]]
        [[self query] setPredicate:searchPredicate];
        
        /*NSArray *searchScopes;
         searchScopes=[NSArray arrayWithObjects:NSMetadataQueryUserHomeScope,nil];*/
        
        //NSArray* searchScopes = @[scope];
        
        //NSMetadataQueryLocalComputerScope
        
        //[[self query] setDelegate:(id<NSMetadataQueryDelegate> _Nullable)]
        
        [[self query] setSearchScopes:searchScopes];
        
        NSSortDescriptor *sortKeys=[[NSSortDescriptor alloc] initWithKey:(id)kMDItemDisplayName ascending:YES];
        [[self query] setSortDescriptors:[NSArray arrayWithObject:sortKeys]];
        //dispatch_async(dispatch_get_main_queue(), ^{
        [[self query] startQuery];
    });
    //});
}

- (void) restartSearch {
    [[self query] stopQuery];
    [[self query] startQuery];
}

- (void)queryDidUpdate:sender {
    NSLog(@"A data batch has been received");
    return;
    /*NSMutableArray* files = [[NSMutableArray alloc] init];
    NSUInteger i=0;
    for (i=0; i < [[self query] resultCount]; i++) {
        NSMetadataItem *theResult = [[self query] resultAtIndex:i];
        [files addObject:theResult];
    }*/

    NSMutableArray* files = [[NSMutableArray alloc] initWithArray:[[self query] results]];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidUpdateNotification object:query];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
    //self->query=nil;

    if([self updateCallback] != nil) {
        PHPScriptFunction* function = (PHPScriptFunction*)[self updateCallback];
        PHPScriptObject* resultsObject = [[self interpretation] makeIntoObjects:files];
        [self setLastGather:resultsObject];
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        NSMutableArray* arr2 = [[NSMutableArray alloc] initWithArray:@[
            resultsObject
        ]];
        [arr addObject:arr2];
        [function callScriptFunctionSub:arr parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:nil];
    }
}

- (void)initalGatherComplete:sender {
    //[[self query] stopQuery];
    NSLog(@"gather completed:");
    /*NSMutableArray* files = [[NSMutableArray alloc] init];
     NSUInteger i=0;
     for (i=0; i < [[self query] resultCount]; i++) {
     NSMetadataItem *theResult = [[self query] resultAtIndex:i];
     [files addObject:theResult];
     }*/
    
    
    NSMutableArray* files = [[NSMutableArray alloc] initWithArray:[[self query] results]];
    /*NSMutableArray* filesArr = [[NSMutableArray alloc] init];
    for(NSMetadataItem* item in files) {
        [filesArr addObject:[item dictionaryWithValuesForKeys:<#(nonnull NSArray<NSString *> *)#>]]
    }*/
    //[[self instance] subResults][@(0)] = files;
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidUpdateNotification object:query];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
    //self->query=nil;

    /*NSLog(@"files : %@", files);
    for(NSMetadataItem* item in files) {
        NSLog(@"item: %@", item);
        //[item val]
    }*/
    //_completionHandler(files);
    if([self initalCallback] != nil) {
        PHPScriptFunction* function = (PHPScriptFunction*)[self initalCallback];
        PHPScriptObject* resultsObject = [[self interpretation] makeIntoObjects:files];
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        NSMutableArray* arr2 = [[NSMutableArray alloc] initWithArray:@[
            resultsObject
        ]];
        [arr addObject:arr2];
        [function callScriptFunctionSub:arr parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:nil];
        //NSLog(@"files : %@", files);
    }
    //[[self query] stopQuery];
}

@end

/*FindTaggedFiles* finder = [[FindTaggedFiles alloc]initWithTag:@"Disneyland" withHandler:^(NSArray* files){
 //do something with the files
}];

[finder startSearch];*/
