//
//  HomeViewController.m
//  isInvested
//
//  Created by Blue on 16/8/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeaderView.h"
#import "FinanceNewsCell.h"
#import "CalendarCell.h"
#import "NewsMessage.h"
#import "CalendarMessage.h"
#import "SimpleWebViewController.h"
#import "SocketTool.h"
#import "LoginViewController.h"
#import "IINavigationController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HomeHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray<NSString *> *headerTitles;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NewsMessage *> *> *newsData;
@property (nonatomic, strong) NSMutableArray<CalendarMessage *> *calendarData;
@property (nonatomic, strong) UIImageView *nullView;
@property (nonatomic, strong) UIImageView *notNetView;

@property (nonatomic, copy) NSString *selectDate; //选中的日历日期, 下拉刷新请求时用
@property (nonatomic, assign) BOOL isNewsPage;
/** 保存Y值, 滚动悬停时判断用 */
@property (nonatomic, assign) CGFloat titleViewY;
/** 快讯 & 日历 切换之前, 移出屏幕外的y值 */
@property (nonatomic, assign) CGFloat newsOffsetY;
@property (nonatomic, assign) CGFloat calendarOffsetY;
/** suspensionBar */
@property (weak, nonatomic) IBOutlet UIView *suspensionBarView;
@property (weak, nonatomic) IBOutlet UIButton *suspensionBarButton;
@end

@implementation HomeViewController

- (UIImageView *)notNetView {
    if (!_notNetView) {
        _notNetView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notNetwork"]];
        _notNetView.center = CGPointMake(WIDTH / 2, HEIGHT / 2 - 64);
        _notNetView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshNetwork)];
        [_notNetView addGestureRecognizer:tap];
    }
    return _notNetView;
}

- (UIImageView *)nullView {
    if (!_nullView) {
        _nullView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"null_data"]];
        _nullView.contentMode = UIViewContentModeCenter;
        _nullView.centerX = WIDTH / 2;
        _nullView.centerY = self.headerView.titleView.bottom + 55.5 + 98;
    }
    return _nullView;
}

- (HomeHeaderView *)headerView {
    if (!_headerView) {
        WEAK_SELF
        _headerView = [[HomeHeaderView alloc] init];
        self.titleViewY = _headerView.titleView.y;
        
        _headerView.eventView.objc1 = ^(){ //请求大事件后, 显示调用此block
            weakSelf.headerView.eventView.hidden = NO;
            weakSelf.headerView.titleView.y = weakSelf.headerView.eventView.bottom + kPadding;
            weakSelf.headerView.height = weakSelf.headerView.titleView.bottom + 0.5;
            weakSelf.tableView.tableHeaderView = weakSelf.headerView; //ios8需要此方法, 以后的系统不需要
            weakSelf.titleViewY = weakSelf.headerView.titleView.y;
        };
        _headerView.eventView.objc2 = ^(){ //大事件结束后, 隐藏大事件view
            weakSelf.headerView.eventView.hidden = YES;
            weakSelf.headerView.titleView.y = weakSelf.headerView.preview.bottom + kPadding;
            weakSelf.headerView.height = weakSelf.headerView.titleView.bottom + 0.5;
            weakSelf.tableView.tableHeaderView = weakSelf.headerView; //ios8需要此方法, 以后的系统不需要
            weakSelf.titleViewY = weakSelf.headerView.titleView.y;
        };
        _headerView.titleView.objc1 = ^(){ //点击快讯
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            weakSelf.nullView.hidden = YES; //快讯页永远有数据, 不可能会用到
            [weakSelf addTableViewFooter];
            
            // 切换之前保存 tableView.contentOffset.y 移出屏幕外的值
            // 不保存<0的值, 为避免标题栏没置顶时, 往下滚动
            CGFloat y = weakSelf.tableView.contentOffset.y - weakSelf.titleViewY;
            weakSelf.calendarOffsetY = y > 0 ? y : 0;
            
            // 标题栏两边显示的高度不一样,切换后必须变更
            weakSelf.headerView.height -= 55;
            [weakSelf.tableView reloadData];
            
            // 标题栏已经置顶了, 才需要将cell滚动至离开之前的位置
            // 标题栏没置顶时, cell肯定在首行, 无需滚动
            // y=0 就是标题栏刚刚置顶时, 此时也需要滚动
            if (y >= 0) {
                [weakSelf.tableView setContentOffset:
                 CGPointMake(0, weakSelf.titleViewY + weakSelf.newsOffsetY) animated:NO];
            }
        };
        
        _headerView.titleView.objc2 = ^(){ //点击日历
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            weakSelf.nullView.hidden = NO;
            [weakSelf removeTableViewFooter];
            
            CGFloat y = weakSelf.tableView.contentOffset.y - weakSelf.titleViewY;
            weakSelf.newsOffsetY = y > 0 ? y : 0;
            
            weakSelf.headerView.height += 55;
            [weakSelf.tableView reloadData];
            
            if (y >= 0) {
                [weakSelf.tableView setContentOffset:
                 CGPointMake(0, weakSelf.titleViewY + weakSelf.calendarOffsetY) animated:NO];
            }
        };
        
        /** 点击了7天中的不同日期 */
        _headerView.titleView.calendarView.clickedDayBlock = ^(NSString *ymd){
            weakSelf.selectDate = ymd;
            
            weakSelf.tableView.tableFooterView = nil;
            [weakSelf requestCalendarDataWithDate:ymd];
        };
    }
    return _headerView;
}

