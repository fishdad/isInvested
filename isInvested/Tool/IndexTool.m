//
//  IndexTool.m
//  isInvested
//
//  Created by Blue on 16/11/11.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "IndexTool.h"
#import "IndexModel.h"
#import "FMDB.h"

@implementation IndexTool

static FMDatabase *_db;

+ (void)initialize {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"indexes.sqlite"];
    _db = [FMDatabase databaseWithPath:filePath];
    
    // 打开数据库
    if ([_db open]) {
        
        // 创建表格
        if ([_db executeUpdate:@"create table if not exists t_indexes (name text,code text,code_type text,firstno text,no text,section,current_section,primary key(code,code_type));"]) {
            LOG(@"t_indexes表创建成功");
        } else {
            LOG(@"t_indexes表创建失败");
        }
        
        NSArray *array =
        @[ @{ @"name":@"粤贵银", @"code":@"GDAG", @"code_type":@"0x5a01", @"firstno":@"0", @"no":@"0", @"section":@"1", @"current_section":@"0" },
           @{ @"name":@"粤贵钯", @"code":@"GDPD", @"code_type":@"0x5a01", @"firstno":@"1", @"no":@"1", @"section":@"1", @"current_section":@"0" },
           @{ @"name":@"粤贵铂", @"code":@"GDPT", @"code_type":@"0x5a01", @"firstno":@"2", @"no":@"2", @"section":@"1", @"current_section":@"0" },
           
           @{ @"name":@"现货黄金", @"code":@"XAU", @"code_type":@"0x5b00", @"firstno":@"4", @"no":@"3", @"section":@"2", @"current_section":@"0" },
           @{ @"name":@"现货白银", @"code":@"XAG", @"code_type":@"0x5b00", @"firstno":@"5", @"no":@"4", @"section":@"2", @"current_section":@"0" },
           @{ @"name":@"现货铂金", @"code":@"XAP", @"code_type":@"0x5b00", @"firstno":@"99", @"no":@"5", @"section":@"2", @"current_section":@"2" },
           @{ @"name":@"现货钯金", @"code":@"XPD", @"code_type":@"0x5b00", @"firstno":@"99", @"no":@"6", @"section":@"2", @"current_section":@"2" },
           @{ @"name":@"台两黄金", @"code":@"TWGD", @"code_type":@"0x5b00", @"firstno":@"99", @"no":@"99", @"section":@"2", @"current_section":@"2" },
           @{ @"name":@"香港黄金", @"code":@"HKGT", @"code_type":@"0x5b00", @"firstno":@"99", @"no":@"99", @"section":@"2", @"current_section":@"2" },
           
           @{ @"name":@"美元指数", @"code":@"UDI", @"code_type":@"0x8100", @"firstno":@"3", @"no":@"7", @"section":@"3", @"current_section":@"0" },
           @{ @"name":@"美元人民币", @"code":@"USDCNY", @"code_type":@"0x8100", @"firstno":@"99", @"no":@"99", @"section":@"3", @"current_section":@"3" },
           @{ @"name":@"美原油指数", @"code":@"NECLI", @"code_type":@"0x5400", @"firstno":@"99", @"no":@"99", @"section":@"3", @"current_section":@"3" },
           @{ @"name":@"美原油连续", @"code":@"NECLA", @"code_type":@"0x5400", @"firstno":@"99", @"no":@"99", @"section":@"3", @"current_section":@"3" } ];
        
        FMResultSet *set = [_db executeQuery:@"select * from t_indexes"];
        if (set.next) return;
        
        for (NSDictionary *indexDic in array) {
            
            NSString *name = indexDic[@"name"];
            NSString *code = indexDic[@"code"];
            NSString *code_type = indexDic[@"code_type"];
            NSString *firstno = indexDic[@"firstno"];
            NSString *no = indexDic[@"no"];
            NSString *section   = indexDic[@"section"];
            NSString *current_section = indexDic[@"current_section"];
            
            BOOL flag = [_db executeUpdate:@"insert into t_indexes (name,code,code_type,firstno,no,section,current_section) values(?,?,?,?,?,?,?)",name,code,code_type,firstno,no,section,current_section];
            if (flag) {
                NSLog(@"插入成功");
            } else {
                NSLog(@"插入失败");
            }
        }
        
    } else {
        LOG(@"t_indexes DB打开失败");
    }
}

/** 取选中的的指数 */
+ (NSMutableArray *)selectedIndexes {
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_indexes where no <> '99' order by no"];
    
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *name = [set stringForColumn:@"name"];
        NSString *code = [set stringForColumn:@"code"];
        NSString *code_type = [set stringForColumn:@"code_type"];
        
        NSDictionary *dic = @{@"name":name,@"code":code,@"code_type":code_type};
        [arrM addObject:[IndexModel mj_objectWithKeyValues:dic]];
    }
    return arrM;
}

