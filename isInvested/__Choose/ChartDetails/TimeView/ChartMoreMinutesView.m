//
//  ChartMoreMinutesView.m
//  isInvested
//
//  Created by Blue on 16/9/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ChartMoreMinutesView.h"

@implementation ChartMoreMinutesView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.x = WIDTH - self.width - 5;
    self.y = 64 + 120 + 30;
    
    self.layer.cornerRadius = 5.0;
}

- (IBAction)clickedMinuteB:(UIButton *)button {
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
    
    if (self.clickedMinuteBlock) {
        self.clickedMinuteBlock(button.tag);
    }
}

@end
