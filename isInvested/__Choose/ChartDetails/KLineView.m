//
//  KLineView.m
//  isInvested
//
//  Created by Blue on 16/10/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "KLineView.h"
#import "IndexModel.h"

CGFloat const fineW = 0.5;
CGFloat const boldW = 5.0;
CGFloat const padding = 1.0;      //单边 padding
CGFloat const singleW = 7.0;      //boldW + padding * 2;
CGFloat const radiusX = 2.5;      //(boldW - fineW) / 2.0

@interface KLineView ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *rightL0; // MA(5,10,20)
@property (weak, nonatomic) IBOutlet UILabel *leftL0;
@property (weak, nonatomic) IBOutlet UILabel *leftL1;
@property (weak, nonatomic) IBOutlet UILabel *leftL2;
@property (weak, nonatomic) IBOutlet UILabel *leftL3;
@property (weak, nonatomic) IBOutlet UILabel *leftL4;

@property (weak, nonatomic) IBOutlet UILabel *bottomL0;
@property (weak, nonatomic) IBOutlet UILabel *bottomL1;
@property (weak, nonatomic) IBOutlet UILabel *bottomL2;
@property (weak, nonatomic) IBOutlet UILabel *bottomL3;
@property (weak, nonatomic) IBOutlet UILabel *bottomL4;

@property (weak, nonatomic) IBOutlet UILabel *smallL_top;
@property (weak, nonatomic) IBOutlet UILabel *smallL_bottom;
@property (weak, nonatomic) IBOutlet UILabel *smallL_right;

@property (weak, nonatomic) IBOutlet UIView  *horizontalView1;
@property (weak, nonatomic) IBOutlet UIView  *horizontalView2;
@property (weak, nonatomic) IBOutlet UILabel *horizontalPriceLabel1;
@property (weak, nonatomic) IBOutlet UILabel *horizontalPriceLabel2;

@property (weak, nonatomic) IBOutlet UIView  *verticalView;
@property (weak, nonatomic) IBOutlet UILabel *verticalDateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalLine1CenterY_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalLine2CenterY_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLineCenterX_constraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX_constraint;
@property (weak, nonatomic) IBOutlet UIButton *macdButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) NSTimer *timer; //1秒没来通知, 就取本地资源

@property (nonatomic, strong) NSArray<IndexModel *> *data;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger showTotal;

@property (nonatomic, assign) CGFloat priceunit;
@property (nonatomic, assign) CGFloat bigMax;
@property (nonatomic, assign) CGFloat bigMin;
@property (nonatomic, assign) CGFloat smallMax;
@property (nonatomic, assign) CGFloat smallMin;
@property (nonatomic, assign) CGFloat bigScale;
@property (nonatomic, assign) CGFloat smallScale;
@property (nonatomic, assign) CGFloat smallViewY;// 小图y的0值

/** 已执行的节点号 */
@property (nonatomic, assign) NSInteger node;
@property (nonatomic, assign) NSInteger longNode; //长按用
@end

@implementation KLineView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.width = WIDTH;
    
    self.selectButton = self.macdButton;
    self.showTotal = (WIDTH - 10) / singleW;
    
    [self.scrollView addGestureRecognizer:
     [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(reloadKLineData:) name:SocketKLineNotification object:nil];
}

- (void)drawRect:(CGRect)rect {
    
    if (self.count == 0) return;
    
    // 需按顺序调用
    [self drawHorizontalLines];
    
    [self drawBigChart];
    
    switch (self.selectButton.tag) {
        case SmallIndexStyleRSI:
        case SmallIndexStyleKDJ:
            [self drawRSIAndKDJChart];
            break;
        default:
            [self drawMACDChart];
            break;
    }
}

