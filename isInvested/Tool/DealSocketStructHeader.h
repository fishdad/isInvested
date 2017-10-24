//
//  DealSocketStructHeader.h
//  isInvested
//
//  Created by Ben on 16/10/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#ifndef DealSocketStructHeader_h
#define DealSocketStructHeader_h

//结构体中的数据类型double  8字节 int  4字节 short  2字节 longlong  8字节 Char 1字节

#define PACKET_FLAG_NUM 4
#define USERNAME_LENGTH 16
#define USER_PWD 11
#define FUND_PWD 7

#define  MAX_CUSTOMERNAME_LEN             128
#define  MAX_COMMODITYNAME_LEN            128
#define  MAX_COMMODITYCODE_LEN            16
#define  MAX_COMMODITYTYPE_LEN            16
#define  MAX_LOGINACCONT_LEN              32
#define  MAX_MESSAGE_LEN                  512

#define  MAX_BULLETIN_HEADER_LEN          128
#define  MAX_BULLETIN_CONTENT_LEN         4000
#define  MAX_PUBLISHERNAME_LEN            64

#define  MAX_BANKPWD_LEN                  128
#define  MAX_FUNDPWD_LEN                  128
//#define  MAX_LOGINPWD_LEN                 128
#define  MAX_BANKACCNT_LEN                32
#define  MAX_BANKNAME_LEN                 64
#define  MAX_CERTNUMBER_LEN               32
#define  MAX_SPECIFICATIONUNIT_LEN        16
#define  MAX_OP_LOGIN_ACCOUNT_LEN         64
#define  MAX_APPDES_LEN                      128
#define  MAX_MONEYINOUT_MSG_LEN           128
#define  MAX_MONEYINOUT_SID_LEN           72
#define  MAX_MONEYINOUT_URL_LEN           264
#define  MAX_DELICOMM_LEN                 5
#define  MAX_STRSID_LEN                   32
#define  MAX_TICKET_LEN                   256
#define  MAX_IDENTIFYCODE_LEN                 16
#define  MAX_IP_LEN                       128
#define  MAX_FUNDFLOW_REMARK_LEN          64

//xinle 2016.11.03先手工设定手续费率为 万分之八
#define HandlingRate 0.0008
//操作枚举
typedef NS_ENUM(unsigned short, DealType) {
    RT_LOGIN                       = 0x0100, //登录
    GET_ACCNTINFO                  = 0x0101, //获取账号信息
    GET_MARKETSTATUS               = 0x0102, //获取市场开休市状态
    GET_OPENMARKETCONF             = 0x0103, //根据商品ID，获取其市价建仓的配置信息
    GET_CLOSEMARKETCONF            = 0x0104, //根据商品ID，获取其市价平仓的配置信息
    GET_OPENLIMITCONF              = 0x0105, //根据商品ID，获取其限价建仓的配置信息
    GET_CLOSELIMITCONF             = 0x0106, //根据商品ID，获取其限价平仓的配置信息
    GET_OPENDELIVERYCONF           = 0x0107, //根据商品ID，获取交割的配置信息
    REQ_QUOTE                      = 0x0108, //获取行情报价
    REQ_HEARTBEAT                  = 0x0110, //心跳表示 检测与客户端通信是否正常
    REQ_CHANGELOGINPWD             = 0x0111, //修改登录密码
    REQ_CHANGEFUNDPWD              = 0x0112, //修改资金密码
    
    //-------------交易实际的逻辑-----------
    REQ_OPENMARKET                 = 0x0116, //市价单建仓
    REQ_OPENLIMIT                  = 0x0119, //限价建仓
    GET_HOLDPOSITIONTOTAL          = 0x0115, //获取持仓单总量
    REQ_CLOSEMARKET                = 0x0117, //市价单平仓
    REQ_CLOSEMARETMANY             = 0x0118, //批量平仓
    REQ_CLOSELIMIT                 = 0x0120, //限价平仓
    REQ_LIMITREVOKE                = 0x0125, //限价单撤销
    GET_MONEYQUERY                 = 0x0126, //查询银行资金
    REQ_MONEYINOUT                 = 0x0127, //出入金
    GET_FUNDFLOWQUERY              = 0x0128, //出入金查询请求
    PUSH_SYSBULLETIN               = 0x0129, //系统公告
    GET_SIGNRESULTNOTIFYQUERY      = 0x0130, //签约结果通知
    REQ_PAYFORWARD                 = 0x0131, //支付推进
    PUSH_PAYFORWARDRESULT          = 0x0134, //支付推进结果
    REQ_QUOTEBYID                  = 0x0132, //根据商品ID获取行情报价
    PUSH_SYSBUL_LIMITCLOSE         = 0x0133, //限价成交通知
    
    GET_CUSTMTRADEREPORTHOLDPOSITOIN        = 0x0122, //客户交易报表持仓单查询请求(历史)
    GET_CUSTMTRADEREPORTCLOSEPOSITOIN       = 0x0123, //客户交易报表平仓单查询请求(历史)
    GET_CUSTMTRADEREPORTLIMITORDER          = 0x0124, //客户交易报表限价单查询请求(暂时没有)
    REQ_HOLDPOSITION                        = 0x0109, //持仓单信息(实时)
    GET_CLOSEORDERS                         = 0x0114, //获取平仓信息(实时)
    GET_LIMITORDERS                         = 0x0113, //获取限价单信息(实时)
    
    REQ_ERROR                               = 0x0135, //请求错误
    
};

