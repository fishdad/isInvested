//
//  CommodityInfoModel.m
//  isInvested
//
//  Created by Ben on 16/10/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CommodityInfoModel.h"

@implementation CommodityInfoModel

+(CommodityInfoModel *)shareModelWithStruct:(CommodityInfo) commodityInfo{
    
    CommodityInfoModel *model = [[CommodityInfoModel alloc] init];
    model.CommodityID = [NSString stringWithFormat:@"%d",commodityInfo.CommodityID];
    model.CommodityName = [NSString stringWithUTF8String:commodityInfo.CommodityName];
    model.CommodityRight = [NSString stringWithFormat:@"%lld",commodityInfo.CommodityRight];
    model.TradeRight = [NSString stringWithFormat:@"%lld",commodityInfo.TradeRight];
    model.AgreeUnit = [NSString stringWithFormat:@"%f",commodityInfo.AgreeUnit];
    model.Currency = [NSString stringWithFormat:@"%lld",commodityInfo.Currency];
    model.MinQuoteChangeUnit = [NSString stringWithFormat:@"%f",commodityInfo.MinQuoteChangeUnit];
    model.MinPriceUnit = [NSString stringWithFormat:@"%f",commodityInfo.MinPriceUnit];
    model.FixedSpread = [NSString stringWithFormat:@"%.2f",commodityInfo.FixedSpread];
    model.BuyPrice = [NSString stringWithFormat:@"%.2f",commodityInfo.BuyPrice];
    model.SellPrice = [NSString stringWithFormat:@"%.2f",commodityInfo.SellPrice];
    model.HighPrice = [NSString stringWithFormat:@"%.2f",commodityInfo.HighPrice];
    model.LowPrice = [NSString stringWithFormat:@"%.2f",commodityInfo.LowPrice];
    model.QuoteTime = [NSString stringWithFormat:@"%lld",commodityInfo.QuoteTime];
    model.CommodityClass = [NSString stringWithFormat:@"%d",commodityInfo.CommodityClass];
    model.CommodityClassName = [NSString stringWithUTF8String:commodityInfo.CommodityClassName];
    model.CommodityMode = [NSString stringWithFormat:@"%d",commodityInfo.CommodityMode];
    model.IsDisplay = [NSString stringWithFormat:@"%d",commodityInfo.IsDisplay];
    model.CommodityGroupID = [NSString stringWithFormat:@"%d",commodityInfo.CommodityGroupID];
    model.CommodityGroupName = [NSString stringWithUTF8String:commodityInfo.CommodityGroupName];
    model.WeightStep = [NSString stringWithFormat:@"%f",commodityInfo.WeightStep];
    model.WeightRadio = [NSString stringWithFormat:@"%f",commodityInfo.WeightRadio];
    model.TradeType = [NSString stringWithFormat:@"%lld",commodityInfo.TradeType];
    model.SpecificationRate = [NSString stringWithFormat:@"%f",commodityInfo.SpecificationRate];
    model.SpecificationUnit = [NSString stringWithUTF8String:commodityInfo.SpecificationUnit];
    
    return model;
}


@end
