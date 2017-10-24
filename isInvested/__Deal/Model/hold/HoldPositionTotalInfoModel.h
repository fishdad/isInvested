//
//  HoldPositionTotalInfoModel.h
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HoldPositionTotalInfoModel : NSObject

@property (nonatomic, strong) NSString *CommodityID;			///< 商品ID
@property (nonatomic, strong) NSString *CommodityName;	///<  商品名称
@property (nonatomic, assign) OPENDIRECTOR_DIRECTION OpenDirector;		///< 建仓方向
@property (nonatomic, strong) NSString *Quantity;			///< 持仓数量
@property (nonatomic, strong) NSString *TotalWeight;			///< 持仓总重量
@property (nonatomic, strong) NSString *OpenPriceTotal;		///< 建仓总值
@property (nonatomic, strong) NSString *AvgOpenPrice;		///< 建仓均价
@property (nonatomic, strong) NSString *HoldPriceTotal;		///< 持仓总值
@property (nonatomic, strong) NSString *AvgHoldPrice;		///< 持仓均价
@property (nonatomic, strong) NSString *ClosePrice;			///< 平仓价
@property (nonatomic, strong) NSString *OpenProfit;			///< 浮动盈亏

+(HoldPositionTotalInfoModel *)shareModelWithStruct:(HoldPositionTotalInfo) stu;

@end