//买卖方向
typedef NS_ENUM(int, OPENDIRECTOR_DIRECTION)
{
    OPENDIRECTOR_BUY    = 1,		///< 1:买
    OPENDIRECTOR_SELL   = 2,		///< 2:卖
};
//出入金
typedef NS_ENUM(int, MONEY_DIRECTION){
    MONEY_OUT			= 1,		///< 1:出金
    MONEY_IN			= 2,		///< 2:入金
};
//限价
typedef NS_ENUM(int, LIMITTYPE){
    LIMITTYPE_OPENLIMIT  = 1,		///< 1:限价建仓
    LIMITTYPE_SL_CLOSE   = 3,		///< 3:限价止损平仓
    LIMITTYPE_TP_CLOSE   = 2,		///< 2:限价止盈平仓
};

typedef NS_ENUM(int, BANKTYPE)
{
    BANK_OF_CHINA		= 3,		///< 3:中国银行
    BANK_163EPAY		= 23, 		///< 23:网易宝
    BANK_SINAPAY		= 24,		///< 24:新浪支付
};

//const char PACKET_FLAG[] = "JACK";

//2.请求和解析数据时 用下面的结构体
#pragma pack(1)
typedef struct PackHead
{
    char m_strHead[4];           //里面放 "JACK"
    int  m_iLength;           //表示整个完整的数据包的长度
    unsigned short      m_iType;         // 请求类型
    unsigned short      m_bsucessFromSrv;//服务器设置 请求是否成功 0:失败   1:成功
}ansPackHead;

//2.<1>用RT_LOGIN登录时 m_data放的是下面的结构体
#pragma pack(1)
typedef struct User
{
    char            m_strUser[USERNAME_LENGTH];   // 用户名
    char            m_strPwd[USER_PWD];    // 密码
}ansUserAcc;

//返回的账户信息：
#pragma pack(1)
typedef struct _ACCOUNT_INFO
{
    char   Account[MAX_LOGINACCONT_LEN];    ///< 账户名
    char   LoginAccount[MAX_LOGINACCONT_LEN];   ///< 登录名
    char   CustomerName[MAX_CUSTOMERNAME_LEN];  ///< 客户名称
    double NAVPrice;            ///< 净值
    double Amount;              ///< 余额
    double OpenProfit;          ///< 浮动盈亏
    double ExchangeReserve;     ///< 交易准备金
    double PerformanceReserve;  ///< 履约准备金
    double FrozenReserve;       ///< 冻结准备金
    double RiskRate;            ///< 风险率
}AccountInfo;

//返回的行情信息：此结构体要八字节对齐
#pragma pack(8)
typedef struct _COMMODITY_INFO
{
    int       CommodityID;  ///< 商品ID
    char      CommodityName[132];     ///< 商品名称
    long long CommodityRight;   ///< 商品权限
    long long TradeRight;   ///< 交易权限
    double    AgreeUnit;    ///< 合约单位
    long long Currency;     ///< 货币种类
    double    MinQuoteChangeUnit;   ///< 最小行情变动单位
    double    MinPriceUnit; ///< 最小价格单位
    double    FixedSpread;  ///< 固定点差
    double    BuyPrice;     ///< 买入价
    double    SellPrice;    ///< 卖出价
    double    HighPrice;    ///< 最高价
    double    LowPrice;     ///< 最低价
    long long QuoteTime;    ///< 报价时间
    int       CommodityClass;   ///< 商品类型
    char      CommodityClassName[MAX_COMMODITYNAME_LEN];    ///< 商品类型名称
    int       CommodityMode;    ///< 处理方式 0-旧商品 1-新商品 2-特殊商品
    int       IsDisplay;    ///< 是否展示
    int       CommodityGroupID; ///< 商品组ID
    char      CommodityGroupName[MAX_COMMODITYNAME_LEN];    ///< 商品组名称
    double    WeightStep;   ///< 重量步进值
    double    WeightRadio;  ///< 重量换算
    long long       TradeType;    ///< 交易类型
    double    SpecificationRate;  ///< 规格系数
    char      SpecificationUnit[MAX_SPECIFICATIONUNIT_LEN];  ///< 规格单位
}CommodityInfo;



