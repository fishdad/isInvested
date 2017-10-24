//
//  DealSocketTool.m
//  isInvested
//
//  Created by Ben on 16/10/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "DealSocketTool.h"
#import "RealReachability.h"
#import "UIImage+GIF.h"
#import "HttpTool.h"

//默认链接不上服务器就提示网络异常的次数
#define LoginServerMaxCount 5
//默认登录服务器显示等待登录的秒数
#define LoginServerSeconds 10.0

@interface DealSocketTool ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) NSMutableData *socketData;
@property (nonatomic, assign) BOOL is_com_package;//是否数据位完整数据
@property (nonatomic, assign) BOOL isSocketLogin;//是否已经登录服务器了
@property (nonatomic, strong) NSTimer        *connectTimer; // 计时器

@property (nonatomic, copy) LoginToServerBlock     loginToServerBlock;     //登录状态
@property (nonatomic, copy) AccountInfoBlock       accountInfoBlock;       //用户信息
@property (nonatomic, copy) CommodityInfoBlock     commodityInfoBlock;     //商品信息
@property (nonatomic, copy) OpenMarketOrderBlock   openMarketOrderBlock;   //市价开仓配置
@property (nonatomic, copy) CloseMarketOrderBlock  closeMarketOrderBlock;  //市价平仓配置
@property (nonatomic, copy) OpenLimitOrderBlock    openLimitOrderBlock;    //限价开仓配置
@property (nonatomic, copy) CloseLimitOrderBlock   closeLimitOrderBlock;   //限价平仓配置
@property (nonatomic, copy) OpenDeliveryConfBlock  openDeliveryConfBlock;  //市场交割
@property (nonatomic, copy) ChangePassWordBlock    changePassWordBlock;    //密码修改

@property (nonatomic, copy) DealResultBlock        marketStatusBlock;   //开市状态
@property (nonatomic, copy) ProcessResultBlock        openMarketResultBlock;   //市价建仓结果
@property (nonatomic, copy) ProcessResultBlock        openLimitResultBlock;    //限价建仓结果
@property (nonatomic, copy) HoldPositionTotalInfoBlock holdPositionTotalInfoBlock;//持仓总量
@property (nonatomic, copy) ProcessResultBlock        closeMarketOrderResultBlock;    //市价平仓
@property (nonatomic, copy) ProcessResultBlock        limitRevokeResultBlock;    //限价撤单结果
@property (nonatomic, copy) ProcessResultBlock        closeLimitOrderResultBlock;    //限价平仓结果
@property (nonatomic, copy) MoneyQueryBlock        moneyQueryBlock;//银行资金
@property (nonatomic, copy) MoneyInOutInfoBlock    moneyInOutInfoBlock;//出入金结果
@property (nonatomic, copy) ErrorBlock errorBlock;
@property (nonatomic, copy) DealResultBlock sinaSignResultBlock;//签约绑定结果block
@property (nonatomic, copy) PayResultBlock payResultBlock;//支付推进
@property (nonatomic, copy) AmountResultBlock amountResultBlock;//实际到账
@property (nonatomic, copy) RealTimeQuoteBlock realTimeQuoteBlock;//实时行情的价格
@property (nonatomic, copy) FundFlowQueryInfoBlock fundFlowQueryInfoBlock;//转账记录
@property (nonatomic, copy) SysBulletinInfoBlock sysBulletinInfoBlock;//系统公告


@property (nonatomic, copy)CustmTradeReportHoldPositionInfoBlock custmTradeReportHoldPositionInfoBlock;//历史持仓单
@property (nonatomic, copy)CustmTradeReportClosePositionInfoBlock custmTradeReportClosePositionInfoBlock;//历史平仓单
@property (nonatomic, copy)CustmTradeReportLimitOrderInfoBlock custmTradeReportLimitOrderInfoBlock;//历史限价单
@property (nonatomic, copy)HoldPositionInfoBlock holdPositionInfoBlock;//持仓单
@property (nonatomic, copy)ClosePositionInfoBlock closePositionInfoBlock;//平仓单
@property (nonatomic, copy)LimitOrderInfoBlock limitOrderInfoBlock;//限价单

@property (nonatomic, assign) NSInteger loginServerCount;//尝试连接服务器的次数
@property (nonatomic, assign) BOOL isCutOffByServer;//是否服务器主动断开

@property (nonatomic, assign) DealType dealSocketType;//当前的请求类型
@property (nonatomic, assign) int detailNoNetCount;//详情页面的没有网络的提示次数


@end

@implementation DealSocketTool

#pragma mark -- 单利方法
+(instancetype)shareInstance{
    static DealSocketTool *dealSocketTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dealSocketTool = [[DealSocketTool alloc] init];
    });
    return dealSocketTool;
}

-(instancetype)init{

    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkChanged:)
                                                     name:kRealReachabilityChangedNotification
                                                   object:nil];
        _isLoginFaild = NO;
        
        ////抓取交易登录的二进制数据 测试专用 xinle 2017.02.21
//        [self test];
    }
    return self;
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- 对外暴露接口方法
//是否链接服务器
- (BOOL)connectToRemote
{
    return [self.socket isConnected];
}
//判断交易是否可以登录
-(BOOL)isKHAccountCanLogin{
    
    NSString *accountStr = [NSUserDefaults objectForKey:KHAccount];
    if ((accountStr == nil || [accountStr isEqualToString:@""]) ||(self.LoginPassWordStr == nil || [self.LoginPassWordStr isEqualToString:@""])) {
        return NO;
    }else{
        return YES;
    }
}

//登录服务器携带Block
-(void)showLoginMsg{

    [HUDTool showText:@"网络繁忙,请稍后..."];
}

- (void)loginToServerWithPassWord:(NSString *)passWord Block:(LoginToServerBlock)loginToServerBlock
{
    
    [self performSelector:@selector(showLoginMsg) withObject:@"登录" afterDelay:LoginServerSeconds];
    self.LoginPassWordStr = passWord;
    self.loginToServerBlock = loginToServerBlock;
    [self loginToServer];
}


//登录服务器
- (void)loginToServer
{
    LOG(@"~~~~~~~发送loginToServer请求!!!!!");
    //调用登录服务器就进行登录次数的验证
    _loginServerCount ++;
    if (_loginServerCount > LoginServerMaxCount) {
        
        _loginServerCount = 0;//归零重记
        [self.socket disconnect];
        _isLoginFaild = YES;//与服务器链接失败
        if (_isCutOffByServer == NO) {//服务器断开的不去提示
            if (self.loginToServerBlock) {
                self.loginToServerBlock(NO,@"网络繁忙,请稍后...");
            }
        }else{
            if (self.loginToServerBlock) {
                self.loginToServerBlock(NO,@"您的网络环境不稳定,登录失败");
            }
        }
        return;
    }
    
    if ([self connectToRemote]) {
        if ([self isKHAccountCanLogin]) {
            NSData *data = [self socketLogin];
            LOG(@"~~~~~~~发送登录请求!!!!!");
            
            NSString *accountStr = [NSUserDefaults objectForKey:KHAccount];
            if ([accountStr isEqualToString:@""] || accountStr == nil || self.LoginPassWordStr == nil || [self.LoginPassWordStr isEqualToString:@""]) {
                return;//账户或者密码为空直接返回
            }
            
            [self sendData:data Tag:RT_LOGIN];
            LOG(@"~~~~~交易登录的二进制数据:%@,%@",[NSUserDefaults objectForKey:Account],data);
        }
    } else {
        [self connectToServer];
    }
}

//获取账户信息
-(void)getAccntInfoWithBlock:(AccountInfoBlock)accountInfoBlock isHUDHidden:(BOOL)isHUDHidden{
    
    self.accountInfoBlock = accountInfoBlock;
    NSMutableData *myData = [self getPackHeadDataByType:GET_ACCNTINFO ParamSize:0];
    if (isHUDHidden == YES) {
        [self sendNoHUDData:myData Tag:(GET_ACCNTINFO)];
    }else{
        [self sendData:myData Tag:(GET_ACCNTINFO)];
    }
}

//获取市场开休市状态
-(void)getMarketstatusWithStatusBlock:(DealResultBlock)block{

    self.marketStatusBlock = block;
    NSMutableData *myData = [self getPackHeadDataByType:GET_MARKETSTATUS ParamSize:0];
    [self sendData:myData Tag:(GET_MARKETSTATUS)];
}

//获取系统公告
-(void)PUSH_SYSBUL_LIMITCLOSEWithBlock:(SysBulletinInfoBlock)block{
    
    self.sysBulletinInfoBlock = block;
}

