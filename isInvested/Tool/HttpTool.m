//
//  HttpTool.m
//  phone
//
//  Created by 吴忧 on 14/11/16.
//  Copyright © 2014年 吴峰. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
#import "IndexModel.h"
#import "AppDelegate.h"

static NSString *_url;
static NSURLSessionDataTask *_task;

@implementation HttpTool

/** 获取网络状态
 *  0 无网
 *  1 WIFI
 *  2 CELL
 *  其它未知
 */
+ (NetworkStatus)networkStatus {
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
}

+ (void)txtGet:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        unsigned long encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSDictionary *dictionary = [[[NSString alloc] initWithData:responseObject encoding:encoding] mj_JSONObject];
        
        LOG(@"------------------------------txt文档==%@     %@      %@", dictionary[@"codetype"], dictionary[@"open_close_time"], dictionary[@"date"]);
        
        if (success) {
            success(dictionary);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 取消上次无用的请求
    if (_task && [_url isEqualToString:url]) [_task cancel];
    _url = url;
    
    // 获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self getRandomUrl]]];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    mgr.requestSerializer.timeoutInterval = 5;
    
    //请求数据类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:url forHTTPHeaderField:@"Referer"];
    [mgr.requestSerializer setValue:@"CngoldClient/1.0" forHTTPHeaderField:@"User-Agent"];
    [mgr.requestSerializer setValue:@"cngold.com.cn" forHTTPHeaderField:@"Source"];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    _task = [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {        
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
    
    // 取消上次无用的请求
    if (_task && [_url isEqualToString:url]) [_task cancel];
    _url = url;
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    // 获得请求管理者
    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    mgr.requestSerializer.timeoutInterval = 5;
    
    //请求数据类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    // 暂时注释
//    mgr.securityPolicy.allowInvalidCertificates = YES;

    [mgr.requestSerializer setValue:url forHTTPHeaderField:@"Referer"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:@"CngoldClient/1.0" forHTTPHeaderField:@"User-Agent"];
    [mgr.requestSerializer setValue:@"cngold.com.cn" forHTTPHeaderField:@"Source"];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    _task = [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//***********************************************
#pragma mark -- 金融家vip模块的登录注册等
+(NSString*)getRandomUrl{
    NSInteger number = arc4random()%5;
    NSString *url;
    switch (number) {
        case 0:
            url = @"http://api.evmfLd.com";
            break;
        case 1:
            url = @"http://api.ofwnfv.com";
            break;
        case 2:
            url = @"http://api.osjdf.com";
            break;
        case 3:
            url = @"http://api.iojewr.com";
            break;
            
        default:
            url = @"http://api.osdfsdf.com";
            break;
    }
    
    return url;
}

+(NSString*)urlwithMethodGetType:(RequestGetUrlType)type{
    
    NSString *url;
    
    switch (type) {
        case GET_LOGIN:
            url = @"/touguapi/login";
            break;
        case GET_REGISTER:
            url = @"/touguapi/register";
            break;
        case GET_VALIDATECODE:
            url = @"/touguapi/sendvalidatecode";
            break;
        case GET_UPDATEPASSWORD:
            url = @"/touguapi/updateuserpassword";
            break;
        case GET_RESETPASSWORD:
            url = @"/touguapi/resetuserpassword";
            break;
        case GET_UPDATEMOBILE:
            url = @"/touguapi/updateusermobile";
            break;
        case GET_USERINFO:
            url = @"/touguapi/getuserinfo";
            break;
        case GET_UPDATENICKNAME:
            url =@"/touguapi/UpdateNickname";
            break;
        case GET_OPENACCOUNT:
            url =@"/touguapi/OpenAccount";
            break;
        case TouGuRegister:
            url =@"/touguapi/TouGuRegister";
            break;
        case DESDeCodeMobiles:
            url =@"/touguapi/DESDeCodeMobiles";
            break;
        case GetAccountMessage:
            url =@"/touguapi/GetAccountMessage";
            break;
        case UpLoadUserAvatarBase64:
            url =@"/touguapi/UpLoadUserAvatarBase64";
            break;
        case UpdateAccountBank:
            url =@"/touguapi/UpdateAccountBank";
            break;

        default :
            break;
    }
    
    return url;
    
}

+(AFHTTPSessionManager *)XLgetAFHTTPSessionManager{
    
    AFHTTPSessionManager *mgr;
    if ([LOGIN_HOST isEqualToString:@"http://112.84.186.235:8638"]) {
        //新的接口地址
        mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:LOGIN_HOST]];
    }else{
        //外网地址 -- 原来
        mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self getRandomUrl]]];
    }
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 30.0;
    
    //请求数据类型
    NSMutableSet *mutableSet = [NSMutableSet setWithSet:mgr.responseSerializer.acceptableContentTypes];
    [mutableSet addObject:@"application/json"];
    [mutableSet addObject:@"text/html"];
    mgr.responseSerializer.acceptableContentTypes = mutableSet;
    
    
    [mgr.requestSerializer setValue:@"HrAccount_WebApiClient_Global" forHTTPHeaderField:@"User-Agent"];
    [mgr.requestSerializer setValue:@"TouGuApp123" forHTTPHeaderField:@"Source"];
    [mgr.requestSerializer setValue:@"FD7U39KL" forHTTPHeaderField:@"Connstr"];
    
    return mgr;
}

