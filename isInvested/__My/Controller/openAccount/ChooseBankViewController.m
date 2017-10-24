//
//  ChooseBankViewController.m
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ChooseBankViewController.h"
#import "OpenAccountFlowView.h"
#import "BankSView.h"
#import "RiskAgreeViewController.h"
#import "IQKeyboardManager.h"
#import "NSDictionary+NullKeys.h"
#import "CityChooseView.h"
#import "BankChooseView.h"
#import "JPUSHService.h"
#import "OpenAccountResultViewController.h"
#import "NewBankChooseView.h"

@interface ChooseBankViewController ()<UITextFieldDelegate,UITextViewDelegate>

{

    NSArray *bankArr;
    NSString* _IPV4Str;
   
}

@property (nonatomic, strong) BankSView *banks;
@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSString *privace;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *ticket;//新浪支付的ticket

@end


@implementation ChooseBankViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedBack) name:@"complantOpenAccount" object:nil];
    //获取IP地址
    _IPV4Str =  [Util getIPV4String];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initMyView];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"bankData"ofType:@"json"];
    //根据文件路径读取数据
    NSData *jdata = [[NSData alloc]initWithContentsOfFile:filePath];
    //格式化成json数据
    NSError *error ;
    bankArr = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableContainers error:&error];

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    
    for (NSDictionary *bank in bankArr) {
        NSString *bankName = bank[@"bankName"];
        
        NSRange rang = [bankName rangeOfString:@"银行"];
        
        if (rang.length != 0) {
            bankName = [bankName substringWithRange:NSMakeRange(0, rang.location + rang.length)];
        }
        
        [arr addObject:bankName];
    }
    
    UIBarButtonItem *left =  [UIBarButtonItem itemWithTarget:self action:@selector(clickedBack) image:@"back"];
    self.navigationItem.leftBarButtonItem = left;

}

-(void)clickedBack{
    
     [self dismissViewControllerAnimated:YES completion:nil];
     [self.navigationController popViewControllerAnimated:YES];
}


