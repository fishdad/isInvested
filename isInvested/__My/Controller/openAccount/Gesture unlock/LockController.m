//
//  LockController.m
//  新华易贷
//
//  Created by 吴 凯 on 15/9/21.
//  Copyright (c) 2015年 吴 凯. All rights reserved.
//

#import "LockController.h"

#import <LocalAuthentication/LocalAuthentication.h>
#import "SignerViewController.h"
#import "IINavigationController.h"
#import "UIImage+GIF.h"

#define KSCREENW [UIScreen mainScreen].bounds.size.width

#define KSCREENH [UIScreen mainScreen].bounds.size.height

@interface LockController ()<LockViewDelegate,UIAlertViewDelegate>
{

    UIImageView* _loadingGif;
}
//@property (weak, nonatomic) IBOutlet UILabel *locklabel;
@property(nonatomic,weak)UILabel *unlocklabel;
@property(nonatomic,weak)UILabel *setpassword;
//标记是否是重置密码
@property(nonatomic ,assign,getter=isresetpassword)BOOL resetpassword;
//判断是否是两次确认密码
@property(nonatomic,assign,getter=istwopassword)BOOL twopassword;

@property(nonatomic,assign) LockType lockType;//解锁,重置(判断本地没有密码时为设置页面,所以不处理)
@property (nonatomic, assign) BOOL isFindErrorPass;//密码超出次数找回

@property (nonatomic, strong) UIButton *cancelbutt;
@property (nonatomic, strong) UIButton *findPassWordButton;

@end

@implementation LockController

-(instancetype)initWithLockType:(LockType)lockType{

    self = [super init];
    
    self.lockType = lockType;
    
    return self;
    
}

-(int)getCanGoTime{

    NSDate *startD = [NSUserDefaults objectForKey:@"errorPassWordTime"];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int min = (int)value / 60;//分
    
    return (10 - min);
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self hideHud];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self judgeViewDisplay];
    NSInteger errorCount = [[NSUserDefaults objectForKey:@"errorCount"] integerValue];
    BOOL isOutOfTime = [self isOutOfTime];
    if (!isOutOfTime) {
        
        if (errorCount >= 5) {
            UILabel *errorLabel = [self.lockview viewWithTag:8888];
            int min = [self getCanGoTime];
            errorLabel.text = [NSString stringWithFormat:@"多次输入错误,请%d分钟以后重试",min];
            [self shakeAnimation];
            
            [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
                
                NSString *msg = [NSString stringWithFormat:@"手势密码错误次数过多,您可以通过忘记手势密码来验证身份或%d分钟之后重试",min];
                [Util alertViewWithCancelBtnAndMessage:msg Target:dealVC doActionBtn:@"忘记手势密码" handler:^(UIAlertAction *action) {
                    [self findPassWordButtonClick];
                }];
            }];
        }else{
        
            UILabel *errorLabel = [self.lockview viewWithTag:8888];
            errorLabel.text = [NSString stringWithFormat:@"密码错误,您还可以输入%ld次",(long)(5 - errorCount)];
        }
        
    }else{
        [NSUserDefaults setObject:nil forKey:@"errorPassWordTime"];//保存时间
        [NSUserDefaults setObject:@(0) forKey:@"errorCount"];
        UILabel *errorLabel = [self.lockview viewWithTag:8888];
        errorLabel.text = @"";
    }
    
    BOOL isNow = [NSUserDefaults boolForKey:[Util isTouchIDPassWord]];
    NSDate *date = [NSUserDefaults objectForKey:LastOpenTime];
    
    if (_lockType == LockTypeOpen && isNow == YES && [Util compareWithCurrentTimeByCompareDate:date WithMin:10]) {
        [self initTouchID];//增加手势识别
    }
    
}
//界面消失类型
-(void)myReturnWithIsSuccess:(BOOL) isSuccess{

    //此处返回是否验证成功
    if (self.returnBlock != nil) {
        self.returnBlock(isSuccess);
    }

    if (isSuccess == YES) {
        
        //成功返回错误密码相关清除
        [NSUserDefaults setObject:nil forKey:@"errorPassWordTime"];//保存时间
        [NSUserDefaults setObject:@(0) forKey:@"errorCount"];
        UILabel *errorLabel = [self.lockview viewWithTag:8888];
        errorLabel.text = @"";
        
         [NSUserDefaults setObject:[NSDate date] forKey:LastOpenTime];//保存时间
         [NSUserDefaults setBool:YES forKey:[Util isSHPassWord]];
        //手势代替的交易密码
        NSString *passWord = [NSUserDefaults objectForKey:[Util DealSHReplacePassWord]];
        if (passWord == nil) {
            [NSUserDefaults setObject:[DealSocketTool shareInstance].LoginPassWordStr forKey:[Util DealSHReplacePassWord]];
        }
        if (_lockType == LockTypeOpen) {
           [self loginToServer];
        }else{
           [self myViewReturn];
        }
    }else{
        [self myViewReturn];
    }
}

