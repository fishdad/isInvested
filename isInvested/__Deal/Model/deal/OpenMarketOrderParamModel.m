//
//  OpenMarketOrderParamModel.m
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "OpenMarketOrderParamModel.h"

@implementation OpenMarketOrderParamModel

-(OpenMarketOrderParam)getStruct{

    OpenMarketOrderParam openMarketOrderParam;
    memset(&openMarketOrderParam,0x00,sizeof(OpenMarketOrderParam));
    openMarketOrderParam.nCommodityID = self.nCommodityID;
    openMarketOrderParam.nOpenDirector = self.nOpenDirector;		///< 建仓方向
    openMarketOrderParam.dbPrice = self.dbPrice;			///< 建仓单价
    openMarketOrderParam.dbWeight = self.dbWeight;		///< 交易重量(kg)
    openMarketOrderParam.nQuantity = self.nQuantity;			///< 交易数量
    openMarketOrderParam.dbTradeRange = self.dbTradeRange;	///< 最大点差

    return openMarketOrderParam;
}

@end
