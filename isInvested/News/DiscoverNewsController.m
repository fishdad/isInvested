//
//  DiscoverNewsController.m
//  isInvested
//
//  Created by Blue on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "DiscoverNewsController.h"
#import "FinanceNewsCell.h"
#import "NewsMessage.h"

@interface DiscoverNewsController ()<UITabBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<NSMutableArray<NewsMessage *> *> *data;
@property (nonatomic, strong) NSMutableArray<NSString *> *headerTitles;
@property (nonatomic, strong) UIImageView *notNetView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DiscoverNewsController

- (UIImageView *)notNetView {
    if (!_notNetView) {
        _notNetView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notNetwork"]];
        _notNetView.center = CGPointMake(WIDTH / 2, HEIGHT / 2 - 64);
        _notNetView.userInteractionEnabled = YES;
        [_notNetView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshNetwork)]];
    }
    return _notNetView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"快讯";
    [self refreshNetwork];
}

- (void)addRefreshHeaderAndFooter {
    WEAK_SELF
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf requestNewsDataWithTime:nil];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestNewsDataWithTime:weakSelf.data.lastObject.lastObject.UpdateTime];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FinanceNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FinanceNewsCell"];
    if (!cell) cell = [[NSBundle mainBundle] loadNibNamed:@"FinanceNewsCell" owner:self options:nil][0];
    
    cell.model = self.data[indexPath.section][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = FONT(12.0);
    button.backgroundColor = OXColor(0xf0f0f0);
    [button setTitleColor:OXColor(0x999999) forState:UIControlStateNormal];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNewsSectionHeaderHeight - 0.5, WIDTH, 0.5)];
    line.backgroundColor = OXColor(0xe6e6e6);
    [button addSubview:line];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    NSString *title = section < 3 ? [self.headerTitles[section] dateAppendingToday] : self.headerTitles[section];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.data[indexPath.section][indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.data[indexPath.section][indexPath.row] setIsShowGray:YES];
    [self.data[indexPath.section][indexPath.row] performSelector:@selector(exchange2heightValue)];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/** 请求快讯 */
- (void)requestNewsDataWithTime:(NSString *)updateTime {
    [HUDTool showToView:self.view];
    
    NSDictionary *params = @{ @"op" : @"getlistbefore",
                              @"p1" : PRIORITY(updateTime, [@"yyyy-MM-dd HH:mm:ss" currentTime]),
                              @"p2" : @20,
                              @"p3" : @"" };
    WEAK_SELF
    [HttpTool post:URL_NEWS params:params success:^(id responseObj) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [HUDTool hideForView:weakSelf.view];
        
        NSArray *array = [NewsMessage mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        [weakSelf processDataWithArray:array withTime:updateTime];
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [HUDTool hideForView:weakSelf.view];
        [HUDTool showText:kRequestTimeout];
    }];
}

/** 处理 刷新 & 加载更多 得到的数组 */
- (void)processDataWithArray:(NSArray<NewsMessage *> *)sortData withTime:(NSString *)updateTime {
    
    if (!updateTime) { //刷新
        self.headerTitles = [NSMutableArray array];
        [self.headerTitles addObject:sortData[0].days];
        
        self.data = [NSMutableArray array];
        [self.data addObject:[NSMutableArray array]];
    }
    
    NSInteger count = sortData.count;
    for (NSInteger i = 0; i < count; i++) {
        
        if (![self.headerTitles.lastObject isEqualToString:sortData[i].days]) {
            [self.headerTitles addObject:sortData[i].days];
            [self.data addObject:[NSMutableArray array]];
        }
        [self.data.lastObject addObject:sortData[i]];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView reloadData];
    [self.notNetView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    [self addRefreshHeaderAndFooter];
}

#pragma mark - 点击事件

- (void)refreshNetwork {
    if ([HttpTool networkStatus]) {
        [self requestNewsDataWithTime:nil];
    } else {
        [self.view addSubview:self.notNetView];
    }
}

@end
