//
//  RegistViewController.m
//  isInvested
//
//  Created by Ben on 16/8/15.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "RegistViewController.h"
#import "RiskAgreeViewController.h"

@interface RegistViewController ()
{

    NSString *_codePhone;
}

@end

@implementation RegistViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"注册";
    self.view.window.backgroundColor = [UIColor whiteColor];
    //背景
    UIImageView *View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    View.image=[UIImage imageNamed:@"bg4.jpg"];
    View.backgroundColor = [UIColor whiteColor];
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

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initMyView{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, HEIGHT - 44)];
    [self.view addSubview:scrollView];

    //app图片
    CGFloat imgW = 80;
    CGFloat imgH = 80;
    CGFloat hSpace = 55;
    UIImageView *_img = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - imgW) / 2.0, hSpace, imgW, imgH)];
    _img.layer.masksToBounds = YES;
    _img.layer.cornerRadius = 10;
    _img.image = [UIImage imageNamed:@"appIcon"];
    [scrollView addSubview:_img];
    
    CGFloat x = 25;
    //账号
    _nickName = [[MyTextView alloc] initWithFrame:CGRectMake(x, _img.bottom + hSpace, (WIDTH - 2 * x), 44)];
    [scrollView addSubview:_nickName];
    _nickName.backColor = OXColor(0xffffff);
//    _nickName.img.image = [UIImage imageNamed:@"user_hl"];
    _nickName.lbl.text = @"账号";
    _nickName.placeholder = @"请输入登录账号,以字母开头";
    
    //密码
    _passWord = [[MyTextView alloc] initWithFrame:CGRectMake(x, _nickName.bottom + 10, (WIDTH - 2 * x), 44)];
    [scrollView addSubview:_passWord];
//    _passWord.img.image = [UIImage imageNamed:@"lock_hl"];
    _passWord.lbl.text = @"密码";
    _passWord.textF.secureTextEntry = YES;
    _passWord.backColor = OXColor(0xffffff);
    _passWord.placeholder = @"6-16位字母、数字、特殊符号";
    
    //确认密码
    _passWord2 = [[MyTextView alloc] initWithFrame:CGRectMake(x, _passWord.bottom + 10, (WIDTH - 2 * x), 44)];
    [scrollView addSubview:_passWord2];
//    _passWord2.img.image = [UIImage imageNamed:@"lock_hl"];
    _passWord2.lbl.text = @"确认密码";
    _passWord2.textF.secureTextEntry = YES;
    _passWord2.backColor = OXColor(0xffffff);
    _passWord2.placeholder = @"请再次输入密码";
    
    //手机号
    _phoneNum = [[MyTextView alloc] initWithFrame:CGRectMake(x, _passWord2.bottom + 10, (WIDTH - 2 * x), 44)];
    [scrollView addSubview:_phoneNum];
    //    _phoneNum.img.image = [UIImage imageNamed:@"phone_hl"];
    _phoneNum.lbl.text = @"手机号";
    _phoneNum.placeholder = @"请输入手机号";
    _phoneNum.textF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNum.backColor = OXColor(0xffffff);
    
    //获取验证码
    _code = [[MyTextView alloc] initWithFrame:CGRectMake(x, _phoneNum.bottom + 10, (WIDTH - 2 * x), 44)];
    [scrollView addSubview:_code];
    _code.backColor = OXColor(0xffffff);
    _code.textF.keyboardType = UIKeyboardTypeNumberPad;
