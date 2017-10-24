//
//  MyAssetsViewController.m
//  isInvested
//
//  Created by Ben on 16/8/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MyAssetsViewController.h"
#import "JHChartHeader.h"
#import "LDProgressView.h"
#import "HoldTableHeadView.h"
#import "DealViewController.h"
#import "MyTransferViewController.h"
#import "TwoHLblView.h"
#import "LockController.h"
#import "SignerViewController.h"
#import "OpenAccountImageView.h"
#import "IINavigationController.h"
#import "ChooseBankViewController.h"
#import "NormalInfoViewController.h"

@interface MyAssetsViewController ()
{

    CGFloat _height1;
    CGFloat _height2;
}
@property(nonatomic,strong)NSArray *progressValuesArr;//进度条数据
@property(nonatomic,strong)NSArray *ringValuesArr;//环形图数据
@property (nonatomic, strong) HoldTableHeadView *headView;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) TwoHLblView *accountStructView;//账户结构
@property (nonatomic, strong) TwoHLblView *breakToalView;//盈亏合计
@property (nonatomic, strong) TwoHLblView *transToalView;//交易手续费
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) LockController *lockVC;
@property (nonatomic, strong) SignerViewController *singerVC;
@property (nonatomic, strong) OpenAccountImageView *khImgView ;//开户的界面

@property (nonatomic, strong) JHRingChart *ring;//环形图,只创建一次
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MyAssetsViewController

-(void)dealloc{

    LOG(@"MyAssetsViewController 销毁~~");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    LOG(@"HoldTableViewController~~~~~~~~appear");
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    LOG(@"HoldTableViewController~~~~~~~~disAppear");
}


