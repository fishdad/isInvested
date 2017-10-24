//
//  SignerViewController.m
//  isInvested
//
//  Created by Ben on 16/8/17.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "SignerViewController.h"
#import "LockController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "NSDictionary+NullKeys.h"
#import "IsOpeningAccountStatusView.h"
#import "HasOpenedAccountView.h"
#import "GetCodeViewController.h"
#import "IINavigationController.h"
#import "NoDataView.h"
#import "DealSocketTool.h"
#import "UIImage+GIF.h"

@interface SignerViewController ()
{

    UIImageView *_loadingGif;
}

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) IsOpeningAccountStatusView *isOpeningView;
@property (nonatomic, strong) HasOpenedAccountView *hasOpenedView;
@property (nonatomic, strong) NoDataView *noDataView;
@property (nonatomic, strong)  UIButton *findBtn;

@end

@implementation SignerViewController

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    _passWord2.textF.text = @"";
    [self hideHud];
}

-(void)viewWillAppear:(BOOL)animated{
    
    LOG(@"viewWillAppear~~~~~执行!");

    [super viewWillAppear:animated];
    _noDataView.hidden = YES;
    _passWord2.textF.text = @"";
    NSString *KHAccountStr = [NSUserDefaults objectForKey:KHAccount];
    _accountNum.textF.text = KHAccountStr;
    _hasOpenedView.accountStr = KHAccountStr;
     [self selfHidden:YES];
    
    //当前开户的状态
    NSString *OpenAccountStatusNow = [NSUserDefaults objectForKey:OpenAccountStatus];
    if ([OpenAccountStatusNow isEqualToString:@"2"]) {//2代表开户成功
        [self selfHidden:NO];
        [self showTouchID];//显示指纹
    }else{
        //获取当前的开户状态
        [self getOpenStatus];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tag = VCViewTagSignVC;
    //当前登录账号未开户的情况
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(complantOpenAccount) name:@"LoginWithNoAccount" object:nil];
    self.title=@"验证身份";
    _isAfter = NO;
    [self initMyView];
    
    //正在开户状态页面
    _isOpeningView = [[IsOpeningAccountStatusView alloc] initWithFrame:self.view.bounds];
    _isOpeningView.hidden = YES;
    WEAK_SELF
    __weak typeof(_isOpeningView) weakIsOpeningView = _isOpeningView;
    _isOpeningView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        LOG(@"当前页面的下拉刷新方法~~~~");
        [weakSelf getOpenStatus];
        [weakIsOpeningView.scrollView.mj_header endRefreshing];
    }];
    
    [self.view addSubview:_isOpeningView];
    
    //开户成功界面
    _hasOpenedView = [[HasOpenedAccountView alloc] initWithFrame:self.view.bounds];
    _hasOpenedView.hidden = YES;
    _hasOpenedView.openAccountBlock = ^(){
    
        [weakSelf toulemeOpenAccount];
    };
    [self.view addSubview:_hasOpenedView];
    
    
    _accountNum.textF.text = [NSUserDefaults objectForKey:KHAccount];
    _accountNum.textF.userInteractionEnabled = NO;
    
    //自己返回事件处理
    UIBarButtonItem *left = [UIBarButtonItem itemWithTarget:self action:@selector(cancelButtonClick) image:@"back"];
    self.navigationItem.leftBarButtonItem = left;
    
    //没有数据
    _noDataView = [NoDataView defaultNoDataView];
    _noDataView.hidden = YES;
    [self.view addSubview:_noDataView];
}

