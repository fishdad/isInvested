//
//  PriceChooseView.h
//  isInvested
//
//  Created by Ben on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBStepper.h"

@interface PriceChooseView : UIView

@property (nonatomic, strong)UIButton *btn;
@property (nonatomic, strong)UILabel *leftLbl;
@property (nonatomic, strong)XBStepper *stepper;
@property (nonatomic, strong)UILabel *rightLbl;
@property (nonatomic, assign)NSInteger precision;
@property (nonatomic, assign)BOOL isSelected;// 是否选中

//取消选择
-(void)cancelSelected;
@end
