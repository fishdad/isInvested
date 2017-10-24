//
//  BankChooseView.m
//  isInvested
//
//  Created by Ben on 16/11/29.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "BankChooseView.h"
#import "BankSView.h"

@interface BankChooseView ()

@property (nonatomic, strong) BankSView *banks;

@end

@implementation BankChooseView

-(void)dealloc{

    LOG(@"BankChooseView~~~~~~~~~销毁");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpSubViews];
    }
    return self;
}

-(void)setUpSubViews{

    //黑色底部
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.8;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
    [backView addGestureRecognizer:tap];
    [self addSubview:backView];
   
    //白班
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];

    CGFloat width = WIDTH - 20 * 2;
    CGFloat space = 20;
    
    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(space, 5, 80, 35);
    cancelBtn.tag = 101;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:OXColor(0x2672d1) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelBtn];
    //确定
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(width - 80 - 5, 5 ,80, 35);
    okBtn.tag = 102;
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:OXColor(0x2672d1) forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:okBtn];


    [whiteView addSubview:[Util setUpLineWithFrame:CGRectMake(0, okBtn.bottom, width, 0.5)]];
    
    _banks = [[BankSView alloc] initWithWidth:width];
    _banks.frame = CGRectMake(0, okBtn.bottom + 5, width, _banks.height);
    [whiteView addSubview:_banks];

    whiteView.frame = CGRectMake(0, 0, width, _banks.bottom + 5);
    whiteView.center = self.center;
    
}

-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 102) {//确定
        
        if (self.chooseBank) {
            self.chooseBank(_banks.selectedIndex);
        }
    }
    [self removeFromSuperview];
}

-(void)tapTouch{
    
}


@end
