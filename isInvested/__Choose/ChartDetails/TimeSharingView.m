//
//  TimeSharingView.m
//  isInvested
//
//  Created by Blue on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//  分时图

#import "TimeSharingView.h"
#import "ChartDetailsController.h"
#import "IndexModel.h"

@interface TimeSharingView ()

@property (weak, nonatomic) IBOutlet UILabel *leftL0;
@property (weak, nonatomic) IBOutlet UILabel *leftL1;
@property (weak, nonatomic) IBOutlet UILabel *leftL2;
@property (weak, nonatomic) IBOutlet UILabel *leftL3;
@property (weak, nonatomic) IBOutlet UILabel *leftL4;

@property (weak, nonatomic) IBOutlet UILabel *rightL0;
@property (weak, nonatomic) IBOutlet UILabel *rightL1;
@property (weak, nonatomic) IBOutlet UILabel *rightL3;
@property (weak, nonatomic) IBOutlet UILabel *rightL4;

@property (weak, nonatomic) IBOutlet UILabel *bottomL0;
@property (weak, nonatomic) IBOutlet UILabel *bottomL1;
@property (weak, nonatomic) IBOutlet UILabel *bottomL2;
@property (weak, nonatomic) IBOutlet UILabel *bottomL3;
@property (weak, nonatomic) IBOutlet UILabel *bottomL4;

@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) NSMutableArray<IndexModel *> *data;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat maxPrice;
@property (nonatomic, assign) CGFloat minPrice;
@property (nonatomic, assign) CGFloat preClose;
@property (nonatomic, assign) CGFloat scale;
/** 最大幅动值 */
@property (nonatomic, assign) CGFloat maxFluctuation;
@property (nonatomic, assign) CGFloat minWidth; //单条分钟占的宽度
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, strong) NSTimer *timer; //1秒没来通知, 就取本地资源

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalLineCenterY_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLineCenterX_constraint;

@property (weak, nonatomic) IBOutlet UIView *horizontalView;//隐藏/显示用
@property (weak, nonatomic) IBOutlet UIView *verticalView;//隐藏/显示用
@property (weak, nonatomic) IBOutlet UILabel *horizontalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *horizontalFluctuationLabel;
@property (weak, nonatomic) IBOutlet UILabel *verticalTimeLabel;
@end

@implementation TimeSharingView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.width = WIDTH;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(reloadTimeSharingData:)name:SocketTimeSharingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(reloadPushData:) name:SocketRealTimeAndPushNotification object:nil];
    
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
}

#pragma mark - 计算

- (void)createTimeLabel { //分时
    
    CGFloat singleW = (WIDTH - 2 * kMarginLeft) / 4.0;
    self.bottomL0.centerX = 12;
    self.bottomL1.centerX = singleW;
    self.bottomL3.centerX = singleW * 3.0;
    self.bottomL4.centerX = singleW * 4.0 - 12;
    
    NSArray<UILabel *> *subviews = self.bottomL0.superview.subviews;
    NSArray *array = [TxtTool timeSharingTimeArrayWithCodeType:self.model.code_type];
    
    for (NSInteger i = 0; i < 5; i++) {
        subviews[i].text = array[i];
    }
}

- (void)createDateLabelWithDateArray:(NSArray<NSString *> *)array { //5日
    
    CGFloat singleW = (WIDTH - 2 * kMarginLeft) / 5.0;
    self.bottomL0.centerX = singleW * 0.5;
    self.bottomL1.centerX = singleW * 1.5;
    self.bottomL3.centerX = singleW * 3.5;
    self.bottomL4.centerX = singleW * 4.5;
    
    NSInteger diff = [NSDate currentWeek] - 5;
    NSString *today = [@"yyyyMMdd" stringFromInterval1970: kInterval1970 - kOneDaySeconds * (diff < 0 ? 0 : diff) ];
    NSArray<UILabel *> *subviews = self.bottomL0.superview.subviews;
    
    for (NSInteger i = 0; i < 5; i++) {
        subviews[i].text = [array[i] isEqualToString:@"0"] ? today : array[i];
    }
}

