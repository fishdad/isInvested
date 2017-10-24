//
//  VarietyDetailView.m
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "VarietyDetailView.h"

@implementation VarietyDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = OXColor(0xffffff);
        CGFloat w = frame.size.width / 3.0;
        CGFloat h = frame.size.height / 2.0;
        
        _breakView = [[TwoVLblView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _weightView = [[TwoVLblView alloc] initWithFrame:CGRectMake(NW(_breakView), 0, w, h)];
        _avgView = [[TwoVLblView alloc] initWithFrame:CGRectMake(NW(_weightView), 0, w, h)];
        
        _breakPresentView = [[TwoVLblView alloc] initWithFrame:CGRectMake(0, NH(_breakView), w, h)];
        _ExitPriceView = [[TwoVLblView alloc] initWithFrame:CGRectMake(NW(_breakPresentView), NH(_breakView), w, h)];
        _breakEvenPriceView = [[TwoVLblView alloc] initWithFrame:CGRectMake(NW(_ExitPriceView), NH(_breakView), w, h)];
        
        [self addSubview:_breakView];
        [self addSubview:_weightView];
        [self addSubview:_avgView];
        [self addSubview:_breakPresentView];
        [self addSubview:_ExitPriceView];
        [self addSubview:_breakEvenPriceView];
        
        _breakView.TitleLbl.text = @"盈亏(元)";
        _weightView.TitleLbl.text = @"总重量(KG)";
        _avgView.TitleLbl.text = @"持仓均价(元)";
        _breakPresentView.TitleLbl.text = @"盈亏比(%)";
        _ExitPriceView.TitleLbl.text = @"平仓价(元)";
        _breakEvenPriceView.TitleLbl.text = @"保本价(元)";
        
        [self setUpLines];
    }
    return self;
}

-(void)setUpLines{

    [self addSubview:[Util setUpLineWithFrame:CGRectMake(10, 0,WIDTH - 20, 0.5)]];
    [self addSubview:[Util setUpLineWithFrame:CGRectMake(10, self.frame.size.height / 2.0,WIDTH - 20, 0.5)]];
    [self addSubview:[Util setUpLineWithFrame:CGRectMake(0, self.frame.size.height - 0.5,WIDTH, 0.5)]];
    
    CGFloat w = self.frame.size.width / 3.0;
    CGFloat h = self.frame.size.height / 2.0;
    CGFloat lineH = h - 30;
    CGFloat hSpace = (h - lineH) / 2.0;
    
    [self addSubview:[Util setUpLineWithFrame:CGRectMake(w, hSpace, 0.5, lineH)]];
    [self addSubview:[Util setUpLineWithFrame:CGRectMake(w * 2, hSpace, 0.5, lineH)]];
    [self addSubview:[Util setUpLineWithFrame:CGRectMake(w, hSpace + h, 0.5, lineH)]];
    [self addSubview:[Util setUpLineWithFrame:CGRectMake(w * 2, hSpace + h, 0.5, lineH)]];

}

-(NSString *)priceDigitWithString:(NSString *) string{

    NSString *resultStr = [NSString stringWithFormat:@"%.2f",[string floatValue]];
    return resultStr;
}
-(void)setModel:(HoldPositionTotalInfoModel *)model{

    if (![model isKindOfClass:[HoldPositionTotalInfoModel class]]) {
        return;
    }
    _model = model;
    //详细信息
    self.breakView.value = [self priceDigitWithString:model.OpenProfit];//盈亏
    self.weightView.ValueLbl.text = [NSString stringWithFormat:[Util getWeightDigitByComID:model.CommodityID],[model.TotalWeight doubleValue]];//重量
    self.avgView.ValueLbl.text = [self priceDigitWithString:model.AvgHoldPrice];//持仓均价
    //盈亏比
    //盈亏比=浮动盈亏÷持仓总值×100%
    double dbreakPresen = (model.OpenProfit.doubleValue / model.HoldPriceTotal.doubleValue * 100);
    NSString *breakPresen;
    
    if (dbreakPresen > 0) {
        if (dbreakPresen < 0.01) {
            breakPresen = [NSString stringWithFormat:@"%.4f%%",(dbreakPresen)];
        }else{
            breakPresen = [NSString stringWithFormat:@"%.2f%%",(dbreakPresen)];
        }
    }else{
        if (dbreakPresen > - 0.01) {
            breakPresen = [NSString stringWithFormat:@"%.4f%%",(dbreakPresen)];
        }else{
            breakPresen = [NSString stringWithFormat:@"%.2f%%",(dbreakPresen)];
        }
    }
    
    self.breakPresentView.value = breakPresen;//盈亏比
    self.ExitPriceView.ValueLbl.text = [self priceDigitWithString:model.ClosePrice];//平仓价
    
    //保本价
    //（1）买涨持仓   最新:=建仓价(1+手续费率)÷(1-手续费率)
    //（2）买跌持仓   最新:=建仓价(1-手续费率)÷(1+手续费率)
    double breakEvenPrice = 0.0;
    if (model.OpenDirector == OPENDIRECTOR_BUY) {
        breakEvenPrice = [model.AvgOpenPrice doubleValue] * (1 + HandlingRate) / (1 - HandlingRate);
    }else if(model.OpenDirector == OPENDIRECTOR_SELL){
        breakEvenPrice = [model.AvgOpenPrice doubleValue] * (1 - HandlingRate) / (1 + HandlingRate);
    }
    self.breakEvenPriceView.ValueLbl.text = [NSString stringWithFormat:@"%.2f",breakEvenPrice];

}

@end
