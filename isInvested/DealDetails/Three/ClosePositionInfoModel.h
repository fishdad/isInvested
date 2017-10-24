//
//  ClosePositionInfoModel.h
//  isInvested
//
//  Created by Ben on 16/12/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClosePositionInfoModel : NSObject

@property (nonatomic, assign)long long ClosePositionID;	///< 平仓单ID
@property (nonatomic, assign)int       CommodityID;		///< 商品ID
@property (nonatomic, strong)NSString *CommodityName;	///< 商品名称
@property (nonatomic, assign)int       CloseDirector;	///< 平仓方向
@property (nonatomic, assign)double    OpenPrice;		///< 建仓价
@property (nonatomic, assign)double    HoldPrice;		///< 持仓价
@property (nonatomic, assign)double    ClosePrice;		///< 平仓价
@property (nonatomic, assign)int       Quantity;			///< 持仓数量
@property (nonatomic, assign)double	  TotalWeight;		///< 持仓总重量
@property (nonatomic, assign)long long OpenPositionID;	///< 建仓单ID
@property (nonatomic, assign)double    CommissionAmount;	///< 手续费
@property (nonatomic, assign)long long OpenDate;			///< 建仓时间
@property (nonatomic, assign)long long CloseDate;		///< 平仓时间
@property (nonatomic, assign)int       MemberID;			///< 会员ID
@property (nonatomic, assign)int       OpenType;			///< 建仓类型  --- ::1:客户下单  --- 4:限价下单
@property (nonatomic, assign)int       CloseType;		///< 平仓类型  --- ::1:客户下单  --- 4:限价下单  --- 5:斩仓强平

// ---------------------------------------------------- 以下为历史Model

@property (nonatomic, assign)long long	tradedate;		///< 交易日
@property (nonatomic, assign)long long	holdpositionid;	///< 持仓单号
@property (nonatomic, assign)int	    commodityid;	///< 商品标示
@property (nonatomic, strong)NSString*	commoditycode;	///< 商品编号
@property (nonatomic, assign)int		closequantity;	///< 平仓数量
@property (nonatomic, assign)int		opendirector;	///< 建仓方向
@property (nonatomic, assign)long long	closepositionid;	///< 平仓单号
@property (nonatomic, assign)double		commission;		///< 手续费
@property (nonatomic, assign)double		opencommission;	///< 建仓手续费
@property (nonatomic, assign)int		commoditymode;	///< 商品类型

+(ClosePositionInfoModel *)shareModelWithStruct:(ClosePositionInfo) stu;

+(ClosePositionInfoModel *)shareHisModelWithStruct:(CustmTradeReportClosePositionInfo) stu;

@property (nonatomic, assign)CGFloat openProfit;		///< 浮动盈亏
@property (nonatomic, assign)CGFloat openProfitPer;		///< 浮动盈亏比

@property (nonatomic, copy) NSString *openCloseDate;

@property (nonatomic, copy) NSString *seconds;
@property (nonatomic, copy) NSString *days;
@end
