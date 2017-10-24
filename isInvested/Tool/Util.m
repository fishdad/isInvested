//
//  Util.m
//  CustomTabBarViewTest
//
//  Created by Bella on 14-8-25.
//  Copyright (c) 2014年 Bella. All rights reserved.
//

#import "Util.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import "DealSocketTool.h"
#import "RealReachability.h"
#import "DealViewController.h"
#import "BuyUpDownOrderViewController.h"
#import "sys/utsname.h"
#import "JPUSHService.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation Util

+(BOOL)validateJRJ:(NSString*)string{
    
    NSString *userName = @"^[a-zA-Z][a-zA-Z0-9]{1,19}";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userName];
    
    if([regextestct evaluateWithObject:string]){
        return YES;
    }else{
        return NO;
    }
    
    
}

//用户名为2-20的字母或数字，首位必须是字母
+(BOOL)validateUserName:(NSString*)string
{
    NSString *userName = @"^[a-zA-Z][a-zA-Z0-9]{1,19}";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userName];
    
    if([regextestct evaluateWithObject:string]){
        return YES;
    }else{
        return NO;
    }

}

//交易/资金密码判断(8-10位字母+数字)
+(BOOL)validateKHPassword:(NSString *)string{

//    $pattern = '/^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,10}$/';
//    
//    
//    分开来注释一下：
//    ^ 匹配一行的开头位置
//    (?![0-9]+$) 预测该位置后面不全是数字
//    (?![a-zA-Z]+$) 预测该位置后面不全是字母
//    [0-9A-Za-z] {6,10} 由6-10位数字或这字母组成
//    $ 匹配行结尾位置
    NSString *Regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,10}$$";
    NSPredicate *Predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    
    return [Predicate evaluateWithObject:string];
    
    
}

+(BOOL)validateUserPassword:(NSString*)string
{
    if (string.length>=6&&string.length<=16) {
        return YES;
    }else{
        return NO;
    }
    
}
//六位数字
+ (BOOL)validateTheZipCode:(NSString *)zipCode
{
    
    // NSString *zipCodeRegex = @"[1-9]d{5}(?!d)";
    NSString *zipCodeRegex = @"^[0-9]{6}$";
    NSPredicate *zipCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",zipCodeRegex];
    return [zipCodePredicate evaluateWithObject:zipCode];
}
+ (BOOL)validatePhoneNumber:(NSString *)string{
    
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     
     移动号段：134~139，147，150~152，157~159，181~183，187~188
     联通号段：130~132，155~156，185~186
     电信号段：133，153，180，189
     */
    //    NSString * MOBILES = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //    /**
    //     10         * 中国移动：China Mobile
    //     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //  //  NSString * CM1 = @"^1(47[0-8])\\d)\\d{7}$";
    //    /**
    //     15         * 中国联通：China Unicom
    //     16         * 130,131,132,152,155,156,185,186
    //     17         */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[156])\\d{8}$";
    //    /**
    //     20         * 中国电信：China Telecom
    //     21         * 133,1349,153,180,189
    //     22         */
    NSString * CT = @"^1\\d{10}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILES];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //  NSPredicate *regextestcm1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM1];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    //    if (([regextestmobile evaluateWithObject:string] == YES)
    //        || ([regextestcm evaluateWithObject:string] == YES)
    //        || ([regextestct evaluateWithObject:string] == YES)
    //        || ([regextestcu evaluateWithObject:string] == YES))
    if(([regextestct evaluateWithObject:string] == YES)){
        
        return YES;
    }
    else
    {
        return NO;
    }
    
    //    NSString *regex = @"^13\\d{9}||14\\d{9}||15[0,1,2,3,5,6,7,8,9]\\d{8}||18[0,1,2,3,5,6,7,8,9]\\d{8}$";
    //
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //
    //    return [pred evaluateWithObject:string];
}
+ (BOOL)validateEmail:(NSString *)string{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}
+ (BOOL)validateHttp:(NSString *)string{
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    if (arrayOfAllMatches.count > 0) {
        return YES;
    }
    return NO;
}
+ (BOOL)allIsNumber:(NSString *)string{
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:string];
}
//身份证
+ (BOOL)isIdentificationCard:(NSString *)idCardString
{
    NSString * idCard = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    
    NSPredicate *regextestIDCard = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCard];
    return [regextestIDCard evaluateWithObject:idCardString];
    
}

+ (NSString *)UTF8_To_GB2312:(NSString*)utf8string{
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *cityEnc = [utf8string dataUsingEncoding:encode];
    NSString *gb2312 = [[NSString alloc] initWithData:cityEnc encoding:encode];
    return [gb2312 stringByAddingPercentEscapesUsingEncoding:encode];
}

+ (NSString *)getLocalVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // app名称
    //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    //    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return app_Version;
    
}
+ (NSString *)getFileManagerPath:(NSString *)appendingPathCompent{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:appendingPathCompent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return diskCachePath;
}
+ (NSString *)getFileManagerPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"FZCaches/image/AD"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return diskCachePath;
}

//时间处理(上传app安装时间到天即可)
+ (NSString *)dateDetailFromLong:(NSString *)createdAt{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[createdAt doubleValue]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter1 stringFromDate:d];
    return  strDate;
}

//时间处理
+ (NSString *)dateFromLong:(NSString *)createdAt{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[createdAt doubleValue]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter1 stringFromDate:d];
    return  strDate;
}


//获取当前时间
+ (NSString *)GetsTheCurrentTime
{
    NSDate *d = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [formatter1 stringFromDate:d];
    return  strDate;
    
}

//获取和当前时间日期差的时间
+(NSString *)getsDateFromCurrentTimeByDays:(NSInteger)n{
    NSDate*nowDate = [NSDate date];
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    NSDate *theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*n ];
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    return the_date_str;
}


+ (NSString *)GetsTheCurrentCalendar
{
    NSDate *d = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter1 stringFromDate:d];
    return  strDate;
    
}


