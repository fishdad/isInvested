//
//  FinanceNewsCell.m
//  isInvested
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "FinanceNewsCell.h"
#import "NewsMessage.h"
#import "ShareView.h"

@interface FinanceNewsCell ()

/** 文本高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textH;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

/** 此为以下3个label的父view */
@property (weak, nonatomic) IBOutlet UIView  *FinanceV;
@property (weak, nonatomic) IBOutlet UILabel *beforeL;
@property (weak, nonatomic) IBOutlet UILabel *predictionL;
@property (weak, nonatomic) IBOutlet UILabel *resultL;
@end

@implementation FinanceNewsCell

- (void)setModel:(NewsMessage *)model {
    [super setModel:model];
    
    self.textH.constant = model.textHeight;
    self.contentL.attributedText = model.isShowGray ? model.grayContent : model.content;
    self.FinanceV.hidden = !model.Type;
    
    if (model.Type) {
        self.beforeL.text     = model.Finance_Before;
        self.predictionL.text = model.Finance_Prediction;
        self.resultL.text     = model.Finance_Result;
    }
}

- (IBAction)clickedShare {
    
//    ShareModel *model = [[ShareModel alloc] init];
//    model.caption = @"标题还没确定------";
//    model.content = self.model.News_Content;
//    model.imageUrl = self.model.News_ImageUrl;
//    model.gotoUrl = @"www.baidu.com";
//    
//    [[ShareView viewFromXid] setModel:model];
}

@end