- (BOOL)isNewsPage {
    return self.headerView.titleView.newsButton.isSelected;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    BOOL login = [NSUserDefaults boolForKey:isLogin];
    BOOL sign = [NSUserDefaults boolForKey:isSinaAccountBangding];
    self.suspensionBarView.hidden = login && sign;
    [self setupSuspensionBar];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[SocketTool sharedSocketTool] setIndexes:[IndexTool indexesWithSection:0]];
    [[SocketTool sharedSocketTool] setRequestStyle:SocketRequestStyleRealTimeAndPush];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tlm_title"]];
    self.tableView.tableHeaderView = self.headerView;
    
    self.selectDate = [@"yyyy-MM-dd HH:mm:ss" currentTime];
    
    [self refreshNetwork];
    [self addTableViewHeader];
}

- (void)requestNewData {
    //请求最新数据
    if (self.isNewsPage) {
        [self requestNewsDataWithTime:nil];
    } else {
        [self requestCalendarDataWithDate:self.selectDate];
    }
    [self.headerView.playerView requestPictures];
}

#pragma mark - RefreshHeader & Footer

- (void)addTableViewHeader {
    WEAK_SELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isNewsPage) {
            [weakSelf requestNewsDataWithTime:nil];
        } else {
            [weakSelf requestCalendarDataWithDate:self.selectDate];
        }
        [weakSelf.headerView.eventView requestBigEvent];
        [weakSelf.headerView.playerView requestPictures];
    }];
}

- (void)addTableViewFooter {
    WEAK_SELF
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestNewsDataWithTime:weakSelf.newsData.lastObject.lastObject.UpdateTime];
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)removeTableViewFooter {
    self.tableView.mj_footer = nil;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isNewsPage ? self.newsData.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isNewsPage ? self.newsData[section].count : self.calendarData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID; id param;
    
    if (self.isNewsPage) {
        ID = @"FinanceNewsCell";
        param = self.newsData[indexPath.section][indexPath.row];
    } else {
        ID = @"CalendarCell";
        param = self.calendarData[indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil][0];
    [cell performSelector:@selector(setModel:) withObject:param];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //快讯
    if (self.isNewsPage) return self.newsData[indexPath.section][indexPath.row].cellHeight;
    //日历, ios10以下
    if (IOS_VERSION < 10.0 && !indexPath.row) return 98.0 + 55.0; //日历栏view高度==55
    //日历, ios10
    return 98.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isNewsPage) { // 快讯
        [self.newsData[indexPath.section][indexPath.row] setIsShowGray:YES];        
        [self.newsData[indexPath.section][indexPath.row] performSelector:@selector(exchange2heightValue)];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } else { // 日历
        SimpleWebViewController *vc = [[SimpleWebViewController alloc] init];
        vc.url = self.calendarData[indexPath.row].FinanceUrl;
        vc.navigationItem.title = @"日历正文";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.isNewsPage ? kNewsSectionHeaderHeight : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!self.isNewsPage) return nil;
    
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

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView { //LOG(@"scrollView.contentOffset.y==%f", scrollView.contentOffset.y);
    
    CGFloat bottomInset = self.suspensionBarView.hidden ? 0 : 40;
    
    if (self.headerView.titleView.y && scrollView.contentOffset.y >= self.titleViewY) { //悬停
        self.headerView.titleView.y = 0;
        [self.view addSubview:self.headerView.titleView];
        self.tableView.contentInset = UIEdgeInsetsMake(36, 0, bottomInset, 0); //使日期栏不被挡住, 向下偏移36
        self.headerView.preview.tag = 1;
        
    } else if (!self.headerView.titleView.y && scrollView.contentOffset.y < self.titleViewY) { //恢复
        self.headerView.titleView.y = self.titleViewY;
        [self.headerView addSubview:self.headerView.titleView];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomInset, 0); //日期栏不置顶时, 将偏移值置0
        self.headerView.preview.tag = 0;
    }
}

