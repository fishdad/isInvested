//
//  OpenDeliveryOderConfModel.m
//  isInvested
//
//  Created by Ben on 16/10/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "OpenDeliveryOderConfModel.h"

@implementation OpenDeliveryOderConfModel

+(OpenDeliveryOderConfModel *)shareModelWithStruct:(OpenDeliveryOderConf) openDeliveryOderConf{
    
    OpenDeliveryOderConfModel *model = [[OpenDeliveryOderConfModel alloc] init];
    model.CommodityID = [NSString stringWithFormat:@"%d",openDeliveryOderConf.CommodityID];
    model.CanDeliver = [NSString stringWithFormat:@"%d",openDeliveryOderConf.CanDeliver];
    model.AgreeUnit = [NSString stringWithFormat:@"%f",openDeliveryOderConf.AgreeUnit];
    model.DeliveryCharge = [NSString stringWithFormat:@"%f",openDeliveryOderConf.DeliveryCharge];
    model.DeliCommCnt = [NSString stringWithFormat:@"%d",openDeliveryOderConf.DeliCommCnt];
    model.DeliveryCommodity = [DeliveryCommodityModel shareModelWithStruct:openDeliveryOderConf.DeliveryCommodity];
    return model;
}


@end
