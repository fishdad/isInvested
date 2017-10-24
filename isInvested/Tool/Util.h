//
//  Util.h
//  CustomTabBarViewTest
//
//  Created by Bella on 14-8-25.
//  Copyright (c) 2014年 Bella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "Const.h"

@interface Util : NSObject

+(BOOL)validateUserName:(NSString*)string;
+(BOOL)validateUserPassword:(NSString*)string;
+ (BOOL)validatePhoneNumber:(NSString *)string;
//邮箱校验
+ (BOOL)validateEmail:(NSString *)string;
+ (BOOL)validateHttp:(NSString *)string;
+ (BOOL)allIsNumber:(NSString *)string;
+ (BOOL)isIdentificationCard:(NSString *)idCardString;
+ (BOOL)validateTheZipCode:(NSString *)zipCode;
//此处是判断输入是否为空
+(BOOL)isEmpty:(NSString *) string;
//UTF8转码为GB2312
+ (NSString *)UTF8_To_GB2312:(NSString*)utf8string;

+ (NSString *)getLocalVersion;
//+ (UIColor *)ColorConversionWithColorString:(NSString *) ColorString;
+ (NSString *)getFileManagerPath:(NSString *)appendingPathCompent;
+ (NSString *)dateFromLong:(NSString *)createdAt;
+ (NSString*)mobilePhone:(NSString *)phoneNumber;
+ (NSDate *)strtodate:(NSString *)dateStr formatter:(NSString *)formatter;
+ (NSString *)dateFromLong:(NSString *)createdAt formatter:(NSString *)formatter;
+ (NSString *)dateFromDay:(NSDate *)createdAt format:(NSString*)format;
+(NSString *)md5:(NSString *)str;//md5加密
+(NSDictionary*)getExpressionList;//获取表情列表
//+(NSString*)dicPraseName:(int)number;//根据字典转换成Name
//+(NSString*)getUserImageUrl:(NSString*)user_id;
+ (NSString *)dataWithBase64EncodedString:(NSString *)string;
+(NSInteger)validateCharacterNumber:(NSString*)string;//计算名称中的汉字
+(NSString*)stringWithStringEncodedHtml:(NSString *)string;
+ (NSUInteger) lenghtWithString:(NSString *)string ;//昵称中汉字和字母组合的，字符的长度

+ (NSString *)md5Str16:(NSString *)str;//16位的MD5加密
+(NSString *)showDate:(NSString *)da;
+(CGSize)caLabelSize:(NSString*)string heigh:(float)heigh font:(UIFont*)font;//动态计算label的高度

+(NSString *)filterHTML:(NSString *)html;//去掉带html标签
//验证金融家用户名称
+(BOOL)validateJRJ:(NSString*)string;

//过滤掉字符串的所有空格
+(NSString*)filtrationSpace1:(NSString*)string;
+(NSString*)filtrationSpace:(NSString*)string;

+ (NSString*)StringToIntercept:(NSString*)UpdateTimeStr;
+ (NSString *)GetsTheCurrentCalendar;
+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)base64EncodedStringFrom:(NSData *)data;


+(void)writeToFile:(NSString*)data folderName:(NSString*)folderName;
+(NSString*)readFromFileWithTheFolderPath:(NSString*)folderPath;
+ (NSString *)GetsTheCurrentTime;
+ (NSString*)weekdayStringFromDate;
/**
 *  判断当前是否有网络
 *
 *  @return 当前网络状态
 */

+(void)isNetWorkWithBlock:(void (^)(BOOL isNetWork))netWorkBlock;
//静态的判断是否有网络
+(BOOL)isNetWork;

/**
 *  char 转nsstring类型
 *
 *  @param ch char
 *
 *  @return nsstring
 */
+(NSString*)charChangeString:(char*)ch;
+ (NSString *)ByTheNameOfTheCountryToGetThePictureOfTheCountry:(NSString*)countryName;
+ (void)deleteFile:(NSString*)folderName;
/**
 *  根据市场Type转16进制
 *
 *  @param marketType 市场Type
 *
 *  @return short
 */
+(unsigned short)marketTypeChangeShort:(NSString*)marketType;

/**
 *  根据16进制转市场Type
 *
 *  @param unsigned short 市场Type16进制
 *
 *  @return marketType
 */

+(NSString*)shortChangeMarketType:(unsigned short)shortType;


/**
 *  计算主推的当前时间
 */


+(NSString*)getMainPush:(NSString*)date  mid:(NSString*)mid;



/**
 *  计算当前时间秒数
 *
 *  @return 时间秒数
 */
+(NSTimeInterval)getTimeIntervalForNowDateWithTime:(NSString*)time;

/**
 *  获取当前屏幕显示的viewcontroller
 *
 *  @return viewcontroller
 */

+ (UIViewController *)getCurrentVC;


//时间处理(毫秒级别)
+ (NSString *)dateDetailFromLong:(NSString *)createdAt;

+ (NSString*)StringToIntercept1:(NSString*)UpdateTimeStr;

//判断两次点击时间差(参数分钟)
+(BOOL )compareWithCurrentTimeByCompareDate:(NSDate*) compareDate WithMin:(int)Interval;

//交易/资金密码判断(8-10位字母+数字)
+(BOOL)validateKHPassword:(NSString *)string;

//返回横线
+(UIView *)setUpLineWithFrame:(CGRect)frame;

//一个字符串两种颜色
+ (NSAttributedString *) setFirstString:(NSString *)firstString secondString:(NSString *)secondString firsColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor;

//一个字符串两种颜色,两种字体
+ (NSAttributedString *) setFirstString:(NSString *)firstString secondString:(NSString *)secondString firsColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor firstFont:(UIFont *) firstFont secondFont:(UIFont *) secondFont;