//获取行情报价
-(void)req_QuOTEWithBlock:(CommodityInfoBlock)commodityInfoBlock{
    
    self.commodityInfoBlock = commodityInfoBlock;
    NSMutableData *myData = [self getPackHeadDataByType:REQ_QUOTE ParamSize:0];
    [self sendData:myData Tag:(REQ_QUOTE)];
}

//获取市价单建仓配置信息
-(void)getOpenMarketOrderConByCommodityID:(int) commodityID WithBlock:(OpenMarketOrderBlock) openMarketOrderBlock{

    self.openMarketOrderBlock = openMarketOrderBlock;
    [self getOrderConByDealType:GET_OPENMARKETCONF CommodityID:commodityID];
}

//获取市价单平仓配置信息
-(void)getCloseMarketOrderConByCommodityID:(int) commodityID WithBlock:(CloseMarketOrderBlock) closeMarketOrderBlock{

    self.closeMarketOrderBlock = closeMarketOrderBlock;
    [self getOrderConByDealType:GET_CLOSEMARKETCONF CommodityID:commodityID];
}

//获取限价单建仓配置信息
-(void)getOpenLimitOrderConByCommodityID:(int) commodityID WithBlock:(OpenLimitOrderBlock) openLimitOrderBlock{

    self.openLimitOrderBlock = openLimitOrderBlock;
    [self getOrderConByDealType:GET_OPENLIMITCONF CommodityID:commodityID];
}
//获取限价单平仓配置信息
-(void)getCloseLimitOrderConByCommodityID:(int) commodityID WithBlock:(CloseLimitOrderBlock) closeLimitOrderBlock{

    self.closeLimitOrderBlock = closeLimitOrderBlock;
    [self getOrderConByDealType:GET_CLOSELIMITCONF CommodityID:commodityID];
}

//获取产品交割信息
-(void) getOpenDeliveryConfWithCommodityID:(int) commodityID HoldPrice:(double)holdPrice HoldWeight:(double) holdWeight WithBlock:(OpenDeliveryConfBlock) openDeliveryConfBlock{

    self.openDeliveryConfBlock = openDeliveryConfBlock;
    OpenOrderConf openOrderConf;
    memset(&openOrderConf,0x00,sizeof(OpenOrderConf));
    openOrderConf.m_CommodityID = commodityID;
    openOrderConf.m_HoldPrice = holdPrice;
    openOrderConf.m_HoldWeight = holdWeight;
    NSMutableData *myData = [self getPackHeadDataByType:GET_OPENDELIVERYCONF ParamSize:sizeof(OpenOrderConf)];
    NSData *openOrderConfData = [NSData dataWithBytes:&openOrderConf length:sizeof(openOrderConf)];
    [myData appendData:openOrderConfData];
    
    [self sendData:myData Tag:(GET_OPENDELIVERYCONF)];
}

//修改交易密码
-(void) changePassWordOldPwd:(NSString *)OldPwd NewPWD:(NSString *)NewPWD WithBlock:(ChangePassWordBlock) changePassWordBlock{

    self.changePassWordBlock = changePassWordBlock;

    ChangePWD changePWD;
    memset(&changePWD,0x00,sizeof(ChangePWD));
    memcpy(changePWD.m_strOldPwd, [OldPwd cStringUsingEncoding:NSUTF8StringEncoding], USER_PWD);
    memcpy(changePWD.m_strNewPwd, [NewPWD cStringUsingEncoding:NSUTF8StringEncoding], USER_PWD);
    changePWD.m_imarketType = 1;//1:贵金属
    NSMutableData *myData = [self getPackHeadDataByType:REQ_CHANGELOGINPWD ParamSize:sizeof(ChangePWD)];
    NSData *changePWDData = [NSData dataWithBytes:&changePWD length:sizeof(ChangePWD)];
    [myData appendData:changePWDData];
    
    [self sendData:myData Tag:(REQ_CHANGELOGINPWD)];

}

//修改资金密码
-(void) changeFundPassWordOldPwd:(NSString *)OldPwd NewPWD:(NSString *)NewPWD WithBlock:(ChangePassWordBlock)changePassWordBlock{

    self.changePassWordBlock = changePassWordBlock;
    
    ChangeFundPWD changeFundPWD;
    memset(&changeFundPWD,0x00,sizeof(changeFundPWD));
    memcpy(changeFundPWD.m_strOldPwd, [OldPwd cStringUsingEncoding:NSUTF8StringEncoding], FUND_PWD);
    memcpy(changeFundPWD.m_strNewPwd, [NewPWD cStringUsingEncoding:NSUTF8StringEncoding], FUND_PWD);
    
    NSMutableData *myData = [self getPackHeadDataByType:REQ_CHANGEFUNDPWD ParamSize:sizeof(ChangeFundPWD)];
    NSData *changePWDData = [NSData dataWithBytes:&changeFundPWD length:sizeof(ChangeFundPWD)];
    [myData appendData:changePWDData];
    
    [self sendData:myData Tag:(REQ_CHANGEFUNDPWD)];
}

