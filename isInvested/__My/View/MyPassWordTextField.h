//
//  MyPassWordTextField.h
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//


/**
 带有密码可见/不可见的密码输入框
 */
#import <UIKit/UIKit.h>

@interface MyPassWordTextField : UIView

@property(nonatomic,strong)UITextField *textF;

@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)NSString *placeholder;

@end