-(void)initMyView{
    //账户
    CGFloat x = 25;
    _accountNum = [[MyTextView alloc] initWithFrame:CGRectMake(x, 20 + 64, (WIDTH - 2 * x), 44)];
    [self.view addSubview:_accountNum];
//    _accountNum.img.image = [UIImage imageNamed:@"edit_trade_login_icon_name"];
    _accountNum.lbl.text = @"交易账号";
    _accountNum.placeholder = @"请输入账户名称";
    _accountNum.textF.textColor = [UIColor blackColor];
    _accountNum.backColor = [UIColor whiteColor];
    
    //密码
    _passWord2 = [[MyTextView alloc] initWithFrame:CGRectMake(x, _accountNum.bottom + 10, (WIDTH - 2 * x), 44)];
    [self.view addSubview:_passWord2];
    _passWord2.backColor = [UIColor whiteColor];
    _passWord2.textF.textColor = [UIColor blackColor];
    _passWord2.textF.secureTextEntry = YES;
//    _passWord2.img.image = [UIImage imageNamed:@"lock_normal"];
    _passWord2.lbl.text = @"密码";
    _passWord2.placeholder = @"请输入登录密码";
    
    //确定
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, _passWord2.bottom + 40, (WIDTH - 2 * x), 44)];
    _loginBtn.tag = 101;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.backgroundColor = kNavigationBarColor;
    _loginBtn.showsTouchWhenHighlighted = YES;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    //忘记密码
    _findBtn= [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2.0, _loginBtn.bottom , WIDTH / 2.0 , 44)];
    _findBtn.tag = 102;
    [_findBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [_findBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
//    findBtn.backgroundColor = [UIColor redColor];
    _findBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_findBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_findBtn];

//    //测试按钮
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(300, 300, 100, 100);
//    btn.backgroundColor = [UIColor redColor];
//    [btn addTarget:self action:@selector(getOpenStatus) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
}

//界面消失类型
-(void)myReturnWithIsSuccess:(BOOL) isSuccess{
    
    if (isSuccess == YES) {
        [NSUserDefaults setObject:[NSDate date] forKey:LastOpenTime];//保存时间
        NSString *passWordStr = _passWord2.textF.text;
        if (passWordStr != nil && ![passWordStr isEqualToString:@""]) {
            [NSUserDefaults setObject:passWordStr forKey:KHLoginPassWord];//开户的登录密码
            [NSUserDefaults setObject:passWordStr forKey:[Util DealSHReplacePassWord]];
        }
    }
    
    if (_appearType == AppearTypeAddView) {
        [self.view removeFromSuperview];
    }else if (_appearType == AppearTypePresent){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (_appearType == AppearTypePush){
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    //此处返回是否验证成功
    if (self.returnBlock != nil) {
        self.returnBlock(isSuccess);
    }    
}

-(void)getOpenStatus{
    
    LOG(@"getOpenStatus~~~~~执行!");
    _noDataView.hidden = YES;

    NSString *KHAccountStr = [NSUserDefaults objectForKey:KHAccount];
    if (KHAccountStr == nil || [KHAccountStr isEqualToString:@""]) {
        return;
    }
    //判断当前账号的状态
    NSDictionary *params = @{@"method":@"GetCustomerStatus",
                             @"loginAccount":KHAccountStr};
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        LOG(@"NormalInfoViewController%@",responseObject);
        
        NSDictionary *resultDic = responseObject;
        
        if ([[resultDic handleNullObjectForKey:@"errCode"] isEqual: @"99999"]) {
            
            NSString *OpenAccountStatusStr = [resultDic handleNullObjectForKey:@"status"];
            [NSUserDefaults setObject:OpenAccountStatusStr forKey:OpenAccountStatus];
            
            if ([OpenAccountStatusStr isEqual: @"1"]) {
                //1:正在开户
                _isOpeningView.hidden = NO;
                _hasOpenedView.hidden = YES;
                return ;
            }else if([OpenAccountStatusStr isEqual: @"2"]){
                
                //2.开户成功
                if ([NSUserDefaults boolForKey:isBangDingAccount]) {
                    //如果绑定成功
                    _isOpeningView.hidden = YES;
                    _hasOpenedView.hidden = YES;
                    [self selfHidden:NO];
                }else{
                    [self toulemeOpenAccount];
                    _isOpeningView.hidden = YES;
                    _hasOpenedView.hidden = NO;
                    [self selfHidden:NO];
                    [self showTouchID];//显示指纹
                }
            }else if([OpenAccountStatusStr isEqual: @"3"]){
                //3.开户失败
                _isOpeningView.hidden = YES;
                _hasOpenedView.hidden = YES;
                [HUDTool showText:@"开户失败"];
                return ;
            }
        }
        else{
            
            if ([[resultDic handleNullObjectForKey:@"errCode"] isEqual: @"10030"]) {
                return;
            }
            [self selfHidden:YES];
            [HUDTool showText:@"获取开户状态失败"];
            _noDataView.hidden = NO;
            return ;
        }
        
    } failure:^(NSError *error) {
        
        [self selfHidden:YES];
        [HUDTool showText:@"当前网络环境异常"];
         _noDataView.hidden = NO;
        return ;
        
    }];

}

