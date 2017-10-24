//
//  PopMarketDealView.m
//  isInvested
//
//  Created by Ben on 16/12/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "PopMarketDealView.h"
#import "IQKeyboardManager.h"
#import "MarketOrderView.h"
#import "WeightChooseView.h"
#import "HorizontalScrollView.h"

@interface PopMarketDealView ()
{
    CGRect _frame;
}

@property (nonatomic, strong) NSString *commodityID;//商品的ID
@property (nonatomic, strong) WeightChooseView *weightView;
@property (nonatomic, strong) MarketOrderView *markView;
@property (nonatomic, assign) NSInteger weightChooseType;//重量选择类型
@property (nonatomic, strong) NSString *unit;//计量单位

@property (nonatomic, assign) BuyOrderType type;
@property (nonatomic, assign) PriceOrderType priceType;

@end

@implementation PopMarketDealView

- (instancetype)initWithFrame:(CGRect)frame CommodityID:(NSString *)commodityID
{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        _commodityID = commodityID;
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
    
    }
    return self;
}

-(void)setUpAllSubViews{
    
    //黑色底部
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.8;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
    [backView addGestureRecognizer:tap];
    [self addSubview:backView];
    
    //白色底部
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    //标题栏
    _titleView = [[VarietyDetailTitleView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    _titleView.actionBtn.hidden = YES;
    _titleView.type = BuyOrderTypeLevel;
    _titleView.titleLbl.text = @"粤贵银(KG)";
    [whiteView addSubview:_titleView];
    
    //重量选择视图(共用同一个重量选择视图)
    WEAK_SELF
    _weightView = [[WeightChooseView alloc] initWithMarketOrderType:_type];
    //0:手动输入重量 3:1/3  2:1/2   1:全部
    _weightView.easeChooseBlock = ^(NSInteger index){
        if (index != 0) {
            [weakSelf endEditing:YES];
        }
        weakSelf.weightChooseType = index;
        [weakSelf getWeightStepperValue];
    };
    _weightView.weightChangeBlock = ^(){
        
//        [weakSelf setUpPriceRateWithNewPrice:weakSelf.NewPrice];
    };
    
     __block HorizontalScrollView *view;
    //计量单位下拉显示
    _weightView.unitBlock = ^(){
        
        [weakSelf endEditing:YES];
        [NSUserDefaults setBool:YES forKey:@"UnitChoose"];
        CGFloat w = 200;
        NSDictionary *weightDic = [Util weightStepDicByComID];
        if (weakSelf.commodityID == nil) {
            return ;
        }
        CommodityInfoModel *model = nil;//当前的品种信息
        NSArray *items = weightDic[model.CommodityID];
        NSString *nowString = weakSelf.weightView.unitValueLbl.text;
        CGFloat hSpace = 45;
        view = [[HorizontalScrollView alloc] initWithFrame:CGRectMake(WIDTH , weakSelf.markView.y + hSpace, w, 35) Items:items NowString:nowString];
        //动画显示
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(WIDTH - w - 10, weakSelf.markView.y + hSpace, w, 35);
            view.chooseBlock = ^(NSInteger i){
                //单位选择
                weakSelf.weightView.unitValueLbl.text = [NSString stringWithFormat:@"X%@kg",items[i]];
                weakSelf.unit = items[i];
//                [weakSelf getWeightStepperValue];
            };
            
            [weakSelf.markView addSubview:view];
        }];
    };
    //计量单位下拉消失
    _weightView.unitDismissBlock = ^(){
        
        [NSUserDefaults setBool:NO forKey:@"UnitChoose"];
        [view removeFromSuperview];
    };


    //市价下单
    _markView = [[MarketOrderView alloc] initWithMarketOrderType:BuyOrderTypeUp WeightViewHeight:_weightView.height];
    _markView.frame = CGRectMake(0, _titleView.bottom , WIDTH, _markView.height);
    [whiteView addSubview:_markView];
    
    //重量的位置
    _weightView.frame = CGRectMake(0, _markView.priceValueLbl.bottom, WIDTH, _weightView.height);
    [_markView addSubview:_weightView];
    
    //取消按钮
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(0, _markView.bottom + 10, WIDTH * 0.4, 44);
    [_cancelBtn addTarget:self action:@selector(cancelClickBtn)
         forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.backgroundColor = OXColor(0xe6e6e6);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:OXColor(0x999999) forState:UIControlStateNormal];
    [whiteView addSubview:_cancelBtn];
    //操作按钮
    _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _okBtn.frame = CGRectMake(_cancelBtn.right,_markView.bottom + 10, WIDTH * 0.6, 44);
    [_okBtn addTarget:self action:@selector(okClickBtn) forControlEvents:UIControlEventTouchUpInside];
    _okBtn.backgroundColor = OrangeBackColor;
    [whiteView addSubview:_okBtn];
    
    CGFloat h = NH(_okBtn);
    whiteView.frame = CGRectMake(0, HEIGHT - h, WIDTH, h);
}

