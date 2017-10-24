//
//  ImportantNews3ImgCell.m
//  isInvested
//
//  Created by Blue on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ImportantNews3ImgCell.h"
#import "ImportantNewsMessage.h"

@interface ImportantNews3ImgCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *image1L;
@property (weak, nonatomic) IBOutlet UIImageView *image2L;
@property (weak, nonatomic) IBOutlet UIImageView *image3L;
@property (weak, nonatomic) IBOutlet UILabel *mediaL;
@end

@implementation ImportantNews3ImgCell

- (void)setModel:(ImportantNewsMessage *)model {
    [super setModel:model];
    
    self.titleL.text = model.Art_Title;
    if (model.Art_Images.count >= 3) {
        [self.image1L sd_setImageWithURL:[NSURL URLWithString:model.Art_Images[0]]];
        [self.image2L sd_setImageWithURL:[NSURL URLWithString:model.Art_Images[1]]];
        [self.image3L sd_setImageWithURL:[NSURL URLWithString:model.Art_Images[2]]];
    }
    self.mediaL.text = model.Art_MediaAndTime;
}

@end
