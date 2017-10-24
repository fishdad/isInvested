//
//  DiscoverViewController.m
//  isInvested
//
//  Created by Blue on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "DiscoverViewController.h"
#import "ImportantNewsController.h"
#import "CalendarViewController.h"
#import "DiscoverNewsController.h"
#import "DiscoverCell.h"
#import "PlayerView.h"

@interface DiscoverViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) PlayerView *playerView;
@end

@implementation DiscoverViewController

- (NSArray *)data {
    if (!_data) {
        _data = @[ @{ @"image":@"ImportantNewsController", @"title":@"要闻", @"explain":@"闻天下风云, 知行情上下" },
                   @{ @"image":@"CalendarViewController", @"title":@"日历", @"explain":@"看今日大事, 洞涨跌来去" },
                   @{ @"image":@"DiscoverNewsController", @"title":@"快讯", @"explain":@"念时事消息, 决出入盈止" } ];
    }
    return _data;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.playerView requestPictures];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView = [[PlayerView alloc] init];
    self.tableView.tableHeaderView = self.playerView;
    
                 // = HEIGHT - HEIGHT_21_9 - 64 - 80 * 3 - 49 + 0.5;
    CGFloat footerH = HEIGHT - HEIGHT_21_9 - 352.5;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, footerH)];
    self.tableView.tableFooterView = footer;    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoverCell *cell = [[NSBundle mainBundle] loadNibNamed:@"DiscoverCell" owner:self options:nil][0];
    cell.model = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    UIViewController *vc = [[NSClassFromString(self.data[indexPath.row][@"image"]) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
