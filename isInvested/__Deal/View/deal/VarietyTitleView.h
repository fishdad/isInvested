//
//  VarietyTitleView.h
//  isInvested
//
//  Created by Ben on 16/9/6.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VarietyTitleView : UIView

@property (nonatomic, strong) UIButton *varietyBtn;//是否显示行情
@property (nonatomic, strong) UIButton *varietyBtn1;//是否显示行情,右侧点击区域
@property (nonatomic, strong) UIButton *titleBtn;//品种名称
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *NewPriceLbl;
@property (nonatomic, strong) UILabel *ZFLbl;

@property (nonatomic, strong) NSString *NewPriceValue;
-(void)setNewPriceValue:(NSString *)NewPriceValue Fluctuation_percent:(CGFloat) fluctuation_percent;

@end
