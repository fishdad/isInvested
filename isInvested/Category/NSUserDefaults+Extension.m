//
//  NSUserDefaults+Extension.m
//  isInvested
//
//  Created by Wu on 16/8/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NSUserDefaults+Extension.h"

@implementation NSUserDefaults (Extension)

+ (void)setObject:(id)obj forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setBool:(BOOL)b forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:b forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)boolForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

@end
