//
//  ImportantNewsController.m
//  isInvested
//
//  Created by Blue on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ImportantNewsController.h"
#import "NewsDetailController.h"
#import "ImportantNewsMessage.h"
#import "ImportantNews1ImgCell.h"
#import "ImportantNews3ImgCell.h"

@interface ImportantNewsController ()

@property (nonatomic, strong) NSMutableArray<ImportantNewsMessage *> *data;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIImageView *notNetView;
@end

@implementation ImportantNewsController

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

- (NSInteger)page {
    return PRIORITY(_page, 1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"要闻";
    self.view.backgroundColor = GrayBgColor;
    self.tableView.separatorStyle = 0;
    self.tableView.scrollEnabled = NO;
    
    [self refreshNetwork];
}

- (void)setupTableView {
    WEAK_SELF
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf requestImportantNewsWithPage:0];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestImportantNewsWithPage:++weakSelf.page];
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled = YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.data[indexPath.row].Art_Images.count == 3) { //3张图cell
        
        ImportantNews3ImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImportantNews3ImgCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ImportantNews3ImgCell" owner:self options:nil][0];
        }
        cell.model = self.data[indexPath.row];
        return cell;
        
    } else {
        
        ImportantNews1ImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImportantNews1ImgCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ImportantNews1ImgCell" owner:self options:nil][0];
        }
        cell.model = self.data[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    NewsDetailController *detailVc = [[NewsDetailController alloc] init];
    detailVc.artCode = self.data[indexPath.row].Art_Code;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.data[indexPath.row].cellHeight;
}

/** 请求重要新闻 */
- (void)requestImportantNewsWithPage:(NSInteger)page {
    [HUDTool showToView:self.view];
    
    NSDictionary *params = @{ @"type" : @"3",
                              @"page" : @(page),
                              @"pageSize" : @"20" };
    WEAK_SELF
    [HttpTool post:URL_IMPORTANT_NEWS params:params success:^(id responseObj) { //LOG(@"重要新闻==%@", responseObj);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [HUDTool hideForView:weakSelf.view];
        
        if (page) { //加载更多
            [weakSelf.data addObjectsFromArray:[ImportantNewsMessage mj_objectArrayWithKeyValuesArray:responseObj[@"data"]]];
        } else {
            weakSelf.data = [ImportantNewsMessage mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        }
        [weakSelf.notNetView removeFromSuperview];
        [weakSelf.tableView reloadData];
        [weakSelf setupTableView];
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [HUDTool hideForView:weakSelf.view];
        [HUDTool showText:kRequestTimeout];
    }];
}

#pragma mark - 点击事件

- (void)refreshNetwork {
    if ([HttpTool networkStatus]) {
        [self requestImportantNewsWithPage:0];
    } else {
        [self.view addSubview:self.notNetView];
    }
}

@end