- (void)calculateRoundValue {
    // 左侧列
    NSString *format = [self.model.name isEqualToString:@"美元人民币"] ? @"%.4f" : @"%.2f";
    self.maxFluctuation = MAX((self.maxPrice - self.preClose), (self.preClose - self.minPrice));
    self.leftL2.text = [NSString stringWithFormat:format, self.preClose / self.model.priceunit];
    self.leftL0.text = [NSString stringWithFormat:format, (self.preClose + self.maxFluctuation) / self.model.priceunit];
    self.leftL4.text = [NSString stringWithFormat:format, (self.preClose - self.maxFluctuation) / self.model.priceunit];
    self.leftL1.text = [NSString stringWithFormat:format, (self.preClose + self.maxFluctuation / 2) / self.model.priceunit];
    self.leftL3.text = [NSString stringWithFormat:format, (self.preClose - self.maxFluctuation / 2) / self.model.priceunit];
    // 右侧列
    CGFloat maxFluctuationPercent = self.maxFluctuation / self.preClose * 100;
    self.rightL0.text = [NSString stringWithFormat:@"%.2f%%", maxFluctuationPercent];
    self.rightL4.text = [NSString stringWithFormat:@"-%.2f%%", maxFluctuationPercent];
    self.rightL1.text = [NSString stringWithFormat:@"%.2f%%", maxFluctuationPercent / 2];
    self.rightL3.text = [NSString stringWithFormat:@"-%.2f%%", maxFluctuationPercent / 2];
}

/** 传入价格, 依昨收价算出该价格的Y值 */
- (CGFloat)calculateYWithNewPrice:(CGFloat)price {
    return  price && self.scale ?
            self.centerY - (price - self.preClose) / self.scale :
            self.centerY;
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect {
    
    if (!self.preClose) return; //通知来了之后, 决定用哪个昨收值
    self.subviews.lastObject.hidden = YES; //从本地取缓存刷新, 也需要将其隐藏
    
    //画水平和垂直分界线, 方法里会改变ctx的线宽, 所以要放在设置线宽前调用
    [self drawHorizontalAndVerticalLines];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 0.5);//线宽

    //从xib创建, 约束后的frame要过一会才会得到, 所有放在这里计算scale
    self.scale = self.maxFluctuation * 2 / self.leftL4.bottom;
    CGPoint origin = CGPointMake(kMarginLeft, [self calculateYWithNewPrice:self.data[0].new_price]);
    
    UIBezierPath *bluePath = [UIBezierPath bezierPath];
    UIBezierPath *yellowPath = [UIBezierPath bezierPath];
    [bluePath moveToPoint:origin];
    [yellowPath moveToPoint:origin];
    NSMutableArray *yellowPaths = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 1; i < self.count; i++) {
        
        CGFloat x = kMarginLeft + i * self.minWidth;
        CGFloat blueY = [self calculateYWithNewPrice:self.data[i].new_price];
        CGFloat yellowY = [self calculateYWithNewPrice:self.data[i].avg_price];
        
        if (self.data[i - 1].isFlash) {
            [yellowPaths addObject:yellowPath];
            yellowPath = [UIBezierPath bezierPath];
            [yellowPath moveToPoint:CGPointMake(x, yellowY)];
        }
        [bluePath addLineToPoint:CGPointMake(x, blueY)];
        [yellowPath addLineToPoint:CGPointMake(x, yellowY)];
    }
    [yellowPaths addObject:yellowPath]; //将普通分时的avgPath保存
    
    //画背景path, 然后填充渐变色
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithCGPath:bluePath.CGPath];
    [bgPath addLineToPoint:CGPointMake(bgPath.currentPoint.x, kMarginTop + self.leftL4.bottom)];
    [bgPath addLineToPoint:CGPointMake(kMarginLeft, bgPath.currentPoint.y)];
    [DrawTool drawLinearGradient:bgPath startColor:OXColor(0xb8d1f5) endColor:OXColor(0xe8eef7)];
    
    [BLUE_LINE_COLOR setStroke];
    CGContextAddPath(ctx, bluePath.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    [YELLOW_LINE_COLOR setStroke];
    for (UIBezierPath *path in yellowPaths) {
        CGContextAddPath(ctx, path.CGPath);
        CGContextDrawPath(ctx, kCGPathStroke);
    }
}