//时间处理
+ (NSString *)dateFromDay:(NSDate *)createdAt format:(NSString*)format{
    //    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[createdAt doubleValue]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter1 setTimeZone:timeZone];
    [formatter1 setDateStyle:NSDateFormatterFullStyle];
    [formatter1 setDateFormat:format];
    //    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter1 stringFromDate:createdAt];
    return  strDate;
}



//判断时间是不是超过一天


+(NSString *)showDate:(NSString *)da{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString  *date= [Util dateFromDay:[NSDate date] format:@"yyyy-MM-dd"];
    NSTimeInterval nowsecond =[[formatter1 dateFromString:date] timeIntervalSince1970];
    NSString *d =[Util dateFromDay:[NSDate dateWithTimeIntervalSince1970:[da doubleValue]] format:@"yyyy-MM-dd"];
    NSTimeInterval datasecond =[[formatter1 dateFromString:d] timeIntervalSince1970];
    //    NSTimeInterval secondsBetweenDates = [ timeIntervalSinceDate:d];
    int day = (nowsecond-datasecond)/24/3600;
    if(day>0){
        return [Util dateFromLong:da formatter:@"yyyy-MM-dd"];
    }else{
        return [Util dateFromLong:da formatter:@"HH:mm:ss"];
    }
    return nil;
}

//时间处理
+ (NSString *)dateFromLong:(NSString *)createdAt formatter:(NSString *)formatter{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter1 dateFromString:createdAt];
    //    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[createdAt doubleValue]];
    [formatter1 setDateFormat:formatter];
    NSString *strDate = [formatter1 stringFromDate:date];
    return  strDate;
}



+ (NSDate *)strtodate:(NSString *)dateStr formatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateStr];
}



+(NSString*)mobilePhone:(NSString *)phoneNumber{
    
    
    phoneNumber = [NSString stringWithFormat:@"%@****%@",[phoneNumber substringWithRange:NSMakeRange(0, 3)],[phoneNumber substringWithRange:NSMakeRange(7, 4)]];
    
    return phoneNumber;
}

//判断输入是否为空
+(BOOL)isEmpty:(NSString *) string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (NSString *)md5:(NSString *)str {
    
    
    
    const char *cStr = [str UTF8String];
    
    
    
    unsigned char result[16];
    
    
    
    CC_MD5( cStr,(unsigned int)strlen(cStr), result );
    
    
    
    return [NSString stringWithFormat:
            
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            
            
            result[0], result[1], result[2], result[3],
            
            
            
            result[4], result[5], result[6], result[7],
            
            
            
            result[8], result[9], result[10], result[11],
            
            
            
            result[12], result[13], result[14], result[15]
            
            
            
            ];
    
    
    
}
+ (NSString *)md5Str16:(NSString *)str {
    
    
    
    const char *cStr = [str UTF8String];
    
    
    
    unsigned char result[16];
    
    
    
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    
    NSString *Str32 = [NSString stringWithFormat:
                       
                       
                       @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                       
                       
                       
                       result[0], result[1], result[2], result[3],
                       
                       
                       
                       result[4], result[5], result[6], result[7],
                       
                       
                       
                       result[8], result[9], result[10], result[11],
                       
                       
                       
                       result[12], result[13], result[14], result[15]
                       
                       ];
    NSString *str16 = [Str32 substringWithRange:NSMakeRange(8, 16)];
    
    
    return  str16;
    
    
}

//获取表情列表

+(NSDictionary*)getExpressionList{
    
    NSDictionary *dic;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    if ([[languages objectAtIndex:0] hasPrefix:@"zh"]) {
        
        dic = [NSDictionary dictionaryWithContentsOfFile:
               [[NSBundle mainBundle] pathForResource:@"_expression_cn"
                                               ofType:@"plist"]];
    }
    else {
        
        dic = [NSDictionary dictionaryWithContentsOfFile:
               [[NSBundle mainBundle] pathForResource:@"_expression_en"
                                               ofType:@"plist"]];
        //        NSLog([_faceMap description]);
    }
    
    return  dic;
    
}



+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:@""]) {
        //取项目的bundleIdentifier作为KEY
        
//        NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin
        
        //        data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        
        return [self base64EncodedStringFrom:data];
    }
    else {
        return @"";
    }
}
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

+ (NSString *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return nil;
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    
    return[Util stringWithStringEncodedHtml:[[NSString alloc] initWithData: [NSData dataWithBytes:bytes length:length] encoding:NSUTF8StringEncoding]];
}

