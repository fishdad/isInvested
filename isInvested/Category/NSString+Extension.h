//
//  NSString+Extension.h
//  phone
//
//  Created by 吴忧 on 15/12/9.
//  Copyright © 2015年 吴峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSString (Extension)

/** DES加密 */
//- (NSString *)encryptUseDES;

/** DES解密 */
- (NSString *)decryptUseDES;

/** 传入需过滤掉的字符串数组 */
- (NSString *)separatedByArray:(NSArray *)array;

/** 传入需过滤掉的字符串 */
- (NSString *)separatedByString:(NSString *)string;

/** 返回字符串所占用的尺寸 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/** 最大值为 99999.99 */
- (NSString *)priceByTenThousand;

/** -1, 最小值=0 */
- (NSString *)minus1ByMinValueIs0;

/** +1, 最大值=99999.99 */
- (NSString *)plus1ByMaxValueIs99999point99;

/** 日期str后拼接 今天 昨天 前天, 交易明细里组标题用 */
- (NSString *)dateAppendingToday;


- (NSDate *)dateFromString:(NSString *)str;
- (NSString *)stringFromDate:(NSDate *)date;

/** 使用df, 调用当前的时间字符串 */
- (NSString *)currentTime;

/** 使用df, 传入1970秒, 取时间字符串 */
- (NSString *)stringFromInterval1970:(NSTimeInterval)interval;

/** 使用codeType调用休市的时间 */
- (NSString *)endTime;
- (NSString *)startTime;

@end
