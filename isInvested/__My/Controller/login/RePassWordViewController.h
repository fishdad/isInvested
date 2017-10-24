//
//  RePassWordViewController.h
//  isInvested
//
//  Created by Ben on 16/8/16.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"

@interface RePassWordViewController : UIViewController

@property(nonatomic,strong) MyTextView *passWord;
@property(nonatomic,strong) MyTextView *passWord2;

@property(nonatomic,strong)NSString *phoneNum;
@property(nonatomic,strong)NSString *vCode;

@end