+(NSString*)stringWithStringEncodedHtml:(NSString *)string {
    
    
    NSString *result =  [[[[[[[[string  stringByReplacingOccurrencesOfString:@"\\&" withString:@"&"] stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"] stringByReplacingOccurrencesOfString:@"&gt;" withString:@">" ] stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""] stringByReplacingOccurrencesOfString:@"&amp;nbsp;" withString:@""] stringByReplacingOccurrencesOfString:@"&amp;lt;" withString:@"<"]stringByReplacingOccurrencesOfString:@"&amp;gt;" withString:@">"];
    return result;
}


+(NSInteger)validateCharacterNumber:(NSString*)string
{
    if(string.length==0){
        return 0;
    }
    
    NSInteger number = 0;
    NSInteger num = 0;
    NSString *userNameRegex = @"^[\u4E00-\uFA29]";
    NSString *Regex = @"^[A-Z]";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    NSPredicate *Predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    for(int i = 0;i<string.length;i++){
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        if([userNamePredicate evaluateWithObject:s]){
            number++;
        }
        if([Predicate evaluateWithObject:s]){
            num++;
        }
        
    }
    if((string.length-number)%2==0){
        if(num>0){
            if(num%3==0){
                return (string.length-number-num)/2+number+num/3*2;
            }else{
                return (string.length-number-num)/2+number+num/3*2+1;
            }
        }else{
            return (string.length-number)/2+number;
        }
        
    }else{
        if(num>0){
            if(num%3==0){
                return (string.length-number-num)/2+number+num/3*2+1;
            }else{
                return (string.length-number-num)/2+number+num/3*2+2;
            }
        }else{
            return (string.length-number)/2+1+number;
        }
        
        
    }
}

+ (NSUInteger) lenghtWithString:(NSString *)string
{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    return len + numMatch;
}

//跟上面的方法一样
- (NSUInteger) lenghtWithString:(NSString *)string
{
    NSUInteger asciiLength = 0;
    for(NSUInteger i = 0; i < string.length; i++)
    {
        unichar uc = [string characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    return asciiLength;
}

+(CGSize)caLabelSize:(NSString*)string heigh:(float)heigh font:(UIFont*)font{
    CGSize size = CGSizeMake(heigh,3000);
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading  attributes:attribute context:nil];
    
    return rect.size;
    
}


/**
 *  去掉带有HTML标签
 *
 *  @param html string
 *
 *  @return string
 */
+(NSString *)filterHTML:(NSString *)html
{
    
    //    查找全部匹配的，并替换
    NSString *	search=@"<br />";
    NSString*   replace=@"\r";
    NSString * search1 = @"</b>";
    NSString * search2 = @"<b>";
    
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        html= [html stringByReplacingOccurrencesOfString:search withString:replace];
        html= [html stringByReplacingOccurrencesOfString:search1 withString:@""];
        html= [html stringByReplacingOccurrencesOfString:search2 withString:@""];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        
        
    }
    //        NSString * regEx = @"<([^>]*)>";
    //        html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


//过滤掉字符串的所有空格
+(NSString*)filtrationSpace1:(NSString*)string{
    
    NSString *str;
    //去掉前后空格
    str =  [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return  str;
    
    
    
    
}

+(NSString*)filtrationSpace:(NSString*)string{
    
    NSString *str;
    //去掉前后空格
    str =  [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return  str;
    
    
    
    
}


+ (NSString*)StringToIntercept:(NSString*)UpdateTimeStr
{
//    NSDate *d = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
//    NSString *strDate = [formatter1 stringFromDate:d];
    
    NSString *interceptStr;
//    NSString *dateMonthYearStr = [UpdateTimeStr substringWithRange:NSMakeRange(0, 10)];
    
    //    if ([strDate isEqualToString:dateMonthYearStr]) {
    interceptStr = [UpdateTimeStr substringWithRange:NSMakeRange(11, 5)];
    //    }else{
    //        interceptStr = [UpdateTimeStr substringWithRange:NSMakeRange(0, 10)];
    //    }
    
    return interceptStr;
}


+ (NSString*)StringToIntercept1:(NSString*)UpdateTimeStr
{
    NSDate *d = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter1 stringFromDate:d];
    
    NSString *dateMonthYearStr = [UpdateTimeStr substringWithRange:NSMakeRange(0, 10)];
    
    if ([strDate isEqualToString:dateMonthYearStr]) {
        return nil;
    }
    //    }else{
    //        interceptStr = [UpdateTimeStr substringWithRange:NSMakeRange(0, 10)];
    //    }
    
    return [UpdateTimeStr substringWithRange:NSMakeRange(6, 5)];
}

/**
 *  char 转nsstring类型
 *
 *  @param ch char
 *
 *  @return nsstring
 */
+(NSString*)charChangeString:(char*)ch{
    
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    NSInteger nLen = strlen(ch)>6?6:strlen(ch);
    NSString* str = [[NSString alloc]initWithBytes:ch length:nLen encoding:enc];
    return str;
}
+(void)writeToFile:(NSString*)data folderName:(NSString*)folderName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent: [NSString stringWithFormat:@"ZJCaches/%@",folderName]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    NSString *pStr = [diskCachePath stringByAppendingString:@"/data.txt"];
    [data writeToFile:pStr atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}
+(NSString*)readFromFileWithTheFolderPath:(NSString*)folderPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"ZJCaches/%@",folderPath] ];
    NSString *pStr = [diskCachePath stringByAppendingString:@"/data.txt"];
    NSString *dataStr = [NSString stringWithContentsOfFile:pStr encoding:NSUTF8StringEncoding error:nil];
    return dataStr;
    
}



+ (NSString*)weekdayStringFromDate
{
    NSDate *inputDate = [NSDate date];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"7", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    NSString *weekStr = [weekdays objectAtIndex:theComponents.weekday];
    return weekStr ;
}

+ (NSString *)ByTheNameOfTheCountryToGetThePictureOfTheCountry:(NSString*)countryName
{
    NSString *imageName;
    
    if ([countryName isEqualToString:@"AU"]) {
        imageName = @"ao_daliya";
    }else if ([countryName isEqualToString:@"DE"]){
        imageName = @"de_guo";
    }else if ([countryName isEqualToString:@"FR"]){
        imageName = @"fa_guo";
    }else if ([countryName isEqualToString:@"KR"]){
        imageName = @"han_guo";
    }else if ([countryName isEqualToString:@"CA"]){
        imageName = @"jia_nada";
    }else if ([countryName isEqualToString:@"US"]){
        imageName = @"mei_guo";
    }else if ([countryName isEqualToString:@"CH"]){
        imageName = @"rui_shi";
    }else if ([countryName isEqualToString:@"JP"]){
        imageName = @"ri_ben";
    }else if ([countryName isEqualToString:@"SG"]){
        imageName = @"xin_jiapo";
    }else if ([countryName isEqualToString:@"NZ"]){
        imageName = @"xin_xilan";
    }else if ([countryName isEqualToString:@"IT"]){
        imageName = @"yi_dali";
    }else if ([countryName isEqualToString:@"GB"]){
        imageName = @"ying_guo";
    }else if ([countryName isEqualToString:@"CN"]){
        imageName = @"zhong_guo";
    }else if ([countryName isEqualToString:@"HK"]){
        imageName = @"xiang_gang";
    }else if ([countryName isEqualToString:@"EU"]){
        imageName = @"ou_yuan";
    }else if ([countryName isEqualToString:@"TW"]){
        imageName = @"zhong_guo";
    }else if ([countryName isEqualToString:@"OECD"]){
        imageName = @"oecd";
    }
    
    
    return imageName;
}

/**
 *  根据市场Type转16进制
 *
 *  @param marketType 市场Type
 *
 *  @return short
 */
+(unsigned short)marketTypeChangeShort:(NSString*)marketType{
    
    unsigned short sh = 0;
    if([marketType isEqualToString:@"5b00"]){
        sh = 0x5b00;
    }
    
    if([marketType isEqualToString:@"5b01"]){
        sh = 0x5b01;
    }
    if([marketType isEqualToString:@"5a00"]){
        sh = 0x5a00;
    }
    if([marketType isEqualToString:@"5a01"]){
        sh = 0x5a01;
    }
    if([marketType isEqualToString:@"5a02"]){
        sh = 0x5a02;
    }
    if([marketType isEqualToString:@"5a03"]){
        sh = 0x5a03;
    }
    if([marketType isEqualToString:@"5a04"]){
        sh = 0x5a04;
    }
    if([marketType isEqualToString:@"5a05"]){
        sh = 0x5a05;
    }
    if([marketType isEqualToString:@"5a06"]){
        sh = 0x5a06;
    }
    if([marketType isEqualToString:@"8100"]){
        sh = 0x8100;
    }
    if([marketType isEqualToString:@"5a07"]){
        sh = 0x5a07;
    }
    if([marketType isEqualToString:@"5400"]){
        sh = 0x5400;
    }
    if([marketType isEqualToString:@"5700"]){
        sh = 0x5700;
    }
    if([marketType isEqualToString:@"5a08"]){
        sh = 0x5a08;
    }
    if([marketType isEqualToString:@"5a09"]){
        sh = 0x5a09;
    }
    if([marketType isEqualToString:@"5a0a"]){
        sh = 0x5a0a;
    }
    if([marketType isEqualToString:@"5a0b"]){
        sh = 0x5a0b;
    }
    return sh;
}
+ (void)deleteFile:(NSString*)folderName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *filePath1 = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",folderName]];
    BOOL Have = [[NSFileManager defaultManager] fileExistsAtPath:filePath1];
    if (!Have){
        NSLog(@"在改路径下文件不存在");
        return;
        
    }else{
        BOOL delete = [[NSFileManager defaultManager]removeItemAtPath:filePath1 error:nil];
        if (delete) {
            //            NSLog(@"删除成功");
            
        }else{
            
            //            NSLog(@"删除失败");
        }
    }
    
}
/**
 *  根据16进制转市场Type
 *
 *  @param unsigned short 市场Type16进制
 *
 *  @return marketType
 */

+(NSString*)shortChangeMarketType:(unsigned short)shortType{
    
    NSString *s;
    switch (shortType) {
        case 0x5b00:
            s = @"5b00";
            break;
        case 0x5b01:
            s = @"5b01";
            break;
        case 0x5a00:
            s = @"5a00";
            break;
        case 0x5a01:
            s = @"5a01";
            break;
        case 0x5a02:
            s = @"5a02";
            break;
        case 0x5a03:
            s = @"5a03";
            break;
        case 0x5a04:
            s = @"5a04";
            break;
        case 0x5a05:
            s = @"5a05";
            break;
        case 0x5a06:
            s = @"5a06";
            break;
        case 0x8100:
            s = @"8100";
            break;
        case 0x5a07:
            s = @"5a07";
            break;
        case 0x5400:
            s = @"5400";
            break;
        case 0x5700:
            s = @"5700";
            break;
        case 0x5a08:
            s = @"5a08";
            break;
        case 0x5a09:
            s = @"5a09";
            break;
        case 0x5a0a:
            s = @"5a0a";
            break;
        case 0x5a0b:
            s = @"5a0b";
            break;
        default:
            break;
    }
    
    
    return s;
    
}


/**
 *  计算主推的当前时间
 */


+(NSString*)getMainPush:(NSString*)date mid:(NSString*)mid{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yMMddHHmm"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDate *d = [formatter dateFromString:date];
    //    [formatter1 setDateFormat:@"yyyyMMddhhmm"];
    
    
    NSString *dateString = [formatter stringFromDate:[NSDate dateWithTimeInterval:[mid integerValue]*60 sinceDate:d]];
    
    
    return dateString;
}


/**
 *  计算当前时间秒数
 *
 *  @return 时间秒数
 */
+(NSTimeInterval)getTimeIntervalForNowDateWithTime:(NSString*)time{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (time != nil) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString =  [formatter stringFromDate:[NSDate date]];
        NSTimeInterval sec = [[formatter dateFromString:dateString] timeIntervalSince1970] + [time integerValue] * 60 + 86400;
        return sec;
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString =  [formatter stringFromDate:[NSDate date]];
        NSTimeInterval sec = [[formatter dateFromString:dateString] timeIntervalSince1970];
        return sec;
    }
    
}

/**
 *  获取当前屏幕显示的viewcontroller
 *
 *  @return viewcontroller
 */

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark -- 判断是否超时
//+(BOOL )compareWithCurrentTimeByCompareDate:(NSDate*) compareDate WithMin:(int)Interval
//{
//    
//    if (compareDate == nil) {
//        return YES;
//    }else{
//        
//        NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
//        timeInterval = -timeInterval;
//
//        if (timeInterval < Interval * 60) {
//            //没有超时
//            if ([DealSocketTool shareInstance].connectToRemote == YES) {
//                //判断服务器是否连接
//                NSString *LoginPassWordStr = [DealSocketTool shareInstance].LoginPassWordStr;
//                if (LoginPassWordStr == nil || [LoginPassWordStr isEqualToString:@""]) {
//                    //没有登录密码的时候也是认为超时
//                    return YES;
//                }else{
//                    return NO;
//                }
//            }else{
//                //没有连接超时
//                return YES;
//            }
//        }else{
//            //超时(切断socket连接)
//            [[DealSocketTool shareInstance] cutOffSocket];
//            return YES;
//        }
//    }
//}

+(BOOL )compareWithCurrentTimeByCompareDate:(NSDate*) compareDate WithMin:(int)Interval
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;

    if ([Util isNetWork]) {
        if (compareDate == nil) {
            return YES;
        }else{
            
            if (timeInterval < Interval * 60) {
                //没有超时
                NSString *LoginPassWordStr = [DealSocketTool shareInstance].LoginPassWordStr;
                if (LoginPassWordStr == nil || [LoginPassWordStr isEqualToString:@""]) {
                    //没有登录密码的时候也是认为超时
                    return YES;
                }else{
                    //存在登录密码
                    if ([DealSocketTool shareInstance].connectToRemote == YES) {
                        //判断服务器是否连接
                        return NO;
                    }else{
                        //没有连接超时 & 断开连接
                        if ([DealSocketTool shareInstance].SocketActiveTag == SocketActiveTypeFromBackground) {
                            return NO;
                        }else{
                            return YES;
                        }
                    }
                }
            }else{
                //超时(切断socket连接)
                [[DealSocketTool shareInstance] cutOffSocket];
                return YES;
            }
        }
    }else{
        
        if (timeInterval < Interval * 60) {
            //断网 & 没有超时
            return NO;
        }else{
            return YES;
        }
    }
}



#pragma mark -- 判断时间差是否超出
+(BOOL)isDealSocketLoginOutOfTime
{
    NSDate *compareDate = [NSUserDefaults objectForKey:LastOpenTime];
    if (compareDate == nil) {
        return YES;
    }else{
        NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
        timeInterval = -timeInterval;
        if (timeInterval < DealSocketLoginTime * 60) {
            //没有超时
            return NO;
        }else{
            //超时
            return YES;
        }
    }
}

#pragma mark --返回横线
+(UIView *)setUpLineWithFrame:(CGRect)frame{

    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.3;
    return line;
}

#pragma mark -一个字符串两种颜色
+ (NSAttributedString *) setFirstString:(NSString *)firstString secondString:(NSString *)secondString firsColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor{
    NSString *string = [NSString stringWithFormat:@"%@%@",firstString,secondString]; //目标字段
    
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [mutaString addAttribute:NSForegroundColorAttributeName value:firstColor range:NSMakeRange(0,firstString.length)];
    [mutaString addAttribute:NSForegroundColorAttributeName value:secondColor range:NSMakeRange(firstString.length,secondString.length)];
    
    return mutaString;
}

#pragma mark -一个字符串两种颜色两种字体
+ (NSAttributedString *) setFirstString:(NSString *)firstString secondString:(NSString *)secondString firsColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor firstFont:(UIFont *) firstFont secondFont:(UIFont *) secondFont{
    NSString *string = [NSString stringWithFormat:@"%@%@",firstString,secondString]; //目标字段
    
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [mutaString addAttributes:@{NSForegroundColorAttributeName:firstColor,
                                           NSFontAttributeName:firstFont}
                        range:NSMakeRange(0,firstString.length)];
    
    [mutaString addAttributes:@{NSForegroundColorAttributeName:secondColor,
                                NSFontAttributeName:secondFont}
                        range:NSMakeRange(firstString.length,secondString.length)];
    
    return mutaString;
}

#pragma mark -一个字符串三种颜色两种字体
+ (NSAttributedString *) setFirstString:(NSString *)firstString secondString:(NSString *)secondString threeString:(NSString *)threeString firsColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor threeColor:(UIColor *)threeColor firstFont:(UIFont *) firstFont secondFont:(UIFont *) secondFont threeFont:(UIFont *)threeFont{
    NSString *string = [NSString stringWithFormat:@"%@%@%@",firstString,secondString,threeString]; //目标字段
    
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [mutaString addAttributes:@{NSForegroundColorAttributeName:firstColor,
                                NSFontAttributeName:firstFont}
                        range:NSMakeRange(0,firstString.length)];
    
    [mutaString addAttributes:@{NSForegroundColorAttributeName:secondColor,
                                NSFontAttributeName:secondFont}
                        range:NSMakeRange(firstString.length,secondString.length)];
    
    [mutaString addAttributes:@{NSForegroundColorAttributeName:threeColor,
                                NSFontAttributeName:threeFont}
                        range:NSMakeRange(firstString.length + secondString.length,threeString.length)];
    
    return mutaString;
}

#pragma mark -一个字符串多种颜色,字体
+ (NSAttributedString *) setStringsArr:(NSArray<NSString *> *) stringsArr ColorsArr:(NSArray<UIColor *> *) colorsArr FontsArr:(NSArray <UIFont *> *) fontsArr{
    
     NSString *string = @"";//目标字段
    
    for (NSString *str in stringsArr) {
        string = [NSString stringWithFormat:@"%@%@",string,str];
    }
    
    
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:string];
    for (int i = 0; i < stringsArr.count; i++) {
        
        CGFloat location = 0;
        for (int j = 0; j < i; j++) {
            NSString *str = stringsArr[j];
            location = location + str.length;
        }
        
        [mutaString addAttributes:@{NSForegroundColorAttributeName:colorsArr[i],
                                    NSFontAttributeName:fontsArr[i]}
                            range:NSMakeRange(location,stringsArr[i].length)];
    }
    
    return mutaString;
}




#pragma mark -- 银行卡号对应银行

+ (NSString *)returnBankNameWith:(NSString*) idCard InBankArr:(NSArray *)bankArr{
    
    for (NSDictionary *bank in bankArr) {
        if ([bank[@"bin"] isEqualToString:idCard]) {
            return bank[@"bankName"];
        }
    }
    
    return @"";
}

+(NSString *)returnBankNameByBankID:(NSString *)bankID{
    
    NSDictionary *bankDic = @{@"1":@"农业银行",
                              @"2":@"北京银行",
                              @"3":@"中国银行",
                              @"4":@"上海银行",
                              @"5":@"渤海银行",
                              @"6":@"建设银行",
                              @"7":@"光大银行",
                              @"8":@"兴业银行",
                              @"9":@"中信银行",
                              @"10":@"招商银行",
                              @"11":@"民生银行",
                              @"12":@"交通银行",
                              @"13":@"广东发展银行",
                              @"14":@"华夏银行",
                              @"15":@"工商银行",
                              @"16":@"宁波银行",
                              @"17":@"南京银行",
                              @"18":@"中国邮储银行",
                              @"19":@"浦东发展银行",
                              @"20":@"平安银行",};
    
    return bankDic[bankID];
    
}

//银行编码转名称
+(NSString *)returnBankNameByBankCode:(NSString *)bankCode{
    
    NSDictionary *bankDic = @{@"ABC":@"农业银行",
                              @"BCCB":@"北京银行",
                              @"BOC":@"中国银行",
                              @"BOS":@"上海银行",
                              @"CBHB":@"渤海银行",
                              @"CCB":@"建设银行",
                              @"CEB":@"光大银行",
                              @"CIB":@"兴业银行",
                              @"CITIC":@"中信银行",
                              @"CMB":@"招商银行",
                              @"CMBC":@"民生银行",
                              @"COMM":@"交通银行",
                              @"GDB":@"广东发展银行",
                              @"HXB":@"华夏银行",
                              @"ICBC":@"工商银行",
                              @"NBCB":@"宁波银行",
                              @"NJCB":@"南京银行",
                              @"PSBC":@"中国邮储银行",
                              @"SPDB":@"浦东发展银行",
                              @"SZPAB":@"平安银行",};
    
    return bankDic[bankCode];

}

+(NSString *)returnBankCodeByBankID:(NSString *)bankID{
    
    NSDictionary *bankDic = @{@"1":@"ABC",
                              @"2":@"BCCB",
                              @"3":@"BOC",
                              @"4":@"BOS",
                              @"5":@"CBHB",
                              @"6":@"CCB",
                              @"7":@"CEB",
                              @"8":@"CIB",
                              @"9":@"CITIC",
                              @"10":@"CMB",
                              @"11":@"CMBC",
                              @"12":@"COMM",
                              @"13":@"GDB",
                              @"14":@"HXB",
                              @"15":@"ICBC",
                              @"16":@"NBCB",
                              @"17":@"NJCB",
                              @"18":@"PSBC",
                              @"19":@"SPDB",
                              @"20":@"SZPAB",};
    
    return bankDic[bankID];
    
}


//add by ben 2016.06.28增加已阅读新闻纪录
+(void)setNewsReadedLabel:(UILabel *)label ColorByCodeStr:(NSString *)code{
    
    NSMutableDictionary *newsReadDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewsReaded"];
    
    UIColor *color;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"WhetherOrNotNight"]) {
        //日间模式
        color = OXColor(0x111111);
        
    }else{
        //夜间模式
        color = OXColor(0x979797);
    }
    
    if (newsReadDic != nil) {
        if ([newsReadDic[code] isEqualToString:@"1"]) {
            
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"WhetherOrNotNight"]) {
                //日间模式
                color = OXColor(0x999999);
                
            }else{
                //夜间模式
                color = OXColor(0x444444);
            }
            
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //返回主线程刷新UI
        label.textColor = color;
        
    });
    
}

