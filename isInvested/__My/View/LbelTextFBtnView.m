//
//  LbelTextFBtnView.m
//  isInvested
//
//  Created by Ben on 16/8/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "LbelTextFBtnView.h"

@implementation LbelTextFBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //提示文字
        CGFloat imgW = 100;
        CGFloat imgH = 30;
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, (frame.size.height - imgH) / 2.0, imgW, imgH)];
        _label.font = [UIFont systemFontOfSize:17];
        [self addSubview:_label];
        
        
        //输入框
        CGFloat textFX = _label.x + _label.width + 10;
        _textF = [[UITextField alloc] initWithFrame:CGRectMake(textFX, (frame.size.height - imgH) / 2.0, (frame.size.width - textFX), imgH)];
        //文本编辑删除类型
//        _textF.clearsOnBeginEditing =YES;
        //删除按钮的类型
        _textF.clearButtonMode =UITextFieldViewModeWhileEditing;
        [self addSubview:_textF];
        
        //按钮
        CGFloat btnW = 30;
        _actBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.size.width - btnW - 20, (self.size.height - imgH) / 2.0, btnW, imgH)];
        _actBtn.layer.masksToBounds = YES;
        _actBtn.layer.cornerRadius = 15;
//        _actBtn.backgroundColor = [UIColor redColor];
        [_actBtn addTarget:self action:@selector(actBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_actBtn];
        
    }
    return self;
}

-(void)setLabelText:(NSString *)labelText{

    _label.text = labelText;
    CGFloat imgH = 30;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
         attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    
    CGSize size =  [labelText boundingRectWithSize:CGSizeMake( MAXFLOAT,imgH) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    _label.frame = CGRectMake(0, (self.frame.size.height - imgH) / 2.0, size.width, imgH);
    //输入框
     CGFloat textFX = _label.x + _label.width + 10;
    _textF.frame = CGRectMake(textFX, (self.frame.size.height - imgH) / 2.0, (self.frame.size.width - textFX), imgH);
    
    //按钮
    CGFloat btnW = 30;
    _actBtn.frame = CGRectMake(self.size.width - btnW - 20, (self.size.height - imgH) / 2.0, btnW, imgH);
    
}

-(void)actBtnClick:(UIButton *)btn{
    
    if (self.actBtnBlock != nil) {
        self.actBtnBlock();
    }

}



@end
