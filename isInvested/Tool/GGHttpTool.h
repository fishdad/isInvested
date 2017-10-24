//
//  GGHttpTool.h
//  isInvested
//
//  Created by Blue on 16/9/9.
//  Copyright © 2016年 Blue. All rights reserved.
//  广贵网络请求工具类

#import <Foundation/Foundation.h>

// 查询接口
#define GGQueryHost(s) [@"https://183.62.250.17:28443/" stringByAppendingString:s]
// 推送接口
#define GGPushHost(s)  [@"https://183.62.250.17:28080/" stringByAppendingString:s]
// 批量接口
#define GGBatchHost(s) [@"https://183.62.250.21:21/" stringByAppendingString:s]

#define GGToken [NSUserDefaults objectForKey:gg_token]

#define GGCustomerAccountId @"167000000000349"
//#define GGCustomerAccountId @"167000000000292"

#define GGIfStatusEqual0 if (![responseObj[@"status"] isEqualToNumber:@1]) {\
                            [HUDTool showText:responseObj[@"msg"]];\
                            return;\
                         }

@interface GGHttpTool : NSObject

/** 广贵get */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** 广贵pos */
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

@end
