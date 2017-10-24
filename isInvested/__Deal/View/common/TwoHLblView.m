//
//  TwoHLblView.m
//  isInvested
//
//  Created by Ben on 16/9/26.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "TwoHLblView.h"

@implementation TwoHLblView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height;
        
        _TitleLbl = [[UILabel alloc] init];
        _TitleLbl.frame = CGRectMake(10,0, w / 2.0 - 10, h);
        _TitleLbl.textColor = OXColor(0x333333);
        _TitleLbl.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_TitleLbl];
        
        _ValueLbl = [[UILabel alloc] init];
        _ValueLbl.frame = CGRectMake(w / 2.0, 0, w / 2.0 - 10, h);
        _ValueLbl.textColor = OXColor(0x666666);
        _ValueLbl.textAlignment = NSTextAlignmentRight;
        _ValueLbl.text = @"";
        [self addSubview:_ValueLbl];
        
    }
    return self;
}

@end
