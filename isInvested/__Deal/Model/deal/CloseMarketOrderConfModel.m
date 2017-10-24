//
//  CloseMarketOrderConfModel.m
//  isInvested
//
//  Created by Ben on 16/10/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CloseMarketOrderConfModel.h"

@implementation CloseMarketOrderConfModel

+(CloseMarketOrderConfModel *)shareModelWithStruct:(CloseMarketOrderConf) closeMarketOrderConf{
    
    CloseMarketOrderConfModel *model = [[CloseMarketOrderConfModel alloc] init];
    model.CommodityID = [NSString stringWithFormat:@"%lld",closeMarketOrderConf.CommodityID];
    model.MinQuantity = [NSString stringWithFormat:@"%f",closeMarketOrderConf.MinQuantity];
    model.MaxQuantity = [NSString stringWithFormat:@"%f",closeMarketOrderConf.MaxQuantity];
    model.MinTradeRange = [NSString stringWithFormat:@"%f",closeMarketOrderConf.MinTradeRange];
    model.MaxTradeRange = [NSString stringWithFormat:@"%f",closeMarketOrderConf.MaxTradeRange];
    model.DefaultTradeRange = [NSString stringWithFormat:@"%.0f",closeMarketOrderConf.DefaultTradeRange];
    model.AgreeUnit = [NSString stringWithFormat:@"%f",closeMarketOrderConf.AgreeUnit];
    model.CommodityMode = [NSString stringWithFormat:@"%lld",closeMarketOrderConf.CommodityMode];
    model.WeightStep = [NSString stringWithFormat:@"%f",closeMarketOrderConf.WeightStep];
    model.WeightRadio = [NSString stringWithFormat:@"%f",closeMarketOrderConf.WeightRadio];
    model.MinTotalWeight = [NSString stringWithFormat:@"%f",closeMarketOrderConf.MinTotalWeight];
    model.MaxTotalWeight = [NSString stringWithFormat:@"%f",closeMarketOrderConf.MaxTotalWeight];
    model.DepositeRate = [NSString stringWithFormat:@"%f",closeMarketOrderConf.DepositeRate];
    model.SpecificationRate = [NSString stringWithFormat:@"%f",closeMarketOrderConf.SpecificationRate];
    return model;
}


@end
