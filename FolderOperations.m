//
//  FolderOperations.m
//  noobtest
//
//  Created by siggi on 8.2.2024.
//

//#import <Foundation/Foundation.h>
#import "FolderOperations.h"

@implementation FolderOperations
- (NSMutableDictionary*)partitionByParentFolder:(NSMutableArray*)input
                                            key:(NSString*)key {
    NSMutableDictionary* byFolder = [[NSMutableDictionary alloc] init];
    for (NSMutableDictionary* item in input) {
        NSString* parentPath = [item[key] stringByDeletingLastPathComponent];
        if (byFolder[parentPath] == nil) {
            byFolder[parentPath] = [[NSMutableArray alloc] initWithArray:@[]];
        }
        [byFolder[parentPath] addObject:item];
    }
    return byFolder;
}
@end
