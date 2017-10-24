//
//  ExitView.m
//  isInvested
//
//  Created by Blue on 16/9/6.
//  Copyright © 2016年 Blue. All rights reserved.
//  平仓买入 or 平仓卖出

#import "ExitView.h"
#import "IQKeyboardManager.h"
#import "SocketTool.h"
#import "IndexModel.h"
#import "KMPopView.h"

@interface ExitView ()

@property (weak, nonatomic) IBOutlet UILabel *changeL; //买涨or买跌Label
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *floatingprofitandlossL;
@property (weak, nonatomic) IBOutlet UILabel *totalWeightL;
@property (weak, nonatomic) IBOutlet UILabel *holdpriceL;
@property (weak, nonatomic) IBOutlet UILabel *floatingprofitandlossPerL;
@property (weak, nonatomic) IBOutlet UILabel *closePriceL;
@property (weak, nonatomic) IBOutlet UILabel *breakevenPriceL;

@property (weak, nonatomic) IBOutlet UILabel *priceL; //平仓价格Label
@property (weak, nonatomic) IBOutlet UIButton *spreadB; //允许差价btn
@property (weak, nonatomic) IBOutlet UITextField *spreadTF; //允许差价TF

@property (weak, nonatomic) IBOutlet UITextField *weightTF; //重量输入框
@property (weak, nonatomic) IBOutlet UILabel *weightBaseL; //重量单位Label
@property (weak, nonatomic) IBOutlet UIButton *moreWeightB; //向下尖头Btn
@property (weak, nonatomic) IBOutlet UIView *moreWeightV3; //隐藏的长view
@property (weak, nonatomic) IBOutlet UIView *moreWeightV4; //隐藏的长view
@property (nonatomic, strong) UIButton *selectKgButton; //当前选中的kg值
@property (weak, nonatomic) IBOutlet UIButton *point1kgB; //0.1kgBtn
@property (weak, nonatomic) IBOutlet UIButton *point001kgB; //0.001kgBtn

@property (nonatomic, strong) UIButton *scaleButton; // 1/3 1/2 全部 被选中的btn
@end

@implementation ExitView

- (void)clearData {
    
    self.spreadB.selected = YES;
    self.spreadTF.enabled = YES;
    self.spreadTF.text = @"50";
    self.weightTF.text = @"1";
    
    self.selectKgButton.selected = NO; //将上次最后一次选中的btn取消选中
    if ([self.model.CommodityName isEqualToString:@"粤贵银"]) {
        self.weightBaseL.text = @"0.1kg";
        self.selectKgButton = self.point1kgB;
    } else {
        self.weightBaseL.text = @"0.001kg";
        self.selectKgButton = self.point001kgB;
    }
    self.selectKgButton.selected = YES; //选中, 不可少
    self.moreWeightV4.hidden = YES;
    self.moreWeightV3.hidden = YES;
    
    self.scaleButton.layer.borderColor = GrayBorderColor.CGColor;
    self.scaleButton.selected = NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.width = WIDTH;
    self.y = HEIGHT;
    
    //显示完成按钮, 以便点击退出键盘
    [[IQKeyboardManager sharedManager] setEnable:NO];
    //键盘弹起的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setModel:(HoldPositionInfoModel *)model {
    _model = model;
    
    self.nameL.text = model.CommodityName;
    if (model.OpenDirector == 1) {
        self.changeL.backgroundColor = OXColor(kRed);
        self.changeL.text = @"买涨";
    } else {
        self.changeL.backgroundColor = OXColor(kGreen);
        self.changeL.text = @"买跌";
    }
    
    self.floatingprofitandlossL.text = [NSString stringWithFormat:@"%.2f", model.OpenProfit]; //盈亏
    self.totalWeightL.text = [NSString stringWithFormat:@"%.3f", model.TotalWeight]; //总重量
    self.holdpriceL.text = [NSString stringWithFormat:@"%.2f", model.HoldPositionPrice]; //持仓价
    self.floatingprofitandlossPerL.text = model.settlementplPer; //盈亏比
    self.closePriceL.text = [NSString stringWithFormat:@"%.2f", model.ClosePrice]; //平仓价
    self.breakevenPriceL.text = [NSString stringWithFormat:@"%.2f", model.breakevenPrice]; //保本价
    self.priceL.text = [NSString stringWithFormat:@"平仓价格  %.2f", model.ClosePrice]; //平仓价格
    
    if (model.OpenProfit >= 0) { //设置盈亏&盈亏比的颜色
        self.floatingprofitandlossL.textColor = OXColor(kRed);
        self.floatingprofitandlossPerL.textColor = OXColor(kRed);
    } else {
        self.floatingprofitandlossL.textColor = OXColor(kGreen);
        self.floatingprofitandlossPerL.textColor = OXColor(kGreen);
    }
}

#pragma mark - 键盘通知方法

- (void)keyboardWillShow:(NSNotification *)noti {
    
    //tf相对于window的坐标
    CGPoint point = [self.weightTF convertPoint:self.weightTF.bounds.origin toView:nil];
    //最终突出部分的高度
    CGFloat protrusionH = point.y - self.y + self.weightTF.height;
    
    // 获取键盘y值
    NSDictionary *dict = noti.userInfo;
    CGFloat keyboardY = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    self.y = keyboardY - protrusionH;
    
    //弹出键盘时, 取消 1/3 1/2 全部 btn的选中状态
    self.scaleButton.layer.borderColor = GrayBorderColor.CGColor;
    self.scaleButton.selected = NO;
}

