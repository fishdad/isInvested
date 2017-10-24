//
//  IndexRectangleCell.m
//  isInvested
//
//  Created by Blue on 16/10/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "IndexRectangleCell.h"
#import "IndexModel.h"

@interface IndexRectangleCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
/** 涨跌幅 & 涨跌额 */
@property (weak, nonatomic) IBOutlet UILabel *fluchuationL;
@end

@implementation IndexRectangleCell

- (void)setModel:(IndexModel *)model {
    [super setModel:model];
    
    if (!model.name) { //占位用的, 什么也不显示
        self.nameL.text = self.priceL.text = self.fluchuationL.text = @"";
        return;
    }
    
    //无网显示 --
    if ([HttpTool networkStatus] == NotReachable ||
        model.new_price == 0 ) {
        self.nameL.text = @"--";
        self.priceL.text = @"--";
        self.fluchuationL.text = @"--    --";
        self.priceL.textColor = OXColor(0x666666);
        self.fluchuationL.textColor = OXColor(0x666666);
        return;
    }
    
    self.nameL.text = model.name;
    self.priceL.text = model.newPriceStr;
    self.fluchuationL.text = [model.fluctuationStr stringByAppendingFormat:@"  %@", model.fluctuationPercentStr];
    self.priceL.textColor = OXColor(model.color);
    self.fluchuationL.textColor = OXColor(model.color);

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
