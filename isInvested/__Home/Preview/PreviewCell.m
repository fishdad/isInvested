//
//  PreviewCell.m
//  isInvested
//
//  Created by Blue on 16/8/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "PreviewCell.h"

@interface PreviewCell ()

@property (weak, nonatomic) IBOutlet UIButton *checkB;
@property (weak, nonatomic) IBOutlet UIButton *moveB;
@end

@implementation PreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    
    self.checkB.selected = checked;
    self.moveB.hidden = !checked;
}

- (IBAction)clickedCheckB:(UIButton *)sender {
    if (self.clickedSelectBlock) {
        self.clickedSelectBlock(!sender.selected);
    }
}

@end
