//
//  HomeTitleView.m
//  isInvested
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "HomeTitleView.h"

@interface HomeTitleView ()

@property (nonatomic, weak) UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIView *newsLine;
@property (weak, nonatomic) IBOutlet UIView *calendarLine;
@end

@implementation HomeTitleView

- (WeeklyCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [WeeklyCalendarView viewFromXid];
        _calendarView.hidden = YES;
        _calendarView.y = 36.5;
    }
    return _calendarView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.width = WIDTH;
    
    [self addSubview:self.calendarView];
    
    self.selectButton = self.newsButton;
    self.height -= 55.5;
}

/** 点击标题 */
- (IBAction)clickedTitleB:(UIButton *)button {
    
    if (self.selectButton == button) return;
    
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
    
    self.newsLine.hidden = button.tag;
    self.calendarLine.hidden = !button.tag;
    
    self.calendarView.hidden = !button.tag;
    self.height += button.tag ? 55.5 : -55.5;
    
    button.tag ? ((void(^)())self.objc2)() : ((void(^)())self.objc1)();
}

@end
