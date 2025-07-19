//
//  TableDataSource.m
//  noobtest
//
//  Created by siggi jokull on 5.12.2022.
//

#import "TableDataSource.h"

@implementation TableDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    ////////////////////////NSLog/@"test123");
    return 10;
}
- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
    ////////////////////////NSLog/@"test123");
    return @1;
}
- (void)tableView:(NSTableView *)tableView
   setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row {
    
}

@end



