//
//  DealSocketTool.h
//  isInvested
//
//  Created by Ben on 16/10/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "DealSocketStructHeader.h"

#import "AccountInfoModel.h"
#import "CommodityInfoModel.h"
#import "OpenMarketOrderConfModel.h"
#import "CloseMarketOrderConfModel.h"
#import "OpenLimitOrderConfModel.h"
#import "LimitClosePositionConfModel.h"
#import "OpenDeliveryOderConfModel.h"
#import "OpenMarketOrderParamModel.h"
#import "OpenLimitOrderParamModel.h"
#import "HoldPositionTotalInfoModel.h"
#import "CloseMarketOrderManyParamModel.h"
#import "CloseMarketOrderParamModel.h"
#import "MoneyInOutParamModel.h"
#import "MoneyInOutInfoModel.h"
#import "FundFlowQueryInfoModel.h"
#import "SysBulletinInfoModel.h"

#import "CustmTradeReportHoldPositionInfoModel.h"
#import "CustmTradeReportLimitOrderInfoModel.h"
#import "HoldPositionInfoModel.h"
#import "ClosePositionInfoModel.h"
#import "LimitOrderInfoModel.h"

//链接的有效时间10分钟
#define DealSocketLoginTime 10
//断开连接的类型
typedef NS_ENUM(int, SocketOfflineType)
{
    SocketOfflineByServer,// 服务器掉线，默认为0
    SocketOfflineByUser,  // 用户主动cut
};

//重新连接的类型的类型
typedef NS_ENUM(int, SocketActiveType)
{
    SocketActiveTypeByUser = 1,//用户登录
    SocketActiveTypeFromBackground,  //后台进入前台
};

typedef void(^LoginToServerBlock)(unsigned short isSuccess,NSString *statusStr);    //获取登录状态
typedef void(^AccountInfoBlock)(AccountInfoModel *model);                           //获取账户信息
typedef void(^CommodityInfoBlock)(NSArray<CommodityInfoModel*> *modelArr);          //获取行情报价
typedef void(^OpenMarketOrderBlock)(OpenMarketOrderConfModel *model);               //获取市价开仓单信息
typedef void(^CloseMarketOrderBlock)(CloseMarketOrderConfModel *model);             //获取市价平仓单信息
typedef void(^OpenLimitOrderBlock)(OpenLimitOrderConfModel *model);                 //获取限价开仓单信息
typedef void(^CloseLimitOrderBlock)(LimitClosePositionConfModel *model);            //获取限价平仓单信息
typedef void(^OpenDeliveryConfBlock)(OpenDeliveryOderConfModel *model);             //获取产品交割信息
typedef void(^ChangePassWordBlock)(unsigned short isSuccess,NSString *statusStr);   //修改密码
typedef void(^DealResultBlock)(unsigned short isSuccess,NSString *statusStr);       //交易状态
typedef void(^HoldPositionTotalInfoBlock)(NSArray<HoldPositionTotalInfoModel*> *modelArr);//获取持单总量
typedef void(^MoneyQueryBlock)(BourseMoneyInfo stu);              //银行资金
typedef void(^MoneyInOutInfoBlock)(MoneyInOutInfoModel *model);   //出入金结果
typedef void(^PayResultBlock)(ProcessResult stu);                 //支付推进 操作结果
typedef void(^AmountResultBlock)(ProcessResult stu);              //支付推进 到账结果
typedef void(^RealTimeQuoteBlock)(RealTimeQuote stu);             //实时行情的价格
typedef void(^FundFlowQueryInfoBlock)(NSArray<FundFlowQueryInfoModel*> *modelArr);   //转账记录
typedef void(^SysBulletinInfoBlock)(SysBulletinInfoModel *model);                    //系统公告

typedef void(^CustmTradeReportHoldPositionInfoBlock)(NSArray<CustmTradeReportHoldPositionInfoModel*> *modelArr);   //历史持仓单查询
typedef void(^CustmTradeReportClosePositionInfoBlock)(NSArray<ClosePositionInfoModel*> *modelArr);   //历史平仓单查询
typedef void(^CustmTradeReportLimitOrderInfoBlock)(NSArray<LimitOrderInfoModel*> *modelArr);   //历史限价单查询
typedef void(^HoldPositionInfoBlock)(NSArray<HoldPositionInfoModel*> *modelArr);               //持仓单查询
typedef void(^ClosePositionInfoBlock)(NSArray<ClosePositionInfoModel*> *modelArr);             //平仓单查询
typedef void(^LimitOrderInfoBlock)(NSArray<LimitOrderInfoModel*> *modelArr);                   //限价单查询

