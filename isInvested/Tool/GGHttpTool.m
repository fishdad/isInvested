//
//  GGHttpTool.m
//  isInvested
//
//  Created by Blue on 16/9/9.
//  Copyright © 2016年 Blue. All rights reserved.
//  广贵网络请求工具类

#import "GGHttpTool.h"

@implementation GGHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    //允许非权威机构颁发的证书
    mgr.securityPolicy.allowInvalidCertificates = YES;
    //不验证域名一致性
    mgr.securityPolicy.validatesDomainName = NO;
    
    mgr.requestSerializer.timeoutInterval = 10.0;
    
    //请求数据类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure {
    
    // 获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    mgr.requestSerializer.timeoutInterval = 10.0;
    
    //请求数据类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:url forHTTPHeaderField:@"Referer"];
    [mgr.requestSerializer setValue:@"CngoldClient/1.0" forHTTPHeaderField:@"User-Agent"];
    [mgr.requestSerializer setValue:@"cngold.com.cn" forHTTPHeaderField:@"Source"];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // 发送POST请
    [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