//================================交易...建仓
//市价建仓
-(void)REQ_OPENMARKETWithParam:(OpenMarketOrderParamModel *)model ResultBlock:(ProcessResultBlock) dealResultBlock{

    self.openMarketResultBlock = dealResultBlock;
    NSData *data = [self getDataREQ_OPENMARKETWithParamModel:model];
    [self sendData:data Tag:(REQ_OPENMARKET)];
}
//限价建仓
-(void)REQ_OPENLIMITWithParam:(OpenLimitOrderParamModel *)model ResultBlock:(ProcessResultBlock) dealResultBlock{
    
    self.openLimitResultBlock = dealResultBlock;
    NSData *data = [self getDataREQ_OPENLIMITWithParamModel:model];
    [self sendData:data Tag:(REQ_OPENLIMIT)];
}
//获取持单总量
-(void)GET_HOLDPOSITIONTOTALWithBlock:(HoldPositionTotalInfoBlock) block isHUDHidden:(BOOL)isHUDHidden{

    self.holdPositionTotalInfoBlock = block;
    NSMutableData *myData = [self getPackHeadDataByType:GET_HOLDPOSITIONTOTAL ParamSize:0];
    if (isHUDHidden == YES) {//隐藏HUD
        [self sendNoHUDData:myData Tag:(GET_HOLDPOSITIONTOTAL)];
    }else{
        [self sendData:myData Tag:(GET_HOLDPOSITIONTOTAL)];
    }
}
//批量平仓
-(void)REQ_CLOSEMARETMANYWithParam:(CloseMarketOrderManyParamModel *)model Block:(ProcessResultBlock) block{
    
    self.closeMarketOrderResultBlock = block;
    NSData *myData = [self getDataREQ_CLOSEMARETMANYWithParamModel:model];
    [self sendData:myData Tag:(REQ_CLOSEMARETMANY)];

}
//市价平仓 参数列表:(依次 当前持仓单的买卖方向,市价平仓的参数model,成功返回的block)
-(void)REQ_CLOSEMARETWithOpenDirector_Direction:(OPENDIRECTOR_DIRECTION) OpenDirector_Direction
                                          Param:(CloseMarketOrderParamModel *)model
                                          Block:(ProcessResultBlock) block{

    //获取最新的市场价格
    [self REQ_QUOTEBYID:model.nCommodityID WithBlock:^(RealTimeQuote stu) {
        self.closeMarketOrderResultBlock = block;
        if (OpenDirector_Direction == OPENDIRECTOR_BUY) {//买涨持仓 的平仓价格 对应 卖出价
            model.dbPrice = stu.SellPrice;
        }else{
            model.dbPrice = stu.BuyPrice;
        }
        NSData *data = [self getDataREQ_CLOSEMARETWithParamModel:model];
        [self sendData:data Tag:(REQ_CLOSEMARKET)];
    }];
}
//限价单撤单
-(void)REQ_LIMITREVOKEWithLimitOrderID:(long long) nLimitOrderID CommodityID:(int)nCommodityID LimitType:(LIMITTYPE)nLimitType ResultBlock:(ProcessResultBlock) block{
    
    self.limitRevokeResultBlock = block;
    LimitRevokeParam stu;
    memset(&stu,0x00,sizeof(LimitRevokeParam));
    stu.nLimitOrderID = nLimitOrderID;
    stu.nCommodityID = nCommodityID;
    stu.nLimitType = nLimitType;
    
    NSMutableData *myData = [self getPackHeadDataByType:REQ_LIMITREVOKE ParamSize:sizeof(LimitRevokeParam)];
    NSData *data = [NSData dataWithBytes:&stu length:sizeof(LimitRevokeParam)];
    [myData appendData:data];
    [self sendData:myData Tag:(REQ_LIMITREVOKE)];

}
//限价平仓 参数列表:(依次 当前持仓单的买卖方向,持仓单ID,商品ID,止损价格,止盈价格)
-(void)REQ_CLOSELIMITWithOpenDirector_Direction:(OPENDIRECTOR_DIRECTION) OpenDirector_Direction nHoldPositionID:(long long) nHoldPositionID CommodityID:(int)nCommodityID dbSLPrice:(double)dbSLPrice dbTPPrice:(double)dbTPPrice ResultBlock:(ProcessResultBlock) block{

    //获取最新的市场价格
    [self REQ_QUOTEBYID:nCommodityID WithBlock:^(RealTimeQuote stu) {
        
        self.closeLimitOrderResultBlock = block;
        CloseLimitOrderParam closeLimitStu;
        memset(&stu,0x00,sizeof(CloseLimitOrderParam));
        closeLimitStu.nCommodityID = nCommodityID;
        
        //此处需要根据买卖方向选择对应的价格信息
        if (OpenDirector_Direction == OPENDIRECTOR_BUY) {
            closeLimitStu.dbClosePrice = stu.SellPrice;
        }else{
            closeLimitStu.dbClosePrice = stu.BuyPrice;
        }
        closeLimitStu.nExpireType = 1;
        closeLimitStu.nHoldPositionID = nHoldPositionID;
        closeLimitStu.dbSLPrice = dbSLPrice;
        closeLimitStu.dbTPPrice = dbTPPrice;
        NSMutableData *myData = [self getPackHeadDataByType:REQ_CLOSELIMIT ParamSize:sizeof(CloseLimitOrderParam)];
        NSData *data = [NSData dataWithBytes:&closeLimitStu length:sizeof(CloseLimitOrderParam)];
        [myData appendData:data];
        [self sendData:myData Tag:(REQ_CLOSELIMIT)];
    }];
}
//获取银行资金
-(void)GET_MONEYQUERYWithMoneyBlock:(MoneyQueryBlock) block{

    self.moneyQueryBlock = block;
    NSMutableData *myData = [self getPackHeadDataByType:GET_MONEYQUERY ParamSize:0];
    [self sendData:myData Tag:(GET_MONEYQUERY)];
}
//出入金
-(void)REQ_MONEYINOUTWithParamModel:(MoneyInOutParamModel *)model Block:(MoneyInOutInfoBlock)block ErrorBlock:(ErrorBlock)error{

    self.moneyInOutInfoBlock = block;
    self.errorBlock = error;
    NSData *data = [self getREQ_MONEYINOUTDataWithParamModel:model];
    [self sendData:data Tag:(REQ_MONEYINOUT)];
}
//签约银行状态查询
-(void)GET_SIGNRESULTNOTIFYQUERYWithResultBlock:(DealResultBlock) block{

    self.sinaSignResultBlock = block;
    SignResultNotifyQueryParam stu;
    memset(&stu,0x00,sizeof(SignResultNotifyQueryParam));
 
    stu.BankID = 31;//新浪支付的代码,待定31
    NSString *bankCardID = [NSUserDefaults objectForKey:SinaBangdingbankCardID];
    if (bankCardID == nil || [bankCardID isEqualToString:@""]) {
        return;
    }
    memcpy(stu.BankAccount, [bankCardID cStringUsingEncoding:NSUTF8StringEncoding], MAX_BANKACCNT_LEN);
    NSMutableData *myData = [self getPackHeadDataByType:GET_SIGNRESULTNOTIFYQUERY ParamSize:sizeof(SignResultNotifyQueryParam)];
    NSData *SignResultNotifyQueryParamData = [NSData dataWithBytes:&stu length:sizeof(SignResultNotifyQueryParam)];
    [myData appendData:SignResultNotifyQueryParamData];
    
    [self sendData:myData Tag:(GET_SIGNRESULTNOTIFYQUERY)];
}

//支付推进
-(void)REQ_PAYFORWARDWithTicket:(NSString *) Ticket IdentifyCode:(NSString *) IdentifyCode PayBlock:(PayResultBlock) block ResultBlock:(AmountResultBlock) amountBlock{
    
    self.payResultBlock = block;
    self.amountResultBlock = amountBlock;
    PayForwardParam stu;
    memset(&stu,0x00,sizeof(PayForwardParam));

    NSString *IPV4Str =  [Util getIPV4String];
    memcpy(stu.Ticket, [Ticket cStringUsingEncoding:NSUTF8StringEncoding], MAX_TICKET_LEN);
    memcpy(stu.IdentifyCode, [IdentifyCode cStringUsingEncoding:NSUTF8StringEncoding], MAX_IDENTIFYCODE_LEN);
    memcpy(stu.Reversed, [IPV4Str cStringUsingEncoding:NSUTF8StringEncoding], MAX_IP_LEN);
    
    
    NSMutableData *myData = [self getPackHeadDataByType:REQ_PAYFORWARD ParamSize:sizeof(PayForwardParam)];
    NSData *PayForwardParamData = [NSData dataWithBytes:&stu length:sizeof(PayForwardParam)];
    [myData appendData:PayForwardParamData];
    [self sendData:myData Tag:(REQ_PAYFORWARD)];

}
//获取最新的行情报价
-(void)REQ_QUOTEBYID:(int)ID WithBlock:(RealTimeQuoteBlock)block{

    self.realTimeQuoteBlock = block;
    NSMutableData *myData = [self getPackHeadDataByType:REQ_QUOTEBYID ParamSize:sizeof(ID)];
    NSData *IDData = [NSData dataWithBytes:&ID length:sizeof(ID)];
    [myData appendData:IDData];
    
    [self sendData:myData Tag:(REQ_QUOTEBYID)];
}

//转账记录查询
-(void)GET_FUNDFLOWQUERYBynBeginDate:(long long) nBeginDate nEndDate:(long long) nEndDate WithBlock:(FundFlowQueryInfoBlock) block{
    
    self.fundFlowQueryInfoBlock = block;
    FundFlowQueryParam stu;
    
    memset(&stu,0x00,sizeof(FundFlowQueryParam));
    stu.nQueryType = 2;///< 请求类型 (目前只能查询历史报表)  --- 1:当前报表  --- 2:历史报表
    stu.nBeginDate = nBeginDate;///< 查询范围的起始时间(UTC秒数)
    stu.nEndDate = nEndDate;///< 查询范围的终止时间(UTC秒数)
    stu.nBeginRow = -1;///< 开始记录序号 --- 1~n:第一条记录 --- -1:全部 --- 0:无记录
    stu.nEndRow = -1;/////< 结束记录序号 --- 1~n:第n条记录 --- -1:全部 --- 0:无记录
    stu.nOperType = 0;///< 操作类型 --- 0:出入金 --- 1:入金 --- 2:出金
    
    NSMutableData *myData = [self getPackHeadDataByType:GET_FUNDFLOWQUERY ParamSize:sizeof(FundFlowQueryParam)];
    NSData *paramData = [NSData dataWithBytes:&stu length:sizeof(FundFlowQueryParam)];
    [myData appendData:paramData];
    [self sendData:myData Tag:(GET_FUNDFLOWQUERY)];
}

#pragma mark -- 明细的查询
-(void)getCustomOrderParamDataByType:(unsigned short) type BeginDate:(long long) beginDate EndDate:(long long) endDate{
    
    ReportQueryParam stu;
    memset(&stu,0x00,sizeof(ReportQueryParam));
    
    stu.nQueryDateType = 2;///< 请求类型 (目前只能查询历史报表)  --- 1:当前报表  --- 2:历史报表
    stu.nBeginDate = beginDate;///< 查询范围的起始时间(UTC秒数)
    stu.nEndDate = endDate;///< 查询范围的终止时间(UTC秒数)
    stu.nBeginRow = -1;///-1:全部
    stu.nEndRow = -1;  ///-1:全部
    
    LOG(@"nQueryDateType:%lld ,nBeginDate:%lld ,nEndDate:%lld ,nBeginRow:%d ,nEndRow:%d",stu.nQueryDateType,stu.nBeginDate,stu.nEndDate,stu.nBeginRow,stu.nEndRow);
    
    NSMutableData *myData = [self getPackHeadDataByType:type ParamSize:sizeof(ReportQueryParam)];
    NSData *paramData = [NSData dataWithBytes:&stu length:sizeof(ReportQueryParam)];
    [myData appendData:paramData];
    [self sendData:myData Tag:(type)];
}

