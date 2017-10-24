//
//  NSArray+Extension.m
//  isInvested
//
//  Created by Blue on 16/12/5.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NSArray+Extension.h"
#import "IndexModel.h"

@implementation NSArray (Extension)

/** 比较两数组是否改变过 */
- (BOOL)compareIndexes:(NSArray<IndexModel *> *)data {
    
    NSInteger count = data.count;
    
    if (self.count != count) return YES;
    
    for (NSInteger i = 0; i < count; i++) {
        if ([self[i] number] != data[i].number) return YES;
    }
    return NO;
}

@end
