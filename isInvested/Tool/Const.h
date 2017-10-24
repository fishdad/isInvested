//
//  Const.h
//  isInvested
//
//  Created by Wu on 16/8/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const URL_ADVERTISING;
extern NSString * const URL_PLAYER;
extern NSString * const URL_EVENT;
extern NSString * const URL_NEWS;
extern NSString * const URL_CALENDAR;
extern NSString * const URL_IMPORTANT_NEWS;
extern NSString * const URL_NEWS_DETAIL;
extern NSString * const URL_TXT;
extern NSString * const URL_VERSION;
extern NSString * const URL_APPSTORE;
extern NSString * const SOCKET_HOST;
extern unsigned short const SOCKET_PORT;

extern NSInteger const kRed;
extern NSInteger const kGreen;
extern NSInteger const kFlashRed;
extern NSInteger const kFlashGreen;
extern NSInteger const kCandleRed;
extern NSInteger const kCandleGreen;

extern CGFloat const kDrawBeforeWaitingSec; //通知1秒没来, 从本地取资源
extern CGFloat const kNewsSectionHeaderHeight; //快讯组标题高度
/** view之间的间距 */
extern CGFloat const kPadding;
/** 画图页, 顶部间距 */
extern CGFloat const kMarginTop;
extern CGFloat const kMarginLeft;

extern NSInteger const kOneDaySeconds;
extern NSInteger const kTwoDaysSeconds;
extern NSInteger const kThreeDaysSeconds;

/** GG蜜月 */
extern NSString * const GGDataSkey;
/** == @"gg_token" */
extern NSString * const gg_token;

extern NSString * const GGBatchId;
extern NSString * const GGBatchPw;
extern NSString * const kRequestTimeout;

extern NSString * const SocketRealTimeAndPushNotification;
extern NSString * const SocketTimeSharingNotification;
extern NSString * const Socket5DaysNotification;
extern NSString * const SocketKLineNotification;

//--------------------------------------------------------------------------------

extern NSString * const LOGIN_HOST;//登录注册地址
extern NSString * const DealSocketIP;//交易接口ID
extern unsigned short const DealSocketPort;//交易接口端口
extern NSString * const PhotoImgUrlWithHost;//头像上传接口

extern NSString * const PhoneNum;
extern NSString * const NickName;
extern NSString * const PhotoImgUrl;
extern NSString * const Account;
extern NSString * const UserID;
extern NSString * const LoginPassWord;

//extern NSString * const isSHPassWord;//手势密码
//extern NSString * const isTouchIDPassWord;//指纹密码
extern NSString * const KHAccount;//开户账号
extern NSString * const KHSignAccount;//开户签约账号(新浪支付使用)
extern NSString * const KHLoginPassWord;//开户账号登录密码
extern NSString * const LastOpenTime ;//上次解锁时间
extern NSString * const VarietyIndex ;//当前品种index

extern NSString * const isLogin;//是否登录
extern NSString * const isOpenAccount;//是否开户
extern NSString * const OpenAccountStatus;//开户状态
extern NSString * const OpenAccountTime;//开户时间
extern NSString * const isSinaAccountBangding;//是否新浪绑卡
extern NSString * const SinaBangdingBank;//新浪绑定银行
extern NSString * const SinaBangdingBankCard;//是否新浪绑定银行卡号
extern NSString * const SinaBangdingbankCardID;//是否新浪绑定银行卡ID

extern NSString * const IDCardName;//身份证姓名
extern NSString * const mobilePhone;//(开户手机号)
extern NSString * const KHEmail;//开户电子邮箱
extern NSString * const certNo;//(证件号)
extern NSString * const certFrontScanName;//服务器返回的身份证正面名称
extern NSString * const certBackScanName;//服务器返回的身份证反面名称
extern NSString * const riskTestName;//风险测评的文件名称
extern NSString * const isBangDingAccount ;//开户账号绑定投了么账号

extern NSString * const OpenAccountHOST;
extern NSString * const SinaBangdingHost;//新浪支付的接口地址
extern NSString * const TransAmountHost;//转账记录接口地址
extern NSString * const NETWORK_WEAK;

/**
 *  get请求方法路径
 */
typedef NS_ENUM(NSUInteger,RequestGetUrlType) {
    
    GET_LOGIN=10000,                            //登录
    GET_REGISTER,                               //注册
    GET_VALIDATECODE,                           //获取手机验证码
    GET_UPDATEPASSWORD,                         //修改密码
    GET_RESETPASSWORD,                          //重置密码
    GET_UPDATEMOBILE,                           //修改手机
    GET_USERINFO,                               //获取用户信息
    GET_UPDATENICKNAME,                         //修改用户昵称
    GET_OPENACCOUNT,                            //绑定实盘
    TouGuRegister,                              //牛奶金服注册
    DESDeCodeMobiles,                           //手机解密接口
    GetAccountMessage,                          //获取实盘信息
    UpLoadUserAvatarBase64,                     //修改头像
    UpdateAccountBank,                          //绑定银行卡信息
};

/**
 *  新浪支付的接口方法
 */
typedef NS_ENUM(NSUInteger,SinaBangdingUrlType) {
    
    validate_identity = 1000,   // 验证证件信息
    create_activate_member,     // 创建激活会员
    set_real_name,              // 设置实名信息
    binding_bank_card,          // 绑定银行卡
    binding_bank_card_advance,  // 绑定银行卡推进
    query_bank_card,            // 查询银行卡
    unbinding_bank_card,        // 解绑银行卡
    unbinding_bank_card_advance,// 解绑银行卡推进
    egs_member_revoke,          // 注销会员
    advance_hosting_pay,        // 支付推进
    create_hosting_withdraw,    // 托管提现
};

/**
 *  转账记录的接口方法
 */
typedef NS_ENUM(NSUInteger,TransAmountUrlType) {
    
    AddWithdrawLog = 0,   //增加出入金记录
    GetWithdrawListById,  //根据用户ID获取当天申请记录
    GetSumAmount,         //统计用户入金、出金总和
};


//下单类型(涨跌等)
typedef NS_ENUM(NSInteger, BuyOrderType) {
    BuyOrderTypeUp = 0,    //买涨
    BuyOrderTypeDown = 1,   //买跌
    BuyOrderTypeLevel = 2,   //平仓
};

//市价,指价
typedef NS_ENUM(NSInteger, PriceOrderType) {
    PriceOrderTypeMarket = 0,   //市价
    PriceOrderTypeIndex = 1,   //指价
};

//转入,转出
typedef NS_ENUM(NSInteger, TranserType) {
    TranserTypeIn = 0,   //转入
    TranserTypeOut = 1,   //转出
};

//VC的view的tag(lockVC和signVC使用)
typedef NS_ENUM(NSInteger, VCViewTag) {
    VCViewTagLockVC = 9501,   //手势锁
    VCViewTagSignVC = 9502,   //密码验证
};

//进入交易界面的来源
typedef NS_ENUM(NSInteger, DealFromType) {
    
    DealFromTypeBuyUpBtn = 0,         //详情页买涨进入
    DealFromTypeBuyDownBtn = 1,       //详情页买跌面进入
    DealFromTypeTabbar = 2,           //点击中间的tab进入
    DealFromTypeMyAccount = 3,        //我的资产界面进入
};
