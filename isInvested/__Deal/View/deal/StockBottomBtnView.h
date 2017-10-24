//
//  StockBottomBtnView.h
//  isInvested
//
//  Created by Tom on 16/8/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StockBottomBtnViewDelegate <NSObject>

- (void)stockBottomBtnViewDelegateWithTag:(NSInteger)tag;

@end

typedef void(^dismiss)();

@interface StockBottomBtnView : UIView<UIPageViewControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,assign) NSInteger count;//默认选中值
@property (nonatomic,weak) id<StockBottomBtnViewDelegate>delegate;//代理
@property (nonatomic, copy) dismiss dismiss;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy) void (^chooseIndexBlock)(NSInteger tag);

@end
