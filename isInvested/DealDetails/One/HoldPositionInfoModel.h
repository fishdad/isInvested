//
//  HoldPositionInfoModel.h
//  isInvested
//
//  Created by Ben on 16/12/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HoldPositionInfoModel : NSObject

@property (nonatomic, assign)long long HoldPositionID;	///< 持仓单ID
@property (nonatomic, assign)int       CommodityID;		///< 商品ID
@property (nonatomic, strong)NSString *CommodityName;	///< 商品名称
@property (nonatomic, assign)int       OpenType;			///< 建仓类型  --- ::1:客户下单  --- 4:限价下单
@property (nonatomic, assign)int       OpenDirector;		///< 建仓方向
@property (nonatomic, assign)int       Quantity;			///< 持仓数量
@property (nonatomic, assign)double	  TotalWeight;		///< 持仓总重量
@property (nonatomic, assign)double    OpenPrice;		///< 建仓价格
@property (nonatomic, assign)double    HoldPositionPrice;	///< 持仓价
@property (nonatomic, assign)double    ClosePrice;		///< 平仓价
@property (nonatomic, assign)long long SLLimitOrderID;	///< 止损单ID
@property (nonatomic, assign)double    SLPrice;			///< 止损价
@property (nonatomic, assign)long long TPLimitOrderID;	///< 止盈单ID
@property (nonatomic, assign)double    TPPrice;			///< 止盈价
@property (nonatomic, assign)double    OpenProfit;		///< 浮动盈亏
@property (nonatomic, assign)double    CommissionAmount;	///< 手续费
@property (nonatomic, assign)long long OpenDate;			///< 建仓时间
@property (nonatomic, assign)double    AgreeMargin;		///< 履约保证金
@property (nonatomic, assign)double    Freezemargin;		///< 冻结保证金
@property (nonatomic, assign)double    OverdueFindFund;	///< 滞纳金

+(HoldPositionInfoModel *)shareModelWithStruct:(HoldPositionInfo) stu;

/** 盈亏比 */
@property (nonatomic, copy) NSString *settlementplPer;
/** 平仓价 */
@property (nonatomic, assign) CGFloat exitPrice;
/** 保本价 */
@property (nonatomic, assign) CGFloat breakevenPrice;

/** 开仓时间: + seconds */
@property (nonatomic, copy) NSString *seconds;
@property (nonatomic, copy) NSString *days;
@end
