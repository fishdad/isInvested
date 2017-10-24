//
//  KMBottomPopView.h
//  PopView
//
//  Created by Ben on 16/8/9.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopBottomViewBlock)(NSInteger index,NSArray *contents);//点击哪个按钮 + 往外传值
@interface KMBottomPopView : UIView

typedef NS_ENUM(NSInteger, PopBottomType) {
    PopBottomTypeAdd  = 0,//涨
    PopBottomTypeDel  = 1,//跌
    PopBottomTypeLevel  = 2,//平仓
    
};

//原来的添加到window上边
//+ (KMBottomPopView *)popWithType:(PopBottomType) type Title:(NSString *)title DetailLabels:(NSArray *)detailLabels sureBtn:(NSString *)suerStr cancel:(NSString *)cancelStr block:(void(^)(NSInteger index))block canTapCancel:(BOOL)canTap;

+ (KMBottomPopView *)popWithTarget:(UIViewController *) target Type:(PopBottomType) type Title:(NSString *)title DetailLabels:(NSArray *)detailLabels sureBtn:(NSString *)suerStr cancel:(NSString *)cancelStr block:(PopBottomViewBlock)block canTapCancel:(BOOL)canTap;

- (void)show;

@property(nonatomic,retain) UIViewController *target;



@end
