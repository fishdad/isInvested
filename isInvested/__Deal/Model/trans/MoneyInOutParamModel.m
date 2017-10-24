//
//  MoneyInOutParamModel.m
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MoneyInOutParamModel.h"

@implementation MoneyInOutParamModel

-(MoneyInOutParam)getStruct{
    
    MoneyInOutParam stu;
    memset(&stu,0x00,sizeof(MoneyInOutParam));
    
    stu.OperateType = self.OperateType;	///< 出入金类型		---1 ::MONEY_OUT:出金  ---2 MONEY_IN:入金
    stu.Currency = 1;///< 币种		--- 1:人民币
    stu.Amount = self.Amount;///< 出入金数量
    memcpy(stu.FundPsw, [self.FundPsw cStringUsingEncoding:NSUTF8StringEncoding], MAX_FUNDPWD_LEN);
    memcpy(stu.BankPsw, [self.BankPsw cStringUsingEncoding:NSUTF8StringEncoding], MAX_BANKPWD_LEN);
    NSString *IPV4Str =  [Util getIPV4String];
    memcpy(stu.Reversed, [IPV4Str cStringUsingEncoding:NSUTF8StringEncoding], MAX_IP_LEN);
    stu.PayType = 0;///< 支付类型 仅用于新浪支付 ---0:普通出入金 ---1:余额支付 ---:2绑卡支付
    stu.OperateFlag = 0;///< 操作标志 仅用于新浪支付 ---0:普通出入金 ---1:红包入金
    return stu;
}

@end
