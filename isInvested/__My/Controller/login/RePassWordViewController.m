//
//  RePassWordViewController.m
//  isInvested
//
//  Created by Ben on 16/8/16.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "RePassWordViewController.h"

@implementation RePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"重置密码";
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    [self initMyView];
}

-(void)initMyView{
    //密码
    CGFloat x = 25;
    _passWord = [[MyTextView alloc] initWithFrame:CGRectMake(x, 20 + 64, (WIDTH - 2 * x), 44)];
    [self.view addSubview:_passWord];
//    _passWord.img.image = [UIImage imageNamed:@"lock_normal"];
    _passWord.lbl.text = @"密码";
    _passWord.placeholder = @"6-16位字母、数字、特殊符号";
    _passWord.textF.secureTextEntry = YES;
    _passWord.textF.textColor = [UIColor blackColor];
    _passWord.backColor = [UIColor whiteColor];
    
    //确认密码
    _passWord2 = [[MyTextView alloc] initWithFrame:CGRectMake(x, _passWord.bottom + 10, (WIDTH - 2 * x), 44)];
    [self.view addSubview:_passWord2];
    _passWord2.backColor = [UIColor whiteColor];
    _passWord2.textF.textColor = [UIColor blackColor];
    _passWord2.textF.secureTextEntry = YES;
//    _passWord2.img.image = [UIImage imageNamed:@"lock_normal"];
    _passWord2.lbl.text = @"确认密码";
    _passWord2.placeholder = @"请再次输入密码";

    
    _passWord.textF.width = (WIDTH - 3 * x);
    _passWord2.textF.width = (WIDTH - 3 * x);
    
    //确定
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, _passWord2.bottom + 20, (WIDTH - 2 * x), 44)];
    loginBtn.tag = 101;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.backgroundColor = kNavigationBarColor;
    [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
}

-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 101) {
        //下一步
        if([Util isEmpty:_passWord.textF.text]){
            [HUDTool showText:@"密码不能为空"];
            return ;
        }
        
        if(![Util validateUserPassword:_passWord.textF.text]){
            [HUDTool showText:@"密码长度为6~16"];
            return;
        }
        
        
        if([Util isEmpty:_passWord2.textF.text]){
            [HUDTool showText:@"再次确认密码不能为空"];
            return ;
        }
        
        if (![_passWord.textF.text isEqualToString:_passWord2.textF.text]) {
            [HUDTool showText:@"两次密码不一致,请确认"];
            return ;
        }
        
        NSDictionary *params = @{@"mobile":_phoneNum,
                                 @"vcode":_vCode,
                                 @"newpasswd":_passWord2.textF.text};
        [HttpTool XLGet:GET_RESETPASSWORD params:params success:^(id responseObj) {
            
            
            NSDictionary *dic = responseObj;
            NSInteger state = [[dic objectForKey:@"State"] integerValue];
            
            if(state==1){
                
                [HUDTool showText:@"密码重置成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else if(state==-1){
                [HUDTool showText:@"有为空的参数"];
                return ;
            }else if(state==-2){
                [HUDTool showText:@"参数不合法"];
                return ;
            }else if(state==-3){
                [HUDTool showText:@"手机验证码不正确"];
                return ;
            }else if(state==-4){
                [HUDTool showText:@"根据手机号查询不到数据"];
                return ;
            }else if(state==0){
                [HUDTool showText:@"未知错误"];
                return ;
            }
            
        } failure:^(NSError *error) {
            [HUDTool showText:@"密码重置失败,请稍后再试"];
            return ;
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
