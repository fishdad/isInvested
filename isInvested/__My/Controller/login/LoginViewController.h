//
//  LoginViewController.h
//  isInvested
//
//  Created by Ben on 16/8/15.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"

@interface LoginViewController : UIViewController

@property(nonatomic,strong) MyTextView *phoneNum;
@property(nonatomic,strong) MyTextView *passWord;

@property(nonatomic,copy) voidBlock cancelBlock;//
@property (nonatomic, assign) BOOL isGoToDeal;//是否去交易

@end
