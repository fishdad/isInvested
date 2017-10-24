//
//  ClosePositionInfoModel.m
//  isInvested
//
//  Created by Ben on 16/12/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ClosePositionInfoModel.h"

@implementation ClosePositionInfoModel

+(ClosePositionInfoModel *)shareModelWithStruct:(ClosePositionInfo) stu{

    ClosePositionInfoModel *model = [[ClosePositionInfoModel alloc] init];
    model.ClosePositionID = stu.ClosePositionID;	///< 平仓单ID
    model.CommodityID = stu.CommodityID;		///< 商品ID
    model.CommodityName = [NSString stringWithCString:stu.CommodityName encoding:NSUTF8StringEncoding];	///< 商品名称
    model.CloseDirector = stu.CloseDirector;	///< 平仓方向
    model.OpenPrice = stu.OpenPrice;		///< 建仓价
    model.HoldPrice = stu.HoldPrice;		///< 持仓价
    model.ClosePrice = stu.ClosePrice;		///< 平仓价
    model.Quantity = stu.Quantity;			///< 持仓数量
    model.TotalWeight = stu.TotalWeight;		///< 持仓总重量
    model.OpenPositionID = stu.OpenPositionID;	///< 建仓单ID
    model.CommissionAmount = stu.CommissionAmount;	///< 手续费
    model.OpenDate = stu.OpenDate;			///< 建仓时间
    model.CloseDate = stu.CloseDate;		///< 平仓时间
    model.MemberID = stu.MemberID;			///< 会员ID
    model.OpenType = stu.OpenType;			///< 建仓类型  --- ::1:客户下单  --- 4:限价下单
    model.CloseType = stu.CloseType;		///< 平仓类型  --- ::1:客户下单  --- 4:限价下单  --- 5:斩仓强平

    return model;
}

+(ClosePositionInfoModel *)shareHisModelWithStruct:(CustmTradeReportClosePositionInfo) stu {
    
    ClosePositionInfoModel *model = [[ClosePositionInfoModel alloc] init];

    model.CommodityName = [NSString stringWithUTF8String:stu.commodityname];	///< 商品名称
    model.OpenPrice = stu.openprice;		///< 建仓价格
    model.HoldPrice = stu.holdpositionpric;	///< 持仓价格
    model.CloseDirector = stu.closedirector;	///< 平仓方向
    model.ClosePrice = stu.closeprice;		///< 平仓价格
    model.openProfit = stu.profitorloss;	///< 盈亏
    model.TotalWeight = stu.closeweight;	///< 平仓总重量
    model.OpenDate = stu.opendate;		///< 建仓时间
    model.CloseDate = stu.closedate;		///< 平仓时间
    model.CommodityID = stu.commodityid;	///< 商品标示
    
//    model.tradedate = stu.tradedate;		///< 交易日
//    model.holdpositionid = stu.holdpositionid;	///< 持仓单号
//    model.commoditycode = [NSString stringWithUTF8String:stu.commoditycode];	///< 商品编号
//    model.closequantity = stu.closequantity;	///< 平仓数量
//    model.opendirector = stu.opendirector;	///< 建仓方向
//    model.closepositionid = stu.closepositionid;	///< 平仓单号
//    model.commission = stu.commission;		///< 手续费
//    model.opencommission = stu.opencommission;	///< 建仓手续费
//    model.commoditymode = stu.commoditymode;	///< 商品类型
    
    return model;
}

- (CGFloat)openProfit {
    
    NSString *weightRadio = [NSUserDefaults objectForKey:[NSString stringWithFormat:@"%dWeightRadio", self.CommodityID]];
    if (self.CloseDirector == 1) { //买
        return (self.HoldPrice - self.ClosePrice) * self.TotalWeight * weightRadio.floatValue;
    } else { //卖
        return (self.ClosePrice - self.HoldPrice) * self.TotalWeight * weightRadio.floatValue;
    }
}
- (CGFloat)openProfitPer {
    
    if (self.CloseDirector == 1) { //买
        return (self.HoldPrice - self.ClosePrice) / self.HoldPrice * 100;
    } else { //卖
        return (self.ClosePrice - self.HoldPrice) / self.HoldPrice * 100;
    }
}

- (NSString *)openCloseDate {
    
    return [NSString stringWithFormat:@"    开/平: %@ / %@",
            [@"yyyy-MM-dd HH:mm:ss" stringFromInterval1970:self.OpenDate],
            [@"yyyy-MM-dd HH:mm:ss" stringFromInterval1970:self.CloseDate]];
}

- (NSString *)seconds {
    
    if (_seconds) return _seconds;
    
    _seconds = [@"yyyy-MM-dd HH:mm:ss" stringFromInterval1970:self.CloseDate];
    return _seconds;
}
- (NSString *)days {
    return [self.seconds substringToIndex:10];
}

MJExtensionLogAllProperties
@end
