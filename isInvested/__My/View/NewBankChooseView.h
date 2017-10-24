//
//  NewBankChooseView.h
//  isInvested
//
//  Created by Ben on 2016/12/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewBankChooseView : UIView

@property (nonatomic, copy) void (^chooseBank)(NSString *bankCode);

@end