//********新的返回方式******xinle 2016.12.07
typedef void(^ProcessResultBlock)(ProcessResult stu);   //接口返回结构体
typedef void(^ErrorBlock)(unsigned short isSuccess,NSString *statusStr);   //错误异常的报错信息
@interface DealSocketTool : NSObject

@property (nonatomic, copy  ) NSString       *socketHost;      // socket的Host
@property (nonatomic, assign) UInt16         socketPort;       // socket的prot
@property (nonatomic, strong) GCDAsyncSocket  *socket;
@property (nonatomic, strong) NSString *LoginPassWordStr;      //交易登录密码
@property (nonatomic, assign) BOOL         isTouchIDLoginIn;   //指纹登录
@property (nonatomic, assign) SocketOfflineType SocketOffTag;  //断开连接的类型
@property (nonatomic, assign) SocketActiveType SocketActiveTag;//进入活动的类型
@property (nonatomic, assign) NSInteger errorPassWordCount;    //错误密码次数
@property (nonatomic, strong) UIImageView *loadingGif;
@property (nonatomic, assign) BOOL isLoginFaild;//是否登录失败,用于发数据时提示语显示的判断

//工具类单利
+(instancetype)shareInstance;
//是否链接服务器
- (BOOL)connectToRemote;
//判断交易是否可以登录
-(BOOL)isKHAccountCanLogin;
//登录服务器携带Block
- (void)loginToServerWithPassWord:(NSString *)passWord Block:(LoginToServerBlock)loginToServerBlock;
//登录服务器
- (void)loginToServer;
//断开连接
-(void)cutOffSocket;
//获取账户信息
-(void)getAccntInfoWithBlock:(AccountInfoBlock) accountInfoBlock isHUDHidden:(BOOL) isHUDHidden;
//获取市场开休市状态
-(void)getMarketstatusWithStatusBlock:(DealResultBlock)block;
//获取行情报价
-(void)req_QuOTEWithBlock:(CommodityInfoBlock) commodityInfoBlock;
//获取市价单建仓配置信息
-(void)getOpenMarketOrderConByCommodityID:(int) commodityID WithBlock:(OpenMarketOrderBlock) openMarketOrderBlock;
//获取市价单平仓配置信息
-(void)getCloseMarketOrderConByCommodityID:(int) commodityID WithBlock:(CloseMarketOrderBlock) closeMarketOrderBlock;
//获取限价单建仓配置信息
-(void)getOpenLimitOrderConByCommodityID:(int) commodityID WithBlock:(OpenLimitOrderBlock) openLimitOrderBlock;
//获取限价单平仓配置信息
-(void)getCloseLimitOrderConByCommodityID:(int) commodityID WithBlock:(CloseLimitOrderBlock) closeLimitOrderBlock;
//获取产品交割信息
-(void) getOpenDeliveryConfWithCommodityID:(int) commodityID HoldPrice:(double)holdPrice HoldWeight:(double) holdWeight WithBlock:(OpenDeliveryConfBlock) openDeliveryConfBlock;

//修改交易密码
-(void) changePassWordOldPwd:(NSString *)OldPwd NewPWD:(NSString *)NewPWD WithBlock:(ChangePassWordBlock) changePassWordBlock;
//修改资金密码
-(void) changeFundPassWordOldPwd:(NSString *)OldPwd NewPWD:(NSString *)NewPWD WithBlock:(ChangePassWordBlock) changePassWordBlock;