//    _code.img.image = [UIImage imageNamed:@"code_hl"];
    _code.lbl.text = @"验证码";
    _code.placeholder = @"请输入验证码";
    _code.actBtn.backgroundColor = kNavigationBarColor;
    _code.actBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_code.actBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _code.actBtn.hidden = NO;
    WEAK_SELF
    _code.actBtnBlock = ^(){
        
        if([Util isEmpty: weakSelf.phoneNum.textF.text]){
            [HUDTool showText:@"请输入您的手机号"];
            return ;
        }
        
        if([Util validatePhoneNumber: weakSelf.phoneNum.textF.text] == NO){
            [HUDTool showText:@"您输入的手机号不合法"];
            return ;
        }
        
        if([Util isEmpty:weakSelf.nickName.textF.text]){
            [HUDTool showText:@"账号不能为空"];
            return ;
        }
        
        if([Util isEmpty:weakSelf.phoneNum.textF.text]){
            [HUDTool showText:@"手机号不能为空"];
            return ;
        }
        
        if(![Util validateUserName:weakSelf.nickName.textF.text]){
            [HUDTool showText:@"用户名为2-20位字母或数字，首位必须是字母"];
            return;
        }
        
        
        if([Util isEmpty:weakSelf.passWord.textF.text]){
            [HUDTool showText:@"密码不能为空"];
            return ;
        }
        
        if(![Util validateUserPassword:weakSelf.passWord.textF.text]){
            [HUDTool showText:@"密码长度为6~16"];
            return;
        }
        
        
        if([Util isEmpty:weakSelf.passWord2.textF.text]){
            [HUDTool showText:@"再次确认密码不能为空"];
            return ;
        }
        
        if (![weakSelf.passWord.textF.text isEqualToString:weakSelf.passWord2.textF.text]) {
            [HUDTool showText:@"两次密码不一致,请确认"];
            return ;
        }
        
        //1.注册 2.修改密码 3.修改资金密码 4.修改交易密码
        [HttpTool XLGet:GET_VALIDATECODE params:@{@"mobile":weakSelf.phoneNum.textF.text,
                                            @"sendSource":@"1"} success:^(id responseObj) {
            
            NSDictionary *dic = responseObj;
            
            NSInteger state = [[dic objectForKey:@"State"] integerValue];
            
            if(state==1){
                
                weakSelf.validateCode = [dic objectForKey:@"Descr"];
                
                _codePhone = weakSelf.phoneNum.textF.text;
#warning  测试直接反填验证码 xinle(正式上线删除)
                weakSelf.code.textF.text = weakSelf.validateCode;
                
                [HUDTool showText:@"验证码发送成功"];
                return ;
            }else if(state==-1){
                [HUDTool showText:@"有为空的参数"];
                return ;
            }else if(state==-2){
                [HUDTool showText:@"手机号不规范"];
                return ;
            }else if(state==0){
                [HUDTool showText:@"未知错误"];
                return ;
            }
            
            
        } failure:^(NSError *error) {
            
            [HUDTool showText:@"验证码获取失败,请稍后再试"];
            return ;
            
        }];
        
        weakSelf.code.timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf.code selector:NSSelectorFromString(@"countTimer:") userInfo:@"倒计时" repeats:YES];
        
        [weakSelf.code.timer fire];
    };

    //是否查看
    _chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(x + 5, _code.bottom + 10, 20, 20)];
    [_chooseBtn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    _chooseBtn.selected = YES;
    [_chooseBtn setImage:[UIImage imageNamed:@"bankAgree_choose"] forState:UIControlStateSelected];
    [scrollView addSubview:_chooseBtn];
    
    //服务协议
    UILabel *serverLabel = [[UILabel alloc] init];
    serverLabel.frame = CGRectMake(x + 30 , _code.bottom + 5, 300, 30);
    serverLabel.textColor = kNavigationBarColor;
    serverLabel.font = [UIFont systemFontOfSize:15];
    serverLabel.text = @"我已阅读并同意《牛奶金服服务条款》";
    [scrollView addSubview:serverLabel];

    UIButton *serverBtn = [[UIButton alloc] initWithFrame:CGRectMake(x + 30 , _code.bottom + 10, 300, 30)];
    [serverBtn addTarget:self action:@selector(serverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:serverBtn];
    

    
    //注册
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, _code.bottom + 50 + 10, (WIDTH - 2 * x), 44)];
    loginBtn.tag = 101;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.backgroundColor = kNavigationBarColor;
    loginBtn.showsTouchWhenHighlighted = YES;
    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginBtn];
    
    
    //返回登录
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2.0 + 25, loginBtn.bottom, (WIDTH / 2.0 - x), 44)];
    registBtn.tag = 102;
    [registBtn setTitle:@"已有账号?登录" forState:UIControlStateNormal];
    //    registBtn.backgroundColor = [UIColor redColor];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [registBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:registBtn];
    
    scrollView.contentSize = CGSizeMake(WIDTH, registBtn.bottom + 300);
}

-(void)chooseBtn:(UIButton *)btn{

    btn.selected = !btn.selected;
    [btn setImage:[UIImage imageNamed:@"bankAgree_choose"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"bankAgree_unChoose"] forState:UIControlStateNormal];
    
    
}

-(void)serverBtnClick{
    LOG(@"服务协议");
    RiskAgreeViewController *agree = [[RiskAgreeViewController alloc] init];
    agree.title = @"服务协议";
    agree.textFileName = @"registAgree";
    [self.navigationController pushViewController:agree animated:YES];
}

