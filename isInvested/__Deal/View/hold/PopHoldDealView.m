//
//  PopHoldDealView.m //批量平仓界面,此处所有的平仓都是市价平仓
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "PopHoldDealView.h"
#import "HorizontalScrollView.h"
#import "IQKeyboardManager.h"
#import "DealSocketTool.h"
#import "SocketTool.h"
#import "IndexModel.h"
#import "KMPopView.h"
#import "NSDecimalNumber+Addtion.h"

@interface PopHoldDealView ()
{
    CGRect _frame;
}

@property (nonatomic, strong) NSString *commodityID;//商品的ID
@property (nonatomic, strong) CloseMarketOrderConfModel *closeMarketOrderConfModel;//市价平仓的配置信息
@property (nonatomic, assign) float counterFee ;//成交后手续费
@property (nonatomic, strong) NSArray *detailTitleArr;
@property (nonatomic, strong) NSArray *detailValueArr;
@property (nonatomic, strong) NSString *unit;//计量单位
@property (nonatomic, assign) NSInteger weightChooseType;//重量选择类型
@property (nonatomic, strong) CloseMarketOrderManyParamModel *closeMarketOrderManyParamModel;//市价平仓入参

@end

@implementation PopHoldDealView

-(void)dealloc{
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.closeMarketOrderManyParamModel = nil;
    LOG(@"PopHoldDealView~~~销毁");
}

#pragma mark -- 自定义初始化
- (instancetype)initWithFrame:(CGRect)frame Model:(HoldPositionTotalInfoModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        _commodityID = model.CommodityID;
        _model = model;
        [[IQKeyboardManager sharedManager] setEnable:NO];
//        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;//键盘工具条 -- [完成]按钮的使用
        //注册键盘出现的通知
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWasShown:)
         
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        //注册键盘消失的通知
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillBeHidden:)
         
                                                     name:UIKeyboardWillHideNotification object:nil];


        [self setUpAllSubViews];
        if (_model != nil) {
            _detailView.model = _model;
            _titleView.model = _model;
            _priceView.priceValueLbl.text = [NSString stringWithFormat:@"%.2f",[model.ClosePrice doubleValue]];
        }
        //市价平仓配置信息
        [[DealSocketTool shareInstance] getCloseMarketOrderConByCommodityID:([_commodityID intValue]) WithBlock:^(CloseMarketOrderConfModel *model) {
            self.closeMarketOrderConfModel = model;
            _priceView.allowTF.text = model.DefaultTradeRange;
        }];
        
        //内页实时刷新
        WEAK_SELF
        weakSelf.refushBlock = ^(NSArray<HoldPositionTotalInfoModel *> *modelArr){
        
            for (HoldPositionTotalInfoModel * model in modelArr) {
                if ([weakSelf.model.CommodityID isEqualToString:model.CommodityID] && weakSelf.model.OpenDirector == model.OpenDirector) {
                    weakSelf.detailView.model = model;
                    weakSelf.priceView.priceValueLbl.text = [NSString stringWithFormat:@"%.2f",[model.ClosePrice doubleValue]];
                    break;
                }
            }
        };
        
        
    }
    return self;
}




