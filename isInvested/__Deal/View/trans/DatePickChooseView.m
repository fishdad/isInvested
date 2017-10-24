//
//  DatePickChooseView.m
//  时间选择器
//
//  Created by Ben on 16/9/20.
//  Copyright © 2016年 xiaxing. All rights reserved.
//

#import "DatePickChooseView.h"
#import "XLDatePickView.h"
#import "AppDelegate.h"

#define KWIDTH       [UIScreen mainScreen].bounds.size.width
#define KHEIGHT      [UIScreen mainScreen].bounds.size.height

@interface DatePickChooseView ()

@property (nonatomic, strong) XLDatePickView *pick1;
@property (nonatomic, strong) XLDatePickView *pick2;

@end

@implementation DatePickChooseView

-(void)dealloc{
    
    LOG(@"DatePickChooseView~~销毁");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.alpha = 0.7;
        backView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
        [backView addGestureRecognizer:tap];
        [self addSubview:backView];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, KHEIGHT - 316, KWIDTH, 316)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.frame = CGRectMake(0, 10, self.frame.size.width / 2.0, 30);
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"开始日期";
        [whiteView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.frame = CGRectMake(self.frame.size.width / 2.0, 10, self.frame.size.width / 2.0, 30);
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = @"结束日期";
        [whiteView addSubview:label2];
        
        WEAK_SELF
        _pick1 = [[XLDatePickView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width / 2.0, 216)];
        self.dataStr1 = [NSString stringWithFormat:@"%@-%@",_pick1.yearMonthStr,_pick1.dayStr];
        _pick1.dateBlock = ^(NSString *dateStr){
            weakSelf.dataStr1 = dateStr;
        };
        [whiteView addSubview:_pick1];
        
        _pick2 = [[XLDatePickView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0, 50, self.frame.size.width / 2.0, 216)];
        self.dataStr2 = [NSString stringWithFormat:@"%@-%@",_pick2.yearMonthStr,_pick2.dayStr];
        _pick2.dateBlock = ^(NSString *dateStr){
            weakSelf.dataStr2 = dateStr;
        };
        [whiteView addSubview:_pick2];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 316 - 40, KWIDTH - 30, 30);
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        btn.layer.borderWidth = 1;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btn];
       
    }
    return self;
}

-(void)setOutOfDays:(int)outOfDays{

    _outOfDays = outOfDays;
    //设置默认选中的时间
    //当前的日期
    NSString *date2 = [Util GetsTheCurrentCalendar];
    NSArray *dateArr2 = [date2 componentsSeparatedByString:@"-"];
    NSInteger yearMonth2 = ([dateArr2[0] integerValue] - 2016) * 12 + [dateArr2[1] integerValue] - 1;
    NSInteger day2 = [dateArr2[2] integerValue] - 1;
    
    
    //三个月前的日期
    NSInteger year = [dateArr2[0] integerValue];
    NSInteger month = [dateArr2[1] integerValue];
    NSInteger day = [dateArr2[2] integerValue];
    
    if (day >= outOfDays) {
        day = day - outOfDays + 1;
    }else{
        if (month == 1) {
            year = year - 1;
            month = 12;
            day = day + 31 - outOfDays + 1;
        }else{
            month = month - 1;
            day = day + [self getLastDayWithYear:year Month:month] - outOfDays + 1;
        }
    }
    NSInteger yearMonth = (year - 2016) * 12 + month - 1;
    [_pick1.pick selectRow:yearMonth inComponent:0 animated:NO];
    [_pick1.pick selectRow:day-1 inComponent:1 animated:NO];
    //默认的日期值
    _pick1.yearMonthStr = [NSString stringWithFormat:@"%li-%li",year,month];
    _pick1.dayStr = [NSString stringWithFormat:@"%li",day];
    self.dataStr1 = [NSString stringWithFormat:@"%li-%li-%li",year,month,day];
    
    //***结束日期
    NSString *now = [Util GetsTheCurrentCalendar];
    [_pick2.pick selectRow:yearMonth2 inComponent:0 animated:NO];
    [_pick2.pick selectRow:day2 inComponent:1 animated:NO];
    _pick2.yearMonthStr = [now substringWithRange:NSMakeRange(0, 7)];
    _pick2.dayStr = [now substringWithRange:NSMakeRange(8, 2)];
    self.dataStr2 = now;

}


-(NSInteger)getLastDayWithYear:(NSInteger) year Month:(NSInteger) month{
    
    NSInteger dayCount;
    if (month == 2) {
        if((year % 4 == 0 && year % 100 != 0 ) || (year % 400 == 0)){
            dayCount = 29;
        }else{
            
            dayCount = 28;
        }
    }else if (month == 4 || month == 6 || month == 9 || month == 11){
        
        dayCount = 30;
    }else{
        
        dayCount = 31;
    }

    return dayCount;
}

#pragma mark -- 判断时间差是否超出
-(BOOL)timeOutDays:(int) days fromDate:(NSString *)startDateStr toDate:(NSString *)endDateStr{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [[NSDate alloc] init];
    NSDate *endDate = [[NSDate alloc] init];
    startDate = [dateFormatter dateFromString:startDateStr];
    endDate = [dateFormatter dateFromString:endDateStr];
    //计算时间间隔（单位是秒）
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    if (time >= (days * 24 * 60 * 60)) {
        return YES;
    }else{
        return NO;
    }
}

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: LOG(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

//是否超出当前日期
-(BOOL)isAfterNowWithDateStr:(NSString *) dateStr{

    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",_dataStr1]];
    NSTimeInterval time = [date timeIntervalSinceNow];
    if (time > 0)
    {
        return YES;
    }else{
        return NO;
    }
}


-(void)btnClick:(UIButton *)btn{
    
    if ([self isAfterNowWithDateStr:_dataStr1])
    {
        [Util alertViewWithMessage:@"开始日期大于当前日期,请重新选择" Target:self.target];
        return;
    }
    
    if ([self compareDate:_dataStr1 withDate:_dataStr2] == -1) {
        [Util alertViewWithMessage:@"结束日期小于开始日期,请重新选择" Target:self.target];
//        [HUDTool showText:@"结束日期小于开始日期,请重新选择"];
        return;
    }
    
    if ([self timeOutDays:self.outOfDays fromDate:_dataStr1 toDate:_dataStr2]) {
        NSString *waringStr = [NSString stringWithFormat:@"查询时间的范围不能大于%d天,请重新设置",self.outOfDays];
        [Util alertViewWithMessage:waringStr Target:self.target];
//        [HUDTool showText:@"查询时间的范围不能大于7天,请重新设置"];
        return;
    }

    
    _dataStr = [NSString stringWithFormat:@"%@ 至 %@",_dataStr1,_dataStr2];
    if (self.dateBlock) {
        self.dateBlock(_dataStr,_dataStr1,_dataStr2);
    }
    [self dismiss];
    LOG(@"%@",_dataStr);
}

-(void)tapTouch{

    [self dismiss];
}

-(void)dismiss{

    [self removeFromSuperview];
    //屏蔽 by xinle 此处暂时不用
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSArray *views = [app.window.rootViewController.view subviews];
//    for(id v in views){
//        if([v isKindOfClass:[UITabBar class]]){
//            [(UITabBar *)v setHidden:NO];
//        }
//    }
}

@end
