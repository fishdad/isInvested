//
//  LimitOrderInfoModel.h
//  isInvested
//
//  Created by Ben on 16/12/13.
//  Copyright © 2016年 Blue. All rights reserved.
//  LimitOrderInfoModel shareModelWithStruct

#import <Foundation/Foundation.h>

@interface LimitOrderInfoModel : NSObject

@property (nonatomic, assign)long long LimitOrderID;		///< 限价单ID
@property (nonatomic, assign)int       CommodityID;		///< 商品ID
@property (nonatomic, strong)NSString *CommodityName;		///< 商品名称
@property (nonatomic, assign)int       LimitType;		///< 限价单类型	--- ::1:限价建仓 ---2:止盈平仓  ---3:止损平仓
@property (nonatomic, assign)int       OrderType;		///< 建仓类型  --- ::1.客户下单
@property (nonatomic, assign)int       OpenDirector;		///< 建仓方向
@property (nonatomic, assign)double    OrderPrice;		///< 建仓价
@property (nonatomic, assign)double    SLPrice;			///< 止损价
@property (nonatomic, assign)double    TPPrice;			///< 止盈价
@property (nonatomic, assign)int       OpenQuantity;		///< 持仓数量
@property (nonatomic, assign)double	   TotalWeight;		///< 持仓总重量
@property (nonatomic, assign)long long CreateDate;		///< 建仓时间
@property (nonatomic, assign)long long ExpireType;		///< 失效类型
@property (nonatomic, assign)long long UpdateDate;		///< 更新时间
@property (nonatomic, assign)double    FreeszMargin;		///< 冻结保证金
@property (nonatomic, assign)int		  DealStatus;		///< 处理状态  ---1:限价单未成交 ---2:限价单已成交 ---3:限价单用户撤销 ---4:成交撤单 ---5:市价平仓撤销 ---6:斩仓撤销 ---7:限价平仓撤销 ---8:结算撤单 ---9:异常撤销 ---10:交割撤销

+(LimitOrderInfoModel *)shareModelWithStruct:(LimitOrderInfo) stu;

@property (nonatomic, copy) NSString *seconds;
@property (nonatomic, copy) NSString *days;
@end
