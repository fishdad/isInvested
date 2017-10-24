//
//  NewBankTableViewCell.h
//  isInvested
//
//  Created by Ben on 2016/12/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankModel.h"

@interface NewBankTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, strong) UIImageView *chooseImg;
@property (nonatomic, strong) BankModel *model;

@end