+ (NSString *)GetsTheCurrentCalendarByDateFormat:(NSString *)format
{
    NSDate *d = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:format];
    NSString *strDate = [formatter1 stringFromDate:d];
    return  strDate;
    
}

//静态的判断是否有网络
+(BOOL)isNetWork{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}


+(void)isNetWorkWithBlock:(void (^)(BOOL isNetWork))netWorkBlock{
    
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        switch (status)
        {
            case RealStatusNotReachable:
            {
                netWorkBlock(NO);
                break;
            }
                
            case RealStatusViaWiFi:
            {
                netWorkBlock(YES);
                break;
            }
                
            case RealStatusViaWWAN:
            {
                netWorkBlock(YES);
                break;
            }
                
            default:
                netWorkBlock(YES);
                break;
        }
    }];
}


#pragma mark -- 因为用户登录时(账号或者手机号都能登录),此处用UserID最为唯一识别的标识
//当前账号的手势密码开启状态
+(NSString *)isSHPassWord{
    
    NSString *key = [NSString stringWithFormat:@"%@%@",[NSUserDefaults objectForKey:UserID],@"isSHPassWord"];//手势密码
    
    return  key;
}
//当前账号的手势密码代替交易登录密码
+(NSString *)DealSHReplacePassWord{

    NSString *userid = [NSUserDefaults objectForKey:UserID];
    NSString *key = [NSString stringWithFormat:@"%@%@",userid,@"DealSHReplacePassWord"];//交易手势密码(存放交易的登录密码)
    
    return  key;
}

