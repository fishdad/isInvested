//
//  VarietyDetailTitleView.m
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "VarietyDetailTitleView.h"

@implementation VarietyDetailTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = OXColor(0xffffff);
        [self addSubview:[Util setUpLineWithFrame:CGRectMake(0, 0,WIDTH, 0.5)]];
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height;
        CGFloat wSpace = 10;
        CGFloat hSpace2 = 10;
        CGFloat typeW = 25;
        CGFloat typeH = 15;
        CGFloat w2 = 70;
        CGFloat h2 = 22;
        
        _typeLbl = [[UILabel alloc] initWithFrame:CGRectMake(wSpace, (h - typeH) / 2.0, typeW, typeH)];
        _typeLbl.textAlignment = NSTextAlignmentCenter;
        _typeLbl.font = FONT(10);
        _typeLbl.textColor = [UIColor whiteColor];
        _typeLbl.layer.masksToBounds = YES;
        _typeLbl.layer.cornerRadius = 3;
        [self addSubview:_typeLbl];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(NW(_typeLbl) + 5, hSpace2, w2 + 30, h - 2 * hSpace2)];
        _titleLbl.font = FONT(15);
        [self addSubview:_titleLbl];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w - wSpace - w2, (h - h2) * 0.5, w2, h2);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = FONT(13);
        [btn setTitleColor:OrangeBackColor forState:UIControlStateNormal];
        btn.layer.borderColor = [OrangeBackColor CGColor];
        btn.layer.borderWidth = 0.5;
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _actionBtn = btn;
        [self addSubview:_actionBtn];
    
    }
    return self;
}

-(void)setType:(BuyOrderType)type{

    if (type == BuyOrderTypeUp) {
        _typeLbl.backgroundColor = RedBackColor;
        _typeLbl.text = @"买涨";
        [_actionBtn setTitle:@"平仓卖出" forState:UIControlStateNormal];
    }else if(type == BuyOrderTypeDown){
        _typeLbl.backgroundColor = GreenBackColor;
        _typeLbl.text = @"买跌";
        [_actionBtn setTitle:@"平仓买入" forState:UIControlStateNormal];
    }else if(type == BuyOrderTypeLevel){
        _typeLbl.backgroundColor = OrangeBackColor;
        _typeLbl.text = @"平仓";
    }
}

-(void)setModel:(HoldPositionTotalInfoModel *)model{

    if (![model isKindOfClass:[HoldPositionTotalInfoModel class]]) {
        return;
    }
    _model = model;
    //标题头
    self.type = model.OpenDirector - 1;//(1,2)对应我们的买涨买跌(0,1)
    self.titleLbl.text = model.CommodityName;

}

-(void)btnClick:(UIButton *)btn{
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