-(void)initMyView{
    
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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - Y)];
    [self.view addSubview:scrollView];
    
    OpenAccountFlowView *openFlow = [[OpenAccountFlowView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, height) SelectIndex:2];
    [scrollView addSubview:openFlow];
    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, openFlow.bottom, WIDTH, 0.5)]];
    //持卡人
    CGFloat x = 5;
    _nameLTB = [[LbelTextFBtnView alloc] initWithFrame:CGRectMake(x, openFlow.bottom, (WIDTH - 2 * x), 44)];
    [scrollView addSubview:_nameLTB];
    _nameLTB.textF.keyboardType = UIKeyboardTypeNumberPad;
    _nameLTB.labelText = @"持卡人";
    _nameLTB.textF.userInteractionEnabled = NO;
    _nameLTB.textF.text = [NSUserDefaults objectForKey:IDCardName];
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, _nameLTB.bottom, WIDTH, 0.5)]];
    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, _nameLTB.bottom + 10, WIDTH, 0.5)]];
    //储蓄卡
    _bankCardLTB = [[LbelTextFBtnView alloc] initWithFrame:CGRectMake(x, _nameLTB.bottom + 10, (WIDTH - 2 * x), 44)];
    [scrollView addSubview:_bankCardLTB];
    _bankCardLTB.labelText = @"储蓄卡";
    _bankCardLTB.textF.delegate = self;
    _bankCardLTB.textF.keyboardType = UIKeyboardTypeNumberPad;
    _bankCardLTB.textF.placeholder = @"请输入储蓄卡号(支持复制粘贴)";
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(15, _bankCardLTB.bottom, WIDTH, 0.5)]];
    
    //银行
    _bankLTB = [[LbelTextFBtnView alloc] initWithFrame:CGRectMake(x, _bankCardLTB.bottom, (WIDTH - 2 * x), 44)];
    [scrollView addSubview:_bankLTB];
    _bankLTB.labelText = @"银行";
    _bankLTB.textF.placeholder = @"请点击选择银行";
    _bankLTB.textF.userInteractionEnabled = NO;
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(15, _bankLTB.bottom, WIDTH, 0.5)]];
    
    //银行开户地
    _bankCityLTB = [[LbelTextFBtnView alloc] initWithFrame:CGRectMake(x, _bankLTB.bottom, (WIDTH - 2 * x), 44)];
    [scrollView addSubview:_bankCityLTB];
    _bankCityLTB.labelText = @"开户地";
    _bankCityLTB.textF.placeholder = @"请点击选择开户地";
    _bankCityLTB.textF.userInteractionEnabled = NO;
    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, _bankCityLTB.bottom, WIDTH, 0.5)]];
    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, _bankCityLTB.bottom + 10, WIDTH, 0.5)]];
    
    //银行预留手机号
    _phoneNumLTB = [[LbelTextFBtnView alloc] initWithFrame:CGRectMake(x, _bankCityLTB.bottom + 10, (WIDTH - 2 * x), 44)];
    [scrollView addSubview:_phoneNumLTB];
    _phoneNumLTB.labelText = @"银行预留手机号";
    _phoneNumLTB.textF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumLTB.textF.placeholder = @"请输入预留的手机号";
    
    //验证码
    _code = [[MyTextView alloc] initWithFrame:CGRectMake(x, _phoneNumLTB.bottom , (WIDTH - 2 * x), 44)];
    [scrollView addSubview:_code];
    _code.textF.textColor = [UIColor blackColor];
    _code.placeholder = @"请输入验证码";
    _code.textF.keyboardType = UIKeyboardTypeNumberPad;
    _code.backColor = nil;
    _code.actBtn.backgroundColor = kNavigationBarColor;
    [_code.actBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _code.actBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _code.actBtn.hidden = NO;
    [_code setIsHaveImg:NO];
    WEAK_SELF
    _code.actBtnBlock = ^(){
        
        if([Util isEmpty:weakSelf.bankCardLTB.textF.text]){
            [HUDTool showText:@"储蓄卡号不能为空"];
            return ;
        }
        if([Util isEmpty:weakSelf.bankCode]){
            [HUDTool showText:@"银行不能为空"];
            return ;
        }
        
        if([Util isEmpty:weakSelf.privace] || [Util isEmpty:weakSelf.city]){
            [HUDTool showText:@"开户地不能为空"];
            return ;
        }

        if([Util isEmpty: weakSelf.phoneNumLTB.textF.text]){
            [HUDTool showText:@"请输入您预留的手机号"];
            return ;
        }
        
        if([Util validatePhoneNumber: weakSelf.phoneNumLTB.textF.text] == NO){
            [HUDTool showText:@"您输入的手机号不合法"];
            return ;
        }
        
        [weakSelf.code.textF becomeFirstResponder];
        weakSelf.code.timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf.code selector:NSSelectorFromString(@"countTimer:") userInfo:@"倒计时" repeats:YES];
        [weakSelf.code.timer fire];
        [weakSelf getOpenStatus];//直接跳过验证
        LOG(@"获取验证码");
    };
    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(15, _phoneNumLTB.bottom, WIDTH, 0.5)]];

    
    [scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, _code.bottom, WIDTH, 0.5)]];
    
    //是否查看
    _chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(x + 10 , _code.bottom + 25, 20, 20)];
    [_chooseBtn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    _chooseBtn.selected = YES;
    [_chooseBtn setImage:[UIImage imageNamed:@"bankAgree_choose"] forState:UIControlStateSelected];
    [scrollView addSubview:_chooseBtn];
    
    //服务协议(文本超链接)
    NSString *linkStr1 = @"http://www.goToDealAgree.com";
    NSDictionary *dict1 = @{NSLinkAttributeName:[NSURL URLWithString:linkStr1]};
    NSString *linkStr2 = @"http://www.riskAgree.com";
    NSDictionary *dict2 = @{NSLinkAttributeName:[NSURL URLWithString:linkStr2]};
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《入市交易协议书》和《风险揭示书》"];
    [attribute addAttributes:dict1 range:NSMakeRange(7, 9)];
    [attribute addAttributes:dict2 range:NSMakeRange(17, 7)];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(x + 30 + 10, _code.bottom + 20, (WIDTH - (x + 30 + 10)), 44)];
    [scrollView addSubview:textView];
    textView.attributedText = attribute;
    textView.delegate = self;
    textView.editable = NO;   // 非编辑状态下才可以点击Url

    //下一步
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, textView.bottom + 15, (WIDTH - 2 * x), 44)];
    loginBtn.tag = 101;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 3;
    loginBtn.backgroundColor = kNavigationBarColor;
    [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginBtn];
    
    
    //监管介绍
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, loginBtn.bottom + 10, WIDTH, 30)];
    [registBtn setTitle:@"交易资金由第三方银行存管,资金安全度100%" forState:UIControlStateNormal];
    //    registBtn.backgroundColor = [UIColor redColor];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [registBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [scrollView addSubview:registBtn];
    
    scrollView.contentSize = CGSizeMake(WIDTH, registBtn.bottom + 300);
    
    //银行选择
    UIButton *btn = [[UIButton alloc] initWithFrame:_bankLTB.bounds];
    [btn addTarget:self action:@selector(addBanks) forControlEvents:UIControlEventTouchUpInside];
    [_bankLTB addSubview:btn];