#pragma mark - 网络请求

/** 请求快讯 */
- (void)requestNewsDataWithTime:(NSString *)updateTime {
    
    NSDictionary *params = @{ @"op" : @"getlistbefore",
                              @"p1" : PRIORITY(updateTime, [@"yyyy-MM-dd HH:mm:ss" currentTime]),
                              @"p2" : @20,
                              @"p3" : @"" };
    WEAK_SELF
    [HttpTool post:URL_NEWS params:params success:^(id responseObj) { //LOG(@"%@", responseObj[@"data"][0]);
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

/** 请求日历 */
- (void)requestCalendarDataWithDate:(NSString *)ymd {
    
    NSDictionary *params = @{ @"op" : @"getlist",
                              @"p1" : ymd,
                              @"p2" : @"" };
    WEAK_SELF
    [HttpTool post:URL_CALENDAR params:params success:^(id responseObj) { //LOG(@"%@", responseObj[@"data"][0]);
        [weakSelf.tableView.mj_header endRefreshing];
        [HUDTool hideForView:weakSelf.view];
        
        NSArray *array = [CalendarMessage mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        if (!array.count) {
            weakSelf.calendarData = [NSMutableArray arrayWithCapacity:2];
            [weakSelf.calendarData addObject:[[CalendarMessage alloc] init]];
            [weakSelf.calendarData addObject:[[CalendarMessage alloc] init]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView addSubview:weakSelf.nullView];
            weakSelf.nullView.hidden = weakSelf.isNewsPage;
            return;
        }
        [weakSelf.nullView removeFromSuperview];
        weakSelf.calendarData = [NSMutableArray arrayWithArray:array];
        [weakSelf.tableView reloadData];
        
        // 当日历条置顶时, 才滚动cell至首行
        // 当日历条没置顶时, 原cell就在首行, 无需滚动cell
        CGFloat y = weakSelf.tableView.contentOffset.y - weakSelf.titleViewY;
        if (y > 0) {
            [weakSelf.tableView setContentOffset:CGPointMake(0, weakSelf.tableView.contentOffset.y - y) animated:YES];
        }
        
    } failure:^(NSError *error) { LOG_ERROR
        [weakSelf.tableView.mj_header endRefreshing];
        [HUDTool hideForView:weakSelf.view];
        [HUDTool showText:kRequestTimeout];
    }];
}

#pragma mark - suspensionBar

- (void)setupSuspensionBar {
    BOOL login = [NSUserDefaults boolForKey:isLogin];
    [self.suspensionBarButton setTitle:login ? @"立即开户" : @"立即登录" forState:UIControlStateNormal];
}

- (IBAction)clickedSuspensionBarButton {
    
    if (![NSUserDefaults boolForKey:isLogin]) {
        LoginViewController *loginVC =[[LoginViewController alloc] init];
        IINavigationController *loginNav = [[IINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNav animated:YES completion:nil];
    } else {
        [Util goToDeal];
    }
}

- (void)refreshNetwork {
    
    if ([HttpTool networkStatus]) {
        [HUDTool showToView:self.view];
        [self requestNewsDataWithTime:nil];
        [self requestCalendarDataWithDate:self.selectDate];
        self.tableView.hidden = NO;
        [self.notNetView removeFromSuperview];
        
    } else {
        self.tableView.hidden = YES;
        [self.view addSubview:self.notNetView];
    }
}

/** 处理 刷新 & 加载更多 得到的数组 */
- (void)processDataWithArray:(NSArray<NewsMessage *> *)sortData withTime:(NSString *)updateTime {
    
    if (!updateTime) { //刷新
        self.headerTitles = [NSMutableArray array];
        [self.headerTitles addObject:sortData[0].days];
        
        self.newsData = [NSMutableArray array];
        [self.newsData addObject:[NSMutableArray array]];
    }
    
    NSInteger count = sortData.count;
    for (NSInteger i = 0; i < count; i++) {
        
        if (![self.headerTitles.lastObject isEqualToString:sortData[i].days]) {
            [self.headerTitles addObject:sortData[i].days];
            [self.newsData addObject:[NSMutableArray array]];
        }
        [self.newsData.lastObject addObject:sortData[i]];
    }
    [self.tableView reloadData];
    [self addTableViewFooter];
}

@end
