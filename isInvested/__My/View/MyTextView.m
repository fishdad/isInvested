//
//  MyTextView.m
//  isInvested
//
//  Created by Ben on 16/8/15.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MyTextView.h"
#import "UILabel+TextWidhtHeight.h"

@interface MyTextView ()
{

}
@end

@implementation MyTextView

- (instancetype)initWithFrame:(CGRect)frame TitleStr:(NSString *) titleStr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _timerCount = 60;
        //标题名称
        //        CGFloat imgW = 30 * 30 / 37.0;
        CGFloat imgW = [UILabel getWidthWithTitle:titleStr font:FONT(17)];
        CGFloat imgH = 30;
        _lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, (frame.size.height - imgH) / 2.0, imgW, imgH)];
        _lbl.font = FONT(17);
        [self addSubview:_lbl];
        
        
        //输入框
        CGFloat textFX = _lbl.x + _lbl.width + 10;
        _textF.backgroundColor = [UIColor redColor];
        _textF = [[UITextField alloc] initWithFrame:CGRectMake(textFX, (frame.size.height - imgH) / 2.0, (frame.size.width - textFX), imgH)];
        //文本编辑删除类型
        //        _textF.clearsOnBeginEditing =YES;
        _textF.textColor = [UIColor blackColor];
        //删除按钮的类型
        _textF.clearButtonMode =UITextFieldViewModeWhileEditing;
        _textF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textF.autocorrectionType = UITextAutocorrectionTypeNo;//关闭默认联想词
        [self addSubview:_textF];
        
        //按钮
        CGFloat btnW = 100;
        _actBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.size.width - btnW - 10, (self.size.height - imgH) / 2.0, btnW, imgH)];
        _actBtn.layer.masksToBounds = YES;
        _actBtn.layer.cornerRadius = 3;
        [_actBtn addTarget:self action:@selector(actBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_actBtn];
        _actBtn.hidden = YES;
        
        [self addSubview:[Util setUpLineWithFrame:CGRectMake(0,frame.size.height - 0.5, frame.size.width, 0.5)]];
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [self initWithFrame:frame TitleStr:@"四个汉字"];
    return self;
}

-(void)countTimer:(NSTimer *)myTimer{

    [_actBtn setTitle:[NSString stringWithFormat:@"%li S后重发",_timerCount] forState:UIControlStateNormal];
    _actBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _actBtn.backgroundColor = [UIColor lightGrayColor];
    
    NSLog(@"~~~~~~~~:%li",_timerCount);
    
    _timerCount = _timerCount - 1;
    
    if (_timerCount < 0) {
        [_timer invalidate];
        _timer = nil;
        [_actBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _actBtn.backgroundColor = kNavigationBarColor;
        _timerCount = 60;
        _actBtn.selected = NO;
    }
}

-(void)actBtnClick:(UIButton *)btn{
    
    if ([_actBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
        
        if (self.actBtnBlock != nil) {
            self.actBtnBlock();
            
        }        
    }
}

-(void)setPlaceholder:(NSString *)placeholder{

    _textF.placeholder = placeholder;
    [_textF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    if ([placeholder rangeOfString:@"验证码"].length > 0) {
        
        CGRect oFrame = _textF.frame;
        oFrame.size.width = oFrame.size.width - 120;
        _textF.frame = oFrame;
    }
}

-(void)setBackColor:(UIColor *)backColor{

    if (backColor == nil) {
        _backView.backgroundColor = [UIColor whiteColor];
        return;
    }
    if (backColor == [UIColor whiteColor]) {
        _backView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _backView.layer.borderWidth = 1.0;
    }
    _backView.backgroundColor = backColor;
    
}

-(void)setIsHaveImg:(BOOL)isHaveImg{

    if (isHaveImg == NO) {
        
        CGRect oFrame = _textF.frame;
        oFrame.origin.x = 15;
        _textF.frame = oFrame;
    }
}

-(void)dealloc{

    [_timer invalidate];
     _timer = nil;
}

@end
