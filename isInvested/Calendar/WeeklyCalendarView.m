//
//  WeeklyCalendarView.m
//  isInvested
//
//  Created by Blue on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "WeeklyCalendarView.h"

@interface WeeklyCalendarView ()

@property (nonatomic, weak) UIButton *selectButton;
@property (nonatomic, strong) NSArray<NSDate *> *dates; //7天的NSDate
@property (nonatomic, strong) NSArray<UIButton *> *dateButtons; //7天的日期btn

@property (weak, nonatomic) IBOutlet UILabel *weekL0;
@property (weak, nonatomic) IBOutlet UILabel *weekL1;
@property (weak, nonatomic) IBOutlet UILabel *weekL2;
@property (weak, nonatomic) IBOutlet UILabel *weekL3;
@property (weak, nonatomic) IBOutlet UILabel *weekL4;
@property (weak, nonatomic) IBOutlet UILabel *weekL5;
@property (weak, nonatomic) IBOutlet UILabel *weekL6;

@property (weak, nonatomic) IBOutlet UIButton *dateB0;
@property (weak, nonatomic) IBOutlet UIButton *dateB1;
@property (weak, nonatomic) IBOutlet UIButton *dateB2;
@property (weak, nonatomic) IBOutlet UIButton *dateB3;
@property (weak, nonatomic) IBOutlet UIButton *dateB4;
@property (weak, nonatomic) IBOutlet UIButton *dateB5;
@property (weak, nonatomic) IBOutlet UIButton *dateB6;
@end

@implementation WeeklyCalendarView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.width = WIDTH;
    
    [self createView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(createView)
                                                name:UIApplicationSignificantTimeChangeNotification
                                              object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createView {
    
    NSArray<UILabel *> *weeks = @[self.weekL0, self.weekL1, self.weekL2, self.weekL3, self.weekL4, self.weekL5, self.weekL6];
    self.dateButtons = @[self.dateB0, self.dateB1, self.dateB2, self.dateB3, self.dateB4, self.dateB5, self.dateB6];
    
    self.selectButton = self.dateButtons[4];
    self.selectButton.selected = YES;
    
    self.dates = [NSDate getWeekDays];
    for (NSInteger i = 0; i < self.dateButtons.count; i++) {
        
        weeks[i].attributedText = self.dates[i].weekStr;
        [self.dateButtons[i] setAttributedTitle:self.dates[i].dateStr forState:UIControlStateNormal];
        
        self.dateButtons[i].tag = i;
        if (self.dates[i].week >= 6) { //如遇周六&周日, tag值多加100
            self.dateButtons[i].tag = 100 + i;
        }
    }
    // 设置今天btn的显示样式
    [self setStyleWithButton:self.dateButtons[4]];
    
    if (self.clickedDayBlock) {
        self.clickedDayBlock([@"yyyy-MM-dd" currentTime]);
    }
}

/** 点击不同日期 */
- (IBAction)clickedDay:(UIButton *)button {
    
    if (self.selectButton == button) return; //忽略重复点击
    
    // 取消上个btn
    [self cancelStyleWithButton:self.selectButton];
    
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
    
    // 选中当前的btn
    [self setStyleWithButton:button];
    
    NSInteger tag = (button.tag >= 100) ? (button.tag - 100) : button.tag;
    if (self.clickedDayBlock && tag <= 6) {
        self.clickedDayBlock([@"yyyy-MM-dd" stringFromDate:self.dates[tag]]);
    } else {
        [Util alertViewWithMessage:[NSString stringWithFormat:@"tag==%ld  btn.tag==%ld", tag, button.tag]
                            Target:self.window.rootViewController];
#warning 需删除
    }
}

#pragma mark - 设置btn样式

- (void)setStyleWithButton:(UIButton *)button {
    
    NSAttributedString *oldStr = button.currentAttributedTitle;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:oldStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, oldStr.length)];
    
    [button setAttributedTitle:str forState:UIControlStateNormal];
    if (button == self.dateButtons[4]) { //这是今天的btn
        [button setBackgroundImage:[UIImage imageNamed:@"circle_red_26"] forState:UIControlStateSelected];
    }
}

#pragma mark - 取消btn样式

- (void)cancelStyleWithButton:(UIButton *)button {
    
    UIColor *color;
    if (self.selectButton == self.dateButtons[4]) { //1.今天
        color = OXColor(0xcc3b18);
        
    } else if (self.selectButton.tag >= 100) { //2.周末
        color = OXColor(0x999999);
        
    } else { //3.工作日
        color = [UIColor blackColor];
    }
    
    NSAttributedString *oldStr = button.currentAttributedTitle;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:oldStr];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, oldStr.length)];
    
    [button setAttributedTitle:str forState:UIControlStateNormal];
}

@end
