//
//  TwoVLblView.m
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "TwoVLblView.h"

@implementation TwoVLblView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height / 5.0;
        
        _TitleLbl = [[UILabel alloc] init];
        _TitleLbl.frame = CGRectMake(0, 10, w, h * 2 - 10);
        _TitleLbl.font = FONT(13);
        _TitleLbl.textColor = OXColor(0x999999);
        _TitleLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_TitleLbl];

        _ValueLbl = [[UILabel alloc] init];
        _ValueLbl.frame = CGRectMake(0, NH(_TitleLbl) + 10, w, h * 2 - 10);
        _ValueLbl.textColor = OXColor(0x333333);
        _ValueLbl.font = FONT(15);
        _ValueLbl.textAlignment = NSTextAlignmentCenter;
        _ValueLbl.text = @"--";
        [self addSubview:_ValueLbl];
        
    }
    return self;
}

-(void)setValue:(NSString *)value{

    _ValueLbl.text = value;
    if (value.floatValue >= 0) {
        _ValueLbl.textColor = RedBackColor;//红
    }else{
        _ValueLbl.textColor = GreenBackColor;//绿
    }
}

@end
