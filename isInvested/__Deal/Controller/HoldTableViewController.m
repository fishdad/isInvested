//
//  HoldTableViewController.m
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "HoldTableViewController.h"
#import "HoldTableViewCell.h"
#import "HoldTableHeadView.h"
#import "PopHoldDealView.h"
#import "MyAssetsViewController.h"
#import "DealViewController.h"
#import "NoDataView.h"

@interface HoldTableViewController ()
@property (nonatomic, assign) NSInteger page_index;
@property (nonatomic, strong) HoldTableHeadView *headView;
@property (nonatomic, strong) NSArray<HoldPositionTotalInfoModel *> *modelArr;
@property (nonatomic, assign) double HoldPriceTotal;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NoDataView *noDataView;

@end

@implementation HoldTableViewController

-(BOOL)isCurrentViewControllerVisible{

     return (self.isViewLoaded && self.view.window);
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self timerInvalte];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
        
        DealViewController *vc = (DealViewController *)dealVC;
        if (vc.contentScrollView.contentOffset.x / WIDTH == 2) {
            
            if (_timer == nil) {
                [self timerFire];
            }
        }
    }];
}

-(NSTimer *)timer{

    if (_timer == nil) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(openTimerFire) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(void)openTimerFire{

    if ([[DealSocketTool shareInstance] connectToRemote]) {
        //                LOG(@"~~~~~~~~~~~~~~~~~~~~getAccntInfoWithisHUDHidden");
        [self getAccntInfoWithisHUDHidden:YES];
    }
}

-(void)timerFire{

    //获取市场开休市状态
    [[DealSocketTool shareInstance] getMarketstatusWithStatusBlock:^(unsigned short isSuccess, NSString *statusStr) {
        
        if (isSuccess == 0) {//休市返回
            [self openTimerFire];
        }else{
            //开市循环
            [self.timer fire];
        }
    }];
}

-(void)timerInvalte{
    
    [self.timer invalidate];
    self.timer = nil;
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//表头
-(void)setTableViewHeaderView{

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    
    _headView = [[HoldTableHeadView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    _headView.frame = CGRectMake(0, 10, WIDTH, _headView.realHeight);
    WEAK_SELF
    _headView.touchBlock = ^(){
        //账户资产
        MyAssetsViewController *vc = [[MyAssetsViewController alloc] init];
        vc.fromType = 1;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    backView.frame = CGRectMake(0, 0, WIDTH, _headView.realHeight + 20);
    [backView addSubview:_headView];
    self.tableView.tableHeaderView = backView;
}
////下拉刷新,上拉刷新
-(void)refushData{
    WEAK_SELF
    [weakSelf getAccntInfoWithisHUDHidden:NO];//获取账号信息
    [weakSelf getDataListByPageIndex:1];
}

-(void)setMJRefush{

    WEAK_SELF
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf refushData];
    }];
    [header setTitle:@"下拉刷新最新的持仓信息" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新最新的持仓信息" forState:MJRefreshStatePulling];
    weakSelf.tableView.mj_header = header;
    //    //上拉加载
    //    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        // 进入刷新状态后会自动调用这个block
    //        weakSelf.page_index ++;
    //        [weakSelf getDataListByPageIndex:weakSelf.page_index];
    //    }];

}

//登录成功 -- 数据拉取
-(void)getAccntInfo{
    [self getAccntInfoWithisHUDHidden:NO];
}
-(void)getAccntInfoWithisHUDHidden:(BOOL)isHUDHidden{
    
    //个人资产
    [[DealSocketTool shareInstance] getAccntInfoWithBlock:^(AccountInfoModel *model) {
        [_headView reloadViewByAccountInfoModel:model];
    } isHUDHidden:isHUDHidden];
    //获取持仓信息
    [[DealSocketTool shareInstance] GET_HOLDPOSITIONTOTALWithBlock:^(NSArray<HoldPositionTotalInfoModel *> *modelArr) {
        
        self.modelArr = nil;
        NSArray *arr = [NSArray arrayWithArray:modelArr];
        _HoldPriceTotal = 0;
        for (HoldPositionTotalInfoModel *model in arr) {
            _HoldPriceTotal = _HoldPriceTotal + model.HoldPriceTotal.doubleValue;//持仓总值累计
        }
        self.modelArr = arr;
        //LOG(@"~~~~~获取持仓~~~~");
        [self.tableView reloadData];
        //*****批量平仓内页的刷新
        PopHoldDealView *view = [[Util appWindow] viewWithTag:1001];
        if (view &&[view isKindOfClass:[PopHoldDealView class]] && view.refushBlock) {
            view.refushBlock(modelArr);
        }
        
        
    } isHUDHidden:isHUDHidden];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //没有数据
    _noDataView = [NoDataView defaultNoDataView];
    _noDataView.hidden = YES;
    _noDataView.imgView.center = CGPointMake(WIDTH / 2, (HEIGHT - 64 - 37) / 2);
    [self.view addSubview:_noDataView];
    
    //登录成功 -- 进行数据的拉取
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerFire) name:@"SignSuccess" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[HoldTableViewCell class] forCellReuseIdentifier:@"holdCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setTableViewHeaderView];
    [self setMJRefush];
    
    //限价单成交公告
    [[DealSocketTool shareInstance] PUSH_SYSBUL_LIMITCLOSEWithBlock:^(SysBulletinInfoModel *model) {
        
        //BulletinHeader;///< 公告消息头 //BulletinContent;///< 公告消息正文
        [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
            [Util alertViewWithTitle:model.BulletinHeader Message:model.BulletinContent Target:dealVC];
        }];
    }];
}

-(void)getDataListByPageIndex:(NSInteger)index{
    WEAK_SELF
    [weakSelf.tableView.mj_header endRefreshing];
    [weakSelf.tableView.mj_footer endRefreshing];
    [weakSelf.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger count = self.modelArr.count;
    if (count > 0) {
        _noDataView.hidden = YES;
    }else{
        _noDataView.hidden = NO;
    }
    return count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 162 + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"holdCell" forIndexPath:indexPath];
    
    HoldPositionTotalInfoModel *model = self.modelArr[indexPath.row];
    //model 赋值
    cell.model = model;
    //平仓事件
    cell.titleView.actionBlock = ^(){
        
        if ([[DealSocketTool shareInstance] connectToRemote]) {
            if (model != nil && [model isKindOfClass:[HoldPositionTotalInfoModel class]]) {
                [self popHoldDealViewWithModel:model];
            }
        }else{
            [Util alertViewWithMessage:NETWORK_WEAK Target:self];
        }
    };
    
    return cell;
}
//平仓弹窗
-(void)popHoldDealViewWithModel:(HoldPositionTotalInfoModel *)model{

    PopHoldDealView *view = [[PopHoldDealView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) Model:model];
    view.tag = 1001;
    view.refushHoldToalBlock = ^(){
        [self refushData];
    };
    view.type =  model.OpenDirector - 1;//交易方向类型
    UIViewController *vc = [[UIViewController alloc] init];
    view.target = vc;
    vc.view = view;
    [[Util appWindow] addSubview:vc.view];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (self.modelArr.count > 0) {
        return 34;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 34)];
    sectionHead.backgroundColor = OXColor(0xf5f5f5);
    
    CGFloat wSpace = 10;
    CGFloat hSpace = 2;
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(wSpace, hSpace, 80, 30);
    label1.text = @"持仓商品";
    label1.font = FONT(13);
    [sectionHead addSubview:label1];

    CGFloat label2W = WIDTH - 2 * wSpace - 80;
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(NW(label1), hSpace, label2W, 30);
    label2.textAlignment = NSTextAlignmentRight;
    label2.attributedText = [Util setFirstString:@"总成本" secondString:[NSString stringWithFormat:@"%.2f",_HoldPriceTotal] threeString:@"元" firsColor:OXColor(0x999999) secondColor:[UIColor blackColor] threeColor:OXColor(0x999999) firstFont:FONT(13) secondFont:FONT(13) threeFont:FONT(13)];
    [sectionHead addSubview:label2];

    [sectionHead addSubview:[Util setUpLineWithFrame:CGRectMake(0, 0, WIDTH, 0.5)]];
    [sectionHead addSubview:[Util setUpLineWithFrame:CGRectMake(0, 33.5, WIDTH, 0.5)]];
    
    return sectionHead;
}


@end
