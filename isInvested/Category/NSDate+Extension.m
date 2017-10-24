//
//  NSDate+Extension.m
//  isInvested
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSInteger)week {
    
    NSArray<NSString *> *weekdays = [NSArray arrayWithObjects: [NSNull null], @"7", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    
    return weekdays[theComponents.weekday].integerValue;
}

- (NSAttributedString *)weekStr {
    
    switch (self.week) {
        case 1:
            return [[NSMutableAttributedString alloc] initWithString:@"周一"];
        case 2:
            return [[NSMutableAttributedString alloc] initWithString:@"周二"];
        case 3:
            return [[NSMutableAttributedString alloc] initWithString:@"周三"];
        case 4:
            return [[NSMutableAttributedString alloc] initWithString:@"周四"];
        case 5:
            return [[NSMutableAttributedString alloc] initWithString:@"周五"];
        case 6:
        {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"周六"];
            [str addAttribute:NSForegroundColorAttributeName value:OXColor(0x999999) range:NSMakeRange(0, 2)];
            return str;
        }
        default:
        {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"周日"];
            [str addAttribute:NSForegroundColorAttributeName value:OXColor(0x999999) range:NSMakeRange(0, 2)];
            return str;
        }
    }
}

- (NSAttributedString *)dateStr {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[@"dd" stringFromDate:self]];
    if (self.week >= 6) {
        [str addAttribute:NSForegroundColorAttributeName value:OXColor(0x999999) range:NSMakeRange(0, str.length)];
    }
    return str;
}

/** 获取一周的日期, 周一至周日 */
+ (NSArray<NSDate *> *)getWeekDays {
    
    NSMutableArray *muArr = [NSMutableArray array];
    [muArr addObjectsFromArray:[self daysAgoWithNumber:4]];
    [muArr addObject:[NSDate date]];
    [muArr addObjectsFromArray:[self daysLaterWithNumber:2]];
    return muArr;
}

/** *************************  内部的方法  ***************************** */

/** 获取今天前几天的日期数组, 不含今天 */
+ (NSArray<NSString *> *)daysAgoWithNumber:(NSInteger)number {
    
    NSMutableArray *muArr = [NSMutableArray array];
    NSInteger s = -24 * 60 * 60;
    
    for (NSInteger i = number; i >= 1; i--) {
        NSDate *date = [[NSDate date] initWithTimeIntervalSinceNow:s * i];
        [muArr addObject:date];
    }
    return muArr;
}

/** 获取今天后几天的日期数组, 不含今天 */
+ (NSArray<NSString *> *)daysLaterWithNumber:(NSInteger)number {
    
    NSMutableArray *muArr = [NSMutableArray array];
    NSInteger s = 24 * 60 * 60;
    
    for (NSInteger i = 1; i <= number; i++) {
        NSDate *date = [[NSDate date] initWithTimeIntervalSinceNow:s * i];
        [muArr addObject:date];
    }
    return muArr;
}

+ (NSInteger)currentWeek {
    return [NSDate date].week;
}

@end
