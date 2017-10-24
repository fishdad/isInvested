//
//  VarietyDetailTitleView.h
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VarietyDetailTitleView : UIView

@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, assign) BuyOrderType type;
@property (nonatomic, copy) void (^actionBlock)();
@property (nonatomic, strong) HoldPositionTotalInfoModel *model;

@end
