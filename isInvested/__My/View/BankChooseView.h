//
//  BankChooseView.h
//  isInvested
//
//  Created by Ben on 16/11/29.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankChooseView : UIView

@property (nonatomic, copy) void (^chooseBank)(NSInteger index);

@end
