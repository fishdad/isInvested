//
//  BuyUpDownOrderViewController.m
//  isInvested
//
//  Created by Ben on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "BuyUpDownOrderViewController.h"
#import "MarketOrderView.h"
#import "IndexPriceOrderView.h"
#import "KMPopView.h"
#import "VarietyTitleView.h"
#import "StockBottomBtnView.h"
#import "HorizontalScrollView.h"
#import "IQKeyboardManager.h"
#import "DealSocketTool.h"

#import "DealViewController.h"
#import "MyTransferViewController.h"
#import "UILabel+TextWidhtHeight.h"
#import "TimeSharingView.h"
#import "SocketTool.h"
#import "IndexModel.h"

@interface BuyUpDownOrderViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MarketOrderView *markView;
@property (nonatomic, strong) IndexPriceOrderView *indexView;
@property (nonatomic, strong) UIButton *orderBtn;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *orderTypeStr;
@property (nonatomic, assign) BuyOrderType type;
@property (nonatomic, assign) PriceOrderType priceType;
@property (nonatomic, strong) NSArray *detailTitleArr;
@property (nonatomic, strong) NSArray *detailValueArr;
@property (nonatomic, strong) VarietyTitleView *vTitleView;
@property (nonatomic, strong) UILabel *titleMsgLbl;//未刷新到数据提示
//@property (nonatomic, strong) UIView *chartView;
@property (nonatomic, strong) UILabel *orderTytpeLbl;
@property (nonatomic, strong) StockBottomBtnView *bottonView;
@property (nonatomic, strong) NSMutableArray *varietyTitleArr;
@property (nonatomic, strong) NSMutableArray *varietyModelArr;
@property (nonatomic, strong) WeightChooseView *weightView;
@property (nonatomic, strong) NSString *NewPrice;//商品最新的价格
@property (nonatomic, assign) NSInteger currentIndex;//当前的品种行情
@property (nonatomic, assign) NSInteger weightChooseType;//重量选择类型
@property (nonatomic, strong) NSString *ExchangeReserve;//交易准备金
@property (nonatomic, strong) NSString *unit;//计量单位
@property (nonatomic, assign) double reserve ;//履约准备金
@property (nonatomic, assign) double counterFee ;//成交后手续费
@property (nonatomic, assign) BOOL isSuccessDeal ;//是否成功交易

@property (nonatomic, strong) CommodityInfoModel *commodityInfoModel;//当前品种的model
@property (nonatomic, strong) OpenMarketOrderConfModel *openMarketOrderConfModel;//市价开仓配置
@property (nonatomic, strong) OpenLimitOrderConfModel *openLimitOrderConfModel;//指价开仓配置
@property (nonatomic, strong) TimeSharingView *sharingView;
@property (nonatomic, strong) IndexModel *model;

@property (nonatomic, strong) OpenMarketOrderParamModel *openMarketOrderParamModel;//市价建仓参数
@property (nonatomic, strong) OpenLimitOrderParamModel *openLimitOrderParamModel;//限价建仓参数

@property (nonatomic, strong) NSTimer *timer;//定时刷新交易价格的计时器
@property (nonatomic, strong) NSString *priceRefushType;//价格刷新的类型控制 2017.02.22

@end

@implementation BuyUpDownOrderViewController

//获取本地存储的当前品种
-(NSInteger)getNowIndex{

    NSNumber *tag = [NSUserDefaults objectForKey:VarietyIndex];
    return [tag integerValue];
}

-(IndexModel *)model{

    if (!_model) {
        _model = [[IndexModel alloc] init];
        _model.code_type = @"0x5a01";
        _model.code = [self getSelectVarietyCodeWithTag:_currentIndex];
        _model.pre_close = [TxtTool preCloseWithCodeType:self.model.code_type code:self.model.code];
    }
    return _model;
}


//市价建仓入参model
-(OpenMarketOrderParamModel *)openMarketOrderParamModel{
    
    if (!_openMarketOrderParamModel) {
        _openMarketOrderParamModel = [[OpenMarketOrderParamModel alloc] init];
        
        _openMarketOrderParamModel.nOpenDirector = [Util getOPENDIRECTOR_DIRECTIONByBuyOrderType:_type];///< 建仓方向
        _openMarketOrderParamModel.nQuantity = 1;		///< 交易数量
        _openMarketOrderParamModel.nOrderType = 1;		///< 下单类型		---1:客户下单
    }
    return _openMarketOrderParamModel;
}
//限价建仓入参model
-(OpenLimitOrderParamModel *)openLimitOrderParamModel{
    
    if (!_openLimitOrderParamModel) {
        _openLimitOrderParamModel = [[OpenLimitOrderParamModel alloc] init];
        
        _openLimitOrderParamModel.nExpireType = 1;///< 过期类型(待定by xinle)--- 1:当日有效
        _openLimitOrderParamModel.nOpenDirector = [Util getOPENDIRECTOR_DIRECTIONByBuyOrderType:_type];
        _openLimitOrderParamModel.nQuantity = 1;///< 建仓数量
        //int nOrderType;				///< 下单类型		--- 1:客户下单

    }
    return _openLimitOrderParamModel;
}

- (TimeSharingView *)sharingView {
    if (!_sharingView) {
        _sharingView = [TimeSharingView viewFromXid];
        _sharingView.y = _vTitleView.bottom;
        _sharingView.height = 100.0;
        _sharingView.model = self.model;
        _sharingView.style = SocketRequestStyleTimeSharing;
        
        [[SocketTool sharedSocketTool] setIndexes:@[self.model]];
        [[SocketTool sharedSocketTool] setRequestStyle:SocketRequestStyleRealTimeAndPush];
        [[SocketTool sharedSocketTool] setRequestStyle:SocketRequestStyleTimeSharing];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0*NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [[SocketTool sharedSocketTool] setRequestStyle:SocketRequestStyleTimeSharing];
                       });
    }
    return _sharingView;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;//键盘工具条 -- [完成]按钮的使用
    if ([_priceRefushType  isEqual: @"根据交易数据刷新"]) {
        [self timerFire];//定时刷新交易的价格 2017.02.22 xinle
    }
    [self reloadDataView];
    LOG(@"~~~~~~~~~~~~~~~~~~~建仓界面出现~~~~~%li",(long)_type);
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    if ([_priceRefushType  isEqual: @"根据交易数据刷新"]){
        [self timerInvalte];//计时器关闭
    }
    //计量单位消失
    [self unitDismiss];
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;//键盘工具条 -- [完成]按钮的使用
}

