//
//  RegistViewController.h
//  isInvested
//
//  Created by Ben on 16/8/15.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"

@interface RegistViewController : UIViewController

@property(nonatomic,strong) MyTextView *phoneNum;
@property(nonatomic,strong) MyTextView *nickName;
@property(nonatomic,strong) MyTextView *passWord;
@property(nonatomic,strong) MyTextView *passWord2;
@property(nonatomic,strong) MyTextView *code;
@property(nonatomic,strong) NSString* validateCode;
@property (nonatomic, copy) void (^returnBlock)();
@property(nonatomic,strong) UIButton *chooseBtn;
@end
