//
//  CustmTradeReportHoldPositionInfoModel.h
//  isInvested
//
//  Created by Ben on 16/12/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustmTradeReportHoldPositionInfoModel : NSObject

@property (nonatomic, assign)long long  tradedate;		///< 交易日
@property (nonatomic, assign)long long  holdpositionid;	///< 持仓单号
@property (nonatomic, assign)long long  opendate;		///< 建仓时间
@property (nonatomic, assign)int        commodityid;		///< 商品标示
@property (nonatomic, strong)NSString*  commoditycode;	///< 商品编号
@property (nonatomic, strong)NSString*  commodityname;	///< 商品名称
@property (nonatomic, assign)int        holdquantity;	///< 持仓数量
@property (nonatomic, assign)long long       opendirector;	///< 建仓方向
@property (nonatomic, assign)double     openprice;		///< 建仓价格
@property (nonatomic, assign)double     holdpositionpric;	///< 持仓价格
@property (nonatomic, assign)double     slprice;			///< 止损价
@property (nonatomic, assign)double     tpprice;			///< 止盈价
@property (nonatomic, assign)double     settlementpl;	///< 结算盈亏
@property (nonatomic, assign)double     commission;		///< 手续费
@property (nonatomic, assign)double     latefee;			///< 滞纳金
@property (nonatomic, assign)double     perfmargin;		///< 履约保证金
@property (nonatomic, assign)double     settleprice;		///< 结算价
@property (nonatomic, assign)long long        openquantity;	///< 建仓数量
@property (nonatomic, assign)double     holdweight;		///< 持仓总重量
@property (nonatomic, assign)double     openweight;		///< 建仓总重量
@property (nonatomic, assign)long long        commoditymode;	///< 商品类型

+(CustmTradeReportHoldPositionInfoModel *)shareModelWithStruct:(CustmTradeReportHoldPositionInfo) stu;

@end
