//
//  BottomMaskView.m
//  isInvested
//
//  Created by Blue on 16/9/5.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "BottomMaskView.h"

@implementation BottomMaskView

- (instancetype)init {
    if (self = [super initWithFrame:KEY_WINDOW.bounds]) {
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [KEY_WINDOW addSubview:self];
    }
    return self;
}

- (void)setSubView:(UIView *)subView {
    _subView = subView;
    
    [self addSubview:subView];
    
    [UIView animateWithDuration:0.25 animations:^{
        subView.y = HEIGHT - subView.height + 1;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // 点击蒙板使自己消失
    if (point.y < self.subView.y) {
        
        if (self.disappearBlock) {
            self.disappearBlock();
        }
        
//        [self endEditing:YES];
//        
//        [UIView animateWithDuration:0.25 animations:^{
//            self.subView.y = HEIGHT;
//            
//        } completion:^(BOOL finished) {
//            [self removeFromSuperview];
//        }];
        
    }
}

@end
