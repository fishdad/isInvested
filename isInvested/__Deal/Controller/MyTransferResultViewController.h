//
//  MyTransferResultViewController.h
//  isInvested
//
//  Created by Ben on 16/9/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTransferResultViewController : UIViewController
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) void (^okBlock)();
@property (nonatomic, assign) BOOL isSuccessAmount;//是否到账
@end
