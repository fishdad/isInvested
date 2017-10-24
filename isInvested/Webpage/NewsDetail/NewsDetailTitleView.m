//
//  NewsDetailTitleView.m
//  isInvested
//
//  Created by Blue on 16/9/28.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NewsDetailTitleView.h"
#import "ImportantNewsMessage.h"

@interface NewsDetailTitleView ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *mediaL;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@end

@implementation NewsDetailTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.width = WIDTH;
    self.height = 100;
    self.y = -100;
}

- (void)setModel:(ImportantNewsMessage *)model {
    _model = model;
    
    self.titleL.text = model.Art_Title;
    self.mediaL.text = model.mediaAndTime;
    self.countL.text = model.Art_VisitCount;
}

@end
