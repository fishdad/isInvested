//
//  CloseOutController.m
//  isInvested
//
//  Created by Blue on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//  平仓记录

#import "CloseOutController.h"
#import "PositionCell.h"
#import "ClosePositionInfoModel.h"

@interface CloseOutController ()

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *data;
@property (nonatomic, strong) NSMutableArray *headerTitles;
@property (nonatomic, strong) UIImageView *nullView;
@property (nonatomic, strong) NSArray *todayArray;
@end

@implementation CloseOutController

- (ChooseTimeView *)dateView {
    if (!_dateView) {
        WEAK_SELF
        _dateView = [[ChooseTimeView alloc] initWithFrame:CGRectMake(0, HEIGHT- 40, WIDTH, 40)];
        _dateView.outOfDays = 30;
        NSString *date = [Util GetsTheCurrentCalendar];
        _dateView.lbl.text = [NSString stringWithFormat:@"%@ 至 %@",date,date];
        _dateView.btnBlock = ^(long long beginDate,long long endDate) {
            
            weakSelf.tableView.mj_header = nil;
            [[DealSocketTool shareInstance] GET_CUSTMTRADEREPORTCLOSEPOSITOINBeginDate:beginDate EndDate:endDate WithResultArrBlock:^(NSArray<ClosePositionInfoModel *> *modelArr) {
                [weakSelf sortArray:modelArr containToday:kInterval1970 < endDate];
            }];
        };
    }
    return _dateView;
}

- (UIImageView *)nullView {
    if (!_nullView) {
        _nullView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"null_data"]];
        _nullView.center = CGPointMake(WIDTH / 2, (HEIGHT - 64 - 37) / 2);
    }
    return _nullView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 40, 0);
    
    [KEY_WINDOW addSubview:self.dateView];
    [HUDTool showToView:self.view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //闭合状态
    if ([self.headerTitles[section] hasSuffix:@" "]) return 0;
    //打开状态
    return self.data[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PositionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PositionCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PositionCell" owner:self options:nil][0];
    }
    cell.closeModel = self.data[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == self.data[indexPath.section].count - 1) ? 211.5 : 216.5;
}

#pragma mark - 网络请求

- (void)request {
    WEAK_SELF
    [[DealSocketTool shareInstance] getClosePositionInfoWithBlock:^(NSArray<ClosePositionInfoModel *> *modelArr) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf sortArray:modelArr containToday:NO];
        weakSelf.todayArray = modelArr; //保存今天的数组
    }];
}

- (void)sortArray:(NSArray *)historyArray containToday:(BOOL)isToday { LOG(@"dealDetails_three 刷一次");
    
    NSMutableArray *array = [NSMutableArray array];
    if (isToday && self.todayArray.count) { //包含今天的数据
        [array addObjectsFromArray:self.todayArray];
    }
    [array addObjectsFromArray:historyArray];
    
    if (!array.count) {
        self.data = [NSMutableArray array];
        [self.tableView reloadData];
        
        [HUDTool hideForView:self.view];
        [self.nullView removeFromSuperview];
        [self.view addSubview:self.nullView];
        return;
    }
    NSSortDescriptor *d = [NSSortDescriptor sortDescriptorWithKey:@"CloseDate" ascending:NO];
    NSArray<ClosePositionInfoModel *> *sortData = [array sortedArrayUsingDescriptors:@[d]];
    
    self.data = [NSMutableArray array];
    NSMutableArray *subData = [NSMutableArray array];
    self.headerTitles = [NSMutableArray array];
    [self.headerTitles addObject:sortData[0].days];
    
    // 第0个对象没有上个对象, 放在遍历之前为了减少遍历时的判断条件
    [subData addObject:sortData[0]];
    
    NSInteger count = sortData.count;
    for (NSInteger i = 1; i < count; i++) {
        
        if (![sortData[i].days isEqualToString:sortData[i - 1].days]) {
            [self.data addObject:subData];
            subData = [NSMutableArray array];
            [self.headerTitles addObject:sortData[i].days];
        }
        [subData addObject:sortData[i]];
    }
    [self.data addObject:subData];
    [self.tableView reloadData];
    [self.nullView removeFromSuperview];
    [HUDTool hideForView:self.view];
}

/** 组标题栏点击事件 */
- (void)clickedSectionHeader:(UIButton *)button { //将section值通过tag传过来
    
    if ([self.headerTitles[button.tag] hasSuffix:@" "]) { // 闭合状态, 将其打开
        self.headerTitles[button.tag] = [button.currentTitle substringToIndex:button.currentTitle.length - 1];
    } else { //打开状态, 将其闭合
        self.headerTitles[button.tag] = [button.currentTitle stringByAppendingString:@" "];
    }
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:button.tag];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 定时器

- (void)addTimer {
    
    if (!self.data) {
        [self request];
    }
}

- (void)dealloc {
    [self.dateView removeFromSuperview];
    LOG(@"交易详情__Three__销毁了");
}

@end
