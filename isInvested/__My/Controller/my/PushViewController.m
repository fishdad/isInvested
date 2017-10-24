//
//  PushViewController.m
//  isInvested
//
//  Created by Ben on 16/8/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "PushViewController.h"
#import "SwitchTableViewCell.h"


@interface PushViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong) UITableView *tv;
@property(nonatomic,strong) NSDictionary *dataDic;

@end


@implementation PushViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推送设置";
    
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
    
    _dataDic = @{@"0":@[@"资讯推送",@"消息提醒推送"]};
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
    
    //资讯推送
    if ((indexPath.section == 0 && indexPath.row == 0)) {
        cell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil switchOn:YES switchBlock:^(BOOL isON) {
            
            NSLog(@"资讯推送:%i",isON);
            
        }];
    }
    
    //指纹解锁
    if ((indexPath.section == 0 && indexPath.row == 1)) {
        cell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil switchOn:YES switchBlock:^(BOOL isON) {
            
            NSLog(@"消息提醒推送:%i",isON);
        }];
    }
    
    cell.textLabel.text = _dataDic[[NSString stringWithFormat:@"%li",indexPath.section]][indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
