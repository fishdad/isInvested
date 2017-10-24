//
//  CommodityInfoModel.h
//  商品信息
//

#import <Foundation/Foundation.h>

@interface CommodityInfoModel : NSObject

@property (nonatomic, strong) NSString *CommodityID;  ///< 商品ID
@property (nonatomic, strong) NSString *CommodityName;     ///< 商品名称
@property (nonatomic, strong) NSString *CommodityRight;   ///< 商品权限
@property (nonatomic, strong) NSString *TradeRight;   ///< 交易权限
@property (nonatomic, strong) NSString *AgreeUnit;    ///< 合约单位
@property (nonatomic, strong) NSString *Currency;     ///< 货币种类
@property (nonatomic, strong) NSString *MinQuoteChangeUnit;   ///< 最小行情变动单位
@property (nonatomic, strong) NSString *MinPriceUnit; ///< 最小价格单位
@property (nonatomic, strong) NSString *FixedSpread;  ///< 固定点差
@property (nonatomic, strong) NSString *BuyPrice;     ///< 买入价
@property (nonatomic, strong) NSString *SellPrice;    ///< 卖出价
@property (nonatomic, strong) NSString *HighPrice;    ///< 最高价
@property (nonatomic, strong) NSString *LowPrice;     ///< 最低价
@property (nonatomic, strong) NSString *QuoteTime;    ///< 报价时间
@property (nonatomic, strong) NSString *CommodityClass;   ///< 商品类型
@property (nonatomic, strong) NSString *CommodityClassName;    ///< 商品类型名称
@property (nonatomic, strong) NSString *CommodityMode;    ///< 处理方式 0-旧商品 1-新商品 2-特殊商品
@property (nonatomic, strong) NSString *IsDisplay;    ///< 是否展示
@property (nonatomic, strong) NSString *CommodityGroupID; ///< 商品组ID
@property (nonatomic, strong) NSString *CommodityGroupName;    ///< 商品组名称
@property (nonatomic, strong) NSString *WeightStep;   ///< 重量步进值
@property (nonatomic, strong) NSString * WeightRadio;  ///< 重量换算
@property (nonatomic, strong) NSString *TradeType;    ///< 交易类型
@property (nonatomic, strong) NSString *SpecificationRate;  ///< 规格系数
@property (nonatomic, strong) NSString *SpecificationUnit;  ///< 规格单位

+(CommodityInfoModel *)shareModelWithStruct:(CommodityInfo) commodityInfo;

@end
