//
//  DealViewController.m
//  isInvested
//
//  Created by Blue on 16/8/8.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "DealViewController.h"
#import "BuyUpDownOrderViewController.h"
#import "HoldTableViewController.h"
#import "MyTransferViewController.h"
#import "DealDetailsViewController.h"


@interface DealViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) NSArray *titlesArr;
@property(nonatomic,strong) NSArray *classTitles;//子页面的类名
@property (strong, nonatomic) UIScrollView *titleScrollView;
@property (nonatomic, assign) CGFloat scrollH;

@end

@implementation DealViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scrollH = 44;
        [self addChilds];
    }
    return self;
}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

// 此处逻辑待添加到tabbar的点击处 xinle
   // 未超时 && 可登陆 && 未连接 (进行登录服务器)
    BOOL bTime = [Util isDealSocketLoginOutOfTime];
    BOOL bCanLogin = [[DealSocketTool shareInstance] isKHAccountCanLogin];
    BOOL bConnect = [[DealSocketTool shareInstance] connectToRemote];
    
    if (!bTime && bCanLogin && !bConnect) {
        LOG(@"~~~~~~~~~~deal界面进行重新登录");
        [[DealSocketTool shareInstance] loginToServer];
    }
    
    if (_isNotFirstIn == NO) {//不是第一次进入
        //默认打开持仓,我的资产界面进入转账
        [self.contentScrollView setContentOffset:CGPointMake(WIDTH * 2, 0) animated:YES];
    }
    _isNotFirstIn = YES;
}

//身份验证成功
-(void)signSucess{
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    
    [[DealSocketTool shareInstance] req_QuOTEWithBlock:^(NSArray<CommodityInfoModel *> *modelArr) {
        
        for (CommodityInfoModel *model in modelArr) {
    
            [NSUserDefaults setObject:model.WeightStep forKey:[NSString stringWithFormat:@"%@WeightStep",model.CommodityID]];//保存重量步进值
            [NSUserDefaults setObject:model.WeightRadio forKey:[NSString stringWithFormat:@"%@WeightRadio",model.CommodityID]];//保存重量换算
        }
    }];
}
//socket断开连接
-(void)connectCutOff{
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //登录成功 -- 进行数据的拉取
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signSucess) name:@"SignSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signSucess) name:@"DealSignSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectCutOff) name:@"ConnectCutOff" object:nil];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickedBB) title:@"明细"];
//    self.navigationItem.rightBarButtonItem.customView.hidden = YES;

    // 临时btn
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(login) title:@"登录"];
    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, 0, 200, 30);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = OXColor(0xffffff);
//    label.text = @"广东贵金属交易所";
//    label.font = FONT(17);
//    self.navigationItem.titleView = label;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self connectCutOff];
    _titlesArr = @[@"买涨下单",@"买跌下单",@"合并持仓",@"我的转账"];
    [self setupTitle];
//    //默认打开持仓,我的资产界面进入转账(买涨,买跌,持仓,转账)四个界面跳转
//    [self.contentScrollView setContentOffset:CGPointMake(WIDTH * _fromType, 0) animated:YES];
}

-(void)setFromType:(DealFromType)fromType{

    _fromType = fromType;
    //默认打开持仓,我的资产界面进入转账(买涨,买跌,持仓,转账)四个界面跳转
    [self.contentScrollView setContentOffset:CGPointMake(WIDTH * fromType, 0) animated:YES];
}

-(void) addChilds{
    
    //买涨
    BuyUpDownOrderViewController *buyUpVc = [[BuyUpDownOrderViewController alloc] initWithMarketOrderType:BuyOrderTypeUp];
    [self addChildViewController:buyUpVc];
    //买跌
    BuyUpDownOrderViewController *buyDownVc = [[BuyUpDownOrderViewController alloc] initWithMarketOrderType:BuyOrderTypeDown];
    [self addChildViewController:buyDownVc];
    //持仓
    HoldTableViewController *holdVC = [[HoldTableViewController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:holdVC selector:NSSelectorFromString(@"timerFire") name:@"合并持仓" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:holdVC selector:NSSelectorFromString(@"timerInvalte") name:@"非合并持仓" object:nil];
    [self addChildViewController:holdVC];
    //我的转账
    MyTransferViewController *myVC = [[MyTransferViewController alloc] init];
    [self addChildViewController:myVC];
}

//头部滚动条
- (void)setupTitle
{
    
    _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _scrollH)];
    _titleScrollView.backgroundColor = [Util navigationBarColor];
   
    NSInteger count = _titlesArr.count;
