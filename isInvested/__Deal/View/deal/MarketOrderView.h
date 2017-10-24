//
//  MarketOrderView.h
//  isInvested
//
//  Created by Ben on 16/8/31.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightChooseView.h"
//市价下单的公用view
@interface MarketOrderView : UIView
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) void(^allowHelpBlock)();//允许价差帮助
@property (nonatomic, strong) UILabel *priceValueLbl;
@property (nonatomic, strong) NSString *NewPrice;
@property (nonatomic, strong) UIButton *allowBtn;//允许价差的按钮
@property (nonatomic, strong) UITextField *allowTF;//允许价差
@property (nonatomic, strong) UILabel *canBuyTitleLbl;//可买重量
@property (nonatomic, strong) UILabel *reserveLbl;//准备金
@property (nonatomic, strong) UILabel *counterFeeLbl;//手续费

- (instancetype)initWithMarketOrderType:(BuyOrderType) type WeightViewHeight:(CGFloat)weightViewHeight;

@end
