//
//  NSDictionary+NullKeys.m
//  isInvested
//
//  Created by Ben on 16/9/5.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NSDictionary+NullKeys.h"

@implementation NSDictionary (NullKeys)

//判断无效的key值
-(id)handleNullObjectForKey:(NSString *)key {
    
    if ([[self allKeys] containsObject:key]){
    
        return [self objectForKey:key];
    }else{
    
        return @"NullKey";
    }
}

@end