+ (void)XLGet:(RequestGetUrlType)urlType params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    WEAK_SELF
    AFHTTPSessionManager *mgr = [self XLgetAFHTTPSessionManager];
    [weakSelf showHud];
    // 3.发送GET请求
    [mgr GET:[self urlwithMethodGetType:urlType] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf hideHud];
        if (success) {
            dispatch_main_async_safe(^{
                success(responseObject);
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf hideHud];
        if (failure) {
            dispatch_main_async_safe(^{
                failure(error);
            });
        }
    }];
}

+ (void)XLPost:(RequestGetUrlType)urlType params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    WEAK_SELF
    AFHTTPSessionManager *mgr = [self XLgetAFHTTPSessionManager];
    [weakSelf showHud];
    // 3.发送GET请求
    [mgr POST:[self urlwithMethodGetType:urlType] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf hideHud];
        if (success) {
            dispatch_main_async_safe(^{
                success(responseObject);
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf hideHud];
        if (failure) {
            dispatch_main_async_safe(^{
                failure(error);
            });
        }
    }];
}


+ (void)ZJNewsPost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self getRandomUrl]]];
    // 请求超时设定
    mgr.requestSerializer.timeoutInterval = 30.0;
    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:url forHTTPHeaderField:@"Referer"];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    mgr.securityPolicy.allowInvalidCertificates = YES;
    
    
#pragma mark --  以下是设置请求头
    [mgr.requestSerializer setValue:@" CngoldClient/1.0" forHTTPHeaderField:@"User-Agent"];
    [mgr.requestSerializer setValue:@"cngold.com.cn" forHTTPHeaderField:@"Source"];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    dispatch_main_async_safe(^{
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [HUDTool showToView:app.window];
        
    });
    
    // 3.发送GET请求
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_main_async_safe(^{
            
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [HUDTool hideForView:app.window];
            
        });
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_main_async_safe(^{
            
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [HUDTool hideForView:app.window];
            
        });
        
        if (failure) {
            failure(error);
        }
    }];
}


/**
 *  请求SOAP，返回NSData
 *
 *  @param url      请求地址
 *  @param soapBody soap的XML中方法和参数段
 *  @param success  成功block
 *  @param failure  失败block
 */
+(void)showHud{
    dispatch_main_async_safe(^{
        [HUDTool showToView:[UIApplication sharedApplication].delegate.window];
        [self performSelector:@selector(hideHud) withObject:nil afterDelay:15.0];
    });
}
//隐藏风火轮
+(void)hideHud{
    dispatch_main_async_safe(^{
        [HUDTool hideForView:[UIApplication sharedApplication].delegate.window];
    });
}
+ (void)SOAPData:(NSString *)url soapBody:(NSDictionary *)bodyParams success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    WEAK_SELF
    NSString *paramsStr = @"";
    
    for (NSString *key in bodyParams.allKeys) {
        
        if (![key isEqualToString:@"method"] ) {
            paramsStr = [NSString stringWithFormat:@"%@<%@>%@</%@>",paramsStr,key,bodyParams[key],key];
        }
        
    }
    
    //调用的方法 + (命名空间)
    NSString *bodyStr = [NSString stringWithFormat:
                         @"<%@ xmlns = \"http://tempuri.org/\">%@</%@>\n",bodyParams[@"method"],paramsStr,bodyParams[@"method"]];
    
    NSString *soapStr = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                         "<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\">\n"
                         "<SOAP-ENV:Body>%@</SOAP-ENV:Body>\n"
                         "</SOAP-ENV:Envelope>\n",bodyStr];
    
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapStr length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //[request addValue: @"暂不设置,使用默认值" forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody: [soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 超时时间
    config.timeoutIntervalForRequest = 30.0;
    // 是否允许使用蜂窝网络(后台传输不适用)
    config.allowsCellularAccess = YES;
    
    //     NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [weakSelf showHud];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [weakSelf hideHud];
        
        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        
        if (error) {
            LOG(@"Session----失败----%@", error.localizedDescription);
            if (failure) {
                dispatch_main_async_safe(^{
                    failure(error);
                });
            }
        }else{
            
            LOG(@"进入成功回调Session-----结果:%@",result);
            
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data error:&error];
            
            //获取根节点 及中间所有的节点 GDataXMLElement类表示节点
            //获取根节点
            GDataXMLElement *rootElement = [document rootElement];
            
            //追踪到有效父节点 Result
            GDataXMLElement *soapBody=[[rootElement elementsForName : @"soap:Body" ] objectAtIndex : 0 ];
            
            GDataXMLElement *response=[[soapBody elementsForName :[NSString stringWithFormat:@"%@Response",bodyParams[@"method"]]] objectAtIndex : 0 ];
            
            GDataXMLElement *result=[[response elementsForName :[NSString stringWithFormat:@"%@Result",bodyParams[@"method"]]] objectAtIndex : 0 ];
            
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:1];
            
            NSArray *arr = result.children;
            
            if (result.childCount == 1) {
                
                [resultDic setValue:[result stringValue] forKey:@"result"];
                
            }else{
                
                for (GDataXMLElement *element in arr) {
                    
                    NSString *str = [[[result elementsForName:element.name] objectAtIndex : 0 ] stringValue ];
                    if (str != nil) {
                        [resultDic setValue:str forKey:element.name];
                    }
                    
                }
                
            }
            
            if (success) {
                dispatch_main_async_safe(^{
                    success(resultDic);
                });
            }
        }
    }];
    
    [task resume];
    
}
@end
