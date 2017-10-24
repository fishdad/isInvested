//
//  TransInACPayPwdAlert.h
//  isInvested
//
//  Created by Ben on 16/12/2.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ACPayPwdAlert.h"
#import "MyTextView.h"

@interface TransInACPayPwdAlert : ACPayPwdAlert

@property (copy, nonatomic) void (^okBtnAction)(); ///点击确认按钮回调
@property (copy, nonatomic) void (^actBtnBlock)(); ///获取验证码的回调
@property (nonatomic, strong) UIButton *btn;//底部按钮
@property (nonatomic, strong) MyTextView *code;//验证码
-(void)changeView;//修改当前视图

@end
