//
//  HoldTableHeadView.m
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "HoldTableHeadView.h"

@implementation HoldTableHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat hSpace = 10;
        CGFloat w = frame.size.width;
//        CGFloat h = frame.size.height / 2.0 / 5.0;
        CGFloat titleH = 30;
        CGFloat moneyH = 60;
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.frame = CGRectMake(0, hSpace - 5, WIDTH , titleH);
        _titleLbl.text = @"净资产";
        _titleLbl.textColor = OXColor(0x999999);
        _titleLbl.font = FONT(13);
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLbl];
        
        _moneyLbl = [[UILabel alloc] init];
        _moneyLbl.frame = CGRectMake(0, NH(_titleLbl) - 20 , WIDTH , moneyH);
        _moneyLbl.font = BOLD_FONT(32);
        _moneyLbl.textColor = RedBackColor;
        _moneyLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_moneyLbl];
        
        CGFloat vH = 50;
        _breakView = [[TwoVLblView alloc] initWithFrame:CGRectMake(0, NH(_moneyLbl) - 10, w / 2.0, vH)];
        _breakView.TitleLbl.text = @"持仓盈亏(元)";
        _breakView.ValueLbl.font = FONT(13);
        [self addSubview:_breakView];
        
        _canUseMoneyView = [[TwoVLblView alloc] initWithFrame:CGRectMake(NW(_breakView), NH(_moneyLbl) - 10, w / 2.0, vH)];
        _canUseMoneyView.TitleLbl.text = @"可用资金(元)";
        _canUseMoneyView.ValueLbl.font = FONT(13);
        [self addSubview:_canUseMoneyView];
        
        CGFloat lineH = vH - 7 * 2 - 10;
        [self addSubview:[Util setUpLineWithFrame:CGRectMake(NW(_breakView) - 0.5, NH(_moneyLbl), 1, lineH)]];
        
        _realHeight = NH(_canUseMoneyView);
        
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.touchBlock) {
        self.touchBlock();
    }
}
//赋值刷新
-(void)reloadViewByAccountInfoModel:(AccountInfoModel*)model{
    
    _moneyLbl.text = [NSString stringWithFormat:@"¥ %@",model.NAVPrice];//净值
    _breakView.ValueLbl.text = model.OpenProfit;//盈亏
    _canUseMoneyView.ValueLbl.text = model.ExchangeReserve;//可用金(交易准备金)
}

@end
