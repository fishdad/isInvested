//
//  IsOpeningAccountStatusView.m
//  isInvested
//
//  Created by Ben on 16/9/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "IsOpeningAccountStatusView.h"
#import "ImgViewLblView.h"

@implementation IsOpeningAccountStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(0, HEIGHT + 20);
        [self addSubview:_scrollView];
        
        ImgViewLblView *lbl = [[ImgViewLblView alloc] initWithFrame:CGRectMake(30, 45, WIDTH - 60, 40)];
        lbl.label.textAlignment = NSTextAlignmentCenter;
        lbl.label.text = @"广东省贵金属交易中心开户";
        lbl.img = [UIImage imageNamed:@"kaihu_icon"];
        [_scrollView addSubview:lbl];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(80, NH(lbl) + 10, WIDTH - 160 , 60);
        label.font = FONT(15);
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = OXColor(0x999999);
        label.text = @"您的信息正在提交中\n下拉可刷新开户状态";
        [_scrollView addSubview:label];

    }
    return self;
}
@end
