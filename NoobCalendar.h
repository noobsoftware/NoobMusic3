//
//  NoobCalendar.h
//  noobtest
//
//  Created by siggi on 26.9.2024.
//

#ifndef NoobCalendar_h
#define NoobCalendar_h

#import <Foundation/Foundation.h>
@class PHPDates;
@class PHPScriptFunction;
@class PHPScriptObject;
#import "NoobMonth.h"

@interface NoobCalendar : NSObject
- (NSMutableDictionary* )getMonth: (NSNumber* ) year month: (NSNumber* ) month ;
- (NSString* )dayStringValue: (NSNumber* ) day ;
- (NSNumber* )dayNumericValue: (NSString* ) day ;
@end

#endif /* NoobCalendar_h */
