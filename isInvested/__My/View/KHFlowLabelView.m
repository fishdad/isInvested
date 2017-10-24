//
//  KHFlowLabelView.m
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "KHFlowLabelView.h"

@implementation KHFlowLabelView

- (instancetype)initWithFrame:(CGRect)frame LabelText:(NSString *)text BackColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpMyViewWithLabelText:(NSString *)text BackColor:(UIColor *)color];
    }
    return self;
}

-(void)setUpMyViewWithLabelText:(NSString *)text BackColor:(UIColor *)color{
    
    CGFloat bigW = self.frame.size.width;
    CGFloat smallW = bigW - 15;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bigW, bigW)];
    view.layer.masksToBounds = YES;
    view.backgroundColor = LightGrayBackColor;
    view.layer.cornerRadius = bigW / 2;
    [self addSubview:view];
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0,0, smallW, smallW);
    _label.center = view.center;
    _label.backgroundColor = color;
    if ([color isEqual:[UIColor whiteColor]]) {
        _label.textColor = OXColor(0x999999);
    }else{
    
        _label.textColor = [UIColor whiteColor];
    }
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont boldSystemFontOfSize:15];
    _label.numberOfLines = 2;
    _label.text = text;
    _label.layer.masksToBounds = YES;
    _label.layer.cornerRadius = smallW / 2;
    [self addSubview:_label];
    
}


@end
