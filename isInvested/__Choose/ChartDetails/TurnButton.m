//
//  TurnButton.m
//  isInvested
//
//  Created by Blue on 16/12/7.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "TurnButton.h"

@interface TurnButton ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) NSInteger count;
@end

@implementation TurnButton

- (instancetype)init {
    if (self = [super init]) {
        self.adjustsImageWhenHighlighted = NO;
        [self setImage:[UIImage imageNamed:@"chart_clockwise"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clicked {

    if (self.timer) return; //正在转时, 定时器不为空
    
    self.isStopTurn = NO;
    [self addTimer];
    
    if (self.objc1) ((void(^)())self.objc1)();
}

#pragma mark - 定时器方法

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                  target:self
                                                selector:@selector(turnOnce)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)turnOnce {
    
    self.count ++;
    
    // 旋转速度==圈/0.5s
    [UIView animateWithDuration:0.02 animations:^{
        self.transform = CGAffineTransformMakeRotation(self.angle += 0.251327);
        
    } completion:^(BOOL finished) {
        
        // 有网络来, 并且一整圈结束
        if (self.isStopTurn && self.count % 25 == 0) {
            [self removeTimer];
            
        } else if (self.count % 250 == 0) { //无网络,转10圈后停止
            [self removeTimer];
            [HUDTool showText:kRequestTimeout];
        }
    }];
}

#pragma mark - Dynamic Method

void clickedIMP(id self, SEL _cmd) {
    [self clicked];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    if (sel == @selector(clicked)) {
        class_addMethod(self, sel, (IMP)clickedIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

@end
