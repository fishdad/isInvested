//
//  ViewController.m
//  XBStepper
//
//  Created by Peter Jin mail:i@Jxb.name on 15/5/12.
//  Github ---- https://github.com/JxbSir
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBStepper;

@interface XBStepper : UIControl

@property (nonatomic, copy) void (^btnClickBlock)();
@property (nonatomic, copy) void (^textShouldBeginWriteBlock)();
@property (nonatomic, copy) void (^textDidEndEditingBlock)(NSString *text);
@property(nonatomic,strong)UITextField  *txtCount;
@property(nonatomic,assign)NSInteger    Precision;//小数位数

/**
 *  设置框、文本颜色
 *
 *  @param color
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor BorderColor:(UIColor*)borderColor BtnTextColor:(UIColor*)textColor;

/**
 *  设置值
 *
 *  @param max 最大值，默认暂时不用
 *  @param min 最小值，默认0
 *  @param now 当前值，默认0
 */
- (void)setMaxValue:(CGFloat)max min:(CGFloat)min now:(CGFloat)now Precision:(NSInteger) precision;
@end
