//
//  KLineView.h
//  isInvested
//
//  Created by Blue on 16/10/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SmallIndexStyle) {
    SmallIndexStyleMACD = 0,
    SmallIndexStyleRSI  = 1,
    SmallIndexStyleKDJ  = 2,
};

@interface KLineView : UIView

@property (nonatomic, copy  ) NSString *code;
@property (nonatomic, weak  ) UILabel *informationLabel;
@property (nonatomic, assign) SocketRequestStyle style;

@property (nonatomic, copy) void (^stopTurnBlock)(); /** 停止转动Block */
@property (nonatomic, copy) void (^refreshBlock)(); //点击无网络view后刷新

- (void)clearDrawing;
@end
