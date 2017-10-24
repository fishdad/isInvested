//
//  AppDelegate.m
//  isInvested
//
//  Created by Wu on 16/8/4.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "AppDelegate.h"
#import "NewFeatureViewController.h"
#import "AdvertisingViewController.h"
#import "IITabBarController.h"

#import "SocketTool.h"
#import "IQKeyboardManager.h"
#import "TopWindow.h"
#import "RealReachability.h"
#import <Bugly/Bugly.h>

#define BUGLY_APP_ID @"14cccc0175"

#import <UMSocialCore/UMSocialCore.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "MyTransferResultViewController.h"


@interface AppDelegate ()<BuglyDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    WEAK_SELF
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if ([NewFeatureViewController isNewFeature]) { // 新版, 不加载广告
        self.window.rootViewController = [[NewFeatureViewController alloc] init];
        
    } else { // 旧版, 加载广告
        AdvertisingViewController *adController = [[AdvertisingViewController alloc] init];
        self.window.rootViewController = adController;
        adController.skipAdvertisingBlock = ^(){
            weakSelf.window.rootViewController = [[IITabBarController alloc] init];
        };
    }
    
    [self.window makeKeyAndVisible];
    
    // 统一管理键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = YES;
    
    //    [TopWindow show];
    
    //腾讯bug管理追踪崩溃日志
    [self setupBugly];
    //开启网络监测
    [GLobalRealReachability startNotifier];
    GLobalRealReachability.hostForPing = @"www.baidu.com";
    
    [self setupUMShare];
    
    [self setUpJPush];
#warning //@param isProduction 是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"83a7e02e1d51857566facbf8"
                          channel:nil
                 apsForProduction:NO
            advertisingIdentifier:nil];
    
    
    return YES;
}

//极光推送
-(void)setUpJPush{
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}

- (void)setupUMShare {
    
    //打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"582a822de88bad6644000039"];
    
    // 获取友盟social版本号
    //    LOG(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置新浪的appId和appKey
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2397493220"  appSecret:@"29bc5179bab3ddec2388cc764800508f" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    //设置微信的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx816b86089b74b44d" appSecret:@"937ff2c909061715d319193e28b47a4d" redirectURL:@"http://mobile.umeng.com/social"];
    
    //    设置分享到QQ互联的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105750885"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}

//腾讯bug管理
- (void)setupBugly {
    
    BuglyConfig * config = [[BuglyConfig alloc] init];
#if DEBUG
    config.debugMode = YES;
#endif
    config.reportLogLevel = BuglyLogLevelWarn;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 1.5;
    config.channel = @"Bugly";
    config.delegate = self;
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    LOG(@"将要放弃活动");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    LOG(@"已经进入后台, 在这断开tcp");
    
    //断开服务器链接
    LOG(@"服务器断开连接~~~~");
    [[DealSocketTool shareInstance] cutOffSocket];
    
    [TxtTool clearOutDateData];
    [CacheTool clearAllCache];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    LOG(@"将要进入前台");
    //************进入前台重新连接,仅限于交易界面 mod by xinle 2016.12.05
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([DealSocketTool shareInstance].isTouchIDLoginIn) {
        return;//指纹解锁之后回调此方法
    }
    UIViewController *tab = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([tab isKindOfClass:[NSClassFromString(@"IITabBarController") class]]) {
        IITabBarController *iiTab = (IITabBarController *)tab;
        [DealSocketTool shareInstance].SocketActiveTag = SocketActiveTypeFromBackground;
        if (iiTab.selectedIndex == 2) {
            if ([[DealSocketTool shareInstance] isKHAccountCanLogin]) {
                [[DealSocketTool shareInstance] loginToServer];
            }
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    LOG(@"已经变成活动");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    LOG(@"将要终止");
    [NSUserDefaults setObject:[NSDate dateWithTimeIntervalSinceNow:(- 60 * 11)] forKey:LastOpenTime];//双击退出清理最后一次打开时间
}

#pragma mark -- 1.0 极光推送
/// Required - 注册 DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    LOG(@"~~~~~~~~极光的token:%@",deviceToken);
}

//实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    LOG(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark -- 2.0 JPUSHRegisterDelegate

//前台alertView弹窗
-(void)showAlertViewWithUserInfo:(NSDictionary *) userInfo{
    
    
    UITabBarController *tabBarC = (UITabBarController *)[Util appWindow].rootViewController;
    
    if ([tabBarC isKindOfClass:[NSClassFromString(@"IITabBarController") class]]) {
        
        UINavigationController *nav = tabBarC.childViewControllers[tabBarC.selectedIndex];
        NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        [Util alertViewWithCancelBtnAndMessage:message Target:nav doActionBtn:@"立即查看" handler:^(UIAlertAction *action) {
            
            MyTransferResultViewController *vc = [[MyTransferResultViewController alloc] init];
            vc.price = [userInfo valueForKey:@"amount"];;
            vc.isSuccessAmount = YES;
            [nav pushViewController:vc animated:YES];
        }];
    }
}

//后台直接跳转
-(void)showTransferResultWithUserInfo:(NSDictionary *) userInfo{
    
    [Util goToDeal];
    [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
        MyTransferResultViewController *vc = [[MyTransferResultViewController alloc] init];
        vc.price = [userInfo valueForKey:@"amount"];
        vc.isSuccessAmount = YES;
        [dealVC.navigationController pushViewController:vc animated:YES];
    }];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    //    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置//屏蔽不需要在前台弹出横幅 mod by xinle2016.12.21
    //*********************用户前台接收到推送**********
    [self showAlertViewWithUserInfo:userInfo];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    //*********************用户后台接收到推送*********
    [self showTransferResultWithUserInfo:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self showTransferResultWithUserInfo:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    [self showTransferResultWithUserInfo:userInfo];
}

@end