//    CGFloat labelW = 100;
    CGFloat labelW = WIDTH / 4.0;
    _titleScrollView.contentSize = CGSizeMake(count * labelW, -_scrollH);
    
    for (NSInteger i = 0 ; i < count; i ++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 100 + i;
        label.text = _titlesArr[i];
        label.font = FONT(15);
        label.textColor = OXColor(0xd5d7db);
        if (i == 0) {
            label.textColor = OXColor(0xFFC751);
        }
        
        CGFloat labelH = _titleScrollView.bounds.size.height;
        CGFloat labelY = 0;
        CGFloat labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        //横线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(labelX, _scrollH - 2, labelW, labelH)];
        line.tag = 200 + i;
        line.backgroundColor = [UIColor clearColor];
        if (i == 0) {
            line.backgroundColor = OXColor(0xFFC751);
        }
        [_titleScrollView addSubview:line];

        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)]];
        
        [_titleScrollView addSubview:label];
    }
        self.contentScrollView.contentSize = CGSizeMake(count * [UIScreen mainScreen].bounds.size.width, 0);
    
    _titleScrollView.showsHorizontalScrollIndicator = NO;
     [self.view addSubview:_titleScrollView];

}

//标题点击事件
- (void)titleLabelClick:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    NSInteger index = tap.view.tag - 100;
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = index * self.contentScrollView.frame.size.width;
    
    [self.contentScrollView setContentOffset:offset animated:YES];
}

//下部分的内容视图
-(void)loadView{
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    //整屏横向滑动
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横向滑动
    
    //创建一个集合视图
    _contentScrollView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 28, WIDTH, HEIGHT - 28 - 64 - 49) collectionViewLayout:layout];
    if ([_contentScrollView canPerformAction:@selector(setPrefetchingEnabled:) withSender:nil]) {
        _contentScrollView.prefetchingEnabled = NO;//关闭预加载属性
    }
    // 指定集合视图的数据源
    WEAK_SELF
    _contentScrollView.dataSource = (id)weakSelf;
    _contentScrollView.delegate = (id)weakSelf;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.bounces = NO;
    [_contentScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    [view addSubview:_contentScrollView];
    
    self.view = view;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _titlesArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    for (UIView* view in cell.subviews) {
        [view removeFromSuperview];
    }

    //一次加载全部存在内存
    UIViewController *vc = self.childViewControllers[indexPath.item];
    
    CGRect frame = vc.view.frame;
    frame.origin.y = - cell.frame.origin.y + 16;
    if (indexPath.item ==2) {
        frame.size.height = HEIGHT - 64 - 49 - _scrollH;//合并持仓界面适应
    }
    vc.view.frame = frame;
    [cell addSubview:vc.view];
    
    return cell;
}

#pragma mark -scrollVeiwDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 向contentScrollView上添加控制器的View
    NSInteger index = offsetX / width;
    
    //循环处理label把颜色,大小复原 
    for (int i = 0; i < _titlesArr.count; i++) {
        
        UILabel *label = (UILabel *)[_titleScrollView viewWithTag:(100 + i)];
        if (i != index) {
            label.textColor = [UIColor whiteColor];
        }else{
            label.textColor = OXColor(0xFFC751);
        }
        
        UILabel *line = (UILabel *)[_titleScrollView viewWithTag:(200 + i)];
        if (i != index) {
            line.backgroundColor = [UIColor clearColor];
        }else{

            line.backgroundColor = OXColor(0xFFC751);
        }
    }
    
    
    
    // 设置顶部的titleScrollVeiw滚动到中间
    UILabel *label = [_titleScrollView viewWithTag:(100 + index)];
    CGPoint titleContentOffset = CGPointMake(label.center.x - width * 0.5, 0);
    
    //1.左边超出一般屏幕时保持title不动
    if (titleContentOffset.x < 0) titleContentOffset.x = 0;
    
    //2.右边最大滑动距离(contentoffset.x - 屏幕宽),相对位置都在一个屏幕内
    CGFloat maxTitleContentOffsetX = self.titleScrollView.contentSize.width - width;
    if (titleContentOffset.x > maxTitleContentOffsetX) titleContentOffset.x = maxTitleContentOffsetX;
    
    //3.动画改变位置
    [self.titleScrollView setContentOffset:titleContentOffset animated:YES];
    if (index == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"合并持仓" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"非合并持仓" object:nil];
    }
}

/**
 *  手动拖拽scrollView的时候才会调用这个方法,通过点击上面的方法导致的scrollView滚动快停止的时候不会调用这个方法
 *  拖拽结束的时候触发
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)clickedBB {
    DealDetailsViewController *vc = [[DealDetailsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
