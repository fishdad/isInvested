//
//  NSDate+Extension.h
//  isInvested
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

@property (nonatomic, readonly) NSInteger week;
@property (nonatomic, readonly) NSAttributedString *weekStr;
@property (nonatomic, readonly) NSAttributedString *dateStr;

/** 获取一周的日期, 周一至周日 */
+ (NSArray<NSDate *> *)getWeekDays;

+ (NSInteger)currentWeek;

@end
