//
//  TableDelegate.h
//  noobtest
//
//  Created by siggi jokull on 5.12.2022.
//
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface TableViewDelegate : NSObject<NSTableViewDelegate, NSTableViewDataSource>

//- (NSView*) getViewForItem: (NSTableView*) tableView (NSTableColumn*)
/*- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row;*/


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
/*- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row;*/
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*- (void)tableView:(NSTableView *)tableView
   setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row;*/

@end
