//
//  HomeTitleView.h
//  isInvested
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeeklyCalendarView.h"

@interface HomeTitleView : UIView

@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (nonatomic, strong) WeeklyCalendarView *calendarView;
@end
