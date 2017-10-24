//
//  ExitView.h
//  isInvested
//
//  Created by Blue on 16/9/6.
//  Copyright © 2016年 Blue. All rights reserved.
//  平仓买入 or 平仓卖出

#import <UIKit/UIKit.h>

@interface ExitView : UIView

@property (nonatomic, strong) HoldPositionInfoModel *model;
@property (nonatomic, copy) void (^successfulBlock)();

- (void)disappear;
@end
