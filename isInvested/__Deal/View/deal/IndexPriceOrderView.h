//
//  IndexPriceOrderView.h
//  isInvested
//
//  Created by Ben on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightChooseView.h"
#import "StopPriceView.h"

@interface IndexPriceOrderView : UIView

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) void(^rangeHelpBlock)();
@property (nonatomic, strong) StopPriceView *stopPrice;
@property (nonatomic, strong) NSString *upStr;//止盈价格差
@property (nonatomic, strong) NSString *downStr;//止损价格差
@property (nonatomic, strong) NSString *FixedSpread;//固定点差
@property (nonatomic, assign)NSInteger precision;
@property (nonatomic, strong) XBStepper *priceValueStepper;//指价的价格
@property (nonatomic, copy) void (^priceValueStepperTextDidEndEditingBlock)(NSString *text);//价格的值变化
@property (nonatomic, strong) UILabel *canBuyTitleLbl;

- (instancetype)initWithMarketOrderType:(BuyOrderType) type WeightViewHeight:(CGFloat)weightViewHeight;

//(此处需要确定计算价格范围 和 止盈止损的价格取值是否一致)
//设置止盈止损的点差
-(void)setUpValue:(NSString *)upValue DownValue:(NSString *)downValue FixedSpread:(NSString *)FixedSpread;
//指定价格的范围
-(void)setRangeValue:(NSString *)rangeValue UpValue:(NSString *)upValue DownValue:(NSString *)downValue FixedSpread:(NSString *)FixedSpread;

@end