//一个字符串三种颜色两种字体
+ (NSAttributedString *) setFirstString:(NSString *)firstString secondString:(NSString *)secondString threeString:(NSString *)threeString firsColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor threeColor:(UIColor *)threeColor firstFont:(UIFont *) firstFont secondFont:(UIFont *) secondFont threeFont:(UIFont *)threeFont;
//一个字符串多种颜色,字体
+ (NSAttributedString *) setStringsArr:(NSArray<NSString *> *) stringsArr ColorsArr:(NSArray<UIColor *> *) colorsArr FontsArr:(NSArray <UIFont *> *) fontsArr;

#pragma mark -- 银行卡号对应银行
+ (NSString *)returnBankNameWith:(NSString*) idCard InBankArr:(NSArray *)bankArr;
//add by ben 2016.06.28增加已阅读新闻纪录
+(void)setNewsReadedLabel:(UILabel *)label ColorByCodeStr:(NSString *)code;

+ (NSString *)GetsTheCurrentCalendarByDateFormat:(NSString *)format;//日历顶部悬浮时间

//当前账号的手势密码开启状态
+(NSString *)isSHPassWord;
//当前账号的手势密码代替交易登录密码
+(NSString *)DealSHReplacePassWord;
//当前账号的指纹密码开启状态
+(NSString *)isTouchIDPassWord;
//当前账号的手势密码1
+(NSString *)passwordone;
//当前账号的手势密码2
+(NSString *)passwordtwo;
//json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//base64编码的字符串
+(NSString *)returnBase64StrByData:(NSData *)data;
//带有标题,信息的alertView
+(void)alertViewWithTitle:(NSString *)title Message:(NSString *)message Target:(UIViewController *)target;
//字体的alertView 
+(void)alertViewWithMessage:(NSString *)message Target:(UIViewController *)target;
//获取IP地址
+ (NSString *)getIPV4String;
//返回程序的window
+(UIWindow *)appWindow;
//(开户的界面)此处是因为多个HUD加在window上边会出现显示位置错误的问题,自己封装一个在当前页面调用
+ (void)showHUDAddTo:(UIView *)view Text:(NSString *)text;
//返回银行名称
+(NSString *)returnBankNameByBankID:(NSString *)bankID;
//银行编码转名称
+(NSString *)returnBankNameByBankCode:(NSString *)bankCode;
//返回银行编码
+(NSString *)returnBankCodeByBankID:(NSString *)bankID;
//获取和当前时间日期差的时间
+(NSString *)getsDateFromCurrentTimeByDays:(NSInteger)n;
//轻仓,重仓,满仓
+(NSString *)holdTypeWithFrozenReserve:(NSString *) FrozenReserve Amount:(NSString *) Amount;
//获取不同品种的计量单位的选择
+(NSDictionary *)weightStepDicByComID;
//返回下单时候市价指价的图片
+(UIImage *)getImgbyType:(BuyOrderType) type PriceType:(PriceOrderType)priceType;
//  颜色转换为背景图片
+(UIImage *)imageWithColor:(UIColor *)color Size:(CGSize) size;
//照片缩放,防止失真
+(UIImage*)OriginImage:(UIImage *)OriginImage scaleToSize:(CGSize)size;
//买卖方向
+(int)getOPENDIRECTOR_DIRECTIONByBuyOrderType:(BuyOrderType) type;
//模拟手动点击交易按钮
+(void)goToDeal;
//新浪支付的接口方法
+(NSString *)getSinaBangdingUrlBytype:(SinaBangdingUrlType) type;
//转账记录的接口方法
+(NSString *)getTransAmountUrlBytype:(TransAmountUrlType) type;
//处理用户头像
+(void)setPhotoImgUrlWithHost:(NSString *) host;
//点击详情页面直接进入对应品种的买涨.买跌
+(void)goToDealFromeType:(DealFromType) type Code:(NSString *) code;
//获取当前账号的银行卡号
+(NSString *)getCardStr;
//获得交易界面的VC,便于网络和其他的提示
+(void)getDealViewControllerWithBlock:(void(^)(UIViewController* dealVC) )block;
// 判断时间差是否超出
+(BOOL)isDealSocketLoginOutOfTime;
//根据品种的ID得到价格显示的位数
+(NSString *)getPriceDigitByComID:(NSString *)comID;
//根据品种的ID得到重量显示的位数
+(NSString *)getWeightDigitByComID:(NSString *)comID;
//日期转换为时间戳 (日期转换为秒数)
+(NSString *)dateToUTCWithDate:(NSString *)dateStr;
//自定义日期转换为时间戳 (日期转换为秒数)
+(NSString *)dateToUTCWithDate:(NSString *)dateStr DateFormatter:(NSString *) dateFormatterStr;
//时间戳转日期 (秒数转日期)
+(NSString *)UTCToDateWithUTC:(NSString *) timeStamp;
//获取默认的用户头像
+(UIImage *)getUserHeaderImage;
//处理iphone5的导航栏颜色色差
+(UIColor *)navigationBarColor;
//匹配是否包含敏感词
+(BOOL)CommentContent:(NSString *)commentStr SensitiveWords:(NSString *)regulationsStr;
//极光推送设置别名
+(void)setJPushAlise:(NSString *) aliseStr;
//浮点型转字符串,不进行四舍五入
+(NSString *)notRounding:(double)dValue afterPoint:(int)position;
//自定义弹出窗口
+(void)alertViewWithCancelBtnAndMessage:(NSString *)message Target:(UIViewController *)target doActionBtn:(NSString *)doActionBtn handler:(void (^ __nullable)(UIAlertAction *action))handler;

@end
