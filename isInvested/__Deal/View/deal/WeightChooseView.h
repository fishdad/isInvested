//
//  WeightChooseView.h
//  isInvested
//
//  Created by Ben on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBStepper/XBStepper.h"

@interface WeightChooseView : UIView

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UILabel *weightTitleLbl;//买入重量标题
@property (nonatomic, strong) UILabel *unitValueLbl;
@property (nonatomic, strong) XBStepper *weightStepper;
@property (nonatomic, strong) UILabel *canBuyTitleLbl;//可买重量
@property (nonatomic, copy) void(^unitBlock)();//单位下拉帮助
@property (nonatomic, copy) void(^unitDismissBlock)();//单位下拉消失帮助
@property (nonatomic, copy) void(^easeChooseBlock)(NSInteger index);//单位快速选择
@property (nonatomic, copy) void(^weightChangeBlock)();//重量变化

- (instancetype)initWithMarketOrderType:(BuyOrderType) type;
-(void)unitBtnClick:(UIButton *)btn;

@end
