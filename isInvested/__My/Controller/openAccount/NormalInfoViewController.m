//
//  NormalInfoViewController.m
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NormalInfoViewController.h"
#import "OpenAccountFlowView.h"
#import "ChooseImgView.h"
#import "GDataXMLNode.h"
#import "AppDelegate.h"
#import "NSDictionary+NullKeys.h"
#import "CompleteAccountViewController.h"
#import "IQKeyboardManager.h"

@interface NormalInfoViewController ()

{

    UITextField *nameTF;
    UITextField *codeTF;
    UITextField *emailTF;
    
    ChooseImgView *imgView1;
    ChooseImgView *imgView2;
}

@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation NormalInfoViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    UIBarButtonItem *left =  [UIBarButtonItem itemWithTarget:self action:@selector(clickedBack) image:@"back"];
    self.navigationItem.leftBarButtonItem = left;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedBack) name:@"complantOpenAccount" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat Y;
    if (self.navigationController.navigationBar.translucent) {
        Y = 64;
    }else{
        Y = 0;
    }
    UIScrollView* scrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    [self.view addSubview:scrollView];
    
    CGFloat height = 120;
    if (WIDTH == 320) {
        height = 90;
    }
    OpenAccountFlowView *openFlow = [[OpenAccountFlowView alloc] initWithFrame:CGRectMake(0, Y, WIDTH, height) SelectIndex:0];
    [scrollView addSubview:openFlow];
    
    ;
    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, openFlow.bottom, WIDTH, 0.5)]];
    
    CGFloat H = 45;
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(5, openFlow.bottom, WIDTH - 10, H)];
    nameTF.placeholder = @"请输入真实姓名";
    [scrollView addSubview:nameTF];
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(5, nameTF.bottom, WIDTH - 10, 0.5)]];
    
    codeTF = [[UITextField alloc] initWithFrame:CGRectMake(5, nameTF.bottom, WIDTH - 10, H)];
    codeTF.placeholder = @"请输入身份证号";
    [scrollView addSubview:codeTF];
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, codeTF.bottom, WIDTH, 0.5)]];
    
    emailTF = [[UITextField alloc] initWithFrame:CGRectMake(5, codeTF.bottom, WIDTH - 10, H)];
    emailTF.placeholder = @"请输入电子邮箱";
    [scrollView addSubview:emailTF];
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, emailTF.bottom, WIDTH, 0.5)]];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, emailTF.bottom ,WIDTH, 50);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor lightGrayColor];
    label.backgroundColor = OXColor(0xf5f5f5);
    label.text = @" 邮箱用于接收交易账号和密码,请认真填写";
    label.font = FONT(13);
    [scrollView addSubview:label];
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, label.bottom, WIDTH, 0.5)]];

    CGFloat x = 15;
    CGFloat space = 20;
    CGFloat imgW = (WIDTH - x * 2 - space) / 2;
    if (WIDTH == 320) {
        space = 60;
        imgW = (WIDTH - x * 2 - space) / 2;
    }
    imgView1 = [[ChooseImgView alloc] initWithFrame:CGRectMake(x, label.bottom + 20, imgW, imgW) WithTarget:self Title:@"身份证正面"];
    [scrollView addSubview:imgView1];
    
    imgView2 = [[ChooseImgView alloc] initWithFrame:CGRectMake(x + imgView1.width + space, label.bottom + 20, imgW, imgW) WithTarget:self Title:@"身份证反面"];
    [scrollView addSubview:imgView2];
    
    UILabel *photoLabel = [[UILabel alloc] init];
    photoLabel.frame = CGRectMake(0, imgView2.bottom ,WIDTH, 20);
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.textColor = [UIColor lightGrayColor];
    photoLabel.text = @"点击上传您的身份证照片";
    [scrollView addSubview:photoLabel];

    //简化开户
    imgView1.hidden = YES;
    imgView2.hidden = YES;
    photoLabel.hidden = YES;
    
    //下一步
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, photoLabel.bottom + 10, (WIDTH - 2 * x), 44)];
    _loginBtn.tag = 101;
    _loginBtn.showsTouchWhenHighlighted = YES;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 3;
    _loginBtn.backgroundColor = kNavigationBarColor;
    [_loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_loginBtn];
    
    scrollView.contentSize = CGSizeMake(WIDTH, _loginBtn.bottom + 300);
}
-(void)clickedBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 101) {
        //下一步
        if([Util isEmpty:nameTF.text]){
            [HUDTool showText:@"真实姓名不能为空"];
            [nameTF becomeFirstResponder];
            return ;
        }
        
        if([Util isEmpty:codeTF.text]){
            [HUDTool showText:@"身份证号码不能为空"];
            [codeTF becomeFirstResponder];
            return ;
        }
        
        if([Util isEmpty:emailTF.text]){
            [HUDTool showText:@"邮箱不能为空"];
            [emailTF becomeFirstResponder];
            return ;
        }
        
        if(![Util validateEmail:emailTF.text]){
            [HUDTool showText:@"邮箱不正确"];
            [emailTF becomeFirstResponder];
            return ;
        }
        btn.enabled = NO;
        //身份验证
        [self validate_identity];
    }
}

