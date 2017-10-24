//
//  CloseMarketOrderManyParamModel.m
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CloseMarketOrderManyParamModel.h"

@implementation CloseMarketOrderManyParamModel

-(CloseMarketOrderManyParam)getStruct{
    
    CloseMarketOrderManyParam stu;
    memset(&stu,0x00,sizeof(CloseMarketOrderManyParam));
    
    stu.nCommodityID = self.nCommodityID;			///< 商品ID
    stu.dbWeight = self.dbWeight;			///< 交易重量(kg)
    stu.nQuantity = self.nQuantity;				///< 平仓数量
    stu.nTradeRange = self.nTradeRange;			///< 最大点差
    stu.dbPrice = self.dbPrice;				///< 平仓价格
    //int nClosePositionType;		///< 平仓类型		--- 1:一般平仓
    stu.nCloseDirector = self.nCloseDirector;			///< 平仓方向	
    return stu;
}


@end