-(void)toulemeOpenAccount{
    
    //参数说明:
    /// <param name="userId">用户ID</param>
    /// <param name="phone">手机号码</param>
    /// <param name="accCode">实盘账号</param>
    /// <param name="accTrueName">真实姓名</param>
    /// <param name="accIdCard">身份证号</param>
    
    //已经开户的不再绑定
    if ([NSUserDefaults boolForKey:isBangDingAccount] == YES) {
        return;
    } ;
    NSDictionary *params = @{@"userId":[NSUserDefaults objectForKey:UserID],
                             @"phone":[NSUserDefaults objectForKey:mobilePhone],
                             @"accCode":[NSUserDefaults objectForKey:KHAccount],
                             @"accTrueName":[NSUserDefaults objectForKey:IDCardName],
                             @"accIdCard":[NSUserDefaults objectForKey:certNo],
                             @"email":[NSUserDefaults objectForKey:KHEmail],
                             @"platformType":@8};
    
    [HttpTool XLGet:GET_OPENACCOUNT params:params success:^(id responseObj) {
        
        NSDictionary *dic = responseObj;
        NSString *state = dic[@"State"];
        if (state.integerValue == 1) {
            //成功
            [NSUserDefaults setBool:YES forKey:isOpenAccount];
            [NSUserDefaults setBool:YES forKey:isBangDingAccount];
            UIButton *btn = _hasOpenedView.btn;
            [btn setTitle:@"马上去交易" forState:UIControlStateNormal];
        }else{
            //失败
            UIButton *btn = _hasOpenedView.btn;
            [btn setTitle:@"完成绑定" forState:UIControlStateNormal];
            [HUDTool showText:[NSString stringWithFormat:@"%@,请完成绑定操作",dic[@"Descr"]]];
            return ;
        }
        
    } failure:^(NSError *error) {
        
        UIButton *btn = _hasOpenedView.btn;
        [btn setTitle:@"完成绑定" forState:UIControlStateNormal];
        [HUDTool showText:@"数据绑定失败"];
        return ;
    }];
    
}

//是否显示指纹识别
-(void)showTouchID{

    BOOL isNow = [NSUserDefaults boolForKey:[Util isTouchIDPassWord]];
    NSDate *date = [NSUserDefaults objectForKey:LastOpenTime];
    if (self.signerType == SignerTypeTouchID) {//当前类型为带指纹
        if (isNow == YES && [Util compareWithCurrentTimeByCompareDate:date WithMin:10]) {
            [self initTouchID];//增加手势识别
        }
    }
}

//指纹验证
-(void)initTouchID{
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"输入密码";
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"请验证已有手机指纹,登录交易所"
                          reply:^(BOOL success, NSError *error) {
                              if (success) {
                                  dispatch_async (dispatch_get_main_queue(), ^{
                                      //在主线程更新 UI,不然会卡主
//                                      [HUDTool showText:@"身份验证成功"];
                                      [DealSocketTool shareInstance].isTouchIDLoginIn = YES;
                                      [self loginToServerWithType:1];
                                  });
                                  
                              }else{
                                  
                                  switch (error.code) {
                                      case LAErrorAuthenticationFailed:
                                          NSLog(@"身份验证失败。");
                                          dispatch_async (dispatch_get_main_queue(), ^{
                                              
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                                              message:@"指纹验证失败,请尝试其它方式验证"
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"Ok"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                          });
                                          
                                          break;
                                          
                                      case LAErrorUserCancel:
                                          LOG(@"用户点击取消按钮。");
                                          
                                          break;
                                          
                                      case LAErrorUserFallback:
                                      {
                                          LOG(@"用户点击输入密码。");
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              //用户选择输入密码，切换主线程处理
                                          }];
                                          break;
                                      }
                                      case LAErrorSystemCancel:
                                          LOG(@"另一个应用程序去前台");
                                          
                                          break;
                                          
                                      case LAErrorPasscodeNotSet:
                                          LOG(@"密码在设备上没有设置");
                                          
                                          break;
                                          
                                      case LAErrorTouchIDNotAvailable:
                                          NSLog(@"触摸ID在设备上不可用");
                                          dispatch_async (dispatch_get_main_queue(), ^{
                                              
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                                              message:@"Touch ID在设备上不可用"
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"Ok"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                          });
                                          
                                          break;
                                          
                                      case LAErrorTouchIDNotEnrolled:
                                          NSLog(@"没有登记的手指触摸ID。");
                                          dispatch_async (dispatch_get_main_queue(), ^{
                                              
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                                              message:@"没有登记的手指Touch ID"
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"Ok"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                          });
                                          
                                          break;
                                          
                                      default:
                                      {
                                          LOG(@"Touch ID没配置");
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              //其他情况，切换主线程处理
                                          }];
                                          break;
                                      }
                                  }
                              }
                          }];
        
    } else {
        
        //用户把所有touchID删除之后自动不提示
//        dispatch_async (dispatch_get_main_queue(), ^{
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                            message:@"您的设备没有Touch ID."
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//            [alert show];
//        });
    }
    
    
}




