//
//  ChooseViewController.m
//  isInvested
//
//  Created by Blue on 16/10/9.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ChooseViewController.h"
#import "StockPriceCell.h"
#import "EditChooseController.h"
#import "MyAssetsViewController.h"
#import "SearchViewController.h"
#import "ChartDetailsController.h"
#import "IndexModel.h"
#import "SocketTool.h"
#import "LoginViewController.h"
#import "IINavigationController.h"

@interface ChooseViewController ()

@property (nonatomic, strong) UIImageView *nullView;
@property (nonatomic, strong) NSArray<IndexModel *> *data;       //保存升序 or 降序
@property (nonatomic, strong) NSArray<IndexModel *> *normalData; //保存用户自定义顺序的数组
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UIButton *notNetButton;
@end

@implementation ChooseViewController

- (UIImageView *)nullView {
    if (!_nullView) {
        _nullView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_add"]];
        _nullView.center = CGPointMake(WIDTH / 2, HEIGHT / 2 - 64);
        _nullView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedSearch)];
        [_nullView addGestureRecognizer:tap];
    }
    return _nullView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[SocketTool sharedSocketTool] setIndexes:self.data];
    [[SocketTool sharedSocketTool] setRequestStyle:SocketRequestStyleRealTimeAndPush];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    if ([HttpTool networkStatus] == NotReachable) { //没网
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.notNetButton.hidden = NO;
    } else {
        [self getLatestDataAndRefresh];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(reloadSelectData:) name:SocketRealTimeAndPushNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNav {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickedEdit) title:@"编辑"];
    
    UIBarButtonItem *item1 = [UIBarButtonItem itemWithTarget:self action:@selector(clickedSearch) image:@"search_white_2"];
    UIBarButtonItem *item2 = [UIBarButtonItem itemWithTarget:self action:@selector(clickedMoney) image:@"rmb_white_2"];
    self.navigationItem.rightBarButtonItems = @[item1, item2];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StockPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockPriceCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"StockPriceCell" owner:self options:nil][0];
    }
    cell.model = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChartDetailsController *vc = [[ChartDetailsController alloc] init];
    vc.model = self.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击事件

- (void)clickedEdit {
    WEAK_SELF
    
    if ([HttpTool networkStatus] == NotReachable) {
        [HUDTool showText:@"暂无网络, 请稍后再试"];
        return;
    }
    if (!self.data.count) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"当前没有关注任何品种, 是否去添加?" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf clickedSearch];
        }]];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    [[SocketTool sharedSocketTool] disconnect];
    EditChooseController *vc = [[EditChooseController alloc] init];
    vc.refreshDataBlock = ^(){
        [weakSelf getLatestDataAndRefresh];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickedMoney {
    
    if (![NSUserDefaults boolForKey:isLogin]) {
        LoginViewController *loginVC =[[LoginViewController alloc] init];
        IINavigationController*loginNav = [[IINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNav animated:YES completion:nil];
        return;
    }
    
    [[SocketTool sharedSocketTool] disconnect];
    MyAssetsViewController *vc = [[MyAssetsViewController alloc] init];
    vc.fromType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickedSearch {
    WEAK_SELF
    [[SocketTool sharedSocketTool] disconnect];
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.refreshDataBlock = ^(){
        [weakSelf getLatestDataAndRefresh];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

/** 默认降序, 点击改为升序 */
- (IBAction)clickedSort:(UIButton *)button {
    
    button.tag = button.tag == 2 ? 0 : button.tag + 1;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"sort_state_%ld", button.tag]];
    [button setImage:image forState:UIControlStateNormal];
    
    [self refreshData];
}

- (IBAction)clickedNotNetButton {
    
    if ([HttpTool networkStatus]) { //有网
        [self getLatestDataAndRefresh];
    }
}

/** 取最新的关注列表, 并刷新 */
- (void)getLatestDataAndRefresh {
    
    self.data = self.normalData = [CacheTool fetchSelectCache];
    if (self.data.count == 0) {
        self.data = self.normalData = [IndexTool selectedIndexes];
    }
    
    if (self.data.count) {
        UILabel *footerL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        footerL.text = @"以上信息实时刷新, 无需下拉刷新";
        footerL.font = FONT(12.0);
        footerL.textColor = GrayBorderColor;
        footerL.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableFooterView = footerL;
        [self.nullView removeFromSuperview];
        
    } else {
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:self.nullView];
    }
    [self refreshData];
}

- (void)reloadSelectData:(NSNotification *)notification {
    
    if (!self.notNetButton.hidden) return;//些时有 无网 图片，通知来了不做任何处理
    
    NSInteger count = self.data.count;
    for (IndexModel *model in notification.userInfo[@"userInfo"]) {
        
        for (int i = 0; i < count; i++) { //保存到self.data
            IndexModel *m = self.data[i];
            if ([m.code isEqualToString:model.code]) {
                m.new_price = model.new_price;
                m.pre_close = model.pre_close;
                m.isFlash = model.isFlash;
                break;
            }
        }
        for (int i = 0; i < count; i++) { //保存到self.normalData
            IndexModel *m = self.normalData[i];
            if ([m.code isEqualToString:model.code]) {
                m.new_price = model.new_price;
                m.pre_close = model.pre_close;
                m.isFlash = model.isFlash;
                break;
            }
        }
    }
    [self refreshData];
}

/** 按规则刷新数据 */
- (void)refreshData {
    
    if (self.tableView.isDragging || self.tableView.isDecelerating) return;
    
    if (self.sortButton.tag) { //升序或降序
        NSSortDescriptor *d = [NSSortDescriptor sortDescriptorWithKey:@"fluctuation_percent" ascending:self.sortButton.tag == 2];
        self.data = [self.data sortedArrayUsingDescriptors:@[d]];
    } else if (self.normalData.count) { //普通状态
        self.data = self.normalData;
    }
    [self.tableView reloadData];
    self.notNetButton.hidden = YES;
    [CacheTool saveSelectData:self.data];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self refreshData];
}

@end
