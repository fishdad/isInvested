//
//  IndexPriceCell.m
//  isInvested
//
//  Created by Blue on 16/9/5.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "IndexPriceCell.h"
#import "CancelOrderView.h"
#import "MiddleMaskView.h"

@interface IndexPriceCell ()

/** 买涨or买跌 */
@property (weak, nonatomic) IBOutlet UILabel *buyUpOrDownL;
/** 品种名 */
@property (weak, nonatomic) IBOutlet UILabel *commoditynameL;
/** 下单时间 */
@property (weak, nonatomic) IBOutlet UILabel *createDateL;
/** 撤单btn */
@property (weak, nonatomic) IBOutlet UIButton *dealStatusB;

@property (weak, nonatomic) IBOutlet UILabel *totalWeightL;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceL;
@property (weak, nonatomic) IBOutlet UILabel *tPPriceL;
@property (weak, nonatomic) IBOutlet UILabel *sLPriceL;

@property (nonatomic, strong) CancelOrderView *cancelOrderView;
@end

@implementation IndexPriceCell

- (CancelOrderView *)cancelOrderView {
    if (!_cancelOrderView) {
        WEAK_SELF
        _cancelOrderView = [CancelOrderView viewFromXid];
        _cancelOrderView.centerY = self.window.centerY;
        _cancelOrderView.x = WIDTH;
        LimitOrderInfoModel *model = self.model;
        
        _cancelOrderView.clickedOrderBlock = ^(){
            [[DealSocketTool shareInstance] REQ_LIMITREVOKEWithLimitOrderID:model.LimitOrderID
                                                                CommodityID:model.CommodityID
                                                                  LimitType:model.LimitType
                                                                ResultBlock:^(ProcessResult stu) {
                                                                    
                                                                    if (stu.RetCode == 99999) {
                                                                        model.DealStatus = 3;
                                                                        [weakSelf setButtonDealStatus];
                                                                    } else {
                                                                        [HUDTool showText:[NSString stringWithCString:stu.Message encoding:NSUTF8StringEncoding]];
                                                                    }
                                                                }];
        };
    }
    return _cancelOrderView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setModel:(LimitOrderInfoModel *)model {
    [super setModel:model];
    
    self.buyUpOrDownL.backgroundColor = model.OpenDirector == 1 ? OXColor(kRed) : OXColor(kGreen);
    self.buyUpOrDownL.text = model.OpenDirector == 1 ? @"买涨" : @"买跌";
    self.commoditynameL.text = model.CommodityName;
    self.createDateL.text = [@"下单时间: " stringByAppendingString:model.seconds];
    
    self.totalWeightL.text = [NSString stringWithFormat:@"%.3f", model.TotalWeight];
    self.orderPriceL.text = [NSString stringWithFormat:@"%.2f", model.OrderPrice];
    
    NSString *tPPriceStr = [NSString stringWithFormat:@"%.2f", model.TPPrice];
    NSString *sLPriceStr = [NSString stringWithFormat:@"%.2f", model.SLPrice];
    tPPriceStr = [tPPriceStr isEqualToString:@"0.00"] ? @"--" : tPPriceStr;
    sLPriceStr = [sLPriceStr isEqualToString:@"0.00"] ? @"--" : sLPriceStr;
    self.tPPriceL.text = tPPriceStr;
    self.sLPriceL.text = sLPriceStr;
    
    [self setButtonDealStatus];
}

- (void)setButtonDealStatus {
    
    switch ([self.model DealStatus]) {
        case 1:
            [self.dealStatusB setTitle:@"撤单" forState:UIControlStateSelected];
            self.dealStatusB.layer.borderColor = OXColor(0xe6e6e6).CGColor;
            self.dealStatusB.backgroundColor = OXColor(0xf5f5f5);
            self.dealStatusB.selected = YES; //文字颜色加深
            break;
        case 2:
            [self.dealStatusB setTitle:@"已成交" forState:UIControlStateNormal];
            self.dealStatusB.layer.borderColor = [UIColor clearColor].CGColor;
            self.dealStatusB.backgroundColor = [UIColor clearColor];
            self.dealStatusB.selected = NO; //文字颜色变浅
            break;
        default:
            [self.dealStatusB setTitle:@"已撤单" forState:UIControlStateNormal];
            self.dealStatusB.layer.borderColor = [UIColor clearColor].CGColor;
            self.dealStatusB.backgroundColor = [UIColor clearColor];
            self.dealStatusB.selected = NO; //文字颜色变浅
            break;
    }
}

- (IBAction)clickedDealStatusButton:(UIButton *)button {
    
    if ([self.model DealStatus] == 1) {
        self.cancelOrderView.model = self.model;
        [[[MiddleMaskView alloc] init] setSubView:self.cancelOrderView];
    }
}

@end
