//
//  OpenAccountImageView.m
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "OpenAccountImageView.h"

@implementation OpenAccountImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //开户完成的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(complantOpenAccount) name:@"complantOpenAccount" object:nil];
        //当前登录账号已经开户的情况
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(complantOpenAccount) name:@"LoginWithOpenAccount" object:nil];
        self.image = [UIImage imageNamed:@"openAccount"];
        self.userInteractionEnabled = YES;
        //开户按钮
        CGFloat x = 42;
        CGFloat y = HEIGHT - 62 - 64;
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, y, (WIDTH - 2 * x), 42);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = OXColor(0xf5c000);
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 21;
        label.font = BOLD_FONT(20);
        label.text = @"立 即 开 户";
        [self addSubview:label];

    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"开户~~~");
    
    if (self.openAccountBlock != nil) {
        
        self.openAccountBlock();
    }
}
//完成开户
-(void)complantOpenAccount{

    [self removeFromSuperview];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