//<3>用GET_OPENMARKETCONF、GET_CLOSEMARKETCONF、GET_OPENLIMITCONF、GET_CLOSELIMITCONF、GET_OPENDELIVERYCONF请求时m_data放置商品ID，商品ID是int类型 例如100000002 ,用 GET_OPENDELIVERYCONF 请求时传递下面结构体参数
#pragma pack(8)
typedef struct DeliveryOrderConf
{
    long long m_CommodityID; //交易商品ID 4 8
    double m_HoldWeight;//点数 8 8
    double m_HoldPrice;//价格 8 8
}OpenOrderConf;

//市价单建仓配置信息结构体
#pragma pack(8)
typedef struct _OPENMARKETORDER_CONF
{
    long long       CommodityID;      ///< 商品ID 4 8
    double    MinQuantity;      ///< 每单最大交易手数 8 8
    double    MaxQuantity;      ///< 每单最小交易手数 8 8
    double    MinTradeRange;    ///< 市价单允许点差的最小值 8 8
    double    MaxTradeRange;    ///< 市价单允许点差的最大值 8 8
    double    DefaultTradeRange;    ///< 市价单允许点差的起始默认值 8 8
    double    AgreeUnit;        ///< 合约单位 8 8
    long long       CommodityMode;    ///< 处理方式 0-旧商品 1-新商品 2-特殊商品 4 8
    double    WeightStep;       ///< 重量步进值 8 8
    double    WeightRadio;      ///< 重量换算 8 8
    double    MinTotalWeight;   ///< 每单最小交易总重 8 8
    double    MaxTotalWeight;   ///< 每单最大交易总重 8 8
    double    DepositeRate;     ///< 准备金率 8 8
    double    SpecificationRate;    ///< 规格系数 8 8
}OpenMarketOrderConf;

/// 市价单平仓配置信息结构体
#pragma pack(8)
typedef struct _CLOSEMARKETORDER_CONF
{
    long long       CommodityID;      ///< 商品ID int
    double    MinQuantity;      ///< 每单最小交易手数
    double    MaxQuantity;      ///< 每单最大交易手数
    double    MinTradeRange;    ///< 市价单允许点差的最小值
    double    MaxTradeRange;    ///< 市价单允许点差的最大值
    double    DefaultTradeRange;    ///< 市价单允许点差的起始默认值
    double    AgreeUnit;        ///< 合约单位
    long long       CommodityMode;    ///< 处理方式 0-旧商品 1-新商品 2-特殊商品
    double    WeightStep;       ///< 重量步进值
    double    WeightRadio;      ///< 重量换算
    double    MinTotalWeight;   ///< 每单最小交易总重
    double    MaxTotalWeight;   ///< 每单最大交易总重
    double    DepositeRate;     ///< 准备金率
    double    SpecificationRate;    ///< 规格系数
}CloseMarketOrderConf;

/// 限价单建仓配置信息结构体
#pragma pack(8)
typedef struct _OPENLIMITORDER_CONF
{
    long long CommodityID;      ///< 商品ID int
    double    MinQuantity;      ///< 每单最小交易手数
    double    MaxQuantity;      ///< 每单最大交易手数
    double    LimitSpread;      ///< 限价点差
    double    FixSpread;        ///< 固定点差
    double    TPSpread;         ///< 止盈点差
    double    SLSpread;         ///< 止损点差
    double    MinPriceUnit;     ///< 最小价格单位
    double    AgreeUnit;        ///< 合约单位
    long long       CommodityMode;    ///< 处理方式 0-旧商品 1-新商品 2-特殊商品
    double    WeightStep;       ///< 重量步进值
    double    WeightRadio;      ///< 重量换算
    double    MinTotalWeight;   ///< 每单最小交易总重
    double    MaxTotalWeight;   ///< 每单最大交易总重
    double    DepositeRate;     ///< 准备金率
    double    SpecificationRate;    ///< 规格系数
}OpenLimitOrderConf;

