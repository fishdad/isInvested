//
//  OpenDeliveryOderConfModel.h
//  isInvested
//
//  Created by Ben on 16/10/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeliveryCommodityModel.h"

@interface OpenDeliveryOderConfModel : NSObject

@property (nonatomic, strong) NSString *CommodityID;       ///< 交易商品ID
@property (nonatomic, strong) NSString *CanDeliver;        ///< 是否能交割     ---0:不能交割       ---1-能交割
@property (nonatomic, strong) NSString *AgreeUnit;      ///< 合约单位
@property (nonatomic, strong) NSString *DeliveryCharge; ///<  交割货款
@property (nonatomic, strong) NSString *DeliCommCnt;       ///<  对应交割商品总数
@property (nonatomic, strong) DeliveryCommodityModel *DeliveryCommodity; ///< 交易商品对应的交割商品信息

+(OpenDeliveryOderConfModel *)shareModelWithStruct:(OpenDeliveryOderConf) openDeliveryOderConf;

@end