//客户交易报表持仓单查询请求
-(void)GET_CUSTMTRADEREPORTHOLDPOSITOINByBeginDate:(long long) beginDate EndDate:(long long) endDate WithResultArrBlock:(CustmTradeReportHoldPositionInfoBlock) block{

    self.custmTradeReportHoldPositionInfoBlock = block;
    [self getCustomOrderParamDataByType:GET_CUSTMTRADEREPORTHOLDPOSITOIN BeginDate:beginDate EndDate:endDate];
}
//客户交易报表平仓单查询请求
-(void)GET_CUSTMTRADEREPORTCLOSEPOSITOINBeginDate:(long long) beginDate EndDate:(long long) endDate WithResultArrBlock:(CustmTradeReportClosePositionInfoBlock)block{

    self.custmTradeReportClosePositionInfoBlock = block;
    [self getCustomOrderParamDataByType:GET_CUSTMTRADEREPORTCLOSEPOSITOIN BeginDate:beginDate EndDate:endDate];
}
//客户交易报表限价单查询请求
-(void)GET_CUSTMTRADEREPORTLIMITORDERBeginDate:(long long) beginDate EndDate:(long long) endDate WithResultArrBlock:(CustmTradeReportLimitOrderInfoBlock)block{

    self.custmTradeReportLimitOrderInfoBlock = block;
    [self getCustomOrderParamDataByType:GET_CUSTMTRADEREPORTLIMITORDER BeginDate:beginDate EndDate:endDate];
}
//获取持仓单
-(void)getHoldPositionInfoWithBlock:(HoldPositionInfoBlock)block{
    
    self.holdPositionInfoBlock = block;
    NSMutableData *myData = [self getPackHeadDataByType:REQ_HOLDPOSITION ParamSize:0];
    [self sendData:myData Tag:(REQ_HOLDPOSITION)];
}
//获取平仓单
-(void)getClosePositionInfoWithBlock:(ClosePositionInfoBlock)block{
    
    self.closePositionInfoBlock = block;
    NSMutableData *myData = [self getPackHeadDataByType:GET_CLOSEORDERS ParamSize:0];
    [self sendData:myData Tag:(GET_CLOSEORDERS)];
}
//获取限价单
-(void)getLimitOrderInfoWithBlock:(LimitOrderInfoBlock)block{
    
    self.limitOrderInfoBlock = block;
    NSMutableData *myData = [self getPackHeadDataByType:GET_LIMITORDERS ParamSize:0];
    [self sendData:myData Tag:(GET_LIMITORDERS)];
}


#pragma mark -- GCDAsyncSocket 1.0代理
//发送消息成功
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}
//链接服务器成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    LOG(@"服务器连接成功~~~~~");
    _SocketOffTag = SocketOfflineByServer;//默认是服务器掉线
    _isCutOffByServer = NO;
    _isLoginFaild = NO;//与服务器链接成功
    [self.socket readDataWithTimeout:10 tag:RT_LOGIN];
}
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    self.socket = newSocket;
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    LOG(@"接收数据~~~~~");
    [self hideHud];
    if(self.socketData == nil){
        self.socketData = [[NSMutableData alloc] init];
    }
    
//    LOG(@"接收数据的长度~~~~~~~~~%li",data.length);
    
    [self.socketData appendData:data];
    [self dealWithSocketData];
    [self.socket readDataWithTimeout:10 tag:tag];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [self hideHud];
    self.socketData = nil;//数据缓存清空 xinle 2016.12.09
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectCutOff" object:nil];
    _isCutOffByServer = YES;
    _isLoginFaild = YES;//与服务器链接失败
    if ( _SocketOffTag != SocketOfflineByUser) {
        
        [Util isNetWorkWithBlock:^(BOOL isNetWork) {
            if (isNetWork) {//实际有网络存在才去重连
                LOG(@"服务器连接断开~~非人为因素,尝试重连,当前重连次数:%li",(long)_loginServerCount);
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectToServer) object:nil];
                    [self performSelector:@selector(connectToServer) withObject:nil afterDelay:0.5];
                });
            }
        }];
    }
}

#pragma mark -- GCDAsyncSocket 2.0链接服务器相关

//断开连接
-(void)cutOffSocket{
    
    [DealSocketTool shareInstance].isLoginFaild = NO;//清理登录失败的状态
    _SocketOffTag = SocketOfflineByUser;// 声明是由用户主动切断
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectCutOff" object:nil];
    self.isCutOffByServer = NO;//手动断开修改状态
    self.isSocketLogin = NO;
    [self.connectTimer invalidate];
    [self.socket setDelegate:nil];
    [self.socket disconnect];
    self.socket = nil;
    self.socketData = nil;//数据缓存清空 xinle 2016.12.09
}

#pragma mark -- socket对象的创建
-(GCDAsyncSocket *)socket{

    if (_socket == nil) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _socket;
}

// socket连接服务器
-(void)socketConnectHost{
    LOG(@"正在链接服务器!");
#pragma mark -- 测试修改为懒加载 上面👆 
//    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [self.socket disconnect];
    if ([self isKHAccountCanLogin]) {
        [self.socket connectToHost:_socketHost onPort:_socketPort withTimeout:-1 error:&error];
    }else{
        if (self.loginToServerBlock) {
//            self.loginToServerBlock(NO,@"交易账号或密码为空");
        }
    }
    if (error) {
        NSLog(@"交易Socket服务器连接错误:error-->%@" , error);
    }
}

//链接服务器
-(void)connectToServer{
    
    if([Util isNetWork]){//是否有网络
        LOG(@"~~~~~~~~~~开始连接服务器~~~~");
        if([self connectToRemote] == NO){
            self.socketHost = DealSocketIP;
            self.socketPort = DealSocketPort;
            //                [self cutOffSocket];//断开(如果没有连接此时重新链接之前不需要认为断开)
            [self socketConnectHost];//连接服务器
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginToServer) object:nil];
                [self performSelector:@selector(loginToServer) withObject:nil afterDelay:1.0];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginToServer) object:nil];
                [self performSelector:@selector(loginToServer) withObject:nil afterDelay:1.0];
            });
        }
    }else{
        //断网提示
        [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
            [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",NETWORK_WEAK] Target:dealVC];
        }];
    }

}

//用户登录
-(NSData*)socketLogin{
    
    NSMutableData *myData = [self getPackHeadDataByType:RT_LOGIN ParamSize:sizeof(ansUserAcc)];
    ansUserAcc user;
    NSString *accountStr = [NSUserDefaults objectForKey:KHAccount];
    memcpy(user.m_strUser, [accountStr cStringUsingEncoding:NSUTF8StringEncoding], USERNAME_LENGTH);
    memcpy(user.m_strPwd, [self.LoginPassWordStr cStringUsingEncoding:NSUTF8StringEncoding], USER_PWD);
    NSData *userData = [NSData dataWithBytes:&user length:sizeof(user)];
    [myData appendData:userData];
    return myData;
}

/**
 *  发送心跳包
 */

-(void)longConnectToSocket{
    //0x110 心跳类型
    NSMutableData *myData = [self getPackHeadDataByType:REQ_HEARTBEAT ParamSize:0];
    [self.socket writeData:myData withTimeout:-1 tag:REQ_HEARTBEAT];
}
/**
 *  心跳包定时器
 */

-(void)timer{
    [self.connectTimer invalidate];
    //心跳的Block
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];// 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
}

#pragma mark -- 自定义处理接收数据
-(UIImageView *)loadingGif{

    if (_loadingGif == nil) {
        UIImage *image = [UIImage sd_animatedGIFNamed:@"loading"];
        _loadingGif = [[UIImageView alloc] initWithImage:image];
    }
    return _loadingGif;
}
//显示风火轮
-(void)showHud{
   
    [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
        
        self.loadingGif.centerX = WIDTH / 2;
        self.loadingGif.centerY = dealVC.view.centerY * 0.9;
        [dealVC.view addSubview:self.loadingGif];
        dealVC.view.userInteractionEnabled = NO;
        [self performSelector:@selector(hideHud) withObject:nil afterDelay:3.0f];
    }];
}
//隐藏风火轮
-(void)hideHud{

    [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
        
        [self.loadingGif removeFromSuperview];
        dealVC.view.userInteractionEnabled = YES;
    }];
}

