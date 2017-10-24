//
//  CalendarViewController.m
//  isInvested
//
//  Created by Blue on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCell.h"
#import "CalendarMessage.h"
#import "SimpleWebViewController.h"
#import "WeeklyCalendarView.h"

@interface CalendarViewController ()

@property (nonatomic, strong) NSMutableArray<CalendarMessage *> *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *calendarSuperView;
@property (nonatomic, strong) WeeklyCalendarView *calendarView;
/** 当前选中的日期,下拉刷新用 */
@property (nonatomic, copy) NSString *currentDate;
@property (nonatomic, strong) UIImageView *nullView;
@property (nonatomic, strong) UIImageView *notNetView;
@end

@implementation CalendarViewController

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
        _nullView.center = CGPointMake(WIDTH / 2, HEIGHT / 2 - 64 - 55);
    }
    return _nullView;
}

- (WeeklyCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [WeeklyCalendarView viewFromXid];
        WEAK_SELF
        self.currentDate = [@"yyyy-MM-dd" currentTime];
        _calendarView.clickedDayBlock = ^(NSString *day){
            
            weakSelf.currentDate = day;
            [weakSelf.data removeAllObjects];
            [weakSelf.tableView reloadData];
            
            [weakSelf refreshNetwork];
        };
    }
    return _calendarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"日历";
    self.currentDate = [@"yyyy-MM-dd" currentTime];
    
    [self refreshNetwork];
    [self.calendarSuperView addSubview:self.calendarView];
    
    WEAK_SELF
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf requestCalendarData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CalendarCell *cell = [[NSBundle mainBundle] loadNibNamed:@"CalendarCell" owner:self options:nil][0];
    cell.model = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SimpleWebViewController *vc = [[SimpleWebViewController alloc] init];
    vc.url = self.data[indexPath.row].FinanceUrl;
    vc.navigationItem.title = @"日历正文";
    [self.navigationController pushViewController:vc animated:YES];
}

/** 请求日历data */
- (void)requestCalendarData {
    
    [HUDTool showToView:self.view];
    
    NSDictionary *params = @{ @"op" : @"getlist",
                              @"p1" : self.currentDate,
                              @"p2" : @"" };
    WEAK_SELF
    [HttpTool post:URL_CALENDAR params:params success:^(id responseObj) {
        [weakSelf.tableView.mj_header endRefreshing];
        [HUDTool hideForView:weakSelf.view];
        
        weakSelf.data = [CalendarMessage mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        [weakSelf.tableView reloadData];
        
        weakSelf.tableView.scrollEnabled = YES;
        [weakSelf.notNetView removeFromSuperview];
        [weakSelf.nullView removeFromSuperview];
        
        if (!weakSelf.data.count) {
            [weakSelf.tableView addSubview:weakSelf.nullView];
        }
        
    } failure:^(NSError *error) { //LOG_ERROR
        [weakSelf.tableView.mj_header endRefreshing];
        [HUDTool hideForView:weakSelf.view];
        [HUDTool showText:kRequestTimeout];
    }];
}

#pragma mark - 点击事件

- (void)refreshNetwork {
    if ([HttpTool networkStatus]) {
        [self requestCalendarData];
    } else {
        [self.view addSubview:self.notNetView];
    }
}

@end
