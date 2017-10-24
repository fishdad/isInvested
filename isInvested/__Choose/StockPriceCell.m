//
//  StockPriceCell.m
//  isInvested
//
//  Created by Blue on 16/8/16.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "StockPriceCell.h"
#import "IndexModel.h"

@interface StockPriceCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *codeL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *percentL;
@end

@implementation StockPriceCell

- (void)setModel:(IndexModel *)model {
    [super setModel:model];
    
    if ([self.nameL.text isEqualToString:model.mediumName] &&
        [self.priceL.text isEqualToString:model.newPriceStr]) return;
    
    self.nameL.text = model.mediumName;
    self.codeL.text = model.code;
    self.priceL.text = model.newPriceStr;
    self.percentL.text = model.fluctuationPercentStr;
    self.priceL.textColor = OXColor(model.color);
    self.percentL.backgroundColor = OXColor(model.color);
    
    if (model.isFlash) { //主推来的, 要闪
        self.backgroundColor = OXColor(model.flashColor);
        [self performSelector:@selector(restoreBgColor) withObject:nil afterDelay:0.5];
    }
}

- (void)restoreBgColor {
    self.backgroundColor = [UIColor whiteColor];
    [self.model setIsFlash:NO];
}

@end
