//
//  ReKHPassWordViewController.h
//  isInvested
//
//  Created by Ben on 16/8/17.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"

@interface ReKHPassWordViewController : UIViewController

@property(nonatomic,strong) MyTextView *passWord;
@property(nonatomic,strong) MyTextView *passWord2;
@property(nonatomic,strong) UILabel *serverLabel;

@property(nonatomic,assign) NSInteger vcType;// 0:交易 1:资金

@end
