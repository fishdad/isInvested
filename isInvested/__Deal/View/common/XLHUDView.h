//
//  XLHUDView.h
//  isInvested
//
//  Created by Ben on 2016/12/28.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLHUDView : UIView

+(instancetype)shareInstance;
-(void)show;
-(void)hide;
-(void)backViewWithAlpha:(CGFloat) alpha;

@end
