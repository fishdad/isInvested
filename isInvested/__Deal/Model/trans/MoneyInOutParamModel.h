//
//  MoneyInOutParamModel.h
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyInOutParamModel : NSObject

@property (nonatomic, assign) MONEY_DIRECTION OperateType;			///< 出入金类型		---1 ::MONEY_OUT:出金  ---2 MONEY_IN:入金
@property (nonatomic, assign) int Currency;				///< 币种		--- 1:人民币
@property (nonatomic, assign) double Amount;				///< 出入金数量
@property (nonatomic, strong) NSString *FundPsw;	///< 资金密码
@property (nonatomic, strong) NSString *BankPsw;	///< 银行密码
@property (nonatomic, strong) NSString *Reversed;   ///< 特殊会员用于传入IP
@property (nonatomic, assign) int PayType;///< 支付类型 仅用于新浪支付 ---0:普通出入金 ---1:余额支付 ---:2绑卡支付
@property (nonatomic, assign) int OperateFlag;///< 操作标志 仅用于新浪支付 ---0:普通出入金 ---1:红包入金

-(MoneyInOutParam)getStruct;

@end
