//
//  HoldPositionInfoModel.m
//  isInvested
//
//  Created by Ben on 16/12/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "HoldPositionInfoModel.h"

@implementation HoldPositionInfoModel

+(HoldPositionInfoModel *)shareModelWithStruct:(HoldPositionInfo) stu{

    HoldPositionInfoModel *model = [[HoldPositionInfoModel alloc] init];
    model.HoldPositionID = stu.HoldPositionID;	///< 持仓单ID
    model.CommodityID = stu.CommodityID;		///< 商品ID
    model.CommodityName = [NSString stringWithUTF8String:stu.CommodityName];	///< 商品名称
    model.OpenType = stu.OpenType;			///< 建仓类型  --- ::1:客户下单  --- 4:限价下单
    model.OpenDirector = stu.OpenDirector;		///< 建仓方向
    model.Quantity = stu.Quantity;			///< 持仓数量
    model.TotalWeight = stu.TotalWeight;		///< 持仓总重量
    model.OpenPrice = stu.OpenPrice;		///< 建仓价格
    model.HoldPositionPrice = stu.HoldPositionPrice;	///< 持仓价
    model.ClosePrice = stu.ClosePrice;		///< 平仓价
    model.SLLimitOrderID = stu.SLLimitOrderID;	///< 止损单ID
    model.SLPrice = stu.SLPrice;			///< 止损价
    model.TPLimitOrderID = stu.TPLimitOrderID;	///< 止盈单ID
    model.TPPrice = stu.TPPrice;			///< 止盈价
    model.OpenProfit = stu.OpenProfit;		///< 浮动盈亏
    model.CommissionAmount = stu.CommissionAmount;	///< 手续费
    model.OpenDate = stu.OpenDate;			///< 建仓时间
    model.AgreeMargin = stu.AgreeMargin;		///< 履约保证金
    model.Freezemargin = stu.Freezemargin;		///< 冻结保证金
    model.OverdueFindFund = stu.OverdueFindFund;	///< 滞纳金

    return model;
}

/** 盈亏比 */
- (NSString *)settlementplPer {
    CGFloat value = self.OpenDirector == 1 ? self.ClosePrice - self.HoldPositionPrice : self.HoldPositionPrice - self.ClosePrice;
    return [NSString stringWithFormat:@"%.2f%%", value / self.OpenPrice * 100];
}

/** 平仓价 */
- (CGFloat)exitPrice {
    
    if (self.OpenDirector == 1) { //买涨
        
    } else { //买跌
        
    }
    
    return 0.0;
}

/** 保本价 */
- (CGFloat)breakevenPrice {
    
    if (self.OpenDirector == 1) { //买涨
        return self.HoldPositionPrice + 2 * self.OpenPrice * HandlingRate;
    } else { //买跌
        return self.HoldPositionPrice - 2 * self.OpenPrice * HandlingRate;
    }
}

- (NSString *)seconds {
    
    if (_seconds) return _seconds;
    
    _seconds = [@"yyyy-MM-dd HH:mm:ss" stringFromInterval1970:self.OpenDate];
    return _seconds;
}
- (NSString *)days {
    return [self.seconds substringToIndex:10];
}

MJExtensionLogAllProperties
@end