/** 画3条横线 */
- (void)drawHorizontalAndVerticalLines {
#warning 约束好需要时间, 所以放在这里算
    self.centerY = kMarginTop + self.leftL4.bottom / 2;
    
    CGPoint line1StartPoint = CGPointMake(kMarginLeft, kMarginTop + self.leftL4.bottom * 0.25);
    CGPoint line1EndPoint   = CGPointMake(WIDTH - kMarginLeft, kMarginTop + self.leftL4.bottom * 0.25);
    
    CGPoint line2StartPoint = CGPointMake(kMarginLeft, self.centerY);
    CGPoint line2EndPoint   = CGPointMake(WIDTH - kMarginLeft, self.centerY);
    
    CGPoint line3StartPoint = CGPointMake(kMarginLeft, kMarginTop + self.leftL4.bottom * 0.75);
    CGPoint line3EndPoint   = CGPointMake(WIDTH - kMarginLeft, kMarginTop + self.leftL4.bottom * 0.75);
    
    [DrawTool drawLineWithStartPoint:line1StartPoint endPoint:line1EndPoint];
    [DrawTool drawLineWithStartPoint:line2StartPoint endPoint:line2EndPoint];
    [DrawTool drawLineWithStartPoint:line3StartPoint endPoint:line3EndPoint];
    
    //垂直分界线
    //分时系数=4    5日系数=5
    CGFloat singleWidth = (WIDTH - 2 * kMarginLeft) / (self.style - SocketRequestStyleTimeSharing + 4);
    for (int i = 1; i < (self.style - SocketRequestStyleTimeSharing + 4); i++) {
        
        CGPoint startPoint = CGPointMake(kMarginLeft + i * singleWidth, kMarginTop);
        CGPoint endPoint   = CGPointMake(kMarginLeft + i * singleWidth, kMarginTop + self.leftL4.bottom);
        [DrawTool drawLineWithStartPoint:startPoint endPoint:endPoint];
    }
}

#pragma mark - 通知

/** 有网时, 等通知来 */
- (void)reloadTimeSharingData:(NSNotification *)notification {
    
    self.dict = [NSMutableDictionary dictionaryWithDictionary:notification.userInfo];
    //来的通知类型和当前类型不一致(分时页或5日页)  || 由于快速点击, 来了已过时的其它品种的通知
    if ( ([self.dict[@"style"] integerValue] != self.style) || (![self.dict[@"code"] isEqualToString:self.model.code]) ) return;
    
    [self removeTimer]; //来通知了,不需要从本地取资源了,故移除之
    
    if (self.stopTurnBlock) { //来通知后, 可以停止转动了
        self.stopTurnBlock();
        self.subviews.lastObject.hidden = YES;
    }
    self.maxPrice = [self.dict[@"max"] floatValue];
    self.minPrice = [self.dict[@"min"] floatValue];
    self.data = self.dict[@"data"];
    self.count = self.data.count;
    
    //单条分钟的宽度
    self.minWidth = (WIDTH - 2 * kMarginLeft) / [TxtTool minutesTotalWithCodeType:self.model.code_type];
    self.preClose = [self.dict[@"preClose"] floatValue];
    
    if (self.style == SocketRequestStyleTimeSharing) { //1 分时
        [self createTimeLabel];
    } else { //5日
        [self createDateLabelWithDateArray:self.dict[@"dates"]];
        self.minWidth /= 5;
    }
    [self calculateRoundValue];
    [self setNeedsDisplay]; //待 昨收 & self.maxFluctuation 有值之后, 再绘图
    
    // 存储至本地
    [self.dict setObject:@(self.preClose) forKey:@"preClose"];
    [self.dict setObject:@(self.minWidth) forKey:@"minuteWidth"];
    [CacheTool saveData:self.dict withCode:self.model.code requestStyle:self.style];
}

