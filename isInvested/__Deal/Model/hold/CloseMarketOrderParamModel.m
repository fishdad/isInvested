//
//  CloseMarketOrderParamModel.m
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CloseMarketOrderParamModel.h"

@implementation CloseMarketOrderParamModel

-(CloseMarketOrderParam)getStruct{
    
    CloseMarketOrderParam stu;
    memset(&stu,0x00,sizeof(CloseMarketOrderParam));
    
    stu.nHoldPositionID = self.nHoldPositionID;
    stu.nCommodityID = self.nCommodityID;			///< 商品ID
    stu.dbWeight = self.dbWeight;			///< 交易重量(kg)
    stu.nQuantity = self.nQuantity;				///< 平仓数量
    stu.nTradeRange = self.nTradeRange;			///< 最大点差
    stu.dbPrice = self.dbPrice;				///< 平仓价格
    
    return stu;
}


@end
