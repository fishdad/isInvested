//
//  BuyOrderModel.h
//  isInvested
//
//  Created by Ben on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyOrderModel : NSObject

@property (nonatomic, copy) NSString *priceValue;//买入价格
@property (nonatomic, copy) NSString *indexPriceValue;//指价手动修改后的买入价格
@property (nonatomic, copy) NSString *allowPrice;//允许价差
@property (nonatomic, copy) NSString *weight;//买入重量
@property (nonatomic, copy) NSString *reservePrice;//履约手续
@property (nonatomic, copy) NSString *counterPrice;//手续费
@property (nonatomic, copy) NSString *canBuyWeight;//可以购买
@property (nonatomic, copy) NSString *unit;//单位
@property (nonatomic, copy) NSString *stopUp;//止盈
@property (nonatomic, copy) NSString *stopDown;//止损


@end
