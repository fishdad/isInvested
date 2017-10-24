//
//  HoldTableViewCell.h
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VarietyDetailTitleView.h"

@interface HoldTableViewCell : UITableViewCell

@property (nonatomic, strong) VarietyDetailTitleView *titleView;
@property (nonatomic, strong) HoldPositionTotalInfoModel *model;

@end
