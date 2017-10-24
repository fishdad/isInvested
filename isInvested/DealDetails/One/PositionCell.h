//
//  PositionCell.h
//  isInvested
//
//  Created by Blue on 16/9/2.
//  Copyright © 2016年 Blue. All rights reserved.
//  持仓明细 & 平仓记录 cell

#import <UIKit/UIKit.h>

@interface PositionCell : UITableViewCell

@property (nonatomic, strong) ClosePositionInfoModel *closeModel;

@property (nonatomic, copy) void (^stopLossBlock)();
@property (nonatomic, copy) void (^exitBlock)();
@property (nonatomic, copy) void (^cancelOrderBlock)(NSInteger);
@end
