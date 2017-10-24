//
//  TransInACPayPwdAlert.m
//  isInvested
//
//  Created by Ben on 16/12/2.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "TransInACPayPwdAlert.h"

@implementation TransInACPayPwdAlert

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    CGFloat x = 15;
    
    //手机验证码
//    _codeTxt = [[UITextField alloc] initWithFrame:self.pwdInputView.frame];
//    _codeTxt.textAlignment = NSTextAlignmentCenter;
//    _codeTxt.keyboardType = UIKeyboardTypeNumberPad;
//    _codeTxt.hidden = YES;
//    _codeTxt.borderStyle = UITextBorderStyleRoundedRect;
//    [self addSubview:_codeTxt];
    
    
    //验证码
    _code = [[MyTextView alloc] initWithFrame:self.pwdInputView.frame];
    _code.hidden = YES;
    [self addSubview:_code];
    _code.textF.textColor = [UIColor blackColor];
    _code.placeholder = @"请输入验证码";
    _code.textF.font = FONT(13);
    _code.textF.width = 100;
    _code.textF.keyboardType = UIKeyboardTypeNumberPad;
    _code.backColor = nil;
    _code.actBtn.backgroundColor = [UIColor grayColor];
    [_code.actBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _code.actBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _code.actBtn.hidden = NO;
    [_code setIsHaveImg:NO];
    
    
    
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(x, self.completeBtn.bottom + 5, self.width - 2 * x, 40);
    [_btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn.backgroundColor = kNavigationBarColor;
    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 5;
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
   
    self.height = _btn.bottom + 10;
    return self;
}

-(void)btnClick:(UIButton *)btn{
    
    if ([btn.titleLabel.text isEqualToString:@"获取验证码"]) {
       
        if (self.actBtnBlock) {
            self.actBtnBlock();
        }
    }else if([btn.titleLabel.text isEqualToString:@"确定"]){
        if (self.okBtnAction) {
            self.okBtnAction();
        }
    }
}

-(void)changeView{

    self.titleLabel.text = @"请输入手机验证码";
    [self.completeBtn setTitle:@"请输入手机验证码" forState:UIControlStateNormal];
    self.completeBtn.userInteractionEnabled = NO;
    _code.hidden = NO;
    [_code.textF becomeFirstResponder];
    [_code becomeFirstResponder];
    self.pwdInputView.hidden = YES;
    [self.btn setTitle:@"确定" forState:UIControlStateNormal];
}

@end