//    _banks = [[BankSView alloc] init];
//    _banks.frame = CGRectMake(0, _bankLTB.bottom, WIDTH, _banks.height);
//    _banks.hidden = YES;
//    _banks.chooseBank = ^(NSInteger index){
//    
//        weakSelf.bankLTB.textF.text = [Util returnBankNameByBankID:[NSString stringWithFormat:@"%li",(long)index]];
//        if (index <= 22) {
//            weakSelf.bankID = [NSString stringWithFormat:@"%li",(long)index];
//        }
//    };
//    [self.view addSubview:_banks];
    
    //开户地
    UIButton *cityBtn = [[UIButton alloc] initWithFrame:_bankCityLTB.bounds];
    [cityBtn addTarget:self action:@selector(addBankCity) forControlEvents:UIControlEventTouchUpInside];
    [_bankCityLTB addSubview:cityBtn];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    //根据银行卡号自动获取银行名称 暂时不用 xinle
//   NSString *bankName = [Util returnBankNameWith:textField.text InBankArr:bankArr];
//    
//    if (bankName != nil && ![bankName isEqualToString:@""]) {
//        _bankLTB.textF.text = bankName;
//    }
    
    return YES;
}

//银行选择
-(void)addBanks{

    [self.view endEditing:YES];
//    BankChooseView *bankView = [[BankChooseView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//    
//    bankView.chooseBank = ^(NSInteger index){
//        
//        LOG(@"~~~~~~~~~~~~%ld",(long)index);
//        WEAK_SELF
//        if (index <= 20) {
//            weakSelf.bankLTB.textF.text = [Util returnBankNameByBankID:[NSString stringWithFormat:@"%li",(long)index]];
//            weakSelf.bankID = [NSString stringWithFormat:@"%li",(long)index];
//        }
//    };
//    [[Util appWindow] addSubview:bankView];

    NewBankChooseView *bankView = [[NewBankChooseView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    bankView.chooseBank = ^(NSString *bankCode){
        
        WEAK_SELF
        weakSelf.bankLTB.textF.text = [Util returnBankNameByBankCode:bankCode];
        weakSelf.bankCode = bankCode;
    };
    [[Util appWindow] addSubview:bankView];


}

//开户地
-(void)addBankCity{

    [self.view endEditing:YES];
    CityChooseView *view = [[CityChooseView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    view.chooseIndexBlock = ^(NSString *privice,NSString *city){
        
        self.privace = privice;
        self.city = city;
        self.bankCityLTB.textF.text = [NSString stringWithFormat:@"%@ %@",privice,city];
    };
    [[Util appWindow] addSubview:view];
}

-(void)chooseBtn:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    [btn setImage:[UIImage imageNamed:@"bankAgree_unChoose"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"bankAgree_choose"] forState:UIControlStateSelected];
    
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    NSString *str = [NSString stringWithFormat:@"%@",URL];

    NSRange range;
    range = [str rangeOfString:@"goToDealAgree"];
    if (range.length > 0) {
        //入市交易协议书
        RiskAgreeViewController *agree = [[RiskAgreeViewController alloc] init];
        agree.title = @"签署协议";
        agree.textFileName = @"gotoDealAgree";
        [self.navigationController pushViewController:agree animated:YES];
        
    }else{
        //风险揭示书
        RiskAgreeViewController *agree = [[RiskAgreeViewController alloc] init];
        agree.title = @"签署协议";
        agree.textFileName = @"riskAgree";
        [self.navigationController pushViewController:agree animated:YES];
    }
    
    return NO;
}


-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 101) {
        //注册
        
       //新浪支付绑卡成功
        if ([NSUserDefaults boolForKey:isSinaAccountBangding] == YES) {
            [self UpdateAccountBank];
            return;
        }
        
        if([Util isEmpty:_code.textF.text]){
            [HUDTool showText:@"验证码不能为空"];
            return ;
        }
        
        
        if(_chooseBtn.selected != YES){
            [HUDTool showText:@"请认真阅读并同意服务条款"];
            return ;
        }
        
        //银行卡绑定流程
        [self binding_bank_card_advance];
    }
}


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
            
            if ([OpenAccountStatusStr isEqual: @"1"]) {
                //1:正在开户
                [Util alertViewWithMessage:@"数据处理中,请稍后重试" Target:self];
                return ;
            }else if([OpenAccountStatusStr isEqual: @"2"]){
                
                //2.开户成功 -- 签约账号
                NSString *signAccount = [resultDic handleNullObjectForKey:@"signAccount"];
                [NSUserDefaults setObject:signAccount forKey:KHSignAccount];
                //创建新浪子账户
                [self create_activate_member];
            
            }else if([OpenAccountStatusStr isEqual: @"3"]){
                //3.开户失败
                [Util alertViewWithMessage:@"开户失败,请联系牛奶金服工作人员" Target:self];
                return ;
            }
        }
        else{
            
            [HUDTool showText:@"获取开户状态失败"];
            return ;
        }
        
    } failure:^(NSError *error) {
    
        [HUDTool showText:@"请求超时"];
        return ;
        
    }];
    
}

