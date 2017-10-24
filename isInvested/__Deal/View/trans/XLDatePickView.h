//
//  XLDatePickView.h
//  时间选择器
//
//  Created by Ben on 16/9/20.
//  Copyright © 2016年 xiaxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLDatePickView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *yearMonthArr;
@property (nonatomic, strong) NSMutableArray *dayArr;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSString *yearMonthStr;
@property (nonatomic, strong) NSString *dayStr;
@property (nonatomic, copy) void (^dateBlock)(NSString *dateStr);
@property (nonatomic, strong) UIPickerView *pick;

@end
