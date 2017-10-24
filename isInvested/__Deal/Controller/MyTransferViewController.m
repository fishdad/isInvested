//
//  MyTransferViewController.m
//  isInvested
//
//  Created by Ben on 16/9/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MyTransferViewController.h"
#import "MyTransferView.h"
#import "ACPayPwdAlert.h"
#import "MyTranserListView.h"
#import "MyTransferResultViewController.h"
#import "ChooseTimeView.h"
#import "AppDelegate.h"
#import "DatePickChooseView.h"
#import "TransInACPayPwdAlert.h"
#import "RiskAgreeViewController.h"
#import "GetCodeViewController.h"
#import "NSDictionary+NullKeys.h"
#import "UploadCardImgViewController.h"
#import "RiskTableViewController.h"
#import "IQKeyboardManager.h"

@interface MyTransferViewController ()
{

   __block long long llbeginDate;
   __block long long llendDate;
}

@property (nonatomic, strong) MyTransferView *myTransferViewIn;
@property (nonatomic, strong) MyTransferView *myTransferViewOut;
@property (nonatomic, strong) MyTranserListView *myTransferListView;
@property (nonatomic, assign) TranserType transerType;
@property (nonatomic, strong) ChooseTimeView *chooseTimeView;
@property (nonatomic, strong) NSString *ticket;
@property (nonatomic, strong) NSArray *mArr;

@end

@implementation MyTransferViewController

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enable = NO;
    
    NSString *cardStr = [Util getCardStr];
    if (![_myTransferViewIn.cardLT.textF.text isEqualToString:cardStr]) {
        _myTransferViewIn.cardLT.textF.text = cardStr;
    }
    if (![_myTransferViewOut.cardLT.textF.text isEqualToString:cardStr]) {
        _myTransferViewIn.cardLT.textF.text = cardStr;
    }
    WEAK_SELF
    weakSelf.myTransferViewOut.priceLT.textF.text = @"";
    [[DealSocketTool shareInstance] GET_MONEYQUERYWithMoneyBlock:^(BourseMoneyInfo stu) {
        weakSelf.myTransferViewOut.priceLT.textF.placeholder = [NSString stringWithFormat:@"可转出金额为%.2f 元",stu.AmountFetchable];
    }];
}


-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [_myTransferViewIn endEditing:YES];
    [_myTransferViewOut endEditing:YES];
}

-(UISegmentedControl *)segmentControl{

    if (_segmentControl == nil) {
        //市价指价选择框
        NSArray *aArray = @[@"转入",@"转出",@"转账记录"];
        CGFloat space = 15;
        CGFloat segmentH = 34;
        _segmentControl = [[UISegmentedControl alloc] initWithItems:aArray];
        _segmentControl.frame = CGRectMake(space,20,WIDTH - space * 2, segmentH) ;
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl setTintColor:kNavigationBarColor];
        
        NSDictionary *colorAttr = [NSDictionary dictionaryWithObject:kNavigationBarColor forKey:NSForegroundColorAttributeName];
        [_segmentControl setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
        NSDictionary *colorAttrSelected = [NSDictionary dictionaryWithObject:OXColor(0xffffff) forKey:NSForegroundColorAttributeName];
        [_segmentControl setTitleTextAttributes:colorAttrSelected forState:UIControlStateSelected];
        
        [_segmentControl addTarget:self action:@selector(actionSegmentControl:) forControlEvents:(UIControlEventValueChanged)];
    }
    
    return _segmentControl;
}

