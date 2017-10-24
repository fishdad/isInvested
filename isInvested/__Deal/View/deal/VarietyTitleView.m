//
//  VarietyTitleView.m
//  isInvested
//
//  Created by Ben on 16/9/6.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "VarietyTitleView.h"
#import "UILabel+TextWidhtHeight.h"

@implementation VarietyTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpSubViews];
    }
    return self;
}

-(void)setUpSubViews{

    CGFloat spacing = 10;
//    CGFloat btnW = 40;//行情显示图的宽高
    CGFloat btnH = 30;
    CGFloat selfH = self.frame.size.height;
    CGFloat moreBtnW = 25;
    CGFloat moreBtnH = 25;
    CGFloat titleBtnW = [UILabel getWidthWithTitle:@"粤贵银(kg)GDAG" font:FONT(17)];
    
//    //行情显示图
//    _varietyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _varietyBtn.frame = CGRectMake(spacing, (selfH - btnH) / 2.0, btnW, btnH);
//    [_varietyBtn setImage:[Util OriginImage:[UIImage imageNamed:@"deal_variety"] scaleToSize:CGSizeMake(btnW / 1.5, btnH / 1.5)] forState:UIControlStateNormal];
//    [self addSubview:_varietyBtn];
    
    _varietyBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _varietyBtn1.frame = CGRectMake(WIDTH - 150, (selfH - btnH) / 2.0, 150, btnH);
    [self addSubview:_varietyBtn1];
    
    //品种
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.frame = CGRectMake(spacing, (selfH - btnH) / 2.0, titleBtnW, btnH);
    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_titleBtn setTitleColor:OXColor(0x333333) forState:UIControlStateNormal];
    _titleBtn.titleLabel.font = FONT(17);
    [self addSubview:_titleBtn];
    
    //更多
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(_titleBtn.right + 5, _titleBtn.y + 3, moreBtnW, moreBtnH);
    UIImage *img = [UIImage imageNamed:@"deal_varietyMore"];
//    [_moreBtn setImage:[Util OriginImage:img scaleToSize:CGSizeMake(img.size.width / 2.0, img.size.height / 2.0)] forState:UIControlStateNormal];
     [_moreBtn setImage:img forState:UIControlStateNormal];

    [self addSubview:_moreBtn];
    
    //涨跌幅
    CGFloat ZFLblW = [UILabel getWidthWithTitle:@"涨跌幅" font:FONT(10)];
    _ZFLbl = [[UILabel alloc] init];
    _ZFLbl.frame = CGRectMake(WIDTH - spacing - ZFLblW, _titleBtn.y, ZFLblW, btnH);
//    _ZFLbl.textAlignment = NSTextAlignmentRight;
    _ZFLbl.font = FONT(10);
    [self addSubview:_ZFLbl];

    //最新价
    CGFloat NewPriceLblW = [UILabel getWidthWithTitle:@"3743.00" font:FONT(13)];
    _NewPriceLbl = [[UILabel alloc] init];
    _NewPriceLbl.frame = CGRectMake(WIDTH - spacing - ZFLblW - spacing - NewPriceLblW, _titleBtn.y, NewPriceLblW, btnH);
    _NewPriceLbl.textAlignment = NSTextAlignmentRight;
    _NewPriceLbl.font = FONT(13);
    [self addSubview:_NewPriceLbl];
    
    [self addSubview:[Util setUpLineWithFrame:CGRectMake(0, selfH - 0.5, WIDTH, 0.5)]];
}

-(void)setNewPriceValue:(NSString *)NewPriceValue Fluctuation_percent:(CGFloat) fluctuation_percent{

    UIColor *color;
    if (fluctuation_percent > 0) {
        color = RedBackColor;
    }else if (fluctuation_percent < 0){
        color = GreenBackColor;
    }else{
        color = LightGrayBackColor;
    }
    _ZFLbl.textColor = color;
    _NewPriceLbl.textColor = color;
    CGFloat btnH = 30;
    CGFloat spacing = 10;
    NSString * ZFStr = [NSString stringWithFormat:@"%.2f%%",fluctuation_percent];
    _ZFLbl.text = ZFStr;
    CGFloat ZFLblW = [UILabel getWidthWithTitle:ZFStr font:FONT(10)];
    _NewPriceLbl.text = NewPriceValue;
    CGFloat NewPriceLblW = [UILabel getWidthWithTitle:_NewPriceLbl.text font:FONT(13)];
    
    _ZFLbl.frame = CGRectMake(WIDTH - spacing - ZFLblW, _titleBtn.y, ZFLblW, btnH);
    _NewPriceLbl.frame = CGRectMake(WIDTH - spacing - ZFLblW - spacing - NewPriceLblW, _NewPriceLbl.y, NewPriceLblW, btnH);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
