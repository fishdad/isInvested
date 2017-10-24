//
//  CloseMarketOrderParamModel.h
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloseMarketOrderParamModel : NSObject

@property (nonatomic, assign) long long nHoldPositionID;		///< 持仓ID
@property (nonatomic, assign) int nCommodityID;				///< 商品ID
@property (nonatomic, assign) double dbWeight;				///< 交易重量(kg)
@property (nonatomic, assign) int nQuantity;					///< 平仓数量
@property (nonatomic, assign) int nTradeRange;				///< 最大点差
@property (nonatomic, assign) double dbPrice;					///< 平仓价格


-(CloseMarketOrderParam)getStruct;

@end
