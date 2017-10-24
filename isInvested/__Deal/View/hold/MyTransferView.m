//
//  MyTransferView.m
//  isInvested
//
//  Created by Ben on 16/9/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MyTransferView.h"


@implementation MyTransferView

- (instancetype)initWithFrame:(CGRect)frame Type:(TranserType) type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpSubViewsWithType:type];
    }
    return self;
}

-(void)setUpSubViewsWithType:(TranserType) type{

    //白色底部
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = OXColor(0xffffff);
    [self addSubview:backView];

    [backView addSubview:[Util setUpLineWithFrame:CGRectMake(0, 0, WIDTH, 1)]];
    
    CGFloat space = 15;
    CGFloat LTH = 45;
    _cardLT = [[LblTxtFView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 2 * 0, LTH + 10)];
    [backView addSubview:_cardLT];
    
    _moneyHelpLbl = [[UILabel alloc] init];
    _moneyHelpLbl.frame = CGRectMake(space + 100, NH(_cardLT) - 15, WIDTH - space - 100, 20);
    _moneyHelpLbl.font = FONT(12);
    _moneyHelpLbl.textColor = OXColor(0xb9b9b9);
    [backView addSubview:_moneyHelpLbl];
    
    CGFloat lineY;
    if (type == TranserTypeIn) {
        lineY = NH(_moneyHelpLbl);
    }else{
        lineY = _cardLT.bottom;
    }
    
    [backView addSubview:[Util setUpLineWithFrame:CGRectMake(15, lineY, WIDTH, 1)]];

    _priceLT = [[LblTxtFView alloc] initWithFrame:CGRectMake(0, lineY + 1, WIDTH - 2 * 0, LTH)];
    _priceLT.textF.keyboardType = UIKeyboardTypeDecimalPad;
    [backView addSubview:_priceLT];
    
    [backView addSubview:[Util setUpLineWithFrame:CGRectMake(0, NH(_priceLT), WIDTH, 1)]];
    
    backView.frame = CGRectMake(0, _cardLT.y, WIDTH, _cardLT.height + _priceLT.height);
    
    _timeHelpLbl = [[UILabel alloc] init];
    _timeHelpLbl.frame = CGRectMake(space, NH(_priceLT) + 10, WIDTH - 2 * space, 20);
    _timeHelpLbl.font = FONT(12);
    _timeHelpLbl.textAlignment = NSTextAlignmentRight;
    _timeHelpLbl.textColor = OXColor(0x999999);
    [self addSubview:_timeHelpLbl];
    
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(space, NH(_timeHelpLbl) + 20, WIDTH - 2 * space, 40);
    [_btn setTitle:@"确认" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn.backgroundColor = kNavigationBarColor;
    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 5;
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
   
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(WIDTH / 2.0, _btn.bottom + 10, (WIDTH / 2.0 - space), 30);
    [btn setTitle:@"我为什么出不了金?" forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.titleLabel.font = FONT(13);
    [btn setTitleColor:OXColor(0x4294f7) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(helpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _helpBtn = btn;
    _helpBtn.hidden = YES;
    [self addSubview:_helpBtn];
    
}

-(void)helpBtnClick:(UIButton *)btn{
    
    if (_helpClickBlock) {
        _helpClickBlock();
    }
}

-(void)btnClick:(UIButton *)btn{
    
    if (_clickBlock) {
        _clickBlock();
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
