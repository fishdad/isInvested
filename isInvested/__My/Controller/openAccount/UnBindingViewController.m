//
//  UnBindingViewController.m
//  isInvested
//
//  Created by Ben on 16/11/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "UnBindingViewController.h"

#import "PopMarketDealView.h"
#import "RiskAgreeViewController.h"
#import "MyTransferResultViewController.h"

#import "NormalInfoViewController.h"
#import "ChooseBankViewController.h"
#import "RiskTableViewController.h"
#import "UploadCardImgViewController.h"
#import "OpenAccountResultViewController.h"

#import "XLHUDView.h"

@interface UnBindingViewController ()

@property (nonatomic, strong) NSString *ticket;
@property (strong, nonatomic) IBOutlet UITextField *codeTxt;//验证码

@end

@implementation UnBindingViewController


- (IBAction)getCode:(id)sender {
    
    //        6.解绑银行卡(unbinding_bank_card)
    //        接口url:http://192.168.1.185:8918/unbinding_bank_card.aspx?loginAccount=&cardid=&ip=
    //        --------------------------------------------
    //        参数说明(不可空):
    //        loginAccount--用户标识信息
    //        cardid--卡ID
    //        ip--请求者IP
    //        返回参数：见新浪资金托管接口说明
    //

    
    NSString  *_IPV4Str =  [Util getIPV4String];
    if (_IPV4Str == nil || [_IPV4Str isEqualToString:@""]) {
        [HUDTool showText:@"请确认连接的网络"];
        return ;
    }
    NSDictionary *params = @{@"loginAccount":[NSUserDefaults objectForKey:KHSignAccount],
                             @"ip":_IPV4Str,
                             @"cardid":[NSUserDefaults objectForKey:SinaBangdingbankCardID]};
    [GGHttpTool post:[Util getSinaBangdingUrlBytype:unbinding_bank_card] params:params success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        if ([dic[@"response_code"] isEqualToString:@"APPLY_SUCCESS"]) {
            
            [Util alertViewWithMessage:dic[@"response_code"] Target:self];
            LOG(@"~~~~~ticket:%@",dic[@"ticket"]);
            _ticket = dic[@"ticket"];
            
        }else{
            [Util alertViewWithMessage:dic[@"response_message"] Target:self];
            return ;
        }
    } failure:^(NSError *error) {
        
        LOG(@"%@",error);
        [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",error] Target:self];
        return ;
    }];
    

}
- (IBAction)unBangding:(id)sender {
    
    //        7.解绑银行卡推进(unbinding_bank_card_advance)
    //        接口url:http://192.168.1.185:8918/unbinding_bank_card_advance.aspx?loginAccount=&ticket=&validcode=&ip=
    //        --------------------------------------------
    //        参数说明(不可空):
    //        loginAccount--用户标识信息
    //        ticket--绑卡时返回的ticket
    //        validcode--短信验证码
    //        ip--请求者IP
    //        返回参数：见新浪资金托管接口说明
    
    
    
    //9.换绑卡通知(egs_change_bindingcard)
    //接口url:http://192.168.1.185:8918/egs_change_bindingcard.aspx?loginAccount=&origcardid=&cardid=&ip=
    //--------------------------------------------
    //参数说明(不可空):
    //loginAccount--用户标识信息
    //origcardid--原卡ID
    //cardid--卡ID
    //ip--请求者IP
    //返回参数：见新浪资金托管接口说明


    NSString  *_IPV4Str =  [Util getIPV4String];
    if (_IPV4Str == nil || [_IPV4Str isEqualToString:@""]) {
        [HUDTool showText:@"请确认连接的网络"];
        return ;
    }
    NSDictionary *params = @{@"loginAccount":[NSUserDefaults objectForKey:KHSignAccount],
                             @"ip":_IPV4Str,
                             @"validcode":_codeTxt.text,
                             @"ticket":_ticket};
    [GGHttpTool post:[Util getSinaBangdingUrlBytype:unbinding_bank_card_advance] params:params success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        if ([dic[@"response_code"] isEqualToString:@"APPLY_SUCCESS"]) {
            
             [Util alertViewWithMessage:dic[@"response_code"] Target:self];
            
        }else{

            [Util alertViewWithMessage:dic[@"response_message"] Target:self];
            return ;
        }
    } failure:^(NSError *error) {
        
        LOG(@"%@",error);
        [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",error] Target:self];
        return ;
    }];

}

