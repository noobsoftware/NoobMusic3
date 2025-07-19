//
//  PHPIncludedObjects.m
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import "PHPDates.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import "NoobCalendar.h"

@implementation PHPDates
- (void) init: (PHPScriptFunction*) context {
    [self initArrays];
    [self setGlobalObject:true];
    
    /* NSCalendar *gregorian = [NSCalendar currentCalendar];
     //NSCalendar *gregorian = [[NSCalendar alloc] initwi];
     NSDateComponents *components = [gregorian components:(NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:NSDate.now];

     //NSDateComponents *components = [[NSDateComponents alloc] init];
     
     year = @([components  year]);
     month = @([components month]);*/
    PHPScriptFunction* get_current_year = [[PHPScriptFunction alloc] init];
    [get_current_year initArrays];
    //////////////////////////NSLog/@"set log");
    [self setDictionaryValue:@"get_current_date" value:get_current_year];
    [get_current_year setPrototype:self];
    [get_current_year setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        /*NSObject* year = values[0][0];
        NSObject* month = values[0][1];
        
        NSNumber* year_number = [self makeIntoNumber:[self parseInputVariable:year]];
        NSNumber* month_number = [self makeIntoNumber:[self parseInputVariable:month]];
        
        NoobCalendar* calendar = [[NoobCalendar alloc] init];
        NSMutableDictionary* dictResults = [calendar getMonth:year_number month:month_number];
        return [[self getInterpretation] makeIntoObjects:dictResults];*/
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        //NSCalendar *gregorian = [[NSCalendar alloc] initwi];
        NSDateComponents *components = [gregorian components:(NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:NSDate.now];

        //NSDateComponents *components = [[NSDateComponents alloc] init];
        return [[self getInterpretation] makeIntoObjects:@{
            @"year": @([components  year]),
            @"month": @([components month])
        }];
        /*year = @([components  year]);
        month = @([components month]);*/
    } name:@"main"];
    
    PHPScriptFunction* get_month = [[PHPScriptFunction alloc] init];
    [get_month initArrays];
    //////////////////////////NSLog/@"set log");
    [self setDictionaryValue:@"get_month" value:get_month];
    [get_month setPrototype:self];
    [get_month setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* year = values[0][0];
        NSObject* month = values[0][1];
        
        NSNumber* year_number = [self makeIntoNumber:[self parseInputVariable:year]];
        NSNumber* month_number = [self makeIntoNumber:[self parseInputVariable:month]];
        
        NoobCalendar* calendar = [[NoobCalendar alloc] init];
        NSMutableDictionary* dictResults = [calendar getMonth:year_number month:month_number];
        return [[self getInterpretation] makeIntoObjects:dictResults];
    } name:@"main"];
    
    PHPScriptFunction* get_date = [[PHPScriptFunction alloc] init];
    [get_date initArrays];
    //////////////////////////NSLog/@"set log");
    [self setDictionaryValue:@"get_date" value:get_date];
    [get_date setPrototype:self];
    [get_date setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        ////////////////////////NSLog/@"log values: %@", values);
        NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        while([input isKindOfClass:[NSMutableArray class]]) {
            input = ((NSMutableArray*)input)[0];
        }
        input = [self_instance resolveValueReferenceVariableArray:input];
        int yearOffset = 0;
        if([values[0] count] > 0) {
            NSObject* offsetInput1 = values[0][1];
            offsetInput1 = [self_instance resolveValueReferenceVariableArray:offsetInput1];
            while([offsetInput1 isKindOfClass:[NSMutableArray class]]) {
                offsetInput1 = ((NSMutableArray*)offsetInput1)[0];
            }
            offsetInput1 = [self_instance resolveValueReferenceVariableArray:offsetInput1];
            yearOffset = [(NSNumber*)offsetInput1 intValue];
        }
        int monthOffset = 0;
        if([values[0] count] > 1) {
            NSObject* offsetInput2 = values[0][2];
            offsetInput2 = [self_instance resolveValueReferenceVariableArray:offsetInput2];
            while([offsetInput2 isKindOfClass:[NSMutableArray class]]) {
                offsetInput2 = ((NSMutableArray*)offsetInput2)[0];
            }
            offsetInput2 = [self_instance resolveValueReferenceVariableArray:offsetInput2];
            monthOffset = [(NSNumber*)offsetInput2 intValue];
        }
        int dayOffset = 0;
        if([values[0] count] > 2) {
            NSObject* offsetInput3 = values[0][3];
            offsetInput3 = [self_instance resolveValueReferenceVariableArray:offsetInput3];
            while([offsetInput3 isKindOfClass:[NSMutableArray class]]) {
                offsetInput3 = ((NSMutableArray*)offsetInput3)[0];
            }
            offsetInput3 = [self_instance resolveValueReferenceVariableArray:offsetInput3];
            dayOffset = [(NSNumber*)offsetInput3 intValue];
        }
        /*if([input isKindOfClass:[PHPReturnResult class]]) {
            input = [(PHPReturnResult*)input result];
        }
        if([input isKindOfClass:[PHPScriptVariable class]]) {
            input = [(PHPScriptVariable*)input get];
        }*/
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger year = [components year];
        int set_year = (int)year;
        set_year += yearOffset;
        [components setYear:set_year];
        NSInteger month = [components month];
        int set_month = (int)month;
        set_month += monthOffset;
        [components setMonth:set_month];
        NSInteger day = [components day];
        int set_day = (int)day;
        set_day += dayOffset;
        [components setDay:set_day];
        ////////////////////////NSLog/@"output: %@", input);
        NSCalendar* nsCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate* setDate = [nsCalendar dateFromComponents:components];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        NSString* format = @"yyyy-MM-dd";
        NSString* inputFormat = (NSString*)input;
        if([inputFormat isEqualToString:@"default"]) {
            inputFormat = format;
        }
        [dateFormatter setDateFormat:inputFormat];
        //phpDates
        NSString *dateString = [dateFormatter stringFromDate:setDate];
        //NSDate* setDate = [[NSDate alloc]]
        return dateString;
    } name:@"main"];
    
    
    
    PHPScriptFunction* diff_from_now = [[PHPScriptFunction alloc] init];
    [diff_from_now initArrays];
    //////////////////////////NSLog/@"set log");
    [self setDictionaryValue:@"diff_from_now" value:diff_from_now];
    [diff_from_now setPrototype:self];
    [diff_from_now setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSString* inputvalue = (NSString*)[self parseInputVariable:values[0][0]];
        
        NSDate *date1 = [NSDate dateWithString:inputvalue];
        NSDate *date2 = [NSDate now];//[NSDate dateWithString:@"2010-02-03 00:00:00 +0000"];

        if([values[0] count] > 1) {
            date2 = [NSDate dateWithString:(NSString*)[self parseInputVariable:values[0][1]]];
        }
        
        NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
        if([values[0] count] > 2) {
            return @(secondsBetween);
        }
        int numberOfDays = secondsBetween / 86400;
        
        return @(numberOfDays);
        
        /*NSArray* components = [inputvalue componentsSeparatedByString:@"-"];
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:[components[0] longLongValue]];
        [comps setMonth:[components[1] longLongValue]];
        [comps setDay:[components[2] longLongValue]];
        [comps setHour:0];
        [comps setMinute:0];
        [comps setSecond:0];
        
        NSDate *dateOfBirth = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        
        NSTimeInterval timeGap = [[NSDate new] timeIntervalSinceDate:dateOfBirth];
        
        NSDate* dateValue = [[NSDate alloc] initWithTimeIntervalSince1970:timeGap];
        
        NSString* inputMethod = (NSString*)[self parseInputVariable:values[0][1]];
        
        if([inputMethod isEqualToString:@"days"]) {
            //NSDateComponents* resultComponents = [[NSDateComponents alloc] initWithCoder:<#(nonnull NSCoder *)#>]
            //return [dateValue ]
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        NSString* format = @"yyyy-MM-dd";
        [dateFormatter setDateFormat:format];
        //phpDates
        NSString *dateString = [dateFormatter stringFromDate:dateValue];
        //NSDate* setDate = [[NSDate alloc]]
        return dateString;
        
        return nil;*/
    } name:@"main"];
    
    PHPScriptFunction* daysOfMonth = [[PHPScriptFunction alloc] init];
    [daysOfMonth initArrays];
    //////////////////////NSLog/@"set log");
    [self setDictionaryValue:@"month_days" value:daysOfMonth];
    [daysOfMonth setPrototype:self];
    [daysOfMonth setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        ////////////////////NSLog/@"log values: %@", values);
        NSObject* input = [self_instance parseInputVariable:values[0][0]];
        NSNumber* year = [self_instance makeIntoNumber:input];
        
        NSObject* inputB = [self_instance parseInputVariable:values[0][1]];
        NSNumber* month = [self_instance makeIntoNumber:inputB];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        NSDate *date = NSDate.now;
        // Set your year and month here
        if([year isEqualTo:@-1] && [month isEqualTo:@-1]) {
            
        } else {
            [components setYear:[year longLongValue]];
            [components setMonth:[month longLongValue]];
            
            date = [calendar dateFromComponents:components];
        }
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSString* format = @"yyyy-MM-dd";
        [dateFormatter setDateFormat:format];
        //phpDates
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
        [weekday setDateFormat: @"EEEE"];;
        
        //NSLog(@"%d", (int)range.length);
        NSMutableDictionary* results = [[NSMutableDictionary alloc] initWithDictionary:@{
            @"start_date": dateString,
            @"number_of_days": @(range.length),
            @"day": [weekday stringFromDate:date]
        }];
        
        return [[self interpretation] makeIntoObjects:results];
    } name:@"main"];
    
    /**/
}
@end
