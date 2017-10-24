//
//  NSDictionary+NullKeys.h
//  isInvested
//
//  Created by Ben on 16/9/5.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullKeys)

//判断无效的key值
-(id)handleNullObjectForKey:(NSString *)key;

@end
