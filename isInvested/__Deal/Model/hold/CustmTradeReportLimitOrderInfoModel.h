//
//  CustmTradeReportLimitOrderInfoModel.h
//  isInvested
//
//  Created by Ben on 16/12/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustmTradeReportLimitOrderInfoModel : NSObject

@property (nonatomic, assign)long long	tradedate;		///< 交易日
@property (nonatomic, assign)long long	limitorderid;	///< 限价单号
@property (nonatomic, assign)long long	createdate;		///< 下单时间
@property (nonatomic, assign)int		commodityid;	///< 商品标示
@property (nonatomic, assign)NSString *	commoditycode;	///< 商品编号
@property (nonatomic, assign)NSString *	commodityname;	///< 商品名称
@property (nonatomic, assign)int		openquantity;	///< 建仓数量
@property (nonatomic, assign)int		opendirector;	///< 建仓方向
@property (nonatomic, assign)int		limittype;		///< 类型
@property (nonatomic, assign)double		orderprice;		///< 限价
@property (nonatomic, assign)double		tpprice;		///< 止损价
@property (nonatomic, assign)double		slprice;		///< 止盈价
@property (nonatomic, assign)long long		deadline;		///< 期限
@property (nonatomic, assign)double		frozenreserve;	///< 冻结保证金
@property (nonatomic, assign)double		openweight;		///< 减仓总重量
@property (nonatomic, assign)long long		commoditymode;	///< 商品模式

+(CustmTradeReportLimitOrderInfoModel *)shareModelWithStruct:(CustmTradeReportLimitOrderInfo) stu;

@end
