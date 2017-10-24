//
//  StopLossView.m
//  isInvested
//
//  Created by Blue on 16/9/5.
//  Copyright © 2016年 Blue. All rights reserved.
//  止盈止损view

#import "StopLossView.h"
#import "IQKeyboardManager.h"
#import "SocketTool.h"
#import "IndexModel.h"

@interface StopLossView ()

@property (weak, nonatomic) IBOutlet UILabel *changeL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *percentL;

/** 止盈价提示label */
@property (weak, nonatomic) IBOutlet UILabel *tppriceL;
/** 止盈价输入框tf */
@property (weak, nonatomic) IBOutlet UITextField *tppriceTF;
/** 止盈价提示label左边的边距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tppriceL_Leading;
/** 止盈价view,倒圆角用 */
@property (weak, nonatomic) IBOutlet UIView *tppriceV;

/** 止损价提示label */
@property (weak, nonatomic) IBOutlet UILabel *slpriceL;
/** 止损价输入框tf */
@property (weak, nonatomic) IBOutlet UITextField *slpriceTF;
/** 止损价提示label左边的边距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slpriceL_Leading;
/** 止损价view,倒圆角用 */
@property (weak, nonatomic) IBOutlet UIView *slpriceV;
//止盈价 & 止损价 btn
@property (weak, nonatomic) IBOutlet UIButton *tppriceB;
@property (weak, nonatomic) IBOutlet UIButton *slpriceB;

@property (nonatomic, copy) NSString *tppriceSign; // ≤ or ≥
@property (nonatomic, copy) NSString *slpriceSign; // ≤ or ≥
@property (nonatomic, assign) CGFloat tpprice; //止盈价初始范围值
@property (nonatomic, assign) CGFloat slprice; //止损价初始范围值
@property (nonatomic, assign) CGFloat closePrice; // 初始平仓价
@end

@implementation StopLossView

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTitleViewData:)
                                                 name:SocketRealTimeAndPushNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadTitleViewData:(NSNotification *)notification {
    
    if ([notification.userInfo[@"userInfo"] count] == 1) {
        IndexModel *model = notification.userInfo[@"userInfo"][0];
        self.priceL.text = [NSString stringWithFormat:@"%.2f", model.new_price / model.priceunit];
        self.percentL.text = [NSString stringWithFormat:@"%.2f%%", model.fluctuation_percent];
    }
}

#pragma mark - 键盘通知方法

- (void)keyboardWillShow:(NSNotification *)noti {
    
    //tf相对于window的坐标
    CGPoint point = [self.slpriceTF convertPoint:self.slpriceTF.bounds.origin toView:nil];
    //最终突出部分的高度
    CGFloat protrusionH = point.y - self.y + self.tppriceTF.height;
    
    // 获取键盘y值
    NSDictionary *dict = noti.userInfo;
    CGFloat keyboardY = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    self.y = keyboardY - protrusionH;
}

- (void)keyboardWillHide {
    self.y = HEIGHT - self.height;
}