//发送数据请求
-(void)sendData:(NSData *)data Tag:(long)tag{
    
    if (_dealSocketType != tag && _dealSocketType != REQ_HEARTBEAT) {
        _detailNoNetCount = 0;
    }
    _dealSocketType = tag;
    if ([self connectToRemote]) {
        
        if (tag != RT_LOGIN && tag != REQ_MONEYINOUT && tag != REQ_PAYFORWARD) {
            //            [self showHud]; 修改为 一段时间加载不到数据才显示加载动画
            [self performSelector:@selector(showHud) withObject:@(tag) afterDelay:1.5f];
        }
        LOG(@"交易数据请求,类型%ld,数据:%@",tag,data);
        [self.socket writeData:data withTimeout:-1 tag:tag];
    }else{
        //只要断开连接就 提示:网络异常
        //        [Util goToDeal];//掉线重新输入验证
        
        if ((tag == REQ_HOLDPOSITION || tag == GET_LIMITORDERS)) {
            
            if (_detailNoNetCount < 1) {
                //如果没网
                [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
                    [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",NETWORK_WEAK] Target:dealVC];
                }];
                _detailNoNetCount ++;
            }else{
                return;//定时刷新的请求去除显示 2017.02.24 xinle
            }
        }
        if ([Util isNetWork]) {
            
            //与服务器链接失败
            if (_isLoginFaild == YES) {
                
                [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
                    //                    [Util goToDeal];//跳过密码验证的页面.完善客户体验
                    [Util alertViewWithMessage:[NSString stringWithFormat:@"与交易服务器连接异常,请尝试在网络稳定的环境下重新连接"] Target:dealVC];
                }];
            }
        }else{
            //如果没网
            [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
                [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",NETWORK_WEAK] Target:dealVC];
            }];
        }
    }
}

//发送数据请求
-(void)sendNoHUDData:(NSData *)data Tag:(long)tag{
    
    if ([self connectToRemote]) {
        [self.socket writeData:data withTimeout:-1 tag:tag];
    }else{
        //只要断开连接就 提示:网络异常
//        [Util goToDeal];//掉线重新输入验证
        [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
            [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",NETWORK_WEAK] Target:dealVC];
        }];
    }
}


//获取其市价建仓的配置信息
-(void)getOrderConByDealType:(DealType) type CommodityID:(int) commodityID{
    
    NSData *data = [NSData dataWithBytes:&commodityID length:sizeof(commodityID)];
    NSMutableData *myData = [self getPackHeadDataByType:type ParamSize:(int)(data.length)];
    [myData appendData:data];
    [self sendData:myData Tag:type];
}
//处理拼接的包头信息 (paramsSize = sizeof(具体的结构体), 0 代表没有参数)
-(NSMutableData *)getPackHeadDataByType:(unsigned short) type ParamSize:(int) paramSize{
    
    ansPackHead login;
    memset(&login,0x00,sizeof(ansPackHead));
    memcpy(login.m_strHead, [@"JACK" cStringUsingEncoding:NSUTF8StringEncoding], PACKET_FLAG_NUM);
    login.m_iLength =  sizeof(login) + paramSize;
    login.m_iType = type;
    NSMutableData *myData = [NSMutableData dataWithBytes:&login length:sizeof(login)];
    return myData;
}
//处理数据(判断是不是完整的包)
-(void)dealWithSocketData{
    if (self.socketData.length < 12) {//PackHead包头的长度
        return;
    }
    NSData *d;
    ansPackHead dataHead;
    [self.socketData getBytes:&dataHead length:sizeof(dataHead)];
    //首先判断接受的数据是不是完整的包，如果是完整的包进行出来，不是完成的包等下次接受数据到完整的在处理
    if(dataHead.m_iLength > self.socketData.length){
        //当前接收到的数据不完整,继续接受
        d = [NSData dataWithData:self.socketData];
        self.is_com_package = NO;
        if(dataHead.m_iLength > 10000000 || dataHead.m_iLength<0){
            //数据包异常时,抛出
            self.socketData = nil;
            d = [NSData dataWithData:self.socketData];
        }
    }else{
        //数据包完整,去按照type处理数据,此处返回的是还没有处理的数据
        d = [self dealWithData:dataHead];
    }
    
    self.socketData = [[NSMutableData alloc] init];
    [self.socketData appendData:d];
    //如果存在未处理的数据,递归循环处理
    if(self.socketData.length > 0){
        if(self.is_com_package){
            [self dealWithSocketData];
        }
    }
}

//修改密码
-(void)changePassWord{

    ansPackHead dataHead;
    [self.socketData getBytes:&dataHead range:NSMakeRange(0, sizeof(dataHead))];
   
    if (![self isSucessFromSrvWithDataHead:dataHead]) {
        return;
    }
    if (dataHead.m_iLength > sizeof(ansPackHead)) {
        NSData *data = [self.socketData subdataWithRange:NSMakeRange(sizeof(dataHead), dataHead.m_iLength - sizeof(dataHead))];
        NSString *statusStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (self.changePassWordBlock) {
            self.changePassWordBlock(dataHead.m_bsucessFromSrv,statusStr);
        }
    }
}

//返回错误的提示
-(void)returnErrorWithStu:(ansPackHead)dataHead{

    NSData *data = [self.socketData subdataWithRange:NSMakeRange(sizeof(dataHead), dataHead.m_iLength - sizeof(dataHead))];
    NSString *statusStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (self.errorBlock) {
        self.errorBlock(dataHead.m_bsucessFromSrv,statusStr);
    }

}

