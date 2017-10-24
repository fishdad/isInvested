//
//  StopPriceView.h
//  isInvested
//
//  Created by Ben on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceChooseView.h"

@interface StopPriceView : UIView

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) PriceChooseView *stopUp;
@property (nonatomic, strong) PriceChooseView *stopDown;
@property (nonatomic, assign) NSInteger prcision;
//实时修改止盈,止损的参考值
-(void)setStopValue:(NSString *) value OrderType:(BuyOrderType) type UpValue:(NSString *)upValue DownValue:(NSString *)downValue FixedSpread:(NSString *)FixedSpread;

@end
