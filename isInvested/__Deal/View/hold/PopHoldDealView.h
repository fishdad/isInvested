//
//  PopHoldDealView.h
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VarietyDetailTitleView.h"
#import "VarietyDetailView.h"
#import "PriceDealView.h"
#import "WeightChooseView.h"

@interface PopHoldDealView : UIView

@property (nonatomic, strong) VarietyDetailTitleView *titleView;
@property (nonatomic, strong) VarietyDetailView *detailView;
@property (nonatomic, strong) PriceDealView *priceView;
@property (nonatomic, strong) WeightChooseView *weightView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, copy) void (^okBlock)();
@property (nonatomic, copy) void (^refushHoldToalBlock)();//刷新合并持仓
@property (nonatomic, strong) UIViewController *target;
@property (nonatomic, assign) BuyOrderType type;
@property (nonatomic, assign) HoldPositionTotalInfoModel *model;

@property (nonatomic, copy) void (^refushBlock)();//实时刷新

- (instancetype)initWithFrame:(CGRect)frame Model:(HoldPositionTotalInfoModel *)model;

@end