//身份验证
-(void)setUpsingerVC{

    //2.判断是否开户
    BOOL openAccount = [NSUserDefaults boolForKey:isOpenAccount];
    WEAK_SELF
    if (_khImgView == nil){
        _khImgView = [[OpenAccountImageView alloc] initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT)];
        _khImgView.tag = 100;
    }
    if (openAccount != YES) {
        _khImgView.openAccountBlock = ^(){
            NormalInfoViewController *normalVC = [[NormalInfoViewController alloc] init];
            IINavigationController*normalNVC = [[IINavigationController alloc] initWithRootViewController:normalVC];
            weakSelf.navigationController.navigationBar.hidden = NO;
            [weakSelf presentViewController:normalNVC animated:YES completion:nil];
        };
        [_khImgView removeFromSuperview];
        [weakSelf.view addSubview:_khImgView];
    }else{
        //新浪支付未绑卡时
        BOOL sign = [NSUserDefaults boolForKey:isSinaAccountBangding];
        if (sign != YES) {
            _khImgView.openAccountBlock = ^(){
                ChooseBankViewController *bankVC = [[ChooseBankViewController alloc] init];
                IINavigationController*bankNVC = [[IINavigationController alloc] initWithRootViewController:bankVC];
                weakSelf.navigationController.navigationBar.hidden = NO;
                [weakSelf presentViewController:bankNVC animated:YES completion:nil];
            };
            [_khImgView removeFromSuperview];
            [weakSelf.view addSubview:_khImgView];
        }else{
            [_khImgView removeFromSuperview];
        }
    }
    //3.手势是否开启
    BOOL isSH = [NSUserDefaults boolForKey:[Util isSHPassWord]];
    if (isSH == YES) {
        //手势解锁的界面
        [_singerVC.view removeFromSuperview];
        //判断是否超时
        NSDate *date = [NSUserDefaults objectForKey:LastOpenTime];
        if (_fromType != 1) {
            //验证一次还是每次都验证
            if (_lockVC == nil) {
                _lockVC = [[LockController alloc] initWithLockType:LockTypeOpen];
                _lockVC.appearType = LockAppearTypeAddView;
                [_lockVC viewWillAppear:YES];
                [weakSelf.view addSubview:_lockVC.view];
            }
//            if ([Util compareWithCurrentTimeByCompareDate:date WithMin:10]) {
//                [[DealSocketTool shareInstance] cutOffSocket];//超时断开连接
//                [_lockVC viewWillAppear:YES];
//                _lockVC.view.frame = CGRectMake(0, -64, WIDTH, HEIGHT + 64);
//                [weakSelf.view addSubview:_lockVC.view];
//            }else{
//                [_lockVC.view removeFromSuperview];
//            }
            
            //修改替换为socket 连接状态 2017.01.22
            if (![DealSocketTool shareInstance].connectToRemote) {
                [_lockVC viewWillAppear:YES];
                _lockVC.view.frame = CGRectMake(0, -64, WIDTH, HEIGHT + 64);
                [weakSelf.view addSubview:_lockVC.view];
            }else{
                [_lockVC.view removeFromSuperview];
            }

        }
    }else{
        [_lockVC.view removeFromSuperview];
        //判断是否超时
        NSDate *date = [NSUserDefaults objectForKey:LastOpenTime];
        if (_fromType != 1) {
            
            //身份验证的界面
            if (weakSelf.singerVC == nil) {
                weakSelf.singerVC = [[SignerViewController alloc] init];
                weakSelf.singerVC.appearType = AppearTypeAddView;
                weakSelf.singerVC.signerType = SignerTypeTouchID;
                //            [weakSelf.singerVC viewWillAppear:YES];
                //            [weakSelf.view addSubview:weakSelf.singerVC.view];
            }
            _singerVC.accountNum.textF.text = [NSUserDefaults objectForKey:KHAccount];
            
//            if ([Util compareWithCurrentTimeByCompareDate:date WithMin:10]) {
//                [[DealSocketTool shareInstance] cutOffSocket];//超时断开连接
//                [_singerVC viewWillAppear:YES];
//                [weakSelf.view addSubview:_singerVC.view];
//            }else{
//                [_singerVC.view removeFromSuperview];
//            }
            
            //修改替换为socket 连接状态 2017.01.22
            if (![DealSocketTool shareInstance].connectToRemote) {
                [_singerVC viewWillAppear:YES];
                [weakSelf.view addSubview:_singerVC.view];
            }else{
                [_singerVC.view removeFromSuperview];
            }

        }
    }
    
    //4.最终处理
    BOOL sign = [NSUserDefaults boolForKey:isSinaAccountBangding];// 是否新浪支付签约
    if (openAccount != YES || sign != YES) {
        [_lockVC.view removeFromSuperview];
        [_singerVC.view removeFromSuperview];
    }
}

//初始化子界面
-(void)setUpAllSubViewsWithModel:(AccountInfoModel *) model{

    //转入转出资金
    [self setUpBtns];
    [self setUpTitleLabelViews1];//账户结构/重仓,
    //可用金(交易准备金),持仓(履约准备金)
    //持仓占比 =账户履约保证金÷账户净值×100%
    double fPerformanceReserve = ([model.PerformanceReserve doubleValue] / [model.NAVPrice doubleValue]) * 100;
    NSString *sPerformanceReserve = [NSString stringWithFormat:@"%f",fPerformanceReserve];
    NSString *sExchangeReserve = [NSString stringWithFormat:@"%f",(100 - fPerformanceReserve)];
    if (sExchangeReserve.doubleValue < 0) {
        sExchangeReserve = @"0";
    }
    _ringValuesArr = @[sExchangeReserve,sPerformanceReserve];
    [self showRingChartView];//环形条
    //持仓保证金(履约准备金),预扣保证金(冻结准备金)
    _progressValuesArr = @[model.PerformanceReserve,model.FrozenReserve];
    [self initProgress];//资金进度条
    [self setUpTitleLabelViews2];//当日统计,盈亏合计,交易手续费
}

//计时器
-(NSTimer *)timer{
    
    if (_timer == nil) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(openTimerFire) userInfo:nil repeats:YES];
    }
    
    return _timer;
}

