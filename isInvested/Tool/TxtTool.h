//
//  TxtTool.h
//  isInvested
//
//  Created by Blue on 16/10/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IndexModel;

@interface TxtTool : NSObject

/** 存储txt数据 */
+ (void)saveWithTxtData:(NSDictionary *)dictionary;

/** 当前codeType是否需要请求txt */
+ (BOOL)isNeedRequestByCodeType:(NSString *)codeType;

/** 取本地index字典 */
+ (NSDictionary *)indexWithCodeType:(NSString *)codeType andCode:(NSString *)code;

/** 取昨收 */
+ (CGFloat)preCloseWithCodeType:(NSString *)codeType code:(NSString *)code;

/** 分钟总数 */
+ (NSInteger)minutesTotalWithCodeType:(NSString *)codeType;

/** 传入索引号, 取当前时间 */
+ (NSString *)currentTimeWithNumber:(NSInteger)number codeType:(NSString *)codeType;

/** 取分时的时间栏数组 */
+ (NSArray *)timeSharingTimeArrayWithCodeType:(NSString *)codeType;


/** 存储历史分时data */
+ (void)saveHistoryTimeSharingData:(NSDictionary *)dict code:(NSString *)code day:(NSString *)day;
/** 取历史分时数组 */
+ (NSDictionary *)getHistoryTimeSharingArrayWithCode:(NSString *)code date:(int)date;
/** 清除过期的数据 */
+ (void)clearOutDateData;
@end
