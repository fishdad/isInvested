//
//  HasOpenedAccountView.m
//  isInvested
//
//  Created by Ben on 16/9/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "HasOpenedAccountView.h"

@implementation HasOpenedAccountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        CGFloat ImgW = 80;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - ImgW) / 2.0, 80, ImgW, ImgW)];
        imgView.image = [UIImage imageNamed:@"open_success_tick"];
        [self addSubview:imgView];
        
        CGFloat space = 40;
        CGFloat lblH = 40;
        UILabel *label1 = [[UILabel alloc] init];
        label1.frame = CGRectMake(space, NH(imgView) + 10, WIDTH - 2 * space, lblH);
        label1.text = @"恭喜!广东省贵金属交易中心";
        label1.textColor = OXColor(0x56b427);
        label1.font = BOLD_FONT(20);
        [self addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.frame = CGRectMake(space, NH(label1), WIDTH - 2 * space, lblH);
        label2.text = @"开户成功!";
        label2.textColor = OXColor(0x56b427);
        label2.font = BOLD_FONT(20);
        [self addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.tag = 100;
        label3.frame = CGRectMake(space, NH(label2), WIDTH - 2 * space, lblH - 10);
        label3.text = [NSString stringWithFormat:@"交易账号: %@",[NSUserDefaults objectForKey:KHAccount]];
        label3.font = FONT(15);
        label3.textColor = OXColor(0x666666);
        [self addSubview:label3];

        UILabel *label4 = [[UILabel alloc] init];
        label4.frame = CGRectMake(space, NH(label3), WIDTH - 2 * space, lblH - 10);
        label4.text = @"牛奶金服，千万投资者的掌中宝";
        label4.font = FONT(15);
        label4.textColor = OXColor(0x666666);
        [self addSubview:label4];
        

        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(space, NH(label4) + 30, WIDTH - 2 * space, 40);
        [_btn setTitle:@"马上去交易" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor whiteColor];
        
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 3;
        _btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _btn.layer.borderWidth = 1;
        
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];

    }
    return self;
}

-(void)setAccountStr:(NSString *)accountStr{

    UILabel *label = [self viewWithTag:100];
     label.text = [NSString stringWithFormat:@"交易账号: %@",accountStr];
}

-(void)btnClick:(UIButton *)btn{
 
    if ([btn.titleLabel.text isEqualToString:@"马上去交易"]) {
        if (self.goToDealBlock) {
            self.goToDealBlock();
        }
        [self removeFromSuperview];
    }else{
    
        if (self.openAccountBlock) {
            self.openAccountBlock();
        }
    }
}

@end
