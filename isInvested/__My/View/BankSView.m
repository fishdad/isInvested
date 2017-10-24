//
//  BankSView.m
//  isInvested
//
//  Created by Ben on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "BankSView.h"

@implementation BankSView


- (instancetype)initWithWidth:(CGFloat) width
{
    self = [super init];
    if (self) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        
        self.backgroundColor = [UIColor whiteColor];
        CGFloat space = 15;
        CGFloat btnW = (width - 15 * 4) / 3.0;
        CGFloat btnH = 30;
        int num = 20;
        int col = 3;
        int row = (num / col) + 1;
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < col; j ++) {
                int index = i * col + j + 1;
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = index;
                btn.frame = CGRectMake(j * btnW + space * (j + 1), i * btnH + (i + 1) * space, btnW, btnH );
    
                UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%i",index]];
                if (img != nil) {
                    [btn setImage:img forState:UIControlStateNormal];
                    [self btn:btn borderType:NO];
                }
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:btn];
                
            }
        }
        
        self.height = btnH * row + (row + 1) * space;
        scrollView.frame = CGRectMake(0, 0, width, self.height);
        scrollView.contentSize = CGSizeMake(width, self.height + 10);
    }
    return self;
}

-(void)btn:(UIButton *)btn borderType:(BOOL) isSelected{
    
    btn.layer.borderWidth = 1.0;
    if (isSelected) {
        btn.layer.borderColor = [OrangeBackColor CGColor];
    }else{
        btn.layer.borderColor = [LightGrayBackColor CGColor];
    }

}


-(void)btnClick:(UIButton *)btn{
    LOG(@"~~~~~点击了:%li",(long)btn.tag);
    _selectedIndex = btn.tag;
    int num = 20;
    int col = 3;
    int row = (num / col) + 1;
    
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j ++) {
            int index = i * col + j + 1;
            UIButton *btn = [self viewWithTag:index];
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%i",index]];
            if (img != nil) {
                [self btn:btn borderType:NO];
            }
        }
    }
    
    [self btn:btn borderType:YES];
}


@end
