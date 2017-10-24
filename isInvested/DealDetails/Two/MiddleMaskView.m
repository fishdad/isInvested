//
//  MiddleMaskView.m
//  isInvested
//
//  Created by Blue on 16/9/7.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MiddleMaskView.h"

@implementation MiddleMaskView

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
        subView.center = self.window.center;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self disappear];
}

/** 使蒙板消失 */
- (void)disappear {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.subView.x = WIDTH;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
