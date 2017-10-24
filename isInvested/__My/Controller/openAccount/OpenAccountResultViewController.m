//
//  OpenAccountResultViewController.m
//  isInvested
//
//  Created by Ben on 16/9/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "OpenAccountResultViewController.h"
#import "IsOpeningAccountStatusView.h"
#import "HasOpenedAccountView.h"
#import "NSDictionary+NullKeys.h"
#import "IITabBarController.h"

@interface OpenAccountResultViewController ()

@property (nonatomic, strong) IsOpeningAccountStatusView *isOpeningView;
@property (nonatomic, strong) HasOpenedAccountView *hasOpenedView;

@end

@implementation OpenAccountResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开户结果";
    self.view.backgroundColor = [UIColor whiteColor];

    //正在开户状态页面
    _isOpeningView = [[IsOpeningAccountStatusView alloc] initWithFrame:self.view.bounds];
    _isOpeningView.hidden = YES;
    WEAK_SELF
    __weak typeof(_isOpeningView) weakIsOpeningView = _isOpeningView;
    _isOpeningView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        LOG(@"当前页面的下拉刷新方法~~~~");
        [weakSelf getOpenStatus];
        [weakIsOpeningView.scrollView.mj_header endRefreshing];
    }];
    
    [self.view addSubview:_isOpeningView];
    
    //开户成功界面
    _hasOpenedView = [[HasOpenedAccountView alloc] initWithFrame:self.view.bounds];
    _hasOpenedView.hidden = YES;
    
    //进行交易
    _hasOpenedView.goToDealBlock = ^(){
        
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"complantOpenAccount" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoOpenAccount" object:nil];
        [Util goToDeal];//手动点击交易 xinle   
    };
    //继续绑定
    _hasOpenedView.openAccountBlock = ^(){
        [weakSelf toulemeOpenAccount];
    };
    [self.view addSubview:_hasOpenedView];

    //获取开户状态
    [self getOpenStatus];
}

-(void)getOpenStatus{
    
    NSString *KHAccountStr = [NSUserDefaults objectForKey:KHAccount];
    if (KHAccountStr == nil || [KHAccountStr isEqualToString:@""]) {
        [HUDTool showText:@"当前还未有开户账号"];
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
                _isOpeningView.hidden = NO;
                _hasOpenedView.hidden = YES;
                return ;
            }else if([OpenAccountStatusStr isEqual: @"2"]){
                
                //2.开户成功
                [self toulemeOpenAccount];
                _isOpeningView.hidden = YES;
                _hasOpenedView.hidden = NO;
                return;
            }else if([OpenAccountStatusStr isEqual: @"3"]){
                //3.开户失败
                [NSUserDefaults setBool:NO forKey:isOpenAccount];
                _isOpeningView.hidden = YES;
                _hasOpenedView.hidden = YES;
//                [HUDTool showText:@"开户失败"];
                [Util alertViewWithMessage:@"开户失败" Target:self];
                return ;
            }
        }else{
            
            [HUDTool showText:@"获取开户状态失败"];
            return ;
        }
        
    } failure:^(NSError *error) {
        
        [HUDTool showText:@"当前网络环境异常"];
        return ;
        
    }];
    
}


#pragma mark -- 开户逻辑修改,在绑定银行卡的地方上传了 交易账号 此处暂时屏蔽 by xinle
-(void)toulemeOpenAccount{
    
    
//    //参数说明:
//    /// <param name="userId">用户ID</param>
//    /// <param name="phone">手机号码</param>
//    /// <param name="accCode">实盘账号</param>
//    /// <param name="accTrueName">真实姓名</param>
//    /// <param name="accIdCard">身份证号</param>
//    //已经开户的不再绑定
//    if ([NSUserDefaults boolForKey:isBangDingAccount] == YES) {
//        return;
//    } ;
//    NSDictionary *params = @{@"userId":[NSUserDefaults objectForKey:UserID],
//                             @"phone":[NSUserDefaults objectForKey:mobilePhone],
//                             @"accCode":[NSUserDefaults objectForKey:KHAccount],
//                             @"accTrueName":[NSUserDefaults objectForKey:IDCardName],
//                             @"accIdCard":[NSUserDefaults objectForKey:certNo],
//                             @"email":[NSUserDefaults objectForKey:KHEmail],
//                             @"platformType":@8};
//    
//    [HttpTool XLGet:GET_OPENACCOUNT params:params success:^(id responseObj) {
//        
//        NSDictionary *dic = responseObj;
//        NSString *state = dic[@"State"];
//        if (state.integerValue == 1) {
//            //成功
//            [NSUserDefaults setBool:YES forKey:isOpenAccount];
//            [NSUserDefaults setBool:YES forKey:isBangDingAccount];
//            UIButton *btn = _hasOpenedView.btn;
//            [btn setTitle:@"马上去交易" forState:UIControlStateNormal];
//        }else{
//            //失败
//            UIButton *btn = _hasOpenedView.btn;
//            [btn setTitle:@"完成绑定" forState:UIControlStateNormal];
//            [HUDTool showText:[NSString stringWithFormat:@"%@,请完成绑定操作",dic[@"Descr"]]];
//            return ;
//        }
//        
//    } failure:^(NSError *error) {
//        
//        UIButton *btn = _hasOpenedView.btn;
//        [btn setTitle:@"完成绑定" forState:UIControlStateNormal];
//        [HUDTool showText:@"数据绑定失败"];
//        return ;
//        
//        
//    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
