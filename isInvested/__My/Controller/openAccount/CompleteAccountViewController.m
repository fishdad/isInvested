//
//  CompleteAccountViewController.m
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CompleteAccountViewController.h"
#import "OpenAccountFlowView.h"
#import "ChooseImgView.h"
#import "MyPassWordTextField.h"
#import "NSDictionary+NullKeys.h"
#import "ChooseBankViewController.h"
#import "IQKeyboardManager.h"

@interface CompleteAccountViewController ()

{
    
    MyPassWordTextField *_JYPassWordTF1;//交易密码
    MyPassWordTextField *_JYPassWordTF2;
    
    MyPassWordTextField *_ZJPassWordTF1;//资金密码
    MyPassWordTextField *_ZJPassWordTF2;
    
    UILabel *_statusLabel1;//错误提示1
    UILabel *_statusLabel2;//错误提示2
    
}
@end

@implementation CompleteAccountViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;//键盘工具条 -- [完成]按钮的使用
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;//键盘工具条 -- [完成]按钮的使用
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"广贵开户中心";
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat Y;
    if (self.navigationController.navigationBar.translucent) {
        Y = 64;
    }else{
        Y = 0;
    }
    CGFloat height = 120;
    if (WIDTH == 320) {
        height = 90;
    }
    
    UIScrollView* scrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - Y)];
    [self.view addSubview:scrollView];
    
    OpenAccountFlowView *openFlow = [[OpenAccountFlowView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, height) SelectIndex:1];
    [scrollView addSubview:openFlow];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(5, openFlow.bottom, WIDTH, 40);
//    label.text = @"设置交易密码(用于交易登录)";
    label.attributedText = [Util setFirstString:@"设置交易密码" secondString:@"(用于交易登录)" firsColor:[UIColor blackColor] secondColor:[UIColor grayColor]];
    [scrollView addSubview:label];
    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, label.bottom, WIDTH, 0.5)]];
    
    CGFloat H = 45;
    
    _JYPassWordTF1 = [[MyPassWordTextField alloc] initWithFrame:CGRectMake(5, label.bottom, WIDTH - 10, H)];
    _JYPassWordTF1.placeholder = @"必须为数字+英文字母组合,8-10位";
    [scrollView addSubview:_JYPassWordTF1];
    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(5, _JYPassWordTF1.bottom, WIDTH - 10, 0.5)]];
    
    _JYPassWordTF2 = [[MyPassWordTextField alloc] initWithFrame:CGRectMake(5, _JYPassWordTF1.bottom, WIDTH - 10, H)];
    _JYPassWordTF2.placeholder = @"请再次输入密码";
    [scrollView addSubview:_JYPassWordTF2];
    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, _JYPassWordTF2.bottom, WIDTH, 0.5)]];
    
    //红色错误提示1
    _statusLabel1 = [[UILabel alloc] init];
    _statusLabel1.frame = CGRectMake(0, _JYPassWordTF2.bottom , WIDTH, 30);
    _statusLabel1.font =[UIFont boldSystemFontOfSize:15];
    _statusLabel1.textColor = [UIColor redColor];
    [scrollView addSubview:_statusLabel1];

    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(5, _JYPassWordTF2.bottom + 30, WIDTH, 40);
//    label1.text = @"设置资金密码(用于转账)";
    label1.attributedText = [Util setFirstString:@"设置资金密码" secondString:@"(用于转账)" firsColor:[UIColor blackColor] secondColor:[UIColor grayColor]];
    [scrollView addSubview:label1];

    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, label1.bottom, WIDTH, 0.5)]];
    
    _ZJPassWordTF1 = [[MyPassWordTextField alloc] initWithFrame:CGRectMake(5, label1.bottom, WIDTH - 10, H)];
    _ZJPassWordTF1.textF.keyboardType = UIKeyboardTypeNumberPad;
    _ZJPassWordTF1.placeholder = @"资金密码必须为6位数字";
    [scrollView addSubview:_ZJPassWordTF1];
    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(5, _ZJPassWordTF1.bottom, WIDTH - 10, 0.5)]];
    
    _ZJPassWordTF2 = [[MyPassWordTextField alloc] initWithFrame:CGRectMake(5, _ZJPassWordTF1.bottom, WIDTH - 10, H)];
    _ZJPassWordTF2.textF.keyboardType = UIKeyboardTypeNumberPad;
    _ZJPassWordTF2.placeholder = @"请再次输入密码";
    [scrollView addSubview:_ZJPassWordTF2];
    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, _ZJPassWordTF2.bottom, WIDTH, 0.5)]];
    
    //红色错误提示2
    _statusLabel2 = [[UILabel alloc] init];
    _statusLabel2.frame = CGRectMake(0, _ZJPassWordTF2.bottom , WIDTH, 30);
    _statusLabel2.font =[UIFont boldSystemFontOfSize:15];
    _statusLabel2.textColor = [UIColor redColor];
    [scrollView addSubview:_statusLabel2];
    
    
    CGFloat x = 15;
    //下一步
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, _ZJPassWordTF2.bottom + 30, (WIDTH - 2 * x), 44)];
    loginBtn.tag = 101;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 3;
    loginBtn.backgroundColor = kNavigationBarColor;
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginBtn];

    scrollView.contentSize = CGSizeMake(WIDTH, loginBtn.bottom + 300);

}