#pragma mark -- 计算重量值
-(void)getWeightStepperValue{
    
    WEAK_SELF
    if (weakSelf.weightChooseType == 0) {
        return;
    }
    //根据快速计算计算出输入框内的值
    float canByWeight = [weakSelf setUpCanByWeightLblValue];
    //    float canByWeight = 22.3; // xinle 测试值
    float weight = canByWeight / weakSelf.weightChooseType;
    float buyWeight = (weight / (weakSelf.unit.floatValue));
    int a;
    if (weakSelf.weightChooseType == 1) {
        a = (int)(buyWeight);
    }else{
        a = (int)(buyWeight + 0.5);
    }
    NSString *text = [NSString stringWithFormat:@"%i",a];
    weakSelf.weightView.weightStepper.txtCount.text = text;
}

#pragma mark -- 计算可买重量赋值并返回数据
-(float)setUpCanByWeightLblValue{
    
    //可买重量=余额÷（买入价×合约单位×（准备金率+手续费率）），即可买重量= Amount÷（BuyPrice×AgreeUnit×（DepositeRate+手续费率））。
    
    float weight;
//    float price;
//    float AgreeUnit;
//    float DepositeRate;
//    if (_priceType == PriceOrderTypeMarket) {//市价
//        if (_type == BuyOrderTypeUp) {//买涨
//            price = [self.commodityInfoModel.BuyPrice floatValue];
//        }else if(_type == BuyOrderTypeDown){//买跌
//            price = [self.commodityInfoModel.SellPrice floatValue];
//        }
//        AgreeUnit =  [self.openMarketOrderConfModel.AgreeUnit floatValue];
//        DepositeRate = [self.openMarketOrderConfModel.DepositeRate floatValue];
//    }    
//    if (price == 0) {//价格为零时处理
//        weight = 0;
//    }else{
//        weight = [self.amount floatValue] / (price * AgreeUnit * (DepositeRate + HandlingRate));
//    }
//    _weightView.canBuyTitleLbl.attributedText = [Util setStringsArr:@[@"最大可买重量:",[NSString stringWithFormat:@"%.2fkg",weight]] ColorsArr:@[[UIColor lightGrayColor],[UIColor blackColor]] FontsArr:@[FONT(12),FONT(12)]];
    return weight;
}


-(void)setUpPriceRateWithNewPrice:(NSString *)newPrice{

    //1.履约准备金。计算公式为，履约准备金=买入价×买入数量×合约单位×准备金率（即，履约准备金=BuyPrice×买入数量×AgreeUnit×DepositeRate）。
    //    _reserve = [newPrice floatValue] * weight * AgreeUnit * DepositeRate;
    //    _markView.reserveLbl.text = [NSString stringWithFormat:@"履约准备金:%.2f",_reserve];
    
    _markView.reserveLbl.text = [NSString stringWithFormat:@"履约准备金:%.2f",0.00];
    
    //2.成交后手续费。计算公式为，成交后手续费=买入价×买入数量×合约单位×手续费率（即，成交后手续费=BuyPrice×买入数量×AgreeUnit×手续费率）。
    //    _counterFee = [newPrice floatValue] * weight * AgreeUnit * HandlingRate;
    //    _markView.counterFeeLbl.text = [NSString stringWithFormat:@"成交后手续费:%.2f",_counterFee];
    
    _markView.counterFeeLbl.text = [NSString stringWithFormat:@"成交后手续费:%.2f",0.00];

}


-(void)tapTouch{
    
    //点击空白处不返回
        [self disMiss];
}

-(void)disMiss{
    
//    self.target = nil;
    [self removeFromSuperview];
}

-(void)cancelClickBtn{
    
    [self disMiss];
}

-(void)okClickBtn{
    
//    if (self.okBlock) {
//        self.okBlock();
//    }
    [self disMiss];
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