- (void)keyboardWillHide {
    self.y = HEIGHT - self.height;
}

#pragma mark - 点击事件

/** 允许差价 */
- (IBAction)clickedSpread:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    self.spreadTF.enabled = sender.selected;
    self.spreadTF.text = sender.selected ? @"50" : @"0";
}

- (IBAction)clickedMinus {
    CGFloat value = self.weightTF.text.floatValue - 1;
    self.weightTF.text = [NSString stringWithFormat:@"%ld", (NSInteger)(value > 0 ? value : 0)];
}
- (IBAction)clickedPlus {
    self.weightTF.text = [NSString stringWithFormat:@"%ld", (NSInteger)(self.weightTF.text.floatValue + 1)];
}

/** 选择更多重量基数 */
- (IBAction)clickedMoreWeight:(UIButton *)button {
    button.selected = !button.selected;
    
    if (!button.selected) {
        self.moreWeightV3.hidden = YES;
        self.moreWeightV4.hidden = YES;
        return;
    }
    
    if ([self.model.CommodityName isEqualToString:@"粤贵银"]) {
        self.moreWeightV4.hidden = NO;
        self.moreWeightV3.hidden = YES;
    } else {
        self.moreWeightV4.hidden = YES;
        self.moreWeightV3.hidden = NO;
    }
}

/** 点击了具体的kg值 */
- (IBAction)clickedKgValue:(UIButton *)button {
    
    CGFloat oldValue = self.weightTF.text.floatValue * self.selectKgButton.currentTitle.floatValue;
    self.weightTF.text = [NSString stringWithFormat:@"%ld", (NSInteger)(oldValue / button.currentTitle.floatValue)];
    
    self.selectKgButton.selected = NO;
    button.selected = YES;
    self.selectKgButton = button;
    
    self.weightBaseL.text = button.currentTitle;
    self.moreWeightV3.hidden = YES;
    self.moreWeightV4.hidden = YES;
    self.moreWeightB.selected = NO;
}

/** 1/3 1/2 or 全部 */
- (IBAction)clickedScaleButton:(UIButton *)button {
    
    self.scaleButton.layer.borderColor = GrayBorderColor.CGColor;
    self.scaleButton.selected = NO;
    button.layer.borderColor = OXColor(0xe55430).CGColor;
    button.selected = YES;
    self.scaleButton = button;
    
    CGFloat value = self.totalWeightL.text.floatValue / button.tag;
    CGFloat unit = self.weightBaseL.text.floatValue;
    self.weightTF.text = [NSString stringWithFormat:@"%.0f", value / unit];
}

- (IBAction)clickedCancel {
    [self disappear];
}
- (IBAction)clickedFinish {
    [self shouPopView];
}

- (void)disappear {
    [self clearData];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.y = HEIGHT;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

-(void)shouPopView{
    WEAK_SELF
    
    CGFloat value = self.weightTF.text.floatValue;
    CGFloat unit = self.weightBaseL.text.floatValue;
    
    NSArray *keys = @[ @"平仓价格: ", @"允许差价: ", @"平仓重量: ", @"参考手续费: " ];
    NSArray *values = @[ @(self.model.ClosePrice).stringValue,
                         self.spreadTF.text,
                         [NSString stringWithFormat:@"%.3fkg", value * unit],
                         [NSString stringWithFormat:@"%.2f", self.model.CommissionAmount] ];
    
    [[KMPopView popWithType:BuyOrderTypeLevel PriceType:0 Title:self.model.CommodityName DetailTitleLabels:keys DetailValueLabels:values sureBtn:@"确定" cancel:@"取消" block:^(NSInteger index) {
        
        if(index == 1){
            
            CloseMarketOrderParamModel *m = [[CloseMarketOrderParamModel alloc] init];
            m.nHoldPositionID = weakSelf.model.HoldPositionID;
            m.nCommodityID = weakSelf.model.CommodityID;
            m.dbWeight = value * unit;
            m.nQuantity = 1;
            m.nTradeRange = weakSelf.spreadTF.text.intValue;
            m.dbPrice = weakSelf.model.ClosePrice;
            //    LOG(@"%@", m);
            [[DealSocketTool shareInstance] REQ_CLOSEMARETWithOpenDirector_Direction:weakSelf.model.OpenDirector
                                                                               Param:m
                                                                               Block:^(ProcessResult stu) {
                                                                                   if (stu.RetCode == 99999) {
                                                                                       [HUDTool showText:@"平仓成功"];
                                                                                       if (weakSelf.successfulBlock) {
                                                                                           weakSelf.successfulBlock();
                                                                                       }
                                                                                   } else {
                                                                                       [HUDTool showText:[NSString stringWithCString:stu.Message encoding:NSUTF8StringEncoding]];
                                                                                   }
                                                                               }];
            [weakSelf disappear];
            
        }
    } canTapCancel:YES] show] ;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