/// 限价单平仓配置信息结构体
#pragma pack(8)
typedef struct _LIMITCLOSEPOSITION_CONF
{
    long long       CommodityID;      ///< 商品ID int
    double    FixedSpread;      ///< 固定点差
    double    TPSpread;         ///< 止盈点差
    double    SLSpread;         ///< 止损点差
    double    MinPriceUnit;     ///< 最小价格单位
    double    AgreeUnit;        ///< 合约单位
    long long       CommodityMode;    ///< 处理方式 0-旧商品 1-新商品 2-特殊商品 int
    double    WeightRadio;      ///< 重量换算
}LimitClosePositionConf;

#pragma pack(1)
typedef struct _DELIVERYCOMMODITY
{
    int   CommodityID;  ///< 交割商品ID
    char  CommodityName[MAX_COMMODITYNAME_LEN]; ///< 交割商品名称
    int   TradecommodityClassID;    ///< 交割商品类型
    double  DeliveryRadio;      ///< 交割手续费比例
}DeliveryCommodity;

/// 交割申请配置信息结构体
#pragma pack(1)
typedef struct _OPENDELIVERYORDER_CONF
{
    int  CommodityID;       ///< 交易商品ID
    
    int  CanDeliver;        ///< 是否能交割     ---0:不能交割       ---1-能交割
    double  AgreeUnit;      ///< 合约单位
    double  DeliveryCharge; ///<  交割货款
//    DeliveryCommodity DeliveryCommodity[MAX_DELICOMM_LEN];     ///< 交易商品对应的交割商品信息
    DeliveryCommodity DeliveryCommodity;     ///< 交易商品对应的交割商品信息
    int  DeliCommCnt;       ///<  对应交割商品总数 [0,n)
}OpenDeliveryOderConf;

#pragma pack(1)
//修改交易的密码
typedef struct ChangePwd
{
    char            m_strOldPwd[USER_PWD];    //旧 密码
    char            m_strNewPwd[USER_PWD];    // 新密码
    int             m_imarketType; //市场类型
}ChangePWD;

#pragma pack(1)
//修改资金的密码
typedef struct ChangePwdFund
{
    char            m_strOldPwd[FUND_PWD];    //旧 密码
    char            m_strNewPwd[FUND_PWD];    // 新密码
}ChangeFundPWD;

//=========================================================== REQ_OPENMARKET 市价单建仓   请求是参数
/// 市价单建仓
#pragma pack(8)
typedef struct _OPENMARKETORDER_PARAM
{
    int nCommodityID;		///< 商品ID
    int nOpenDirector;		///< 建仓方向		--- ::OPENDIRECTOR_BUY:买  --- OPENDIRECTOR_SELL:卖
    double dbPrice;			///< 建仓单价
    double dbWeight;		///< 交易重量(kg)
    long long nQuantity;			///< 交易数量 int
    double dbTradeRange;	///< 最大点差
    //int nOrderType;			///< 下单类型		---1:客户下单
}OpenMarketOrderParam;

//<15> REQ_OPENLIMIT   限价建仓  请求参数
/// 限价单建仓入参结构体
#pragma pack(8)
typedef struct _OPENLIMITODER_PARAM
{
    int nCommodityID;			///< 商品ID
    int nExpireType;			///< 过期类型		--- 1:当日有效
    long long nOpenDirector;			///< 建仓方向		--- ::OPENDIRECTOR_BUY:买  --- OPENDIRECTOR_SELL:卖
    double dbWeight;			///< 交易重量(kg)
    long long nQuantity;				///< 建仓数量
    //int nOrderType;				///< 下单类型		--- 1:客户下单
    double dbOrderPrice;		///< 建仓单价
    double dbTPPrice;			///< 止盈价格
    double dbSLPrice;			///< 止损价格
}OpenLimitOrderParam;

//<10> GET_HOLDPOSITIONTOTAL  获取持仓单总量 解析用
/// 持仓汇总单信息结构体
#pragma pack(8)
typedef struct _HOLDPOSITION_TOTAL_INFO
{
    int    CommodityID;			///< 商品ID
    char   CommodityName[MAX_COMMODITYNAME_LEN];	///<  商品名称
    int    OpenDirector;		///< 建仓方向
    long long    Quantity;			///< 持仓数量
    double TotalWeight;			///< 持仓总重量
    double OpenPriceTotal;		///< 建仓总值
    double AvgOpenPrice;		///< 建仓均价
    double HoldPriceTotal;		///< 持仓总值
    double AvgHoldPrice;		///< 持仓均价
    double ClosePrice;			///< 平仓价
    double OpenProfit;			///< 浮动盈亏
    
}HoldPositionTotalInfo;

