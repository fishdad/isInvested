//
//  LoginViewController.m
//  isInvested
//
//  Created by Ben on 16/8/15.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "GetCodeViewController.h"
#import "NSDictionary+NullKeys.h"
#import "JPUSHService.h"
#import "UILabel+TextWidhtHeight.h"


@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _phoneNum.textF.text = [NSUserDefaults objectForKey:Account];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";

    //背景图片
    UIImageView *View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    View.image=[UIImage imageNamed:@"bg4.jpg"];
     View.backgroundColor = OXColor(0xffffff);
    [self.view addSubview:View];

    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,20,44,44)];
    [backBtn setImage:[UIImage imageNamed:@"backBlue"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickaddBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //标题
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((WIDTH - 200) / 2, 30, 200, 30);
    label.text = self.title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];

    
    [self initMyView];
}

-(void)myReturn{

     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickaddBtn
{
    
    if (self.cancelBlock != nil) {
        self.cancelBlock();
    }
    
    [self myReturn];
}

-(void)initMyView{

    //app图片
    CGFloat imgW = 80;
    CGFloat imgH = 80;
    CGFloat hSpace = 80;
    UIImageView *_img = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - imgW) / 2.0, hSpace, imgW, imgH)];
    _img.layer.masksToBounds = YES;
    _img.layer.cornerRadius = 10;
    _img.image = [UIImage imageNamed:@"appIcon"];
    [self.view addSubview:_img];
    
    //手机号
    CGFloat x = 25;
    _phoneNum = [[MyTextView alloc] initWithFrame:CGRectMake(x, _img.bottom + hSpace, (WIDTH - 2 * x), 44) TitleStr:@"四个汉字"];
    [self.view addSubview:_phoneNum];
//    _phoneNum.textF.keyboardType = UIKeyboardTypePhonePad;
//    _phoneNum.img.image = [UIImage imageNamed:@"user_hl"];
    _phoneNum.lbl.text = @"账号";
    _phoneNum.lbl.width = [UILabel getWidthWithTitle:_phoneNum.lbl.text font:_phoneNum.lbl.font];
    _phoneNum.backColor = OXColor(0xffffff);
    _phoneNum.placeholder = @"请输入账号/手机号";
    
    //密码
    _passWord = [[MyTextView alloc] initWithFrame:CGRectMake(x, _phoneNum.bottom + 15, (WIDTH - 2 * x), 44)];
    [self.view addSubview:_passWord];
    _passWord.textF.secureTextEntry = YES;
