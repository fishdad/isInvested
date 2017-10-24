//
//  ImportantNews1ImgCell.m
//  isInvested
//
//  Created by Blue on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ImportantNews1ImgCell.h"
#import "ImportantNewsMessage.h"

@interface ImportantNews1ImgCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageIv;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *mediaL;
@end

@implementation ImportantNews1ImgCell

- (void)setModel:(ImportantNewsMessage *)model {
    [super setModel:model];
    
    if (model.Art_Images.count) {
        [self.imageIv sd_setImageWithURL:[NSURL URLWithString:model.Art_Images[0]]];
    }
    self.titleL.text = model.Art_Title;
    self.mediaL.text = model.Art_MediaAndTime;
}

@end