//是否从服务器请求数据成功
-(BOOL)isSucessFromSrvWithDataHead:(ansPackHead)dataHead{
    
    if (dataHead.m_bsucessFromSrv == 0) {
        NSData *data = [self.socketData subdataWithRange:NSMakeRange(sizeof(dataHead), dataHead.m_iLength - sizeof(dataHead))];
        NSString *statusStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (dataHead.m_iType == GET_ACCNTINFO) {//获取账号信息特殊处理
            return NO;
        }else if (dataHead.m_iType == PUSH_PAYFORWARDRESULT) {//出入金结果
            if ([statusStr isEqualToString:@"未知错误\0"]) {
                statusStr = @"验证码已失效,请重新获取";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:statusStr message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }else if (dataHead.m_iType == REQ_CHANGELOGINPWD) {//修改密码
            
            NSRange range = [statusStr rangeOfString:@"密码错误"];
            if (range.length > 0) {
                statusStr = @"原始密码错误";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:statusStr message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }else if (dataHead.m_iType == REQ_ERROR){//错误处理
            
            NSRange range = [statusStr rangeOfString:@"重复登录"];
            if (range.length == 0) {
//                statusStr = @"网络环境不稳定,为保证您正常交易请切换到稳定的网络";
//                [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
//                    [Util alertViewWithMessage:statusStr Target:dealVC];
//                }];
                return NO;
            }else{
                return YES;
            }
        }else{
            
            statusStr = [NSString stringWithFormat:@"%@",statusStr];
            [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
                [Util alertViewWithMessage:statusStr Target:dealVC];
            }];
            return NO;
        }
    }else{
        return YES;
    }
}

#pragma mark -- 处理dataHeard
-(void)dealWithDataHead:(ansPackHead)dataHead{
    
    if (![self isSucessFromSrvWithDataHead:dataHead]) {
        return;
    }
}

/**
 *  数据完整后，在这个方法进行解析是那种数据类型
 *
 *  @param dataHead 解析的头部信息
 *  @return  剩余的数据
 */
#pragma mark -- 接收数据处理

-(NSData*)dealWithData:(ansPackHead)dataHead {
    NSData *d;
    self.is_com_package = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showHud) object:@(dataHead.m_iType)];
    [self hideHud];
    LOG(@"交易接收数据,类型:%hu,数据:%@",dataHead.m_iType,self.socketData);
    
    if(dataHead.m_iType == RT_LOGIN){//登录
       
//        ansPackHead dataHead;
//        [self.socketData getBytes:&dataHead range:NSMakeRange(0, sizeof(dataHead))];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showLoginMsg) object:@"登录"];
            
            NSData *data = [self.socketData subdataWithRange:NSMakeRange(sizeof(dataHead), dataHead.m_iLength - sizeof(dataHead))];
            NSString *statusStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSRange range = [statusStr rangeOfString:@"密码错误"];
            if (range.length > 0) {
                _errorPassWordCount ++;
                NSInteger count = 5 - _errorPassWordCount;
                if (count > 0) {
                    statusStr = [NSString stringWithFormat:@"密码错误,您还可以输入%ld次",(long)count];
                }else{
                    statusStr = [NSString stringWithFormat:@"密码错误,您的账号已被锁定"];
                }
            }
           
            range = [statusStr rangeOfString:@"禁止该帐号登录"];
            if (range.length > 0) {
                statusStr = [NSString stringWithFormat:@"您的账号已被锁定,请联系牛奶金服相关工作人员"];
            }
            
            range = [statusStr rangeOfString:@"你会被系统断开连接"];
            if (range.length > 0) {
                [self cutOffSocket];
                self.LoginPassWordStr = @"";
                [Util goToDeal];
            }
            
            range = [statusStr rangeOfString:@"当前用户已在别的地方登录"];
            if (range.length > 0) {
                //设置别名 -- 清空别名,保证推送接受的唯一性
                [Util setJPushAlise:@""];
            }

            if (self.loginToServerBlock) {
                self.loginToServerBlock(dataHead.m_bsucessFromSrv,statusStr);
            }
            if (dataHead.m_bsucessFromSrv == 1) {
                 _loginServerCount = 0;//实际登录成功之后,归零重计
                _errorPassWordCount = 0;
                self.isTouchIDLoginIn = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SignSuccess" object:nil];
                //设置别名
                [Util setJPushAlise:[NSUserDefaults objectForKey:KHSignAccount]];
                _SocketActiveTag = SocketActiveTypeByUser;//改为手动登录
                [self timer];
                [self.connectTimer fire];
            }
        }
    }else if (dataHead.m_iType == REQ_HEARTBEAT){//心跳包
    
//        LOG(@"心跳连接正常~~~~~");
    }else if (dataHead.m_iType == REQ_CHANGELOGINPWD){//修改交易密码
        
        [self changePassWord];
    }else if (dataHead.m_iType == REQ_CHANGEFUNDPWD){//修改资金密码
        
        [self changePassWord];
    }else if(dataHead.m_iType ==GET_ACCNTINFO){//获取账号信息
        
        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            AccountInfo accountInfo;
            [self.socketData getBytes:&accountInfo range:NSMakeRange(sizeof(dataHead),dataHead.m_iLength - sizeof(dataHead))];
            AccountInfoModel *model = [AccountInfoModel shareModelWithStruct:accountInfo];
            if (self.accountInfoBlock) {
                self.accountInfoBlock(model);
            }
        }
    }else if(dataHead.m_iType == GET_MARKETSTATUS){//获取市场开休市状态
        
//        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
        
            NSData *data = [self.socketData subdataWithRange:NSMakeRange(sizeof(ansPackHead), dataHead.m_iLength - sizeof(ansPackHead))];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (self.marketStatusBlock) {
                self.marketStatusBlock(dataHead.m_bsucessFromSrv,str);
            }
            LOG(@"市场的开休市信息:%hu",dataHead.m_bsucessFromSrv);
        }
    }else if(dataHead.m_iType == PUSH_SYSBUL_LIMITCLOSE){//限价单成交的系统公告
        
        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            
            SysBulletinInfo stu;
            [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead), sizeof(SysBulletinInfo))];
             SysBulletinInfoModel *model = [SysBulletinInfoModel shareModelWithStruct:stu];
            
            if (self.sysBulletinInfoBlock) {
                self.sysBulletinInfoBlock(model);
            }
        }
    }else if(dataHead.m_iType == REQ_QUOTE){//获取行情报价
        
        [self dealWithDataHead:dataHead];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            int CommodityLength = sizeof(CommodityInfo);
            int count = ((dataHead.m_iLength - sizeof(ansPackHead)) / CommodityLength);
            for (int i = 0; i < count; i++) {
                CommodityInfo commodityInfo;
                [self.socketData getBytes:&commodityInfo range:NSMakeRange(sizeof(dataHead) + i * CommodityLength, CommodityLength)];
                CommodityInfoModel *model = [CommodityInfoModel shareModelWithStruct:commodityInfo];
                [arr addObject:model];
            }
        }
        if (self.commodityInfoBlock) {
            self.commodityInfoBlock(arr);
        }
    }else if(dataHead.m_iType == GET_OPENMARKETCONF){//获取其市价建仓的配置信息
        
        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
                            
            OpenMarketOrderConf openMarketOrderConf;
            [self.socketData getBytes:&openMarketOrderConf range:NSMakeRange(sizeof(dataHead),sizeof(OpenMarketOrderConf))];
            OpenMarketOrderConfModel *model =[OpenMarketOrderConfModel shareModelWithStruct:openMarketOrderConf];
            if (self.openMarketOrderBlock) {
                self.openMarketOrderBlock(model);
            }
        }
    }else if(dataHead.m_iType == GET_CLOSEMARKETCONF){//获取其市价平仓的配置信息
        
        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            
            CloseMarketOrderConf closeMarketOrderConf;
            [self.socketData getBytes:&closeMarketOrderConf range:NSMakeRange(sizeof(dataHead),sizeof(CloseMarketOrderConf))];
            CloseMarketOrderConfModel *model =[CloseMarketOrderConfModel shareModelWithStruct:closeMarketOrderConf];
            if (self.closeMarketOrderBlock) {
                self.closeMarketOrderBlock(model);
            }
        }
        
    }else if(dataHead.m_iType == GET_OPENLIMITCONF){//获取其限价建仓的配置信息
        
        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            
            OpenLimitOrderConf openLimitOrderConf;
            [self.socketData getBytes:&openLimitOrderConf range:NSMakeRange(sizeof(dataHead),sizeof(OpenLimitOrderConf))];
            OpenLimitOrderConfModel *model = [OpenLimitOrderConfModel shareModelWithStruct:openLimitOrderConf];
            if (self.openLimitOrderBlock) {
                self.openLimitOrderBlock(model);
            }
        }
    }else if(dataHead.m_iType == GET_CLOSELIMITCONF){//获取其限价平仓的配置信息
        
        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            
            LimitClosePositionConf limitClosePositionConf;
            [self.socketData getBytes:&limitClosePositionConf range:NSMakeRange(sizeof(dataHead),sizeof(LimitClosePositionConf))];
            LimitClosePositionConfModel *model = [LimitClosePositionConfModel shareModelWithStruct:limitClosePositionConf];
            if (self.closeLimitOrderBlock) {
                self.closeLimitOrderBlock(model);
            }
        }
    }else if(dataHead.m_iType == GET_OPENDELIVERYCONF){//获取交割的配置信息
        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            
            OpenDeliveryOderConf openDeliveryOderConf;
            
            [self.socketData getBytes:&openDeliveryOderConf range:NSMakeRange(sizeof(dataHead),sizeof(OpenDeliveryOderConf))];
            
            OpenDeliveryOderConfModel *model = [OpenDeliveryOderConfModel shareModelWithStruct:openDeliveryOderConf];
            if (self.openDeliveryConfBlock) {
                self.openDeliveryConfBlock(model);
            }
        }
    }//=====================================建仓单...交易
    else if(dataHead.m_iType == REQ_OPENMARKET){//市价建仓
        [self returnResultWithBlock:self.openMarketResultBlock];
    }else if(dataHead.m_iType == REQ_OPENLIMIT){//限价建仓
        [self returnResultWithBlock:self.openLimitResultBlock];
    }else if(dataHead.m_iType == REQ_CLOSELIMIT){//限价平仓
        [self returnResultWithBlock:self.closeLimitOrderResultBlock];
    }else if(dataHead.m_iType == REQ_CLOSEMARKET){//批量平仓 + 市价平仓 公用一个回调
        [self returnResultWithBlock:self.closeMarketOrderResultBlock];
    }else if(dataHead.m_iType == REQ_LIMITREVOKE){//限价撤单
        [self returnResultWithBlock:self.limitRevokeResultBlock];
    }else if (dataHead.m_iType == GET_SIGNRESULTNOTIFYQUERY){//签约银行的结果
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            NSData *data = [self.socketData subdataWithRange:NSMakeRange(sizeof(dataHead), dataHead.m_iLength - sizeof(dataHead))];
            NSString *statusStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSRange range = [statusStr rangeOfString:@"重复签约"];
//            if (range.length == 0) {
                if (self.sinaSignResultBlock) {
                    self.sinaSignResultBlock(dataHead.m_bsucessFromSrv,statusStr);
                }
//            }
        }
    }
    else if(dataHead.m_iType == REQ_MONEYINOUT){//出入金
        
        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            
            if (dataHead.m_bsucessFromSrv == 0) {
                //0:返回错误信息
                [self returnErrorWithStu:dataHead];
            }else{
            
                MoneyInOutInfo stu;
                [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead),sizeof(MoneyInOutInfo))];
                MoneyInOutInfoModel *model = [MoneyInOutInfoModel shareModelWithStruct:stu];
                if (self.moneyInOutInfoBlock) {
                    self.moneyInOutInfoBlock(model);
                }
            }
        }
    }
    else if(dataHead.m_iType == REQ_PAYFORWARD){//支付推进
        
        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength >= sizeof(ansPackHead) + sizeof(ProcessResult)) {
            
            ProcessResult stu;
            [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead),sizeof(ProcessResult))];
            if (self.payResultBlock) {
                self.payResultBlock(stu);
            }
        }
    }
    else if(dataHead.m_iType == PUSH_PAYFORWARDRESULT){//入金到账结果
        
        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength >= sizeof(ansPackHead) + sizeof(ProcessResult)) {
            
            ProcessResult stu;
            [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead),sizeof(ProcessResult))];
            if (self.amountResultBlock) {
                self.amountResultBlock(stu);
            }
        }
    }
    else if(dataHead.m_iType == GET_MONEYQUERY){//银行资金
        
        [self dealWithDataHead:dataHead];
        LOG(@"%d ======= %lu ",dataHead.m_iLength,sizeof(ansPackHead));
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            BourseMoneyInfo stu;
            [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead),sizeof(BourseMoneyInfo))];
            if (self.moneyQueryBlock) {
                self.moneyQueryBlock(stu);
            }
        }
    }
    else if(dataHead.m_iType == REQ_QUOTEBYID){//根据行情的ID查询最新的报价信息
        
        [self dealWithDataHead:dataHead];
        if (dataHead.m_iLength > sizeof(ansPackHead)) {
            RealTimeQuote stu;
            [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead),sizeof(RealTimeQuote))];
            if (self.realTimeQuoteBlock) {
                self.realTimeQuoteBlock(stu);
            }
        }
    }
    else if(dataHead.m_iType == GET_HOLDPOSITIONTOTAL){//持仓总量//暂时复制代码实现,后期优化把结构体名称,类名等当参数
        
        [self dealWithDataHead:dataHead];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        if (dataHead.m_iLength >= sizeof(ansPackHead) + sizeof(HoldPositionTotalInfo)) {
            int Length = sizeof(HoldPositionTotalInfo);
            int count = ((dataHead.m_iLength - sizeof(ansPackHead)) / Length);
            for (int i = 0; i < count; i++) {
                HoldPositionTotalInfo stu;
                [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead) + i * Length, Length)];
                HoldPositionTotalInfoModel *model = [HoldPositionTotalInfoModel shareModelWithStruct:stu];
                [arr addObject:model];
            }
        }
        if (self.holdPositionTotalInfoBlock) {
            self.holdPositionTotalInfoBlock(arr);
        }
    }
    else if(dataHead.m_iType == GET_FUNDFLOWQUERY){//转账资金记录
        
        [self dealWithDataHead:dataHead];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        if (dataHead.m_iLength >= sizeof(ansPackHead) + sizeof(FundFlowQueryInfo)) {
            int Length = sizeof(FundFlowQueryInfo);
            int count = ((dataHead.m_iLength - sizeof(ansPackHead)) / Length);
            for (int i = 0; i < count; i++) {
                FundFlowQueryInfo stu;
                [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead) + i * Length, Length)];
                FundFlowQueryInfoModel *model = [FundFlowQueryInfoModel shareModelWithStruct:stu];
                [arr addObject:model];
            }
        }
        
        if (self.fundFlowQueryInfoBlock) {
            self.fundFlowQueryInfoBlock(arr);
        }
    }
    else if(dataHead.m_iType == GET_CUSTMTRADEREPORTHOLDPOSITOIN){//历史持仓单查询//暂时复制代码实现,后期优化把结构体名称,类名等当参数
        
        [self dealWithDataHead:dataHead];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[self getLimitInfoModelArrBy:dataHead]];
        if (self.custmTradeReportHoldPositionInfoBlock) {
            self.custmTradeReportHoldPositionInfoBlock(arr);
        }
    }
    else if(dataHead.m_iType == GET_CUSTMTRADEREPORTCLOSEPOSITOIN){//历史平仓单查询//暂时复制代码实现,后期优化把结构体名称,类名等当参数
        
        [self dealWithDataHead:dataHead];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        if (dataHead.m_iLength >= sizeof(ansPackHead) + sizeof(CustmTradeReportClosePositionInfo)) {
            int Length = sizeof(CustmTradeReportClosePositionInfo);
            int count = ((dataHead.m_iLength - sizeof(ansPackHead)) / Length);
            for (int i = 0; i < count; i++) {
                CustmTradeReportClosePositionInfo stu;
                [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead) + i * Length, Length)];
                
                LOG(@"commodityid:%d,profitorloss:%f",stu.commodityid,stu.profitorloss);
                ClosePositionInfoModel *model = [ClosePositionInfoModel shareHisModelWithStruct:stu];
                [arr addObject:model];
            }
        }
        if (self.custmTradeReportClosePositionInfoBlock) {
            self.custmTradeReportClosePositionInfoBlock(arr);
        }
    }
    else if(dataHead.m_iType == GET_CUSTMTRADEREPORTLIMITORDER){//历史限价单查询//暂时复制代码实现,后期优化把结构体名称,类名等当参数
        
        [self dealWithDataHead:dataHead];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        if (dataHead.m_iLength >= sizeof(ansPackHead) + sizeof(LimitOrderInfo)) {
            int Length = sizeof(LimitOrderInfo);
            int count = ((dataHead.m_iLength - sizeof(ansPackHead)) / Length);
            for (int i = 0; i < count; i++) {
                LimitOrderInfo stu;
                [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead) + i * Length, Length)];
                LimitOrderInfoModel *model = [LimitOrderInfoModel shareModelWithStruct:stu];
                [arr addObject:model];
            }
        }
        if (self.custmTradeReportLimitOrderInfoBlock) {
            self.custmTradeReportLimitOrderInfoBlock(arr);
        }
    }else if(dataHead.m_iType == REQ_HOLDPOSITION){//持仓单查询
        
        [self dealWithDataHead:dataHead];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        if (dataHead.m_iLength >= sizeof(ansPackHead) + sizeof(HoldPositionInfo)) {
            int Length = sizeof(HoldPositionInfo);
            int count = ((dataHead.m_iLength - sizeof(ansPackHead)) / Length);
            for (int i = 0; i < count; i++) {
                HoldPositionInfo stu;
                [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead) + i * Length, Length)];
                HoldPositionInfoModel *model = [HoldPositionInfoModel shareModelWithStruct:stu];
                [arr addObject:model];
            }
        }
        if (self.holdPositionInfoBlock) {
            self.holdPositionInfoBlock(arr);
        }
    }else if(dataHead.m_iType == GET_CLOSEORDERS){//平仓单查询
        
        [self dealWithDataHead:dataHead];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        if (dataHead.m_iLength >= sizeof(ansPackHead) + sizeof(ClosePositionInfo)) {
            int Length = sizeof(ClosePositionInfo);
            int count = ((dataHead.m_iLength - sizeof(ansPackHead)) / Length);
            for (int i = 0; i < count; i++) {
                ClosePositionInfo stu;
                [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead) + i * Length, Length)];
                ClosePositionInfoModel *model = [ClosePositionInfoModel shareModelWithStruct:stu];
                [arr addObject:model];
            }
        }
        if (self.closePositionInfoBlock) {
            self.closePositionInfoBlock(arr);
        }
    }
    else if(dataHead.m_iType == GET_LIMITORDERS){//限价单查询
        
        [self dealWithDataHead:dataHead];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[self getLimitInfoModelArrBy:dataHead]];
        if (self.limitOrderInfoBlock) {
            self.limitOrderInfoBlock(arr);
        }
    }else if (dataHead.m_iType == REQ_ERROR){//错误处理
    
        [self dealWithDataHead:dataHead];
    }
    else{
         return d;
    }
    NSInteger length =  dataHead.m_iLength;
    //    NSLog(@"接受数据长度:%ld   解析包中得到的长度:%ld",self.socketData.length,(long)dataHead.leng);
    d = [self.socketData subdataWithRange:NSMakeRange(length, self.socketData.length-length)];
    return d;
}

