//
//  DatePickChooseView.h
//  时间选择器
//
//  Created by Ben on 16/9/20.
//  Copyright © 2016年 xiaxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickChooseView : UIView

@property (nonatomic, strong) NSString *dataStr1;
@property (nonatomic, strong) NSString *dataStr2;
@property (nonatomic, strong) NSString *dataStr;
@property (nonatomic, copy) void (^dateBlock)(NSString *dateStr,NSString *dateStr1,NSString *dateStr2);
@property (nonatomic, strong) UIViewController *target;
@property (nonatomic, assign) int outOfDays;//最大向前查询的天数

@end