- (instancetype)initWithMarketOrderType:(BuyOrderType) type
{
    self = [super init];
    if (self) {
        
        _type = type;
#pragma mark -- 选择想要的加载数据的模式 2017.02.22
        _priceRefushType = @"根据行情数据刷新";
//        _priceRefushType = @"根据交易数据刷新";
        
        if (type == BuyOrderTypeUp) {
            self.color = RedBackColor;
            self.orderTypeStr = @"买涨下单";
        }else if (type == BuyOrderTypeDown){
        
            self.color = GreenBackColor;
            self.orderTypeStr = @"买跌下单";
        }
        
    }
    return self;
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentIndex = [self getNowIndex];
//    获取交易数据暂时屏蔽,放到viewWillAppear里边获取数据 xinle 2016.12.15
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDealData) name:@"SignSuccess" object:nil];
    //初始创建,不显示
    [NSUserDefaults setBool:NO forKey:@"UnitChoose"];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self getDealData];
    [self setUpView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTitleViewData:)
                                                 name:SocketRealTimeAndPushNotification
                                               object:nil];
}

#pragma mark -- 获取最新价和涨跌幅
- (void)reloadTitleViewData:(NSNotification *)notification {
    
    NSArray<IndexModel *> *array = notification.userInfo[@"userInfo"];
    
    if (array.count == 1 && [array[0].code isEqualToString:self.model.code]) {
        self.model = array[0];
        
        LOG(@"行情图的最新价和涨跌幅:%f    %f", self.model.new_price, self.model.fluctuation_percent);
        if ([_priceRefushType  isEqual: @"根据行情数据刷新"]) {
            ////根据加载数据开关控制树新数据来源 2017.02.22 xinle
            CGFloat newPrice = self.model.new_price / self.model.priceunit;
            [self getNewPrice:[NSString stringWithFormat:[Util getPriceDigitByComID:self.commodityInfoModel.CommodityID],newPrice] FromType:@"行情"];
        }
    }
}

#pragma mark -- 定时刷新获取交易系统的最新行情报价 (预备后期如果行情和交易的数据不一致的情况)
-(NSTimer *)timer{
    
    if (_timer == nil) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openTimerFire) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(void)openTimerFire{
    
    if ([[DealSocketTool shareInstance] connectToRemote]) {
        
        [self refushNewDealPrice];//获取最新的行情价格
    }
}

-(void)timerFire{
    
    //获取市场开休市状态
    [[DealSocketTool shareInstance] getMarketstatusWithStatusBlock:^(unsigned short isSuccess, NSString *statusStr) {
        
        if (isSuccess == 0) {//休市返回
            [self openTimerFire];
        }else{
            //开市循环
            [self.timer fire];
        }
    }];
}

-(void)timerInvalte{
    
    [self.timer invalidate];
    self.timer = nil;
}
-(void)refushNewDealPrice{

    //及时切换价格信息
    int iComID = [self.commodityInfoModel.CommodityID intValue];
    if (iComID == 0) {
        return;
    }
    [[DealSocketTool shareInstance] REQ_QUOTEBYID:iComID WithBlock:^(RealTimeQuote stu) {
        
       [self getNewPrice:[NSString stringWithFormat:[Util getPriceDigitByComID:self.commodityInfoModel.CommodityID],stu.SellPrice] FromType:@"行情"];
    }];
}

