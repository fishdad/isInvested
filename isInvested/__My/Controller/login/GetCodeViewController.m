//
//  GetCodeViewController.m
//  isInvested
//
//  Created by Ben on 16/8/16.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "GetCodeViewController.h"
#import "RePassWordViewController.h"
#import "ReKHPassWordViewController.h"

@implementation GetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"获取验证码";
    self.view.backgroundColor = OXColor(0xffffff);
    
    [self initMyView];
    
    if (_vcType == 0) {
        self.title=@"重置交易密码";
    }else if (_vcType == 1){
    
        self.title=@"重置资金密码";
    }
    if (_vcType ==0 || _vcType == 1) {
        _phoneNum.backColor = [UIColor whiteColor];
//        _phoneNum.isHaveImg = NO;
//        _phoneNum.img.image = nil;
        _phoneNum.textF.textColor = [UIColor blackColor];
        
        _code.backColor = [UIColor whiteColor];
//        _code.isHaveImg = NO;
//        _code.img.image = nil;
        _code.textF.textColor = [UIColor blackColor];
    }
}

-(void)initMyView{
    //手机号
    CGFloat x = 25;
    _phoneNum = [[MyTextView alloc] initWithFrame:CGRectMake(x, 20 + 64, (WIDTH - 2 * x), 44)];
    [self.view addSubview:_phoneNum];
//    _phoneNum.img.image = [UIImage imageNamed:@"phone_normal"];
    _phoneNum.lbl.text = @"手机号";
    _phoneNum.placeholder = @"请输入手机号";
    _phoneNum.textF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNum.textF.textColor = [UIColor blackColor];
    _phoneNum.backColor = [UIColor whiteColor];
    
    //自动获取存放的手机号码
    
    
    
    NSString *phone = [NSUserDefaults objectForKey:mobilePhone];
    if (phone != nil && ![phone isEqualToString:@""]) {
        _phoneNum.textF.text = phone;
        _phoneNum.textF.userInteractionEnabled = NO;
    }
    //获取验证码
    _code = [[MyTextView alloc] initWithFrame:CGRectMake(x, _phoneNum.bottom + 10, (WIDTH - 2 * x), 44)];
    [self.view addSubview:_code];
    _code.backColor = [UIColor whiteColor];
    _code.textF.textColor = [UIColor blackColor];
    _code.textF.keyboardType = UIKeyboardTypeNumberPad;
//    _code.img.image = [UIImage imageNamed:@"code_normal"];
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
       
        [weakSelf.phoneNum.textF becomeFirstResponder];
        
        //sendSource 1.注册 2.修改密码 3.修改资金密码 4.修改交易密码
        NSString *sendSource = @"2";
        if (_vcType == 0) {
            sendSource = @"4";//"重置交易密码";
        }else if (_vcType == 1){
            sendSource = @"3";//"重置资金密码";
        }
        [HttpTool XLGet:GET_VALIDATECODE params:@{@"mobile":weakSelf.phoneNum.textF.text,
                                            @"sendSource":sendSource
                                                  } success:^(id responseObj) {
            
            NSDictionary *dic = responseObj;
            
            NSInteger state = [[dic objectForKey:@"State"] integerValue];
            
            if(state==1){
                
               _validateCode = [dic objectForKey:@"Descr"];
                
                weakSelf.code.timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf.code selector:NSSelectorFromString(@"countTimer:") userInfo:@"倒计时" repeats:YES];
                
                [weakSelf.code.timer fire];
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
        
    };

    
    //下一步
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, _code.bottom + 40, (WIDTH - 2 * x), 44)];
    loginBtn.tag = 101;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.backgroundColor = kNavigationBarColor;
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
}

-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 101) {
        //下一步
        if([Util isEmpty:_phoneNum.textF.text]){
            [HUDTool showText:@"手机号不能为空"];
            return ;
        }

        if([Util isEmpty:_code.textF.text]){
            [HUDTool showText:@"验证码不能为空"];
            return ;
        }

        if (_vcType == 0 || _vcType == 1) {
            
//#warning ceshi 暂不验证验证码 xinle
            //交易模块
            if (![_validateCode isEqualToString:_code.textF.text]) {
                [HUDTool showText:@"验证码不正确"];
                return ;
            }
            //0 :"重置交易密码"; 1 :重置资金密码
            ReKHPassWordViewController *vc = [[ReKHPassWordViewController alloc] init];
            vc.vcType = self.vcType;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
        
            //用户模块登录
            if (![_validateCode isEqualToString:_code.textF.text]) {
                [HUDTool showText:@"验证码不正确"];
                return ;
            }
            
            RePassWordViewController *vc = [[RePassWordViewController alloc] init];
            vc.phoneNum = _phoneNum.textF.text;
            vc.vCode = _validateCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
