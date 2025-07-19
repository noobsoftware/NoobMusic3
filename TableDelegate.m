//
//  TableDelegate.m
//  noobtest
//
//  Created by siggi jokull on 5.12.2022.
//


#import "TableDelegate.h"

@implementation TableViewDelegate

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    ////////////////////////NSLog/@"25");
    return 25;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //NSView* view = [[NSView alloc] init]
    /*NSTextField *label = [tableView makeViewWithIdentifier:@"view identifier" owner:self];
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
    return label;*/
    NSString *identifier = tableColumn.identifier;
    NSTableCellView *cell = [tableView makeViewWithIdentifier:identifier owner:self];
    if ([identifier isEqualToString:@"numbers"]) {
        cell.textField.stringValue = @"test123";//[self.numbers objectAtIndex:row];
    } else {
        cell.textField.stringValue = @"test123";//[self.letters objectAtIndex:row];
    }
    return cell;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    ////////////////////////NSLog/@"test123");
    return 10;
}
/*- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
    ////////////////////////NSLog/@"test123");
    return @1;
}*/
/*- (void)tableView:(NSTableView *)tableView
   setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row {
    
}*/
@end


