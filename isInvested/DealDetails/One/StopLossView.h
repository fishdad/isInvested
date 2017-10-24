//
//  StopLossView.h
//  isInvested
//
//  Created by Blue on 16/9/5.
//  Copyright © 2016年 Blue. All rights reserved.
//  止盈止损view

#import <UIKit/UIKit.h>

@interface StopLossView : UIView

@property (nonatomic, strong) HoldPositionInfoModel *model;
@property (nonatomic, strong) HoldPositionInfoModel *refreshModel; //刷新数据用的
@property (nonatomic, copy) void (^successfulBlock)();

- (void)disappear;
@end
