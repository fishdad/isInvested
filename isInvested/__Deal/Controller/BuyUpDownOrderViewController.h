//
//  BuyUpDownOrderViewController.h
//  isInvested
//
//  Created by Ben on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyUpDownOrderViewController : UIViewController

- (instancetype)initWithMarketOrderType:(BuyOrderType) type;


@property (nonatomic, strong) UISegmentedControl *segmentControl;
//下单方式切换
-(void)actionSegmentControl:(UISegmentedControl *)segment;
//选择行情
-(void)selectVarietyIndex:(NSInteger) tag;

@end
