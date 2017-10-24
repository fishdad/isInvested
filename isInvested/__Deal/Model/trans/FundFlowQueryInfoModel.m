//
//  FundFlowQueryInfoModel.m
//  isInvested
//
//  Created by Ben on 16/12/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "FundFlowQueryInfoModel.h"

@implementation FundFlowQueryInfoModel

+(FundFlowQueryInfoModel *)shareModelWithStruct:(FundFlowQueryInfo) stu{
    
    FundFlowQueryInfoModel *model = [[FundFlowQueryInfoModel alloc] init];
    model.FlowNumber = stu.FlowNumber;         ///< 流水号
    model.OperType = stu.OperType;           ///< 操作类型 --- 15:入金 --- 16:出金
    model.BeforeAmount = stu.BeforeAmount;       ///< 起始金额
    model.Amount = stu.Amount;             ///< 变动金额
    model.AfterAmount = stu.AfterAmount;        ///< 变后金额
    model.OpLoginAccount = [NSString stringWithUTF8String:stu.OpLoginAccount];   ///< 操作员
    model.OperDate = stu.OperDate;       ///< 日期
    model.BankID = stu.BankID;             ///< 银行标识
    model.OrderID = stu.OrderID;			///< 关联单号

    return model;
}

@end
