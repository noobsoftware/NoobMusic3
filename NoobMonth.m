//
//  NoobMonth.m
//  noobtest
//
//  Created by siggi on 26.9.2024.
//

#import "NoobMonth.h"

@implementation NoobMonth
- (void )assignValues: (NSString* ) dateValue numberOfDays: (NSNumber* ) numberOfDays day: (NSNumber* ) day  {
NSMutableArray*  dateValueSplit = [dateValue componentsSeparatedByString:@"-"];
[self setNumberOfDays:numberOfDays];
[self setDateValue:[[NSMutableDictionary alloc] initWithDictionary:@{@"year":@([dateValueSplit[0] intValue]), @"month":@([dateValueSplit[1] intValue]), @"day":day}]];
}
- (NSMutableDictionary* )getLastDate {
NSNumber*  firstDay = [self dateValue][@"day"];
NSNumber*  dateIndex = @1;
while([dateIndex isLessThan:[self numberOfDays]])
{
firstDay = @([firstDay longLongValue]+1);
if([firstDay isGreaterThan:@6]) {
firstDay = @0;

}
dateIndex = @([dateIndex longLongValue]+1);

}
NSNumber*  year = [self dateValue][@"year"];
NSNumber*  month = [self dateValue][@"month"];
NSMutableDictionary*  lastDate = [[NSMutableDictionary alloc] initWithDictionary:@{@"year":year, @"month":month, @"date":dateIndex, @"day":firstDay}];
return lastDate;
}
@end
