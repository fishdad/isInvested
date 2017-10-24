//
//  HoldTableHeadView.h
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoVLblView.h"

@interface HoldTableHeadView : UIView

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *moneyLbl;
@property (nonatomic, strong) TwoVLblView *breakView;
@property (nonatomic, strong) TwoVLblView *canUseMoneyView;
@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, copy) void (^touchBlock)();
//赋值刷新
-(void)reloadViewByAccountInfoModel:(AccountInfoModel*)model;

@end
