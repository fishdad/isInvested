//
//  IndexPriceOrderView.m
//  isInvested
//
//  Created by Ben on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "IndexPriceOrderView.h"
#import "XBStepper.h"
#import "UILabel+TextWidhtHeight.h"

@interface IndexPriceOrderView ()

@property (nonatomic, assign) BuyOrderType type;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UILabel *RangeLbl;
@property (nonatomic, assign) CGFloat weightViewHeight;
@property (nonatomic, copy) void(^rangeLblBlock)();

@end



@implementation IndexPriceOrderView

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

-(void)setPrecision:(NSInteger)precision{

    _precision = precision;
    _stopPrice.prcision = precision;
    [_priceValueStepper setMaxValue:0 min:0 now:0 Precision:precision];
}

-(void)setUpView{
    
    CGFloat spacing = 10;
    CGFloat titleLblW = [UILabel getWidthWithTitle:@"四个汉字" font:FONT(15)];
    CGFloat titleLblH = 30;
    
    //买入价格
    UILabel *priceTitleLbl = [[UILabel alloc] init];
    priceTitleLbl.frame = CGRectMake(spacing, 5, titleLblW, titleLblH);
    priceTitleLbl.text = @"买入价格";
    priceTitleLbl.font = FONT(15);
    [self addSubview:priceTitleLbl];
    
//    //可买入数量
//    _canBuyTitleLbl = [[UILabel alloc] init];
//    _canBuyTitleLbl.font = FONT(13);
//    _canBuyTitleLbl.numberOfLines = 2;
//    _canBuyTitleLbl.text = @"可买\n00000.00kg";
//    _canBuyTitleLbl.textColor = [UIColor lightGrayColor];
//    [self addSubview:_canBuyTitleLbl];
    
    //实际的价格的值
    CGFloat stepperH = 34;
    if (WIDTH == 320) {
        stepperH = 30;
    }
    CGFloat stepperW = (WIDTH - 2 * spacing - priceTitleLbl.width - 55);
    _priceValueStepper = [[XBStepper alloc] initWithFrame:CGRectMake(NW(priceTitleLbl) + spacing, priceTitleLbl.y, stepperW, stepperH)];
   
    WEAK_SELF
    //设置止盈止损 和 可买重量
    _priceValueStepper.textDidEndEditingBlock = ^(NSString *text){
        [weakSelf.stopPrice setStopValue:text OrderType:weakSelf.type UpValue:weakSelf.upStr DownValue:weakSelf.downStr FixedSpread:
         weakSelf.FixedSpread];
        if (weakSelf.priceValueStepperTextDidEndEditingBlock) {
            weakSelf.priceValueStepperTextDidEndEditingBlock(text);
        }
    };
    [_priceValueStepper setBackgroundColor:[UIColor whiteColor] BorderColor:[UIColor lightGrayColor] BtnTextColor:OrangeBackColor];
    [self addSubview:_priceValueStepper];
//    _canBuyTitleLbl.frame = CGRectMake(NW(_priceValueStepper) + spacing, -5,titleLblW, 60);
    
    //范围价格
    CGFloat bigSpacing = NW(priceTitleLbl) + spacing;
    _RangeLbl = [[UILabel alloc] init];
    [self addSubview:_RangeLbl];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[Util OriginImage:[UIImage imageNamed:@"deal_help"] scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    CGFloat lblW = [UILabel getWidthWithTitle:@"" font:weakSelf.RangeLbl.font];
    weakSelf.RangeLbl.frame = CGRectMake(bigSpacing,NH(priceTitleLbl) + 5, lblW, titleLblH);
    btn.frame = CGRectMake(NW(_RangeLbl), weakSelf.RangeLbl.y, 30, 30);
    
    //后期实时变化
    self.rangeLblBlock = ^(NSString *text){
        if (WIDTH >= 414) {
            weakSelf.RangeLbl.font = FONT(13);
        }else{
            weakSelf.RangeLbl.font = FONT(12);
        }
        CGFloat lblW = [UILabel getWidthWithTitle:text font:weakSelf.RangeLbl.font];
        if (WIDTH == 320) {
            weakSelf.RangeLbl.frame = CGRectMake(10,NH(priceTitleLbl) + 5, lblW, titleLblH);
        }else{
            weakSelf.RangeLbl.frame = CGRectMake(bigSpacing,NH(priceTitleLbl) + 5, lblW, titleLblH);
        }
        btn.frame = CGRectMake(NW(_RangeLbl), weakSelf.RangeLbl.y, 30, 30);
    };
    //止盈止损
    _stopPrice = [[StopPriceView alloc] init];
    _stopPrice.frame = CGRectMake(0, NH(_RangeLbl), WIDTH, _stopPrice.height);
    [self addSubview:_stopPrice];
    
    //返回高度
    CGFloat NHWeightChoose = NH(_stopPrice) + _weightViewHeight + 10;
    self.height = NHWeightChoose;
    
}

//设置止盈止损的点差
-(void)setUpValue:(NSString *)upValue DownValue:(NSString *)downValue FixedSpread:(NSString *)FixedSpread{

    self.upStr = upValue;
    self.downStr = downValue;
    self.FixedSpread = FixedSpread;
}
//指定价格的范围
-(void)setRangeValue:(NSString *)rangeValue UpValue:(NSString *)upValue DownValue:(NSString *)downValue FixedSpread:(NSString *)FixedSpread{
    
    NSString *str = @"%%.%lif";
    NSString *priceDigit = [NSString stringWithFormat:str,_precision];
    
//    	限价建仓价格不能在（商品卖价 - 限价点差，商品买价 + 限价点差）之间；
    //>=(商品买价 + 限价点差)
    float rangeDownFloat = (rangeValue.floatValue) + (FixedSpread.floatValue) + (downValue.floatValue);
    NSString *rangeDownStr = [NSString stringWithFormat:priceDigit,rangeDownFloat];
    //<=(商品卖价 - 限价点差)
    float rangeUpFloat = (rangeValue.floatValue) - (upValue.floatValue);
    NSString *rangeUpStr = [NSString stringWithFormat:priceDigit,rangeUpFloat];
    
    UIColor *color;
    if (_type == BuyOrderTypeUp) {
        color = RedBackColor;
    }else{
        color = GreenBackColor;
    }

    _RangeLbl.attributedText = [Util setStringsArr:@[@"范围:价格≥ ",rangeDownStr,@" 或价格≤ ",rangeUpStr] ColorsArr:@[[UIColor lightGrayColor],color,[UIColor lightGrayColor],color] FontsArr:@[FONT(13),FONT(13),FONT(13),FONT(13)]];
    
    NSString *text = [NSString stringWithFormat:@"范围:价格≥ %@ 或价格≤ %@",rangeDownStr,rangeUpStr];
    self.rangeLblBlock(text);
}

-(void)btnClick:(UIButton *)btn{
    
    if (self.rangeHelpBlock != nil) {
        self.rangeHelpBlock();
    }
}

@end