//当前账号的指纹密码开启状态
+(NSString *)isTouchIDPassWord{

   NSString *key = [NSString stringWithFormat:@"%@%@",[NSUserDefaults objectForKey:UserID],@"isTouchIDPassWord"];//指纹密码
    
    return key;
}

//当前账号的手势密码1
+(NSString *)passwordone{

    NSString *key = [NSString stringWithFormat:@"%@%@",[NSUserDefaults objectForKey:UserID],@"passwordone"];//手势密码1
    
    return key;
}
//当前账号的手势密码2
+(NSString *)passwordtwo{

    NSString *key = [NSString stringWithFormat:@"%@%@",[NSUserDefaults objectForKey:UserID],@"passwordtwo"];//手势密码2
    
    return key;
}

//json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
        
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

//base64编码的字符串
+(NSString *)returnBase64StrByData:(NSData *)data{
    
    NSData *base64Data =  [data base64EncodedDataWithOptions:0];
    NSString *base64DataStr = [[NSString alloc]
                               initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return base64DataStr;
}

//带有标题,信息的alertView
+(void)alertViewWithTitle:(NSString *)title Message:(NSString *)message Target:(UIViewController *)target{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [target presentViewController:alertController animated:YES completion:nil];
}
//字体的alertView 
+(void)alertViewWithMessage:(NSString *)message Target:(UIViewController *)target{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, message.length)];
    [alertController setValue:alertMessageStr forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [target presentViewController:alertController animated:YES completion:nil];

}
//自定义弹出窗口
+(void)alertViewWithCancelBtnAndMessage:(NSString *)message Target:(UIViewController *)target doActionBtn:(NSString *)doActionBtn handler:(void (^ __nullable)(UIAlertAction *action))handler{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, message.length)];
    [alertController setValue:alertMessageStr forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:doActionBtn style:UIAlertActionStyleDefault handler:handler];
    [alertController addAction:doAction];
    [target presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (NSString *)getIPV4String{

    NSDictionary *IPDic = [self getIPAddresses];
    NSString *_IPV4Str =  IPDic[@"en0/ipv4"];
    if (_IPV4Str == nil) {
        _IPV4Str =  IPDic[@"pdp_ip0/ipv4"];
    }
    if (_IPV4Str == nil) {
        _IPV4Str = @"127.0.0.1";
    }
    
    return _IPV4Str;
}

//返回程序的window
+(UIWindow *)appWindow{

    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return  window;
}

//(开户的界面)此处是因为多个HUD加在window上边会出现显示位置错误的问题,自己封装一个在当前页面调用
+ (void)showHUDAddTo:(UIView *)view Text:(NSString *)text {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    [hud hideAnimated:YES afterDelay:1.5f];
}
//轻仓,重仓,满仓
+(NSString *)holdTypeWithFrozenReserve:(NSString *) FrozenReserve Amount:(NSString *) Amount{
    
//  持仓占比 =账户履约保证金÷账户净值×100%
//  持仓结构，如持仓占比≤10%，则为轻仓；10%＜持仓占比≤50%，则为中仓；如50%＜持仓占比≤90%，则为重仓；如持仓占比＞90%，则为满仓。
    double all = ([Amount doubleValue]);
    double hold;
    if (all == 0) {
        hold = 0;
    }else{
        hold = ([FrozenReserve doubleValue] / all);
    }
    NSString *holdType;
    //处理四舍五入的显示问题
    if (hold <= 0) {
        holdType = @"空仓";
    }else if (hold < 0.105) {
        holdType = @"轻仓";
    }else if (hold < 0.505){
        holdType = @"中仓";
    }else if (hold < 0.905){
        holdType = @"重仓";
    }else{
        holdType = @"满仓";
    }
    return holdType;
}
//获取不同品种的计量单位的选择
+(NSDictionary *)weightStepDicByComID{
    //银,铂,钯
    NSDictionary *dic = @{@"100000000":@[@"0.1",@"1",@"15",@"100"],
                          @"100000001":@[@"0.001",@"0.1",@"1"],
                          @"100000002":@[@"0.001",@"0.1",@"1"]};
    return dic;
}

//返回下单时候市价指价的图片
+(UIImage *)getImgbyType:(BuyOrderType) type PriceType:(PriceOrderType)priceType
{
    NSDictionary *dic = @{@"00":@"market_up",
                          @"01":@"index_up",
                          @"10":@"market_down",
                          @"11":@"index_down",
                          @"20":@"closeOrder",
                          @"21":@"closeOrder"};
    
    NSString *key = [NSString stringWithFormat:@"%ld%ld",(long)type,(long)priceType];
    UIImage *img = [UIImage imageNamed:dic[key]];
    return img;
}

//  颜色转换为背景图片
+(UIImage *)imageWithColor:(UIColor *)color Size:(CGSize) size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//照片缩放,防止失真
+(UIImage*)OriginImage:(UIImage *)OriginImage scaleToSize:(CGSize)size
{
    //防止缩放失真
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    // 绘制改变大小的图片
    [OriginImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

//买卖方向
+(int)getOPENDIRECTOR_DIRECTIONByBuyOrderType:(BuyOrderType) type{
    
    OPENDIRECTOR_DIRECTION direction;
    if (type == BuyOrderTypeUp) {
        direction = OPENDIRECTOR_BUY;	///< 建仓方向
    }else if (type == BuyOrderTypeDown){
        direction = OPENDIRECTOR_SELL;	///< 建仓方向
    }
    return direction;
}

//模拟手动点击交易按钮
+(void)goToDeal{

    //回退到rootVC 2017.02.23
    [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
        
        [dealVC.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    UITabBarController *tabBarC = (UITabBarController *)[Util appWindow].rootViewController;

    if ([tabBarC isKindOfClass:[NSClassFromString(@"IITabBarController") class]]) {
        [tabBarC setSelectedIndex:2];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"交易" image:nil tag:2];
        [tabBarC tabBar:tabBarC.tabBar didSelectItem:item];
    }
}

/**
 *  新浪支付的接口方法
 */
+(NSString *)getSinaBangdingUrlBytype:(SinaBangdingUrlType) type{
    
    NSString *urlType;
    
    switch (type) {
        case validate_identity:
            urlType = @"validate_identity";
            break;
        case create_activate_member:
            urlType = @"create_activate_member";
            break;
        case set_real_name:
            urlType = @"set_real_name";
            break;
        case binding_bank_card:
            urlType = @"binding_bank_card";
            break;
        case binding_bank_card_advance:
            urlType = @"binding_bank_card_advance";
            break;
        case query_bank_card:
            urlType = @"query_bank_card";
            break;
        case unbinding_bank_card:
            urlType = @"unbinding_bank_card";
            break;
        case unbinding_bank_card_advance:
            urlType = @"unbinding_bank_card_advance";
            break;
        case egs_member_revoke:
            urlType = @"egs_member_revoke";
            break;
        case advance_hosting_pay:
            urlType = @"advance_hosting_pay";
            break;
        case create_hosting_withdraw:
            urlType = @"create_hosting_withdraw";
            break;
        default :
            break;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@.aspx?",SinaBangdingHost,urlType];
    return urlStr;
    
}

/**
 *  转账记录的接口方法
 */
+(NSString *)getTransAmountUrlBytype:(TransAmountUrlType) type{
    
    NSString *urlType;
    
    switch (type) {
        case AddWithdrawLog:
            urlType = @"AddWithdrawLog";
            break;
        case GetWithdrawListById:
            urlType = @"GetWithdrawListById";
            break;
        case GetSumAmount:
            urlType = @"GetSumAmount";
            break;
               default :
            break;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?",TransAmountHost,urlType];
    return urlStr;
    
}


//点击详情页面直接进入对应品种的买涨.买跌
+(void)goToDealFromeType:(DealFromType) type Code:(NSString *) code{
    
    NSInteger codeIndex = 0;
    if ([code isEqualToString:@"GDAG"]) { //越贵银
        codeIndex = 0;
    } else if ([code isEqualToString:@"GDPT"]) { //铂
        codeIndex = 1;
    } else if([code isEqualToString:@"GDPD"]){ //钯
        codeIndex = 2;
    }
    
    UITabBarController *tabVC = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    UINavigationController *nav = tabVC.childViewControllers[2];
    NSArray *arr = nav.childViewControllers;
    DealViewController *dealVC;
    for (id vc in arr) {
        if ([vc isKindOfClass:[DealViewController class]]) {
            dealVC = vc;
            break;
        }
    }
    if (tabVC.selectedIndex == 2) {
        [dealVC.navigationController popViewControllerAnimated:YES];
    }
    dealVC.fromType = type;
    BuyUpDownOrderViewController *buyVC;
    buyVC = dealVC.childViewControllers[type];
    buyVC.segmentControl.selectedSegmentIndex = 0;
    [buyVC actionSegmentControl:buyVC.segmentControl];
    [NSUserDefaults setObject:@(codeIndex) forKey:VarietyIndex];
    [buyVC viewWillAppear:YES];
    
    [Util goToDeal];
}
//处理用户头像
+(void)setPhotoImgUrlWithHost:(NSString *) host{
    
    NSString *userId = [NSUserDefaults objectForKey:UserID];
    int i = arc4random() % 256;
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/MilkVip/%@/%@.jpg?%d",host,userId,userId,i];
    [NSUserDefaults setObject:urlStr forKey:PhotoImgUrl];
}

//获取当前账号的银行卡号
+(NSString *)getCardStr{

    NSString *bank = [NSUserDefaults objectForKey:SinaBangdingBank];
    NSString *bankCard = [NSUserDefaults objectForKey:SinaBangdingBankCard];
    if (bankCard == nil || [bankCard isEqualToString:@""]) {
        return @"";
    }else{
        NSString *cardStr = [NSString stringWithFormat:@"%@(%@)",[Util returnBankNameByBankCode:bank],[bankCard substringFromIndex:(bankCard.length - 4)]];
        return cardStr;
    }
}
//获得交易界面的VC,便于网络和其他的提示
+(void)getDealViewControllerWithBlock:(void(^)(UIViewController* dealVC) )block{

    UIViewController *tab = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([tab isKindOfClass:[NSClassFromString(@"IITabBarController") class]]) {
        UINavigationController *nav = tab.childViewControllers[2];
        for (id childVC in nav.childViewControllers) {
            if ([childVC isKindOfClass:[NSClassFromString(@"DealViewController") class]]) {
                if (block) {
                    block(childVC);
                }
                break;
            }
        }
    }
}

//根据品种的ID得到价格显示的位数
+(NSString *)getPriceDigitByComID:(NSString *)comID{
    
    NSInteger n;
    if ([comID isEqualToString:@"100000000"]) {
        n = 0;
    }else{
        n = 2;
    }
    NSString *str = @"%%.%@f";
    NSString *priceDigit = [NSString stringWithFormat:str,@(n)];
    return priceDigit;
}

//根据品种的ID得到重量显示的位数
+(NSString *)getWeightDigitByComID:(NSString *)comID{
    
    NSInteger n;
    if ([comID isEqualToString:@"100000000"]) {
        n = 1;
    }else{
        n = 3;
    }
    NSString *str = @"%%.%@f";
    NSString *priceDigit = [NSString stringWithFormat:str,@(n)];
    return priceDigit;
}

//日期转换为时间戳 (日期转换为秒数)
+(long)dateToUTCWithdDate:(NSDate *)date{
    
    NSTimeInterval timeStamp= [date timeIntervalSince1970];
    return timeStamp;
}

//日期转换为时间戳 (日期转换为秒数)
+(NSString *)dateToUTCWithDate:(NSString *)dateStr{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSTimeInterval timeStamp= [date timeIntervalSince1970];
    NSString *str = [NSString stringWithFormat:@"%f",timeStamp];
    return str;
}

//自定义日期转换为时间戳 (日期转换为秒数)
+(NSString *)dateToUTCWithDate:(NSString *)dateStr DateFormatter:(NSString *) dateFormatterStr{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormatterStr];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSTimeInterval timeStamp= [date timeIntervalSince1970];
    NSString *str = [NSString stringWithFormat:@"%f",timeStamp];
    return str;
}

//时间戳转日期 (秒数转日期)
+(NSString *)UTCToDateWithUTC:(NSString *) timeStamp{
    
    long long int ndate = (long long int)[timeStamp intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ndate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateFormatStr = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:dateFormatStr];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

//获取默认的用户头像
+(UIImage *)getUserHeaderImage{

    NSString *userImgData = [NSString stringWithFormat:@"%@userImgData",[NSUserDefaults objectForKey:UserID]];
    NSData *imgData = [NSUserDefaults objectForKey:userImgData];
    UIImage *headImage = [UIImage imageWithData:imgData];
    if (headImage == nil) {
        headImage = [UIImage imageNamed:@"headImage"];
    }

    return headImage;
}
//处理iphone5的导航栏颜色色差
+(UIColor *)navigationBarColor{
    
    UIColor *color;
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString containsString:@"iPhone5"]) { //iphone5特别, 单独改颜色
        color = OXColor(0x1a82cb);
    }else{
        color = kNavigationBarColor;
    }
    
    return color;
}
//匹配是否包含敏感词
+(BOOL)CommentContent:(NSString *)commentStr SensitiveWords:(NSString *)regulationsStr
{
    NSString *string = commentStr;
    NSString *tempStr = regulationsStr;
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    
    if(numberofMatch > 0)
    {
        return YES;
    }else{
        return NO;
    }
    
}

//极光推送设置别名
+(void)setJPushAlise:(NSString *) aliseStr{
    
    if (aliseStr == nil) {
        aliseStr = [NSUserDefaults objectForKey:KHSignAccount];
    }
    [JPUSHService setTags:nil alias:aliseStr fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        LOG(@"极光推送设置别名结果:%d -- %@",iResCode,iAlias);
    }];
}

//浮点型转字符串,不进行四舍五入
+(NSString *)notRounding:(double)dValue afterPoint:(int)position{
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:dValue];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end
