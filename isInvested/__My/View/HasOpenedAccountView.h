//
//  HasOpenedAccountView.h
//  isInvested
//
//  Created by Ben on 16/9/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HasOpenedAccountView : UIView

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, copy) void (^openAccountBlock)();
@property (nonatomic, copy) void (^goToDealBlock)();
@property (nonatomic, strong) NSString *accountStr;

@end
