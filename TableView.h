//
//  TableView.h
//  noobtest
//
//  Created by siggi jokull on 5.12.2022.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface TableView : NSObject<NSTableViewDelegate, NSTableViewDataSource>
@property (nonatomic) NSTableView* tableView;
- (NSScrollView*) getTableView: (CGRect) frame;

- (void) getTest: (double) val;
- (void) reload;
//- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row;

//- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
/*- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row;*/
//-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end
