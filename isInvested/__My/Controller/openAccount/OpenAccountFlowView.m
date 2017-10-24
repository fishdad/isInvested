//
//  OpenAccountFlowView.m
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "OpenAccountFlowView.h"
#import "KHFlowLabelView.h"

@implementation OpenAccountFlowView

- (instancetype)initWithFrame:(CGRect)frame SelectIndex:(NSInteger) index
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = OXColor(0xf5f5f5);
        [self setUpMyViewWithSelectIndex:(NSInteger) index];
        
    }
    return self;
}

-(void)setUpMyViewWithSelectIndex:(NSInteger) index{
    
    CGFloat lineH = 10;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15,(self.frame.size.height - lineH) / 2, WIDTH - 30, lineH)];
    line.backgroundColor = LightGrayBackColor;
    [self addSubview:line];

    CGFloat bigW = 75;
    CGFloat space = (WIDTH - 15 * 2 - bigW * 3) / 2;
    
    NSArray *textArr = @[@"基本\n信息",@"设置\n密码",@"签约\n银行"];
   
    for (int i = 0; i < 3; i++) {
     
        UIColor *color = [UIColor whiteColor];
        
        if (i == index) {
            color = kNavigationBarColor;
        }
        
        KHFlowLabelView *view = [[KHFlowLabelView alloc] initWithFrame:CGRectMake(15 + (bigW + space) * i, (self.frame.size.height - bigW) /  2.0, bigW, bigW) LabelText:textArr[i] BackColor:color];
        
        [self addSubview:view];
        
    }
}

@end
