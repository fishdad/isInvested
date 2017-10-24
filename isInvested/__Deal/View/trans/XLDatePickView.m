//
//  XLDatePickView.m
//  时间选择器
//
//  Created by Ben on 16/9/20.
//  Copyright © 2016年 xiaxing. All rights reserved.
//

#import "XLDatePickView.h"

@implementation XLDatePickView

-(void)dealloc{

    LOG(@"XLDatePickView~~销毁");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _width = self.frame.size.width;
        
         _yearMonthArr = [NSMutableArray arrayWithCapacity:1];
        //年份现在暂定为2016~2036年
        if (_yearMonthArr.count == 0) {
            for (int i = 0; i < 20; i ++) {
                for (int j = 1; j <= 12; j ++) {
                    NSString *yearMonth = [NSString stringWithFormat:@"%i年%i月",(2016 + i),j];
                    [_yearMonthArr addObject:yearMonth];
                }
            }

        }
        
        _dayArr = [NSMutableArray arrayWithCapacity:1];
        for (int i = 1 ; i <= 31 ; i++) {
            [_dayArr addObject:[NSString stringWithFormat:@"%i日",i]];
        }
        [self setUpYearMonthStrByRow:0];
        [self setUpDayStrByRow:0];
        
        _pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0,_width,216)];
        _pick.delegate = self;
        _pick.dataSource = self;
        [self addSubview:_pick];
        
        [_pick reloadAllComponents];
    }
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _yearMonthArr.count;
    }else{
        
        return _dayArr.count;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (component == 0) {
        return (_width ) * 2 / 3.0;
    }else{
        
        return (_width ) * 1 / 3.0;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    NSString *title;
    CGFloat width;
    if (component == 0) {
        title = _yearMonthArr[row];
        width = (_width ) * 2 / 3.0;
    }else{
        
        title = _dayArr[row];
        width = (_width ) * 1 / 3.0;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0,width,44);
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        [self setUpYearMonthStrByRow:row];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [self setUpDayStrByRow:0];
    }else{
        [self setUpDayStrByRow:row];
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",_yearMonthStr,_dayStr];
    if (self.dateBlock) {
        self.dateBlock(dateStr);
    }
    LOG(@"%@",dateStr);
    
}
-(void)setUpYearMonthStrByRow:(NSInteger)row{
    
    _yearMonthStr = _yearMonthArr[row];
    NSRange yearRange = [_yearMonthStr rangeOfString:@"年"];
    NSString *year = [_yearMonthStr substringWithRange:NSMakeRange(0, yearRange.location)];
    NSRange monthRange = [_yearMonthStr rangeOfString:@"月"];
    NSString *month = [_yearMonthStr substringWithRange:NSMakeRange(yearRange.location + 1, monthRange.location - yearRange.location - 1)];
    [self setDayArrWithYear:year.integerValue Month:month.integerValue];
    if (month.integerValue < 10) {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    _yearMonthStr = [NSString stringWithFormat:@"%@-%@",year,month];
}

-(void)setUpDayStrByRow:(NSInteger)row{
    
    _dayStr = _dayArr[row];
    NSRange dayRange = [_dayStr rangeOfString:@"日"];
    _dayStr = [_dayStr substringWithRange:NSMakeRange(0, dayRange.location)];
    if (_dayStr.integerValue < 10) {
        _dayStr = [NSString stringWithFormat:@"0%@",_dayStr];
    }
    
}

-(void)setDayArrWithYear:(NSInteger) year Month:(NSInteger) month{
    
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
    
    [_dayArr removeAllObjects];
    for (int i = 1; i <= dayCount; i++) {
        [_dayArr addObject:[NSString stringWithFormat:@"%i日",i]];
    }
}


@end
