//
//  CancelOrderView.m
//  isInvested
//
//  Created by Blue on 16/9/7.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CancelOrderView.h"

@interface CancelOrderView ()

@property (weak, nonatomic) IBOutlet UIImageView *cornerIv;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UIButton *cancelB;
@end

@implementation CancelOrderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = 0;
    
    self.layer.cornerRadius = 10.0;
}

- (void)setModel:(LimitOrderInfoModel *)model {
    _model = model;
    
    if (model.OpenDirector == 1) { //买涨
        self.cornerIv.image = [UIImage imageNamed:@"dealdetails_buyup"];
        self.cancelB.backgroundColor = OXColor(kRed);
    } else { //买跌
        self.cornerIv.image = [UIImage imageNamed:@"dealdetails_buydown"];
        self.cancelB.backgroundColor = OXColor(kGreen);
    }
    self.nameL.text = model.CommodityName;
    self.priceL.text = [NSString stringWithFormat:@"指定价格:  %.2f", model.OrderPrice];
    self.weightL.text = [NSString stringWithFormat:@"买入重量:  %.3f kg", model.TotalWeight];
}

/** 为截取手势用 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (IBAction)clickedCancel {
    [self disappear];
}

- (IBAction)clickedOrder {
    
    if (self.clickedOrderBlock) {
        self.clickedOrderBlock();
    }
    [self disappear];
}

- (void)disappear {
    [UIView animateWithDuration:0.25 animations:^{
        self.x = WIDTH;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

@end