#pragma mark -- 下拉刷新的方法,重量选择
-(void)setUpView{
    
    _scrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 49)];
    
    __weak typeof(_scrollView) weakScrollView = _scrollView;
    WEAK_SELF
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadDataView];
        [weakScrollView.mj_header endRefreshing];
    }];
    [header setTitle:@"下拉刷新最新的行情报价" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新最新的行情报价" forState:MJRefreshStatePulling];
    _scrollView.mj_header = header;
    [self.view addSubview:_scrollView];
    
    //行情栏目条目
    _vTitleView = [[VarietyTitleView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    _vTitleView.NewPriceLbl.textColor = self.color;
    _vTitleView.ZFLbl.textColor = self.color;
    [_vTitleView.varietyBtn addTarget:self action:@selector(varietyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_vTitleView.varietyBtn1 addTarget:self action:@selector(varietyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_vTitleView.titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_vTitleView.moreBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_vTitleView];
    
    //如果没有刷新出数据提示下拉刷新
    _titleMsgLbl = [[UILabel alloc] initWithFrame:_vTitleView.bounds];
    _titleMsgLbl.backgroundColor = [UIColor whiteColor];
    _titleMsgLbl.textAlignment = NSTextAlignmentCenter;
    _titleMsgLbl.text = @"请尝试下拉刷新获取最新的数据信息";
    _titleMsgLbl.font = FONT(15);
    [_vTitleView addSubview:_titleMsgLbl];
    
    //行情view
    [_scrollView addSubview:self.sharingView];
    
    //下单方式
    CGFloat spacing = 10;
    CGFloat titleLblW = [UILabel getWidthWithTitle:@"四个汉字" font:FONT(15)];
    CGFloat segmentW = (WIDTH - 2 * spacing - titleLblW - 55);
    CGFloat titleLblH = 34;
    if (WIDTH == 320) {
        titleLblH = 30;
    }
    _orderTytpeLbl = [[UILabel alloc] init];
    _orderTytpeLbl.frame = CGRectMake(spacing, NH(self.sharingView) + 10,titleLblW,titleLblH);
    _orderTytpeLbl.text = @"下单方式";
    _orderTytpeLbl.font = FONT(15);
    [_scrollView addSubview:_orderTytpeLbl];
    
    //市价指价选择框
    NSArray *aArray = @[@"市价下单",@"指价下单"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:aArray];
    _segmentControl.frame = CGRectMake(NW(_orderTytpeLbl) + 10, _orderTytpeLbl.y,segmentW, titleLblH) ;
    _segmentControl.selectedSegmentIndex = 0;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT(16),NSFontAttributeName,nil];
    [_segmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:dic forState:UIControlStateSelected];
    [_segmentControl setTintColor:self.color];
    
    NSDictionary *colorAttr = [NSDictionary dictionaryWithObject:self.color forKey:NSForegroundColorAttributeName];
    NSDictionary *colorAttrSelected = [NSDictionary dictionaryWithObject:OXColor(0xffffff) forKey:NSForegroundColorAttributeName];
    [_segmentControl setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:colorAttrSelected forState:UIControlStateSelected];
    
    [_segmentControl addTarget:self action:@selector(actionSegmentControl:) forControlEvents:(UIControlEventValueChanged)];
    [_scrollView addSubview:_segmentControl];
    
    //重量选择视图(共用同一个重量选择视图)
    _weightView = [[WeightChooseView alloc] initWithMarketOrderType:_type];
    //0:手动输入重量 3:1/3  2:1/2   1:全部
    _weightView.easeChooseBlock = ^(NSInteger index){
    
        if (index != 0) {
            [weakSelf.view endEditing:YES];
        }
        weakSelf.weightChooseType = index;
        [weakSelf getWeightStepperValue];
    };
    _weightView.weightChangeBlock = ^(){
     
        [weakSelf setUpPriceRateWithNewPrice:weakSelf.NewPrice];
    };
    //市价
    _markView = [[MarketOrderView alloc] initWithMarketOrderType:_type WeightViewHeight:_weightView.height];
    _markView.frame = CGRectMake(0, NH(_segmentControl) + 10, WIDTH, _markView.height);
    //市价?号帮助按钮
    _markView.allowHelpBlock = ^(){
        [Util alertViewWithMessage:@"最大价差是指成交价和下单价的最大波动范围" Target:weakSelf];
    };
    __block HorizontalScrollView *unitChooseview;
     //计量单位下拉显示
    _weightView.unitBlock = ^(){
    
        [weakSelf.view endEditing:YES];
        [NSUserDefaults setBool:YES forKey:@"UnitChoose"];
        CGFloat w = 200;
        NSDictionary *weightDic = [Util weightStepDicByComID];
        if (weakSelf.varietyModelArr.count == 0) {
            return ;
        }
        CommodityInfoModel *model = weakSelf.varietyModelArr[weakSelf.currentIndex];//当前的品种信息
        NSArray *items = weightDic[model.CommodityID];
        NSString *nowString = weakSelf.weightView.unitValueLbl.text;
        CGFloat hSpace;
        if (_priceType == PriceOrderTypeMarket){
            hSpace = 80;
        }else{
            hSpace = 200;
        }
        //计量单位的选择view
        unitChooseview = [[HorizontalScrollView alloc] initWithFrame:CGRectMake(WIDTH , weakSelf.markView.y + hSpace + 5, w, 35) Items:items NowString:nowString];
        //动画显示
        [UIView animateWithDuration:0.5 animations:^{
            unitChooseview.frame = CGRectMake(WIDTH - w - 10, weakSelf.markView.y + hSpace + 5, w, 35);
            unitChooseview.chooseBlock = ^(NSInteger i){
                //单位选择
                weakSelf.weightView.unitValueLbl.text = [NSString stringWithFormat:@"X%@kg",items[i]];
                weakSelf.unit = items[i];
                [weakSelf getWeightStepperValue];
                [weakSelf setUpPriceRateWithNewPrice:weakSelf.NewPrice];
            };
            
            [weakSelf.scrollView addSubview:unitChooseview];
        }];
    };
    //计量单位下拉消失
    _weightView.unitDismissBlock = ^(){
    
        [NSUserDefaults setBool:NO forKey:@"UnitChoose"];
        [unitChooseview removeFromSuperview];
    };
    [_scrollView addSubview:_markView];
    
    //指价
    _indexView = [[IndexPriceOrderView alloc] initWithMarketOrderType:_type WeightViewHeight:_weightView.height];
    _indexView.frame = CGRectMake(0, NH(_segmentControl) + 10, WIDTH, _indexView.height);
    _indexView.hidden = YES;
    _indexView.rangeHelpBlock = ^(){
        [Util alertViewWithMessage:@"价格可输入范围(价格≥限价买入报价 或 价格≤限价卖出报价)" Target:weakSelf];
    };
    //指价的价格发生变化
    _indexView.priceValueStepperTextDidEndEditingBlock = ^(NSString *priceValue){
        [weakSelf setUpCanByWeightLblValueWithPrice:priceValue.doubleValue];
    };
    [_scrollView addSubview:_indexView];
    
    //下单按钮
    _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderBtn.frame = CGRectMake(spacing, NH(_markView) + 10, WIDTH - 2 * spacing, 48);
    [_orderBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _orderBtn.layer.masksToBounds = YES;
    _orderBtn.layer.cornerRadius = 3;
//    _orderBtn.titleLabel.font = FONT(15);
    _orderBtn.backgroundColor = _color;
    _orderBtn.showsTouchWhenHighlighted = YES;
    [_orderBtn setTitle:_orderTypeStr forState:UIControlStateNormal];
    [_scrollView addSubview:_orderBtn];
    
    //重量选择
    _weightView.frame = CGRectMake(0,NH(self.sharingView) + 80 + 10, WIDTH, _weightView.height);
    [_scrollView addSubview:_weightView];
    [self setScrollContentSize];
//    [self setUpSubViewsFramesWithCharViewHiden:YES];//默认不显示行情图
}


#pragma mark -- 计算重量值
-(void)getWeightStepperValue{
    
    WEAK_SELF
    if (weakSelf.weightChooseType == 0) {
        return;
    }
    //根据快速计算计算出输入框内的值
    double canByWeight = [weakSelf setUpCanByWeightLblValueWithPrice:self.NewPrice.doubleValue];
//    double canByWeight = 22.3; // xinle 测试值
    double weight = canByWeight / weakSelf.weightChooseType;
    double buyWeight = (weight / (weakSelf.unit.doubleValue));
    int a;
    if (weakSelf.weightChooseType == 1) {
        a = (int)(buyWeight);
        
    }else{
        a = (int)(buyWeight + 0.5);
    }
    NSString *text = [NSString stringWithFormat:@"%i",a];
    weakSelf.weightView.weightStepper.txtCount.text = text;
}

#pragma mark -- 是否显示行情图
-(void)varietyBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [self setUpSubViewsFramesWithCharViewHiden:YES];
    }else{
        [self setUpSubViewsFramesWithCharViewHiden:NO];
    }
}

#pragma mark -- 行情品种切换
-(void)titleBtnClick:(UIButton *)btn{
    
    [self.view endEditing:YES];
    //计量单位消失
    [self unitDismiss];
    WEAK_SELF
    StockBottomBtnView *view = [[StockBottomBtnView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    if (_varietyTitleArr.count > 0) {
        _titleMsgLbl.hidden = YES;
    }else{
        _titleMsgLbl.hidden = NO;
    }    
    view.array = _varietyTitleArr;
    view.count = _currentIndex;//当前选择的行数
    __block typeof(view) weakView = view;
    view.dismiss = ^(){
        [weakView removeFromSuperview];
        weakView = nil;
    };
    //切换行情,交易等信息
    view.chooseIndexBlock = ^(NSInteger tag){
        
        //修改为心跳判断实际的链接
        NSArray *arr = weakSelf.varietyTitleArr;
        if (tag < arr.count) {
            [NSUserDefaults setObject:@(tag) forKey:VarietyIndex];//保存当前的品种
            [weakSelf selectVarietyIndex:tag];
        }
    };
    [[Util appWindow] addSubview:view];

}

#pragma mark -- 当前选择行情转换成航抢图的code
-(NSString *)getSelectVarietyCodeWithTag:(NSInteger) tag{

    NSString *code;
    if (tag == 0) { //越贵银
        code = @"GDAG";
    } else if (tag == 1) { //铂
        code = @"GDPT";
    } else { //钯
        code = @"GDPD";
    }

    return code;
}

#pragma mark -- 选择行情
-(void)selectVarietyIndex:(NSInteger) tag{

    WEAK_SELF
    if (weakSelf.varietyTitleArr.count > 0) {
        
        weakSelf.model.code = [weakSelf getSelectVarietyCodeWithTag:tag];
        weakSelf.model.pre_close = [TxtTool preCloseWithCodeType:weakSelf.model.code_type code:weakSelf.model.code];
        weakSelf.sharingView.model = weakSelf.model;
        
        [[SocketTool sharedSocketTool] setIndexes:@[weakSelf.model]];
        [[SocketTool sharedSocketTool] setRequestStyle:SocketRequestStyleRealTimeAndPush];
        [[SocketTool sharedSocketTool] setRequestStyle:SocketRequestStyleTimeSharing];
        
        [weakSelf.vTitleView.titleBtn setTitle:weakSelf.varietyTitleArr[tag] forState:UIControlStateNormal];
        //重新请求数据
        [weakSelf getDataFromInterNetByVarietyIndex:tag FirstIn:NO];
    }
}

//重量选择位置
-(void)setWeightViewFrameWithCharViewHidden:(BOOL) hiden{

    if (self.sharingView.hidden) {
        if (_priceType == PriceOrderTypeMarket) {
            _weightView.frame = CGRectMake(0,NH(_vTitleView) + 80 + 10, WIDTH, _weightView.height);
        }else{
            _weightView.frame = CGRectMake(0,NH(_vTitleView) + 200 + 10, WIDTH, _weightView.height);
        }
    }else{
        if (_priceType == PriceOrderTypeMarket) {
            _weightView.frame = CGRectMake(0,NH(self.sharingView) + 80 + 10, WIDTH, _weightView.height);
        }else{
            _weightView.frame = CGRectMake(0,NH(self.sharingView) + 200 + 10, WIDTH, _weightView.height);
        }
    }

}

-(void)setUpSubViewsFramesWithCharViewHiden:(BOOL) hidden{

    CGFloat spacing = 10;
    CGFloat titleLblW = [UILabel getWidthWithTitle:@"四个汉字" font:FONT(15)];
    CGFloat titleLblH = 34;
    if (WIDTH == 320) {
        titleLblH = 30;
    }
    CGFloat charViewH;
    if (hidden == YES) {
        charViewH = 0;
    }else{
        charViewH =100;
    }
    self.sharingView.hidden = hidden;
    
    [self setWeightViewFrameWithCharViewHidden:hidden];
    
    _orderTytpeLbl.frame = CGRectMake(spacing, NH(_vTitleView) + charViewH + 10,titleLblW,titleLblH);
    _segmentControl.frame = CGRectMake(NW(_orderTytpeLbl) + spacing, _orderTytpeLbl.y,_segmentControl.frame.size.width, titleLblH) ;
    _markView.frame = CGRectMake(0, NH(_segmentControl) + 10, WIDTH, _markView.height);
    _indexView.frame = CGRectMake(0, NH(_segmentControl) + 10, WIDTH, _indexView.height);
    _orderBtn.frame = CGRectMake(spacing, NH(_markView) + 10, WIDTH - 2 * spacing, 44);
    [self setScrollContentSize];
}

-(void)setScrollContentSize{
    
    //设置滑动范围
    CGFloat height = NH(_orderBtn) + 64 + 49 + 10;
    _scrollView.contentSize = CGSizeMake(0, height);
}
-(NSString *)getCommodityName:(NSString *)name{

    NSString *newName;
    if ([name isEqualToString:@"粤贵银"]) {
        newName = [NSString stringWithFormat:@"%@(kg)GDAG",name];
    }else if ([name isEqualToString:@"粤贵钯"]) {
        newName = [NSString stringWithFormat:@"%@(g)GDPD",name];
    }if ([name isEqualToString:@"粤贵铂"]) {
        newName = [NSString stringWithFormat:@"%@(g)GDPT",name];
    }
    return newName;
}
#pragma mark -- 获取品种的最新行情报价

//账号验证和手势验证的界面是否存在
-(BOOL)checkCanGetDealData{

    BOOL isCan = YES;
    UIViewController *dealVC = self.parentViewController;
    NSArray *arr = dealVC.view.subviews;
    for (UIView *view in arr) {
        if (view.tag == VCViewTagLockVC || view.tag == VCViewTagSignVC) {
            isCan = NO;
            break;
        }
    }
    return isCan;
}

-(void)getDealData{
    
    if (_varietyTitleArr.count > 0) {
        //已经存在数据暂时不获取
        return;
    }else{
        if ([self checkCanGetDealData]) {//判断是否能够获取数据
            _varietyTitleArr = [[NSMutableArray alloc] initWithCapacity:1];
            _varietyModelArr = [[NSMutableArray alloc] initWithCapacity:1];
            [[DealSocketTool shareInstance] req_QuOTEWithBlock:^(NSArray<CommodityInfoModel *> *modelArr) {
            
                for (CommodityInfoModel *model in modelArr) {
                    [_varietyTitleArr addObject:[self getCommodityName:model.CommodityName]];
                    [_varietyModelArr addObject:model];
                    
                    [NSUserDefaults setObject:model.WeightStep forKey:[NSString stringWithFormat:@"%@WeightStep",model.CommodityID]];//保存重量步进值
                    [NSUserDefaults setObject:model.WeightRadio forKey:[NSString stringWithFormat:@"%@WeightRadio",model.CommodityID]];//保存重量换算
                }
                LOG(@"~~~~~~~~行情品种model个数:%li",(unsigned long)_varietyTitleArr.count);
                if (_varietyTitleArr.count > 0) {
                    _titleMsgLbl.hidden = YES;
                }else{
                    _titleMsgLbl.hidden = NO;
                }
                //获取当前品种的数据
                [self getDataFromInterNetByVarietyIndex:_currentIndex FirstIn:YES];
            }];
        }
    }
}

#pragma mark -- 履约准备金 和 成交后手续费
-(void)setUpPriceRateWithNewPrice:(NSString *)newPrice{

    double weight = [self getWeight];
    double WeightRadio;
    double DepositeRate;
    DepositeRate = [self.openMarketOrderConfModel.DepositeRate doubleValue];
    WeightRadio = [self.openMarketOrderConfModel.WeightRadio doubleValue];
    
    //1.履约准备金。计算公式为，履约准备金=买入价×买入数量×重量换算×准备金率。
    _reserve = [newPrice doubleValue] * weight * WeightRadio * DepositeRate;
    _markView.reserveLbl.text = [NSString stringWithFormat:@"履约准备金:%.2f",_reserve];

    //2.成交后手续费。计算公式为，成交后手续费=买入价×买入数量×重量换算×手续费率。
     _counterFee = [newPrice doubleValue] * weight * WeightRadio * HandlingRate;
    _markView.counterFeeLbl.text = [NSString stringWithFormat:@"成交后手续费:%.2f",_counterFee];
}

#pragma mark -- 获取最新价[注:此处逻辑是卖出价为最新价](主推或者更换品种时候调用)
-(void)getNewPrice:(NSString *)newPrice FromType:(NSString *) fromeType{
    
    NSString *priceDigit = [Util getPriceDigitByComID:self.commodityInfoModel.CommodityID];
    self.NewPrice = newPrice;
    //(名称,最新价,涨跌幅)
#pragma -- xinle 行情数据不根据交易的数据刷新(屏蔽)
    if ([fromeType isEqualToString:@"行情"]) {
        [_vTitleView setNewPriceValue:newPrice Fluctuation_percent:self.model.fluctuation_percent];
    }
    //指价
    [_indexView setRangeValue:newPrice UpValue:([NSString stringWithFormat:@"%f",([self LimitSpread])]) DownValue:[NSString stringWithFormat:@"%f",([self LimitSpread])] FixedSpread:[NSString stringWithFormat:@"%f",([self FixSpread])]];
    //实时变化(买涨:最新价+固定点差 买跌:最新价)
    if (_type == BuyOrderTypeUp) {
        newPrice = [NSString stringWithFormat:priceDigit,([newPrice doubleValue] + ([self FixSpread]))];//(买涨:最新价+固定点差)
    }else{
        newPrice = [NSString stringWithFormat:priceDigit,([newPrice doubleValue])];//(买跌:最新价)
    }
    _markView.NewPrice = newPrice;
    //履约准备金 和 成交后手续费
    [self setUpPriceRateWithNewPrice:newPrice];

    //最大可买重量随价格变化而变动 -- xinle 2017.02.21
    [self setUpCanByWeightLblValueWithPrice:newPrice.doubleValue];
}

#pragma mark -- 切换品种数据清空
-(void)reloadPrecisionWithComID:(NSString *) CommID{

    if ([CommID isEqualToString:@"100000000"]) {//粤贵银//是否可以输入小数点
        _indexView.precision = 0;//不能输入小数
    }else{
        _indexView.precision = 2;//两位小数
    }

}

-(void)changeDataByCommID:(NSString *)CommID{

    _indexView.priceValueStepper.txtCount.text = @"";
    _indexView.priceValueStepper.txtCount.placeholder = @"0";
    [_indexView.stopPrice.stopUp cancelSelected];
    [_indexView.stopPrice.stopDown cancelSelected];
    _weightView.weightStepper.txtCount.text = @"";
    _weightView.weightStepper.txtCount.placeholder = @"0";
    [_weightView unitBtnClick:nil];
    [self reloadPrecisionWithComID:CommID];
}

#pragma mark -- 获取当前品种的开仓平仓的配置信息
-(void)getDataFromInterNetByVarietyIndex:(NSInteger) index FirstIn:(BOOL) isFirstIn{
    
    if (_varietyModelArr.count == 0) {
        [self getDealData];//获取最新数据
    }else{
    
        if (_varietyTitleArr.count > 3) {
            [_varietyTitleArr removeAllObjects];
            [_varietyModelArr removeAllObjects];
            return;
        }
        //1.0当前品种的最新行情信息
        CommodityInfoModel *commodityInfoModel = _varietyModelArr[index];//当前的品种信息
        self.commodityInfoModel = commodityInfoModel;//缓存当前品种信息
        
        //如果第一遍获取基本的品种信息失败,会再次拉取 2017.02.22 xinle
        if (commodityInfoModel.CommodityID == nil) {
            [self getDealData];
        }
        
//        [self changeDataByCommID:commodityInfoModel.CommodityID];
        NSString *code = commodityInfoModel.CommodityID;
        if (_currentIndex != index || _isSuccessDeal) {
            //切换品种,重量,价格,止盈,止损等全部清零
            [self changeDataByCommID:code];
        }
        [_vTitleView.titleBtn setTitle:_varietyTitleArr[index] forState:(UIControlStateNormal)];
        NSDictionary *weightDic = [Util weightStepDicByComID];
        NSArray *items = weightDic[code];
        if ((_currentIndex != index) || isFirstIn == YES) {
            self.weightView.unitValueLbl.text = [NSString stringWithFormat:@"X%@kg",items[0]];//每次切换品种修改默认计量单位
            self.unit = items[0];
        }
        
        //2.0品种建单的配置信息
        if (_priceType == PriceOrderTypeMarket) {
            //市价(买涨,买跌)
            [[DealSocketTool shareInstance] getOpenMarketOrderConByCommodityID:([code intValue]) WithBlock:^(OpenMarketOrderConfModel *model) {
                
                _markView.allowTF.text = model.DefaultTradeRange;
                self.openMarketOrderConfModel = model;
            }];
        }else if (_priceType == PriceOrderTypeIndex){
            //指价(买涨,买跌)
            [[DealSocketTool shareInstance] getOpenLimitOrderConByCommodityID:([code intValue]) WithBlock:^(OpenLimitOrderConfModel *model) {
                
                self.openLimitOrderConfModel = model;
                [_indexView setUpValue:[NSString stringWithFormat:@"%f",([self TPSpread])] DownValue:[NSString stringWithFormat:@"%f",([self SLSpread])] FixedSpread:[NSString stringWithFormat:@"%f",([self FixSpread])]];//设置止盈止损的点差
                [_indexView.stopPrice setStopValue:_indexView.priceValueStepper.txtCount.text OrderType:_type UpValue:[NSString stringWithFormat:@"%f",([self TPSpread])] DownValue:[NSString stringWithFormat:@"%f",([self SLSpread])] FixedSpread:[NSString stringWithFormat:@"%f",([self FixSpread])]];
            }];
        }
        
        //获取最新的账户余额
        [self getAccntAmountWithBlock:^(NSString *amount) {
            self.ExchangeReserve = amount;
            
//            [self setUpCanByWeightLblValueWithPrice:self.NewPrice.doubleValue];//根据最新的余额计算可买重量
            
            //及时切换价格信息
            [[DealSocketTool shareInstance] REQ_QUOTEBYID:[self.commodityInfoModel.CommodityID intValue] WithBlock:^(RealTimeQuote stu) {
                
                if (_type == BuyOrderTypeUp) {//买涨
                    [self getNewPrice:[NSString stringWithFormat:@"%.2f",stu.BuyPrice] FromType:@"交易"];
                }else if(_type == BuyOrderTypeDown){//买跌
                    [self getNewPrice:[NSString stringWithFormat:@"%.2f",stu.SellPrice] FromType:@"交易"];
                }
            }];

            
        }];
        _currentIndex = index;
        
        
//        原来的取数据的模式 -- 更换为上边的实时拉取最新的报价信息 2017.02.22 xinle
//        if (_type == BuyOrderTypeUp) {
//            [self getNewPrice:self.commodityInfoModel.BuyPrice FromType:@"交易"];
//        }else if(_type == BuyOrderTypeDown){
//            [self getNewPrice:self.commodityInfoModel.SellPrice FromType:@"交易"];
//        }
//        _currentIndex = index;
    }
}

#pragma mark -- 获取最新的账户余额
-(void)getAccntAmountWithBlock:(void(^)(NSString * amount)) amountBlock{

    [[DealSocketTool shareInstance] getAccntInfoWithBlock:^(AccountInfoModel *model) {
        amountBlock(model.ExchangeReserve);
    } isHUDHidden:NO];
}

#pragma mark -- 计算可买重量赋值并返回数据
-(double)setUpCanByWeightLblValueWithPrice:(double) price{

    //可买重量=余额÷（买入价×合约单位×（准备金率+手续费率）），即可买重量= Amount÷（BuyPrice×AgreeUnit×（DepositeRate+手续费率））。
    
    double weight;
//    double price;
    double AgreeUnit;
    double DepositeRate;
    if (_priceType == PriceOrderTypeMarket) {//市价
        
//        if (_type == BuyOrderTypeUp) {//买涨
//            price = [self.commodityInfoModel.BuyPrice doubleValue];
//        }else if(_type == BuyOrderTypeDown){//买跌
//            price = [self.commodityInfoModel.SellPrice doubleValue];
//        }
//        此处的价格修改为最新的行情报价
        
        
        AgreeUnit =  [self.openMarketOrderConfModel.AgreeUnit doubleValue];
        DepositeRate = [self.openMarketOrderConfModel.DepositeRate doubleValue];
    }else{
        //指价
        price = [_indexView.priceValueStepper.txtCount.text doubleValue];
        AgreeUnit =  [self.openLimitOrderConfModel.AgreeUnit doubleValue];
        DepositeRate = [self.openLimitOrderConfModel.DepositeRate doubleValue];
    }

    if (price == 0) {//价格为零时处理
        weight = 0;
    }else{
        //可买重量=交易准备金÷下单价格÷(准备金率+手续费率)÷重量转换
        double ExchangeReserve = [self.ExchangeReserve doubleValue];
        if (ExchangeReserve <= 0) {
            weight = 0;
        }else{
            weight = ExchangeReserve / price / (DepositeRate + HandlingRate) / [self.commodityInfoModel.WeightRadio doubleValue];
        }
    }
    
     NSInteger n = [self getWeightDigitByWeightStep:self.commodityInfoModel.WeightStep];
    
//    //1.0 原始代码 四舍五入,计算有误
//    NSString *str = @"%%.%@fkg";
//    NSString *weightDigit = [NSString stringWithFormat:str,@(n)];
//    NSString *weightStr = [NSString stringWithFormat:weightDigit,weight];
    
    //2.0 修改为不用四舍五入
    NSString *weightStr = [NSString stringWithFormat:@"%@kg",[Util notRounding:weight afterPoint:(int)n]];
    
    _weightView.canBuyTitleLbl.attributedText = [Util setStringsArr:@[@"最大可买重量:",weightStr] ColorsArr:@[[UIColor lightGrayColor],[UIColor blackColor]] FontsArr:@[FONT(12),FONT(12)]];
    return weight;
}

//根据重量步进值精确小数位
-(NSInteger)getWeightDigitByWeightStep:(NSString *)WeightStep{
    
    if ([WeightStep isEqualToString:@"0.100000"] || [WeightStep doubleValue] == 0.1) {
        return 1;
    }else{
        return 3;
    }
}

#pragma mark -- 获取所买重量
-(double)getWeight{

    CGFloat weight;
//    if (_weightChooseType == 0) {
//        //手动输入类型
//        weight = _weightView.weightStepper.txtCount.text.doubleValue * self.unit.doubleValue;
//    }else{
//        //快速选择重量(可买重量 / 快速选择)
//        weight = [self setUpCanByWeightLblValue] / _weightChooseType;
//    }
    
    weight = _weightView.weightStepper.txtCount.text.doubleValue * self.unit.doubleValue;
    return weight;
}

//资金转入,转出
-(void)myTransferInOrOut:(TranserType) type{
    
    UITabBarController *tabVC = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    UINavigationController *nav = tabVC.childViewControllers[2];
    NSArray *arr = nav.childViewControllers;
    DealViewController *dealVC;
    for (id vc in arr) {
        if ([vc isKindOfClass:[DealViewController class]]) {
            dealVC = vc;
            break;
        }
    }
    dealVC.fromType = DealFromTypeTabbar;
    [dealVC.contentScrollView setContentOffset:CGPointMake(WIDTH * 3, 0) animated:YES];
    MyTransferViewController *detailVC = dealVC.childViewControllers[3];
    detailVC.segmentControl.selectedSegmentIndex = type;
    [detailVC actionSegmentControl:detailVC.segmentControl];
    tabVC.selectedIndex = 2;
    [dealVC viewWillAppear:YES];
}
#pragma mark -- 计算限价点差,固定点差,止盈点差,止损点差

-(double)LimitSpread{//限价点差

    return self.openLimitOrderConfModel.LimitSpread.doubleValue * self.openLimitOrderConfModel.MinPriceUnit.doubleValue;
}

-(double)FixSpread{//固定点差
    
    return self.commodityInfoModel.FixedSpread.doubleValue * self.commodityInfoModel.MinPriceUnit.doubleValue;
}

-(double)TPSpread{//止盈点差
    
    return self.openLimitOrderConfModel.TPSpread.doubleValue * self.openLimitOrderConfModel.MinPriceUnit.doubleValue;
}

-(double)SLSpread{//止损点差
    
    return self.openLimitOrderConfModel.SLSpread.doubleValue * self.openLimitOrderConfModel.MinPriceUnit.doubleValue;
}


#pragma mark -- 获取当前单据的有效信息
-(BOOL)getOrderWeight:(void (^)(NSString * weightStr)) weightBlock{

    double weightF = [self getWeight];
    if (weightF == 0) {
        [Util showHUDAddTo:self.view Text:@"买入重量不能为零"];
        return NO;
    }
    double canBuyWeight = [self setUpCanByWeightLblValueWithPrice:self.NewPrice.doubleValue];
    if (weightF > canBuyWeight) {
        
        [Util alertViewWithCancelBtnAndMessage:@"您的可用资金不足,切换较小重量单位或转入资金" Target:self doActionBtn:@"立即转账" handler:^(UIAlertAction *action) {
            [self myTransferInOrOut:TranserTypeIn];//转入资金
        }];
        return NO;
    }
    
    //    新商品，dbWeight* nQuantity必须在[MinTotalWeight,MaxTotalWeight]范围内。dbWeight须是 MinTotalWeight + N* WeightStep;  (N为正数)
    int nQuantity= 1;//设置交易手数,默认为1
    if (_priceType == PriceOrderTypeMarket) {
        
        if (!(weightF * nQuantity >= self.openMarketOrderConfModel.MinTotalWeight.doubleValue && weightF * nQuantity <= self.openMarketOrderConfModel.MaxTotalWeight.doubleValue)) {
            
            [Util alertViewWithMessage:[NSString stringWithFormat:@"买入重量超出范围:[%.3fkg,%.0fkg]",self.openMarketOrderConfModel.MinTotalWeight.doubleValue,self.openMarketOrderConfModel.MaxTotalWeight.doubleValue] Target:self];
            return NO;
        }
        
    }else if(_priceType == PriceOrderTypeIndex){
        
        if (!(weightF * nQuantity >= self.openLimitOrderConfModel.MinTotalWeight.doubleValue && weightF * nQuantity <= self.openLimitOrderConfModel.MaxTotalWeight.doubleValue)) {
            
            [Util alertViewWithMessage:[NSString stringWithFormat:@"买入重量超出范围:[%.3fkg,%.0fkg]",self.openLimitOrderConfModel.MinTotalWeight.doubleValue,self.openLimitOrderConfModel.MaxTotalWeight.doubleValue] Target:self];
            return NO;
        }
    }
    
    NSString *pointStr = [NSString stringWithFormat:@"%%.0fkg"];
    if (self.unit.doubleValue < 1) {
        int count;
        if ([_unit isEqualToString:@"0.001"]) {
            count = 3;
        }else{
            count =  ( 1 / _unit.doubleValue) / 10;
        }
        pointStr = [NSString stringWithFormat:@"%%.%ifkg",count];
    }
    NSString *weight = [NSString stringWithFormat:pointStr,weightF]; //获取当前单据上边的重量信息
    weightBlock(weight);
    return YES;
}

-(BOOL)getOrderIndexPrice:(void (^)(NSString *NewPriceStr,NSString *stopUpStr,NSString *stopDownStr)) indexPriceBlock{

    //指价
    
    if (_indexView.priceValueStepper.txtCount.text.doubleValue == 0) {
        [Util showHUDAddTo:self.view Text:@"买入价格不能为零"];
        return NO;
    }
    NSString *NewPrice = _indexView.priceValueStepper.txtCount.text;//价格
    
    //限价建仓价格不能在（商品卖价 - 限价点差，商品买价 + 限价点差）之间；
    //>=(商品买价 + 限价点差)
    double rangeDowndouble = (self.NewPrice.doubleValue) + ([self FixSpread]) + ([self LimitSpread]);
    //<=(商品卖价 - 限价点差)
    double rangeUpdouble = (self.NewPrice.doubleValue) - ([self LimitSpread]);
    if (!((NewPrice.doubleValue >= rangeDowndouble) || (NewPrice.doubleValue <= rangeUpdouble))) {
        [Util showHUDAddTo:self.view Text:@"买入价格不在安全范围内"];
        return NO;
    }
    
    NSString *stopUp = _indexView.stopPrice.stopUp.stepper.txtCount.text;//止盈价
    NSString *stopDown = _indexView.stopPrice.stopDown.stepper.txtCount.text;//止损价
    
    //    	买入时：
    //    止盈价>=  限价建仓价格 + 止盈价点差
    //    止损价<=  限价建仓价格 - 止损价点差 - 固定点差
    //    	卖出时：
    //    止盈价<=  限价建仓价格 - 止盈价点差
    //    止损价>=  限价建仓价格 + 止损价点差 + 固定点差
    //止盈价范围
    if (_indexView.stopPrice.stopUp.isSelected) {
        if ([stopUp isEqualToString:@""] || stopUp == nil || stopUp.doubleValue == 0) {
            [Util showHUDAddTo:self.view Text:@"您填写止盈价后提交"];
            return NO;
        }
        double stopUpValue;
        //买涨,买跌的浮动数目此处参考网易贵金属,以后暂定
        if (_type == BuyOrderTypeUp) {
            stopUpValue = (NewPrice.doubleValue + ([self TPSpread]) );
            if (!(stopUp.doubleValue >= stopUpValue)) {
                [Util showHUDAddTo:self.view Text:@"止盈价不符合条件"];
                return NO;
            }
        }else if (_type == BuyOrderTypeDown){
            stopUpValue = (NewPrice.doubleValue - [self TPSpread]);
            if (!(stopUp.doubleValue <= stopUpValue)) {
                [Util showHUDAddTo:self.view Text:@"止盈价不符合条件"];
                return NO;
            }
        }
    }
    //止损价范围
    if (_indexView.stopPrice.stopDown.isSelected) {
        if ([stopDown isEqualToString:@""] || stopDown == nil || stopDown.doubleValue == 0) {
            [Util showHUDAddTo:self.view Text:@"您填写止损价后提交"];
            return NO;
        }
        //买涨,买跌的浮动数目此处参考网易贵金属,以后暂定
        double stopDownValue;
        if (_type == BuyOrderTypeUp) {
            stopDownValue = (NewPrice.doubleValue - [self SLSpread] - [self FixSpread]);
            if (!(stopDown.doubleValue <= stopDownValue)) {
                [Util showHUDAddTo:self.view Text:@"止损价不符合条件"];
                return NO;
            }
        }else if (_type == BuyOrderTypeDown){
            stopDownValue = (NewPrice.doubleValue + [self SLSpread] + [self FixSpread]);
            if (!(stopDown.doubleValue >= stopDownValue)) {
                [Util showHUDAddTo:self.view Text:@"止损价不符合条件"];
                return NO;
            }
        }
    }
    
    indexPriceBlock(NewPrice,stopUp,stopDown);
    return YES;
}

#pragma mark -- 归集单据信息,下单建仓
-(void)getOrderDatas{
    
    if (_priceType == PriceOrderTypeIndex){
        //指价下单的价格不能为0
        if (_indexView.priceValueStepper.txtCount.text.doubleValue == 0) {
            [Util showHUDAddTo:self.view Text:@"买入价格不能为零"];
            return ;
        }
    }

    //获取重量
    __block NSString *weight;
    if (![self getOrderWeight:^(NSString *weightStr) {
        weight = weightStr;
    }]) {
        return;
    }
    
    NSString *TradeRange;
    if (!_markView.allowBtn.selected) {//允许价差
        TradeRange = _markView.allowTF.text;//允许价差
        //    	dbTradeRange 须在 [MinTradeRange, MaxTradeRange]范围内。
        if (!(TradeRange.doubleValue >= self.openMarketOrderConfModel.MinTradeRange.doubleValue && TradeRange.doubleValue <= self.openMarketOrderConfModel.MaxTradeRange.doubleValue)) {
            [Util alertViewWithMessage:[NSString stringWithFormat:@"允许价差超出范围:[%.0f,%.0f]",self.openMarketOrderConfModel.MinTradeRange.doubleValue,self.openMarketOrderConfModel.MaxTradeRange.doubleValue] Target:self];
            return ;
        }
    }else{
        TradeRange = @"0";
    }
    
    NSString *reserve = [NSString stringWithFormat:@"%.2f",_reserve];//履约手续费
    NSString *counterFee = [NSString stringWithFormat:@"%.2f",_counterFee];//参考手续费
    __block NSString *NewPrice;//价格
    __block NSString *stopUp;//止盈价
    __block NSString *stopDown;//止损价
    
    if (_priceType == PriceOrderTypeMarket) {
        //市价
        //此处的价格以交易所最新的行情报价为准 xinle  //NewPrice = _markView.priceValueLbl.text;//价格
        [[DealSocketTool shareInstance] REQ_QUOTEBYID:[self.commodityInfoModel.CommodityID intValue] WithBlock:^(RealTimeQuote stu) {
            
            if (_type == BuyOrderTypeUp) {//买涨
//              NewPrice = [NSString stringWithFormat:@"%.2f",stu.BuyPrice];
                NewPrice = [NSString stringWithFormat:[Util getPriceDigitByComID:self.commodityInfoModel.CommodityID],stu.BuyPrice];
            }else if(_type == BuyOrderTypeDown){//买跌
//              NewPrice = [NSString stringWithFormat:@"%.2f",stu.SellPrice];
                NewPrice = [NSString stringWithFormat:[Util getPriceDigitByComID:self.commodityInfoModel.CommodityID],stu.SellPrice];
            }
            
            _detailTitleArr = @[@"买入价格:  ",@"允许价差:  ",@"买入重量:  ",@"参考履约准备金:  ",@"参考手续费:  "];
            _detailValueArr = @[NewPrice,TradeRange,weight,reserve,counterFee];
            
            //市价建仓的入参
            self.openMarketOrderParamModel.nCommodityID = [self.commodityInfoModel.CommodityID intValue];
            self.openMarketOrderParamModel.dbPrice = [NewPrice doubleValue];
            self.openMarketOrderParamModel.dbWeight = [weight doubleValue];
            self.openMarketOrderParamModel.dbTradeRange = [TradeRange doubleValue];
            
            [self shouPopView];
        }];
    }else if (_priceType == PriceOrderTypeIndex){
        //指价
        if (![self getOrderIndexPrice:^(NSString *NewPriceStr, NSString *stopUpStr, NSString *stopDownStr) {
            NewPrice = NewPriceStr;
            stopUp = stopUpStr;
            stopDown = stopDownStr;
        }]) {
            return;
        }
        
        _detailTitleArr = @[@"买入价格:  ",@"买入重量:  ",@"参考履约准备金:  ",@"参考手续费:  "];
        _detailValueArr = @[NewPrice,weight,reserve,counterFee];
        
        //指价建仓的入参
        self.openLimitOrderParamModel.nCommodityID = [self.commodityInfoModel.CommodityID intValue];
        self.openLimitOrderParamModel.dbWeight = [weight doubleValue];			///< 交易重量(kg)
        self.openLimitOrderParamModel.dbOrderPrice = [NewPrice doubleValue];		///< 建仓单价
        self.openLimitOrderParamModel.dbTPPrice = [stopUp doubleValue];			///< 止盈价格
        self.openLimitOrderParamModel.dbSLPrice = [stopDown doubleValue];			///< 止损价格
        [self shouPopView];
    }
}

//刷新页面数据
-(void)reloadDataView{

    WEAK_SELF
    [weakSelf getDealData];//获取最新数据
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [weakSelf selectVarietyIndex:[weakSelf getNowIndex]];//行情图刷新,延时0.5秒
    });
    [weakSelf reloadPrecisionWithComID:weakSelf.commodityInfoModel.CommodityID];
    _isSuccessDeal = NO;
}

#pragma mark -- 展示下单的弹窗
-(void)shouPopView{

    [[KMPopView popWithType:_type PriceType:_priceType Title:_vTitleView.titleBtn.titleLabel.text DetailTitleLabels:_detailTitleArr DetailValueLabels:_detailValueArr sureBtn:_orderTypeStr cancel:@"取消" block:^(NSInteger index) {
        
        if(index == 1){
            LOG(@"~~~~下单");
            if (_priceType == PriceOrderTypeMarket) {
                //市价建仓
                [[DealSocketTool shareInstance] REQ_OPENMARKETWithParam:self.openMarketOrderParamModel ResultBlock:^(ProcessResult stu) {
                    
                    if (stu.RetCode == 99999) {
//                        [Util alertViewWithMessage:@"建仓成功" Target:self];
                        _isSuccessDeal = YES;
                        [self reloadDataView];
                        [Util showHUDAddTo:self.view Text:@"建仓成功"];
                        //刷新页面的数据
                        [self changeDataByCommID:self.commodityInfoModel.CommodityID];
                    }
                }];
                
            }else if (_priceType == PriceOrderTypeIndex){
                //指价建仓
                [[DealSocketTool shareInstance] REQ_OPENLIMITWithParam:self.openLimitOrderParamModel ResultBlock:^(ProcessResult stu) {
                    
                    if (stu.RetCode == 99999) {
//                        [Util alertViewWithMessage:@"委托成功" Target:self];
                        _isSuccessDeal = YES;
                        [self reloadDataView];
                        [Util showHUDAddTo:self.view Text:@"委托成功"];
                        //刷新页面的数据
                        [self changeDataByCommID:self.commodityInfoModel.CommodityID];
                    }
                }];
            }
        }
    } canTapCancel:YES] show] ;

}

#pragma mark -- 下单按钮
-(void)btnClick:(UIButton *)btn{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(okBtnClicked) object:nil];
    [self okBtnClicked];
}

-(void)okBtnClicked{

    //计量单位消失
    [self unitDismiss];
    //获取市场开休市状态
    [[DealSocketTool shareInstance] getMarketstatusWithStatusBlock:^(unsigned short isSuccess, NSString *statusStr) {
        
        if (isSuccess == 0) {//休市返回
            //            [HUDTool showText:statusStr];
            [Util alertViewWithMessage:statusStr Target:self];
            return ;
        }else{
            [self getOrderDatas];
        }
    }];

}

#pragma mark -- 下单方式切换
-(void)actionSegmentControl:(UISegmentedControl *)segment{
    
    [self.view endEditing:YES];
    CGFloat spacing = 10;
    if (segment.selectedSegmentIndex == 0) {
        _priceType = PriceOrderTypeMarket;//市价
        _markView.hidden = NO;
        _indexView.hidden = YES;
        _orderBtn.frame = CGRectMake(spacing, NH(_markView) + 10, WIDTH - 2 * spacing, 44);
        [self setScrollContentSize];
    }else if (segment.selectedSegmentIndex == 1){
        _priceType = PriceOrderTypeIndex;//指价
        _markView.hidden = YES;
        _indexView.hidden = NO;
        _orderBtn.frame = CGRectMake(spacing, NH(_indexView) + 10, WIDTH - 2 * spacing, 44);
        [self setScrollContentSize];
    }
    //重量选择
    [self setWeightViewFrameWithCharViewHidden:self.sharingView.hidden];
    [self getDataFromInterNetByVarietyIndex:_currentIndex FirstIn:NO];
    //计量单位消失
    [self unitDismiss];
}
#pragma mark -- 下拉计量单位消失
-(void)unitDismiss{
    //计量单位消失
    [NSUserDefaults setBool:NO forKey:@"UnitChoose"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnitTransForm" object:nil];
    if (_weightView.unitDismissBlock) {
        _weightView.unitDismissBlock();
    }
}

@end
