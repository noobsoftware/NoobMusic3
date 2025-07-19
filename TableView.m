//
//  TableView.m
//  noobtest
//
//  Created by siggi jokull on 5.12.2022.
//

#import "TableView.h"

@implementation TableView
/*
 NSTableView tableView = new NSTableView () {
                 Frame = frame
             };

             // Just like NSOutlineView, NSTableView expects at least one column
             tableView.AddColumn (new NSTableColumn ("Values"));
             tableView.AddColumn (new NSTableColumn ("Data"));

             // Setup the Delegate/DataSource instances to be interrogated for data and view information
             // In Unified, these take an interface instead of a base class and you can combine these into
             // one instance.
             tableView.DataSource = new TableDataSource ();
             tableView.Delegate = new TableDelegate ();

             NSScrollView scrollView = new NSScrollView (frame) {
                 AutoresizingMask = NSViewResizingMask.HeightSizable | NSViewResizingMask.WidthSizable
             };
             scrollView.DocumentView = tableView;
             return scrollView;
 */

- (NSScrollView*) getTableView: (CGRect) frame {
    NSTableView* tableView = [[NSTableView alloc] initWithFrame:frame];
    NSTableColumn* column_a = [[NSTableColumn alloc] init];
    [column_a setTitle:@"Values"];
    NSTableColumn* column_b = [[NSTableColumn alloc] init];
    [column_b setTitle:@"Data"];
    [tableView addTableColumn:column_a];
    [tableView addTableColumn:column_b];
    [tableView setIdentifier:@"table_a"];
    [column_b setIdentifier:@"column_b"];
    [column_a setIdentifier:@"column_a"];
    //TableDataSource* tableDataSource = [[TableDataSource alloc] init];
    //TableViewDelegate* tableDelegate = [[TableViewDelegate alloc] init];
    NSCell* cell = [[NSCell alloc] initTextCell:@"test123"];
    [cell setIdentifier:@"identifier"];
    [tableView setCell:cell];
    //[tableView cell]
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    //[tableView ]
    //[tableView set]
    NSScrollView* scrollView = [[NSScrollView alloc] initWithFrame:frame];
    [scrollView setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
    [scrollView setDocumentView:tableView];
    [self setTableView:tableView];
    return scrollView;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    //////////////////////////NSLog/@"25");
    return 25;
}

- (void) getTest: (double) val {
    ////////////////////////NSLog/@"%f", val);
}

//NSView GetViewForItem (NSTableView tableView, NSTableColumn tableColumn, nint row)

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //NSView* view = [[NSView alloc] init]
    NSTextField *label = [tableView makeViewWithIdentifier:@"identifier" owner:self];
    if(label == nil) {
        label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, [tableColumn width], 20)];
        //[label];
        [label setEditable:false];
        [label setUsesSingleLineMode:false];
        [label setTextColor:[NSColor blackColor]];
        //[label setBackgroundColor:[NSColor whiteColor]];
        //[label setLineBreakStrategy:NSLineBreakStrategyStandard];
        //[label setDir:NSLineMovesDown];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        //[label setMaximumNumberOfLines:5];
        [[label cell] setTruncatesLastVisibleLine:true];
    }
    [label setIdentifier:@"view identifier"];
    [label setStringValue:@"test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123 test123 test123test123test123 test123 test123 test123"];
    ////////////////////////NSLog/@"test");
    return label;
    /*NSString *identifier = @"identifier";//tableColumn.identifier;
    NSTableCellView *cell = [tableView makeViewWithIdentifier:identifier owner:self];
    if ([identifier isEqualToString:@"numbers"]) {
        cell.textField.stringValue = @"test123";//[self.numbers objectAtIndex:row];
    } else {
        cell.textField.stringValue = @"test123";//[self.letters objectAtIndex:row];
    }
    ////////////////////////NSLog/@"test1231111");
    [[cell textField] setTextColor:[NSColor blueColor]];
    return cell;*/
}

- (void) reload {
    [[self tableView] reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    ////////////////////////NSLog/@"test123");
    return 2500;
}

/*- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    return YES;
}

// What kind of drag operation should I perform?
- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id )info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {
    return op == NSTableViewDropAbove; // Specifies that the drop should occur above the specified row.
}

// The mouse button was released over a row in the table view, should I accept the drop?
- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id )info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op {
    //[self reArrange:list sourceNum:sourceIndex destNum:row]; // let the source array reflect the change
    return YES;
}*/

@end

