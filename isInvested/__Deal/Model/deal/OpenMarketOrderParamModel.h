//
//  OpenMarketOrderParamModel.h
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

//====市价建仓单的参数
@interface OpenMarketOrderParamModel : NSObject

@property (nonatomic, assign) int nCommodityID;		///< 商品ID
@property (nonatomic, assign) OPENDIRECTOR_DIRECTION nOpenDirector;	///< 建仓方向
@property (nonatomic, assign) double dbPrice;       ///< 建仓单价
@property (nonatomic, assign) double dbWeight;      //交易重量(kg)
@property (nonatomic, assign) double dbTradeRange;  ///< 最大点差
@property (nonatomic, assign) int nQuantity;		///< 交易数量
@property (nonatomic, assign) int nOrderType;		///< 下单类型		---1:客户下单

-(OpenMarketOrderParam)getStruct;

@end
