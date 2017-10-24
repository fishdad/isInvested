//
//  FundFlowQueryInfoModel.h
//  isInvested
//
//  Created by Ben on 16/12/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundFlowQueryInfoModel : NSObject

@property (nonatomic, assign)int     FlowNumber;         ///< 流水号
@property (nonatomic, assign)int     OperType;           ///< 操作类型 --- 15:入金 --- 16:出金 --- 17:入金冲正 --- 18:出金冲正 --- 19:撤销入金 --- 20:撤销出金 --- 21:单边账调整入金 --- 22:单边账调整出金 --- 23:穿仓回退入金 --- 24:穿仓回退出金
@property (nonatomic, assign)double  BeforeAmount;       ///< 起始金额
@property (nonatomic, assign)double  Amount;             ///< 变动金额
@property (nonatomic, assign)double  AfterAmount;        ///< 变后金额
@property (nonatomic, strong)NSString *OpLoginAccount;   ///< 操作员
@property (nonatomic, assign)long long   OperDate;       ///< 日期
@property (nonatomic, assign)int     BankID;             ///< 银行标识
@property (nonatomic, assign)int		OrderID;			///< 关联单号

+(FundFlowQueryInfoModel *)shareModelWithStruct:(FundFlowQueryInfo) stu;

@end
