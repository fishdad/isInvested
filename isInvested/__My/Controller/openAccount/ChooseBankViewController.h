//
//  ChooseBankViewController.h
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"
#import "LbelTextFBtnView.h"

@interface ChooseBankViewController : UIViewController

@property(nonatomic,strong) LbelTextFBtnView *nameLTB;
@property(nonatomic,strong) LbelTextFBtnView *bankCardLTB;
@property(nonatomic,strong) LbelTextFBtnView *bankLTB;
@property(nonatomic,strong) LbelTextFBtnView *bankCityLTB;
@property(nonatomic,strong) LbelTextFBtnView *phoneNumLTB;
@property(nonatomic,strong) MyTextView *code;
@property(nonatomic,strong) UIButton *chooseBtn;

@end