//<12> REQ_CLOSEMARKET 市价单平仓  请求参数
/// 市价平仓单入参结构体
#pragma pack(8)
typedef struct _CLOSEMARKETORDER_PARAM
{
    long long nHoldPositionID;		///< 持仓ID
    long long nCommodityID;				///< 商品ID
    double dbWeight;				///< 交易重量(kg)
    int nQuantity;					///< 平仓数量
    int nTradeRange;				///< 最大点差
    double dbPrice;					///< 平仓价格
    //int nClosePositionType;			///< 平仓类型		--- 1:客户下单
}CloseMarketOrderParam;

//<14>REQ_CLOSEMARETMANY  批量平仓 请求参数
/// 批量平仓入参结构体
#pragma pack(8)
typedef struct _CLOSEMARKETORDERMANY_PARAM
{
    long long nCommodityID;			///< 商品ID
    double dbWeight;			///< 交易重量(kg)
    int nQuantity;				///< 平仓数量
    int nTradeRange;			///< 最大点差
    double dbPrice;				///< 平仓价格
    //int nClosePositionType;		///< 平仓类型		--- 1:一般平仓
    long long nCloseDirector;			///< 平仓方向		--- ::OPENDIRECTOR_BUY:买  --- OPENDIRECTOR_SELL:卖
}CloseMarketOrderManyParam;

//<16> REQ_CLOSELIMIT   限价平仓  请求参数
/// 限价单平仓入参结构体
#pragma pack(8)
typedef struct _CLOSELIMITORDER_PARAM
{
    long long nCommodityID;			///< 商品ID
    double dbClosePrice;		///< 平仓单价
    long long nExpireType;			///< 过期类型		--- 1:当日有效
    long long nHoldPositionID;	///< 持仓ID
    //int nOrderType;				///< 下单类型		--- 1:客户下单
    double dbSLPrice;			///< 止损价格
    double dbTPPrice;			///< 止盈价格
}CloseLimitOrderParam;

//<21> REQ_LIMITREVOKE   限价单撤销   请求参数
/// 限价单撤销入参结构体
#pragma pack(8)
typedef struct _LIMITREVOKE_PARAM
{
    long long nLimitOrderID;	///< 限价单ID
    int nCommodityID;			///< 商品ID
    //int nOrderType;				///< 下单类型		--- 1:客户下单
    int nLimitType;				///< 限价单类型		--- ::LIMITTYPE_OPENLIMIT:建仓  --- LIMITTYPE_TP_CLOSE:止盈  --- LIMITTYPE_SL_CLOSE:止损
}LimitRevokeParam;

#pragma mark -- 出入金 & 查询

//<22>GET_MONEYQUERY   //查询银行资金  解析结构体用
/// 交易所余额信息
#pragma pack(8)
typedef struct _BOURSEMONEY_INFO
{
    double Amount;				///< 交易所余额
    double AmountAvailable;		///< 交易所可用资金
    double AmountFetchable;		///< 交易所可提取资金
}BourseMoneyInfo;

//<23>REQ_MONEYINOUT    出入金  请求参数
/// 出入金入参结构体
#pragma pack(8)
typedef struct	_MONEYINOUT_PARAM
{
    int OperateType;			///< 出入金类型		--- ::MONEY_OUT:出金  --- MONEY_IN:入金
    int Currency;				///< 币种		--- 1:人民币
    double Amount;				///< 出入金数量
    char FundPsw[MAX_FUNDPWD_LEN];	///< 资金密码
    char BankPsw[MAX_BANKPWD_LEN];	///< 银行密码
    char Reversed[MAX_IP_LEN];		///< 特殊会员用于传入IP
    int PayType;                    ///< 支付类型 仅用于新浪支付 ---0:普通出入金 ---1:余额支付 ---:2绑卡支付
    int OperateFlag;                ///< 操作标志 仅用于新浪支付 ---0:普通出入金 ---1:红包入金
}MoneyInOutParam;//成功时  解析用
///出入金请求返回信息
#pragma pack(8)
typedef struct _MONEYINOUT_INFO
{
    int		  RetCode;    ///< 返回码
    char	  StrSid[MAX_STRSID_LEN + 1];    ///< SID
    char	  LocalSid[MAX_MONEYINOUT_SID_LEN];  ///< 新增LocalSid
    char	  BankSid[MAX_MONEYINOUT_SID_LEN];   ///< 新增BankSid
    char	  NotifyUrl[MAX_MONEYINOUT_URL_LEN]; ///< 新增NotifyUrl
    char	  Message[MAX_MESSAGE_LEN];			 ///< 出入金请求返回信息
    char	  Ticket[MAX_TICKET_LEN + 3];			 ///<
}MoneyInOutInfo;

