//
//  DealViewController.h
//  isInvested
//
//  Created by Blue on 16/8/8.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealViewController : UIViewController
@property (nonatomic, assign) BOOL isNotFirstIn;
@property(nonatomic,strong)UICollectionView *contentScrollView;
@property (nonatomic, assign) DealFromType fromType;//1:我的资产界面进入 0:点击中间的tab进入
@end
