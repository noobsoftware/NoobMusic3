//
//  NoobCalendar.m
//  noobtest
//
//  Created by siggi on 26.9.2024.
//

#import "NoobCalendar.h"
#import "PHPDates.h"
#import "PHPScriptFunction.h"
#import "PHPScriptObject.h"
@implementation NoobCalendar
- (NSMutableDictionary* )getMonth: (NSNumber* ) year month: (NSNumber* ) month  {
PHPDates* date = [[PHPDates alloc] init];
if(year == NULL) {
year = (@(-[@1 doubleValue]));
month = (@(-[@1 doubleValue]));

}
NSMutableDictionary*  dateDict = [date getDictionary];
PHPScriptFunction* getDateAction = dateDict[@"monthDays"];
PHPScriptObject* monthValuesItem = [getDateAction callCallback:[[NSMutableArray alloc] initWithArray:@[year, month]]];
NSMutableDictionary*  monthValues = [monthValuesItem getDictionary];
NSString*  dateValue = monthValues[@"startDate"];
NSMutableArray*  dateSplit = [dateValue componentsSeparatedByString:@"-"];
NSNumber*  setYear = @([dateSplit[0] intValue]);
NSNumber*  setMonth = @([dateSplit[1] intValue]);
NSNumber*  lastMonth = @([setMonth doubleValue]-[@1 doubleValue]);
NSNumber*  lastMonthYear = setYear;
NSNumber*  nextMonth = @([setMonth doubleValue]+[@1 doubleValue]);
NSNumber*  nextMonthYear = setYear;
if([lastMonth isEqualTo:@0]) {
lastMonth = @12;
lastMonthYear = @([lastMonthYear doubleValue]-[@1 doubleValue]);

}
if([nextMonth isEqualTo:@13]) {
nextMonth = @1;
nextMonthYear = @([nextMonthYear doubleValue]+[@1 doubleValue]);

}
NSMutableDictionary*  lastMonthValues = [getDateAction callCallback:[[NSMutableArray alloc] initWithArray:@[lastMonthYear, lastMonth]]];
NSMutableDictionary*  nextMonthValues = [getDateAction callCallback:[[NSMutableArray alloc] initWithArray:@[nextMonthYear, nextMonth]]];
NSNumber*  firstDay = [self dayNumericValue:lastMonthValues[@"day"]];
NoobMonth* lastMonthItem = [[NoobMonth alloc] init];
[lastMonthItem assignValues:lastMonthValues[@"startDate"] numberOfDays:lastMonthValues[@"numberOfDays"] day:firstDay];
NSMutableDictionary*  lastMonthLastDay = [lastMonthItem getLastDate];
NSMutableArray*  monthDays = [[NSMutableArray alloc] initWithArray:@[]];
NSNumber*  dayCounter = @0;
NSNumber*  dateIndexValue = @([lastMonthLastDay[@"date"] doubleValue]-[lastMonthLastDay[@"day"] doubleValue]);
NSMutableArray*  currentMonthWeek = [[NSMutableArray alloc] initWithArray:@[]];
NSMutableDictionary*  interval = [[NSMutableDictionary alloc] initWithDictionary:@{@"from":dateIndexValue}];
while([dateIndexValue isLessThanOrEqualTo:lastMonthLastDay[@"date"]])
{
[currentMonthWeek addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"date":dateIndexValue, @"day":dayCounter}]];
dateIndexValue = @([dateIndexValue longLongValue]+1);
dayCounter = @([dayCounter longLongValue]+1);

}
if([dayCounter isEqualTo:@7]) {
[monthDays addObject:currentMonthWeek];
currentMonthWeek = [[NSMutableArray alloc] initWithArray:@[]];
dayCounter = @0;

}
dateIndexValue = @1;
while([dateIndexValue isLessThanOrEqualTo:monthValues[@"numberOfDays"]])
{
[currentMonthWeek addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"date":dateIndexValue, @"day":dayCounter, @"currentMonth":@true}]];
dateIndexValue = @([dateIndexValue longLongValue]+1);
dayCounter = @([dayCounter longLongValue]+1);
if([dayCounter isEqualTo:@7]) {
[monthDays addObject:currentMonthWeek];
currentMonthWeek = [[NSMutableArray alloc] initWithArray:@[]];
dayCounter = @0;

}

}
dateIndexValue = @1;
while([dayCounter isLessThanOrEqualTo:@6])
{
[currentMonthWeek addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"date":dateIndexValue, @"day":dayCounter}]];
dateIndexValue = @([dateIndexValue longLongValue]+1);
dayCounter = @([dayCounter longLongValue]+1);

}
interval[@"to"]=dateIndexValue;
[monthDays addObject:currentMonthWeek];
NSMutableDictionary*  result = [[NSMutableDictionary alloc] initWithDictionary:@{@"interval":interval, @"monthDays":monthDays, @"setYear":setYear, @"setMonth":setMonth, @"lastMonth":lastMonth, @"lastMonthYear":lastMonthYear, @"nextMonth":nextMonth, @"nextMonthYear":nextMonthYear}];
return result;
}
- (NSString* )dayStringValue: (NSNumber* ) day  {
NSString*  result = @"Monday";
if([day isEqualTo:@1]) {
result = @"Tuesday";

}else if([day isEqualTo:@2]) {
result = @"Wednesday";

}else if([day isEqualTo:@3]) {
result = @"Thursday";

}else if([day isEqualTo:@4]) {
result = @"Friday";

}else if([day isEqualTo:@5]) {
result = @"Saturday";

}else if([day isEqualTo:@6]) {
result = @"Sunday";

}
return result;
}
- (NSNumber* )dayNumericValue: (NSString* ) day  {
NSNumber*  result = @0;
if([day isEqualTo:@"Monday"]) {
result = @0;

}else if([day isEqualTo:@"Tuesday"]) {
result = @1;

}else if([day isEqualTo:@"Wednesday"]) {
result = @2;

}else if([day isEqualTo:@"Thursday"]) {
result = @3;

}else if([day isEqualTo:@"Friday"]) {
result = @4;

}else if([day isEqualTo:@"Saturday"]) {
result = @5;

}else if([day isEqualTo:@"Sunday"]) {
result = @6;

}
return result;
}
@end

