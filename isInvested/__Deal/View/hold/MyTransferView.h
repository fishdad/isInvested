//
//  MyTransferView.h
//  isInvested
//
//  Created by Ben on 16/9/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LblTxtFView.h"

@interface MyTransferView : UIView

@property (nonatomic, strong) LblTxtFView *cardLT;
@property (nonatomic, strong) LblTxtFView *priceLT;
@property (nonatomic, strong) UILabel *moneyHelpLbl;
@property (nonatomic, strong) UILabel *timeHelpLbl;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *helpBtn;
@property (nonatomic, copy) void (^clickBlock)();
@property (nonatomic, copy) void (^helpClickBlock)();

- (instancetype)initWithFrame:(CGRect)frame Type:(TranserType) type;

@end
