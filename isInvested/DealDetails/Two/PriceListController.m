//
//  PriceListController.m
//  isInvested
//
//  Created by Blue on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//  指价单

#import "PriceListController.h"
#import "IndexPriceCell.h"
#import "ChooseTimeView.h"

@interface PriceListController ()

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *data;
@property (nonatomic, strong) NSMutableArray *headerTitles;
@property (nonatomic, strong) UIImageView *nullView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation PriceListController

- (UIImageView *)nullView {
    if (!_nullView) {
        _nullView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"null_data"]];
        _nullView.center = CGPointMake(WIDTH / 2, (HEIGHT - 64 - 37) / 2);
    }
    return _nullView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    IndexPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndexPriceCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"IndexPriceCell" owner:self options:nil][0];
    }
    cell.model = self.data[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == self.data[indexPath.section].count - 1) ? 181 : 186;
}

#pragma mark - 网络请求

- (void)request {
    WEAK_SELF
    [[DealSocketTool shareInstance] getLimitOrderInfoWithBlock:^(NSArray<LimitOrderInfoModel *> *modelArr) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf sortArray:modelArr];
    }];
}

- (void)sortArray:(NSArray *)array { LOG(@"dealDetails_two 刷一次");
    
    if (!array.count) {
        self.data = [NSMutableArray array];
        [self.tableView reloadData];
        
        [HUDTool hideForView:self.view];
        [self.nullView removeFromSuperview];
        [self.view addSubview:self.nullView];
        return;
    }
    
    NSArray<LimitOrderInfoModel *> *sortData = [[array reverseObjectEnumerator] allObjects];
    
    self.data = [NSMutableArray array];
    NSMutableArray *subData = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    [titles addObject:sortData[0].days];
    
    // 第0个对象没有上个对象, 放在遍历之前为了减少遍历时的判断条件
    [subData addObject:sortData[0]];
    
    NSInteger count = sortData.count;
    for (NSInteger i = 1; i < count; i++) {
        
        if (![sortData[i].days isEqualToString:sortData[i - 1].days]) {
            [self.data addObject:subData];
            subData = [NSMutableArray array];
            // 将上个日期字符串保存
            [titles addObject:sortData[i].days];
        }
        [subData addObject:sortData[i]];
    }
    //组标题数组有值, 就不要改变了, 否则会复盖 打开&关闭的记录
    if (!self.headerTitles.count) self.headerTitles = titles;
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
    [self request];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(request)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeTimer];
}

- (void)dealloc {
    LOG(@"交易详情__two__销毁了");
}

@end
