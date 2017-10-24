//
//  PositionCell.m
//  isInvested
//
//  Created by Blue on 16/9/2.
//  Copyright © 2016年 Blue. All rights reserved.
//  持仓明细 & 平仓记录 cell

#import "PositionCell.h"

@interface PositionCell ()

/** 买涨or买跌 */
@property (weak, nonatomic) IBOutlet UILabel *buyUpOrDownL;
/** 品种名 */
@property (weak, nonatomic) IBOutlet UILabel *commoditynameL;

/** 盈亏Label */
@property (weak, nonatomic) IBOutlet UILabel *floatingprofitandlossL;
/** 总重量Label */
@property (weak, nonatomic) IBOutlet UILabel *totalWeightL;
/** 持仓价Label */
@property (weak, nonatomic) IBOutlet UILabel *holdpriceL;
/** 盈亏比Label */
@property (weak, nonatomic) IBOutlet UILabel *floatingprofitandlossPerL;
/** 平仓价Label */
@property (weak, nonatomic) IBOutlet UILabel *closePriceL;
/** 保本价Label */
@property (weak, nonatomic) IBOutlet UILabel *breakevenPriceL;

@property (weak, nonatomic) IBOutlet UILabel *opendateL;///< 开仓的时间
@property (weak, nonatomic) IBOutlet UIButton *tpButton; //止盈止损
@property (weak, nonatomic) IBOutlet UIButton *closeButton; //平仓卖出

/* 撤单view */
@property (weak, nonatomic) IBOutlet UIView *cancelOrderV;
/** 撤单view高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelOrder_height;
@property (weak, nonatomic) IBOutlet UILabel *cancel_tppriceL; ///< 撤单栏,止盈价Label
@property (weak, nonatomic) IBOutlet UILabel *cancel_slpriceL; ///< 撤单栏,止损价Label
@property (weak, nonatomic) IBOutlet UIButton *cancel_tppriceB; ///< 撤单栏,止盈价Btn
@property (weak, nonatomic) IBOutlet UIButton *cancel_slpriceB; ///< 撤单栏,止损价Btn
@end

@implementation PositionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setModel:(HoldPositionInfoModel *)model {
    [super setModel:model];
    
    self.tpButton.hidden = NO;
    self.closeButton.hidden = NO;
    [self.closeButton setTitle:model.OpenDirector == 1 ? @"平仓卖出" : @"平仓买入" forState:UIControlStateNormal];
    
    if (model.TPPrice || model.SLPrice) {
        self.cancelOrderV.hidden = NO;
        self.cancelOrder_height.constant = 30;
        
        NSString *tPPriceStr = [NSString stringWithFormat:@"%.2f", model.TPPrice];
        NSString *sLPriceStr = [NSString stringWithFormat:@"%.2f", model.SLPrice];
        tPPriceStr = [tPPriceStr isEqualToString:@"0.00"] ? @"--" : tPPriceStr;
        sLPriceStr = [sLPriceStr isEqualToString:@"0.00"] ? @"--" : sLPriceStr;
        self.cancel_tppriceL.text = [@"止盈价: " stringByAppendingString:tPPriceStr];
        self.cancel_slpriceL.text = [@"止损价: " stringByAppendingString:sLPriceStr];
        
        self.cancel_tppriceB.hidden = !model.TPPrice;
        self.cancel_slpriceB.hidden = !model.SLPrice;
    } else {
        self.cancelOrderV.hidden = YES;
        self.cancelOrder_height.constant = 0;
    }
    
    self.buyUpOrDownL.backgroundColor = model.OpenDirector == 1 ? OXColor(kRed) : OXColor(kGreen);
    self.buyUpOrDownL.text = model.OpenDirector == 1 ? @"买涨" : @"买跌";
    self.commoditynameL.text = model.CommodityName;
    self.opendateL.text = [NSString stringWithFormat:@"    开仓时间: %@", model.seconds];
    
    self.floatingprofitandlossL.text = [NSString stringWithFormat:@"%.2f", model.OpenProfit]; //盈亏
    self.totalWeightL.text = [NSString stringWithFormat:@"%.3f", model.TotalWeight]; //总重量
    self.holdpriceL.text = [NSString stringWithFormat:@"%.2f", model.HoldPositionPrice]; //持仓价
    self.floatingprofitandlossPerL.text = model.settlementplPer; //盈亏比
    self.closePriceL.text = [NSString stringWithFormat:@"%.2f", model.ClosePrice]; //平仓价
    self.breakevenPriceL.text = [NSString stringWithFormat:@"%.2f", model.breakevenPrice]; //保本价
    [self setTextColorWithPrice:model.OpenProfit];
}

- (void)setCloseModel:(ClosePositionInfoModel *)closeModel {
    _closeModel = closeModel;
    
    self.tpButton.hidden = YES;
    self.closeButton.hidden = YES;
    self.cancelOrderV.hidden = YES;
    self.cancelOrder_height.constant = 0;
    
    self.buyUpOrDownL.backgroundColor = closeModel.CloseDirector == 1 ? OXColor(kRed) : OXColor(kGreen);
    self.buyUpOrDownL.text = closeModel.CloseDirector == 1 ? @"买涨" : @"买跌";
    self.commoditynameL.text = closeModel.CommodityName;
    self.opendateL.text = closeModel.openCloseDate;
    
    self.floatingprofitandlossL.text = [NSString stringWithFormat:@"%.2f", closeModel.openProfit]; //盈亏
    self.totalWeightL.text = [NSString stringWithFormat:@"%.3f", closeModel.TotalWeight]; //总重量
    self.holdpriceL.text = [NSString stringWithFormat:@"%.2f", closeModel.HoldPrice]; //持仓价
    self.floatingprofitandlossPerL.text = [NSString stringWithFormat:@"%.2f%%", closeModel.openProfitPer]; //盈亏比
    self.closePriceL.text = [NSString stringWithFormat:@"%.2f", closeModel.ClosePrice]; //平仓价
    self.breakevenPriceL.text = [NSString stringWithFormat:@"%.2f", closeModel.OpenPrice]; //保本价
    [self setTextColorWithPrice:closeModel.openProfit];
}

/** 设置盈亏&盈亏比的颜色 */
- (void)setTextColorWithPrice:(CGFloat)price {    
    if (price >= 0) {
        self.floatingprofitandlossL.textColor = OXColor(kRed);
        self.floatingprofitandlossPerL.textColor = OXColor(kRed);
    } else {
        self.floatingprofitandlossL.textColor = OXColor(kGreen);
        self.floatingprofitandlossPerL.textColor = OXColor(kGreen);
    }
}

#pragma mark - 点击事件

/** 止盈止损 */
- (IBAction)clickedStopLossB {
    if (self.stopLossBlock) {
        self.stopLossBlock();
    }
}
/** 平仓卖出 */
- (IBAction)clickedExitB {
    if (self.exitBlock) {
        self.exitBlock();
    }
}
/** 弹出撤单提醒框 */
- (IBAction)clickedCancelOrder:(UIButton *)sender {
    if (self.cancelOrderBlock) {
        self.cancelOrderBlock(sender.tag);
    }
}

@end