- (void)setModel:(HoldPositionInfoModel *)model {
    _model = model;
    
    //买涨or买跌的颜色
    self.changeL.backgroundColor = model.OpenDirector == 1 ? OXColor(kRed) : OXColor(kGreen);
    self.changeL.text = model.OpenDirector == 1 ? @"买涨" : @"买跌";
    self.nameL.text = model.CommodityName;
    
    self.closePrice = model.ClosePrice; //保存初始平仓价
    
    // 计算止盈价 & 止损价 范围提示标签
    WEAK_SELF
    [[DealSocketTool shareInstance] getCloseLimitOrderConByCommodityID:model.CommodityID WithBlock:^(LimitClosePositionConfModel *m) {
        
        if (model.OpenDirector == 1) {
            weakSelf.tppriceSign = @"≥"; weakSelf.slpriceSign = @"≤";
            
            weakSelf.tpprice =   model.ClosePrice +
            m.TPSpread.floatValue * m.MinPriceUnit.floatValue +
            m.FixedSpread.floatValue * m.MinPriceUnit.floatValue;
            
            weakSelf.slprice =   model.ClosePrice -
            m.SLSpread.floatValue * m.MinPriceUnit.floatValue;
            
        } else {
            weakSelf.tppriceSign = @"≤"; weakSelf.slpriceSign = @"≥";
            
            weakSelf.tpprice =   model.ClosePrice -
            m.TPSpread.floatValue * m.MinPriceUnit.floatValue -
            m.FixedSpread.floatValue * m.MinPriceUnit.floatValue;
            
            weakSelf.slprice =   model.ClosePrice +
            m.SLSpread.floatValue * m.MinPriceUnit.floatValue;
        }
        weakSelf.tppriceL.text = [weakSelf.tppriceSign stringByAppendingFormat:@"%.2f", weakSelf.tpprice];
        weakSelf.slpriceL.text = [weakSelf.slpriceSign stringByAppendingFormat:@"%.2f", weakSelf.slprice];
    }];
    
    if (model.TPPrice) { //止盈价有值
        self.tppriceB.selected = YES;
        self.tppriceV.userInteractionEnabled = YES;
        self.tppriceTF.text = [NSString stringWithFormat:@"%.2f", model.TPPrice];
        if (self.tppriceL_Leading.constant == 0) {
            self.tppriceL_Leading.constant += self.tppriceL.width / 2 + 40;
        }
    }
    if (model.SLPrice) { //止损价有值
        self.slpriceB.selected = YES;
        self.slpriceV.userInteractionEnabled = YES;
        self.slpriceTF.text = [NSString stringWithFormat:@"%.2f", model.SLPrice];
        if (self.slpriceL_Leading.constant == 0) {
            self.slpriceL_Leading.constant += self.tppriceL.width / 2 + 40;
        }
    }
    
    if (model.CommodityID == 100000000) { //这是月贵银
        self.tppriceTF.keyboardType = UIKeyboardTypeNumberPad;
        self.slpriceTF.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        self.tppriceTF.keyboardType = UIKeyboardTypeDecimalPad;
        self.slpriceTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
}

- (void)setRefreshModel:(HoldPositionInfoModel *)refreshModel {
    _refreshModel = refreshModel;
    
    CGFloat diff = refreshModel.ClosePrice - self.closePrice; // 平仓价的变化值
    self.tppriceL.text = [NSString stringWithFormat:@"%@%.2f", self.tppriceSign, self.tpprice + diff];
    self.slpriceL.text = [NSString stringWithFormat:@"%@%.2f", self.slpriceSign, self.slprice + diff];
}

- (void)clearData {
    self.tppriceB.selected = NO;
    self.tppriceV.userInteractionEnabled = NO;
    self.tppriceL_Leading.constant = 0;
    self.tppriceTF.text = @"";
    [self.tppriceTF resignFirstResponder];
    
    self.slpriceB.selected = NO;
    self.slpriceV.userInteractionEnabled = NO;
    self.slpriceL_Leading.constant = 0;
    self.slpriceTF.text = @"";
    [self.slpriceTF resignFirstResponder];
}

#pragma mark - 点击事件

/** 点击止盈价button */
- (IBAction)clickedTppriceB:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.tppriceV.userInteractionEnabled = sender.selected;
    
    if (sender.selected) { //勾选
        self.tppriceL_Leading.constant += self.tppriceL.width / 2 + 40;
        [self.tppriceTF becomeFirstResponder];
    } else { //未勾选
        self.tppriceL_Leading.constant -= self.tppriceL.width / 2 + 40;
        self.tppriceTF.text = @"";
    }
}
/** 点击止损价button */
- (IBAction)clickedSlpriceB:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.slpriceV.userInteractionEnabled = sender.selected;
    
    if (sender.selected) { //勾选
        self.slpriceL_Leading.constant += self.tppriceL.width / 2 + 40;
        [self.slpriceTF becomeFirstResponder];
    } else { //未勾选
        self.slpriceL_Leading.constant -= self.tppriceL.width / 2 + 40;
        self.slpriceTF.text = @"";
    }
}

