//
//  UILabel+TextWidhtHeight.h
//  XLApp
//
//  Created by 辛乐 on 16/9/6.
//  Copyright © 2016年 辛乐. All rights reserved.
//

//获取字符串的长度
#import <UIKit/UIKit.h>

@interface UILabel (TextWidhtHeight)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end