//转入资金
-(void)transInMoney{

    WEAK_SELF
    NSString *inMoney = weakSelf.myTransferViewIn.priceLT.textF.text;
    if ([inMoney isEqualToString:@""] || inMoney.doubleValue <= 0) {
        [HUDTool showText:@"请输入正确的转入金额"];
        [weakSelf.myTransferViewIn.priceLT.textF becomeFirstResponder];
        return ;
    }
    
    BOOL isChkCertStatus = [NSUserDefaults boolForKey:@"ChkCertStatus"];
    if (isChkCertStatus) {//证件已上传
        [weakSelf transInPassWordAlert];
    }else{
        double amount = [weakSelf.myTransferViewIn.priceLT.textF.text doubleValue];
        [weakSelf ChkCertStatusWithAmount:amount];//查询证件上传的状态
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mArr = [NSArray array];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = OXColor(0xf5f5f5);
    //功能选择segement
    [self.view addSubview:self.segmentControl];
    //转入
    _myTransferViewIn = [[MyTransferView alloc] initWithFrame:CGRectMake(0, NH(_segmentControl) + 15, WIDTH, HEIGHT - 20 - 64 - _segmentControl.height- 20 - 49)Type:TranserTypeIn];
    [self.view addSubview:_myTransferViewIn];
    WEAK_SELF
    _myTransferViewIn.clickBlock = ^(){
        
        //获取广贵所的签约状态
        NSString *signKey = [NSString stringWithFormat:@"SIGNRESULTNOTIFYQUERY%@",[NSUserDefaults objectForKey:UserID]];
        BOOL isSign = [NSUserDefaults boolForKey:signKey];
        if (isSign != YES) {
            [[DealSocketTool shareInstance] GET_SIGNRESULTNOTIFYQUERYWithResultBlock:^(unsigned short isSuccess, NSString *statusStr) {
                NSRange range = [statusStr rangeOfString:@"重复签约"];
                if (isSuccess == 1 || range.length > 0) {
                    [NSUserDefaults setBool:YES forKey:signKey];
                    [weakSelf transInMoney];
                }
            }];
        }else{
            [weakSelf transInMoney];
        }
    };
    [self setUpTranserView:_myTransferViewIn ByType:TranserTypeIn];
    
    //转出
    _myTransferViewOut = [[MyTransferView alloc] initWithFrame:CGRectMake(0, NH(_segmentControl) + 15, WIDTH, HEIGHT - 20 - 64 -  _segmentControl.height- 20 - 49)Type:TranserTypeOut];
    [self.view addSubview:_myTransferViewOut];
    _myTransferViewOut.clickBlock = ^(){
       
        
        NSString *outMoney = weakSelf.myTransferViewOut.priceLT.textF.text;
        if ([outMoney isEqualToString:@""] || outMoney.doubleValue <= 0) {
            [HUDTool showText:@"请输入正确的转出金额"];
            [weakSelf.myTransferViewIn.priceLT.textF becomeFirstResponder];
            return ;
        }
        [[DealSocketTool shareInstance] GET_MONEYQUERYWithMoneyBlock:^(BourseMoneyInfo stu) {
            
            
//            [Util alertViewWithMessage:[NSString stringWithFormat:@"交易所余额:%f,交易所可用资金:%f,交易所可提取资金:%f",stu.Amount,stu.AmountAvailable,stu.AmountFetchable] Target:weakSelf];
            
            if (outMoney.doubleValue <= stu.AmountFetchable) {
                [weakSelf passWordAlert];
            }else{
                [HUDTool showText:@"当前可提取资金不足"];
                return ;
            }
        }];
        
    };

     [self setUpTranserView:_myTransferViewOut ByType:TranserTypeIn];
    
    //转账记录
    _myTransferListView = [[MyTranserListView alloc] initWithFrame:CGRectMake(0,  NH(_segmentControl), WIDTH, HEIGHT - 20 - 64 -  _segmentControl.height- 40 - 49 - 44)];
    [self.view addSubview:_myTransferListView];
    _myTransferListView.hidden = YES;
    
    //*************查询历史记录**********
    _chooseTimeView = [[ChooseTimeView alloc] initWithFrame:CGRectMake(0, NH(_myTransferListView), WIDTH, 40)];
    _chooseTimeView.outOfDays = 7;
    _chooseTimeView.hidden = YES;
    [self.view addSubview:_chooseTimeView];

    //应该先有个默认区间(显示当天)
    NSString *date = [Util GetsTheCurrentCalendar];
    _chooseTimeView.lbl.text = [NSString stringWithFormat:@"%@ 至 %@",date,date];
    //1.自动默认查询
    NSString *beginDate = [NSString stringWithFormat:@"%@ 00:00:00",date];
    NSString *endDate = [NSString stringWithFormat:@"%@ 23:59:59",date];
    llbeginDate = [[Util dateToUTCWithDate:beginDate] longLongValue];
    llendDate = [[Util dateToUTCWithDate:endDate] longLongValue];
    [_myTransferListView reloadDataByBeginDate:llbeginDate EndDate:llendDate];//查询转账记录
    //指定日期查询
    _chooseTimeView.btnBlock = ^(long long beginDate,long long endDate){
        llbeginDate = beginDate;
        llendDate = endDate;
        [weakSelf.myTransferListView reloadDataByBeginDate:beginDate EndDate:endDate];//查询转账记录
    };
    //********************************
}

#pragma mark 密码键盘弹出 -- 完成出金的操作
-(void)passWordAlert{

    ACPayPwdAlert *pwdAlert = [[ACPayPwdAlert alloc] init];
    pwdAlert.title = @"请输入资金密码";
    __weak typeof(pwdAlert) weakPwdAlert = pwdAlert;
    
    //重置密码
    weakPwdAlert.forgetPassAction = ^(){
        [weakPwdAlert dismiss];
        GetCodeViewController *vc = [[GetCodeViewController alloc] init];
        vc.vcType = 1;//资金密码重置
        [self.navigationController pushViewController:vc animated:YES];
    };    
    pwdAlert.completeAction = ^(NSString *pwd){
       
        MoneyInOutParamModel *inOutParamModel = [[MoneyInOutParamModel alloc] init];
        NSString *price;
       //这是密码输入成功之后的处理操作
        void (^okBlock)();
        WEAK_SELF
        LOG(@"转出:==pwd:%@", pwd);
        inOutParamModel.OperateType = MONEY_OUT;
        price = _myTransferViewOut.priceLT.textF.text;
//        price = [NSString stringWithFormat:@"%.2f",[price doubleValue]];//强制保留两位小数
        okBlock = ^(){
            weakSelf.myTransferViewOut.priceLT.textF.text = @"";
            [[DealSocketTool shareInstance] GET_MONEYQUERYWithMoneyBlock:^(BourseMoneyInfo stu) {
                weakSelf.myTransferViewOut.priceLT.textF.placeholder = [NSString stringWithFormat:@"可转出金额为%.2f 元",stu.AmountFetchable];
            }];
        };
        
        inOutParamModel.BankPsw = @"";///< 银行密码
        inOutParamModel.FundPsw = pwd;///< 资金密码
        inOutParamModel.Amount = price.doubleValue;
       
        [self showHud];
        [[DealSocketTool shareInstance] REQ_MONEYINOUTWithParamModel:inOutParamModel Block:^(MoneyInOutInfoModel *model) {
            //输入密码之后的处理
            if (model.RetCode == 99999) {
                [weakPwdAlert dismiss];
                NSString * _IPV4Str = [Util getIPV4String];
                if (_IPV4Str == nil || [_IPV4Str isEqualToString:@""]) {
                    [HUDTool showText:@"请确认连接的网络"];
                    return ;
                }
                NSDictionary *params = @{@"loginAccount":[NSUserDefaults objectForKey:KHSignAccount],
                                         @"amount":price,
                                         @"cardId":[NSUserDefaults objectForKey:SinaBangdingbankCardID],
                                         @"ip":_IPV4Str,
                                         @"userId":[NSUserDefaults objectForKey:UserID]};
                
                [GGHttpTool post:[Util getSinaBangdingUrlBytype:create_hosting_withdraw] params:params success:^(id responseObj) {
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
                    
                    [self hideHud];
                    if ([dic[@"response_code"] isEqualToString:@"APPLY_SUCCESS"]) {
                        
                        MyTransferResultViewController *vc = [[MyTransferResultViewController alloc] init];
                        vc.price = price;
                        vc.okBlock = okBlock;
                        [self.navigationController pushViewController:vc animated:YES];

                    }else{
                        NSString *message = [NSString stringWithFormat:@"❌ %@", dic[@"response_message"]];
                        [Util alertViewWithMessage:message Target:self];
                    }
                } failure:^(NSError *error) {
                    [weakPwdAlert dismiss];
                    [self hideHud];
                    [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",@"访问超时"] Target:self];
                    return ;
                }];
            }else{
                [weakPwdAlert dismiss];
                [self hideHud];
                NSString *message = [NSString stringWithFormat:@"❌ %@", model.Message];
                [Util alertViewWithMessage:message Target:self];
                return ;
            }
        } ErrorBlock:^(unsigned short isSuccess, NSString *statusStr) {
           
            [weakPwdAlert dismiss];
            [self hideHud];
//            [HUDTool showText:statusStr];
            [Util alertViewWithMessage:statusStr Target:self];
            
            return ;
        }];
        
    };
    [pwdAlert show];
}

#pragma mark -- 查询证件上传状态
-(void)ChkCertStatusWithAmount:(double) amount{
    
    NSDictionary *params = @{@"method":@"ChkCertStatus",
                             @"loginAccount":[NSUserDefaults objectForKey:KHAccount]};
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        if ([[responseObject handleNullObjectForKey:@"errCode"] isEqual: @"99999"]) {
            
            NSString *result = [responseObject handleNullObjectForKey:@"status"];
            
            if ([result isEqualToString:@"4"]) {
                //开户未上传
                [self selectAllInMoneyWithAmount:amount Status:@"4"];
            }else if ([result isEqualToString:@"1"]){
                //待审核
                [self selectAllInMoneyWithAmount:amount Status:@"1"];
            }else if ([result isEqualToString:@"2"]){
                //审核通过
                [NSUserDefaults setBool:YES forKey:@"ChkCertStatus"];
                [self transInPassWordAlert];
            }else if ([result isEqualToString:@"3"]){
                //审核被驳回
                [Util alertViewWithCancelBtnAndMessage:@"上传证件审核未通过,请重新上传" Target:self doActionBtn:@"立即上传" handler:^(UIAlertAction *action) {
                    //修改证件
                    UploadCardImgViewController *upLoadVC = [[UploadCardImgViewController alloc] init];
                    upLoadVC.isUpdateScan = YES;
                    [self.navigationController pushViewController:upLoadVC animated:YES];
                }];
            }
        }else{
            [Util showHUDAddTo:self.view Text:@"交易所检查证件状态失败,暂不允许入金"];
            return ;
        }
        
    } failure:^(NSError *error) {
        
        [Util showHUDAddTo:self.view Text:@"交易所检查证件状态失败,暂不允许入金"];
        return ;
    }];
    
}