#pragma mark -- 创建子控件
-(void)setUpAllSubViews{

    //黑色底部
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
    [backView addGestureRecognizer:tap];
    [self addSubview:backView];
    
    //白色底部
    UIView *whiteView = [[UIView alloc] init];
    whiteView.tag = 1001;
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    _titleView = [[VarietyDetailTitleView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    _titleView.actionBtn.hidden = YES;
    _titleView.type = BuyOrderTypeLevel;
    
    [whiteView addSubview:_titleView];
    _detailView = [[VarietyDetailView alloc] initWithFrame:CGRectMake(0, NH(_titleView), WIDTH, 130)];
    [whiteView addSubview:_detailView];
    
    _priceView = [[PriceDealView alloc] init];
    _priceView.priceTitleLbl.text = @"平仓价格";
    _priceView.frame = CGRectMake(0, NH(_detailView), WIDTH, 44);
    [whiteView addSubview:_priceView];
    
    _weightView = [[WeightChooseView alloc] initWithMarketOrderType:BuyOrderTypeLevel];
    _weightView.weightTitleLbl.text = @"平仓重量";
    _weightView.frame = CGRectMake(0, NH(_priceView), WIDTH, _weightView.height);
    [whiteView addSubview:_weightView];
    WEAK_SELF
    //市价?号帮助按钮
    _priceView.allowHelpBlock = ^(){
        
        [Util alertViewWithMessage:@"最大价差是指成交价和下单价的最大波动范围" Target:weakSelf.target];
    };
    __block HorizontalScrollView *unitChooseview;
    __weak typeof(_weightView) weakWeightView = _weightView;
    //计量单位下拉显示
    NSDictionary *weightDic = [Util weightStepDicByComID];
    NSArray *items = weightDic[weakSelf.commodityID];
    _weightView.unitValueLbl.text = [NSString stringWithFormat:@"X%@kg",items[0]];
    self.unit = items[0];
    //0:手动输入重量 3:1/3  2:1/2   1:全部
    _weightView.easeChooseBlock = ^(NSInteger index){
        
        if (index != 0) {
            [weakSelf endEditing:YES];
        }
        weakSelf.weightChooseType = index;
        [weakSelf getWeightStepperValue];
    };
    //计量单位
    _weightView.unitBlock = ^(){
        
        [NSUserDefaults setBool:YES forKey:@"UnitChoose"];
        CGFloat w = 200;
        //NSArray *items = @[@"0.1kg",@"1kg",@"15kg",@"100kg"];
        NSString *nowString = weakWeightView.unitValueLbl.text;
        //计量单位选择的view
        unitChooseview = [[HorizontalScrollView alloc] initWithFrame:CGRectMake(WIDTH ,whiteView.y + NH(weakWeightView) - 53, w, 35) Items:items NowString:nowString];
        //动画显示
        [UIView animateWithDuration:0.5 animations:^{
            unitChooseview.frame = CGRectMake(WIDTH - w - 10,whiteView.y + NH(weakWeightView) - 53, w, 35);
            unitChooseview.chooseBlock = ^(NSInteger i){
                //单位选择
                weakWeightView.unitValueLbl.text = [NSString stringWithFormat:@"X%@kg",items[i]];
                weakSelf.unit = items[i];
                //此处应该重新计算重量的输入值
                [weakSelf getWeightStepperValue];
                
            };
            
            [weakSelf addSubview:unitChooseview];
        }];
    };
    //计量单位下拉消失
    _weightView.unitDismissBlock = ^(){
        
        [NSUserDefaults setBool:NO forKey:@"UnitChoose"];
        [unitChooseview removeFromSuperview];
    };
    
    
    //取消按钮
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(0, NH(_weightView) + 10, WIDTH * 0.4, 44);
    [_cancelBtn addTarget:self action:@selector(cancelClickBtn)
         forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.backgroundColor = OXColor(0xe6e6e6);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:OXColor(0x999999) forState:UIControlStateNormal];
    [whiteView addSubview:_cancelBtn];
    //操作按钮
    _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _okBtn.frame = CGRectMake(NW(_cancelBtn),NH(_weightView) + 10, WIDTH * 0.6, 44);
    [_okBtn addTarget:self action:@selector(okClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _okBtn.backgroundColor = OrangeBackColor;
    [whiteView addSubview:_okBtn];
    CGFloat h = NH(_okBtn);
    whiteView.frame = CGRectMake(0, HEIGHT, WIDTH, h);
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.frame = CGRectMake(0, HEIGHT - h, WIDTH, h);
    }];
}

-(void)setType:(BuyOrderType)type{
    
    _type = type;
    if (type == BuyOrderTypeUp) {
          [_okBtn setTitle:@"平仓卖出" forState:UIControlStateNormal];
    }else if(type == BuyOrderTypeDown){
          [_okBtn setTitle:@"平仓买入" forState:UIControlStateNormal];
    }
}
#pragma mark -- 履约准备金 和 成交后手续费
-(void)setUpPriceRateWithNewPrice:(NSString *)newPrice{
    
    double weight = [self getWeight];
    double WeightRadio;
    WeightRadio = [self.closeMarketOrderConfModel.WeightRadio doubleValue];
    //2.成交后手续费。计算公式为，成交后手续费=买入价×买入数量×重量换算×手续费率（即，成交后手续费=BuyPrice×买入数量×WeightRadio×手续费率）。
    _counterFee = [newPrice doubleValue] * weight * WeightRadio * HandlingRate;
}
#pragma mark -- 计算重量值
-(void)getWeightStepperValue{
    
    WEAK_SELF
    if (weakSelf.weightChooseType == 0) {
        return;
    }
    //根据快速计算计算出输入框内的值
    double canByWeight = [self.model.TotalWeight doubleValue];
    double weight = canByWeight / weakSelf.weightChooseType;
    double buyWeight = (weight / (weakSelf.unit.doubleValue));
    
    //1.0 原始计算
//    int a;
//    if (weakSelf.weightChooseType == 1) {
//        a = (int)(buyWeight);
//    }else{
//        a = (int)(buyWeight + 0.5);
//    }
//    NSString *text = [NSString stringWithFormat:@"%i",a];
    
    
    //2.0 舍去四舍五入的计算
    if (weakSelf.weightChooseType != 1) {
        buyWeight = (buyWeight + 0.5);
    }
    NSString *text = [Util notRounding:buyWeight afterPoint:0];
    weakSelf.weightView.weightStepper.txtCount.text = text;
}

//计算重量
-(double)getWeight{

    double weight= 0;
    double dWeightStepper = _weightView.weightStepper.txtCount.text.doubleValue;
    double dUnit = self.unit.doubleValue;
    weight = dWeightStepper * dUnit;
    return weight;
}

//计算精确的重量
-(NSString *)getDecimalWeight{

    NSDecimalNumber * decimalWeight = [NSDecimalNumber aDecimalNumberWithString:_weightView.weightStepper.txtCount.text type:multiply anotherDecimalNumberWithString:self.unit];
    
    return [NSString stringWithFormat:@"%@",decimalWeight];
}

-(BOOL)getWeightWithBlock:(void(^)(NSString * weight)) weightBlock{

    double weightF = [self getWeight];
    if (weightF == 0) {
        [Util showHUDAddTo:self Text:@"平仓重量不能为零"];
        return NO;
    }
    //新商品，dbWeight* nQuantity必须在[MinTotalWeight,MaxTotalWeight]范围内。dbWeight须是 MinTotalWeight + N* WeightStep;  (N为正数)
    int nQuantity= 1;//设置交易手数,默认为1
    if (!(weightF * nQuantity >= self.closeMarketOrderConfModel.MinTotalWeight.doubleValue && weightF * nQuantity <= self.closeMarketOrderConfModel.MaxTotalWeight.doubleValue)) {
        
//        [Util alertViewWithMessage:[NSString stringWithFormat:@"平仓重量超出范围:[%.3fkg,%.0fkg]",self.closeMarketOrderConfModel.MinTotalWeight.floatValue,self.closeMarketOrderConfModel.MaxTotalWeight.floatValue] Target:self.target];
        [Util showHUDAddTo:self Text:[NSString stringWithFormat:@"平仓重量超出范围:[%.3fkg,%.0fkg]",self.closeMarketOrderConfModel.MinTotalWeight.doubleValue,self.closeMarketOrderConfModel.MaxTotalWeight.doubleValue]];
        return NO;
    }
    
    
//    if (weightF > [self.model.TotalWeight doubleValue]) {
//        [Util showHUDAddTo:self Text:@"平仓重量超出持仓总重量"];
//        return NO;
//    }
    
    //浮点型精确比较大小
    NSString *decimalWeight = [self getDecimalWeight];
    if ([NSDecimalNumber aDecimalNumberWithString:decimalWeight compareAnotherDecimalNumberWithString:self.model.TotalWeight] == NSOrderedDescending) {
        [Util showHUDAddTo:self Text:@"平仓重量超出持仓总重量"];
        return NO;

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

#pragma mark -- 归集单据信息,下单建仓
-(void)getOrderDatas{
    self.closeMarketOrderManyParamModel = [[CloseMarketOrderManyParamModel alloc] init];
    //获取重量
    __block NSString* closeWeight;
    if (![self getWeightWithBlock:^(NSString *weight) {
        closeWeight = weight;
    }]) {
        return;
    }
    //允许价差
    NSString *TradeRange;
    if (!_priceView.allowBtn.selected) {
        TradeRange = _priceView.allowTF.text;//允许价差
        //    	dbTradeRange 须在 [MinTradeRange, MaxTradeRange]范围内。
        if (!(TradeRange.doubleValue >= self.closeMarketOrderConfModel.MinTradeRange.doubleValue && TradeRange.doubleValue <= self.closeMarketOrderConfModel.MaxTradeRange.doubleValue)) {
            [Util alertViewWithMessage:[NSString stringWithFormat:@"允许价差超出范围:[%.0f,%.0f]",self.closeMarketOrderConfModel.MinTradeRange.doubleValue,self.closeMarketOrderConfModel.MaxTradeRange.doubleValue] Target:self.target];
            return ;
        }
    }else{
        TradeRange = @"0";
    }
    
    __block NSString *NewPrice;//价格
    
    //获取最新的行情报价
    [[DealSocketTool shareInstance] REQ_QUOTEBYID:[self.commodityID intValue] WithBlock:^(RealTimeQuote stu) {
        
        if (_type == BuyOrderTypeUp) {//买涨 的平仓对应的是买跌
            NewPrice = [NSString stringWithFormat:@"%.2f",stu.SellPrice];
            self.closeMarketOrderManyParamModel.nCloseDirector = OPENDIRECTOR_SELL;
        }else if(_type == BuyOrderTypeDown){//买跌 的平仓对应的是买涨
            NewPrice = [NSString stringWithFormat:@"%.2f",stu.BuyPrice];
            self.closeMarketOrderManyParamModel.nCloseDirector = OPENDIRECTOR_BUY;
        }
        //履约准备金,手续费
        [self setUpPriceRateWithNewPrice:NewPrice];
        NSString *counterFee = [NSString stringWithFormat:@"%.2f",_counterFee];//参考手续费
        
        //下单弹窗数据归集
        _detailTitleArr = @[@"平仓价格:  ",@"允许价差:  ",@"平仓重量:  ",@"参考手续费:  "];
        _detailValueArr = @[NewPrice,TradeRange,closeWeight,counterFee];
        
        //市价批量平仓的入参
        self.closeMarketOrderManyParamModel.nCommodityID = [self.commodityID intValue];
        self.closeMarketOrderManyParamModel.dbWeight = [closeWeight doubleValue];
        self.closeMarketOrderManyParamModel.nQuantity = 1;//此处默认都是1
        self.closeMarketOrderManyParamModel.nTradeRange = [TradeRange doubleValue];
        self.closeMarketOrderManyParamModel.dbPrice = [NewPrice doubleValue];
    
//        [self disMiss];
        [self shouPopView];
    }];

}

#pragma mark -- 展示下单的弹窗
-(void)shouPopView{
    
    KMPopView *popView = [KMPopView popWithType:BuyOrderTypeLevel PriceType:PriceOrderTypeMarket Title:_titleView.titleLbl.text DetailTitleLabels:_detailTitleArr DetailValueLabels:_detailValueArr sureBtn:@"确定" cancel:@"取消" block:^(NSInteger index) {
        
        if(index == 1){
            LOG(@"~~~~下单");
            //批量平仓
            [[DealSocketTool shareInstance] REQ_CLOSEMARETMANYWithParam:self.closeMarketOrderManyParamModel Block:^(ProcessResult stu) {
               
                if (stu.RetCode == 99999) {
                    [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
                        [self disMiss];
//                        [Util alertViewWithMessage:@"平仓成功" Target:dealVC];
                        [Util showHUDAddTo:dealVC.view Text:@"平仓成功"];
                        if (self.refushHoldToalBlock) {
                            self.refushHoldToalBlock();
                        }
                    }];
                }else{
                    NSString *str = [NSString stringWithUTF8String:stu.Message];
                    [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
                        [Util alertViewWithMessage:str Target:dealVC];
                    }];
                }
            }];
        }
    } canTapCancel:YES];
    [popView show];
    
}

-(void)tapTouch{
   //点击空白处不返回
   [self disMiss];
}

-(void)disMiss{

    //键盘消失
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
    self.target = nil;
    __block UIView *whiteView = [self viewWithTag:1001];
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.y = HEIGHT;
        [self removeFromSuperview];
    }];
}

-(void)cancelClickBtn{
    //键盘消失
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
    [self disMiss];
}

-(void)okClickBtn:(UIButton *)btn{
 
    if (self.okBlock) {
        self.okBlock();
    }
    btn.enabled = NO;
    //获取市场开休市状态
    [[DealSocketTool shareInstance] getMarketstatusWithStatusBlock:^(unsigned short isSuccess, NSString *statusStr) {
        
         btn.enabled = YES;
        if (isSuccess == 0) {//休市返回
            //            [HUDTool showText:statusStr];
            [Util alertViewWithMessage:statusStr Target:self.target];
            return ;
        }else{
            //归集平仓数据
            [self getOrderDatas];
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self endEditing:YES];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.frame = CGRectMake(0, -keyBoardFrame.size.height, WIDTH, HEIGHT);
}



-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.frame = _frame;
}

@end
