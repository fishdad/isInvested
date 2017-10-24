//
//  MyPassWordTextField.m
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MyPassWordTextField.h"

@implementation MyPassWordTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat W = 20;
        CGFloat X = frame.size.width - W - 10;
        
        _textF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, X , frame.size.height)];
        //默认密码格式
        _textF.secureTextEntry = YES;
        [self addSubview:_textF];
        
        CGFloat Y = (frame.size.height - W) / 2;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(X, Y, W, W)];
        [btn setImage:[UIImage imageNamed:@"unLook"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"look"] forState:UIControlStateSelected];
       
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

-(void)btnClick:(UIButton *)button{

    button.selected = !button.selected;
    
    _textF.secureTextEntry = ! _textF.secureTextEntry;
    
    NSString* text = _textF.text;
    _textF.text = @"";
    _textF.text = text;
}

-(void)setPlaceholder:(NSString *)placeholder{

    _textF.placeholder = placeholder;
}

-(NSString *)text{

    return _textF.text;
}

@end
