//
//  WeightChooseView.m
//  isInvested
//
//  Created by Ben on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "WeightChooseView.h"
#import "UILabel+TextWidhtHeight.h"

@interface WeightChooseView()

@property (nonatomic, assign) BuyOrderType type;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) NSInteger i;

@end


@implementation WeightChooseView

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithMarketOrderType:(BuyOrderType) type
{
    self = [super init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transFormOfWeightMoreDisPlay) name:@"UnitTransForm" object:nil];
    if (self) {
        _type = type;
        if (type == BuyOrderTypeUp) {
            _color = RedBackColor;
        }else if (type == BuyOrderTypeDown){
            _color = GreenBackColor;
        }else if (type == BuyOrderTypeLevel){
            _color = OrangeBackColor;
        }
        [self setUpView];
    }
    return self;
}

-(void)setUpView{

    CGFloat spacing = 10;
    CGFloat titleLblW = [UILabel getWidthWithTitle:@"四个汉字" font:FONT(15)];
    CGFloat titleLblH = 30;

    //买入重量
    _weightTitleLbl = [[UILabel alloc] init];
    _weightTitleLbl.frame = CGRectMake(spacing, 10, titleLblW, titleLblH);
    _weightTitleLbl.text = @"买入重量";
    _weightTitleLbl.font = FONT(15);
    [self addSubview:_weightTitleLbl];
    
    //计量单位
    CGFloat unitValueLblW = 55;
    _unitValueLbl = [[UILabel alloc] init];
    _unitValueLbl.frame = CGRectMake(WIDTH - unitValueLblW , _weightTitleLbl.y, unitValueLblW, 20);
//    _unitValueLbl.text = @"X 100kg";
    _unitValueLbl.textAlignment = NSTextAlignmentCenter;
//    _unitValueLbl.backgroundColor = [UIColor redColor];
    _unitValueLbl.font = FONT(10);
    [self addSubview:_unitValueLbl];
    
    //下拉计量单位按钮
    CGFloat btnW = 30;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 100;
    btn.frame = CGRectMake(WIDTH - ((unitValueLblW + btnW) / 2.0), _unitValueLbl.bottom - 10, btnW, btnW);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *img = [Util OriginImage:[UIImage imageNamed:@"deal_weightMore"] scaleToSize:CGSizeMake(15, 15)];
    [btn setImage:img forState:UIControlStateNormal];
    [self addSubview:btn];

    
    //重量计数
    CGFloat stepperH = 34;
    if (WIDTH == 320) {
        stepperH = 30;
    }
    CGFloat stepperW = (WIDTH - 2 * spacing - _weightTitleLbl.width - unitValueLblW);
    _weightStepper = [[XBStepper alloc] initWithFrame:CGRectMake(NW(_weightTitleLbl) + 10, _weightTitleLbl.y, stepperW, stepperH)];
    [_weightStepper setMaxValue:0 min:0 now:0 Precision:0];
    [_weightStepper setBackgroundColor:[UIColor whiteColor] BorderColor:OXColor(0xd4d4d4) BtnTextColor:OrangeBackColor];
    WEAK_SELF
    _weightStepper.textShouldBeginWriteBlock = ^(){
    
        [weakSelf unitBtnClick:nil];
    };
    _weightStepper.btnClickBlock = ^(){
    
        if (weakSelf.weightChangeBlock) {
            weakSelf.weightChangeBlock();
        }
    };
    [self addSubview:_weightStepper];
    
    //1/3,1/2,全部
    CGFloat btnSpacing = 2 * spacing + titleLblW;
//    CGFloat bW = (WIDTH - btnSpacing - spacing - spacing * 2) / 3.0;
    CGFloat bW = (stepperW  - 2 * spacing)/ 3.0;
    CGFloat bH = 26;
    if (WIDTH == 320) {
        bH = 22;
    }
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(btnSpacing, NH(_weightTitleLbl) + 10, bW, bH);
    [btn1 addTarget:self action:@selector(unitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"1/3" forState:UIControlStateNormal];
    btn1.titleLabel.font = FONT(13);
    btn1.tag = 101;
    [self btnMaskLayer:btn1];
    [self addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(NW(btn1) + spacing, NH(_weightTitleLbl) + 10, bW, bH);
    [btn2 addTarget:self action:@selector(unitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"1/2" forState:UIControlStateNormal];
    btn2.titleLabel.font = FONT(13);
    btn2.tag = 102;
    [self btnMaskLayer:btn2];
    [self addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(NW(btn2) + spacing, NH(_weightTitleLbl) + 10, bW, bH);
    [btn3 addTarget:self action:@selector(unitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setTitle:@"全部" forState:UIControlStateNormal];
    btn3.titleLabel.font = FONT(13);
    btn3.tag = 103;
    [self btnMaskLayer:btn3];
    [self addSubview:btn3];

    //可买入数量
    _canBuyTitleLbl = [[UILabel alloc] init];
    _canBuyTitleLbl.frame = CGRectMake(btnSpacing, btn1.bottom + 5, (WIDTH - btnSpacing), 20);
//    _canBuyTitleLbl.text = @" 可买00000.00kg";
//    _canBuyTitleLbl.textColor = [UIColor lightGrayColor];
    [self addSubview:_canBuyTitleLbl];

    //传出高度
    self.height = NH(_canBuyTitleLbl);
}

-(void)btnMaskLayer:(UIButton *)btn{
    
    btn.layer.borderColor = [OXColor(0xd4d4d4) CGColor];
    btn.layer.borderWidth = 0.5;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
}

-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 100) {
        
        BOOL isUnitChoose = [NSUserDefaults boolForKey:@"UnitChoose"];
        if (isUnitChoose) {
            //单位选择消失
            if (self.unitDismissBlock) {
                self.unitDismissBlock();
            }
        }else{
            //单位选择
            if (self.unitBlock) {
                self.unitBlock();
            }
        }
        [self transFormOfWeightMoreDisPlay];
    }
}

-(void)transFormOfWeightMoreDisPlay{
    
    BOOL isUnitChoose = [NSUserDefaults boolForKey:@"UnitChoose"];
    UIButton *btn = [self viewWithTag:100];
    if (isUnitChoose) {
        //单位选择消失
        [UIView animateWithDuration:0.5 animations:^{
            btn.transform = CGAffineTransformMakeRotation(M_PI * 1);
        }];
    }else{
        //单位选择
        [UIView animateWithDuration:0.5 animations:^{
            btn.transform = CGAffineTransformMakeRotation(M_PI * 0);
        }];
    }

    
}


-(void)unitBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
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
//    if (btn != nil) {
//        [_weightStepper.txtCount resignFirstResponder];
//        _weightStepper.txtCount.text = @"";
//
//    }
    //101:1/3  102:1/2   103:全部
    NSInteger weightType = 0;
    if (btn.tag != 0) {
        weightType = 104 - btn.tag;
    }
    if (self.easeChooseBlock) {
        self.easeChooseBlock(weightType);
    }
    if (self.weightChangeBlock) {
        self.weightChangeBlock();
    }
}


@end