- (void)reloadPushData:(NSNotification *)notification {
    
    NSArray<IndexModel *> *array = notification.userInfo[@"userInfo"];
    if (array.count != 1 || ![array[0].code isEqualToString:self.model.code]) return;
    
    IndexModel *model = array[0];
    NSInteger index;
    NSString *hhmm = [TxtTool currentTimeWithNumber:self.data.count - 1 codeType:model.code_type];
    
    if ([model.hhmm isEqualToString:hhmm]) { //推来的是同一分钟的价格, 更新此分钟的model
        [self.data removeLastObject]; self.count--;
        index = self.count - 2; //最最后一个的前一个model
    } else { //推来的是最新分钟的价格, 将最新分钟的model添加至self.data
        index = self.count - 1; //取最后一个model
    }
    [self.data addObject:model]; self.count++;
    
    model.totalNumber = model.total;
    model.total -= self.data[index].totalNumber;
    model.totalPrice = self.data[index].totalPrice + model.total * model.new_price;
    model.avg_price = model.totalPrice / model.totalNumber;
    
    if (self.informationLabel.tag == self.count - 1) { //长按住最后一条时, 实时更新数据
        [self setInformationLabelContentWithModel:model withNode:self.count - 1];
        [self set10ContentWithModel:self.data.lastObject longNode:self.count - 1];
    }
    
    self.maxPrice = model.new_price > self.maxPrice ? model.new_price : self.maxPrice;
    self.minPrice = model.new_price < self.minPrice ? model.new_price : self.minPrice;
    [self calculateRoundValue];
    [self setNeedsDisplay];
    
    [self.dict setObject:self.data forKey:@"array"];
    [self.dict setObject:@(self.maxPrice) forKey:@"max"];
    [self.dict setObject:@(self.minPrice) forKey:@"min"];
    [CacheTool saveData:self.dict withCode:self.model.code requestStyle:self.style];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 长按

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    
    BOOL isHidden = (recognizer.state == UIGestureRecognizerStateEnded);
    self.informationLabel.hidden = isHidden;
    self.horizontalView.hidden   = isHidden;
    self.verticalView.hidden     = isHidden;
    
    NSInteger longNode = ([recognizer locationInView:self].x - 5) / self.minWidth;
    if (longNode < 0) { // 防止快速滑出边界时轴线卡住
        longNode = 0;
    } else if (longNode >= self.count) {
        longNode = self.count - 1;
    }
    // 设置标题Label的内容
    [self setInformationLabelContentWithModel:self.data[longNode] withNode:longNode];
    // 设置10字轴的内容
    [self set10ContentWithModel:self.data[longNode] longNode:longNode];
}

/** 设置标题Label的内容 */
- (void)setInformationLabelContentWithModel:(IndexModel *)m withNode:(NSInteger)node{
    
    NSString *format = [self.model.name isEqualToString:@"美元人民币"] ? @"%.4f" : @"%.2f";
    NSString *fluctuation = [NSString stringWithFormat:@"(%.2f%%)", (m.new_price - self.preClose) / self.preClose * 100];
    NSString *price = [NSString stringWithFormat:[@"   价格" stringByAppendingString:format],
                       m.new_price / self.model.priceunit];
    NSString *other = [NSString stringWithFormat:[@"   均价" stringByAppendingFormat:@"%@   成交量%@", format, @"%ld"],
                       m.avg_price / self.model.priceunit, m.total];
    
    NSMutableAttributedString *aPrice = [[NSMutableAttributedString alloc] initWithString:price];
    NSMutableAttributedString *aFluctuation = [[NSMutableAttributedString alloc] initWithString:fluctuation];
    NSMutableAttributedString *aOther = [[NSMutableAttributedString alloc] initWithString:other];
    
    [aFluctuation setAttributes:@{ NSForegroundColorAttributeName : [UIColor redColor] } range:NSMakeRange(0, aFluctuation.length)];
    [aPrice appendAttributedString:aFluctuation];
    [aPrice appendAttributedString:aOther];
    self.informationLabel.attributedText = aPrice;
    self.informationLabel.tag = node;
}

