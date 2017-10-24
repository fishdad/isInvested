//
//  CustmTradeReportHoldPositionInfoModel.m
//  isInvested
//
//  Created by Ben on 16/12/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CustmTradeReportHoldPositionInfoModel.h"

@implementation CustmTradeReportHoldPositionInfoModel

+(CustmTradeReportHoldPositionInfoModel *)shareModelWithStruct:(CustmTradeReportHoldPositionInfo) stu{

    CustmTradeReportHoldPositionInfoModel *model = [[CustmTradeReportHoldPositionInfoModel alloc] init];
    
    model.tradedate = stu.tradedate;		///< 交易日
    model.holdpositionid = stu.holdpositionid;	///< 持仓单号
    model.opendate = stu.opendate;		///< 建仓时间
    model.commodityid = stu.commodityid;		///< 商品标示
    model.commoditycode = [NSString stringWithUTF8String:stu.commoditycode];	///< 商品编号
    model.commodityname = [NSString stringWithUTF8String:stu.commodityname];	///< 商品名称
    model.holdquantity = stu.holdquantity;	///< 持仓数量
    model.opendirector = stu.opendirector;	///< 建仓方向
    model.openprice = stu.openprice;		///< 建仓价格
    model.holdpositionpric = stu.holdpositionpric;	///< 持仓价格
    model.slprice = stu.slprice;			///< 止损价
    model.tpprice = stu.tpprice;			///< 止盈价
    model.settlementpl = stu.settlementpl;	///< 结算盈亏
    model.commission = stu.commission;		///< 手续费
    model.latefee = stu.latefee;			///< 滞纳金
    model.perfmargin = stu.perfmargin;		///< 履约保证金
    model.settleprice = stu.settleprice;		///< 结算价
    model.openquantity = stu.openquantity;	///< 建仓数量
    model.holdweight = stu.holdweight;		///< 持仓总重量
    model.openweight = stu.openweight;		///< 建仓总重量
    model.commoditymode = stu.commoditymode;	///< 商品类型

    return model;
}

@end
