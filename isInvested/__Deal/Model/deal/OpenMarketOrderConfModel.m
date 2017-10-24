//
//  OpenMarketOrderConfModel.m
//  isInvested
//
//  Created by Ben on 16/10/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "OpenMarketOrderConfModel.h"

@implementation OpenMarketOrderConfModel

+(OpenMarketOrderConfModel *)shareModelWithStruct:(OpenMarketOrderConf) openMarketOrderConf{
    
    OpenMarketOrderConfModel *model = [[OpenMarketOrderConfModel alloc] init];
    model.CommodityID = [NSString stringWithFormat:@"%lld",openMarketOrderConf.CommodityID];
    model.MinQuantity = [NSString stringWithFormat:@"%f",openMarketOrderConf.MinQuantity];
    model.MaxQuantity = [NSString stringWithFormat:@"%f",openMarketOrderConf.MaxQuantity];
    model.MinTradeRange = [NSString stringWithFormat:@"%f",openMarketOrderConf.MinTradeRange];
    model.MaxTradeRange = [NSString stringWithFormat:@"%f",openMarketOrderConf.MaxTradeRange];
    model.DefaultTradeRange = [NSString stringWithFormat:@"%.0f",openMarketOrderConf.DefaultTradeRange];
    model.AgreeUnit = [NSString stringWithFormat:@"%f",openMarketOrderConf.AgreeUnit];
    model.CommodityMode = [NSString stringWithFormat:@"%lld",openMarketOrderConf.CommodityMode];
    model.WeightStep = [NSString stringWithFormat:@"%f",openMarketOrderConf.WeightStep];
    model.WeightRadio = [NSString stringWithFormat:@"%f",openMarketOrderConf.WeightRadio];
    model.MinTotalWeight = [NSString stringWithFormat:@"%f",openMarketOrderConf.MinTotalWeight];
    model.MaxTotalWeight = [NSString stringWithFormat:@"%f",openMarketOrderConf.MaxTotalWeight];
    model.DepositeRate = [NSString stringWithFormat:@"%f",openMarketOrderConf.DepositeRate];
    model.SpecificationRate = [NSString stringWithFormat:@"%f",openMarketOrderConf.SpecificationRate];
    return model;
}


@end