//    _passWord.img.image = [UIImage imageNamed:@"lock_hl"];
    _passWord.lbl.text = @"密码";
    _passWord.backColor = OXColor(0xffffff);
    _passWord.placeholder = @"请输入密码";
    
    //登录
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, _passWord.bottom + 40, (WIDTH - 2 * x), 44)];
    loginBtn.tag = 101;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.backgroundColor = kNavigationBarColor;
    loginBtn.showsTouchWhenHighlighted = YES;
    [loginBtn setTitle:@"安全登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //忘记密码
    UIButton *findBtn = [[UIButton alloc] initWithFrame:CGRectMake(x - 50, loginBtn.bottom + 5, (WIDTH / 2.0 -  x), 44)];
    findBtn.tag = 102;
    [findBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
//    findBtn.backgroundColor = [UIColor redColor];
    findBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [findBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [findBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findBtn];

    //注册
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2.0 + 25, loginBtn.bottom + 5, (WIDTH / 2.0 - x), 44)];
    registBtn.tag = 103;
    [registBtn setTitle:@"没有账号?立即注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
//    registBtn.backgroundColor = [UIColor redColor];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [registBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
}

-(void)btnClick:(UIButton *)btn{

    if (btn.tag == 101) {
        //登录
        if([Util isEmpty:_phoneNum.textF.text]){
            [HUDTool showText:@"账号不能为空"];
            return ;
        }
        
//        if(![Util validateJRJ:[Util filtrationSpace1:_phoneNum.textF.text]]){
//            [HUDTool showText:@"请输入正确的账号,账号为2-20的字母或数字，首位必须是字母"];
//            return;
//        }

    
        if([Util isEmpty:_passWord.textF.text]){
            [HUDTool showText:@"密码不能为空"];
            return ;
        }
        //proType 当前平台 3 投了么
        NSDictionary *params = @{@"loginname":_phoneNum.textF.text,
                                 @"passwd":_passWord.textF.text,
                                 @"proType":@3};
        
        [HttpTool XLGet:GET_LOGIN params:params success:^(id responseObj) {
            
            NSDictionary *dic = responseObj;
            
            if([[dic objectForKey:@"State"] integerValue]==1){
                
//                [HUDTool showText:@"登录成功"];
                
                NSDictionary *userDic = [Util dictionaryWithJsonString:[dic objectForKey:@"Descr"]];
                [NSUserDefaults setObject:_phoneNum.textF.text forKey:Account];//账号(用户名)
                [NSUserDefaults setObject:userDic[@"nickname"] forKey:NickName];//昵称
                [NSUserDefaults setObject:userDic[@"uid"] forKey:UserID];//USERID
              //[NSUserDefaults setObject:userDic[@"avatar"] forKey:PhotoImgUrl];//头像[已废弃]
                [Util setPhotoImgUrlWithHost:PhotoImgUrlWithHost];
                [NSUserDefaults setBool:YES forKey:isLogin];
                NSString *mobiledes = userDic[@"mobiledes"];//手机号密文
                if (mobiledes != nil) {
                    [self getDESDeCodeMobiles:mobiledes];
                }
                //KH投了么~开户的账号
                NSString *account = userDic[@"account"];
                if (account == nil || [account isEqualToString:@""]) {
                    [NSUserDefaults setObject:@"" forKey:KHAccount];
                    [NSUserDefaults setBool:NO forKey:isOpenAccount];
                    [NSUserDefaults setBool:NO forKey:isBangDingAccount];
                    //如果未开户的情况下
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginWithNoAccount" object:nil];
                    [self myReturn];
                    if (_isGoToDeal == YES) {
                        [Util goToDeal];//手动点击交易
                    }
                }else{
                    [NSUserDefaults setObject:account forKey:KHAccount];
                    [NSUserDefaults setBool:YES forKey:isOpenAccount];
                    [NSUserDefaults setBool:YES forKey:isBangDingAccount];
                    //获取实盘信息
                    [self getAccountMessageWithuserId:userDic[@"uid"] accountNo:account];
                    //如果已经开户的情况下
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginWithOpenAccount" object:nil];
                }
            }else if([[dic objectForKey:@"State"] integerValue]==-1){
                [HUDTool showText:@"有为空的参数"];
                return ;
            }else if([[dic objectForKey:@"State"] integerValue]==-2){
                [HUDTool showText:@"登录名包含危险值"];
                return ;

            }else if ([[dic objectForKey:@"State"] integerValue]==-3){
                [HUDTool showText:@"用户被禁用"];
                return ;

            }else if ([[dic objectForKey:@"State"] integerValue]==0){
                [HUDTool showText:@"用户名或密码错误"];
                return ;
            }else if ([[dic objectForKey:@"State"] integerValue]==-4){
                [HUDTool showText:@"用户不属于当前平台"];
                return ;
                
            }

            
        } failure:^(NSError *error) {
            
            [HUDTool showText:@"请求超时,请稍后再试"];
            return ;            
        }];
        
    }
    if (btn.tag == 102) {
        //忘记密码
        GetCodeViewController *getCode = [[GetCodeViewController alloc] init];
        getCode.vcType = 3;
        [self.navigationController pushViewController:getCode animated:YES];
    }
    if (btn.tag == 103) {
        //注册
        RegistViewController *registVC = [[RegistViewController alloc] init];
        registVC.returnBlock = ^(){[self myReturn];};
        [self.navigationController pushViewController:registVC animated:YES];
    }
}

//手机密文解密
-(void)getDESDeCodeMobiles:(NSString *)mobiledes{

    [HttpTool XLGet:DESDeCodeMobiles params:@{@"mobiledes":mobiledes} success:^(id responseObj) {
        
        if([[responseObj objectForKey:@"State"] integerValue]==1){
            
            NSString *str = responseObj[@"Descr"];
            NSString *mobile = [str substringWithRange:NSMakeRange(str.length - 11, 11)];
            [NSUserDefaults setObject:mobile forKey:mobilePhone];
            LOG(@"手机号解密结果:%@",mobile);
        }
        
    } failure:^(NSError *error) {
        
        LOG(@"手机号解密失败:%@",error);
    }];

}
#pragma mark -- 获取实盘信息
-(void)getAccountMessageWithuserId:(NSString *) userId accountNo:(NSString *) accountNo{

    NSDictionary *params = @{@"userId":userId,
                             @"accountNo":accountNo};
    [HttpTool XLGet:GetAccountMessage params:params success:^(id responseObj) {
        
        NSString *State = [responseObj objectForKey:@"state"];
        if([State integerValue]==1){
            
            [NSUserDefaults setObject:responseObj[@"data"][@"idCard"] forKey:certNo];
            [NSUserDefaults setObject:responseObj[@"data"][@"userName"] forKey:IDCardName];
            [NSUserDefaults setObject:responseObj[@"data"][@"createTime"] forKey:OpenAccountTime];
            
            
            NSString *card_list = responseObj[@"data"][@"bank"];
#pragma mark -- 拉取银行卡信息 :银行卡ID^银行code^银行卡号^签约账号
            if (card_list != nil && ![card_list isEqualToString:@""]) {
                
                [NSUserDefaults setBool:YES forKey:isSinaAccountBangding];//新浪支付绑卡成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GoOpenAccount" object:nil];
                
                
                NSArray *cardListArr = [card_list componentsSeparatedByString:@"^"];
                NSString *bankCardID = cardListArr[0];//银行卡ID
                NSString *bankCode = cardListArr[1];//银行
                NSString *bankCard = cardListArr[2];//银行卡号
                NSString *signAccount = cardListArr[3];//签约账号
                
                [NSUserDefaults setObject:bankCardID forKey:SinaBangdingbankCardID];
                [NSUserDefaults setObject:bankCode forKey:SinaBangdingBank];
                [NSUserDefaults setObject:bankCard forKey:SinaBangdingBankCard];
                [NSUserDefaults setObject:signAccount forKey:KHSignAccount];
                [NSUserDefaults setObject:@"2" forKey:OpenAccountStatus];
                
                //设置别名
                [Util setJPushAlise:signAccount];
                //JPush 监听登陆成功
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(networkDidLogin:)
                                                             name:kJPFNetworkDidLoginNotification
                                                           object:nil];
                
                [self myReturn];
                if (_isGoToDeal == YES) {
                    [Util goToDeal];//手动点击交易
                }
            }else{
                [self getOpenStatus];//获取绑卡状态,处理绑卡失败的情况,不进行错误提示与广贵接口完全脱离
            }
        }
        
    } failure:^(NSError *error) {
        
        LOG(@"实盘信息失败:%@",error);
    }];

}

