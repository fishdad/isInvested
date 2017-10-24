//
//  NoDataView.m
//  isInvested
//
//  Created by Ben on 16/10/18.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView ()


@end

@implementation NoDataView

-(void)dealloc{

    LOG(@"NoDataView~~~~~销毁");
}

+(NoDataView *)defaultNoDataView{

    NoDataView *view = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"null_data"]];
        _imgView.userInteractionEnabled = YES;
        _imgView.center = CGPointMake(WIDTH / 2, (HEIGHT - 64 - 37) / 2 - 100);
        [self addSubview:_imgView];
    }
    return self;
}

@end
