//
//  TimeSharingView.h
//  isInvested
//
//  Created by Blue on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//  分时 or 5日

#import <UIKit/UIKit.h>
@class IndexModel;

@interface TimeSharingView : UIView

@property (nonatomic, strong) IndexModel *model;
@property (nonatomic, assign) SocketRequestStyle style;
@property (nonatomic, weak  ) UILabel *informationLabel;

@property (nonatomic, copy) void (^stopTurnBlock)(); //停止转动Block
@property (nonatomic, copy) void (^refreshBlock)(); //点击无网络view后刷新

- (void)clearDrawing;
@end
