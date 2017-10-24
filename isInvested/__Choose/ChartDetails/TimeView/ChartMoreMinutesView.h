//
//  ChartMoreMinutesView.h
//  isInvested
//
//  Created by Blue on 16/9/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartMoreMinutesView : UIView

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, copy) void(^clickedMinuteBlock)(NSInteger);
@end