//返回类型
-(void)myViewReturn{
    if (_appearType == LockAppearTypeAddView) {
        [self.view removeFromSuperview];
    }else if (_appearType == LockAppearTypePresent){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (_appearType == LockAppearTypePush){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//登录服务器
-(void)loginToServer{
    
    [self showHud];
    NSString *passWord = [NSUserDefaults objectForKey:[Util DealSHReplacePassWord]];
    if (passWord == nil) {
        passWord = [DealSocketTool shareInstance].LoginPassWordStr;
    }
    if (passWord == nil || [passWord isEqualToString:@""]) {
        return;
    }
//    [[DealSocketTool shareInstance] cutOffSocket];
    [[DealSocketTool shareInstance] loginToServerWithPassWord:passWord Block:^(unsigned short isSuccess, NSString *statusStr) {
        
        LOG(@"*************%@",statusStr);
        if (isSuccess == 1) {
            //此处返回是否验证成功
            //[HUDTool showText:statusStr];
            //用于实际交易时
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SignSuccess" object:nil];
            [self myViewReturn];
        }else if(isSuccess == 0){
            
            [self hideHud];
            NSRange range = [statusStr rangeOfString:@"重复登录"];
            if (range.length == 0) {
                [[DealSocketTool shareInstance] cutOffSocket];
                [HUDTool showText:statusStr];
            }else{
                //重复登录也视为登录成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SignSuccess" object:nil];
                [self myViewReturn];
            }
            return ;
        }else{
            [HUDTool showText:@"服务器异常"];
            return ;
        }
    }];
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
                                      [self myReturnWithIsSuccess:YES];
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

//登录获得绑定开户账号
-(void)complantOpenAccount{
    if (_appearType == LockAppearTypeAddView) {
        [self.view removeFromSuperview];
    }else if (_appearType == LockAppearTypePresent){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (_appearType == LockAppearTypePush){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//忘记密码找回密码成功
-(void)ReSetPassWordSuccess{
    //清空手势密码
    WEAK_SELF
    UILabel *errorLabel = [self.lockview viewWithTag:8888];
    errorLabel.text = @"";
    [NSUserDefaults setObject:nil forKey:@"errorPassWordTime"];//保存时间
    [NSUserDefaults setObject:@(0) forKey:@"errorCount"];
    [NSUserDefaults setBool:NO forKey:[Util isSHPassWord]];
    //手势代替的交易密码
    [NSUserDefaults setObject:nil forKey:[Util DealSHReplacePassWord]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[Util passwordone]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[Util passwordtwo]];
    
    for (int i = 1; i <= 6; i ++) {
        UIView *view = [weakSelf.view viewWithTag:(100 + i)];
        [view removeFromSuperview];
    }
    //添加下次设置按钮
    [weakSelf addCancelButton];
    [weakSelf setPassWordView:@"设置手势密码"];
}

-(void)dealloc{
    
    LOG(@"手势锁界面销毁~~~~~~");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 判断时间差是否超出
-(BOOL)isOutOfTime
{
    NSDate *compareDate = [NSUserDefaults objectForKey:@"errorPassWordTime"];
    if (compareDate == nil) {
        return YES;
    }else{
        NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
        timeInterval = -timeInterval;
        if (timeInterval < 10 * 60) {
            //没有超时
            return NO;
        }else{
            //超时
            return YES;
        }
    }
}

//晃动动画
-(void)shakeAnimation{

    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.fromValue = [NSNumber numberWithFloat:-5];
    shake.toValue = [NSNumber numberWithFloat:5];
    shake.duration = 0.1;//执行时间
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 3;//次数
    UILabel *infoLabel = [self.lockview viewWithTag:8888];
    [infoLabel.layer addAnimation:shake forKey:@"shakeAnimation"];
    infoLabel.alpha = 1.0;
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
        //self.infoLabel.alpha = 0.0; //透明度变0则消失
    } completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tag = VCViewTagLockVC;
    //当前登录账号未开户的情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(complantOpenAccount) name:@"LoginWithNoAccount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReSetPassWordSuccess) name:@"ReSetPassWordSuccess" object:nil];

    self.title = @"手势密码";
    
    self.resetpassword = NO;
    self.twopassword = NO;
    LockView *lockview = [[LockView alloc]init];
    lockview.backgroundColor = [UIColor clearColor];
    lockview.width = WIDTH - 10 - 10;
    lockview.height = WIDTH - 10 - 10;
    lockview.x = (KSCREENW - lockview.width) * 0.5;
    lockview.y = 150;
    if (_signerFromType == SignerFromTypeSHSet) {
        lockview.y = 150 - 64;
    }
    self.lockview = lockview;
    
    
    UILabel *errorLabel = [[UILabel alloc] init];
    errorLabel.tag = 8888;
    errorLabel.frame = CGRectMake(0,-20,self.lockview.size.width, 30);
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.textColor = [UIColor redColor];
    errorLabel.font = [UIFont systemFontOfSize:15];
    [self.lockview addSubview:errorLabel];

#pragma mark -- 手势密码错误
    WEAK_SELF
    self.lockview.errorPassWorfBlock = ^(){
        
        if (_lockType == LockTypeReSet || _lockType == LockTypeChangeSet) {
            NSString *localpasswordone = [[NSUserDefaults standardUserDefaults]objectForKey:[Util passwordone]];
            NSString *localpasswordtwo = [[NSUserDefaults standardUserDefaults]objectForKey:[Util passwordtwo]];
            if (![localpasswordone isEqualToString:localpasswordtwo]) {
                return ;
            }
        }
        
        if (_lockType == LockTypeOpen) {
            NSString *localpasswordtwo = [[NSUserDefaults standardUserDefaults]objectForKey:[Util passwordtwo]];
            
            if (localpasswordtwo == nil) {
                return;
            }
        }
    
        NSDate *errorPassWordTime = [NSUserDefaults objectForKey:@"errorPassWordTime"];
        NSInteger errorCount = [[NSUserDefaults objectForKey:@"errorCount"] integerValue];
        if (errorPassWordTime == nil) {
            [NSUserDefaults setObject:[NSDate date] forKey:@"errorPassWordTime"];//保存时间
        }
        [NSUserDefaults setObject:@(errorCount + 1) forKey:@"errorCount"];
        errorCount = [[NSUserDefaults objectForKey:@"errorCount"] integerValue];
        NSInteger count = (5 - errorCount);
        if (count > 0) {
            errorLabel.text = [NSString stringWithFormat:@"密码错误,您还可以输入%ld次",(long)count];
            [self shakeAnimation];
        }else{
            int min = [self getCanGoTime];
            errorLabel.text = [NSString stringWithFormat:@"多次输入错误,请%d分钟以后重试",min];
    
            NSString *msg = [NSString stringWithFormat:@"手势密码错误次数过多,您可以通过忘记手势密码来验证身份或%d分钟之后重试",min];
            [Util alertViewWithCancelBtnAndMessage:msg Target:self doActionBtn:@"忘记手势密码" handler:^(UIAlertAction *action) {
                [weakSelf findPassWordButtonClick];
            }];
        }
    };
    
    
    lockview.delegate = self;
    [self.view addSubview:lockview];
    self.view.backgroundColor = OXColor(0xffffff);
    self.lockview.delegate = self;
    [self judgeMentLocalPassWord];

    if (_signerFromType == SignerFromTypeSHSet) {

        NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:[Util passwordtwo]];
        if (password == nil || _lockType == LockTypeChangeSet) {//第一次设置 或者 重置
            //身份验证
            SignerViewController *vc = [[SignerViewController alloc]init];
            [self addChildViewController:vc];
            vc.appearType = AppearTypeAddView;
            [self.view addSubview:vc.view];

        }
    }
    
    //自己返回事件处理
    UIBarButtonItem *left = [UIBarButtonItem itemWithTarget:self action:@selector(cancelButtonClick) image:@"back"];
    self.navigationItem.leftBarButtonItem = left;
}

//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

//添加重置密码按钮
- (void)addResetPassWordBuutton{
    UIButton *resetpassword = [[UIButton alloc]init];
//    [resetpassword setTitle:@"重置密码" forState:UIControlStateNormal];
    resetpassword.tag = 101;
    [resetpassword setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [resetpassword sizeToFit];
    resetpassword.y = CGRectGetMaxY(self.lockview.frame) + 10;
    resetpassword.x = (KSCREENW - resetpassword.width) * 0.5;
    [self.view addSubview:resetpassword];
    [resetpassword addTarget:self action:@selector(resetPassWord) forControlEvents:UIControlEventTouchUpInside];
}
//添加下次设置按钮
-(UIButton *)cancelbutt{

    if (_cancelbutt == nil) {
        _cancelbutt = [[UIButton alloc]init];
        _cancelbutt.tag = 102;
        [_cancelbutt setTitle:@"下次设置" forState:UIControlStateNormal];
        [_cancelbutt setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [_cancelbutt sizeToFit];
        _cancelbutt.y = CGRectGetMaxY(self.lockview.frame) + 10;
        _cancelbutt.x = (KSCREENW - _cancelbutt.width) * 0.5;
        [_cancelbutt addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelbutt;
}

- (void)addCancelButton{
 
    [self.view addSubview:self.cancelbutt];
}

//取消设置按钮
- (void)cancelButtonClick{
    //返回(没有设置)
    
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:[Util passwordtwo]];
    
    if (password == nil) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[Util passwordone]];
    }
    
    [self myReturnWithIsSuccess:NO];
}


//忘记手势密码按钮
-(UIButton *)findPassWordButton{

    if (_findPassWordButton == nil) {
        
        _findPassWordButton = [[UIButton alloc]init];
        _findPassWordButton.tag = 103;
        [_findPassWordButton setTitle:@"忘记手势密码?" forState:UIControlStateNormal];
        [_findPassWordButton setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [_findPassWordButton sizeToFit];
        _findPassWordButton.y = CGRectGetMaxY(self.lockview.frame) + 10;
        _findPassWordButton.x = (KSCREENW - _findPassWordButton.width) * 0.5;
        [_findPassWordButton addTarget:self action:@selector(findPassWordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _findPassWordButton;
}

- (void)addFindPassWordButton{
    [self.view addSubview:self.findPassWordButton];
}

//找回密码按钮
- (void)findPassWordButtonClick{
     _isFindErrorPass = YES;
    //忘记密码
    SignerViewController *vc = [[SignerViewController alloc] init];
    vc.appearType = AppearTypePush;
    WEAK_SELF
    vc.returnBlock = ^(BOOL isSuccess){
        if (isSuccess == YES) {
            [weakSelf ReSetPassWordSuccess];
        }
    };
    
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

//重置按钮点击事件
- (void)resetPassWord{
    self.resetpassword = YES;
    [self setLocklabel:@"确认旧手势密码"];
    [self.unlocklabel sizeToFit];
    self.unlocklabel.x = (KSCREENW - self.unlocklabel.width) * 0.5;
    self.unlocklabel.y = CGRectGetMinY(self.lockview.frame) - 40;

}


#pragma mark -- 手势解锁
- (BOOL)unlockView:(LockView *)unlockView withPassword:(NSString *)password
{
    NSString *localpasswordone = [[NSUserDefaults standardUserDefaults]objectForKey:[Util passwordone]];
    NSString *localpasswordtwo = [[NSUserDefaults standardUserDefaults]objectForKey:[Util passwordtwo]];
    
    if (self.twopassword) {
        if ([localpasswordone isEqualToString:localpasswordtwo]) {
            [HUDTool showText:@"密码设置成功"];
            self.twopassword = NO;
            if (_isFindErrorPass) {
                [self myViewReturn];
            }
            [self myReturnWithIsSuccess:YES];
            return YES;
        }else{
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"与上次密码不对应" message:@"请重新设置密码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertview show];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:[Util passwordone]];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:[Util passwordtwo]];
            [self setLocklabel:@"设置密码"];
            return NO;
        }
    }else{
        if ([password isEqualToString:localpasswordone]) {
            
            NSInteger errorCount = [[NSUserDefaults objectForKey:@"errorCount"] integerValue];
            BOOL isOutOfTime = [self isOutOfTime];
            if (!isOutOfTime) {
                
                if (errorCount >= 5) {
                    UILabel *errorLabel = [self.lockview viewWithTag:8888];
                    int min = [self getCanGoTime];
                    errorLabel.text = [NSString stringWithFormat:@"多次输入错误,请%d分钟以后重试",min];
                    [self shakeAnimation];
                    
                    [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
                        
                        NSString *msg = [NSString stringWithFormat:@"手势密码错误次数过多,您可以通过忘记手势密码来验证身份或%d分钟之后重试",min];
                        [Util alertViewWithCancelBtnAndMessage:msg Target:dealVC doActionBtn:@"忘记手势密码" handler:^(UIAlertAction *action) {
                            [self findPassWordButtonClick];
                        }];
                    }];
                    
                    return YES;
                }
            }
            if (self.isresetpassword) {
            
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:[Util passwordone]];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:[Util passwordtwo]];
                [self setLocklabel:@"设置新密码"];
                self.resetpassword = NO;
                [NSUserDefaults setObject:nil forKey:@"errorPassWordTime"];//保存时间
                [NSUserDefaults setObject:@(0) forKey:@"errorCount"];
                UILabel *errorLabel = [self.lockview viewWithTag:8888];
                errorLabel.text = @"";
            }else{
                //成功返回 -- 解锁成功
                [self myReturnWithIsSuccess:YES];
            }
            return YES;
        }else {
            return NO;
        }
        return NO;
    }
}

- (void)setPassWordSuccess:(NSString *)tabelname{
    NSString *localpasswordone = [[NSUserDefaults standardUserDefaults]objectForKey:[Util passwordone]];
    NSString *localpasswordtwo = [[NSUserDefaults standardUserDefaults]objectForKey:@"passwordywo"];
    if (!localpasswordtwo||!localpasswordone ) {
        self.twopassword = YES;
    }
    self.setpassword.text = tabelname;
    self.unlocklabel.text = tabelname;
    [self.unlocklabel sizeToFit];
    [self.setpassword sizeToFit];
    self.setpassword.x = (KSCREENW - self.setpassword.width) * 0.5;
    self.setpassword.y = CGRectGetMinY(self.lockview.frame) - 40;
    self.unlocklabel.x = (KSCREENW - self.unlocklabel.width) * 0.5;
    self.unlocklabel.y = CGRectGetMinY(self.lockview.frame) - 40;

}


//判断本地是否存有密码
- (void)judgeViewDisplay{
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:[Util passwordtwo]];
    if (password == nil) {
        //添加下次设置按钮
        UIButton *cancelbutt = [self.view viewWithTag:102];
        if (cancelbutt == nil) {
            [self addCancelButton];
        }
        UIButton *findPassbtn = [self.view viewWithTag:103];
        findPassbtn.hidden = YES;
        UILabel *locklabel = [self.view viewWithTag:104];
        locklabel.text = @"设置手势密码";
    }else{
        //添加重置密码按钮
        if (self.lockType == LockTypeOpen) {
            
            UIButton *cancelbutt = [self.view viewWithTag:102];
            cancelbutt.hidden = YES;
            UIButton *findPassbtn = [self.view viewWithTag:103];
            if (findPassbtn == nil) {
                [self addFindPassWordButton];
            }
            UILabel *locklabel = [self.view viewWithTag:104];
            locklabel.text = @"手势解锁";

            
        }else if (self.lockType == LockTypeReSet){
            
            UIButton *cancelbutt = [self.view viewWithTag:102];
            cancelbutt.hidden = YES;
            UIButton *findPassbtn = [self.view viewWithTag:103];
            if (findPassbtn == nil) {
                [self addFindPassWordButton];
            }
            UILabel *locklabel = [self.view viewWithTag:104];
            locklabel.text = @"手势解锁";
            [self resetPassWord];
        }
    }
}


//判断本地是否存有密码
- (void)judgeMentLocalPassWord{
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:[Util passwordtwo]];
    if (password == nil) {
        //添加下次设置按钮
        [self addCancelButton];
        [self setPassWordView:@"设置手势密码"];
    }else{
        //添加重置密码按钮
        if (self.lockType == LockTypeOpen) {
            
//            [self addResetPassWordBuutton];
            [self addFindPassWordButton];
            [self unlockView:@"手势解锁"];
            
        }else if (self.lockType == LockTypeReSet){
            
            [self addFindPassWordButton];
            [self unlockView:@"手势解锁"];
            [self resetPassWord];
        }
    }
}

//设置密码界面
- (void)setPassWordView:(NSString *)lockstr{
    UILabel *locklabel = [[UILabel alloc]init];
    locklabel.tag = 104;
    locklabel.text = lockstr;
    locklabel.textAlignment = NSTextAlignmentCenter;
    self.setpassword = locklabel;
    locklabel.textColor = kNavigationBarColor;
    [locklabel sizeToFit];
    locklabel.x = (KSCREENW - locklabel.width) * 0.5;
    locklabel.y = CGRectGetMinY(self.lockview.frame) - 40;
    [self.view addSubview:locklabel];
}

- (void)setLocklabel:(NSString *)locklstr{
    
    self.setpassword.text = locklstr;
    self.unlocklabel.text = locklstr;
    [self.setpassword sizeToFit];
    [self.unlocklabel sizeToFit];
    self.setpassword.x = (KSCREENW - self.setpassword.width) * 0.5;
    self.setpassword.y = CGRectGetMinY(self.lockview.frame) - 40;
    self.unlocklabel.x = (KSCREENW - self.unlocklabel.width) * 0.5;
    self.unlocklabel.y = CGRectGetMinY(self.lockview.frame) - 40;
    [self.view addSubview:self.setpassword];
    [self.view addSubview:self.unlocklabel];

}

//手势解锁界面
- (void)unlockView:(NSString *)unlockstr{
    
    UILabel *locklabel = [[UILabel alloc]init];
    locklabel.tag = 105;
    self.unlocklabel = locklabel;
    locklabel.text = unlockstr;
    locklabel.textColor = kNavigationBarColor;
    [locklabel sizeToFit];
    locklabel.x = (KSCREENW - locklabel.width) * 0.5;
    locklabel.y = CGRectGetMinY(self.lockview.frame) - 40;
    [self.view addSubview:locklabel];
    
    UILabel *label = [[UILabel alloc] init];
    label.tag = 106;
    label.frame = CGRectMake(0, locklabel.y - 40,WIDTH, 30);
//    label.text = @"广贵中心";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kNavigationBarColor;
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
}

//显示风火轮
-(void)showHud{
    dispatch_main_async_safe(^{
        
        [DealSocketTool shareInstance].loadingGif.centerX = WIDTH / 2;
        [DealSocketTool shareInstance].loadingGif.centerY = self.view.centerY + 100;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
