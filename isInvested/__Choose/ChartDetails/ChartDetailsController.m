//
//  ChartDetailsController.m
//  isInvested
//
//  Created by Blue on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ChartDetailsController.h"
#import "SocketTool.h"
#import "IndexModel.h"
#import "TimeSharingView.h"
#import "KLineView.h"
#import "ChartMinutesMaskView.h"
#import "ChartMoreMinutesView.h"
#import "TurnButton.h"

@interface ChartDetailsController ()

/** 头部栏 */
@property (weak, nonatomic) IBOutlet UIButton *loadingButton;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *fluctuationL;
@property (weak, nonatomic) IBOutlet UILabel *fluctuation_percentL;
@property (weak, nonatomic) IBOutlet UILabel *todayL;
@property (weak, nonatomic) IBOutlet UILabel *preCloseL;
@property (weak, nonatomic) IBOutlet UILabel *maxL;
@property (weak, nonatomic) IBOutlet UILabel *minL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (nonatomic, assign) CGRect chartViewFrame;

/** 时间条 */
@property (nonatomic, strong) UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorView_xConstraint;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (nonatomic, strong) TimeSharingView *sharingView;
@property (nonatomic, strong) KLineView *kLineView;
@property (nonatomic, strong) ChartMoreMinutesView *minutesView;

/** 右上角的btn */
@property (nonatomic, strong) TurnButton *turnButton;
@property (nonatomic, strong) NSTimer *timer; //第分钟刷新的定时器
@end

@implementation ChartDetailsController

- (TurnButton *)turnButton {
    if (!_turnButton) {
        WEAK_SELF
        _turnButton = [[TurnButton alloc] init];
        _turnButton.frame = CGRectMake(WIDTH - 64, 20, 64, 44);
        _turnButton.objc1 = ^(){ //右上角点击事件
            [weakSelf refreshData];
        };
    }
    return _turnButton;
}

- (TimeSharingView *)sharingView {
    if (!_sharingView) {
        WEAK_SELF
        _sharingView = [TimeSharingView viewFromXid];
        _sharingView.frame = self.chartViewFrame;
        _sharingView.model = self.model;
        _sharingView.informationLabel = self.informationLabel;
        _sharingView.stopTurnBlock = ^(){ //来通知时, 改BOOL值, 以便及时停止
            weakSelf.turnButton.isStopTurn = YES;
        };
        _sharingView.refreshBlock = ^(){ //点击无网络view后刷新
            [weakSelf.turnButton performSelector:@selector(clicked)];
        };
    }
    return _sharingView;
}

- (KLineView *)kLineView {
    if (!_kLineView) {
        WEAK_SELF
        _kLineView = [KLineView viewFromXid];
        _kLineView.frame = self.chartViewFrame;
        _kLineView.informationLabel = self.informationLabel;
        _kLineView.stopTurnBlock = ^(){ //来通知时, 改BOOL值, 以便及时停止
            weakSelf.turnButton.isStopTurn = YES;
        };
        _kLineView.refreshBlock = ^(){ //点击无网络view后刷新
            [weakSelf.turnButton performSelector:@selector(clicked)];
        };
    }
    return _kLineView;
}

- (ChartMoreMinutesView *)minutesView {
    if (!_minutesView) {
        _minutesView = [ChartMoreMinutesView viewFromXid];
        WEAK_SELF
        _minutesView.clickedMinuteBlock = ^(NSInteger tag){
            [weakSelf.lastButton setTitle:[NSString stringWithFormat:@"%ld分", tag] forState:UIControlStateNormal];
            [weakSelf.minutesView.superview removeFromSuperview];
            [[SocketTool sharedSocketTool] setRequestStyle:(SocketRequestStyle)tag];
            
            weakSelf.kLineView.code = weakSelf.model.code;
            weakSelf.kLineView.style = tag;
            [weakSelf.kLineView clearDrawing];
            [weakSelf.view addSubview:weakSelf.kLineView];
            [weakSelf setTimeBarButtonStateWithButton:weakSelf.lastButton];
        };
    }
    return _minutesView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self removeTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 这个方法在switch后执行, 故省略setIndexes
    [[SocketTool sharedSocketTool] setRequestStyle:SocketRequestStyleRealTimeAndPush];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.turnButton];
    
    CGFloat chartViewY = 200.0 + 40.0;
    CGFloat chartViewHeight = [self.model.code_type isEqualToString:@"0x5a01"] ? HEIGHT - chartViewY - 44 : HEIGHT - chartViewY;
    self.chartViewFrame = CGRectMake(0, chartViewY, WIDTH, chartViewHeight);
    
    [self.view addSubview:[[UIView alloc]init]];//炮灰,不可删
    
    [[SocketTool sharedSocketTool] setIndexes:@[self.model]];
    [self clickedTimeBar:self.firstButton];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(reloadTitleViewData:) name:SocketRealTimeAndPushNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 更新顶部栏data */
