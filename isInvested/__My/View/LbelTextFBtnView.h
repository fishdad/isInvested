//
//  LbelTextFBtnView.h
//  isInvested
//
//  Created by Ben on 16/8/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^voidBlock)();

@interface LbelTextFBtnView : UIView

@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UITextField *textF;
@property(nonatomic,strong) UIButton *actBtn;

@property(nonatomic,copy) voidBlock actBtnBlock;
@property(nonatomic,strong) NSString *labelText;

@end
