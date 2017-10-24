//
//  VarietyDetailView.h
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoVLblView.h"

@interface VarietyDetailView : UIView

@property (nonatomic, strong) TwoVLblView *breakView;//盈亏
@property (nonatomic, strong) TwoVLblView *weightView;//重量
@property (nonatomic, strong) TwoVLblView *avgView;//持仓均价
@property (nonatomic, strong) TwoVLblView *breakPresentView;//盈亏比
@property (nonatomic, strong) TwoVLblView *ExitPriceView;//平仓价
@property (nonatomic, strong) TwoVLblView *breakEvenPriceView;//保本价
@property (nonatomic, strong) HoldPositionTotalInfoModel *model;

@end
