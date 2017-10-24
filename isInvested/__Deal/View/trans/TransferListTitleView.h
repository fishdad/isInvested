//
//  TransferListTitleView.h
//  isInvested
//
//  Created by Ben on 16/9/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferListTitleView : UIView

@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, assign) TranserType type;
@property (nonatomic, assign) NSInteger  statusType;//状态 0 失败;1 成功

@end