#pragma mark - 长按

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    
    BOOL isHidden = recognizer.state == UIGestureRecognizerStateEnded;
    if (isHidden) {
        self.rightL0.text = @"MA(5,10,20)";
        self.smallL_right.text = @"";
    }
    self.informationLabel.hidden = isHidden;
    self.horizontalView1.hidden = isHidden;
    self.horizontalView2.hidden = isHidden || self.selectButton.tag; //第0个 MACD页时, 才显示第2条横线
    self.verticalView.hidden = isHidden;
    
    NSInteger longNode = ([recognizer locationInView:self].x - 5) / singleW;
    if (longNode != self.longNode && longNode < self.showTotal && longNode < self.count) { // 防止数组越界
        self.longNode = longNode;
        
        NSInteger o = self.count > self.showTotal ? self.count - self.showTotal - self.node : 0;
        IndexModel *m = self.data[o + self.longNode];
        
        [self calculate10PositionWithModel:m];
        [self setInformationContentWithModel:m];
        
        // 大图右上角
        NSString *ma5Str = [NSString stringWithFormat:@"MA5 %.2f", m.ma5_price / self.priceunit];
        NSString *ma10Str = [NSString stringWithFormat:@" MA10 %.2f", m.ma10_price / self.priceunit];
        NSString *ma20Str = [NSString stringWithFormat:@" MA20 %.2f", m.ma20_price / self.priceunit];
        self.rightL0.attributedText = [self paintColorWithStringArray:@[@"", ma5Str, ma10Str, ma20Str]];
        
        // 小图右上角
        switch (self.selectButton.tag) {
            case 0:
            {
                NSString *dif = [NSString stringWithFormat:@" DIF %.3f", m.DIF / self.priceunit];
                NSString *dea = [NSString stringWithFormat:@" DEA %.3f", m.DEA / self.priceunit];
                NSString *macd = [NSString stringWithFormat:@" MACD %.3f", m.MACD / self.priceunit];
                self.smallL_right.attributedText = [self paintColorWithStringArray:@[@"MACD(26,12,9)", dif, dea, macd]];
                break;
            }
            case 1:
            {
                NSString *rsi1 = [NSString stringWithFormat:@" RSI1 %.2f", m.RSI1];
                NSString *rsi2 = [NSString stringWithFormat:@" RSI2 %.2f", m.RSI2];
                NSString *rsi3 = [NSString stringWithFormat:@" RSI3 %.2f", m.RSI3];
                self.smallL_right.attributedText = [self paintColorWithStringArray:@[@"RSI(6,12,24)", rsi1, rsi2, rsi3]];
                break;
            }
            case 2:
            {
                NSString *k = [NSString stringWithFormat:@" K %.2f", m.K];
                NSString *d = [NSString stringWithFormat:@" D %.2f", m.D];
                NSString *j = [NSString stringWithFormat:@" J %.2f", m.J];
                self.smallL_right.attributedText = [self paintColorWithStringArray:@[@"KDJ(9,3,3)", k, d, j]];
                break;
            }
            default:
                break;
        }
    }
}

/** 计算10字光标的位置 */
- (void)calculate10PositionWithModel:(IndexModel *)m {
    
    NSString *format = [self.code isEqualToString:@"USDCNY"] ? @"%.4f" : @"%.2f";
    self.horizontalPriceLabel1.text = [NSString stringWithFormat:format, m.close_price / self.priceunit];
    self.horizontalPriceLabel2.text = [NSString stringWithFormat:@"%.3f", m.MACD / self.priceunit];
    self.verticalDateLabel.text     = [self getDateWithModel:m];
    
    CGFloat centerX = kMarginLeft + self.longNode * singleW + singleW / 2;
    CGFloat centerY1 = kMarginTop + (self.bigMax - m.close_price) / self.bigScale;
    CGFloat centerY2 = self.smallViewY + (self.smallMax - m.MACD) / self.smallScale;
    
    if (centerX < 32) { //kMarginLeft + self.verticalView.width / 2 == 32
        self.verticalView.centerX = 32;
        self.verticalLineCenterX_constraint.constant = centerX - 32;
        
    } else if (centerX > WIDTH - 32) {
        self.verticalView.centerX = WIDTH - 32;
        self.verticalLineCenterX_constraint.constant = centerX - (WIDTH - 32);
        
    } else {
        self.verticalView.centerX = centerX;
        self.verticalLineCenterX_constraint.constant = 0;
    }
    
    if (centerY1 < 15) { //kMarginTop + horizontalView1.height / 2 == 15
        self.horizontalView1.centerY = 15;
        self.horizontalLine1CenterY_constraint.constant = centerY1 - 15;
        
    } else if (centerY1 > self.leftL4.bottom + 5) {
        self.horizontalView1.centerY = self.leftL4.bottom + 5;
        self.horizontalLine1CenterY_constraint.constant = centerY1 - self.leftL4.bottom - 5;
        
    } else {
        self.horizontalView1.centerY = centerY1;
        self.horizontalLine1CenterY_constraint.constant = 0;
    }
    
    if (centerY2 < self.smallViewY + 5) { // horizontalView1.height / 2 == 5
        self.horizontalView2.centerY = self.smallViewY + 5;
        self.horizontalLine2CenterY_constraint.constant = centerY2 - self.smallViewY - 5;
        
    } else if (centerY2 > self.smallViewY + self.smallL_bottom.bottom - 5) {
        self.horizontalView2.centerY = self.smallViewY + self.smallL_bottom.bottom - 5;
        self.horizontalLine2CenterY_constraint.constant = centerY2 - self.smallViewY - self.smallL_bottom.bottom + 5;
        
    } else {
        self.horizontalView2.centerY = centerY2;
        self.horizontalLine2CenterY_constraint.constant = 0;
    }
    
}

