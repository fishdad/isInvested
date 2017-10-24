//
//  ChangePassWordViewcontroller.m
//  isInvested
//
//  Created by Ben on 16/8/17.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ChangePassWordViewcontroller.h"
#import "NSDictionary+NullKeys.h"

@implementation ChangePassWordViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor= OXColor(0xffffff);
    
    [self initMyView];
    
    if (_vcType == 0) {
        
        self.title=@"修改交易密码";
        _oldPassWord.placeholder = @"请输入当前交易密码";
        _passWord.placeholder = @"新密码(必须为数字+英文字母,8-10位)";
    }else{
        
        self.title=@"修改资金密码";
        _oldPassWord.placeholder = @"请输入当前资金密码";
        _passWord.placeholder = @"新密码(必须为6位数字)";
        _oldPassWord.textF.keyboardType = UIKeyboardTypeNumberPad;
        _passWord.textF.keyboardType = UIKeyboardTypeNumberPad;
        _passWord2.textF.keyboardType = UIKeyboardTypeNumberPad;
    }

}

-(void)initMyView{
    
    //原密码
    CGFloat x = 25;
    _oldPassWord = [[MyTextView alloc] initWithFrame:CGRectMake(x, 64 + 20, (WIDTH - 2 * x), 44)];
    [self.view addSubview:_oldPassWord];
    _oldPassWord.textF.secureTextEntry = YES;
    _oldPassWord.backColor = [UIColor whiteColor];
    _oldPassWord.isHaveImg = NO;
    _oldPassWord.textF.textColor = [UIColor blackColor];
//    _oldPassWord.img.image = [UIImage imageNamed:@"collectionSelect"];
    
    //密码
    _passWord = [[MyTextView alloc] initWithFrame:CGRectMake(x, _oldPassWord.bottom + 10, (WIDTH - 2 * x), 44)];
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
    
    
    _oldPassWord.textF.width = (WIDTH - 3 * x);
    _passWord.textF.width = (WIDTH - 3 * x);
    _passWord2.textF.width = (WIDTH - 3 * x);
    
    
    //操作提示
    _serverLabel = [[UILabel alloc] init];
    _serverLabel.frame = CGRectMake(x + 10 , _passWord2.bottom + 15, 300, 30);
    _serverLabel.textColor = [UIColor redColor];
    _serverLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_serverLabel];
    

    //确认修改
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
        //注册
        
        if([Util isEmpty:_oldPassWord.textF.text]){
            //            [HUDTool showText:@"密码不能为空"];
            _serverLabel.text = @"请输入原密码";
            return ;
        }

        
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
            
            [[DealSocketTool shareInstance] changePassWordOldPwd:_oldPassWord.textF.text NewPWD:_passWord2.textF.text WithBlock:^(unsigned short isSuccess, NSString *statusStr) {
                
                if (isSuccess == 1) {
                    //修改交易密码
                    NSString *rightPassWord = _passWord2.textF.text;
                    [NSUserDefaults setObject:rightPassWord forKey:KHLoginPassWord];//开户的登录密码
                    NSString *key = [Util DealSHReplacePassWord];
                    [NSUserDefaults setObject:rightPassWord forKey:key];
                    [DealSocketTool shareInstance].LoginPassWordStr = rightPassWord;
                    NSString *newPassWord = [NSUserDefaults objectForKey:key];
                    LOG(@"~~~~~~~~%@   --   %@",newPassWord,rightPassWord);
                    if (![newPassWord isEqualToString:rightPassWord]) {
                        [NSUserDefaults setObject:rightPassWord forKey:key];
                    }
                    LOG(@"~~~~~~~~%@   --   %@",newPassWord,rightPassWord);
                    if (statusStr == nil) {
                        statusStr = @"修改成功";
                    }
                    [HUDTool showText:statusStr];
                    [self ResetPwdByPwdType:@"1"];
                }else{
                    
                    [HUDTool showText:statusStr];
                }
            }];
           
        }else{
            
            [[DealSocketTool shareInstance] changeFundPassWordOldPwd:_oldPassWord.textF.text NewPWD:_passWord2.textF.text WithBlock:^(unsigned short isSuccess, NSString *statusStr) {
                
                if (isSuccess == 1) {
                    
                    if (statusStr == nil) {
                        statusStr = @"修改成功";
                    }
                    [HUDTool showText:statusStr];
                    //修改资金密码
                    [self ResetPwdByPwdType:@"2"];
                }else{
                    [HUDTool showText:statusStr];
                }
            }];
        }
    }
}

//重新设置密码
-(void)ResetPwdByPwdType:(NSString *) pwdType{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
