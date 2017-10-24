//
//  CalendarMessage.m
//  isInvested
//
//  Created by admin on 16/8/26.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CalendarMessage.h"

@implementation CalendarMessage

- (NSString *)Finance_Time {
    return [_Finance_Time substringWithRange:NSMakeRange(11, 5)];
}

- (NSString *)result {
    return _Finance_Prediction.length ? @"已公布" : @"侦测中";
}

- (NSInteger)signColor {
    return _Finance_Prediction.length ? kCalendarSignPastColor : kCalendarSignNowColor;
}

- (NSString *)Finance_Before {
    
    NSString *str = _Finance_Before.length ? _Finance_Before : @"--";
    return [@"前值  " stringByAppendingString:str];
}
- (NSString *)Finance_Prediction {
    
    NSString *str = _Finance_Prediction.length ? _Finance_Prediction : @"--";
    return [@"预测  " stringByAppendingString:str];
}
- (NSString *)Finance_Result {
    
    NSString *str = _Finance_Result.length ? _Finance_Result : @"--";
    return [@"公布  " stringByAppendingString:str];
}

- (NSString *)starPicName {
    
    if ([_Finance_Importance isEqualToString:@"高"]) {
        return @"importance_3";
    } else if ([_Finance_Importance isEqualToString:@"中"]) {
        return @"importance_2";
    }
    return @"importance_1";
}

MJExtensionLogAllProperties
@end