/** 设置Information条的内容 */
- (void)setInformationContentWithModel:(IndexModel *)m {
    
    CGFloat fluctuation = (m.close_price - m.open_price) / m.open_price * 100;
    
    NSString *format = [self.code isEqualToString:@"USDCNY"] ?
    @"   开%.4f   高%.4f   低%.4f   收%.4f   涨跌(%.2f%%)" :
    @"   开%.2f   高%.2f   低%.2f   收%.2f   涨跌(%.2f%%)";
    NSString *inforString = [NSString stringWithFormat:format, m.open_price / self.priceunit, m.max_price / self.priceunit, m.min_price / self.priceunit, m.close_price / self.priceunit, fluctuation];
    
    NSMutableAttributedString *inforAttributedStr = [[NSMutableAttributedString alloc] initWithString:inforString];
    
    UIColor *color = OXColor(m.candleColor);
    NSInteger location = [inforString rangeOfString:@"("].location;
    NSRange range = NSMakeRange(location, inforString.length - location);
    [inforAttributedStr addAttributes:@{ NSForegroundColorAttributeName : color } range:range];
    self.informationLabel.attributedText = inforAttributedStr;
}

- (NSString *)getDateWithModel:(IndexModel *)m {
    
    if (m.date < 100000000) { //日期值
        NSInteger yy = m.date / 10000;
        NSInteger MM = m.date / 100 % 100;
        NSInteger dd = m.date % 100;
        return [NSString stringWithFormat:@"%ld-%02ld-%02ld", yy, MM, dd];
    } else { //时间值
        NSInteger MM = m.date / 1000000 % 100;
        NSInteger dd = m.date / 10000 % 100;
        NSInteger hh = m.date / 100 % 100;
        NSInteger mm = m.date % 100;
        return [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld", MM, dd, hh, mm];
    }
}

/** 分段上色 */
- (NSAttributedString *)paintColorWithStringArray:(NSArray *)array {
    if (array.count < 4) return nil;
    
    NSMutableAttributedString *aStr0 = [[NSMutableAttributedString alloc] initWithString:array[0]];
    NSMutableAttributedString *aStr1 = [[NSMutableAttributedString alloc] initWithString:array[1]];
    NSMutableAttributedString *aStr2 = [[NSMutableAttributedString alloc] initWithString:array[2]];
    NSMutableAttributedString *aStr3 = [[NSMutableAttributedString alloc] initWithString:array[3]];
    
    [aStr0 setAttributes:@{ NSForegroundColorAttributeName : GRAY_TITLE_COLOR  } range:NSMakeRange(0, aStr0.length)];
    [aStr1 setAttributes:@{ NSForegroundColorAttributeName : RED_LINE_COLOR    } range:NSMakeRange(0, aStr1.length)];
    [aStr2 setAttributes:@{ NSForegroundColorAttributeName : YELLOW_LINE_COLOR } range:NSMakeRange(0, aStr2.length)];
    [aStr3 setAttributes:@{ NSForegroundColorAttributeName : BLUE_LINE_COLOR   } range:NSMakeRange(0, aStr3.length)];
    
    [aStr0 appendAttributedString:aStr1];
    [aStr0 appendAttributedString:aStr2];
    [aStr0 appendAttributedString:aStr3];
    return aStr0;
}

#pragma mark - 通知

- (void)reloadKLineData:(NSNotification *)notification {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:notification.userInfo];
    //来的通知类型和当前类型不一致(分时页或5日页), 直接return
    //由于快速点击, 来了已过时的通知, 直接return
    if ( ([dict[@"style"] integerValue] != self.style) ||
        (![dict[@"code"] isEqualToString:self.code]) ) {
        return;
    }
    [self removeTimer]; //来通知了,不需要从本地取资源了 self.subviews.lastObject.hidden = YES;
    
    if (self.stopTurnBlock) {
        self.stopTurnBlock(); //来通知后, 可以停止转动了
        self.subviews.lastObject.hidden = YES;
    }
    
    self.data = dict[@"array"];
    self.count = self.data.count;
    self.priceunit = self.data[0].priceunit;
    
    self.scrollView.contentSize = CGSizeMake(singleW * self.count, 0);
    
    if (self.scrollView.contentOffset.x == 0) { //点击或切换了不同的k线
        self.scrollView.contentOffset = CGPointMake(singleW * self.count, 0);
    } //原来x有值, 就是滑动过, 然后来通知刷新的, 此时就不要改变x的值
    [self setNeedsDisplay];
    
    // 存储至本地
    [CacheTool saveData:dict withCode:dict[@"code"] requestStyle:self.style];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 计算大图范围

/** 计算大图的范围 */
- (void)calculateBigRange {
    
    self.bigMax     = CGFLOAT_MIN;
    self.bigMin     = CGFLOAT_MAX;
    
    NSInteger count = self.count - self.node;
    NSInteger o = count > self.showTotal ? count - self.showTotal : 0;
    for (NSInteger i = o; i < count; i++) {
        IndexModel *m = self.data[i];
        //取最大值
        CGFloat tempMax = MAX(MAX(m.max_price, m.ma5_price), MAX(m.ma10_price, m.ma20_price));
        if (self.bigMax < tempMax) self.bigMax = tempMax;
        //取最小值, 除去0值
        if (self.bigMin > m.min_price) self.bigMin = m.min_price;
        if (self.bigMin > m.ma5_price && m.ma5_price)   self.bigMin = m.ma5_price;
        if (self.bigMin > m.ma10_price && m.ma10_price) self.bigMin = m.ma10_price;
        if (self.bigMin > m.ma20_price && m.ma20_price) self.bigMin = m.ma20_price;
    }
    self.bigScale = (self.bigMax - self.bigMin) / self.leftL4.bottom;
    
    NSString *format = [self.code isEqualToString:@"USDCNY"] ? @"%.4f" : @"%.2f";
    self.leftL0.text = [NSString stringWithFormat:format, self.bigMax / self.priceunit];
    self.leftL4.text = [NSString stringWithFormat:format, self.bigMin / self.priceunit];
    self.leftL2.text = [NSString stringWithFormat:format, (self.bigMax + self.bigMin) / 2.0 / self.priceunit];
    self.leftL1.text = [NSString stringWithFormat:format, (self.bigMin + (self.bigMax - self.bigMin) * 0.75) / self.priceunit];
    self.leftL3.text = [NSString stringWithFormat:format, (self.bigMin + (self.bigMax - self.bigMin) * 0.25) / self.priceunit];

    NSInteger i1 = o + (NSInteger)(self.showTotal * 0.25);
    NSInteger i2 = o + (NSInteger)(self.showTotal * 0.5);
    NSInteger i3 = o + (NSInteger)(self.showTotal * 0.75);
    //底部时间栏赋值
    self.bottomL0.text = [self getDateWithModel:self.data[o]];
    self.bottomL4.text = [self getDateWithModel:self.data[count - 1]];
    self.bottomL1.text = i1 < count ? [self getDateWithModel:self.data[i1]] : @"";
    self.bottomL2.text = i2 < count ? [self getDateWithModel:self.data[i2]] : @"";
    self.bottomL3.text = i3 < count ? [self getDateWithModel:self.data[i3]] : @"";
    
    //画3条垂直线
    CGFloat x1 = kMarginLeft + (i1 - o) * singleW + padding + radiusX;
    CGFloat x2 = kMarginLeft + (i2 - o) * singleW + padding + radiusX;
    CGFloat x3 = kMarginLeft + (i3 - o) * singleW + padding + radiusX;
    [self drawVerticalLinesWithX1:x1 x2:x2 x3:x3];
}

#pragma mark - 计算小图范围

/** 计算MACD的范围 */
- (void)calculateMACDRange {
    
    [CalculatorTool MACDArrayWithOriginalArray:self.data];
    self.smallMax = CGFLOAT_MIN;
    self.smallMin = CGFLOAT_MAX;
    
    NSInteger count = self.count - self.node;
    NSInteger o = count > self.showTotal ? count - self.showTotal : 0;
    for (NSInteger i = o; i < count; i++) {
        IndexModel *m = self.data[i];
        
        CGFloat tempMax = MAX(MAX(m.DIF, m.DEA), m.MACD);
        CGFloat tempMin = MIN(MIN(m.DIF, m.DEA), m.MACD);
        if (self.smallMax < tempMax) self.smallMax = tempMax;
        if (self.smallMin > tempMin) self.smallMin = tempMin;
    }
    self.smallScale         = (self.smallMax - self.smallMin) / 80.0; //80为高度
    self.smallL_top.text    = [NSString stringWithFormat:@"%.3f", self.smallMax / self.priceunit];
    self.smallL_bottom.text = [NSString stringWithFormat:@"%.3f", self.smallMin / self.priceunit];
}

/** 计算RSI的范围 */
- (void)calculateRSIRange {
    
    [CalculatorTool RSIArrayWithOriginalArray:self.data];
    self.smallMax = CGFLOAT_MIN;
    self.smallMin = CGFLOAT_MAX;
    
    NSInteger count = self.count - self.node;
    NSInteger o = count > self.showTotal ? count - self.showTotal : 0;
    for (NSInteger i = o; i < count; i++) {
        IndexModel *m = self.data[i];
        
        CGFloat tempMax = MAX(MAX(m.RSI1, m.RSI2), m.RSI3);
        CGFloat tempMin = MIN(MIN(m.RSI1, m.RSI2), m.RSI3);
        if (self.smallMax < tempMax) self.smallMax = tempMax;
        if (self.smallMin > tempMin) self.smallMin = tempMin;
    }
    self.smallScale         = (self.smallMax - self.smallMin) / 80.0; //80为高度
    self.smallL_top.text    = [NSString stringWithFormat:@"%.2f", self.smallMax];
    self.smallL_bottom.text = [NSString stringWithFormat:@"%.2f", self.smallMin];
}

/** 计算KDJ的范围 */
- (void)calculateKDJRange {
    
    [CalculatorTool KDJArrayWithOriginalArray:self.data];
    self.smallMax = CGFLOAT_MIN;
    self.smallMin = CGFLOAT_MAX;
    
    NSInteger count = self.count - self.node;
    NSInteger o = count > self.showTotal ? count - self.showTotal : 0;
    for (NSInteger i = o; i < count; i++) {
        IndexModel *m = self.data[i];
        
        CGFloat tempMax = MAX(MAX(m.K, m.D), m.J);
        CGFloat tempMin = MIN(MIN(m.K, m.D), m.J);
        if (self.smallMax < tempMax) self.smallMax = tempMax;
        if (self.smallMin > tempMin) self.smallMin = tempMin;
    }
    self.smallScale         = (self.smallMax - self.smallMin) / 80.0; //80为高度
    self.smallL_top.text    = [NSString stringWithFormat:@"%.2f", self.smallMax];
    self.smallL_bottom.text = [NSString stringWithFormat:@"%.2f", self.smallMin];
}

#pragma mark - Draw

/** 画3条横线 */
- (void)drawHorizontalLines {
    
    CGFloat centerY = kMarginTop + self.leftL4.bottom / 2;
    
    CGPoint line1StartPoint = CGPointMake(5, (centerY - kMarginTop) / 2 + kMarginTop);
    CGPoint line1EndPoint   = CGPointMake(WIDTH - 5, (centerY - 5) / 2 + 5);
    
    CGPoint line2StartPoint = CGPointMake(5, centerY);
    CGPoint line2EndPoint   = CGPointMake(WIDTH - 5, centerY);
    
    CGPoint line3StartPoint = CGPointMake(5, (centerY - kMarginTop) * 1.5 + kMarginTop);
    CGPoint line3EndPoint   = CGPointMake(WIDTH - 5, (centerY - kMarginTop) * 1.5 + kMarginTop);
    
    [DrawTool drawLineWithStartPoint:line1StartPoint endPoint:line1EndPoint];
    [DrawTool drawLineWithStartPoint:line2StartPoint endPoint:line2EndPoint];
    [DrawTool drawLineWithStartPoint:line3StartPoint endPoint:line3EndPoint];
}

/** 画3条竖线 */
- (void)drawVerticalLinesWithX1:(CGFloat)x1 x2:(CGFloat)x2 x3:(CGFloat)x3 {
    
    CGFloat bigStartY = kMarginTop;
    CGFloat bigEndY = kMarginTop + self.leftL4.bottom;
    
    CGFloat smallStartY = self.height - 5 - 80;;
    CGFloat smallEndY = self.height - 5;
    
    [DrawTool drawLineWithStartPoint:CGPointMake(x1, bigStartY) endPoint:CGPointMake(x1, bigEndY)];
    [DrawTool drawLineWithStartPoint:CGPointMake(x2, bigStartY) endPoint:CGPointMake(x2, bigEndY)];
    [DrawTool drawLineWithStartPoint:CGPointMake(x3, bigStartY) endPoint:CGPointMake(x3, bigEndY)];
    
    [DrawTool drawLineWithStartPoint:CGPointMake(x1, smallStartY) endPoint:CGPointMake(x1, smallEndY)];
    [DrawTool drawLineWithStartPoint:CGPointMake(x2, smallStartY) endPoint:CGPointMake(x2, smallEndY)];
    [DrawTool drawLineWithStartPoint:CGPointMake(x3, smallStartY) endPoint:CGPointMake(x3, smallEndY)];
}

/** 画大图 */
- (void)drawBigChart {
    
    [self calculateBigRange];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 0.5);
    
    NSInteger count = self.count - self.node;
    NSInteger o = count > self.showTotal ? count - self.showTotal : 0;
    CGFloat lineX   = kMarginLeft + padding + radiusX;
    
    //红色5 黄色10 蓝色20
    UIBezierPath *path5  = [UIBezierPath bezierPath];
    UIBezierPath *path10 = [UIBezierPath bezierPath];
    UIBezierPath *path20 = [UIBezierPath bezierPath];
    
    NSInteger o5  =  5 - o > 0 ?  5 - o : 0; //前5条没数据, 要判断线条起始点
    NSInteger o10 = 10 - o > 0 ? 10 - o : 0;
    NSInteger o20 = 20 - o > 0 ? 20 - o : 0;
    
    if (o + o5 < count) {
        CGFloat x = lineX + o5 * singleW;
        CGFloat y = kMarginTop + (self.bigMax - self.data[o + o5].ma5_price) / self.bigScale;
        [path5  moveToPoint:CGPointMake(x, y)];
    }
    if (o + o10 < count) {
        CGFloat x = lineX + o10 * singleW;
        CGFloat y = kMarginTop + (self.bigMax - self.data[o + o10].ma10_price) / self.bigScale;
        [path10 moveToPoint:CGPointMake(x, y)];
    }
    if (o + o20 < count) {
        CGFloat x = lineX + o20 * singleW;
        CGFloat y = kMarginTop + (self.bigMax - self.data[o + o20].ma20_price) / self.bigScale;
        [path20 moveToPoint:CGPointMake(x, y)];
    }
    
    for (NSInteger i = o; i < count; i++) {
        
        CGFloat candleX = kMarginLeft + (i - o) * singleW;
        [self drawCandleByOriginX:candleX model:self.data[i] ctx:ctx];//画单个蜡烛
        
        CGFloat lineX = candleX + padding + radiusX;
        if (i >= 5) [path5 addLineToPoint:CGPointMake(lineX, kMarginTop + (self.bigMax - self.data[i].ma5_price) / self.bigScale)];
        if (i >= 10) [path10 addLineToPoint:CGPointMake(lineX, kMarginTop + (self.bigMax - self.data[i].ma10_price) / self.bigScale)];
        if (i >= 20) [path20 addLineToPoint:CGPointMake(lineX, kMarginTop + (self.bigMax - self.data[i].ma20_price) / self.bigScale)];
    }
    [RED_LINE_COLOR setStroke];    CGContextAddPath(ctx, path5.CGPath);  CGContextDrawPath(ctx, kCGPathStroke);
    [YELLOW_LINE_COLOR setStroke]; CGContextAddPath(ctx, path10.CGPath); CGContextDrawPath(ctx, kCGPathStroke);
    [BLUE_LINE_COLOR setStroke];   CGContextAddPath(ctx, path20.CGPath); CGContextDrawPath(ctx, kCGPathStroke);
}