- (IBAction)revoke:(id)sender {
    
    
    //8.注销会员(egs_member_revoke)
    //接口url:http://192.168.1.185:8918/egs_member_revoke.aspx?loginAccount=&ip=
    //--------------------------------------------
    //参数说明(不可空):
    //loginAccount--用户标识信息
    //ip--请求者IP
    //返回参数：见新浪资金托管接口说明
    //

    NSString  *_IPV4Str =  [Util getIPV4String];
    if (_IPV4Str == nil || [_IPV4Str isEqualToString:@""]) {
        [HUDTool showText:@"请确认连接的网络"];
        return ;
    }
    NSDictionary *params = @{@"loginAccount":[NSUserDefaults objectForKey:KHSignAccount],
                             @"ip":_IPV4Str};
    [GGHttpTool post:[Util getSinaBangdingUrlBytype:egs_member_revoke] params:params success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        if ([dic[@"response_code"] isEqualToString:@"APPLY_SUCCESS"]) {
            
            [Util alertViewWithMessage:dic[@"response_code"] Target:self];
            
        }else{
            
            [Util alertViewWithMessage:dic[@"response_message"] Target:self];
            return ;
        }
    } failure:^(NSError *error) {
        
        LOG(@"%@",error);
        [Util alertViewWithMessage:[NSString stringWithFormat:@"%@",error] Target:self];
        return ;
    }];

}

//0.新浪支付的身份验证
-(void)validate_identity{
    
    //    realName--真实姓名
    //    certno--证件号码
    NSDictionary *params = @{@"realname":@"辛乐",
                             @"certno":@"150626198705271333"};
    
    [GGHttpTool post:[Util getSinaBangdingUrlBytype:validate_identity] params:params success:^(id responseObj) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"response_code"] isEqualToString:@"VALIDATE_TRUE"]) {
            
            LOG(@"~~~~~~~~身份证验证正确");
        }else{
            [Util showHUDAddTo:self.view Text:dic[@"response_message"]];
            return ;
        }
    } failure:^(NSError *error) {
        
        LOG(@"%@",error);
        
    }];
}


//买涨
- (IBAction)buyUp:(id)sender {
    
//    [Util goToDealFromeType:DealFromTypeBuyUpBtn Code:@"GDAG"];
    
//    //绑定银行卡推进 -- 绑卡成功
//    RiskAgreeViewController *agree = [[RiskAgreeViewController alloc] init];
//    agree.title = @"签署协议";
//    agree.textFileName = @"riskAgree";
//    [self.navigationController pushViewController:agree animated:YES];
    
    
//    [self validate_identity];
    
    BOOL b = [Util validatePhoneNumber:@"152164173171"];
    LOG(@"~~~~~~~~%d",b);
    
}

//买跌
- (IBAction)buyDown:(id)sender {
    
     [Util goToDealFromeType:DealFromTypeBuyDownBtn Code:@"GDPD"];
}


- (IBAction)holdOrder:(id)sender {
    
//    NSTimeInterval endDate = [[NSDate date] timeIntervalSince1970];
//    NSTimeInterval beginDate = endDate - 30 * 24 * 60 * 60;
    
//    [[DealSocketTool shareInstance] GET_CUSTMTRADEREPORTHOLDPOSITOINByBeginDate:beginDate EndDate:endDate WithResultArrBlock:^(NSArray<CustmTradeReportHoldPositionInfoModel *> *modelArr) {
//        
//        LOG(@"~~~~~~~历史持仓单查询:%@",modelArr);
//    }];
    
//    //简化开户
//    ChooseBankViewController *normalVC = [[ChooseBankViewController alloc] init];
//    [self.navigationController pushViewController:normalVC animated:YES];
    
    XLHUDView *hud = [XLHUDView shareInstance];
    [hud show];
    
}
- (IBAction)closeOrder:(id)sender {
    
    XLHUDView *hud = [XLHUDView shareInstance];
    [hud hide];
    
    
    NSTimeInterval endDate = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval beginDate = endDate - 30 * 24 * 60 * 60;
    [[DealSocketTool shareInstance] GET_CUSTMTRADEREPORTCLOSEPOSITOINBeginDate:beginDate EndDate:endDate WithResultArrBlock:^(NSArray<ClosePositionInfoModel *> *modelArr) {
        
        LOG(@"~~~~~~~历史平仓单查询:%@",modelArr);
    }];
}
- (IBAction)limitOrder:(id)sender {
    
    NSTimeInterval endDate = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval beginDate = endDate - 30 * 24 * 60 * 60;
    [[DealSocketTool shareInstance] GET_CUSTMTRADEREPORTLIMITORDERBeginDate:beginDate EndDate:endDate WithResultArrBlock:^(NSArray<LimitOrderInfoModel *> *modelArr) {
         LOG(@"~~~~~~历史限价单:%@",modelArr);
    }];
     
}