//==================================交易...建仓
//返回建仓的结果
-(void)returnResultWithBlock:(ProcessResultBlock) block{

    ansPackHead dataHead;
    [self.socketData getBytes:&dataHead range:NSMakeRange(0, sizeof(dataHead))];
    if (![self isSucessFromSrvWithDataHead:dataHead]) {
        return;
    }
    if (dataHead.m_iLength >= (sizeof(ansPackHead) + sizeof(ProcessResult))) {
        ProcessResult stu;
        [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead),sizeof(ProcessResult))];
        if (block) {
            block(stu);
        }
    }
}

//市价建仓的
-(NSData *)getDataREQ_OPENMARKETWithParamModel:(OpenMarketOrderParamModel *)model{

    OpenMarketOrderParam openMarketOrderParam = [model getStruct];
    NSMutableData *myData = [self getPackHeadDataByType:REQ_OPENMARKET ParamSize:sizeof(OpenMarketOrderParam)];
    NSData *openMarketOrderParamData = [NSData dataWithBytes:&openMarketOrderParam length:sizeof(OpenMarketOrderParam)];
    [myData appendData:openMarketOrderParamData];
    
    return myData;
}

//限价建仓的
-(NSData *)getDataREQ_OPENLIMITWithParamModel:(OpenLimitOrderParamModel *)model{
    
    OpenLimitOrderParam openLimitOrderParam = [model getStruct];
    NSMutableData *myData = [self getPackHeadDataByType:REQ_OPENLIMIT ParamSize:sizeof(OpenLimitOrderParam)];
    NSData *OpenLimitOrderParamData = [NSData dataWithBytes:&openLimitOrderParam length:sizeof(OpenLimitOrderParam)];
    [myData appendData:OpenLimitOrderParamData];
    
    return myData;
}

