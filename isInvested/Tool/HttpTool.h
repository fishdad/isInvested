//
//  HttpTool.h
//  phone
//
//  Created by 吴忧 on 14/11/16.
//  Copyright © 2014年 吴峰. All rights reserved.
//  网络请求工具类

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"


@interface HttpTool : NSObject

/** 获取网络状态
 *  0 无网
 *  1 WIFI
 *  2 CELL
 *  其它未知
 */
+ (NetworkStatus)networkStatus;

/** txtGet请求 */
+ (void)txtGet:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** get请求 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** pos请求 */
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

// ----------------------------------

#pragma mark -- 金融家VIP的用户中心,中金网的快讯,要闻,日历 请求头分别封装
//用户注册登录模块的get请求(请求URL和请求头比较特殊单独封装方法)
+ (void)XLGet:(RequestGetUrlType)urlType params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)XLPost:(RequestGetUrlType)urlType params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)SOAPData:(NSString *)url soapBody:(NSDictionary *)bodyParams success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure ;

@end
