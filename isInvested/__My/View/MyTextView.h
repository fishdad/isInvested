//
//  MyTextView.h
//  isInvested
//
//  Created by Ben on 16/8/15.
//  Copyright © 2016年 Blue. All rights reserved.
//

/**

 自定义带图片,输入框,获取验证码的视图
 */

#import <UIKit/UIKit.h>

typedef void(^voidBlock)();

@interface MyTextView : UIView

@property(nonatomic,strong) UIView *backView;
//@property(nonatomic,strong) UIImageView *img;
@property(nonatomic,strong) UILabel *lbl;//风格替换换为label
@property(nonatomic,strong) UITextField *textF;
@property(nonatomic,strong) UIButton *actBtn;

@property(nonatomic,strong) NSString *placeholder;//占位符,为了修改颜色
@property(nonatomic,copy) voidBlock actBtnBlock;//获取验证码
@property(nonatomic,strong) UIColor *backColor;//背景色
@property(nonatomic,assign) NSInteger timerCount;
@property(nonatomic,strong)   NSTimer *timer;

@property(nonatomic,assign) BOOL isHaveImg;


- (instancetype)initWithFrame:(CGRect)frame TitleStr:(NSString *) titleStr;

@end
