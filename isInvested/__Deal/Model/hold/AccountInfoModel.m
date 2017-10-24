//
//  AccountInfoModel.m
//  isInvested
//
//  Created by Ben on 16/10/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "AccountInfoModel.h"
#import "DealSocketStructHeader.h"

@implementation AccountInfoModel

+(AccountInfoModel *)shareModelWithStruct:(AccountInfo) accountInfo{

    AccountInfoModel *model = [[AccountInfoModel alloc] init];

     model.Account = [[NSString alloc] initWithUTF8String:accountInfo.Account];
     model.LoginAccount = [[NSString alloc] initWithUTF8String:accountInfo.LoginAccount];
     model.CustomerName = [[NSString alloc] initWithUTF8String:accountInfo.CustomerName];
     model.NAVPrice = [NSString stringWithFormat:@"%.2f",accountInfo.NAVPrice];
     model.Amount = [NSString stringWithFormat:@"%.2f",accountInfo.Amount];
     model.OpenProfit = [NSString stringWithFormat:@"%.2f",accountInfo.OpenProfit];
     model.ExchangeReserve = [NSString stringWithFormat:@"%.2f",accountInfo.ExchangeReserve];
     model.PerformanceReserve = [NSString stringWithFormat:@"%.2f",accountInfo.PerformanceReserve];
     model.FrozenReserve = [NSString stringWithFormat:@"%.2f",accountInfo.FrozenReserve];
     model.RiskRate = [NSString stringWithFormat:@"%.2f",accountInfo.RiskRate];
    return model;
}

@end