/** 画MACD */
- (void)drawMACDChart {
    
    [self calculateMACDRange];
    
    self.smallViewY = self.height - 5 - 80;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    NSInteger count = self.count - self.node;
    NSInteger o = count > self.showTotal ? count - self.showTotal : 0;
    // 红色DIF  黄色DEA
    CGFloat lineX = kMarginLeft + padding + radiusX;
    UIBezierPath *pathDEA = [UIBezierPath bezierPath];
    UIBezierPath *pathDIF = [UIBezierPath bezierPath];
    
    [pathDEA moveToPoint:CGPointMake(lineX, self.smallViewY + (self.smallMax - self.data[o].DEA) / self.smallScale)];
    [pathDIF moveToPoint:CGPointMake(lineX, self.smallViewY + (self.smallMax - self.data[o].DIF) / self.smallScale)];
    
    for (NSInteger i = o; i < count; i++) {
        CGFloat lineX = kMarginLeft + (i - o) * singleW + padding + radiusX;
        [self drawColumnByX:(lineX - radiusX) model:self.data[i] ctx:ctx];
        
        [pathDEA addLineToPoint:CGPointMake(lineX, self.smallViewY + (self.smallMax - self.data[i].DEA) / self.smallScale)];
        [pathDIF addLineToPoint:CGPointMake(lineX, self.smallViewY + (self.smallMax - self.data[i].DIF) / self.smallScale)];
    }
    [YELLOW_LINE_COLOR setStroke]; CGContextAddPath(ctx, pathDEA.CGPath); CGContextDrawPath(ctx, kCGPathStroke);
    [RED_LINE_COLOR    setStroke]; CGContextAddPath(ctx, pathDIF.CGPath); CGContextDrawPath(ctx, kCGPathStroke);
}

