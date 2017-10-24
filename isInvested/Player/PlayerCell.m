//
//  PlayerCell.m
//  isInvested
//
//  Created by Blue on 16/9/14.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "PlayerCell.h"

@interface PlayerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iv;
@end

@implementation PlayerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.width = WIDTH;
    self.height = HEIGHT_21_9;
}

- (void)setSrc:(NSString *)src {
    _src = src;
    
    UIImage *defaultImage = [UIImage imageNamed:@"player_default.jpg"];
    
    if (src.length) {
        [self.iv sd_setImageWithURL:[NSURL URLWithString:src] placeholderImage:defaultImage];
    } else {
        [self.iv setImage:defaultImage];
    }
}

@end
