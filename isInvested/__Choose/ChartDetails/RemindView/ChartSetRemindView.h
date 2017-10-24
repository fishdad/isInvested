//
//  ChartSetRemindView.h
//  isInvested
//
//  Created by Blue on 16/9/23.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndexModel;

@interface ChartSetRemindView : UIView

@property (nonatomic, strong) IndexModel *model;
@property (nonatomic, copy) void(^clickedFinishBlock)();
@end