/** 止盈价-1 */
- (IBAction)clickedTppriceMinus {
    self.tppriceTF.text = self.tppriceTF.text.minus1ByMinValueIs0;
}
/** 止损价-1 */
- (IBAction)clickedSlpriceMinus {
    self.slpriceTF.text = self.slpriceTF.text.minus1ByMinValueIs0;
}

/** 止盈价+1 */
- (IBAction)clickedTppricePlus {
    self.tppriceTF.text = self.tppriceTF.text.plus1ByMaxValueIs99999point99;
}
/** 止损价+1 */
- (IBAction)clickedSlpricePlus {
    self.slpriceTF.text = self.slpriceTF.text.plus1ByMaxValueIs99999point99;
}

/** 限制输入长度 */
- (IBAction)limitLength:(UITextField *)sender {
    sender.text = sender.text.priceByTenThousand;
}

- (IBAction)clickedCancel {
    [self disappear];
}
- (IBAction)clickedFinish {
    
    if (!self.tppriceB.selected && !self.slpriceB.selected) {
        [HUDTool showText:@"请选择止盈价、止损价范围！"];
        return;
    }
    if (self.tppriceB.selected && self.tppriceTF.text.length == 0) {
        [HUDTool showText:@"请输入止盈价"];
        return;
    }
    if (self.slpriceB.selected && self.slpriceTF.text.length == 0) {
        [HUDTool showText:@"请输入止损价"];
        return;
    }
    
    WEAK_SELF
    self.model.SLPrice = self.slpriceTF.text.floatValue;
    self.model.TPPrice = self.tppriceTF.text.floatValue;
    
    CGFloat tppriceRange = [self.tppriceL.text substringWithRange:NSMakeRange(1, self.tppriceL.text.length - 1)].floatValue;
    CGFloat slpriceRange = [self.tppriceL.text substringWithRange:NSMakeRange(1, self.slpriceL.text.length - 1)].floatValue;
    
    if (self.model.OpenDirector == 1) {
        if (self.model.TPPrice < tppriceRange && self.tppriceB.selected) {
            [HUDTool showText:@"止盈价不符合条件"];
            return;
        }
        if (self.model.SLPrice > slpriceRange && self.slpriceB.selected) {
            [HUDTool showText:@"止损价不符合条件"];
            return;
        }
    } else {
        if (self.model.TPPrice > tppriceRange && self.tppriceB.selected) {
            [HUDTool showText:@"止盈价不符合条件"];
            return;
        }
        if (self.model.SLPrice < slpriceRange && self.slpriceB.selected) {
            [HUDTool showText:@"止损价不符合条件"];
            return;
        }
    }
    
    [[DealSocketTool shareInstance] REQ_CLOSELIMITWithOpenDirector_Direction:self.model.OpenDirector
                                                             nHoldPositionID:self.model.HoldPositionID
                                                                 CommodityID:self.model.CommodityID
                                                                   dbSLPrice:self.model.SLPrice
                                                                   dbTPPrice:self.model.TPPrice
                                                                 ResultBlock:^(ProcessResult stu) {
                                                                     if (stu.RetCode == 99999) {
                                                                         [HUDTool showText:@"委托成功"];
                                                                         if (weakSelf.successfulBlock) {
                                                                             weakSelf.successfulBlock();
                                                                         }
                                                                     } else {
                                                                         [HUDTool showText:[NSString stringWithCString:stu.Message encoding:NSUTF8StringEncoding]];
                                                                     }
                                                                 }];
    [self disappear];
}

- (void)disappear {
    [self clearData];
    [[SocketTool sharedSocketTool] disconnect];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.y = HEIGHT;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

@end
