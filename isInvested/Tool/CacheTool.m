//
//  CacheTool.m
//  isInvested
//
//  Created by Blue on 16/12/29.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CacheTool.h"
#import "IndexModel.h"
#import "FMDB.h"

@implementation CacheTool

static FMDatabase *_db;

+ (void)initialize {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"indexes_cache.sqlite"];
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    // 打开数据库
    if ([_db open]) {
        
        // 创建表格
        if ([_db executeUpdate:@"create table if not exists t_indexes_cache (code text,style text,data blob,primary key(code,style));"]) {
            LOG(@"t_indexes_cache表创建成功");
        } else {
            LOG(@"t_indexes_cache表创建失败");
        }
        
    } else {
        LOG(@"FMDatabase 打开失败");
    }
}

+ (void)saveData:(id)obj withCode:(NSString *)code requestStyle:(SocketRequestStyle)style {
    
    // 删除成功后, 再插入
    if ([_db executeUpdateWithFormat:@"delete from t_indexes_cache where code = %@ and style = %ld", code, style]) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
        
        NSString *styleStr = [NSString stringWithFormat:@"%ld", style];
        BOOL flag = [_db executeUpdate:@"insert into t_indexes_cache (code,style,data) values(?,?,?)", code, styleStr, data];
        
        if (flag) {
            LOG(@"catch插入成功  code==%@  style==%ld", code, style);
        } else {
            LOG(@"catch插入失败  code==%@  style==%ld", code, style);
        }
        
    } else {
        LOG(@"删除失败--  code==%@  style==%ld", code, style);
    }
}

+ (id)fetchCacheWithCode:(NSString *)code requestStyle:(SocketRequestStyle)style {
    
    FMResultSet *set = [_db executeQueryWithFormat:
                        @"select * from t_indexes_cache where code = %@ and style = %ld", code, style];
    while (set.next) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[set dataForColumn:@"data"]];
    }
    return nil;
}

+ (void)clearAllCache {
    if ([_db executeUpdate:@"delete from t_indexes_cache"]) {
        LOG(@"删除t_indexes_cache成功");
    } else {
        LOG(@"删除t_indexes_cache失败");
    }
}


+ (void)saveSelectData:(id)obj {
    
    NSArray *array = [IndexModel mj_keyValuesArrayWithObjectArray:obj];
    [CacheTool saveData:array withCode:@"0" requestStyle:0];
}

+ (id)fetchSelectCache {
    NSArray *array = [CacheTool fetchCacheWithCode:@"0" requestStyle:0];
    return [IndexModel mj_objectArrayWithKeyValuesArray:array];
}

@end
