//
//  StopPriceView.m
//  isInvested
//
//  Created by Ben on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "StopPriceView.h"


@implementation StopPriceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}


-(void)setUpView{
    
    _stopUp = [[PriceChooseView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, 30)];
    _stopUp.leftLbl.text = @"止盈价";
    _stopUp.leftLbl.font = FONT(12);
    [self addSubview:_stopUp];
    
    _stopDown = [[PriceChooseView alloc] initWithFrame:CGRectMake(0, _stopUp.bottom + 10, WIDTH, 30)];
    _stopDown.leftLbl.text = @"止损价";
    _stopDown.leftLbl.font = FONT(12);
    [self addSubview:_stopDown];
    
    self.backgroundColor = OXColor(0xf5f5f5);
    self.height = NH(_stopDown) + 10;
}

-(void)setPrcision:(NSInteger)prcision{

    _prcision = prcision;
    _stopUp.precision = prcision;
    _stopDown.precision = prcision;
}


//实时修改止盈,止损的参考值
-(void)setStopValue:(NSString *) value OrderType:(BuyOrderType) type UpValue:(NSString *)upValue DownValue:(NSString *)downValue FixedSpread:(NSString *)FixedSpread{
    
    if (value == nil || [value isEqualToString:@""]) {
        value = @"0";
    }
    NSString *stopUpValue;
    NSString *stopDownValue;
    
    //    	买入时：
    //    止盈价>=  限价建仓价格 + 止盈价点差
    //    止损价<=  限价建仓价格 - 止损价点差 - 固定点差
    //    	卖出时：
    //    止盈价<=  限价建仓价格 - 止盈价点差
    //    止损价>=  限价建仓价格 + 止损价点差 + 固定点差
    NSString *upStr = @" ≥%%.%lif";
    NSString *downStr = @" ≤%%.%lif";
    NSString *priceUpDigit = [NSString stringWithFormat:upStr,_prcision];
    NSString *priceDownDigit = [NSString stringWithFormat:downStr,_prcision];
   
    if (type == BuyOrderTypeUp) {
        stopUpValue = [NSString stringWithFormat:priceUpDigit,(value.floatValue + upValue.floatValue)];
        stopDownValue = [NSString stringWithFormat:priceDownDigit,(value.floatValue - downValue.floatValue - FixedSpread.floatValue)];
    }else if (type == BuyOrderTypeDown){
        stopUpValue = [NSString stringWithFormat:priceDownDigit,(value.floatValue - upValue.floatValue)];
        stopDownValue = [NSString stringWithFormat:priceUpDigit,(value.floatValue + downValue.floatValue + FixedSpread.floatValue)];
    }
    _stopUp.rightLbl.text = stopUpValue;
    _stopUp.stepper.txtCount.text = @"";
    _stopUp.stepper.txtCount.placeholder = stopUpValue;
    
    _stopDown.rightLbl.text = stopDownValue;
    _stopDown.stepper.txtCount.text = @"";
    _stopDown.stepper.txtCount.placeholder = stopDownValue;
}


@end