#pragma mark -- 实盘绑定银行卡
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
    
    [HttpTool XLGet:UpdateAccountBank params:params success:^(id responseObj) {
        
        NSDictionary *dic = responseObj;
        NSString *state = dic[@"State"];
        if (state.integerValue == 1) {
            //成功
            OpenAccountResultViewController *result = [[OpenAccountResultViewController alloc] init];
            [self.navigationController pushViewController:result animated:YES];
        }else{
            //失败
            NSString *msg = [NSString stringWithFormat:@"实盘绑定银行卡失败:%@,请重试",dic[@"Descr"]];
            [HUDTool showText:msg];
            return ;
        }
        
    } failure:^(NSError *error) {
        
        [HUDTool showText:@"实盘绑定银行卡失败,请重试"];
        return ;
    }];
}


//查询银行卡信息
-(void)query_bank_card{

    if (_IPV4Str == nil || [_IPV4Str isEqualToString:@""]) {
        [HUDTool showText:@"请确认连接的网络"];
        return ;
    }
    NSDictionary *params = @{@"loginAccount":[NSUserDefaults objectForKey:KHSignAccount],
                             @"ip":_IPV4Str};
    [GGHttpTool post:[Util getSinaBangdingUrlBytype:query_bank_card] params:params success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        if ([dic[@"response_code"] isEqualToString:@"APPLY_SUCCESS"]) {
           
            NSString *card_list = dic[@"card_list"];
            if (card_list != nil && ![card_list isEqualToString:@""]) { //用户已经绑定银行卡
                [NSUserDefaults setBool:YES forKey:isSinaAccountBangding];//新浪支付绑卡成功
                
                NSArray *cardListArr = [card_list componentsSeparatedByString:@"^"];
                NSString *bankCardID = cardListArr[0];//银行卡ID
                NSString *bankCode = cardListArr[1];//银行
                NSString *bankCard = cardListArr[2];//银行卡号
                
                [NSUserDefaults setObject:bankCardID forKey:SinaBangdingbankCardID];
                [NSUserDefaults setObject:bankCode forKey:SinaBangdingBank];
                [NSUserDefaults setObject:bankCard forKey:SinaBangdingBankCard];
                [self UpdateAccountBank];//去绑定银行卡信息
                return;
            }else{
                //创建新浪子账户
                [self create_activate_member];
            }
        }else{
            //创建新浪子账户
            [self create_activate_member];
        }
    } failure:^(NSError *error) {
        
        LOG(@"%@",error);
        
    }];

}

// 创建激活会员
-(void)create_activate_member{
    
    if (_IPV4Str == nil || [_IPV4Str isEqualToString:@""]) {
        [HUDTool showText:@"请确认连接的网络"];
        return ;
    }
    NSDictionary *params = @{@"loginAccount":[NSUserDefaults objectForKey:KHSignAccount],
                             @"ip":_IPV4Str};
    [GGHttpTool post:[Util getSinaBangdingUrlBytype:create_activate_member] params:params success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
    
        if ([dic[@"response_code"] isEqualToString:@"APPLY_SUCCESS"]) {
            //创建子账号成功 -- 设置实名信息
            [self set_real_name];
        }else if ([dic[@"response_code"] isEqualToString:@"DUPLICATE_IDENTITY_ID"]){//标识重复也重新走
            //直接 -- 绑定银行卡
            [self binding_bank_card];
        }else{
            //创建子账号失败
            [HUDTool showText:dic[@"response_message"]];
            return ;
        }
    } failure:^(NSError *error) {
        
        [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",@"请求超时"] Target:self];
        return ;
        LOG(@"%@",error);
        
    }];

}

