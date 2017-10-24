//
//  PriceDealView.m
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "PriceDealView.h"
#import "UILabel+TextWidhtHeight.h"

@implementation PriceDealView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat spacing = 10;
        CGFloat btnW = 30;
        CGFloat titleLblW = (WIDTH - 10 - btnW * 2 - 10) / 4.0;
        CGFloat allowTW = [UILabel getWidthWithTitle:@"四个汉字" font:FONT(15)];
        CGFloat titleLblH = 30;
        
        UIFont *font = FONT(15);
        if (WIDTH == 320) {
            font = FONT(13);
        }
        //买入价格
        _priceTitleLbl = [[UILabel alloc] init];
        _priceTitleLbl.frame = CGRectMake(spacing, 10, titleLblW, titleLblH);
        _priceTitleLbl.text = @"买入价格";
        _priceTitleLbl.font = font;
        [self addSubview:_priceTitleLbl];
        
        //实际的价格值
        _priceValueLbl = [[UILabel alloc] init];
        _priceValueLbl.frame = CGRectMake(NW(_priceTitleLbl), 10, titleLblW, titleLblH);
//        _priceValueLbl.text = @"3564.25";
         _priceValueLbl.font = font;
        [self addSubview:_priceValueLbl];
        
        CGFloat btnSpacing = NW(_priceValueLbl);
        //允许差价btn
        _allowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allowBtn.frame = CGRectMake(btnSpacing, 10, 30, 30);
        [_allowBtn addTarget:self action:@selector(allowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_allowBtn setImage:[Util OriginImage:[UIImage imageNamed:@"deal_allowChoose"] scaleToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        [self addSubview:_allowBtn];
        
        //允许差价
        UILabel *allowTitleLbl = [[UILabel alloc] init];
        allowTitleLbl.frame = CGRectMake(NW(_allowBtn),  10, titleLblW, titleLblH);
        allowTitleLbl.font = font;
        allowTitleLbl.text = @"允许差价";
        allowTitleLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:allowTitleLbl];
        
        //允许差价的值
        CGFloat textH = 20;
        _allowTF = [[UITextField alloc] initWithFrame:CGRectMake(NW(allowTitleLbl),spacing + 5, allowTW, textH)];
//        _allowTF.text = @"50";
        _allowTF.keyboardType = UIKeyboardTypeDecimalPad;
        _allowTF.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _allowTF.layer.borderWidth = 0.5;
        _allowTF.layer.masksToBounds = YES;
        _allowTF.layer.cornerRadius = 3;
        _allowTF.font = font;
        _allowTF.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_allowTF];
        
        //帮助按钮
        UIButton *helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        helpBtn.frame = CGRectMake(NW(_allowTF), _allowTF.y - 5, btnW, btnW);
        helpBtn.tag = 104;
        [helpBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [helpBtn setImage:[Util OriginImage:[UIImage imageNamed:@"deal_help"] scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
        [self addSubview:helpBtn];
    }
    return self;
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


@end