-(void)selfHidden:(BOOL)hidden{

    _accountNum.hidden = hidden;
    _passWord2.hidden = hidden;
    _loginBtn.hidden = hidden;
    _findBtn.hidden = hidden;
}

- (void)cancelButtonClick {
    //此处返回是否验证
    [self myReturnWithIsSuccess:NO];
}

//登录获得绑定开户账号
-(void)complantOpenAccount{
    if (_appearType == AppearTypeAddView) {
        [self.view removeFromSuperview];
    }else if (_appearType == AppearTypePresent){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (_appearType == AppearTypePush){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)dealloc{
    
    LOG(@"SingerVC销毁~~~~~");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loginToServerWithType:(NSInteger) useType{
    
    NSString *passWordStr = _passWord2.textF.text;
    if (useType == 1) {//指纹取保存密码
        passWordStr =  [NSUserDefaults objectForKey:[Util DealSHReplacePassWord]];
    }
    if (passWordStr == nil || [passWordStr isEqualToString:@""]) {
        return;//密码为空退出
    }
    if ([[DealSocketTool shareInstance] connectToRemote]) {
        [[DealSocketTool shareInstance] cutOffSocket];
    }
    [[DealSocketTool shareInstance] loginToServerWithPassWord:passWordStr Block:^(unsigned short isSuccess, NSString *statusStr) {
        
        if (isSuccess == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SignSuccess" object:nil];
            [self myReturnWithIsSuccess:YES];
        }else if(isSuccess == 0){
            
            [self hideHud];
            NSRange range = [statusStr rangeOfString:@"重复登录"];
            if (range.length == 0) {
                [[DealSocketTool shareInstance] cutOffSocket];
                
                range = [statusStr rangeOfString:@"牛奶金服"];
                if (range.length > 0) {
                    [Util alertViewWithMessage:statusStr Target:self];
                }else{
                    [HUDTool showText:statusStr];
                }
            }else{
                //重复登录也视为登录成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SignSuccess" object:nil];
                [self myReturnWithIsSuccess:YES];
            }
            return ;
        }else{
            [HUDTool showText:@"服务器异常"];
            return ;
        }
    }];
}

//显示风火轮
-(void)showHud{
    dispatch_main_async_safe(^{
        
        [DealSocketTool shareInstance].loadingGif.centerX = WIDTH / 2;
        [DealSocketTool shareInstance].loadingGif.centerY = self.view.centerY * 0.9;
        [self.view addSubview:[DealSocketTool shareInstance].loadingGif];
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(hideHud) withObject:nil afterDelay:10.0f];
    });
}
//隐藏风火轮
-(void)hideHud{
    dispatch_main_async_safe(^{
        [[DealSocketTool shareInstance].loadingGif removeFromSuperview];
         self.view.userInteractionEnabled = YES;
    });
}

-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 101) {
        //下一步
        if([Util isEmpty:_passWord2.textF.text]){
            [HUDTool showText:@"登录密码不能为空"];
            return ;
        }
        [self showHud];
        [self loginToServerWithType:0];
    }else if(btn.tag == 102){
         //忘记密码
        GetCodeViewController *vc = [[GetCodeViewController alloc] init];
        vc.vcType = 0;//交易密码

        if (self.navigationController != nil) {
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UITabBarController *tabVC = (UITabBarController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
            IINavigationController *selfVC = tabVC.childViewControllers[tabVC.selectedIndex];
            if ([selfVC isKindOfClass:[IINavigationController class]]) {
                [selfVC pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}


@end
