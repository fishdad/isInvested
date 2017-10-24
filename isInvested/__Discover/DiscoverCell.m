//
//  DiscoverCell.m
//  isInvested
//
//  Created by Blue on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "DiscoverCell.h"

@interface DiscoverCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageIv;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *explainL;
@end

@implementation DiscoverCell

- (void)setModel:(id)model {
    [super setModel:model];
    
    self.imageIv.image = [UIImage imageNamed:model[@"image"]];
    self.titleL.text = model[@"title"];
    self.explainL.text = model[@"explain"];
}

@end
