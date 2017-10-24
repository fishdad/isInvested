//
//  CustmTradeReportLimitOrderInfoModel.m
//  isInvested
//
//  Created by Ben on 16/12/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CustmTradeReportLimitOrderInfoModel.h"

@implementation CustmTradeReportLimitOrderInfoModel

+(CustmTradeReportLimitOrderInfoModel *)shareModelWithStruct:(CustmTradeReportLimitOrderInfo) stu{

    CustmTradeReportLimitOrderInfoModel *model= [[CustmTradeReportLimitOrderInfoModel alloc] init];
    model.tradedate = stu.tradedate;		///< 交易日
    model.limitorderid = stu.limitorderid;	///< 限价单号
    model.createdate = stu.createdate;		///< 下单时间
    model.commodityid = stu.commodityid;	///< 商品标示
    model.commoditycode = [NSString stringWithUTF8String:stu.commoditycode];	///< 商品编号
    model.commodityname = [NSString stringWithUTF8String:stu.commodityname];	///< 商品名称
    model.openquantity = stu.openquantity;	///< 建仓数量
    model.opendirector = stu.opendirector;	///< 建仓方向
    model.limittype = stu.limittype;		///< 类型
    model.orderprice = stu.orderprice;		///< 限价
    model.tpprice = stu.tpprice;		///< 止损价
    model.slprice = stu.slprice;		///< 止盈价
    model.deadline = stu.deadline;		///< 期限
    model.frozenreserve = stu.frozenreserve;	///< 冻结保证金
    model.openweight = stu.openweight;		///< 减仓总重量
    model.commoditymode = stu.commoditymode;	///< 商品模式
    
    return model;
}

@end
