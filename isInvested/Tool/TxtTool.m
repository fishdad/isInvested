//
//  TxtTool.m
//  isInvested
//
//  Created by Blue on 16/10/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "TxtTool.h"
#import "IndexModel.h"
#import "FMDB.h"

@implementation TxtTool

static FMDatabase *_db;

+ (void)initialize {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"indexes_base.sqlite"];
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    // 打开数据库
    if ([_db open]) {
        
        // 创建表格
        if ([_db executeUpdate:@"create table if not exists t_indexes_base (code_type text,date text,data blob,primary key(code_type));"]) {
            LOG(@"t_indexes_base表创建成功");
        } else {
            LOG(@"t_indexes_base表创建失败");
        }
        
    } else {
        LOG(@"FMDatabase 打开失败");
    }
}

/** 存储txt数据 */
+ (void)saveWithTxtData:(NSDictionary *)dictionary {
    
    // 删除成功后, 再插入
    if ([_db executeUpdateWithFormat:@"delete from t_indexes_base where code_type = %@", dictionary[@"codetype"]]) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
        BOOL flag = [_db executeUpdate:@"insert into t_indexes_base (code_type,date,data) values(?,?,?)", dictionary[@"codetype"], dictionary[@"date"], data];
        
        if (flag) {
            LOG(@"txt插入成功");
        } else {
            LOG(@"txt插入失败");
        }
        
    } else {
        LOG(@"删除失败--");
    }
}

/** 当前codeType是否需要请求txt */
+ (BOOL)isNeedRequestByCodeType:(NSString *)codeType {
    
    NSString *dateStr;
    NSString *sql = [NSString stringWithFormat:@"select date from t_indexes_base where code_type like '%%%@'", codeType];
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        dateStr = [set stringForColumn:@"date"];
    }
    if (!dateStr) return YES; //没取到值, 要请求txt
    
    // txt显示的时间更新于闭市时间, 本地的txt文档里的日期等于今天的日期, 不需要再请求
    if ([dateStr isEqualToString:[@"yyyyMMdd" currentTime]]) return NO;
    
    // 取到数据, 再判断有没有过期
    // 大于等于闭市时间, 会产生新的昨收价, 需要重新请求
    NSInteger now = [@"HHmm" currentTime].integerValue;
    switch (strtoul([[@"0x" stringByAppendingString:codeType] UTF8String], 0, 0)) {
            
        case 0x5b00:
            if (now >= 600) return YES;
            break;
            
        case 0x5400:
            if (now >= 515) return YES;
            break;
            
        default: //0x5a01 & 0x8100
            if (now >= 400) return YES;
            break;
    }
    return NO;
}

/** 取本地index字典 */
+ (NSDictionary *)indexWithCodeType:(NSString *)codeType andCode:(NSString *)code {
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_indexes_base where code_type like '%%%@'", [codeType substringFromIndex:4]];
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[set dataForColumn:@"data"]];
        for (NSDictionary *index in dic[@"list"]) {
            
            if ([index[@"code"] isEqualToString:code]) {
                NSMutableDictionary *newIndex = [NSMutableDictionary dictionaryWithDictionary:index];
                [newIndex setObject:dic[@"open_close_time"] forKey:@"open_close_time"];
                return newIndex;
            }
        }
    }
    return nil;
}

/** 取昨收 */
+ (CGFloat)preCloseWithCodeType:(NSString *)codeType code:(NSString *)code {
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_indexes_base where code_type like '%%%@'", [codeType substringFromIndex:4]];
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[set dataForColumn:@"data"]];
        for (NSDictionary *index in dic[@"list"]) {
            if ([index[@"code"] isEqualToString:code]) {
                return [index[@"preclose"] floatValue];
            }
        }
    }
    return 0.0;
}

