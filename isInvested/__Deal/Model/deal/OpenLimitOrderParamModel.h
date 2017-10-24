//
//  OpenLimitOrderParamModel.h
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenLimitOrderParamModel : NSObject

@property (nonatomic, assign) int nCommodityID;			///< 商品ID
@property (nonatomic, assign) int nExpireType;			///< 过期类型		--- 1:当日有效
@property (nonatomic, assign) OPENDIRECTOR_DIRECTION nOpenDirector;			///< 建仓方向
@property (nonatomic, assign) double dbWeight;			///< 交易重量(kg)
@property (nonatomic, assign) int nQuantity;				///< 建仓数量
//int nOrderType;				///< 下单类型		--- 1:客户下单
@property (nonatomic, assign) double dbOrderPrice;		///< 建仓单价
@property (nonatomic, assign) double dbTPPrice;			///< 止盈价格
@property (nonatomic, assign) double dbSLPrice;			///< 止损价格

-(OpenLimitOrderParam)getStruct;

@end
