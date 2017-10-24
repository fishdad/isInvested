//
//  CalendarCell.m
//  isInvested
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CalendarCell.h"
#import "CalendarMessage.h"

@interface CalendarCell ()

@property (weak, nonatomic) IBOutlet UIImageView *flagIv;
@property (weak, nonatomic) IBOutlet UILabel     *contentL;

@property (weak, nonatomic) IBOutlet UIView  *resultSignV;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *resultL;

@property (weak, nonatomic) IBOutlet UILabel     *bottomL1;
@property (weak, nonatomic) IBOutlet UILabel     *bottomL2;
@property (weak, nonatomic) IBOutlet UILabel     *bottomL3;
@property (weak, nonatomic) IBOutlet UIImageView *starIv;
@end

@implementation CalendarCell

- (void)setModel:(CalendarMessage *)model {
    [super setModel:model];
    
    //隐藏的cell用于没数据时显示图片, 占位用
    self.contentView.hidden = !model.Country_Code;
    if (self.contentView.hidden) return;

    self.flagIv.image = [UIImage imageNamed:model.Country_Code];
    self.contentL.text = model.Finance_Title;
    self.timeL.text = model.Finance_Time;
    self.resultL.text = model.result;
    self.resultSignV.backgroundColor = OXColor(model.signColor);
    
    self.bottomL1.text = model.Finance_Before;
    self.bottomL2.text = model.Finance_Prediction;
    self.bottomL3.text = model.Finance_Result;
    self.starIv.image = [UIImage imageNamed:model.starPicName];
}

@end
