//
//  OpenLimitOrderConfModel.h
//  限价开仓单信息
//

#import <Foundation/Foundation.h>

@interface OpenLimitOrderConfModel : NSObject

@property (nonatomic, strong) NSString *CommodityID;      ///< 商品ID
@property (nonatomic, strong) NSString *MinQuantity;      ///< 每单最小交易手数
@property (nonatomic, strong) NSString *MaxQuantity;      ///< 每单最大交易手数
@property (nonatomic, strong) NSString *LimitSpread;      ///< 限价点差
@property (nonatomic, strong) NSString *FixSpread;        ///< 固定点差
@property (nonatomic, strong) NSString *TPSpread;         ///< 止盈点差
@property (nonatomic, strong) NSString *SLSpread;         ///< 止损点差
@property (nonatomic, strong) NSString *MinPriceUnit;     ///< 最小价格单位
@property (nonatomic, strong) NSString *AgreeUnit;        ///< 合约单位
@property (nonatomic, strong) NSString *CommodityMode;    ///< 处理方式 0-旧商品 1-新商品 2-特殊商品
@property (nonatomic, strong) NSString *WeightStep;       ///< 重量步进值
@property (nonatomic, strong) NSString *WeightRadio;      ///< 重量换算
@property (nonatomic, strong) NSString *MinTotalWeight;   ///< 每单最小交易总重
@property (nonatomic, strong) NSString *MaxTotalWeight;   ///< 每单最大交易总重
@property (nonatomic, strong) NSString *DepositeRate;     ///< 准备金率
@property (nonatomic, strong) NSString *SpecificationRate;    ///< 规格系数

+(OpenLimitOrderConfModel *)shareModelWithStruct:(OpenLimitOrderConf) openLimitOrderConf;

@end