-(void)openTimerFire{

    if ([[DealSocketTool shareInstance] connectToRemote]) {
        
        [self getAccntInfoWithisHUDHidden:YES];
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
//获取账号信息
-(void)getAccntInfo{
    [self timerFire];
//    [self getAccntInfoWithisHUDHidden:NO];
}
-(void)getAccntInfoWithisHUDHidden:(BOOL)isHUDHidden{
    [[DealSocketTool shareInstance] getAccntInfoWithBlock:^(AccountInfoModel *model) {
        [_headView reloadViewByAccountInfoModel:model];
        
        double fPerformanceReserve = ([model.PerformanceReserve doubleValue] / [model.NAVPrice doubleValue]) * 100;
        
        if (_ring == nil) {
            [self setUpAllSubViewsWithModel:model];
        }
        LOG(@"~~~~~~持仓占比:%f",fPerformanceReserve);
        //轻仓,重仓
        _transToalView.ValueLbl.text = [Util holdTypeWithFrozenReserve:model.PerformanceReserve Amount:model.NAVPrice];
        //风险率
        _breakToalView.ValueLbl.text = [NSString stringWithFormat:@"%@%%",model.RiskRate];
    } isHUDHidden:isHUDHidden];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //登录成功 -- 进行数据的拉取
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAccntInfo) name:@"SignSuccess" object:nil];
    self.title=@"净资产";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    //黑色底部
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [Util navigationBarColor];
    backView.tag = 100;
    [_scrollView addSubview:backView];
    
    _headView = [[HoldTableHeadView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    _headView.frame = CGRectMake(0, 0, WIDTH, _headView.realHeight);
    _headView.titleLbl.text = @"";
    [_scrollView addSubview:_headView];
    [self setHeadViewColorAndTitle];
    [self setUpsingerVC];

    [self timerFire];
}
-(void)setUpBtns{
    CGFloat space = 20;
    CGFloat btnW = (WIDTH - 20 * 2) / 2.0;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(space, NH(_headView), btnW - 1, 30);
    [btn1 setTitle:@"转入资金" forState:UIControlStateNormal];
    [btn1 setTitleColor:[Util navigationBarColor] forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor whiteColor];
    btn1.layer.masksToBounds = YES;
    [self roundedView:btn1 byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(15, 15)];
    [btn1 addTarget:self action:@selector(inBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btn1 = btn1;
    [_scrollView addSubview:_btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(WIDTH / 2.0 + 1, NH(_headView), btnW - 1, 30);
    [btn2 setTitle:@"转出资金" forState:UIControlStateNormal];
    [btn2 setTitleColor:[Util navigationBarColor] forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.layer.masksToBounds = YES;
    [self roundedView:btn2 byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(15, 15)];
    [btn2 addTarget:self action:@selector(outBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btn2 = btn2;
    [_scrollView addSubview:_btn2];

    //黑色底部
    UIView *backView = [self.view viewWithTag:100];
    backView.frame = CGRectMake(0, 0, WIDTH, NH(btn2) + 20);
}
//资金转入,转出
-(void)myTransferInOrOut:(TranserType) type{
    
    if (self.transInOutBlock) {
        self.transInOutBlock();
    }
    UITabBarController *tabVC = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    UINavigationController *nav = tabVC.childViewControllers[2];
    [nav popToRootViewControllerAnimated:YES];
    NSArray *arr = nav.childViewControllers;
    if (_fromType == 1) {
        //从交易的持仓界面点击进入
        [self.navigationController popViewControllerAnimated:YES];
    }
    DealViewController *dealVC;
    for (id vc in arr) {
        if ([vc isKindOfClass:[DealViewController class]]) {
            dealVC = vc;
            break;
        }
    }
    
    dealVC.isNotFirstIn = YES;
    dealVC.fromType = DealFromTypeMyAccount;
    MyTransferViewController *detailVC = dealVC.childViewControllers[3];
    detailVC.segmentControl.selectedSegmentIndex = type;
    [detailVC actionSegmentControl:detailVC.segmentControl];
//    tabVC.selectedIndex = 2;
    [Util goToDeal];
    [dealVC viewWillAppear:YES];
}

-(void)inBtnClick:(UIButton *)btn{
    [self myTransferInOrOut:TranserTypeIn];
}

-(void)outBtnClick:(UIButton *)btn{
    [self myTransferInOrOut:TranserTypeOut];
}

//资金进度条
-(void)initProgress{

    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(15, NH(_accountStructView) + 30, WIDTH - 30, 30);
    label1.textColor = OXColor(0x333333);
    label1.text = @"持仓保证金(元)";
    [_scrollView addSubview:label1];

    //持仓保证金(元)
    LDProgressView *progressView1;
    UILabel *label;
    if ([_progressValuesArr[0] doubleValue] >= 0) {//此处修改为全部用数字显示 xinle 2016.12.16
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, NH(label1) + 5, WIDTH / 2.0, 22);
        label.text = _progressValuesArr[0];
        [_scrollView addSubview:label];
    }else{
        progressView1 = [[LDProgressView alloc] initWithFrame:CGRectMake(10, NH(label1) + 5, WIDTH / 2.0, 22)];
        progressView1.color = OrangeBackColor;
        progressView1.flat = @YES;
        progressView1.progress = [_progressValuesArr[0] floatValue] / ([_progressValuesArr[0] floatValue] + [_progressValuesArr[1] floatValue]);
        progressView1.values =_progressValuesArr[0];
        progressView1.animate = @NO;
        [_scrollView addSubview:progressView1];
    }
    
    UILabel *label2 = [[UILabel alloc] init];
    if (progressView1 == nil) {
        label2.frame = CGRectMake(15, NH(label) + 10, WIDTH - 30, 30);
    }else{
        label2.frame = CGRectMake(15, NH(progressView1) + 10, WIDTH - 30, 30);
    }
    label2.textColor = OXColor(0x333333);
    label2.text = @"预扣保证金(元)";
    [_scrollView addSubview:label2];
    
    //预扣保证金(元)
    if ([_progressValuesArr[1] doubleValue] >= 0) {//此处修改为全部用数字显示 xinle 2016.12.16
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, NH(label2) + 5, WIDTH / 2.0, 22);
        label.text = _progressValuesArr[1];
        [_scrollView addSubview:label];
        _height1 = NH(label) + 10;
    }else{
        LDProgressView *progressView2 = [[LDProgressView alloc] initWithFrame:CGRectMake(10, NH(label2) + 5, WIDTH / 2.0, 22)];
        progressView2.color = OrangeBackColor;
        progressView2.flat = @YES;
        progressView2.progress = [_progressValuesArr[1] floatValue] / ([_progressValuesArr[0] floatValue] + [_progressValuesArr[1] floatValue]);
        progressView2.values =_progressValuesArr[1];
        progressView2.animate = @NO;
        [_scrollView addSubview:progressView2];
        _height1 = NH(progressView2) + 10;
    }
}

//环状图
- (void)showRingChartView{
    
    CGFloat ringW = WIDTH  / 2.0;
    _ring = [[JHRingChart alloc] initWithFrame:CGRectMake((WIDTH - ringW), NH(_accountStructView), ringW, ringW)];
    _ring.backgroundColor = [UIColor whiteColor];
    _ring.title = @"资金\n结构";
    _ring.valueDataArr = _ringValuesArr; //有顺序要求[可用金,持仓]
    _ring.detailTitles = @[@"可用金",@"持仓"];
    _ring.k_COLOR_STOCK = @[OXColor(0x48c9ff),OXColor(0xfb4c4c)];
    [_ring showAnimation];
    [_scrollView addSubview:_ring];
    _height2 = NH(_ring) + 10;
}

//账户结构/重仓,
-(void)setUpTitleLabelViews1{
    
    UIView *backView = [self.view viewWithTag:100];
    _accountStructView = [[TwoHLblView alloc] initWithFrame:CGRectMake(0, NH(backView), WIDTH, 40)];
    _accountStructView.TitleLbl.text = @"账户结构";
    _accountStructView.backgroundColor = OXColor(0xf5f5f5);
     _accountStructView.TitleLbl.textColor = OXColor(0x999999);
   CGRect frame = _accountStructView.ValueLbl.frame;
    _accountStructView.ValueLbl.frame = CGRectMake(WIDTH - 10 - 60, frame.origin.y + 5, 60,frame.size.height - 10);
    _accountStructView.ValueLbl.layer.masksToBounds = YES;
    _accountStructView.ValueLbl.textAlignment = NSTextAlignmentCenter;
    _accountStructView.ValueLbl.layer.cornerRadius = 3;
    _accountStructView.ValueLbl.backgroundColor = [UIColor lightGrayColor];
    _accountStructView.ValueLbl.textColor = [UIColor whiteColor];
    _accountStructView.ValueLbl.hidden = YES;//隐藏不可见
    [_scrollView addSubview:_accountStructView];
}
//风险构成,风险率,仓位
-(void)setUpTitleLabelViews2{
    
    [_scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, NH(_accountStructView), WIDTH, 0.5)]];
    CGFloat height = (_height1 > _height2) ? _height1 : _height2;
    
    [_scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, height, WIDTH, 0.5)]];
    TwoHLblView *label = [[TwoHLblView alloc] initWithFrame:CGRectMake(0, height, WIDTH, 40)];
    label.TitleLbl.text = @"风险构成";
    label.backgroundColor = OXColor(0xf5f5f5);
    label.TitleLbl.textColor = OXColor(0x999999);
    [_scrollView addSubview:label];
    
    [_scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, NH(label), WIDTH, 0.5)]];
    
    _breakToalView = [[TwoHLblView alloc] initWithFrame:CGRectMake(0, NH(label), WIDTH, 40)];
    _breakToalView.TitleLbl.text = @"风险率";
    [_scrollView addSubview:_breakToalView];
    [_scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(15, NH(_breakToalView), WIDTH, 0.5)]];
    
    _transToalView = [[TwoHLblView alloc] initWithFrame:CGRectMake(0, NH(_breakToalView), WIDTH, 40)];
    _transToalView.TitleLbl.text = @"仓位";
    [_scrollView addSubview:_transToalView];
    [_scrollView addSubview:[Util setUpLineWithFrame:CGRectMake(0, NH(_transToalView), WIDTH, 0.5)]];
    
    _scrollView.contentSize = CGSizeMake(0, NH(_transToalView) + 20);

}

# pragma mark -- 修改控件的某一个圆角
-(void)roundedView:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii{
    
    /*     参数说明
     view         要修改的控件
     corners      圆角位置,系统的枚举,多个参照下面
     cornerRadii  圆角的size
     */
    
    //贝塞尔曲线修圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    
    //修改显示layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
}

//设置head的显示颜色
-(void)setHeadViewColorAndTitle{

    
    _headView.titleLbl.textColor = OXColor(0xffffff);
    _headView.moneyLbl.textColor = OXColor(0xffffff);
    _headView.breakView.TitleLbl.text = @"持仓盈亏(元)";
    _headView.breakView.TitleLbl.textColor = OXColor(0xd5d7db);
    _headView.breakView.ValueLbl.textColor = OXColor(0xd5d7db);
    _headView.canUseMoneyView.TitleLbl.text = @"可用资金(元)";
    _headView.canUseMoneyView.TitleLbl.textColor = OXColor(0xd5d7db);
    _headView.canUseMoneyView.ValueLbl.textColor = OXColor(0xd5d7db);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
