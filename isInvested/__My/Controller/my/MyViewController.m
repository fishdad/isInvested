//
//  MyViewController.m
//  isInvested
//
//  Created by Blue on 16/8/8.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MyViewController.h"
#import "MyCenterViewController.h"
#import "PushViewController.h"
#import "LoginViewController.h"
#import "ExchangeViewController.h"
#import "IINavigationController.h"
#import "MyAssetsViewController.h"
#import "AboutViewController.h"
#import "MeaasgeTableViewController.h"
#import "UILabel+TextWidhtHeight.h"
#import "ChooseBankViewController.h"


#import "UnBindingViewController.h"


@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tv;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,strong) NSString *nickName;//昵称
@property (nonatomic,strong) NSString *account;//账号
@property (nonatomic,strong) NSDictionary *imgDic;

@end

@implementation MyViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].delegate.window.backgroundColor = kNavigationBarColor;
    self.navigationController.navigationBar.hidden = YES;
    
    [_tv reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:NO];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor blackColor];
    BOOL login = [NSUserDefaults boolForKey:isLogin];
    if (login) {
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTv];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

//tv初始化
-(void)initTv{

    self.navigationItem.title = @"";
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_tv];
    
     WEAK_SELF
    _tv.backgroundColor = GrayBgColor;
    _tv.delegate = weakSelf;
    _tv.dataSource = weakSelf;
    
//    _dataDic = @{@"0":@[@""],
//                 @"1":@[@"账户资产",@"消息提醒"],
//                 @"2":@[@"交易所信息变更",@"帮助中心"],
//                 @"3":@[@"推送设置",@"关于"]};
//    
//    _imgDic = @{@"0":@[@""],
//                @"1":@[@"my_assert",@"my_noticifation"],
//                @"2":@[@"my_change",@"my_help"],
//                @"3":@[@"my_setUp",@"my_about"]};
    
    //一期暂定的功能模块
    _dataDic = @{@"0":@[@""],
                 @"1":@[@"账户资产"],
                 @"2":@[@"交易所信息变更"],
                 @"3":@[@"推送设置",@"关于"]};
    
    _imgDic = @{@"0":@[@""],
                @"1":@[@"my_assert"],
                @"2":@[@"my_change"],
                @"3":@[@"my_setUp",@"my_about"]};

}

-(NSString *)nickName{

    NSString *str = [NSUserDefaults objectForKey:NickName] ;
    if (str == nil) {
        [NSUserDefaults setObject:@"登录/注册" forKey:NickName];
    }
    
    _nickName = [NSUserDefaults objectForKey:NickName];
    
    return _nickName;
}

-(NSString *)account{
    
    if ([NSUserDefaults objectForKey:Account] == nil) {
        [NSUserDefaults setObject:@"" forKey:Account];
    }
    
    _account = [NSUserDefaults objectForKey:Account];
    
    return _account;
}


