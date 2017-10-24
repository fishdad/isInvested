//
//  NSArray+Extension.h
//  isInvested
//
//  Created by Blue on 16/12/5.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IndexModel;

@interface NSArray (Extension)

/** 比较两数组是否改变过 */
- (BOOL)compareIndexes:(NSArray<IndexModel *> *)data;

@end
