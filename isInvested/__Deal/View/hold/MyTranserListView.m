//
//  MyTranserListView.m
//  isInvested
//
//  Created by Ben on 16/9/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MyTranserListView.h"
#import "TransferListTableViewCell.h"
#import "TransferListTitleView.h"
#import "NoDataView.h"

@interface MyTranserListView ()<UITableViewDelegate,UITableViewDataSource>
{
    long long _beginDate;//开始时间
    long long _endDate;//结束时间
    int count;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NoDataView *noDataView;


 @property (nonatomic, strong) NSArray *mArr;

@end

@implementation MyTranserListView

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        [_tableView registerClass:[TransferListTableViewCell class] forCellReuseIdentifier:@"myCell"];
        
        //没有数据
        _noDataView = [NoDataView defaultNoDataView];
        _noDataView.hidden = YES;
        [self addSubview:_noDataView];
        
        _dataArr = [NSMutableArray arrayWithCapacity:1];
        [_tableView reloadData];
        
        
        WEAK_SELF
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [weakSelf reloadDataByBeginDate:_beginDate EndDate:_endDate];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
        [header setTitle:@"下拉刷新最新的转账信息" forState:MJRefreshStateIdle];
        [header setTitle:@"松开刷新最新的转账信息" forState:MJRefreshStatePulling];
        weakSelf.tableView.mj_header = header;
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signSucess) name:@"SignSuccess" object:nil];
    }
    return self;
}

-(void)signSucess{

    [self reloadDataByBeginDate:_beginDate EndDate:_endDate];
}

-(void)reloadDataByBeginDate:(long long)beginDate EndDate:(long long)endDate{

    _beginDate = beginDate;
    _endDate = endDate;
    long long nowDate = [[NSDate date] timeIntervalSince1970];
    BOOL isAddTody;
    if (endDate >= nowDate) {
        isAddTody = YES;
    }else{
        isAddTody = NO;
    }
    _mArr = [NSMutableArray arrayWithCapacity:1];
    [[DealSocketTool shareInstance] GET_FUNDFLOWQUERYBynBeginDate:beginDate nEndDate:endDate WithBlock:^(NSArray<FundFlowQueryInfoModel *> *modelArr) {
        [self getTransAmountListWithHistoryArr:modelArr IsAddTody:isAddTody];
    }];
}
//查询出入金的记录
-(void)getTransAmountListWithHistoryArr:(NSArray *) hisArr IsAddTody:(BOOL) isAddTody{
    
    
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:hisArr];
    
    if (isAddTody) {
        NSDictionary *params = @{@"userId":[NSUserDefaults objectForKey:UserID],
                                 @"type":@"2"};
        
        [GGHttpTool get:[Util getTransAmountUrlBytype:GetWithdrawListById] params:params success:^(id responseObj) {
            
            NSDictionary *dic = responseObj;
            if ([dic[@"code"] intValue]== 1) {
                NSArray *arr = dic[@"data"];
                for (int i = 0; i < arr.count; i++) {
                    FundFlowQueryInfoModel *model = [[FundFlowQueryInfoModel alloc] init];
                    model.OpLoginAccount = @"当天记录";
                    if ([arr[i][@"Wd_Type"] intValue] == 0) {///< 操作类型 --- 15:入金 --- 16:出金
                        model.OperType = 16;
                        model.Amount = - [arr[i][@"Wd_Amount"] doubleValue];
                    }else{
                        model.OperType = 15;
                        model.Amount = [arr[i][@"Wd_Amount"] doubleValue];
                    }
                    NSString *dateStr = arr[i][@"Wd_AddTime"];
                    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    dateStr = [dateStr substringToIndex:19];
                    model.OperDate = [[Util dateToUTCWithDate:dateStr DateFormatter:@"yyyy-MM-dd HH:mm:ss"] longLongValue];
                    if ([arr[i][@"Wd_State"] intValue] == 1) {
                        model.AfterAmount = model.BeforeAmount + model.Amount;
                    }else{
                        model.AfterAmount = model.BeforeAmount - model.Amount;
                    }
                    [mArr addObject:model];
                }
            }
            [self reloadMyTableViewWith:mArr];
            
        } failure:^(NSError *error) {
            LOG(@"转账列表 -- %@",error);
        }];
    }else{
        [self reloadMyTableViewWith:mArr];
    }
}

-(void)reloadMyTableViewWith:(NSMutableArray *) mArr{

    NSArray *sortArr = [mArr sortedArrayUsingComparator:^NSComparisonResult(FundFlowQueryInfoModel * obj1, FundFlowQueryInfoModel *obj2) {
        
        return obj1.OperDate < obj2.OperDate;
    }];
    
    _dataArr = [NSMutableArray arrayWithArray:sortArr];
    if (_dataArr.count == 0) {
        _noDataView.hidden = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        _noDataView.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    [_tableView reloadData];

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 49;
}

//时间戳转日期 (秒数转日期)
-(NSString *)UTCToDateWithUTC:(NSString *) timeStamp{
    
    long long int ndate = (long long int)[timeStamp intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ndate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateFormatStr = [NSString stringWithFormat:@"yyyy-MM-dd\nHH:mm:ss"];
    [dateFormatter setDateFormat:dateFormatStr];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TransferListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    FundFlowQueryInfoModel *model = self.dataArr[indexPath.row];
    cell.valueView.timeLbl.text = [self UTCToDateWithUTC:[NSString stringWithFormat:@"%lld",model.OperDate]];       ///< 日期
    NSString *amount;
    if (model.OperType - 15 == TranserTypeIn) {///< 操作类型 --- 15:入金 --- 16:出金
        cell.valueView.typeLbl.text = @"转入";
        cell.valueView.type = TranserTypeIn;
        amount = [NSString stringWithFormat:@"+%.2f",model.Amount];
    }else if (model.OperType - 15 == TranserTypeOut){
        cell.valueView.typeLbl.text = @"转出";
        cell.valueView.type = TranserTypeOut;
        amount = [NSString stringWithFormat:@"%.2f",model.Amount];
    }else{
        cell.valueView.typeLbl.text = [NSString stringWithFormat:@"%d",model.OperType];
    }
    cell.valueView.priceLbl.text = amount;
    
    if (model.AfterAmount == model.BeforeAmount + model.Amount) {
        cell.valueView.statusLbl.text = @"成功";
        cell.valueView.statusType = 0;
    }else{
        if ([model.OpLoginAccount isEqualToString:@"当天记录"]) {
            cell.valueView.statusLbl.text = @"处理中";
        }else{
            cell.valueView.statusLbl.text = @"失败";
        }
        cell.valueView.statusType = 1;
    }
    cell.valueView.timeLbl.font = FONT(12);
    cell.valueView.typeLbl.font = FONT(13);
    cell.valueView.priceLbl.font = FONT(13);
    cell.valueView.statusLbl.font = FONT(13);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    TransferListTitleView *view = [[TransferListTitleView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    view.backgroundColor = OXColor(0xf5f5f5);
    view.timeLbl.textColor = OXColor(0x999999);
    view.typeLbl.textColor = OXColor(0x999999);
    view.priceLbl.textColor = OXColor(0x999999);
    view.statusLbl.textColor = OXColor(0x999999);
    
    view.timeLbl.text= @"时间";
    view.typeLbl.text = @"类型";
    view.priceLbl.text = @"金额";
    view.statusLbl.text = @"状态";
    
    view.timeLbl.font = FONT(11);
    view.typeLbl.font = FONT(11);
    view.priceLbl.font = FONT(11);
    view.statusLbl.font = FONT(11);
    
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