- (IBAction)nowCloseOrder:(id)sender {
    
    [[DealSocketTool shareInstance] getClosePositionInfoWithBlock:^(NSArray<ClosePositionInfoModel *> *modelArr) {
        
        LOG(@"~~~~~~实时平仓单:%@",modelArr);
    }];
}

- (IBAction)nowHoldOrder:(id)sender {
    
    [[DealSocketTool shareInstance] getHoldPositionInfoWithBlock:^(NSArray<HoldPositionInfoModel *> *modelArr) {
        
        LOG(@"~~~~~~实时持仓单:%@",modelArr);
    }];
}


- (IBAction)nowLimitOrder:(id)sender {
    
    [[DealSocketTool shareInstance] getLimitOrderInfoWithBlock:^(NSArray<LimitOrderInfoModel *> *modelArr) {
        
        LOG(@"~~~~~~实时限价单:%@",modelArr);
    }];
    
    MyTransferResultViewController *vc = [[MyTransferResultViewController alloc] init];
    vc.price = @"100";
    vc.isSuccessAmount = YES;
    [self.navigationController pushViewController:vc animated:YES];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
#pragma pack(8)
   
    
    
    LOG(@"ansPackHead:%ld,ansUserAcc:%ld,AccountInfo:%ld,CommodityInfo:%ld,OpenOrderConf:%ld,OpenMarketOrderConf:%ld,CloseMarketOrderConf:%ld,OpenLimitOrderConf:%ld,LimitClosePositionConf:%ld,ChangePWD:%ld,ChangeFundPWD:%ld,OpenMarketOrderParam:%ld,OpenLimitOrderParam:%ld,HoldPositionTotalInfo:%ld,CloseMarketOrderParam:%ld,CloseMarketOrderManyParam:%ld,CloseLimitOrderParam:%ld,LimitRevokeParam:%ld,BourseMoneyInfo:%ld,MoneyInOutParam:%ld,MoneyInOutInfo:%ld,FundFlowQueryParam:%ld,FundFlowQueryInfo:%ld,SysBulletinInfo:%ld,SignResultNotifyQueryParam:%ld,ProcessResult:%ld,PayForwardParam:%ld,RealTimeQuote:%ld,ReportQueryParam:%ld,CustmTradeReportHoldPositionInfo:%ld,CustmTradeReportClosePositionInfo:%ld,CustmTradeReportLimitOrderInfo:%ld,LimitOrderInfo:%ld,ClosePositionInfo:%ld,HoldPositionInfo:%ld",sizeof(ansPackHead),sizeof(ansUserAcc),sizeof(AccountInfo),sizeof(CommodityInfo),sizeof(OpenOrderConf),sizeof(OpenMarketOrderConf),sizeof(CloseMarketOrderConf),sizeof(OpenLimitOrderConf),sizeof(LimitClosePositionConf),sizeof(ChangePWD),sizeof(ChangeFundPWD),sizeof(OpenMarketOrderParam),sizeof(OpenLimitOrderParam),sizeof(HoldPositionTotalInfo),sizeof(CloseMarketOrderParam),sizeof(CloseMarketOrderManyParam),sizeof(CloseLimitOrderParam),sizeof(LimitRevokeParam),sizeof(BourseMoneyInfo),sizeof(MoneyInOutParam),sizeof(MoneyInOutInfo),sizeof(FundFlowQueryParam),sizeof(FundFlowQueryInfo),sizeof(SysBulletinInfo),sizeof(SignResultNotifyQueryParam),sizeof(ProcessResult),sizeof(PayForwardParam),sizeof(RealTimeQuote),sizeof(ReportQueryParam),sizeof(CustmTradeReportHoldPositionInfo),sizeof(CustmTradeReportClosePositionInfo),sizeof(CustmTradeReportLimitOrderInfo),sizeof(LimitOrderInfo),sizeof(ClosePositionInfo),sizeof(HoldPositionInfo));
    
    
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
