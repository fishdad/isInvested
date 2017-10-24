//
//  MyAssetsViewController.h
//  isInvested
//
//  Created by Ben on 16/8/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAssetsViewController : UIViewController

@property (nonatomic, assign) NSInteger fromType;//来源:0:个人中心 1:交易持仓界面
@property (nonatomic, copy) void(^transInOutBlock)();//转入转出点击后的处理

@end