-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 101) {
        //注册
        if([Util isEmpty: self.phoneNum.textF.text]){
            [HUDTool showText:@"请输入您的手机号"];
            return ;
        }
        
        if([Util validatePhoneNumber: self.phoneNum.textF.text] == NO){
            [HUDTool showText:@"您输入的手机号不合法"];
            return ;
        }
        
        if([Util isEmpty:self.nickName.textF.text]){
            [HUDTool showText:@"账号不能为空"];
            return ;
        }
        
        if([Util isEmpty:self.phoneNum.textF.text]){
            [HUDTool showText:@"手机号不能为空"];
            return ;
        }
        
        if(![Util validateUserName:self.nickName.textF.text]){
            [HUDTool showText:@"用户名为2-20位字母或数字，首位必须是字母"];
            return;
        }
        
        
        if([Util isEmpty:self.passWord.textF.text]){
            [HUDTool showText:@"密码不能为空"];
            return ;
        }
        
        if(![Util validateUserPassword:self.passWord.textF.text]){
            [HUDTool showText:@"密码长度为6~16"];
            return;
        }
        
        
        if([Util isEmpty:self.passWord2.textF.text]){
            [HUDTool showText:@"再次确认密码不能为空"];
            return ;
        }
        
        if (![self.passWord.textF.text isEqualToString:self.passWord2.textF.text]) {
            [HUDTool showText:@"两次密码不一致,请确认"];
            return ;
        }
        
        if([Util isEmpty:_code.textF.text]){
            [HUDTool showText:@"验证码不能为空"];
            return ;
        }
        
        //用户模块登录
        if (![_validateCode isEqualToString:_code.textF.text]) {
            [HUDTool showText:@"验证码不正确"];
            return ;
        }

        if (![_codePhone isEqualToString:self.phoneNum.textF.text]) {
            [HUDTool showText:@"请输入获取验证码的手机号"];
            return ;
        }

        if(_chooseBtn.selected != YES){
            [HUDTool showText:@"请认真阅读并同意服务条款"];
            return ;
        }
        //proType 当前平台 3 投了么
        NSDictionary *params = @{@"loginname":_nickName.textF.text,
                                 @"passwd":_passWord2.textF.text,
                                 @"phone":_phoneNum.textF.text};
        
        [HttpTool XLGet:TouGuRegister params:params success:^(id responseObj) {
            
            NSDictionary *dic = responseObj;
            
            NSInteger state = [[dic objectForKey:@"State"] integerValue];
            if(state==1){
               
                LOG(@"%@",dic);
                //注册成功
                [HUDTool showText:@"注册成功"];
                [NSUserDefaults setObject:_nickName.textF.text forKey:Account];
                [NSUserDefaults setObject:_phoneNum.textF.text forKey:mobilePhone];//注册绑定的手机号
                
                
                //代码去登录 -- proType 当前平台 3 投了么
                NSDictionary *params = @{@"loginname":_phoneNum.textF.text,
                                         @"passwd":_passWord2.textF.text,
                                         @"proType":@3};
                
                [HttpTool XLGet:GET_LOGIN params:params success:^(id responseObj) {
                    
                    NSDictionary *dic = responseObj;
                    
                    if([[dic objectForKey:@"State"] integerValue]==1){
                        
//                        [HUDTool showText:@"登录成功"];
                        
                        NSDictionary *userDic = [Util dictionaryWithJsonString:[dic objectForKey:@"Descr"]];
                        [NSUserDefaults setObject:_phoneNum.textF.text forKey:Account];//账号(用户名)
                        [NSUserDefaults setObject:userDic[@"nickname"] forKey:NickName];//昵称
                        [NSUserDefaults setObject:userDic[@"uid"] forKey:UserID];//USERID
                        //[NSUserDefaults setObject:userDic[@"avatar"] forKey:PhotoImgUrl];//头像[已废弃]
                        [Util setPhotoImgUrlWithHost:PhotoImgUrlWithHost];
                        [NSUserDefaults setBool:YES forKey:isLogin];
                        [NSUserDefaults setObject:self.phoneNum.textF.text forKey:mobilePhone];
                        //KH投了么~开户的账号
                        NSString *account = userDic[@"account"];
                        if (account == nil || [account isEqualToString:@""]) {
                            [NSUserDefaults setObject:@"" forKey:KHAccount];
                            [NSUserDefaults setBool:NO forKey:isOpenAccount];
                            [NSUserDefaults setBool:NO forKey:isBangDingAccount];
                            //如果未开户的情况下
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginWithNoAccount" object:nil];
                        }
                        if (self.returnBlock) {
                            self.returnBlock();
                        }
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
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
                    
                    [HUDTool showText:@"登录失败,请稍后再试"];
                    return ;            
                }];
                
            }else if(state==-1){
                [HUDTool showText:@"有为空的参数"];
                return ;
            }else if(state==-2){
                [HUDTool showText:@"登录名包含危险字符"];
                 return ;
            }else if(state==-3){
                [HUDTool showText:@"用户信息表入库失败"];
                 return ;
            }else if(state==-4){
                [HUDTool showText:@"用户登录表入库失败"];
                 return ;
            }else if(state==-5){
                [HUDTool showText:@"用户名已存在"];
                 return ;
            }else if(state==-6){
                [HUDTool showText:@"用户名不规范"];
                 return ;
            }else if(state==-7){
                [HUDTool showText:@"手机号不规范"];
                return ;
            }else if(state==-8){
                [HUDTool showText:@"手机号已存在"];
                return ;
            }else if(state==0){
                [HUDTool showText:@"未知错误"];
                 return ;
            }
    
        } failure:^(NSError *error) {
            
            [HUDTool showText:@"注册失败,请稍后再试"];
            return ;
            
        }];
        
    }
    if (btn.tag == 102) {
        //登录
        [self clickaddBtn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