- (void)setModel:(IndexModel *)model { _model = model;
    self.view.backgroundColor = OXColor(model.color);
    
    self.titleL.text = model.longName;                            //名称
    self.priceL.text = model.newPriceStr;                         //价格
    self.fluctuationL.text = model.fluctuationStr;                //涨跌
    self.fluctuation_percentL.text = model.fluctuationPercentStr; //涨跌幅
    self.todayL.text = model.openPriceStr;  //今天
    self.preCloseL.text = model.preCloseStr;//昨收
    self.maxL.text = model.maxPriceStr;     //最高
    self.minL.text = model.minPriceStr;     //最低
    self.timeL.text = model.dealTime;       //交易时间
}

#pragma mark - 点击事件

- (IBAction)clickedBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 点击时间条 */
- (IBAction)clickedTimeBar:(UIButton *)button {
    
    // 点击了非分钟btn && 当前btn已被选中, ==重复点击
    if (button.tag && self.selectButton == button) return;
    
    if (!button.tag) { // tag == 0, 点击了分钟
        [[[ChartMinutesMaskView alloc] init] setSubView:self.minutesView];
        return;
    }
    // 上次点击了具体的分钟, 本次点击了非分钟btn
    [self.lastButton setTitle:@"分钟" forState:UIControlStateNormal];
    self.minutesView.selectButton.selected = NO;
    
    [self setTimeBarButtonStateWithButton:button];
    [self.view.subviews.lastObject removeFromSuperview];
    [[SocketTool sharedSocketTool] setRequestStyle:button.tag];
    
    switch (button.tag) {
        case SocketRequestStyleTimeSharing:
            self.sharingView.style = button.tag;
            [self.sharingView clearDrawing];
            [self.view addSubview:self.sharingView];
            break;
        case SocketRequestStyle5days:
            self.sharingView.style = button.tag;
            [self.sharingView clearDrawing];
            [self.view addSubview:self.sharingView];
            break;
        default:
            self.kLineView.code = self.model.code;
            self.kLineView.style = button.tag;
            [self.kLineView clearDrawing];
            [self.view addSubview:self.kLineView];
            break;
    }
}

/** 将传入的btn设为选中状态 */
- (void)setTimeBarButtonStateWithButton:(UIButton *)button {
    
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.indicatorView_xConstraint.constant = self.selectButton.x;
    }];
}

/** 买涨下单or买跌下单 */
- (IBAction)clickedBuyRiseOrFall:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:NO];
    [Util goToDealFromeType:button.tag Code:self.model.code];
}

#pragma mark - 通知方法

- (void)reloadTitleViewData:(NSNotification *)notification {
    
    NSArray<IndexModel *> *array = notification.userInfo[@"userInfo"];
    
    //自选页会主推多个品种, 在自选页断开连接之前会收到一个或多个主推
    //如下判断可排除掉来自自选页的主推,
    if (array.count == 1 && [array[0].code isEqualToString:self.model.code]) {
        self.model = array[0];
    }
}

#pragma mark - Timer

- (void)addTimer {
    SocketRequestStyle style =  PRIORITY(self.selectButton.tag, self.lastButton.currentTitle.integerValue);
    if (style < SocketRequestStyleDayK) return;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60
                                                  target:self
                                                selector:@selector(refreshData)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)refreshData {
    SocketRequestStyle style =  PRIORITY(self.selectButton.tag, self.lastButton.currentTitle.integerValue);
    [[SocketTool sharedSocketTool] setRequestStyle:style];
}

@end
