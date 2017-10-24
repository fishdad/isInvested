//
//  GetCodeViewController.h
//  isInvested
//
//  Created by Ben on 16/8/16.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"

@interface GetCodeViewController : UIViewController

@property(nonatomic,strong) MyTextView *phoneNum;
@property(nonatomic,strong) MyTextView *code;
@property(nonatomic,strong) NSString* validateCode;

@property(nonatomic,assign) NSInteger vcType;//0:交易 1:资金 ,其他用户模块

@end
