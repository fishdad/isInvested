//
//  PriceDealView.h
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceDealView : UIView

@property (nonatomic, strong) UILabel *priceTitleLbl;
@property (nonatomic, strong) UILabel *priceValueLbl;
@property (nonatomic, strong) UIButton *allowBtn;
@property (nonatomic, strong) UITextField *allowTF;
@property (nonatomic, copy) void (^allowHelpBlock)();

@end
