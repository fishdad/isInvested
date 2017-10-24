//
//  OpenLimitOrderConfModel.m
//  isInvested
//
//  Created by Ben on 16/10/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "OpenLimitOrderConfModel.h"

@implementation OpenLimitOrderConfModel


+(OpenLimitOrderConfModel *)shareModelWithStruct:(OpenLimitOrderConf) openLimitOrderConf{
    
    OpenLimitOrderConfModel *model = [[OpenLimitOrderConfModel alloc] init];
    model.CommodityID = [NSString stringWithFormat:@"%lld",openLimitOrderConf.CommodityID];
    model.MinQuantity = [NSString stringWithFormat:@"%f",openLimitOrderConf.MinQuantity];
    model.MaxQuantity = [NSString stringWithFormat:@"%f",openLimitOrderConf.MaxQuantity];
    model.LimitSpread = [NSString stringWithFormat:@"%f",openLimitOrderConf.LimitSpread];
    model.FixSpread = [NSString stringWithFormat:@"%f",openLimitOrderConf.FixSpread];
    model.TPSpread = [NSString stringWithFormat:@"%f",openLimitOrderConf.TPSpread];
    model.SLSpread = [NSString stringWithFormat:@"%f",openLimitOrderConf.SLSpread];
    model.MinPriceUnit = [NSString stringWithFormat:@"%f",openLimitOrderConf.MinPriceUnit];
    model.AgreeUnit = [NSString stringWithFormat:@"%f",openLimitOrderConf.AgreeUnit];
    model.CommodityMode = [NSString stringWithFormat:@"%lld",openLimitOrderConf.CommodityMode];
    model.WeightStep = [NSString stringWithFormat:@"%f",openLimitOrderConf.WeightStep];
    model.WeightRadio = [NSString stringWithFormat:@"%f",openLimitOrderConf.WeightRadio];
    model.MinTotalWeight = [NSString stringWithFormat:@"%f",openLimitOrderConf.MinTotalWeight];
    model.MaxTotalWeight = [NSString stringWithFormat:@"%f",openLimitOrderConf.MaxTotalWeight];
    model.DepositeRate = [NSString stringWithFormat:@"%f",openLimitOrderConf.DepositeRate];
    model.SpecificationRate = [NSString stringWithFormat:@"%f",openLimitOrderConf.SpecificationRate];
    return model;
}

@end
