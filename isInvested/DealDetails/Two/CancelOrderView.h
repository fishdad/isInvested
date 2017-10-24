//
//  CancelOrderView.h
//  isInvested
//
//  Created by Blue on 16/9/7.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancelOrderView : UIView

@property (nonatomic, strong) LimitOrderInfoModel *model;
@property (nonatomic, copy) void(^clickedOrderBlock)();
@end