//================================建仓单...交易
//市价建仓
-(void)REQ_OPENMARKETWithParam:(OpenMarketOrderParamModel *)model ResultBlock:(ProcessResultBlock) dealResultBlock;
//限价建仓
-(void)REQ_OPENLIMITWithParam:(OpenLimitOrderParamModel *)model ResultBlock:(ProcessResultBlock) dealResultBlock;
//获取持单总量
-(void)GET_HOLDPOSITIONTOTALWithBlock:(HoldPositionTotalInfoBlock) block isHUDHidden:(BOOL) isHUDHidden;
//批量平仓
-(void)REQ_CLOSEMARETMANYWithParam:(CloseMarketOrderManyParamModel *)model Block:(ProcessResultBlock) block;
//获取银行资金
-(void)GET_MONEYQUERYWithMoneyBlock:(MoneyQueryBlock) block;
//出入金
-(void)REQ_MONEYINOUTWithParamModel:(MoneyInOutParamModel *)model Block:(MoneyInOutInfoBlock)block ErrorBlock:(ErrorBlock) error;
//签约银行状态查询
-(void)GET_SIGNRESULTNOTIFYQUERYWithResultBlock:(DealResultBlock) block;
//支付推进
-(void)REQ_PAYFORWARDWithTicket:(NSString *) Ticket IdentifyCode:(NSString *) IdentifyCode PayBlock:(PayResultBlock) block ResultBlock:(AmountResultBlock) amountBlock;
//获取最新的行情报价
-(void)REQ_QUOTEBYID:(int)ID WithBlock:(RealTimeQuoteBlock)block;
//转账记录查询(时间戳)
-(void)GET_FUNDFLOWQUERYBynBeginDate:(long long) nBeginDate nEndDate:(long long) nEndDate WithBlock:(FundFlowQueryInfoBlock) block;
//获取系统公告
-(void)PUSH_SYSBUL_LIMITCLOSEWithBlock:(SysBulletinInfoBlock)block;


//市价平仓 参数列表:(依次 当前持仓单的买卖方向,市价平仓的参数model,成功返回的block)
-(void)REQ_CLOSEMARETWithOpenDirector_Direction:(OPENDIRECTOR_DIRECTION) OpenDirector_Direction
                                          Param:(CloseMarketOrderParamModel *)model
                                          Block:(ProcessResultBlock) block;

//限价平仓 参数列表:(依次 当前持仓单的买卖方向,持仓单ID,商品ID,止损价格,止盈价格,成功返回的block)
-(void)REQ_CLOSELIMITWithOpenDirector_Direction:(OPENDIRECTOR_DIRECTION) OpenDirector_Direction
                                nHoldPositionID:(long long) nHoldPositionID
                                    CommodityID:(int)nCommodityID
                                      dbSLPrice:(double)dbSLPrice
                                      dbTPPrice:(double)dbTPPrice
                                    ResultBlock:(ProcessResultBlock) block;

//限价单撤单
-(void)REQ_LIMITREVOKEWithLimitOrderID:(long long) nLimitOrderID
                           CommodityID:(int)nCommodityID
                             LimitType:(LIMITTYPE)nLimitType
                           ResultBlock:(ProcessResultBlock) block;

/*单据查询的入参说明
    beginDate:起始日期 UTC秒数
      endDate:结束日期 UTC秒数
        block:返回的对应model的数组
 */
//客户交易报表持仓单查询请求
-(void)GET_CUSTMTRADEREPORTHOLDPOSITOINByBeginDate:(long long) beginDate
                                           EndDate:(long long) endDate
                                WithResultArrBlock:(CustmTradeReportHoldPositionInfoBlock) block;
//客户交易报表平仓单查询请求
-(void)GET_CUSTMTRADEREPORTCLOSEPOSITOINBeginDate:(long long) beginDate
                                          EndDate:(long long) endDate
                               WithResultArrBlock:(CustmTradeReportClosePositionInfoBlock)block;
//客户交易报表限价单查询请求
-(void)GET_CUSTMTRADEREPORTLIMITORDERBeginDate:(long long) beginDate
                                       EndDate:(long long) endDate
                            WithResultArrBlock:(CustmTradeReportLimitOrderInfoBlock)block;
//获取持仓单
-(void)getHoldPositionInfoWithBlock:(HoldPositionInfoBlock)block;
//获取平仓单
-(void)getClosePositionInfoWithBlock:(ClosePositionInfoBlock)block;
//获取限价单
-(void)getLimitOrderInfoWithBlock:(LimitOrderInfoBlock)block;

@end