/** 画RSI KDJ */
- (void)drawRSIAndKDJChart {
    
    self.smallViewY  = self.height - 5 - 80;
    NSInteger count  = self.count - self.node;
    NSInteger o      = count > self.showTotal ? count - self.showTotal : 0;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //RSI1红  RSI2黄  RSI3蓝
    // K红  D黄  J蓝
    CGFloat lineX = kMarginLeft + padding + radiusX;
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    
    CGFloat originY1;
    CGFloat originY2;
    CGFloat originY3;
    
    if (self.selectButton.tag == SmallIndexStyleRSI) {
        [self calculateRSIRange];
        
        originY1 = self.smallViewY + (self.smallMax - self.data[o].RSI1) / self.smallScale;
        originY2 = self.smallViewY + (self.smallMax - self.data[o].RSI2) / self.smallScale;
        originY3 = self.smallViewY + (self.smallMax - self.data[o].RSI3) / self.smallScale;
        [path1 moveToPoint:CGPointMake(lineX, originY1)];
        [path2 moveToPoint:CGPointMake(lineX, originY2)];
        [path3 moveToPoint:CGPointMake(lineX, originY3)];
        
        for (NSInteger i = o; i < count; i++) {
            CGFloat lineX = kMarginLeft + (i - o) * singleW + padding + radiusX;
            [path1 addLineToPoint:CGPointMake(lineX, self.smallViewY + (self.smallMax - self.data[i].RSI1) / self.smallScale)];
            [path2 addLineToPoint:CGPointMake(lineX, self.smallViewY + (self.smallMax - self.data[i].RSI2) / self.smallScale)];
            [path3 addLineToPoint:CGPointMake(lineX, self.smallViewY + (self.smallMax - self.data[i].RSI3) / self.smallScale)];
        }
        
    } else {
        [self calculateKDJRange];
        
        originY1 = self.smallViewY + (self.smallMax - self.data[o].K) / self.smallScale;
        originY2 = self.smallViewY + (self.smallMax - self.data[o].D) / self.smallScale;
        originY3 = self.smallViewY + (self.smallMax - self.data[o].J) / self.smallScale;
        [path1 moveToPoint:CGPointMake(lineX, originY1)];
        [path2 moveToPoint:CGPointMake(lineX, originY2)];
        [path3 moveToPoint:CGPointMake(lineX, originY3)];
        
        for (NSInteger i = o; i < count; i++) {
            CGFloat lineX = kMarginLeft + (i - o) * singleW + padding + radiusX;
            [path1 addLineToPoint:CGPointMake(lineX, self.smallViewY + (self.smallMax - self.data[i].K) / self.smallScale)];
            [path2 addLineToPoint:CGPointMake(lineX, self.smallViewY + (self.smallMax - self.data[i].D) / self.smallScale)];
            [path3 addLineToPoint:CGPointMake(lineX, self.smallViewY + (self.smallMax - self.data[i].J) / self.smallScale)];
        }
    }
    [RED_LINE_COLOR    setStroke]; CGContextAddPath(ctx, path1.CGPath); CGContextDrawPath(ctx, kCGPathStroke);
    [YELLOW_LINE_COLOR setStroke]; CGContextAddPath(ctx, path2.CGPath); CGContextDrawPath(ctx, kCGPathStroke);
    [BLUE_LINE_COLOR   setStroke]; CGContextAddPath(ctx, path3.CGPath); CGContextDrawPath(ctx, kCGPathStroke);
}