//0.新浪支付的身份验证
-(void)validate_identity{
    
    //    realName--真实姓名
    //    certno--证件号码
    NSDictionary *params = @{@"realname":nameTF.text,
                             @"certno":codeTF.text};

    [GGHttpTool post:[Util getSinaBangdingUrlBytype:validate_identity] params:params success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"response_code"] isEqualToString:@"VALIDATE_TRUE"]) {
            
            [self CertNoAccExistCheck];
        }else{
            [Util showHUDAddTo:self.view Text:dic[@"response_message"]];
            _loginBtn.enabled = YES;
            return ;
        }
    } failure:^(NSError *error) {
        
        _loginBtn.enabled = YES;
        [HUDTool showText:kRequestTimeout];
        LOG(@"%@",error);
        
    }];
}

//1.检查证件
-(void)CertNoAccExistCheck{

    NSDictionary *params = @{@"method":@"CertNoAccExistCheck",
                             @"certType":@"1",
                             @"certNo":codeTF.text};
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        LOG(@"NormalInfoViewController%@",responseObject);
        
        NSDictionary *resultDic = responseObject;
        
        if ([[resultDic handleNullObjectForKey:@"errCode"] isEqual: @"99999"]) {
            
            if ([[resultDic handleNullObjectForKey:@"result"]  isEqual: @"0"]) {
                
                //2.检查风险测评
                [self CheckRisk];
            }
            else{
                [Util showHUDAddTo:self.view Text:@"当前证件已开户"];
                _loginBtn.enabled = YES;
                return ;
            }
        }else{
            
            [Util showHUDAddTo:self.view Text:@"身份证信息有错误,请核查"];
            _loginBtn.enabled = YES;
            return ;
        }
        
    } failure:^(NSError *error) {
        
        LOG(@"NormalInfoViewController%@",error);
        [HUDTool showText:kRequestTimeout];
        _loginBtn.enabled = YES;
        return ;
        
    }];
    
}
//2.检查风险测评
-(void)CheckRisk{
    
    NSDictionary *params = @{@"method":@"CheckRisk",
                             @"userName":nameTF.text,
                             @"certType":@"1",
                             @"certNo":codeTF.text};
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        if ([[responseObject handleNullObjectForKey:@"errCode"] isEqual: @"99999"]) {
            
            NSString *result = [responseObject handleNullObjectForKey:@"result"];
            
            if ([result isEqualToString:@"1"]) {
                
                //3.生成登录账号
                [self GenerateLoginAccount];
            }else{
                [Util showHUDAddTo:self.view Text:@"有90天内风险测评不通过记录"];
                _loginBtn.enabled = YES;
                return ;
            }
            
        }else{
            [Util showHUDAddTo:self.view Text:@"检查风险测评失败"];
            _loginBtn.enabled = YES;
            return ;
        }
        
    } failure:^(NSError *error) {
        
        [HUDTool showText:kRequestTimeout];
        _loginBtn.enabled = YES;
        return ;
    }];
}
//3.生成登录账号
-(void)GenerateLoginAccount{

    NSDictionary *params = @{@"method":@"GenerateLoginAccount",
                             @"userName":nameTF.text};
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        NSString *KHAccountStr = [responseObject handleNullObjectForKey:@"result"];
        
        if (KHAccountStr != nil) {
            
            //3.检查登录账号
            [self CheckLoginAccountByAccount:KHAccountStr];
        }else{
            [Util showHUDAddTo:self.view Text:@"生成登录账号失败,请再次点击下一步"];
        }
    } failure:^(NSError *error) {
        
        [HUDTool showText:kRequestTimeout];
        _loginBtn.enabled = YES;
        return ;
        
    }];

}
//4.检查登录账号
-(void)CheckLoginAccountByAccount:(NSString *)KHAccountStr{
    
    NSDictionary *params = @{@"method":@"CheckLoginAccount",
                             @"loginAccount":KHAccountStr};
    
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        if ([[responseObject handleNullObjectForKey:@"errCode"] isEqual: @"99999"]) {
            
            NSString *result = [responseObject handleNullObjectForKey:@"result"];
            
            if ([result isEqualToString:@"0"]) {
                
                //保存开户账号(保存有效的证件信息)
                [NSUserDefaults setObject:nameTF.text forKey:IDCardName];//身份证姓名
                [NSUserDefaults setObject:codeTF.text forKey:certNo];//(证件号)
                [NSUserDefaults setObject:emailTF.text forKey:KHEmail];//邮箱
                [NSUserDefaults setObject:KHAccountStr forKey:KHAccount];
                //简化开户,去设置密码
                _loginBtn.enabled = YES;
                [self pushNextVC];
                
            }else if(([result isEqualToString:@"1"])){
//                [Util showHUDAddTo:self.view Text:@"默认生成的登录账号已存在"];
                [self GenerateLoginAccount];//重新生成新的交易账号
                return ;
            }
            
        }else{
            [Util showHUDAddTo:self.view Text:@"检查登陆账号失败"];
            _loginBtn.enabled = YES;
            return ;
        }
        
    } failure:^(NSError *error) {
        
        [HUDTool showText:kRequestTimeout];
        _loginBtn.enabled = YES;
        return ;
    }];

}
//进入密码设置
-(void)pushNextVC{
    
    CompleteAccountViewController *vc = [[CompleteAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
