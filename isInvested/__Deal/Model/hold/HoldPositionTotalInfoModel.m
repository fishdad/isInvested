//
//  HoldPositionTotalInfoModel.m
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "HoldPositionTotalInfoModel.h"

@implementation HoldPositionTotalInfoModel

+(HoldPositionTotalInfoModel *)shareModelWithStruct:(HoldPositionTotalInfo) stu{
    
    
    HoldPositionTotalInfoModel *model = [[HoldPositionTotalInfoModel alloc] init];
    model.CommodityID = [NSString stringWithFormat:@"%d",stu.CommodityID];
    model.CommodityName = [NSString stringWithUTF8String:stu.CommodityName];
    model.OpenDirector = stu.OpenDirector;
    model.Quantity = [NSString stringWithFormat:@"%lld",stu.Quantity];
    model.TotalWeight = [NSString stringWithFormat:@"%f",stu.TotalWeight];
    model.OpenPriceTotal = [NSString stringWithFormat:@"%f",stu.OpenPriceTotal];
    model.AvgOpenPrice = [NSString stringWithFormat:@"%f",stu.AvgOpenPrice];
    model.HoldPriceTotal = [NSString stringWithFormat:@"%f",stu.HoldPriceTotal];
    model.AvgHoldPrice = [NSString stringWithFormat:@"%f",stu.AvgHoldPrice];
    model.ClosePrice = [NSString stringWithFormat:@"%f",stu.ClosePrice];
    model.OpenProfit = [NSString stringWithFormat:@"%f",stu.OpenProfit];

    return model;
}


@end
