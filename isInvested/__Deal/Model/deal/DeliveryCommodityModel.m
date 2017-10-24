//
//  DeliveryCommodityModel.m
//  isInvested
//
//  Created by Ben on 16/10/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "DeliveryCommodityModel.h"

@implementation DeliveryCommodityModel

+(DeliveryCommodityModel *)shareModelWithStruct:(DeliveryCommodity) deliveryCommodity{
    
    DeliveryCommodityModel *model = [[DeliveryCommodityModel alloc] init];
    model.CommodityID = [NSString stringWithFormat:@"%d",deliveryCommodity.CommodityID];
    model.CommodityName = [NSString stringWithUTF8String:deliveryCommodity.CommodityName];
    model.TradecommodityClassID = [NSString stringWithFormat:@"%d",deliveryCommodity.TradecommodityClassID];
    model.DeliveryRadio = [NSString stringWithFormat:@"%f",deliveryCommodity.DeliveryRadio];
    
    return model;
}


@end
