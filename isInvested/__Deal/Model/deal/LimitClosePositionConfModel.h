//
//  LimitClosePositionConfModel.h
//  限价平仓单
//

#import <Foundation/Foundation.h>

@interface LimitClosePositionConfModel : NSObject

@property (nonatomic, strong) NSString *CommodityID;
@property (nonatomic, strong) NSString *FixedSpread;      ///< 固定点差
@property (nonatomic, strong) NSString *TPSpread;         ///< 止盈点差
@property (nonatomic, strong) NSString *SLSpread;         ///< 止损点差
@property (nonatomic, strong) NSString *MinPriceUnit;     ///< 最小价格单位
@property (nonatomic, strong) NSString *AgreeUnit;        ///< 合约单位
@property (nonatomic, strong) NSString *CommodityMode;    ///< 处理方式 0-旧商品 1-新商品 2-特殊商品
@property (nonatomic, strong) NSString *WeightRadio;      ///< 重量换算

+(LimitClosePositionConfModel *)shareModelWithStruct:(LimitClosePositionConf) limitClosePositionConf;

@end
