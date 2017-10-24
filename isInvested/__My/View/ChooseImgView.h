//
//  ChooseImgView.h
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseImgView : UIView

@property(nonatomic,strong)UIButton *titleBtn;
@property(nonatomic,strong)UIImageView *dataImgView;
@property(nonatomic,strong)UIButton *statusBtn;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,assign) CGFloat selfHeight;
@property(nonatomic,assign) BOOL isAllowEdit;//是否允许编辑

@property(nonatomic,weak)UIViewController *target;

- (instancetype)initWithFrame:(CGRect)frame WithTarget:(UIViewController *)target Title:(NSString *)title;

@end
