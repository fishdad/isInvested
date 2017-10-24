//
//  CloseOutController.h
//  isInvested
//
//  Created by Blue on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//  平仓记录

#import <UIKit/UIKit.h>
#import "ChooseTimeView.h"
#import "DetailsSuperController.h"

@interface CloseOutController : DetailsSuperController

@property (nonatomic, strong) ChooseTimeView *dateView;

- (void)addTimer;
@end
