//
//  ExchangeViewController.m
//  isInvested
//
//  Created by Ben on 16/8/16.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ChangePassWordViewcontroller.h"
#import "GetCodeViewController.h"
#import "LoginViewController.h"
#import "IINavigationController.h"
#import "SignerViewController.h"

@interface ExchangeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong) UITableView *tv;
@property(nonatomic,strong) NSDictionary *dataDic;

@end


@implementation ExchangeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"交易所信息变更";
    
    [self initTv];
}

//tv初始化
-(void)initTv{
    
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_tv];
    
    WEAK_SELF
    _tv.delegate = weakSelf;
    _tv.dataSource = weakSelf;
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    _tv.tableFooterView = footView;
    
    _dataDic = @{@"0":@[@"修改交易密码",@"重置交易密码"],
                 @"1":@[@"修改资金密码",@"重置资金密码"]};
}

#pragma mark -- tv的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataDic.allKeys.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataDic[[NSString stringWithFormat:@"%li",section]] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell ;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    cell.textLabel.text = _dataDic[[NSString stringWithFormat:@"%li",indexPath.section]][indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
    
        if (![[DealSocketTool shareInstance] connectToRemote]) {
            //身份验证
            SignerViewController *vc = [[SignerViewController alloc]init];
            vc.signerType = SignerTypeNone;
            vc.appearType = AppearTypePush;
            vc.returnBlock = ^(BOOL isSuccess){
                
//                [NSUserDefaults setBool:isSuccess forKey:[Util isSHPassWord]];
                if (isSuccess == YES) {
                    //修改密码
                    ChangePassWordViewcontroller *vc = [[ChangePassWordViewcontroller alloc] init];
                    vc.vcType = indexPath.section;
                    [self.navigationController pushViewController:vc animated:NO];
                }
            };
            
            [self.navigationController pushViewController:vc animated:NO];
        }else{
            //修改密码
            ChangePassWordViewcontroller *vc = [[ChangePassWordViewcontroller alloc] init];
            vc.vcType = indexPath.section;
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
    
    if (indexPath.row == 1) {
        //重置密码
        GetCodeViewController *vc = [[GetCodeViewController alloc] init];
        vc.vcType = indexPath.section;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