/** 取开盘时间的分数数, 如06:00==360 */
+ (NSInteger)openTimeMinutesWithCodeType:(NSString *)codeType {
    
    switch (strtoul([codeType UTF8String], 0, 0)) {
        case 0x5b00:
            return 420;
        default: // 0x5a01 0x5400 0x8100
            return 360;
    }
}

/** 分钟总数 */
+ (NSInteger)minutesTotalWithCodeType:(NSString *)codeType {
    
    switch (strtoul([codeType UTF8String], 0, 0)) {
        case 0x5b00:
            return 1380;
        case 0x5400:
            return 1395;
        default: //0x5a01 0x8100
            return 1320;
    }
}

/** 传入索引号, 取当前时间 */
+ (NSString *)currentTimeWithNumber:(NSInteger)number codeType:(NSString *)codeType {
    
    NSInteger open = [TxtTool openTimeMinutesWithCodeType:codeType];
    // 取余一天的总分钟数, 再加开盘时间的分钟数, 得到有效的分钟数
    NSInteger current = number % [TxtTool minutesTotalWithCodeType:codeType] + open;
    // 小时>24需取余
    return [NSString stringWithFormat:@"%02ld:%02ld", current / 60 % 24, current % 60];
}

/** 取分时的时间栏数组 */
+ (NSArray *)timeSharingTimeArrayWithCodeType:(NSString *)codeType {
    
    NSInteger total = [TxtTool minutesTotalWithCodeType:codeType];
    NSInteger zero = [TxtTool openTimeMinutesWithCodeType:codeType];
    NSInteger one = zero + total * 0.25;
    NSInteger two = zero + total * 0.5;
    NSInteger three = zero + total * 0.75;
    NSInteger four = zero + total;
    
    NSString *str0 = [NSString stringWithFormat:@"%02ld:%02ld", zero / 60, zero % 60];
    NSString *str1 = [NSString stringWithFormat:@"%02ld:%02ld", one / 60, one % 60];
    NSString *str2 = [NSString stringWithFormat:@"%02ld:%02ld", two / 60, two % 60];
    NSString *str3 = [NSString stringWithFormat:@"%02ld:%02ld", three / 60, three % 60];
    NSString *str4 = [NSString stringWithFormat:@"%02ld:%02ld", four / 60 % 24, four % 60];
    return @[str0, str1, str2, str3, str4];
}

/** 存储历史分时 */
+ (void)saveHistoryTimeSharingData:(NSDictionary *)dict code:(NSString *)code day:(NSString *)day {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    BOOL flag = [_db executeUpdate:@"insert into t_indexes_base (code_type,date,data) values(?,?,?)",
                 [code stringByAppendingString:day], day, data];
    if (flag) {
        LOG(@"%@插入成功", code);
    } else {
        LOG(@"%@插入失败", code);
    }
}
/** 取历史分时数组 */
+ (NSDictionary *)getHistoryTimeSharingArrayWithCode:(NSString *)code date:(int)date {
    
    //是否需因为周末而跳过2天
    NSInteger days = date * -1;
    if (days >= [NSDate currentWeek]) days += 2;
    
    NSTimeInterval interval = kInterval1970 - days * kOneDaySeconds;
    NSString *dateStr = [@"yyyyMMdd" stringFromInterval1970:interval];
    
    NSString *name = [code stringByAppendingString:dateStr];
    NSString *sql = [NSString stringWithFormat:@"select * from t_indexes_base where code_type like '%%%@'", name];
    
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[set dataForColumn:@"data"]];
    }
    return nil;
}

/** 清除过期的数据 */
+ (void)clearOutDateData {
    
    NSTimeInterval interval = kInterval1970 - 6 * kOneDaySeconds; //删除6天前的数据
    NSString *dateStr = [@"yyyyMMdd" stringFromInterval1970:interval];
    
    if ([_db executeUpdateWithFormat:@"delete from t_indexes_base where date < %ld", dateStr.integerValue]) {
        LOG(@"删除过期data成功");
    }
}

@end