/** 画K线里的单个Candle */
- (void)drawCandleByOriginX:(CGFloat)x model:(IndexModel *)model ctx:(CGContextRef)ctx {
    
    CGFloat boldX = x + padding;
    CGFloat boldY = kMarginTop + (self.bigMax - MAX(model.close_price, model.open_price)) / self.bigScale;
    CGFloat boldH = ABS(model.close_price - model.open_price) / self.bigScale;
    UIBezierPath *boldPath = [UIBezierPath bezierPathWithRect:CGRectMake(boldX, boldY, boldW, PRIORITY(boldH, 0.5) )];
    CGContextAddPath(ctx, boldPath.CGPath);
    
    CGFloat fineX = boldX + radiusX;
    CGFloat fineY = kMarginTop + (self.bigMax - model.max_price) / self.bigScale;
    CGFloat fineH = (model.max_price - model.min_price) / self.bigScale;
    UIBezierPath *finePath = [UIBezierPath bezierPathWithRect:CGRectMake(fineX, fineY, fineW, fineH)];
    CGContextAddPath(ctx, finePath.CGPath);
    
    [OXColor(model.candleColor) set];
    CGContextFillPath(ctx);
}

/** 画MACD里的单个柱子 */
- (void)drawColumnByX:(CGFloat)x model:(IndexModel *)m ctx:(CGContextRef)ctx {
    
    CGFloat y = self.smallViewY + (self.smallMax - (m.MACD > 0 ? m.MACD : 0)) / self.smallScale;
    CGFloat h = ABS(m.MACD) / self.smallScale;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, boldW, h)];
    CGContextAddPath(ctx, path.CGPath);
    [(m.MACD / self.priceunit > 0 ? OXColor(kCandleRed) : OXColor(kCandleGreen)) set]; CGContextFillPath(ctx);
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
    self.count = self.node = 0;
    self.scrollView.contentOffset = CGPointMake(0, 0); //点击切换K线时,将其滑至最右端
    [self setNeedsDisplay];
    
    if ([HttpTool networkStatus] == NotReachable) { //断网从本地取
        [self fetchLocalDict];
    } else { //有网或弱网, 开始计时,1秒没来通知, 就取本地资源
        [self addTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger node = ((self.count - self.showTotal) * singleW - scrollView.contentOffset.x) / singleW;
    if (node != self.node && node >= 0) {
        self.node = node;
        [self setNeedsDisplay];
    }
}

/** 点击切换小图 */
- (IBAction)clickedSmallChartButton:(UIButton *)button {
    if (self.selectButton == button) return;
    
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
    
    self.lineX_constraint.constant = button.x;
    [self setNeedsDisplay];
}

/** 无网时, 调用此方法 */
- (void)fetchLocalDict {
    
    NSDictionary *dict = [CacheTool fetchCacheWithCode:self.code requestStyle:self.style];
    if (!dict) { //断网后,从本地取不到数据, 再显示提示view
        self.subviews.lastObject.hidden = NO;
        return;
    }
    self.data = dict[@"array"];
    self.count = self.data.count;
    self.priceunit = self.data[0].priceunit;
    
    self.scrollView.contentSize = CGSizeMake(singleW * self.count, 0);
    self.scrollView.contentOffset = CGPointMake(singleW * self.count, 0);
    [self setNeedsDisplay];
    [self removeTimer];
}

- (IBAction)clickedRefresh {
    if (self.refreshBlock) self.refreshBlock();
}

@end
