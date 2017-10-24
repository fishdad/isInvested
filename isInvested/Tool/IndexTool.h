//
//  IndexTool.h
//  isInvested
//
//  Created by Blue on 16/11/11.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexTool : NSObject

/** 取选中的的指数 */
+ (NSMutableArray *)selectedIndexes;

/** 存储修改后的数组 */
+ (void)saveWithHomeModels:(NSArray<IndexModel *> *)models;
+ (void)saveWithSelectModels:(NSArray<IndexModel *> *)models;

+ (void)saveWithHomeModel:(IndexModel *)model;
+ (void)saveWithSelectModel:(IndexModel *)model;

/** 传入关键字搜索 */
+ (NSMutableArray<IndexModel *> *)searchModelByText:(NSString *)text;

/** 取相同current_section数组 */
+ (NSMutableArray<IndexModel *> *)indexesWithSection:(NSInteger)section;

/** 取搜索页展示的全部品种, 返回二维数组 */
+ (NSMutableArray *)searchPageAllIndexes;

@end
