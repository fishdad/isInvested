//
//  ACPayPwdAlert.h
//  ACPayPwdView
//
//  Created by ablett on 16/6/16.
//  Copyright © 2016年 ablett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPwdInputView.h"

@interface ACPayPwdAlert : UIView

@property (copy, nonatomic) NSString *title;                        ///< 标题
@property (assign, nonatomic) NSUInteger length;                    ///< 密码长度
@property (copy, nonatomic) void (^completeAction)(NSString *text); ///< 回调 Block
@property (copy, nonatomic) void (^forgetPassAction)(); ///<忘记密码 回调 Block
@property (strong, nonatomic) ACPwdInputView *pwdInputView; ///< 输入区

@property (strong, nonatomic) UIView *maskView;             ///< 遮罩
@property (strong, nonatomic) UILabel *titleLabel;          ///< 标题
@property (strong, nonatomic) UIButton *completeBtn;        ///< 确定
@property (assign, nonatomic, getter=isComplete) BOOL complete; ///< 是否完成
@property (copy, nonatomic) NSString *pwd;                      ///< 密码

- (void)show;
- (void)dismiss;

@end