//<24>GET_FUNDFLOWQUERY   出入金查询  请求参数
///客户出入金查询入参结构体
#pragma pack(8)
typedef struct _FUNDFLOWQUERY_PARAM
{
    long long nQueryType;				///< 请求类型 (目前只能查询历史报表)  --- 1:当前报表  --- 2:历史报表
    long long nBeginDate;       ///< 查询范围的起始时间(UTC秒数)
    long long nEndDate;         ///< 查询范围的终止时间(UTC秒数)
    int nBeginRow;              ///< 开始记录序号 --- 1~n:第一条记录 --- -1:全部 --- 0:无记录
    int nEndRow;                ///< 结束记录序号 --- 1~n:第n条记录 --- -1:全部 --- 0:无记录
    long long nOperType;				///< 操作类型 --- 0:出入金 --- 1:入金 --- 2:出金
}FundFlowQueryParam;
//成功时 解析用
///客户出入金信息结构体
#pragma pack(8)
typedef struct _FUNDFLOWQUERY_INFO
{
    int     FlowNumber;         ///< 流水号
    int     OperType;           ///< 操作类型 --- 15:入金 --- 16:出金 --- 17:入金冲正 --- 18:出金冲正 --- 19:撤销入金 --- 20:撤销出金 --- 21:单边账调整入金 --- 22:单边账调整出金 --- 23:穿仓回退入金 --- 24:穿仓回退出金
    double  BeforeAmount;       ///< 起始金额
    double  Amount;             ///< 变动金额
    double  AfterAmount;        ///< 变后金额
    char    OpLoginAccount[MAX_OP_LOGIN_ACCOUNT_LEN];   ///< 操作员
    long long   OperDate;       ///< 日期
    int     BankID;             ///< 银行标识
    int		OrderID;			///< 关联单号
    char	Remark[MAX_FUNDFLOW_REMARK_LEN];			///< 红包标识
}FundFlowQueryInfo;

//<25>PUSH_SYSBULLETIN ,PUSH_SYSBUL_LIMITCLOSE    系统公告 解析时用
/// 公告结构体
#pragma pack(8)
typedef struct _SYSBULLETIN_INFO
{
    long long    LoginID;   ///< 登录ID
    long long BulletinID;   ///< 公告ID
    int       TradeMode;		///< 交易模式
    int       BulletinType;		///< 公告类型
    int       BulletinPriorty;  ///< 优先级
    char      BulletinHeader[MAX_BULLETIN_HEADER_LEN];		///< 公告消息头
    char      BulletinContent[MAX_BULLETIN_CONTENT_LEN];		///< 公告消息正文
    char      PublisherName[MAX_PUBLISHERNAME_LEN];		///< 发布方名
    int       BulletinMethod;		///< 公告方式
}SysBulletinInfo;

//<27>GET_SIGNRESULTNOTIFYQUERY 签约结果通知
//请求参数:
// 签约成功结果通知入参结构体
#pragma pack(8)
typedef struct _SIGNRESULTNOTIFYQUERY_PARAM
{
    int     BankID;                             ///< 银行ID --- ::TradeDefine.h BANK_xxx
    char    BankAccount[MAX_BANKACCNT_LEN];     ///< 新签约账号(就是card_id)
}SignResultNotifyQueryParam;
//请求成功解析用:
/// 处理结果结构体
#pragma pack(8)
typedef struct _PROCESSRESULT
{
    int  RetCode;				///< 返回码 99999 成功,其他弹出message提示
    char Message[MAX_MESSAGE_LEN];		///< 返回信息
    char StrSid[MAX_STRSID_LEN + 1];    ///< SID
}ProcessResult;

//<28> REQ_PAYFORWARD 支付推进
//请求参数
/// 支付推进入参结构体
#pragma pack(8)
typedef struct  _PAYFORWARD_PARAM
{
    char Ticket[MAX_TICKET_LEN];	///< Ticket
    char IdentifyCode[MAX_IDENTIFYCODE_LEN];	///< 验证码
    char Reversed[MAX_IP_LEN];      ///< 特殊会员用于传入IP
}PayForwardParam;