-(void)networkDidLogin:(NSNotification *)noti{
    [Util setJPushAlise:nil];
}


//检查是否绑定银行卡
//获取开户状态
-(void)getOpenStatus{

    LOG(@"getOpenStatus~~~~~执行!");
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
            if([OpenAccountStatusStr isEqual: @"2"]){
                //2.开户成功 -- 签约账号
                NSString *signAccount = [resultDic handleNullObjectForKey:@"signAccount"];
                [NSUserDefaults setObject:signAccount forKey:KHSignAccount];
                [self query_bank_card];
            }
        }else if([[resultDic handleNullObjectForKey:@"errCode"] isEqual: @"88888"]){
         
//            [Util alertViewWithCancelBtnAndMessage:@"交易所系统维护中,请联系相关工作人员处理" Target:self doActionBtn:@"下一步" handler:^(UIAlertAction *action) {
//                [self myReturn];
//            }];
            [self myReturn];
        }
        
        if ([[resultDic handleNullObjectForKey:@"status"] isEqual: @"3"]) {
            
//             [Util alertViewWithCancelBtnAndMessage:@"开户失败,请联系相关工作人员处理" Target:self doActionBtn:@"下一步" handler:^(UIAlertAction *action) {
//                 [self myReturn];
//             }];
            [self myReturn];
        }
    } failure:^(NSError *error) {
        
//        [HUDTool showText:@"开户服务器连接异常,请稍后..."];
        [self myReturn];
    }];
    
}