-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 101) {
        //下一步
        //未开户,验证输入,开户,绑定
        if([Util isEmpty:_JYPassWordTF1.text]){
            _statusLabel1.text = @"交易密码不能为空";
            [_JYPassWordTF1 becomeFirstResponder];
            return ;
        }
        
        if(![Util validateKHPassword:_JYPassWordTF1.text]){
            _statusLabel1.text = @"交易密码必须为数字+英文字母,8-10位";
            [_JYPassWordTF1 becomeFirstResponder];
            return;
        }
        
        if([Util isEmpty:_JYPassWordTF2.text]){
            _statusLabel1.text = @"请再次输入交易密码";
            [_JYPassWordTF2 becomeFirstResponder];
            return ;
        }
        
        
        if (![_JYPassWordTF1.text isEqualToString:_JYPassWordTF2.text]) {
            _statusLabel1.text = @"两次交易密码不一致";
            [_JYPassWordTF2 becomeFirstResponder];
            return;
        }
        
        _statusLabel1.text = @"";
        
        if([Util isEmpty:_ZJPassWordTF1.text]){
            _statusLabel2.text = @"资金密码不能为空";
            [_ZJPassWordTF1 becomeFirstResponder];
            return ;
        }
        
        if(![Util validateTheZipCode:_ZJPassWordTF1.text]){
            _statusLabel2.text = @"资金密码必须为6位数字";
            [_ZJPassWordTF1 becomeFirstResponder];
            return;
        }
        
        if([Util isEmpty:_ZJPassWordTF2.text]){
            _statusLabel2.text = @"请再次输入资金密码";
            [_ZJPassWordTF2 becomeFirstResponder];
            return ;
        }
        
        
        if (![_ZJPassWordTF1.text isEqualToString:_ZJPassWordTF2.text]) {
            _statusLabel2.text = @"两次资金密码不一致";
            [_ZJPassWordTF2 becomeFirstResponder];
            return;
        }
        
        _statusLabel2.text = @"";
        
        //提交开户
        [self OpenAccount];
    }
}

//OpenAccountSimple 提交简化开户
-(void)OpenAccount{
    
    /*
     方法名:		OpenAccountSimple
     说明:		简化提交开户
     参数:
     userName(用户姓名)
     loginAccount(登录帐号)
     mobilePhone(手机号)
     certType(证件类型)
     certNo(证件号) 
     email(电子邮箱) 
     signProto(是否签署风险揭示1-是 0-否)
     loginPassword(登录密码) 
     tranPassword(资金密码) 
     clientIP(开户ip)
    */
    
    //获取IP地址
    NSString *IPV4Str =  [Util getIPV4String];
    if (IPV4Str == nil || [IPV4Str isEqualToString:@""]) {
        [HUDTool showText:@"请确认连接的网络"];
        return ;
    }
    
    NSDictionary *params = @{@"method":@"OpenAccountSimple",
                             @"userName":[NSUserDefaults objectForKey:IDCardName],
                             @"loginAccount":[NSUserDefaults objectForKey:KHAccount],
                             @"mobilePhone":[NSUserDefaults objectForKey:mobilePhone],
                             @"certType":@"1",
                             @"certNo":[NSUserDefaults objectForKey:certNo],
                             @"email":[NSUserDefaults objectForKey:KHEmail],
                             @"signProto":@"1",
                             @"loginPassword":_JYPassWordTF2.text,
                             @"tranPassword":_ZJPassWordTF2.text,
                             @"clientIP":IPV4Str};
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        NSDictionary *resultDic = responseObject;
        
        if ([[resultDic handleNullObjectForKey:@"errCode"] isEqual: @"99999"]){
            //保存开户账号和开户状态 -- 只要开户成功就绑定实盘,至于查询开户的状态没有影响
            [NSUserDefaults setBool:YES forKey:isOpenAccount];
             [self toulemeOpenAccount];
        }else{
            
            NSString *errMsg = [resultDic handleNullObjectForKey:@"errMsg"];
            if ([errMsg isEqualToString:@"NullKey"]) {
                errMsg = @"通信异常";
            }
            NSString *msg = [NSString stringWithFormat:@"开户失败 -- %@",errMsg];
            
            if ([[resultDic handleNullObjectForKey:@"errCode"] isEqual: @"88888"])
            {
                msg = @"交易所系统维护中,请稍后再试";
            }
            [Util showHUDAddTo:self.view Text:msg];
            return ;

        }
    } failure:^(NSError *error) {
        
        [Util showHUDAddTo:self.view Text:@"开户失败"];
        return ;
    }];
    
}
//(处理只开户未签约的情况)
//交易账号绑定到金融家
-(void)toulemeOpenAccount{
    
    //参数说明:
    /// <param name="userId">用户ID</param>
    /// <param name="phone">手机号码</param>
    /// <param name="accCode">实盘账号</param>
    /// <param name="accTrueName">真实姓名</param>
    /// <param name="accIdCard">身份证号</param>
    /// <param name="email">邮箱</param>
    //已经开户的不再绑定
    if ([NSUserDefaults boolForKey:isBangDingAccount] == YES) {
        //已经绑定实盘账号 -- 此处在判断签约
        return;
    }else{
        
        //未绑定实盘账号
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
                [NSUserDefaults setBool:YES forKey:isBangDingAccount];
                [self pushNext];
                
            }else{
                //失败
                [HUDTool showText:@"数据绑定失败,请重试"];
                return ;
            }
            
        } failure:^(NSError *error) {
            
            [HUDTool showText:@"数据绑定失败,请重试"];
            return ;
        }];
    }
}

-(void)pushNext{

    ChooseBankViewController *vc = [[ChooseBankViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
