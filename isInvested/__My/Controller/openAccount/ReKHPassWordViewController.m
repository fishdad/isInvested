//
//  ReKHPassWordViewController.m
//  isInvested
//
//  Created by Ben on 16/8/17.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ReKHPassWordViewController.h"
#import "NSDictionary+NullKeys.h"

@implementation ReKHPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor= OXColor(0xffffff);
    
    [self initMyView];
    
    if (_vcType == 0) {
        
        self.title=@"重置交易密码";
         _passWord.placeholder = @"新密码(必须为数字+英文字母,8-10位)";
    }else{
        
        self.title=@"重置资金密码";
         _passWord.placeholder = @"新密码(必须为6位数字)";
        _passWord.textF.keyboardType = UIKeyboardTypeNumberPad;
        _passWord2.textF.keyboardType = UIKeyboardTypeNumberPad;
    }
    
}

-(void)initMyView{
    
    //新密码
    CGFloat x = 25;
    _passWord = [[MyTextView alloc] initWithFrame:CGRectMake(x, 64 + 20, (WIDTH - 2 * x), 44)];
    [self.view addSubview:_passWord];
    //_passWord.img.image = [UIImage imageNamed:@"collectionSelect"];
    _passWord.backColor = [UIColor whiteColor];
    _passWord.isHaveImg = NO;
    _passWord.textF.secureTextEntry = YES;
    _passWord.textF.textColor = [UIColor blackColor];
    
    //确认密码
    _passWord2 = [[MyTextView alloc] initWithFrame:CGRectMake(x, _passWord.bottom + 10, (WIDTH - 2 * x), 44)];
    [self.view addSubview:_passWord2];
    //_passWord2.img.image = [UIImage imageNamed:@"collectionSelect"];
    _passWord2.backColor = [UIColor whiteColor];
    _passWord2.isHaveImg = NO;
    _passWord2.textF.secureTextEntry = YES;
    _passWord2.placeholder = @"请再次输入密码";
    _passWord2.textF.textColor = [UIColor blackColor];
    
    //操作提示
    _serverLabel = [[UILabel alloc] init];
    _serverLabel.frame = CGRectMake(x + 10 , _passWord2.bottom + 15, 300, 30);
    _serverLabel.textColor = [UIColor redColor];
    _serverLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_serverLabel];
    
    _passWord.textF.width = (WIDTH - 3 * x);
    _passWord2.textF.width = (WIDTH - 3 * x);
    
    //注册
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, _passWord2.bottom + 50, (WIDTH - 2 * x), 44)];
    loginBtn.tag = 101;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.backgroundColor = kNavigationBarColor;
    [loginBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
}


-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 101) {
        
        
        if([Util isEmpty:_passWord.textF.text]){
            //            [HUDTool showText:@"密码不能为空"];
            _serverLabel.text = @"密码不能为空";
            return ;
        }
        
        if (_vcType == 0) {
            //交易
            if(![Util validateKHPassword:_passWord.textF.text]){
                //[HUDTool showText:@"密码必须为数字+英文字母,8-10位"];
                _serverLabel.text = @"密码必须为数字+英文字母,8-10位";
                return;
            }

        }else{
            //资金
            if(![Util validateTheZipCode:_passWord.textF.text]){
                //[HUDTool showText:@"密码必须为数字+英文字母,8-10位"];
                _serverLabel.text = @"密码必须为6位数字";
                return;
            }

        }

        if([Util isEmpty:_passWord2.textF.text]){
            //[HUDTool showText:@"再次确认密码不能为空"];
            _serverLabel.text = @"再次确认密码不能为空";
            return ;
        }
        
        if (![_passWord.textF.text isEqualToString:_passWord2.textF.text]) {
            //[HUDTool showText:@"两次密码不一致,请确认"];
            _serverLabel.text = @"两次密码不一致,请确认";
            return ;
        }
        
        _serverLabel.text = @"";
        
        if (_vcType == 0) {
            //重置交易密码
            [self ResetPwdByPwdType:@"0"];
        }else if (_vcType == 1){
            //重置资金密码
            [self ResetPwdByPwdType:@"2"];
        }
    }
}

-(void)changeDealPassWordBypwdType:(NSString *) pwdType password:(NSString *) password{
    
    //    方法名:		ResetPwd
    //    说明:		密码重置
    //    参数:  		loginAccount(登录帐号)
    //    pwdType(0-登录密码 2-资金密码)
    //    password(登录密码)
    
    NSString *openAccountStr = [NSUserDefaults objectForKey:KHAccount];
    if (openAccountStr == nil || [openAccountStr isEqualToString:@""]) {
        [HUDTool showText:@"请首先登录/开户"];
        return;
    }
    NSDictionary *params = @{@"method":@"ResetPwd",
                             @"loginAccount":openAccountStr,
                             @"pwdType":pwdType,
                             @"password":password};
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        LOG(@"NormalInfoViewController%@",responseObject);
        
        NSDictionary *resultDic = responseObject;
        
        if ([[resultDic handleNullObjectForKey:@"errCode"] isEqual: @"99999"]) {
            
            //修改密码成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReSetPassWordSuccess" object:nil];
            if ([pwdType isEqualToString:@"0"]) {
                [DealSocketTool shareInstance].LoginPassWordStr = password;
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            [HUDTool showText:@"修改密码失败"];
            return ;
        }
        
    } failure:^(NSError *error) {
        
        [HUDTool showText:@"当前网络环境异常"];
        return ;
        
    }];
    
}


//重新设置密码
-(void)ResetPwdByPwdType:(NSString *) pwdType{

    [self changeDealPassWordBypwdType:pwdType password:_passWord2.textF.text];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
