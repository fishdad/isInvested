//
//  LimitClosePositionConfModel.m
//  isInvested
//
//  Created by Ben on 16/10/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "LimitClosePositionConfModel.h"

@implementation LimitClosePositionConfModel

+(LimitClosePositionConfModel *)shareModelWithStruct:(LimitClosePositionConf) limitClosePositionConf{
    
    LimitClosePositionConfModel *model = [[LimitClosePositionConfModel alloc] init];
    model.CommodityID = [NSString stringWithFormat:@"%lld",limitClosePositionConf.CommodityID];
    model.FixedSpread = [NSString stringWithFormat:@"%f",limitClosePositionConf.FixedSpread];
    model.TPSpread = [NSString stringWithFormat:@"%f",limitClosePositionConf.TPSpread];
    model.SLSpread = [NSString stringWithFormat:@"%f",limitClosePositionConf.SLSpread];
    model.MinPriceUnit = [NSString stringWithFormat:@"%f",limitClosePositionConf.MinPriceUnit];
    model.AgreeUnit = [NSString stringWithFormat:@"%f",limitClosePositionConf.AgreeUnit];
    model.CommodityMode = [NSString stringWithFormat:@"%lld",limitClosePositionConf.CommodityMode];
    model.WeightRadio = [NSString stringWithFormat:@"%f",limitClosePositionConf.WeightRadio];
    return model;
}


@end
