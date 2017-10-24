//
//  ChooseTimeView.h
//  isInvested
//
//  Created by Ben on 16/9/20.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTimeView : UIView

@property (nonatomic, strong) UILabel *lbl;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) int outOfDays;//最大向前查询的天数
//选择的开始日期,结束日期(UTC描述)
@property (nonatomic, copy) void (^btnBlock)(long long beginDate,long long endDate);
@end