#pragma mark -- tv的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataDic.allKeys.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_dataDic[[NSString stringWithFormat:@"%li",(long)section]] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 185;
    }else{
    
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }else{
        return 0.1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 15;
    }else{
        return 15;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell ;
     NSString *title = _dataDic[[NSString stringWithFormat:@"%li",(long)indexPath.section]][indexPath.row];
    
    if (indexPath.section == 0) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        }
        
        static dispatch_once_t onceToken;//防止循环复用
        dispatch_once(&onceToken, ^{
            self.backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,WIDTH,185)];
            self.backgroundView.userInteractionEnabled = YES;
            self.backgroundView.image = [UIImage imageNamed:@"mineHeadBack_Black"];
          
            self.headImaView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - 60)/2.0, 67, 60, 60)];
            [self.backgroundView addSubview:self.headImaView];
            
            self.headTitleLabel = [[UILabel alloc] init];
            self.headTitleLabel.frame = CGRectMake((WIDTH - 64)/2.0,self.headImaView.bottom + 15,64, 22);
            self.headTitleLabel.layer.borderWidth = 1.0;
            self.headTitleLabel.layer.borderColor = [OXColor(0xffffff) CGColor];
            self.headTitleLabel.layer.masksToBounds = YES;
            self.headTitleLabel.layer.cornerRadius = 3;
            self.headTitleLabel.textColor = OXColor(0xffffff);
            self.headTitleLabel.font = FONT(14);
            self.headTitleLabel.textAlignment = NSTextAlignmentCenter;
            [self.backgroundView addSubview:self.headTitleLabel];
            
        });
        
        [cell.contentView addSubview:self.backgroundView];
        
        self.headImaView.layer.masksToBounds = YES;
        self.headImaView.layer.cornerRadius = self.headImaView.width * 0.5;
        if ([self.nickName isEqualToString:@"登录/注册"]) {
            self.headTitleLabel.text = self.nickName;
            CGFloat lblW = [UILabel getWidthWithTitle:self.headTitleLabel.text font:FONT(14)] + 4;
            self.headTitleLabel.frame = CGRectMake((WIDTH - lblW)/2.0,self.headImaView.bottom + 15,lblW, 22);
            self.headImaView.image = [UIImage imageNamed:@"headImage"];
            
        }else{
            self.headTitleLabel.text = self.nickName;
            CGFloat lblW = [UILabel getWidthWithTitle:self.headTitleLabel.text font:FONT(14)] + 4;
            self.headTitleLabel.frame = CGRectMake((WIDTH - lblW)/2.0,self.headImaView.bottom + 15,lblW, 22);
            NSString *urlStr = [NSUserDefaults objectForKey:PhotoImgUrl];
            [[SDImageCache sharedImageCache]removeImageForKey:urlStr];
            UIImage *headImage = [Util getUserHeaderImage];
            [self.headImaView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:headImage];
        }



    }else{
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        }

        NSString *imgStr = _imgDic[[NSString stringWithFormat:@"%li",(long)indexPath.section]][indexPath.row];
        UIImage *originImage = [UIImage imageNamed:imgStr];
        cell.imageView.image = originImage;
        
        if ([title isEqualToString:@"消息提醒"]) {
            cell.detailTextLabel.text = @"10";
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
    }

    if (indexPath.section != 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = _dataDic[[NSString stringWithFormat:@"%li",(long)indexPath.section]][indexPath.row];
    cell.textLabel.font = FONT(15);
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *title = _dataDic[[NSString stringWithFormat:@"%li",(long)indexPath.section]][indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    if (indexPath.section == 0) {
        
        BOOL Login = [NSUserDefaults boolForKey:isLogin];
        
        if (Login != YES) {
        
            //登录
            LoginViewController *loginVC =[[LoginViewController alloc] init];
//            [self.navigationController pushViewController:loginVC animated:YES];
             IINavigationController*loginNav = [[IINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:loginNav animated:YES completion:nil];
            
        }else{
            //进入个人中心
            MyCenterViewController *myCenter = [[MyCenterViewController alloc] init];
            [self.navigationController pushViewController:myCenter animated:YES];
        }
        
    }
    
    if ([title isEqualToString:@"账户资产"]) {
        
        //1.判断是否登录
        BOOL login = [NSUserDefaults boolForKey:isLogin];
        if (login != YES) {
            //未登录
            LoginViewController *loginVC =[[LoginViewController alloc] init];
            IINavigationController*loginNav = [[IINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:loginNav animated:YES completion:nil];
            return;
        }else{
            //是否开户签约(以最后的签约为准)
            BOOL sign = [NSUserDefaults boolForKey:isSinaAccountBangding];// 是否新浪支付签约
            if (sign != YES) {
                [Util goToDeal];
                [Util alertViewWithMessage:@"请首先完成开户操作" Target:self];
                return;
            }
        }
        //账户资产
        MyAssetsViewController *vc = [[MyAssetsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    if ([title isEqualToString:@"消息提醒"]) {
       
        MeaasgeTableViewController *messageVC = [[MeaasgeTableViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }
    
    if ([title isEqualToString:@"推送设置"]) {
        //推送设置
        PushViewController *pushVC = [[PushViewController alloc] init];
        [self.navigationController pushViewController:pushVC animated:YES];
        
    }
    
    if ([title isEqualToString:@"交易所信息变更"]) {
        
        //1.判断是否登录
        BOOL login = [NSUserDefaults boolForKey:isLogin];
        if (login != YES) {
            //未登录
            LoginViewController *loginVC =[[LoginViewController alloc] init];
            IINavigationController*loginNav = [[IINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:loginNav animated:YES completion:nil];
            return;
        }else{
            //是否开户签约(以最后的签约为准)
            BOOL sign = [NSUserDefaults boolForKey:isSinaAccountBangding];// 是否新浪支付签约
            if (sign != YES) {
                [Util goToDeal];
                [Util alertViewWithMessage:@"请首先完成开户操作" Target:self];
                return;
            }
        }
        ExchangeViewController *exchangeVC = [[ExchangeViewController alloc] init];
        [self.navigationController pushViewController:exchangeVC animated:YES];
    }
    
    if ([title isEqualToString:@"关于"]) {
        
        AboutViewController *VC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
    }

}

-(void)dealloc{

    LOG(@"MyViewController销毁~~~~");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
