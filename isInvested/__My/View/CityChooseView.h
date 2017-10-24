//
//  CityChooseView.h
//  isInvested
//
//  Created by Ben on 16/11/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^dismiss)();

@interface CityChooseView : UIView

@property (nonatomic,assign) NSInteger count;//默认选中值

@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, copy) dismiss dismiss;
@property (nonatomic, copy) void(^chooseIndexBlock)(NSString *province,NSString *city) ;
@end
