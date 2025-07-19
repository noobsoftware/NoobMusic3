//
//  FolderOperations.h
//  noobtest
//
//  Created by siggi on 8.2.2024.
//

#ifndef FolderOperations_h
#define FolderOperations_h

#import <Foundation/Foundation.h>

@interface FolderOperations : NSObject
- (NSMutableDictionary* )partitionByParentFolder: (NSMutableArray* ) input key: (NSString* ) key ;
@end

#endif /* FolderOperations_h */
