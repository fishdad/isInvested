//
//  DeliveryCommodityModel.h
//  isInvested
//
//  Created by Ben on 16/10/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryCommodityModel : NSObject

@property (nonatomic, strong)NSString *CommodityID;  ///< 交割商品ID
@property (nonatomic, strong)NSString *CommodityName; ///< 交割商品名称
@property (nonatomic, strong)NSString *TradecommodityClassID;    ///< 交割商品类型
@property (nonatomic, strong)NSString *DeliveryRadio;      ///< 交割手续费比例

+(DeliveryCommodityModel *)shareModelWithStruct:(DeliveryCommodity) deliveryCommodity;

@end
