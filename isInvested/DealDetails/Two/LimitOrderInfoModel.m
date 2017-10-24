//
//  LimitOrderInfoModel.m
//  isInvested
//
//  Created by Ben on 16/12/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "LimitOrderInfoModel.h"

@implementation LimitOrderInfoModel

+(LimitOrderInfoModel *)shareModelWithStruct:(LimitOrderInfo) stu{

    LimitOrderInfoModel *model = [[LimitOrderInfoModel alloc] init];
    model.LimitOrderID = stu.LimitOrderID;		///< 限价单ID
    model.CommodityID = stu.CommodityID;		///< 商品ID
    model.CommodityName = [NSString stringWithUTF8String:stu.CommodityName];		///< 商品名称
    model.LimitType = stu.LimitType;		///< 限价单类型	--- ::1:限价建仓 ---2:止盈平仓  ---3:止损平仓
    model.OrderType = stu.OrderType;		///< 建仓类型  --- ::1.客户下单
    model.OpenDirector = stu.OpenDirector;		///< 建仓方向
    model.OrderPrice = stu.OrderPrice;		///< 建仓价
    model.SLPrice = stu.SLPrice;			///< 止损价
    model.TPPrice = stu.TPPrice;			///< 止盈价
    model.OpenQuantity = stu.OpenQuantity;		///< 持仓数量
    model.TotalWeight = stu.TotalWeight;		///< 持仓总重量
    model.CreateDate = stu.CreateDate;		///< 建仓时间
    model.ExpireType = stu.ExpireType;		///< 失效类型
    model.UpdateDate = stu.UpdateDate;		///< 更新时间
    model.FreeszMargin = stu.FreeszMargin;		///< 冻结保证金
    model.DealStatus = stu.DealStatus;		///< 处理状态  ---1:限价单未成交 ---2:限价单已成交 ---3:限价单用户撤销 ---4:成交撤单 ---5:市价平仓撤销 ---6:斩仓撤销 ---7:限价平仓撤销 ---8:结算撤单 ---9:异常撤销 ---10:交割撤销

    return model;
}

- (NSString *)seconds {
    
    if (_seconds) return _seconds;
    
    _seconds = [@"yyyy-MM-dd HH:mm:ss" stringFromInterval1970:self.CreateDate];
    return _seconds;
}
- (NSString *)days {
    return [self.seconds substringToIndex:10];
}

MJExtensionLogAllProperties
@end
