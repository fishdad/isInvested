//
//  DealComputerTool.m
//  isInvested
//
//  Created by Ben on 16/11/23.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "DealComputerTool.h"

@implementation DealComputerTool

//获取最新的账户余额
+(void)getAccntAmountWithBlock:(void(^)(NSString * ExchangeReserve)) amountBlock{
    
    [[DealSocketTool shareInstance] getAccntInfoWithBlock:^(AccountInfoModel *model) {
        amountBlock(model.ExchangeReserve);
    } isHUDHidden:YES];
}

//计算可买重量赋值并返回数据
+(void)getCanByWeightValueByPrice:(float) price OpenOrderConfModel:(NSObject *) Model CanBuyWeightBlock:(void(^)(float canbuyWeight)) block{
    
    __block float weight;
    float AgreeUnit;
    float DepositeRate;
    AgreeUnit =  [[Model valueForKey:@"AgreeUnit"] floatValue];
    DepositeRate = [[Model valueForKey:@"DepositeRate"] floatValue];
    if (price == 0) {//价格为零时处理
        weight = 0;
        if (block) {
            block(weight);
        }
    }else{
        
     [self getAccntAmountWithBlock:^(NSString *ExchangeReserve) {
         
//         //可买重量=交易准备金÷下单价格÷(准备金率+手续费率)÷重量转换
//         weight = [ExchangeReserve floatValue] / price / (DepositeRate + HandlingRate) / [Model.WeightRadio floatValue];
         if (block) {
             block(weight);
         }
     }];
    }
}


@end