//查询银行卡信息
-(void)query_bank_card{
    
    //获取IP地址
    NSString *_IPV4Str =  [Util getIPV4String];
    
    if (_IPV4Str == nil || [_IPV4Str isEqualToString:@""]) {
        [HUDTool showText:@"请确认连接的网络"];
        return ;
    }
    NSDictionary *params = @{@"loginAccount":[NSUserDefaults objectForKey:KHSignAccount],
                             @"ip":_IPV4Str};
    [GGHttpTool post:[Util getSinaBangdingUrlBytype:query_bank_card] params:params success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        if ([dic[@"response_code"] isEqualToString:@"APPLY_SUCCESS"]) {
            //用户已经绑定银行卡
            NSString *card_list = dic[@"card_list"];
            if (card_list != nil && ![card_list isEqualToString:@""]) {
                [NSUserDefaults setBool:YES forKey:isSinaAccountBangding];//新浪支付绑卡成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GoOpenAccount" object:nil];
                NSArray *cardListArr = [card_list componentsSeparatedByString:@"^"];
                NSString *bankCardID = cardListArr[0];//银行卡ID
                NSString *bankCode = cardListArr[1];//银行
                NSString *bankCard = cardListArr[2];//银行卡号
                
                [NSUserDefaults setObject:bankCardID forKey:SinaBangdingbankCardID];
                [NSUserDefaults setObject:bankCode forKey:SinaBangdingBank];
                [NSUserDefaults setObject:bankCard forKey:SinaBangdingBankCard];
                [self UpdateAccountBank];
            }else{
                [NSUserDefaults setBool:NO forKey:isSinaAccountBangding];//新浪支付未绑卡
            }
        }
        [self myReturn];
        if (_isGoToDeal == YES) {
            [Util goToDeal];//手动点击交易
        }
    } failure:^(NSError *error) {
        
        LOG(@"%@",error);
        
    }];
    
}

//用户实盘绑定银行卡
-(void)UpdateAccountBank{
    
    NSString *bankCardID = [NSUserDefaults objectForKey:SinaBangdingbankCardID];
    NSString *bankCode = [NSUserDefaults objectForKey:SinaBangdingBank];
    NSString *bankCard =  [NSUserDefaults objectForKey:SinaBangdingBankCard];
    NSString *signAccount = [NSUserDefaults objectForKey:KHSignAccount];//签约账号
    NSString *bankData = [NSString stringWithFormat:@"%@^%@^%@^%@",bankCardID,bankCode,bankCard,signAccount];
    
    
    NSString *useid = [NSUserDefaults objectForKey:UserID];
    NSDictionary *params = @{@"userId":useid,
                             @"firmCode":[NSUserDefaults objectForKey:KHAccount],
                             @"bankData":bankData};
    
    [HttpTool XLGet:UpdateAccountBank params:params success:nil failure:nil];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
