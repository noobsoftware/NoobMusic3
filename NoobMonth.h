//
//  NoobMonth.h
//  noobtest
//
//  Created by siggi on 26.9.2024.
//

#ifndef NoobMonth_h
#define NoobMonth_h

#import <Foundation/Foundation.h>

@interface NoobMonth : NSObject
@property (nonatomic) NSMutableDictionary* dateValue;
@property (nonatomic) NSNumber* numberOfDays;
- (void )assignValues: (NSString* ) dateValue numberOfDays: (NSNumber* ) numberOfDays day: (NSNumber* ) day ;
- (NSMutableDictionary* )getLastDate;
@end

#endif /* NoobMonth_h */
