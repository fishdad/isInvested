//
//  PopMarketDealView.h
//  isInvested
//
//  Created by Ben on 16/12/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#pragma mark -- 暂时不用,后期版本完善可能添加 xinle 

#import <UIKit/UIKit.h>
#import "VarietyDetailTitleView.h"

@interface PopMarketDealView : UIView

@property (nonatomic, strong) VarietyDetailTitleView *titleView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *okBtn;

- (instancetype)initWithFrame:(CGRect)frame CommodityID:(NSString *)commodityID;

@end
