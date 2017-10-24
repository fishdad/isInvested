//
//  OpenMarketOrderConfModel.h
//  市价开仓单信息
//

#import <Foundation/Foundation.h>

@interface OpenMarketOrderConfModel : NSObject

@property (nonatomic, strong) NSString *CommodityID;      ///< 商品ID
@property (nonatomic, strong) NSString *MinQuantity;      ///< 每单最大交易手数
@property (nonatomic, strong) NSString *MaxQuantity;      ///< 每单最小交易手数
@property (nonatomic, strong) NSString *MinTradeRange;    ///< 市价单允许点差的最小值
@property (nonatomic, strong) NSString *MaxTradeRange;    ///< 市价单允许点差的最大值
@property (nonatomic, strong) NSString *DefaultTradeRange;    ///< 市价单允许点差的起始默认值
@property (nonatomic, strong) NSString *AgreeUnit;        ///< 合约单位
@property (nonatomic, strong) NSString *CommodityMode;    ///< 处理方式 0-旧商品 1-新商品 2-特殊商品
@property (nonatomic, strong) NSString *WeightStep;       ///< 重量步进值
@property (nonatomic, strong) NSString *WeightRadio;      ///< 重量换算
@property (nonatomic, strong) NSString *MinTotalWeight;   ///< 每单最小交易总重
@property (nonatomic, strong) NSString *MaxTotalWeight;   ///< 每单最大交易总重
@property (nonatomic, strong) NSString *DepositeRate;     ///< 准备金率
@property (nonatomic, strong) NSString *SpecificationRate;    ///< 规格系数

+(OpenMarketOrderConfModel *)shareModelWithStruct:(OpenMarketOrderConf) openMarketOrderConf;

@end