//<29> REQ_QUOTEBYID 获取商品报价
//请求参数 int类型的 商品ID
//
//请求成功时解析用
/// 实时行情结构体
#pragma pack(8)
typedef struct _REALTIEM_QUOTE
{
    long long       CommodityID;	///< 商品ID
    double    SellPrice;	///< 卖出价
    double    BuyPrice;		///< 买入价
    double    HighPrice;	///< 最高价
    double    LowPrice;		///< 最低价
    long long QuoteTime;	///< 报价时间
}RealTimeQuote;


//<18> GET_CUSTMTRADEREPORTHOLDPOSITOIN  客户交易报表持仓单查询  请求参数
///客户交易报表持仓/平仓/限价单查询入参结构体
#pragma pack(8)
typedef struct _REPORTQUERY_PARAM
{
    long long nQueryDateType;			///< 请求类型 (目前只能查询历史报表)  --- 1:当前报表  --- 2:历史报表
    long long nBeginDate;		///< 查询范围的起始时间(UTC秒数)
    long long nEndDate;			///< 查询范围的终止时间(UTC秒数)
    int nBeginRow;				///< 开始记录序号 --- 1~n:第一条记录 --- -1:全部 --- 0:无记录
    int nEndRow;				///< 结束记录序号 --- 1~n:第n条记录 --- -1:全部 --- 0:无记录
}ReportQueryParam;

///客户交易报表持仓单信息结构体
#pragma pack(8)
typedef struct _CUSTMTRADEREPORTHOLDPOSITION_INFO
{
    long long  tradedate;		///< 交易日
    long long  holdpositionid;	///< 持仓单号
    long long  opendate;		///< 建仓时间
    int        commodityid;		///< 商品标示
    char       commoditycode[MAX_COMMODITYCODE_LEN];	///< 商品编号
    char       commodityname[MAX_COMMODITYNAME_LEN];	///< 商品名称
    int        holdquantity;	///< 持仓数量
    long long        opendirector;	///< 建仓方向
    double     openprice;		///< 建仓价格
    double     holdpositionpric;	///< 持仓价格
    double     slprice;			///< 止损价
    double     tpprice;			///< 止盈价
    double     settlementpl;	///< 结算盈亏
    double     commission;		///< 手续费
    double     latefee;			///< 滞纳金
    double     perfmargin;		///< 履约保证金
    double     settleprice;		///< 结算价
    long long        openquantity;	///< 建仓数量
    double     holdweight;		///< 持仓总重量
    double     openweight;		///< 建仓总重量
    long long        commoditymode;	///< 商品类型
}CustmTradeReportHoldPositionInfo;

//<19> GET_CUSTMTRADEREPORTCLOSEPOSITOIN 客户交易报表平仓单查询  请求参数
//请求成功时  解析用
///客户交易报表平仓单信息结构体
#pragma pack(8)
typedef struct _CUSTMTRADEREPORTCLOSEPOSITION_INFO
{
    long long	tradedate;		///< 交易日
    long long	holdpositionid;	///< 持仓单号
    long long	opendate;		///< 建仓时间
    int			commodityid;	///< 商品标示
    char		commoditycode[MAX_COMMODITYCODE_LEN];	///< 商品编号
    char		commodityname[MAX_COMMODITYNAME_LEN];	///< 商品名称
    int			closequantity;	///< 平仓数量
    long long			opendirector;	///< 建仓方向
    double		openprice;		///< 建仓价格
    double		holdpositionpric;	///< 持仓价格
    long long	closepositionid;	///< 平仓单号
    long long	closedate;		///< 平仓时间
    long long			closedirector;	///< 平仓方向
    double		closeprice;		///< 平仓价格
    double		commission;		///< 手续费
    double		profitorloss;	///< 盈亏
    double		opencommission;	///< 建仓手续费
    double		closeweight;	///< 平仓总重量
    long long			commoditymode;	///< 商品类型
}CustmTradeReportClosePositionInfo;

//<20> GET_CUSTMTRADEREPORTLIMITORDER  客户交易报表限价单查询 请求参数
//成功时 解析用
///客户交易报表限价单信息结构体
#pragma pack(8)
typedef struct _CUSTMTRADEREPORTLIMITORDER_INFO
{
    long long	tradedate;		///< 交易日
    long long	limitorderid;	///< 限价单号
    long long	createdate;		///< 下单时间
    int			commodityid;	///< 商品标示
    char		commoditycode[MAX_COMMODITYCODE_LEN];	///< 商品编号
    char		commodityname[MAX_COMMODITYNAME_LEN];	///< 商品名称
    int			openquantity;	///< 建仓数量
    int			opendirector;	///< 建仓方向
    int			limittype;		///< 类型
    double		orderprice;		///< 限价
    double		tpprice;		///< 止损价
    double		slprice;		///< 止盈价
    long long			deadline;		///< 期限
    double		frozenreserve;	///< 冻结保证金
    double		openweight;		///< 减仓总重量
    long long			commoditymode;	///< 商品模式
}CustmTradeReportLimitOrderInfo;

