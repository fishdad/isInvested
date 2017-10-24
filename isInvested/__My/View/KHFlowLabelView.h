//
//  KHFlowLabelView.h
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHFlowLabelView : UIView

@property(nonatomic,strong) UILabel *label;

- (instancetype)initWithFrame:(CGRect)frame LabelText:(NSString *)text BackColor:(UIColor *)color;

@end
