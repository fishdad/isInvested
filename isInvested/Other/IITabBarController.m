//
//  IITabBarController.m
//  isInvested
//
//  Created by Blue on 16/8/8.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "IITabBarController.h"
#import "IINavigationController.h"
#import "HomeViewController.h"
#import "ChooseViewController.h"
#import "DealViewController.h"
#import "DiscoverViewController.h"
#import "MyViewController.h"
#import "SocketTool.h"

#import "LockController.h"
#import "SignerViewController.h"
#import "LoginViewController.h"
#import "OpenAccountImageView.h"
#import "OpeningAccountViewController.h"
#import "NormalInfoViewController.h"
#import "ChooseBankViewController.h"
#import "GoOpenAccountView.h"

@interface IITabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) LockController *lockVC;//手势锁
@property (nonatomic, strong) SignerViewController *singerVC;//验证密码
@property (nonatomic, strong) OpenAccountImageView *khImgView ;//开户的界面
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) HomeViewController *homeVc;
@end

@implementation IITabBarController

- (void)login {
    
    NSDictionary *params = @{ @"clientId" : @"OCZN5IX099OS",
                              @"clientPasswd" : @"IM3I1C4SYBS8" };
    
    [GGHttpTool get:@"https://183.62.250.17:28443/user/login" params:params success:^(id responseObj) {
        
        if ([responseObj[@"State"] isEqualToNumber:@0]) {
            [HUDTool showText:@"token请求失败!"];
            return;
        }
        // token解密后存入本地
        [NSUserDefaults setObject:[responseObj[@"token"] decryptUseDES] forKey:gg_token];
        
    } failure:^(NSError *error) { LOG_ERROR
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self login];
    
    self.titles = @[@"首页", @"自选", @"交易" ,@"发现", @"我的"];
    
    HomeViewController *home         = [[HomeViewController alloc] init];
    ChooseViewController *choose     = [[ChooseViewController alloc] init];
    DealViewController *deal         = [[DealViewController alloc] init];
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    MyViewController *my             = [[MyViewController alloc] init];
    self.homeVc = home;

    [self addChildVc:home title:self.titles[0] image:@"tabbar_home" selectedImage:@"tabbar_home_sel"];
    [self addChildVc:choose title:self.titles[1] image:@"tabbar_choose" selectedImage:@"tabbar_choose_sel"];
    [self addChildVc:deal title:self.titles[2] image:@"tabbar_deal" selectedImage:@"tabbar_deal_sel"];
    [self addChildVc:discover title:self.titles[3] image:@"tabbar_find" selectedImage:@"tabbar_find_sel"];
    [self addChildVc:my title:self.titles[4] image:@"tabbar_my" selectedImage:@"tabbar_my_sel"];
    
    [self requestVersionNumber];
    
    [self requestTxt];
    
    //当前登录账号已经开户的情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(complantOpenAccount) name:@"LoginWithOpenAccount" object:nil];
}

- (void)addChildVc:(UIViewController *)childVc
             title:(NSString *)title
             image:(NSString *)image
     selectedImage:(NSString *)selectedImage {
    
    // 设置导航栏和dock栏文字
    childVc.title = title;
    
    // 设置子控制器的图片
    childVc.tabBarItem.image         = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //文字选中颜色
    NSDictionary *selectTextAttrs = @{ NSForegroundColorAttributeName : kNavigationBarColor };
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    IINavigationController *nav = [[IINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

- (void)requestVersionNumber {
    WEAK_SELF
    [HttpTool post:URL_VERSION params:@{ @"typeName" : @"投了么" } success:^(id responseObj) {
        [weakSelf compareVersionWithNumber:responseObj[@"version_name"]];
        
    } failure:^(NSError *error) { LOG_ERROR
    }];
}

- (void)compareVersionWithNumber:(NSString *)str2 {
    
    NSString *str1 = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    LOG(@"本地版本==%@\n服务器版本==%@", str1, str2);
    if ([str1 isEqualToString:str2]) return;
    
    NSArray<NSString *> *arr1 = [str1 componentsSeparatedByString:@"."];
    NSArray<NSString *> *arr2 = [str2 componentsSeparatedByString:@"."];
    
    for (NSInteger i = 0; i < arr1.count && i < arr2.count; i++) {
        
        if (arr1[i].integerValue < arr2[i].integerValue) {
            [self remindUpdate];
            return;
        } else if (arr1[i].integerValue > arr2[i].integerValue) {
            return;
        }
    }
    if (arr2.count > arr1.count) [self remindUpdate];
}

/** 弹出更新提醒框 */
- (void)remindUpdate {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"有新版本, 是否更新?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_APPSTORE]];
    }]];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)requestTxt {
    
    NSArray *nameArray = @[@"5a01", @"5b00", @"8100", @"5400"];
    for (NSString *fileName in nameArray) {
        
        if (![TxtTool isNeedRequestByCodeType:fileName]) {
            LOG(@"------------------------------------------------------不要再请求了txt__%@", fileName);
            continue;
        }
        LOG(@"-------------------------------------------------------要请求txt__%@", fileName);
        
        [HttpTool txtGet:[URL_TXT stringByAppendingFormat:@"%@.txt", fileName] params:nil success:^(id responseObj) {
            [TxtTool saveWithTxtData:responseObj];
            
        } failure:^(NSError *error) { LOG(@"txt错误==%@", error);
        }];
    }
}

//****************************************************

#pragma mark tabbar的点击处理 -- 交易界面的处理
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if ([item.title isEqualToString:@"首页"]) {
        [self.homeVc requestNewData];
    }
    
    if ([item.title isEqualToString:@"交易"] ||
        [item.title isEqualToString:@"发现"] ||
        [item.title isEqualToString:@"我的"]) {
        [[SocketTool sharedSocketTool] disconnect];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoOpenAccount" object:item.title];
    
    if (![item.title isEqualToString:@"交易"]) {
        NSInteger index = [_titles indexOfObject:item.title];
        [NSUserDefaults setObject:[NSString stringWithFormat:@"%li",index] forKey:@"tabBarSelectIndex"];
    }
    
    if ([item.title isEqualToString:@"交易"]) {
        
        if ([[DealSocketTool shareInstance] connectToRemote] && ![Util isDealSocketLoginOutOfTime]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DealSignSuccess" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectCutOff" object:nil];
        }
        
        IINavigationController *nav = self.childViewControllers[2];
        DealViewController *vc;
        for (id childVC in nav.childViewControllers) {
            if ([childVC isKindOfClass:[DealViewController class]]) {
                vc = childVC;
                break;
            }
        }
        if (vc.isNotFirstIn == NO) {//第一次进入,默认持仓
            vc.fromType = DealFromTypeTabbar;
        }
        //1.判断是否登录
        WEAK_SELF
        BOOL login = [NSUserDefaults boolForKey:isLogin];
        if (login != YES) {
            //未登录
            LoginViewController *loginVC =[[LoginViewController alloc] init];
            loginVC.isGoToDeal = YES;
            //点击取消按钮
            loginVC.cancelBlock = ^(){
                NSString*selectIndex = [NSUserDefaults objectForKey:@"tabBarSelectIndex"];
                if (selectIndex == nil) {
                    selectIndex = @"0";
                }
                weakSelf.selectedIndex = [selectIndex integerValue];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GoOpenAccount" object:nil];
                return ;
            };
            IINavigationController*loginNav = [[IINavigationController alloc] initWithRootViewController:loginVC];
            [vc presentViewController:loginNav animated:YES completion:nil];
        }
        
        //2.判断是否开户
        BOOL openAccount = [NSUserDefaults boolForKey:isOpenAccount];
        if (_khImgView == nil){
            _khImgView = [[OpenAccountImageView alloc] initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT - 49)];
            _khImgView.tag = 100;
        }
        if (openAccount != YES) {//未开户
            _khImgView.openAccountBlock = ^(){
                
                NormalInfoViewController *normalVC = [[NormalInfoViewController alloc] init];
                IINavigationController*normalNVC = [[IINavigationController alloc] initWithRootViewController:normalVC];
                vc.navigationController.navigationBar.hidden = NO;
                [vc presentViewController:normalNVC animated:YES completion:nil];
            };
            [_khImgView removeFromSuperview];
            [vc.view addSubview:_khImgView];
        }else{
            //新浪支付未绑卡时
            BOOL sign = [NSUserDefaults boolForKey:isSinaAccountBangding];
            if (sign != YES) {
                _khImgView.openAccountBlock = ^(){
                    ChooseBankViewController *bankVC = [[ChooseBankViewController alloc] init];
                    IINavigationController*bankNVC = [[IINavigationController alloc] initWithRootViewController:bankVC];
                    vc.navigationController.navigationBar.hidden = NO;
                    [vc presentViewController:bankNVC animated:YES completion:nil];
                };
                [_khImgView removeFromSuperview];
                [vc.view addSubview:_khImgView];
            }else{
                [_khImgView removeFromSuperview];
            }
        }
        //3.手势是否开启
        BOOL isSH = [NSUserDefaults boolForKey:[Util isSHPassWord]];
        if (isSH == YES) {
            //手势解锁的界面
            [_singerVC.view removeFromSuperview];
            //验证一次还是每次都验证
            if (_lockVC == nil) {
                _lockVC = [[LockController alloc] initWithLockType:LockTypeOpen];
                _lockVC.appearType = LockAppearTypeAddView;
                _lockVC.view.frame = CGRectMake(0, -64, WIDTH, HEIGHT + 64);
                [_lockVC viewWillAppear:YES];
                [vc.view addSubview:_lockVC.view];
            }
            //判断是否超时
            NSDate *date = [NSUserDefaults objectForKey:LastOpenTime];
            
            if ([Util compareWithCurrentTimeByCompareDate:date WithMin:10]) {
                [[DealSocketTool shareInstance] cutOffSocket];//超时断开连接
                [_lockVC viewWillAppear:YES];
                [vc.view addSubview:_lockVC.view];
            }
        }else{
            [_lockVC.view removeFromSuperview];
            //身份验证的界面
            if (_singerVC == nil) {
                _singerVC = [[SignerViewController alloc] init];
                _singerVC.appearType = AppearTypeAddView;
                _singerVC.signerType = SignerTypeTouchID;
                _singerVC.useForType = UseForTypeDeal;
            }
            _singerVC.accountNum.textF.text = [NSUserDefaults objectForKey:KHAccount];
            //判断是否超时
            NSDate *date = [NSUserDefaults objectForKey:LastOpenTime];
            
            if ([Util compareWithCurrentTimeByCompareDate:date WithMin:10]) {
                [[DealSocketTool shareInstance] cutOffSocket];//超时断开连接
                [_singerVC viewWillAppear:YES];
                [vc.view addSubview:_singerVC.view];
            }
        }
        
        //4.最终处理
        NSDate *date = [NSUserDefaults objectForKey:LastOpenTime];
        BOOL sign = [NSUserDefaults boolForKey:isSinaAccountBangding];// 是否新浪支付签约
        if (openAccount != YES || sign != YES || ![Util compareWithCurrentTimeByCompareDate:date WithMin:10]) {
            [_lockVC.view removeFromSuperview];
            [_singerVC.view removeFromSuperview];
        }
    }
}

//完成开户
-(void)complantOpenAccount{
    
    //开启密码阻断
    BOOL isSH = [NSUserDefaults boolForKey:[Util isSHPassWord]];
    IINavigationController *nav = self.childViewControllers[2];
    UIViewController *vc = nav.topViewController;
    if (isSH == YES) {
        [_singerVC.view removeFromSuperview];
        [_lockVC viewWillAppear:YES];
        [vc.view addSubview:_lockVC.view];
    }else{
        [_lockVC.view removeFromSuperview];
        [_singerVC viewWillAppear:YES];
        [vc.view addSubview:_singerVC.view];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