/** 存储修改后的数组 */
+ (void)saveWithHomeModels:(NSArray<IndexModel *> *)models {
    NSString *sql = [NSString stringWithFormat:@"update t_indexes set firstno = '99'"];
    [_db executeUpdate:sql];
    
    for (IndexModel *model in models) {
        NSString *sql = [NSString stringWithFormat:@"update t_indexes set firstno = '%li' where code = '%@' and code_type = '%@'",
                         model.number,model.code,model.code_type];
        [_db executeUpdate:sql];
    }
}

+ (void)saveWithSelectModels:(NSArray<IndexModel *> *)models {
    NSString *sql = [NSString stringWithFormat:@"update t_indexes set no = '99'"];
    [_db executeUpdate:sql];
    
    for (IndexModel *model in models) {
        NSString *sql = [NSString stringWithFormat:@"update t_indexes set no = '%li' where code = '%@' and code_type = '%@'",
                         model.number,model.code,model.code_type];
        [_db executeUpdate:sql];
    }
}

/** 存储修改后的Model */
+ (void)saveWithHomeModel:(IndexModel *)model {
    
    NSString *sql = [NSString stringWithFormat:@"update t_indexes set current_section = '%li' where code = '%@' and code_type = '%@'", model.current_section, model.code, model.code_type];
    
    BOOL b = [_db executeUpdate:sql];
    if (!b) {
        LOG(@"更新首页model失败");
    }
}
+ (void)saveWithSelectModel:(IndexModel *)model {
    
    NSString *sql = [NSString stringWithFormat:@"update t_indexes set no = '%li' where code = '%@' and code_type = '%@'",
                     model.number, model.code, model.code_type];
    
    BOOL b = [_db executeUpdate:sql];
    if (!b) {
        LOG(@"更新自选model失败");
    }
}

/** 传入关键字搜索 */
+ (NSMutableArray<IndexModel *> *)searchModelByText:(NSString *)text {
    
    NSString *key = text.uppercaseString;
    FMResultSet *set = [_db executeQuery:@"select * from t_indexes"];
    NSMutableArray *arrM = [NSMutableArray array];
    
    while ([set next]) {
        NSString *name = [set stringForColumn:@"name"];
        NSString *code = [set stringForColumn:@"code"];
        NSString *code_type = [set stringForColumn:@"code_type"];
        NSString *no = [set stringForColumn:@"no"];
        
        if ([code containsString:key] || [name containsString:key]) {
            NSDictionary *dic = @{@"name":name,@"code":code,@"code_type":code_type,@"number":no};
            [arrM addObject:[IndexModel mj_objectWithKeyValues:dic]];
        }
    }
    return arrM;
}

/** 取相同current_section数组 */
+ (NSMutableArray<IndexModel *> *)indexesWithSection:(NSInteger)section {
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_indexes where current_section = '%ld' order by firstno", section];
    
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *name = [set stringForColumn:@"name"];
        NSString *code = [set stringForColumn:@"code"];
        NSString *code_type = [set stringForColumn:@"code_type"];
        NSString *section = [set stringForColumn:@"section"];
        NSString *current_section = [set stringForColumn:@"current_section"];
        
        NSDictionary *dic = @{@"name":name,@"code":code,@"code_type":code_type,@"section":section,@"current_section":current_section};
        IndexModel *model = [IndexModel mj_objectWithKeyValues:dic];
        [arrM addObject:model];
    }
    return arrM;
}

/** 取搜索页展示的全部品种, 返回二维数组 */
+ (NSMutableArray *)searchPageAllIndexes {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 1; i <= 3; i++) {
        
        NSString *sql = [NSString stringWithFormat:@"select * from t_indexes where section = '%ld' order by no", i];
        FMResultSet *set = [_db executeQuery:sql];
        
        NSMutableArray *arrM = [NSMutableArray array];
        while ([set next]) {
            NSString *name = [set stringForColumn:@"name"];
            NSString *code = [set stringForColumn:@"code"];
            NSString *code_type = [set stringForColumn:@"code_type"];
            NSString *no = [set stringForColumn:@"no"];
            
            NSDictionary *dict = @{@"name":name, @"code":code, @"code_type":code_type,@"number":no};
            [arrM addObject:[IndexModel mj_objectWithKeyValues:dict]];
        }
        [array addObject:arrM];
    }
    return array;
}

@end
