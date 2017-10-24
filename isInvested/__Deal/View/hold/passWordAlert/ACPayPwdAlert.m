//
//  ACPayPwdAlert.m
//  ACPayPwdView
//
//  Created by ablett on 16/6/16.
//  Copyright © 2016年 ablett. All rights reserved.
//

#import "ACPayPwdAlert.h"
#import "AppDelegate.h"

#define kColorComplete [UIColor colorWithRed:0.214 green:0.526 blue:1.000 alpha:1.000]
#define kColorNormal   [UIColor colorWithWhite:0.584 alpha:1.000]
#define kColorMask     [UIColor colorWithWhite:0.000 alpha:0.400]
#define kFrameAlert    CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.8, 168)
#define kColorLine     [UIColor colorWithWhite:0.824 alpha:1.000]
#define kColorCancel   [UIColor colorWithRed:0.967 green:0.159 blue:0.047 alpha:1.000]

static const CGFloat duration = 0.25;

@interface ACPayPwdAlert()

@end

@implementation ACPayPwdAlert

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    //set default value
    self.length = 6;
    
    CGFloat padding = 20.f;
    CGFloat margin = 15.f;
    CGFloat width = [UIScreen mainScreen].bounds.size.width*0.8;
    CGFloat titleH = 20.f;
    CGFloat inputH = (width-padding*2)/self.length;
    CGFloat btnH = 44.f;
    CGFloat height = titleH+inputH+btnH+margin*4+1.f;
    
    
    self.frame = CGRectMake(0, 0, width, height);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.f;
    
    /** title label */
    self.titleLabel.frame = CGRectMake(padding, margin, inputH*self.length, titleH);
    
    /** top line */
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom+margin, self.width, 0.5)];
    topLine.backgroundColor = kColorLine;
    
    /** pwd view */
    self.pwdInputView.frame = CGRectMake(padding, topLine.bottom+margin, inputH*self.length, inputH);
    
    /** cancel button */
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake( 10, 10, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"deal_passCancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    /** complete button 忘记密码?*/
    self.completeBtn.frame = CGRectMake(self.width / 2.0 - 10, self.pwdInputView.bottom+margin, (self.width-0.5)*0.5, btnH);
    [_completeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    [self addSubview:self.titleLabel];
    [self addSubview:topLine];
    [self addSubview:self.pwdInputView];
    [self addSubview:self.completeBtn];
    [self addSubview:cancelBtn];
    
    __weak typeof(&*self)weakSelf = self;
    self.pwdInputView.inputDidCompletion = ^(NSString *pwd) {
        if (pwd.length == weakSelf.pwdInputView.length) {
            weakSelf.pwd = pwd;
            weakSelf.complete = YES;
        }else {
            weakSelf.pwd = @"";
            weakSelf.complete = NO;
        }
    };
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Setter/Getter

- (void)setTitle:(NSString *)title {
    _title = title;
   self.titleLabel.text = title;
}

- (void)setLength:(NSUInteger)length {
    _length = length;
    self.pwdInputView.length = length;
}

- (void)setComplete:(BOOL)complete {
    _complete = complete;
    if (complete) {
        self.completeBtn.enabled = YES;
        //密码输入完成
        if (_completeAction) {
            _completeAction(self.pwd);
        }
    }else {
        self.completeBtn.enabled = NO;
    }
}

- (ACPwdInputView *)pwdInputView {
    if (!_pwdInputView) {
        _pwdInputView = [[ACPwdInputView alloc] init];
    }
    return _pwdInputView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _maskView.backgroundColor = kColorMask;
        _maskView.alpha = 0.f;
    }
    return _maskView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithWhite:0.202 alpha:1.000];
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _titleLabel;
}

- (UIButton *)completeBtn {
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_completeBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_completeBtn setTitleColor:OXColor(0x4294f7) forState:UIControlStateNormal];
        [_completeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_completeBtn addTarget:self action:@selector(forgetPass:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}

#pragma mark - Public

- (void)show {

    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    [keyWindow addSubview:self.maskView];
    [keyWindow addSubview:self];

    self.center = CGPointMake(keyWindow.center.x, (keyWindow.frame.size.height - 216) * 0.5);
    self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    
    __weak typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.maskView.alpha = 1.f;
        weakSelf.alpha = 1.f;
        weakSelf.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf.pwdInputView becomeFirstResponder];
        }
    }];
}


- (void)dismiss {
    [self.pwdInputView endEditing:YES];
    __weak typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.alpha = 0.f;
        weakSelf.maskView.alpha = 0.f;
        weakSelf.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    }completion:^(BOOL finished) {
        if (finished) {
            weakSelf.complete = NO;
            [weakSelf removeFromSuperview];
            [weakSelf.maskView removeFromSuperview];
        }
    }];
}


#pragma mark - Privite


- (void)forgetPass:(id)sender {
    
    //忘记密码
    LOG(@"~~~~~~忘记密码");
    if (self.forgetPassAction) {
       self.forgetPassAction();
    }
}

- (void)cancel:(id)sender {
    [self dismiss];
}

@end
