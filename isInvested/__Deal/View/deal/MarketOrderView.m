//
//  MarketOrderView.m
//  isInvested
//
//  Created by Ben on 16/8/31.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MarketOrderView.h"
#import "XBStepper/XBStepper.h"
#import "UILabel+TextWidhtHeight.h"

@interface MarketOrderView ()

@property (nonatomic, strong) UILabel *priceTitleLbl;
@property (nonatomic, assign) BuyOrderType type;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat weightViewHeight;

@end

@implementation MarketOrderView

- (instancetype)initWithMarketOrderType:(BuyOrderType) type WeightViewHeight:(CGFloat)weightViewHeight
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _type = type;
        _weightViewHeight = weightViewHeight;
        if (type == BuyOrderTypeUp) {
            _color = RedBackColor;
        }else if (type == BuyOrderTypeDown){
            
            _color = GreenBackColor;
            
        }
        
        [self setUpView];
    }
    return self;
}

-(void)setUpView{

    CGFloat spacing = 10;
    CGFloat titleLblW = [UILabel getWidthWithTitle:@"四个汉字" font:FONT(15)];
    CGFloat titleLblH = 30;
    
    //买入价格
    _priceTitleLbl = [[UILabel alloc] init];
    _priceTitleLbl.frame = CGRectMake(spacing, 5, titleLblW, titleLblH);
    _priceTitleLbl.text = @"买入价格";
    _priceTitleLbl.font = FONT(15);
    [self addSubview:_priceTitleLbl];
    
    //实际的价格值
    _priceValueLbl = [[UILabel alloc] init];
    _priceValueLbl.frame = CGRectMake(NW(_priceTitleLbl) + 10, _priceTitleLbl.y, 250, titleLblH);
    _priceValueLbl.font = FONT(15);
//    _priceValueLbl.text = @"3564.25";
    [self addSubview:_priceValueLbl];
    
//    //可买入数量
//    _canBuyTitleLbl = [[UILabel alloc] init];
//    _canBuyTitleLbl.frame = CGRectMake(NW(_priceValueLbl), _priceTitleLbl.y, (WIDTH - NW(_priceValueLbl)), titleLblH);
//    _canBuyTitleLbl.text = @" 可买00000.00kg";
//    _canBuyTitleLbl.font = FONT(13);
//    _canBuyTitleLbl.textColor = [UIColor lightGrayColor];
//    [self addSubview:_canBuyTitleLbl];
    
    CGFloat NHWeightView = NH(_priceTitleLbl) + 10 + _weightViewHeight;
    CGFloat btnSpacing = 2 * spacing + titleLblW;
     CGFloat btnW = 30;
    //允许差价btn
    _allowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allowBtn.frame = CGRectMake(btnSpacing, NHWeightView , 30, 30);
    [_allowBtn addTarget:self action:@selector(allowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_allowBtn setImage:[Util OriginImage:[UIImage imageNamed:@"deal_allowChoose"] scaleToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [self addSubview:_allowBtn];
    
    //允许差价
    UILabel *allowTitleLbl = [[UILabel alloc] init];
    allowTitleLbl.frame = CGRectMake(NW(_allowBtn) + 10, NHWeightView, 60, titleLblH);
    allowTitleLbl.font = FONT(13);
    allowTitleLbl.text = @"允许差价";
    allowTitleLbl.textColor = [UIColor lightGrayColor];
    [self addSubview:allowTitleLbl];
    
    //允许差价的值
    _allowTF = [[UITextField alloc] initWithFrame:CGRectMake(NW(allowTitleLbl), NHWeightView + 5, titleLblW, 20)];
    //_allowTF.text = @"50";
    _allowTF.keyboardType = UIKeyboardTypeDecimalPad;
    _allowTF.layer.borderColor = [OXColor(0xd4d4d4) CGColor];
    _allowTF.layer.borderWidth = 0.5;
    _allowTF.layer.masksToBounds = YES;
    _allowTF.font = FONT(13);
    _allowTF.layer.cornerRadius = 3;
    _allowTF.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_allowTF];
    
    //帮助按钮
    UIButton *helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    helpBtn.frame = CGRectMake(NW(_allowTF) + 5 , _allowTF.y - 5, btnW, btnW);
    helpBtn.tag = 104;
    [helpBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [helpBtn setImage:[Util OriginImage:[UIImage imageNamed:@"deal_help"] scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
    [self addSubview:helpBtn];

 
    [self addSubview:[Util setUpLineWithFrame:CGRectMake(btnSpacing,  NH(_allowBtn) + 10, WIDTH - btnSpacing, 0.5)]];
    
    //准备金
    CGFloat lblW = WIDTH - btnSpacing - 10;
    _reserveLbl = [[UILabel alloc] init];
    _reserveLbl.frame = CGRectMake(btnSpacing, NH(_allowBtn) + 10, lblW, titleLblH);
//    _reserveLbl.text = @"履约准备金:286.80";
    _reserveLbl.font = FONT(13);
    _reserveLbl.textColor = [UIColor lightGrayColor];
    [self addSubview:_reserveLbl];
    
    //手续费
    _counterFeeLbl = [[UILabel alloc] init];
    _counterFeeLbl.frame = CGRectMake(btnSpacing, NH(_reserveLbl), lblW, titleLblH);
//    _counterFeeLbl.text = @"成交后手续费:2.80";
    _counterFeeLbl.font = FONT(13);
    _counterFeeLbl.textColor = [UIColor lightGrayColor];
    [self addSubview:_counterFeeLbl];
    
    //传出高度
    self.height = NH(_counterFeeLbl) + 5;
}

-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 100) {
    }
    
    if (btn.tag == 104) {
        //帮助
        if (self.allowHelpBlock) {
            self.allowHelpBlock();
        }
    }


}

-(void)allowBtnClick:(UIButton *)btn{

    btn.selected = !btn.selected;
    
    if (!btn.selected) {
        //允许价差
        [btn setImage:[Util OriginImage:[UIImage imageNamed:@"deal_allowChoose"] scaleToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        _allowTF.userInteractionEnabled = YES;
        _allowTF.textColor = [UIColor blackColor];
    }else{
        //不允许价差
        [btn setImage:[Util OriginImage:[UIImage imageNamed:@"deal_allowNoChoose"] scaleToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        _allowTF.textColor = OXColor(0x999999);
        _allowTF.userInteractionEnabled = NO;
    }

    
}

-(void)unitBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
//    if (btn.selected) {
//        [btn setTitleColor:_color forState:UIControlStateNormal];
//    }else{
//    
//        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    }
    
    for (int i = 1; i < 4; i ++) {
        
        UIButton *button = [self viewWithTag:(100 + i)];
        
        if ((100 + i) == btn.tag) {
             [button setTitleColor:_color forState:UIControlStateNormal];
             button.layer.borderColor = [_color CGColor];
        }else{
             [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        }
    }
    
    if (btn.tag == 101) {
        //1/3
    }
    
    if (btn.tag == 102) {
        //1/2
    }
    
    if (btn.tag == 103) {
        //全部
    }

}

//最新价赋值
-(void)setNewPrice:(NSString *)NewPrice{
    _priceValueLbl.text = NewPrice;
    [self updatePriceLblFrame];
}
//重新计算frame
-(void)updatePriceLblFrame{
    
    CGFloat titleLblH = 30;
    //实际的价格值
    CGFloat priceTitleLblWidth = [UILabel getWidthWithTitle:_priceValueLbl.text font:_priceValueLbl.font];
    _priceValueLbl.frame = CGRectMake(NW(_priceTitleLbl) + 10, _priceTitleLbl.y, priceTitleLblWidth, titleLblH);
//    //可买入数量
//    _canBuyTitleLbl.frame = CGRectMake(NW(_priceValueLbl) + 10, _priceTitleLbl.y, (WIDTH - NW(_priceValueLbl)), titleLblH);
}

@end
