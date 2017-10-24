//
//  AccountInfoModel.h
//  账户信息

#import <Foundation/Foundation.h>

@interface AccountInfoModel : NSObject

@property (nonatomic, strong) NSString *Account;    ///< 账户名
@property (nonatomic, strong) NSString *LoginAccount;   ///< 登录名
@property (nonatomic, strong) NSString *CustomerName;  ///< 客户名称
@property (nonatomic, strong) NSString *NAVPrice;            ///< 净值
@property (nonatomic, strong) NSString *Amount;              ///< 余额
@property (nonatomic, strong) NSString *OpenProfit;          ///< 浮动盈亏
@property (nonatomic, strong) NSString *ExchangeReserve;     ///< 交易准备金
@property (nonatomic, strong) NSString *PerformanceReserve;  ///< 履约准备金
@property (nonatomic, strong) NSString *FrozenReserve;       ///< 冻结准备金
@property (nonatomic, strong) NSString *RiskRate;            ///< 风险率

//结构体转model
+(AccountInfoModel *)shareModelWithStruct:(AccountInfo) accountInfo;

@end