// 设置实名信息
-(void)set_real_name{

//    loginAccount--用户标识信息
//    realname--真实姓名
//    certno--证件号码
//    ip--请求者IP

    NSDictionary *params = @{@"loginAccount":[NSUserDefaults objectForKey:KHSignAccount],
                             @"realname":[NSUserDefaults objectForKey:IDCardName],
                             @"certno":[NSUserDefaults objectForKey:certNo],
                             @"ip":_IPV4Str};
    [GGHttpTool post:[Util getSinaBangdingUrlBytype:set_real_name] params:params success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];

        LOG(@"设置实名信息:%@",dic);
        
        if ([dic[@"response_code"] isEqualToString:@"APPLY_SUCCESS"]) {
            //设置实名信息成功 -- 绑定银行卡
             [self binding_bank_card];
        }else{
            //设置实名信息
            [HUDTool showText:dic[@"response_message"]];
            return ;
        }
    } failure:^(NSError *error) {
        
        LOG(@"%@",error);
        [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",@"请求超时"] Target:self];
        return ;
        
    }];

}
// 绑定银行卡
-(void)binding_bank_card{
    
//    loginAccount--用户标识信息
//    bankcode--银行编号
//    bankaccountno--银行卡号
//    accountname--户名
//    certno--证件号码
//    phoneno--银行预留手机号
//    province--省份
//    city--城市
//    ip--请求者IP
    
    NSDictionary *params = @{@"loginAccount":[NSUserDefaults objectForKey:KHSignAccount],
                             @"bankcode":self.bankCode,
                             @"bankaccountno":_bankCardLTB.textF.text,
                             @"accountname":[NSUserDefaults objectForKey:IDCardName],
                             @"certno":[NSUserDefaults objectForKey:certNo],
                             @"phoneno":_phoneNumLTB.textF.text,
                             @"province":self.privace,
                             @"city":self.city,
                             @"ip":_IPV4Str};
    [GGHttpTool post:[Util getSinaBangdingUrlBytype:binding_bank_card] params:params success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        LOG(@"绑定银行卡:%@",dic);
        if ([dic[@"response_code"] isEqualToString:@"APPLY_SUCCESS"]) {
           
            //绑定银行卡 -- 绑定银行卡推进
            _ticket = dic[@"ticket"];
            [NSUserDefaults setObject:_bankCode forKey:SinaBangdingBank];
            [NSUserDefaults setObject:_bankCardLTB.textF.text forKey:SinaBangdingBankCard];
//            [self binding_bank_card_advance];//此处必须手动去触发,绑卡推进机制
        }else{
            //设置实名信息
            [HUDTool showText:dic[@"response_message"]];
            return ;
        }
    } failure:^(NSError *error) {
        
        LOG(@"%@",error);
        [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",@"请求超时"] Target:self];
        return ;
        
    }];

}
// 绑定银行卡推进
-(void)binding_bank_card_advance{
    
//    ticket--绑卡时返回的ticket
//    validcode--短信验证码
//    ip--请求者IP
    if ([_ticket isEqualToString:@""] || _ticket == nil) {
        [HUDTool showText:@"当前验证码失效,请重新获取"];
        return;
    }
    
    NSDictionary *params = @{@"ticket":_ticket,
                             @"validcode":_code.textF.text,
                             @"ip":_IPV4Str};
    [GGHttpTool post:[Util getSinaBangdingUrlBytype:binding_bank_card_advance] params:params success:^(id responseObj) {
        
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        LOG(@"绑定银行卡推进:%@",dic);
        if ([dic[@"response_code"] isEqualToString:@"APPLY_SUCCESS"]) {
        
            [NSUserDefaults setBool:YES forKey:isSinaAccountBangding];//新浪支付绑卡成功
            [NSUserDefaults setObject:dic[@"card_id"] forKey:SinaBangdingbankCardID];//绑定的银行卡ID
        
            //绑定银行卡推进 -- 绑卡成功
            [self UpdateAccountBank];
            //设置别名
            [Util setJPushAlise:nil];
            //JPush 监听登陆成功
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(networkDidLogin:)
                                                         name:kJPFNetworkDidLoginNotification
                                                       object:nil];
            
        }else{
            //设置实名信息
            [HUDTool showText:dic[@"response_message"]];
            return ;
        }
    
    } failure:^(NSError *error) {
        
        LOG(@"%@",error);
        [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",@"请求超时"] Target:self];
        return ;
        
    }];

}

-(void)networkDidLogin:(NSNotification *)noti{
    [Util setJPushAlise:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
