//
//  HorizontalScrollView.h
//  isInvested
//
//  Created by Ben on 16/9/9.
//  Copyright © 2016年 Blue. All rights reserved.
//  计量单位选择view

#import <UIKit/UIKit.h>

@interface HorizontalScrollView : UIImageView

@property (nonatomic, copy) void (^chooseBlock)(NSInteger i);

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)items NowString:(NSString *)nowString;

@end
