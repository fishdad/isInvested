//
//  OpenLimitOrderParamModel.m
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "OpenLimitOrderParamModel.h"

@implementation OpenLimitOrderParamModel

-(OpenLimitOrderParam)getStruct{
    
    OpenLimitOrderParam stu;
    memset(&stu,0x00,sizeof(OpenLimitOrderParam));
    stu.nCommodityID = self.nCommodityID;
    stu.nExpireType = self.nExpireType;			///< 过期类型		--- 1:当日有效
    stu.nOpenDirector = self.nOpenDirector;			///< 建仓方向
    stu.dbWeight = self.dbWeight;			///< 交易重量(kg)
    stu.nQuantity = self.nQuantity;				///< 建仓数量
    //int nOrderType;				///< 下单类型		--- 1:客户下单
    stu.dbOrderPrice = self.dbOrderPrice;		///< 建仓单价
    stu.dbTPPrice = self.dbTPPrice;			///< 止盈价格
    stu.dbSLPrice = self.dbSLPrice;			///< 止损价格
    return stu;
}


@end
