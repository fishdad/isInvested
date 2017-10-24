//
//  ChartMinutesMaskView.m
//  isInvested
//
//  Created by Blue on 16/9/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ChartMinutesMaskView.h"

@implementation ChartMinutesMaskView

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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

@end
