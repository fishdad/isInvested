//
//  NSUserDefaults+Extension.h
//  isInvested
//
//  Created by Wu on 16/8/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extension)

+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

+ (void)setBool:(BOOL)b forKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

@end