//批量平仓
-(NSData *)getDataREQ_CLOSEMARETMANYWithParamModel:(CloseMarketOrderManyParamModel *)model{
    
    CloseMarketOrderManyParam stu = [model getStruct];
    NSMutableData *myData = [self getPackHeadDataByType:REQ_CLOSEMARETMANY ParamSize:sizeof(CloseMarketOrderManyParam)];
    NSData *data = [NSData dataWithBytes:&stu length:sizeof(CloseMarketOrderManyParam)];
    [myData appendData:data];
    
    return myData;
}
//市价平仓
-(NSData *)getDataREQ_CLOSEMARETWithParamModel:(CloseMarketOrderParamModel *)model{
    
    CloseMarketOrderParam stu = [model getStruct];
    NSMutableData *myData = [self getPackHeadDataByType:REQ_CLOSEMARKET ParamSize:sizeof(CloseMarketOrderParam)];
    NSData *data = [NSData dataWithBytes:&stu length:sizeof(CloseMarketOrderParam)];
    [myData appendData:data];
    
    return myData;
}
//出入金
-(NSData *)getREQ_MONEYINOUTDataWithParamModel:(MoneyInOutParamModel *)model{
    
    if (![model isKindOfClass:[MoneyInOutParamModel class]]) {
        return nil;
    }
    MoneyInOutParam stu = [model getStruct];
    LOG(@"出入金的参数:OperateType:%d,Currency:%d,Amount:%f,FundPsw:%s,BankPsw:%s,Reversed:%s,PayType:%d,OperateFlag:%d",stu.OperateType,stu.Currency,stu.Amount,stu.FundPsw,stu.BankPsw,stu.Reversed,stu.PayType,stu.OperateFlag);
    
    NSMutableData *myData = [self getPackHeadDataByType:REQ_MONEYINOUT ParamSize:sizeof(MoneyInOutParam)];
    NSData *data = [NSData dataWithBytes:&stu length:sizeof(MoneyInOutParam)];
    [myData appendData:data];
    
    return myData;
}

//限价单查询(实时,历史)
-(NSMutableArray *)getLimitInfoModelArrBy:(ansPackHead) dataHead{

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    if (dataHead.m_iLength >= sizeof(ansPackHead) + sizeof(LimitOrderInfo)) {
        int Length = sizeof(LimitOrderInfo);
        int count = ((dataHead.m_iLength - sizeof(ansPackHead)) / Length);
        for (int i = 0; i < count; i++) {
            LimitOrderInfo stu;
            [self.socketData getBytes:&stu range:NSMakeRange(sizeof(dataHead) + i * Length, Length)];
            LimitOrderInfoModel *model = [LimitOrderInfoModel shareModelWithStruct:stu];
            [arr addObject:model];
        }
    }
    return arr;
}

#pragma mark -- 网络监测
- (void)networkChanged:(NSNotification *)notification
{
    LOG(@"网络连接切换~~~~");
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    
    if (status == RealStatusNotReachable)
    {
        LOG(@"网络连接断开");
    }
    
    if (status == RealStatusViaWiFi || status == RealStatusViaWWAN)
    {
        LOG(@"断网重连~~重新链接登录服务器");
        [self connectToServer];
    }
}

#pragma mark -- 持仓明细的分页查询(当用户数据特别多时,放开此分页功能)
//-(void)getCustomOrderParamDataByType:(unsigned short) type PageIndex:(int) index PageRowCounts:(int) rowCounts{
//
//    ReportQueryParam stu;
//    memset(&stu,0x00,sizeof(ReportQueryParam));
//
//    stu.nQueryDateType = 2;///< 请求类型 (目前只能查询历史报表)  --- 1:当前报表  --- 2:历史报表
//    stu.nBeginDate = [[Util dateToUTCWithDate:@"2016-12-01 00:00:00"] longLongValue];///< 查询范围的起始时间(UTC秒数)
//    stu.nEndDate = [[NSDate date] timeIntervalSince1970];///< 查询范围的终止时间(UTC秒数)
//    if (rowCounts == -1) {
//        stu.nBeginRow = -1;///-1:全部
//        stu.nEndRow = -1;///< 结束记录序号 --- 1~n:第n条记录 ---
//    }else{
//        stu.nBeginRow = index * rowCounts + 1;///< 开始记录序号 --- 1~n:第一条记录
//        stu.nEndRow = (index + 1) * rowCounts;///< 结束记录序号 --- 1~n:第n条记录
//    }
//    NSMutableData *myData = [self getPackHeadDataByType:type ParamSize:sizeof(ReportQueryParam)];
//    NSData *paramData = [NSData dataWithBytes:&stu length:sizeof(ReportQueryParam)];
//    [myData appendData:paramData];
//    [self sendData:myData Tag:(type)];
//}

#pragma mark -- 测试专用 2017.02.21 xinle

//-(void)test{
//    
//    for (int i = 2; i <= 48; i ++) {
//        
//        @autoreleasepool {
//            
//            if ((i % 2 == 0)) {
//                
//                NSString *loginName;
//                if (i < 10) {
//                    loginName = [NSString stringWithFormat:@"kissy00%i",i];
//                }else{
//                    loginName = [NSString stringWithFormat:@"kissy0%i",i];
//                }
//                
//                [self testLoginDataWith:loginName PassWord:@"111111"];
//            }
//        }
//    }
//}
//
//-(void)testLoginDataWith:(NSString *)loginName PassWord:(NSString *) psaaWord{
//
//    //proType 当前平台 3 投了么
//    NSDictionary *params = @{@"loginname":loginName,
//                             @"passwd":psaaWord,
//                             @"proType":@3};
//    
//    [HttpTool XLGet:GET_LOGIN params:params success:^(id responseObj) {
//        
//        NSDictionary *dic = responseObj;
//        
//        if([[dic objectForKey:@"State"] integerValue]==1){
//            
//            NSDictionary *userDic = [Util dictionaryWithJsonString:[dic objectForKey:@"Descr"]];
//
//            NSString *account = userDic[@"account"];
//            if (account == nil || [account isEqualToString:@""]) {
//                
//            }else{
//                //拼接交易登录的二进制数据
//                NSMutableData *myData = [self getPackHeadDataByType:RT_LOGIN ParamSize:sizeof(ansUserAcc)];
//                ansUserAcc user;
//                NSString *accountStr = account;
//                memcpy(user.m_strUser, [accountStr cStringUsingEncoding:NSUTF8StringEncoding], USERNAME_LENGTH);
//                memcpy(user.m_strPwd, [@"qq111111" cStringUsingEncoding:NSUTF8StringEncoding], USER_PWD);
//                NSData *userData = [NSData dataWithBytes:&user length:sizeof(user)];
//                [myData appendData:userData];
//                
//                LOG(@"登录二进制数据:%@ -- %@",loginName,myData);
//
//            }
//        }else if([[dic objectForKey:@"State"] integerValue]==-1){
//            [HUDTool showText:@"有为空的参数"];
//            return ;
//        }else if([[dic objectForKey:@"State"] integerValue]==-2){
//            [HUDTool showText:@"登录名包含危险值"];
//            return ;
//            
//        }else if ([[dic objectForKey:@"State"] integerValue]==-3){
//            [HUDTool showText:@"用户被禁用"];
//            return ;
//            
//        }else if ([[dic objectForKey:@"State"] integerValue]==0){
//            [HUDTool showText:@"用户名或密码错误"];
//            return ;
//        }else if ([[dic objectForKey:@"State"] integerValue]==-4){
//            [HUDTool showText:@"用户不属于当前平台"];
//            return ;
//            
//        }
//        
//        
//    } failure:^(NSError *error) {
//        
//        [HUDTool showText:@"请求超时,请稍后再试"];
//        return ;
//    }];
//
//}

@end
