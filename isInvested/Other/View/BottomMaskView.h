//
//  BottomMaskView.h
//  isInvested
//
//  Created by Blue on 16/9/5.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomMaskView : UIView

/** 底部弹出的子view */
@property (nonatomic, strong) UIView *subView;
/** 点击空白处, 使蒙板消失 */
@property (nonatomic, copy) void (^disappearBlock)();
@end