#pragma mark -- 查询历史累计入金
-(void)selectAllInMoneyWithAmount:(double) amount Status:(NSString *)status{
    
    NSDictionary *params = @{@"userId":[NSUserDefaults objectForKey:UserID],
                             @"type":@"1"};
    
    [GGHttpTool get:[Util getTransAmountUrlBytype:GetSumAmount] params:params success:^(id responseObj) {
        
        NSDictionary *dic = responseObj;
        if ([dic[@"code"] intValue]== 1){
            double allInMoney = [dic[@"data"] doubleValue];
            
            if ([status isEqualToString:@"4"]) {
                
                //开户未上传的累计入金上限10000
                if (allInMoney + amount > 10000) {
                    //完善开户信息 xinle 2016.12.28
                    [Util alertViewWithCancelBtnAndMessage:@"完善开户资料,只需两步即可提升入金上限到30万" Target:self doActionBtn:@"立即完善" handler:^(UIAlertAction *action) {
                        
                        
                        NSString *ID = [NSUserDefaults objectForKey:UserID];
                        NSString *pString = [NSUserDefaults objectForKey:[NSString stringWithFormat:@"%@riskTest",ID]];
                        
                        if (pString != nil) {
                            //存在风险测评
                            UploadCardImgViewController *upLoadVC = [[UploadCardImgViewController alloc] init];
                            upLoadVC.isNeedToUpLoadPDF = YES;
                            [self.navigationController pushViewController:upLoadVC animated:YES];
                        }else{
                            //不存在风险测评
                            RiskTableViewController *riskTestVC = [[RiskTableViewController alloc] init];
                            [self.navigationController pushViewController:riskTestVC animated:YES];
                        }
                    }];
                }else{
                    [self transInPassWordAlert];
                }
            }else if ([status isEqualToString:@"1"]){
            
                //证件审核中
                if (allInMoney + amount > 10000) {
                    //完善开户信息 xinle 2016.12.28
                    NSString *msg = [NSString stringWithFormat:@"开户补充资料审核中,当前可入资金 %.2f元",(10000 - allInMoney)];
                    [Util alertViewWithMessage:msg Target:self];
                }else{
                    [self transInPassWordAlert];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

//显示风火轮
-(void)showHud{
    dispatch_main_async_safe(^{
        [HUDTool showToView:[UIApplication sharedApplication].delegate.window];
        [self performSelector:@selector(hideHud) withObject:nil afterDelay:15.0];
    });
}
//隐藏风火轮
-(void)hideHud{
    dispatch_main_async_safe(^{
        [HUDTool hideForView:[UIApplication sharedApplication].delegate.window];
    });
}



#pragma mark -- 入金的密码键盘 带 验证码
-(void)transInPassWordAlert{
    
    TransInACPayPwdAlert *pwdAlert = [[TransInACPayPwdAlert alloc] init];
    pwdAlert.title = @"请输入资金密码";
    __weak typeof(pwdAlert) weakPwdAlert = pwdAlert;
    __block NSString *price;
    //获取验证码
    WEAK_SELF
    //重置密码
    weakPwdAlert.forgetPassAction = ^(){
        [weakPwdAlert dismiss];
        GetCodeViewController *vc = [[GetCodeViewController alloc] init];
        vc.vcType = 1;//资金密码重置
        [self.navigationController pushViewController:vc animated:YES];
    };
    //输入自己密码
    __block MoneyInOutParamModel *inOutParamModel = [[MoneyInOutParamModel alloc] init];
    weakPwdAlert.actBtnBlock = ^(){
        
        if([Util isEmpty: weakPwdAlert.pwd]){
            [HUDTool showText:@"请输入资金密码"];
            return ;
        }
        
        NSString *pwd = weakPwdAlert.pwd;
       
        if (_transerType == TranserTypeIn) {
            LOG(@"转入:==pwd:%@", pwd);
            inOutParamModel.OperateType = MONEY_IN;
            price = _myTransferViewIn.priceLT.textF.text;
            inOutParamModel.BankPsw = @"";///< 银行密码
            inOutParamModel.FundPsw = pwd;///< 资金密码
            
        }
        inOutParamModel.Amount = price.doubleValue;
        [weakPwdAlert changeView];//改变当前视图
        [self showHud];
        //重新获取验证码
        weakPwdAlert.code.timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:weakPwdAlert.code selector:NSSelectorFromString(@"countTimer:") userInfo:@"倒计时" repeats:YES];
        [[DealSocketTool shareInstance] REQ_MONEYINOUTWithParamModel:inOutParamModel Block:^(MoneyInOutInfoModel *model) {
            //输入密码之后的处理
            [self hideHud];
            if (model.RetCode == 99999) {
                self.ticket = model.Ticket;
//                [weakPwdAlert changeView];//改变当前视图
            }else{
                [weakPwdAlert dismiss];
                NSString *message = [NSString stringWithFormat:@"❌ %@", model.Message];
                [Util alertViewWithMessage:message Target:self];
                return ;
            }
            
            
        } ErrorBlock:^(unsigned short isSuccess, NSString *statusStr) {
            
            [self hideHud];
            [weakPwdAlert dismiss];
            [Util alertViewWithMessage:statusStr Target:self];
            return ;
        }];

        
    };

    weakPwdAlert.code.actBtnBlock = ^(){
        LOG(@"从新获取验证码");
        weakPwdAlert.code.timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:weakPwdAlert.code selector:NSSelectorFromString(@"countTimer:") userInfo:@"倒计时" repeats:YES];

        [[DealSocketTool shareInstance] REQ_MONEYINOUTWithParamModel:inOutParamModel Block:^(MoneyInOutInfoModel *model) {
            //输入密码之后的处理
            if (model.RetCode == 99999) {
                self.ticket = model.Ticket;
            }else{
                return ;
            }
        } ErrorBlock:^(unsigned short isSuccess, NSString *statusStr) {
            return ;
        }];
    };

    //确认入金
    pwdAlert.okBtnAction = ^(){
        
        if([Util isEmpty: weakPwdAlert.code.textF.text]){
            [HUDTool showText:@"请输入手机验证码"];
            return ;
        }
        [self showHud];
        //这是密码输入成功之后的处理操作
        void (^okBlock)();
        okBlock = ^(){
            weakSelf.myTransferViewIn.priceLT.textF.text = @"";
        };
        [[DealSocketTool shareInstance] REQ_PAYFORWARDWithTicket:self.ticket IdentifyCode:weakPwdAlert.code.textF.text PayBlock:^(ProcessResult stu) {
            
            NSString *Message = [NSString stringWithCString:stu.Message encoding:NSUTF8StringEncoding];
            [self hideHud];
            if (stu.RetCode == 99999) {
                //确认入金操作成功之后的处理
                LOG(@"~~~~~~~入金成功之后的回调,进入转账结果的页面(提交)~~~~~~~~");
                MyTransferResultViewController *vc = [[MyTransferResultViewController alloc] init];
                vc.price = price;
                vc.okBlock = okBlock;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
            
                [HUDTool showText:Message toView:[Util appWindow]];
            }
        } ResultBlock:^(ProcessResult stu) {
            
            
            NSString *Message = [NSString stringWithCString:stu.Message encoding:NSUTF8StringEncoding];
            [weakPwdAlert dismiss];
            [self hideHud];
            if (stu.RetCode == 99999) {
                //确认到账成功之后的处理
                [self insertTansAmountWithPrice:price State:@"1"];//插入入金的记录(1:成功)
                LOG(@"~~~~~~~入金成功之后的回调,进入转账结果的页面(到账)~~~~~~~~");
                MyTransferResultViewController *vc = [[MyTransferResultViewController alloc] init];
                vc.price = price;
                vc.okBlock = okBlock;
                vc.isSuccessAmount = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self insertTansAmountWithPrice:price State:@"0"];//插入入金的记录(0:失败)
                
               [HUDTool showText:Message toView:[Util appWindow]];
            }

        }];
    
    };
    [pwdAlert show];
}

//增加入金记录
-(void)insertTansAmountWithPrice:(NSString *) price State:(NSString *) state{
    
    NSString * _IPV4Str = [Util getIPV4String];
    if (_IPV4Str == nil || [_IPV4Str isEqualToString:@""]) {
        [HUDTool showText:@"请确认连接的网络"];
        return ;
    }
    NSDictionary *params = @{@"userId":[NSUserDefaults objectForKey:UserID],
                             @"loginAccount":[NSUserDefaults objectForKey:KHSignAccount],
                             @"amount":price,
                             @"cardId":[NSUserDefaults objectForKey:SinaBangdingbankCardID],
                             @"ip":_IPV4Str,
                             @"state":state,
                             @"type":@"1"};
    
    [GGHttpTool get:[Util getTransAmountUrlBytype:AddWithdrawLog] params:params success:^(id responseObj) {
        
        
    } failure:^(NSError *error) {
    
    }];
}


-(void)setUpTranserView:(MyTransferView *)myTransferView ByType:(NSUInteger) type{

    _myTransferListView.hidden = YES;
    _chooseTimeView.hidden = YES;
    myTransferView.cardLT.label.text = @"储蓄卡";
//  myTransferView.cardLT.textF.text = @"****此处银行卡获取****";
    myTransferView.cardLT.textF.text = [Util getCardStr];
    myTransferView.cardLT.textF.userInteractionEnabled = NO;
    myTransferView.priceLT.label.text = @"金额";
    myTransferView.hidden = NO;
    if (type == TranserTypeIn) {
        //转入
        _myTransferViewOut.hidden = YES;
        myTransferView.helpBtn.hidden = YES;
        myTransferView.moneyHelpLbl.text = @"单笔50万,单日50万";
        myTransferView.timeHelpLbl.text = @"转入时间为工作日09:00 - 21:00";
        [myTransferView.btn setTitle:@"确认转入" forState:UIControlStateNormal];
        myTransferView.priceLT.textF.placeholder = @"建议转入2000元以上金额";
    }else{
        //转出
        _myTransferViewIn.hidden = YES;
        myTransferView.helpBtn.hidden = NO;
        myTransferView.helpClickBlock = ^(){
            RiskAgreeViewController *agree = [[RiskAgreeViewController alloc] init];
            agree.title = @"出金规则";
            agree.textFileName = @"transOutRule";
            [self.navigationController pushViewController:agree animated:YES];
        };
        myTransferView.moneyHelpLbl.text = @"";
        myTransferView.timeHelpLbl.text = @"转出时间为工作日09:00 - 21:00";
        [myTransferView.btn setTitle:@"确认转出" forState:UIControlStateNormal];
        myTransferView.priceLT.textF.placeholder = @"";
        [[DealSocketTool shareInstance] GET_MONEYQUERYWithMoneyBlock:^(BourseMoneyInfo stu) {
            myTransferView.priceLT.textF.placeholder = [NSString stringWithFormat:@"可转出金额为%.2f 元",stu.AmountFetchable];
        }];
        
    }
}
-(void)actionSegmentControl:(UISegmentedControl *)segment{
    
    [_myTransferViewIn endEditing:YES];
    [_myTransferViewOut endEditing:YES];
    
    if (segment.selectedSegmentIndex == 2) {
        //转账记录
        _myTransferViewIn.hidden = YES;
        _myTransferViewOut.hidden = YES;
        _myTransferListView.hidden = NO;
        _chooseTimeView.hidden = NO;
        [_myTransferListView reloadDataByBeginDate:llbeginDate EndDate:llendDate];
        
    }else if(segment.selectedSegmentIndex == 0){
        _transerType = TranserTypeIn;
        [self setUpTranserView:_myTransferViewIn ByType:segment.selectedSegmentIndex];
    }else if (segment.selectedSegmentIndex == 1){
         _transerType = TranserTypeOut;
        [self setUpTranserView:_myTransferViewOut ByType:segment.selectedSegmentIndex];
    }

}

-(void)tabbarHidden:(BOOL)hidden{

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *views = [app.window.rootViewController.view subviews];
    for(id v in views){
        if([v isKindOfClass:[UITabBar class]]){
            [(UITabBar *)v setHidden:hidden];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
