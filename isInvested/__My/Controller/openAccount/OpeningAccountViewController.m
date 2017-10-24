//
//  OpeningAccountViewController.m
//  isInvested
//
//  Created by Ben on 16/9/6.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "OpeningAccountViewController.h"
#import "RiskTableViewController.h"


@interface OpeningAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation OpeningAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //开户完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedBack) name:@"complantOpenAccount" object:nil];
    self.title = @"开户须知";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTv];
}

//tv初始化
-(void)initTv{

    _dataArr = @[@"开户必须完成并通过风险评估测试;",
                 @"开户需上传二代身份证正反面提交审核,请提前准备好二代身份证件;",
                 @"初次交易时,账户资金需高于2000元(仅在初次交易时做资金限制);",
                 @"开户完成后,当天可入金、交易(交易日);",
                 @"在牛奶金服平台进行粤贵银交易,单笔交易上限为1000KG,持仓上限为1200KG。"];
    
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_tv];
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCell"];
    
    WEAK_SELF
    _tv.delegate = (id)weakSelf;
    _tv.dataSource = (id)weakSelf;
    
    UIBarButtonItem *left =  [UIBarButtonItem itemWithTarget:self action:@selector(clickedBack) image:@"back"];
    self.navigationItem.leftBarButtonItem = left;
}

-(void)clickedBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

    


#pragma mark -- tv的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return  60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    
    cell.imageView.image = [Util OriginImage:[UIImage imageNamed:@"kaihu_icon"] scaleToSize:CGSizeMake(20, 20)];
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, (60 - 44) / 2.0, WIDTH - 30, 44);
    [btn setTitle:@"立即开户" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    btn.layer.borderWidth = 1;
    [view addSubview:btn];

    return view;
}

-(void)btnClick:(UIButton *)btn{
    
    RiskTableViewController *normalVC = [[RiskTableViewController alloc] init];
    [self.navigationController pushViewController:normalVC animated:YES];

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