//<8> 用 GET_LIMITORDERS 请求限价单信息,解析用
/// 限价单信息结构体
#pragma pack(8)
typedef struct _LIMITORDER_INFO
{
    long long LimitOrderID;		///< 限价单ID
    int       CommodityID;		///< 商品ID
    char      CommodityName[MAX_COMMODITYNAME_LEN];		///< 商品名称
    int       LimitType;		///< 限价单类型	--- ::1:限价建仓 ---2:止盈平仓  ---3:止损平仓
    int       OrderType;		///< 建仓类型  --- ::1.客户下单
    int       OpenDirector;		///< 建仓方向
    double    OrderPrice;		///< 建仓价
    double    SLPrice;			///< 止损价
    double    TPPrice;			///< 止盈价
    long long       OpenQuantity;		///< 持仓数量
    double	  TotalWeight;		///< 持仓总重量
    long long CreateDate;		///< 建仓时间
    long long ExpireType;		///< 失效类型
    long long UpdateDate;		///< 更新时间
    double    FreeszMargin;		///< 冻结保证金
    long long		  DealStatus;		///< 处理状态  ---1:限价单未成交 ---2:限价单已成交 ---3:限价单用户撤销 ---4:成交撤单 ---5:市价平仓撤销 ---6:斩仓撤销 ---7:限价平仓撤销 ---8:结算撤单 ---9:异常撤销 ---10:交割撤销
}LimitOrderInfo;

//<9> 用GET_CLOSEORDERS 获取平仓单信息,解析用
/// 平仓单信息结构体
#pragma pack(8)
typedef struct _CLOSEPOSITION_INFO
{
    long long ClosePositionID;	///< 平仓单ID
    int       CommodityID;		///< 商品ID
    char      CommodityName[MAX_COMMODITYNAME_LEN];	///< 商品名称
    int       CloseDirector;	///< 平仓方向
    double    OpenPrice;		///< 建仓价
    double    HoldPrice;		///< 持仓价
    double    ClosePrice;		///< 平仓价
    long long       Quantity;			///< 持仓数量
    double	  TotalWeight;		///< 持仓总重量
    long long OpenPositionID;	///< 建仓单ID
    double    CommissionAmount;	///< 手续费
    long long OpenDate;			///< 建仓时间
    long long CloseDate;		///< 平仓时间
    int       MemberID;			///< 会员ID
    int       OpenType;			///< 建仓类型  --- ::1:客户下单  --- 4:限价下单
    long long       CloseType;		///< 平仓类型  --- ::1:客户下单  --- 4:限价下单  --- 5:斩仓强平
}ClosePositionInfo;

//<26> REQ_HOLDPOSITION 获取持仓信息
//请求成功解析用
/// 持仓单信息结构体
typedef struct _HOLDPOSITION_INFO
{
    long long HoldPositionID;	///< 持仓单ID
    int       CommodityID;		///< 商品ID
    char      CommodityName[MAX_COMMODITYNAME_LEN];	///< 商品名称
    int       OpenType;			///< 建仓类型  --- ::1:客户下单  --- 4:限价下单
    int       OpenDirector;		///< 建仓方向
    int       Quantity;			///< 持仓数量
    double	  TotalWeight;		///< 持仓总重量
    double    OpenPrice;		///< 建仓价格
    double    HoldPositionPrice;	///< 持仓价
    double    ClosePrice;		///< 平仓价
    long long SLLimitOrderID;	///< 止损单ID
    double    SLPrice;			///< 止损价
    long long TPLimitOrderID;	///< 止盈单ID
    double    TPPrice;			///< 止盈价
    double    OpenProfit;		///< 浮动盈亏
    double    CommissionAmount;	///< 手续费
    long long OpenDate;			///< 建仓时间
    double    AgreeMargin;		///< 履约保证金
    double    Freezemargin;		///< 冻结保证金
    double    OverdueFindFund;	///< 滞纳金
}HoldPositionInfo;

#endif /* DealSocketStructHeader_h */
