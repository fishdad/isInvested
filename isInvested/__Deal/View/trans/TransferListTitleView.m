//
//  TransferListTitleView.m
//  isInvested
//
//  Created by Ben on 16/9/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "TransferListTitleView.h"

@implementation TransferListTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpSubViews];
    }
    return self;
}

-(void)setUpSubViews{

    _timeLbl = [[UILabel alloc] init];
    _timeLbl.textAlignment = NSTextAlignmentLeft;
    _timeLbl.numberOfLines = 2;
    [self addSubview:_timeLbl];
    _typeLbl = [[UILabel alloc] init];
    _typeLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_typeLbl];
    _priceLbl = [[UILabel alloc] init];
    _priceLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_priceLbl];
    _statusLbl = [[UILabel alloc] init];
    _statusLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLbl];

    CGFloat space = 15;
    CGFloat shortW = 60;
    CGFloat longW = WIDTH / 2.0 - 60;
    _timeLbl.frame = CGRectMake(space, 0, longW - 15, self.height);
    _typeLbl.frame = CGRectMake(NW(_timeLbl), 0, shortW, self.height);
    _priceLbl.frame = CGRectMake(NW(_typeLbl), 0, longW, self.height);
    _statusLbl.frame = CGRectMake(NW(_priceLbl), 0, shortW - 15, self.height);
    
}

-(void)setType:(TranserType)type{

    if (type == TranserTypeIn) {
        _typeLbl.textColor = RedBackColor;
    }else{
        _typeLbl.textColor = GreenBackColor;
    }
}

-(void)setStatusType:(NSInteger)statusType{

    if (statusType == 0) {
        _statusLbl.textColor = [UIColor blackColor];
    }else{
        _statusLbl.textColor = OXColor(0x999999);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
