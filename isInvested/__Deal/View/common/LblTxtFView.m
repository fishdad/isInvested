//
//  LblTxtFView.m
//  isInvested
//
//  Created by Ben on 16/9/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "LblTxtFView.h"

@implementation LblTxtFView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = OXColor(0xffffff);
        //提示文字
        CGFloat imgW = 100;
        if (WIDTH == 320) {
            imgW = 80;
        }
        CGFloat imgH = 30;
        CGFloat spacing = 15;
        _label = [[UILabel alloc]initWithFrame:CGRectMake(spacing, (frame.size.height - imgH) / 2.0, imgW, imgH)];
        _label.font = FONT(17);
        [self addSubview:_label];
        
        //输入框
        CGFloat textFX = _label.x + _label.width ;
        _textF = [[UITextField alloc] initWithFrame:CGRectMake(textFX, (frame.size.height - imgH) / 2.0, (frame.size.width - textFX), imgH)];
        //删除按钮的类型
        _textF.font = FONT(17);
        _textF.delegate = self;
        _textF.clearButtonMode =UITextFieldViewModeWhileEditing;
        [self addSubview:_textF];
    }
    return self;
}

//限制输入小数点的位数 xinle
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = 2;//小数点后需要限制的个数
    for (NSInteger i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
