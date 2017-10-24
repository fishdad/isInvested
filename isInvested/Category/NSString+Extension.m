//
//  NSString+Extension.m
//  phone
//
//  Created by 吴忧 on 15/12/9.
//  Copyright © 2015年 吴峰. All rights reserved.
//

#import "NSString+Extension.h"
#import "GTMBase64.h"

@implementation NSString (Extension)

/** DES加密 */
//- (NSString *)encryptUseDES {
//    
//    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesEncrypted = 0;
//    
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
//                                          kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
//                                          [GGDataSkey UTF8String],
//                                          kCCKeySizeDES,
//                                          nil,
//                                          [data bytes],
//                                          [data length],
//                                          buffer,
//                                          1024,
//                                          &numBytesEncrypted);
//    
//    NSString* plainText = nil;
//    if (cryptStatus == kCCSuccess) {
//        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//        plainText = [GTMBase64 stringByEncodingData:dataTemp];
//    }else{
//        LOG(@"DES加密失败");
//    }
//    return plainText;
//}

/** DES解密 */
- (NSString *)decryptUseDES {
    
    // 利用 GTMBase64 解碼 Base64 字串
    NSData* cipherData = [GTMBase64 decodeString:self];
    
    NSInteger length = cipherData.length;
    
    unsigned char buffer[length];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    
    // IV 偏移量不需使用
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [GGDataSkey UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [cipherData bytes],
                                          length,  //固定写法
                                          buffer,
                                          length,  //可更长
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

/** 传入需过滤掉的字符串数组 */
- (NSString *)separatedByArray:(NSArray *)array {
    
    NSString *string = self;
    for (NSString *str in array) {
        string = [string stringByReplacingOccurrencesOfString:str withString:@""];
    }
    return string;
}

/** 传入需过滤掉的字符串 */
- (NSString *)separatedByString:(NSString *)string {
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:string];
    return [[self componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
}

//返回字符串所占用的尺寸
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{ NSFontAttributeName : font }
                              context:nil].size;
}

/** 最大值为 99999.99 */
- (NSString *)priceByTenThousand {
    
    if (self.integerValue > 99999) return [self substringToIndex:5];
    
    if ([self containsString:@"."]) { //有小数点
        NSRange range = [self rangeOfString:@"."];
        if (self.length - range.location > 3) {
            return [self substringToIndex:self.length - 1];
        }
    }
    return self;
}

/** -1, 最小值=0 */
- (NSString *)minus1ByMinValueIs0 {
    
    if (self.integerValue == 0) return @"0";
    return @(self.floatValue - 1).stringValue;
}

/** +1, 最大值=99999.99 */
- (NSString *)plus1ByMaxValueIs99999point99 {
    
    if (self.integerValue == 99999) {
        return @"99999.99";
    }
    return @(self.floatValue + 1).stringValue;
}

/** 日期str后拼接 今天 昨天 前天, 交易明细里组标题用 */
- (NSString *)dateAppendingToday {
    
    // 先取传入字符串的1970秒数
    NSTimeInterval seconds = [[@"yyyy-MM-dd" dateFromString:self] timeIntervalSince1970];
    NSInteger d = kInterval1970 - seconds;
    
    if (d < kOneDaySeconds) {
        return [self stringByAppendingString:@"  今天"];
        
    } else if (d < kTwoDaysSeconds) {
        return [self stringByAppendingString:@"  昨天"];
        
    } else if (d < kThreeDaysSeconds) {
        return [self stringByAppendingString:@"  前天"];
    }
    return self;
}

- (NSDate *)dateFromString:(NSString *)str {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = self;
    return [df dateFromString:str];
}
- (NSString *)stringFromDate:(NSDate *)date {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = self;
    return [df stringFromDate:date];
}

/** 使用df, 调用当前的时间字符串 */
- (NSString *)currentTime {
    return [self stringFromDate:[NSDate date]];
}
/** 使用df, 传入1970秒, 取时间字符串 */
- (NSString *)stringFromInterval1970:(NSTimeInterval)interval {
    return [self stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
}

/** 使用codeType调用休市的时间 */
- (NSString *)endTime {
    switch (strtoul([self UTF8String], 0, 0)) {
        case 0x5b00: return @"06:00";
        case 0x5400: return @"05:15";
        default:     return @"04:00";
    }
}
- (NSString *)startTime {
    switch (strtoul([self UTF8String], 0, 0)) {
        case 0x5b00:  return @"0700";
        default:      return @"0600";
    }
}

@end
