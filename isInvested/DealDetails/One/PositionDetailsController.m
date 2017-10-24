//
//  PositionDetailsController.m
//  isInvested
//
//  Created by Blue on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//  持仓明细

#import "PositionDetailsController.h"
#import "PositionCell.h"
#import "BottomMaskView.h"
#import "StopLossView.h"
#import "ExitView.h"
#import "SocketTool.h"
#import "IndexModel.h"

@interface PositionDetailsController ()

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *data;
@property (nonatomic, strong) NSMutableArray *headerTitles;
@property (nonatomic, strong) UIImageView *nullView;
@property (nonatomic, strong) StopLossView *stopView; //止盈止损view
@property (nonatomic, strong) ExitView     *exitView; //平仓卖出view
@property (nonatomic, assign) long stopId;  //止盈止损弹窗对应的modelID
@property (nonatomic, assign) long exitId;  //平仓买入弹窗对应的modelID
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation PositionDetailsController

- (StopLossView *)stopView {
    if (!_stopView) {
        _stopView = [StopLossView viewFromXid];
    }
    return _stopView;
}
- (ExitView *)exitView {
    if (!_exitView) {
        _exitView = [ExitView viewFromXid];
    }
    return _exitView;
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
    [HUDTool showToView:self.view];
}

#pragma mark - TableView

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
    cell.model = self.data[indexPath.section][indexPath.row];
    WEAK_SELF
    cell.stopLossBlock = ^(){
        [weakSelf clickedStopLossWithModel:weakSelf.data[indexPath.section][indexPath.row] indexPath:indexPath];
    };
    cell.exitBlock = ^(){
        [weakSelf clickedExitWithModel:weakSelf.data[indexPath.section][indexPath.row] indexPath:indexPath];
    };
    cell.cancelOrderBlock = ^(NSInteger limitType){
        [weakSelf clickedCancelOrderWithLimitType:limitType model:weakSelf.data[indexPath.section][indexPath.row]];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HoldPositionInfoModel *m = self.data[indexPath.section][indexPath.row];
    LOG(@"%d %@", m.CommodityID, m.CommodityName);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HoldPositionInfoModel *model = self.data[indexPath.section][indexPath.row];
    CGFloat height = (model.TPPrice || model.SLPrice) ? 246.5 : 216.5;
    return (indexPath.row == self.data[indexPath.section].count - 1) ? height - 5 : height;
}

#pragma mark - 点击事件

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

- (void)clickedStopLossWithModel:(HoldPositionInfoModel *)infoModel indexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    IndexModel *m = [[IndexModel alloc] init];
    m.code_type = @"0x5a01";
    switch (infoModel.CommodityID) {
            case 100000000:
            m.code = @"GDAG";
            break;
            case 100000001:
            m.code = @"GDPT";
            break;
            case 100000002:
            m.code = @"GDPD";
            break;
        default:
            break;
    }
    [[SocketTool sharedSocketTool] setIndexes:@[m]];
    [[SocketTool sharedSocketTool] setRequestStyle:SocketRequestStyleRealTimeAndPush];
    
    self.stopId = infoModel.HoldPositionID;
    BottomMaskView *maskView = [[BottomMaskView alloc]init];
    self.stopView.model = infoModel;
    self.stopView.successfulBlock = ^(){
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    maskView.subView = self.stopView;
    maskView.disappearBlock = ^(){
        [weakSelf.stopView disappear];
        weakSelf.stopId = 0;
    };
}

- (void)clickedExitWithModel:(HoldPositionInfoModel *)infoModel indexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    self.exitId = infoModel.HoldPositionID;
    BottomMaskView *maskView = [[BottomMaskView alloc]init];
    self.exitView.model = infoModel;
    self.exitView.successfulBlock = ^(){
        [weakSelf.data[indexPath.section] removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView reloadData];
        if (indexPath.section == 1 && indexPath.row == 1) { //原来仅有一条数据, 平仓后就没有有, 显示无数据图片
            [weakSelf.view addSubview:weakSelf.nullView];
        }
    };
    maskView.subView = self.exitView;
    maskView.disappearBlock = ^(){
        [weakSelf.exitView disappear];
        weakSelf.exitId = 0;
    };
}

- (void)clickedCancelOrderWithLimitType:(NSInteger)limitType model:(HoldPositionInfoModel *)model {
    
    NSString *message = [NSString stringWithFormat:@"请确认是否撤销此条止%@单?", limitType == 2 ? @"盈" : @"损"];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        long limitOrderID = limitType == 2 ? model.TPLimitOrderID : model.SLLimitOrderID;
        [[DealSocketTool shareInstance] REQ_LIMITREVOKEWithLimitOrderID:limitOrderID
                                                            CommodityID:model.CommodityID
                                                              LimitType:(int)limitType
                                                            ResultBlock:^(ProcessResult stu) {
                                                                
                                                                if (stu.RetCode == 99999) {
                                                                    [HUDTool showText:@"撤单成功!"];
                                                                } else {
                                                                    [HUDTool showText:[NSString stringWithCString:stu.Message encoding:NSUTF8StringEncoding]];
                                                                }
                                                            }];
    }]];
    [self.view.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 网络请求

/** 查询实时*/
- (void)request {
    WEAK_SELF
    [[DealSocketTool shareInstance] getHoldPositionInfoWithBlock:^(NSArray<HoldPositionInfoModel *> *modelArr) {
        [weakSelf sortArray:modelArr];
    }];
}

- (void)sortArray:(NSArray *)array { LOG(@"dealDetails_one 刷一次");
    
    if (self.tableView.isDragging) return;
    
    if (!array.count) {
        self.data = [NSMutableArray array];
        [self.tableView reloadData];
        
        [self.nullView removeFromSuperview];
        [self.view addSubview:self.nullView];
        [HUDTool hideForView:self.view];
        return;
    }
    
    NSArray<HoldPositionInfoModel *> *sortData = [[array reverseObjectEnumerator] allObjects];
    
    self.data = [NSMutableArray array];
    NSMutableArray *subData = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array]; //组标题栏数组
    [titles addObject:sortData[0].days];
    
    // 第0个对象没有上个对象, 放在遍历之前为了减少遍历时的判断条件
    [subData addObject:sortData[0]];
    
    NSInteger count = sortData.count;
    for (NSInteger i = 1; i < count; i++) {
        
        if (![sortData[i].days isEqualToString:sortData[i - 1].days]) {
            [self.data addObject:subData];
            subData = [NSMutableArray array];
            // 将这个日期字符串保存
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
    
    if (self.stopId) { //刷新止盈止损弹窗里的数据
        for (HoldPositionInfoModel *model in sortData) {
            if (model.HoldPositionID == self.stopId) {
                self.stopView.refreshModel = model;
                return;
            }
        }
        return;
    }
    
    if (self.exitId) { //刷新平仓买入弹窗里的数据
        for (HoldPositionInfoModel *model in sortData) {
            if (model.HoldPositionID == self.exitId) {
                self.exitView.model = model;
                break;
            }
        }
    }
}

#pragma mark - 定时器

- (void)addTimer {
    [self request];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
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
    LOG(@"交易详情__one__销毁了");
}

@end
