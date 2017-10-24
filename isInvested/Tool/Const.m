//
//  Const.m
//  isInvested
//
//  Created by Wu on 16/8/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const URL_ADVERTISING = @"http://112.84.186.235:8059/Tools.ashx?action=get_app_loop_pic&page_id=25";
NSString * const URL_PLAYER = @"http://112.84.186.235:8059/Tools.ashx?action=get_app_loop_pic&page_id=20";
NSString * const URL_EVENT = @"http://112.84.186.235:8059/Tools.ashx?action=get_app_loop_pic&page_id=26";
NSString * const URL_NEWS = @"http://qapi.cngold.com.cn:83/LightHandler.ashx";
NSString * const URL_CALENDAR = @"http://cjrlapi.jincaishen.com.cn/FinanceCalendarHandler.ashx";
NSString * const URL_IMPORTANT_NEWS = @"http://newsappapi.cngold.com.cn/NewListHandler.ashx";
NSString * const URL_NEWS_DETAIL = @"http://newsappapi.cngold.com.cn/detailhandler.ashx";
NSString * const URL_VERSION = @"http://hrcms.cngold.com.cn/AppPreservation/getapp";
NSString * const URL_APPSTORE = @"https://itunes.apple.com/cn/app/id1147447155?mt=8";

NSString * const DealSocketIP = @"61.147.117.174";
NSString * const LOGIN_HOST = @"http://112.84.186.235:8638";
NSString * const PhotoImgUrlWithHost = @"img.milkvip.cn";
NSString * const OpenAccountHOST = @"http://210.22.92.66:808/PmecOpenAccountService.asmx";//简化开户的新地址
NSString * const URL_TXT = @"http://dsapp.yz.zjwtj.com:8010/initinfo/stock/";
NSString * const SOCKET_HOST = @"pmec.app.zjwtj.com";
unsigned short const SOCKET_PORT = 8881;
unsigned short const DealSocketPort = 8010;

//**************内网接口地址******************

//NSString * const URL_TXT = @"http://192.168.1.201:8010/initinfo/stock/";
//NSString * const SOCKET_HOST = @"192.168.1.131";
//NSString * const LOGIN_HOST = @"http://192.168.1.246:8066";
//NSString * const PhotoImgUrlWithHost = @"192.168.1.246:8123";
//NSString * const OpenAccountHOST = @"http://192.168.1.246:808/PmecOpenAccountService.asmx";//简化开户的新地址

NSInteger const kRed         = 0xf55150;
NSInteger const kGreen       = 0x11c971;
NSInteger const kFlashRed    = 0xF2E3E3;
NSInteger const kFlashGreen  = 0xDEF7E9;
NSInteger const kCandleRed   = 0xf25c73;
NSInteger const kCandleGreen = 0x4cd76b;

CGFloat const kDrawBeforeWaitingSec = 1.0; //通知1秒没来, 从本地取资源
CGFloat const kNewsSectionHeaderHeight = 20.0; //快讯组标题高度
/** view之间的间距 */
CGFloat const kPadding = 10.0;
/** 画图页, 顶部间距 */
CGFloat const kMarginTop  = 10.0;
CGFloat const kMarginLeft = 5.0;

NSInteger const kOneDaySeconds    = 86400;
NSInteger const kTwoDaysSeconds   = 172800;
NSInteger const kThreeDaysSeconds = 259200;

/** GG蜜月 */
NSString * const GGDataSkey = @"6UHQL0IU";
/** == @"gg_token" */
NSString * const gg_token = @"gg_token";

NSString * const GGBatchId = @"AJKIOS";
NSString * const GGBatchPw = @"RQAXSSF";
NSString * const kRequestTimeout = @"网络超时!";

NSString * const SocketRealTimeAndPushNotification = @"SocketRealTimeAndPushNotification";
NSString * const SocketTimeSharingNotification = @"SocketTimeSharingNotification";
NSString * const Socket5DaysNotification = @"Socket5DaysNotification";
NSString * const SocketKLineNotification = @"SocketKLineNotification";

//--------------------------------------------------------------------------------ben

NSString * const PhoneNum = @"PhoneNum";//手机号
NSString * const NickName = @"NickName";//昵称
NSString * const PhotoImgUrl = @"PhotoImgUrl";//头像url
NSString * const Account = @"Account";//账号(用户名)
NSString * const UserID = @"UserID";//用户ID
NSString * const LoginPassWord = @"LoginPassWord";//用户登录密码

//NSString * const isSHPassWord = @"isSHPassWord";//手势密码
//NSString * const isTouchIDPassWord = @"isTouchIDPassWord";//指纹密码

NSString * const KHAccount = @"KHAccount";//开户账号
NSString * const KHSignAccount = @"KHSignAccount";//开户签约账号(新浪支付使用)
NSString * const KHLoginPassWord = @"KHLoginPassWord";//开户账号登录密码
NSString * const LastOpenTime = @"LastOpenTime";//上次解锁时间
NSString * const isLogin = @"isLogin";//是否登录
NSString * const VarietyIndex = @"VarietyIndex";//当前品种index

#pragma mark -- 开户相关
NSString * const isOpenAccount = @"isOpenAccount";//是否开户
NSString * const OpenAccountStatus = @"OpenAccountStatus";//开户状态
NSString * const OpenAccountTime = @"OpenAccountTime";//开户时间
NSString * const isSinaAccountBangding = @"isSinaAccountBangding";//是否新浪绑卡
NSString * const SinaBangdingBank = @"SinaBangdingBank";//新浪绑定银行
NSString * const SinaBangdingBankCard = @"SinaBangdingBankCard";//是否新浪绑定银行卡号
NSString * const SinaBangdingbankCardID = @"SinaBangdingbankCardID";//是否新浪绑定银行卡ID

NSString * const IDCardName = @"IDCardName";//身份证姓名
NSString * const mobilePhone = @"mobilePhone";//(手机号)
NSString * const KHEmail = @"KHEmail";//开户电子邮箱
NSString * const certNo = @"certNo";//(证件号)
NSString * const certFrontScanName = @"certFrontScanName";//服务器返回的身份证正面名称
NSString * const certBackScanName = @"certBackScanName";//服务器返回的身份证反面名称
NSString * const riskTestName = @"riskTestName";//风险测评的文件名
NSString * const isBangDingAccount = @"isBangDingAccount";//开户账号绑定投了么账号
NSString * const SinaBangdingHost = @"http://112.84.186.236:8869/";//新浪支付的接口地址(外部接口地址)
NSString * const TransAmountHost = @"http://api.ofwnfv.com/WithdrawLog/";//转账记录接口地址(线上接口地址)
#pragma mark -- 错误提示
NSString * const NETWORK_WEAK = @"网络错误,请检查网络设置";//错误提示