/** 设置10字轴的内容 */
- (void)set10ContentWithModel:(IndexModel *)m longNode:(NSInteger)longNode {
    
    NSString *format = [self.model.name isEqualToString:@"美元人民币"] ? @"%.4f" : @"%.2f";
    self.verticalTimeLabel.text = [TxtTool currentTimeWithNumber:longNode codeType:self.model.code_type];
    self.horizontalPriceLabel.text = [NSString stringWithFormat:format, m.new_price / self.model.priceunit];
    self.horizontalFluctuationLabel.text = [NSString stringWithFormat:@"%.2f%%", (m.new_price - self.preClose) / self.preClose * 100];
    
    CGFloat centerX = kMarginLeft + longNode * self.minWidth;
    CGFloat centerY = [self calculateYWithNewPrice:m.new_price];
    
    if (centerX < 20) { //kMarginLeft + self.verticalView.width / 2 == 20
        self.verticalView.centerX = 20;
        self.verticalLineCenterX_constraint.constant = centerX - 20;
        
    } else if (centerX > WIDTH - 20) {
        self.verticalView.centerX = WIDTH - 20;
        self.verticalLineCenterX_constraint.constant = centerX - (WIDTH - 20);
        
    } else {
        self.verticalView.centerX = centerX;
        self.verticalLineCenterX_constraint.constant = 0;
    }
    
    if (centerY < 15) { //kMarginTop + horizontalView.height / 2 == 15
        self.horizontalView.centerY = 15;
        self.horizontalLineCenterY_constraint.constant = centerY - 15;
        
    } else if (centerY > self.leftL4.bottom + 5) {
        self.horizontalView.centerY = self.leftL4.bottom + 5;
        self.horizontalLineCenterY_constraint.constant = centerY - (self.leftL4.bottom + 5);
        
    } else {
        self.horizontalView.centerY = centerY;
        self.horizontalLineCenterY_constraint.constant = 0;
    }
}

#pragma mark - 定时器

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kDrawBeforeWaitingSec
                                                  target:self
                                                selector:@selector(fetchLocalDict)
                                                userInfo:nil
                                                 repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Other

/** 重新点击时, 清除旧图 */
- (void)clearDrawing {
    self.preClose = 0;
    [self setNeedsDisplay];
    
    if ([HttpTool networkStatus] == NotReachable) { //断网从本地取
        [self fetchLocalDict];
    } else { //有网或弱网, 开始计时,1秒没来通知, 就取本地资源
        [self addTimer];
    }
}

/** 无网时, 调用此方法 */
- (void)fetchLocalDict {
    
    NSDictionary *dict = self.dict;
    if (!dict) dict = [CacheTool fetchCacheWithCode:self.model.code requestStyle:self.style];
    
    if (!dict) { //断网后,从本地取不到数据, 再显示提示view
        self.subviews.lastObject.hidden = NO;
        return;
    }
    self.maxPrice = [dict[@"max"] floatValue];
    self.minPrice = [dict[@"min"] floatValue];
    self.data  = dict[@"array"];
    self.count = self.data.count;
    self.preClose = [dict[@"preClose"] floatValue];
    self.minWidth = [dict[@"minuteWidth"] floatValue];
    if (self.style == SocketRequestStyleTimeSharing) { //1 分时
        [self createTimeLabel];
    } else { //5日
        [self createDateLabelWithDateArray:dict[@"dates"]];
    }
    [self calculateRoundValue];
    [self setNeedsDisplay];
    [self removeTimer];
}

/** 交易页,点击进入自选详情页 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.height > 100.0) return; //已经在详情了,无需再跳转
    
    ChartDetailsController *vc = [[ChartDetailsController alloc] init];
    vc.model = self.model;
    UITabBarController *tabBarC = (UITabBarController *)self.window.rootViewController;
    [tabBarC.selectedViewController pushViewController:vc animated:YES];
}

- (IBAction)clickedRefresh {
    if (self.refreshBlock) self.refreshBlock();
}

@end
