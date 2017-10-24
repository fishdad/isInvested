//
//  HUDTool.h
//  isInvested
//
//  Created by Blue on 16/8/9.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HUDTool : NSObject

+ (void)show;
+ (void)showToView:(UIView *)view;

+ (void)hide;
+ (void)hideForView:(UIView *)view;

+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text toView:(UIView *)view;

@end
