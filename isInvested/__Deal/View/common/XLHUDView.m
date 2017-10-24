//
//  XLHUDView.m
//  isInvested
//
//  Created by Ben on 2016/12/28.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "XLHUDView.h"

@interface XLHUDView ()
{
    UIView *_view1;
    UIView *_view2;
    UIView *_view3;
    UIView *_view4;
}
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation XLHUDView

#pragma mark -- 单利方法
+(instancetype)shareInstance{
    static XLHUDView *xlHUDView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xlHUDView = [[XLHUDView alloc] init];
    });
    return xlHUDView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        CGFloat w = 200;
        CGFloat h = 3 / 4.0 * w;
        _imgView =[[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - w) * 0.5, (HEIGHT - h) * 0.5, w, h)];
        [self addSubview:_imgView];
        
        
        CGFloat viewW = (WIDTH - w) * 0.5;
        CGFloat viewH = (HEIGHT - h) * 0.5;
        
        _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, viewH)];
        [self addSubview:_view1];
        _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, _imgView.y, viewW,h)];
        [self addSubview:_view2];
        _view3 = [[UIView alloc] initWithFrame:CGRectMake(_imgView.right,_imgView.y,viewW, h)];
        [self addSubview:_view3];
        _view4 = [[UIView alloc] initWithFrame:CGRectMake(0, _imgView.bottom, WIDTH, viewH)];
        [self addSubview:_view4];
        
        _view1.alpha = 0;
        _view2.alpha = 0;
        _view3.alpha = 0;
        _view4.alpha = 0;
    }
    return self;
}

-(void)show{

    [[Util appWindow] addSubview:self];
    WEAK_SELF
    __block int i = 1;
    [NSTimer scheduledTimerWithTimeInterval:(1 / 24.0) repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        weakSelf.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.tiff",i]];
        i ++;
        if (i == 63) {
            i = 1;
        }
    }];
}

-(void)hide{

    [self removeFromSuperview];
}

-(void)backViewWithAlpha:(CGFloat) alpha{
    
    _view1.backgroundColor = [UIColor blackColor];
    _view2.backgroundColor = [UIColor blackColor];
    _view3.backgroundColor = [UIColor blackColor];
    _view4.backgroundColor = [UIColor blackColor];
    
    _view1.alpha = alpha;
    _view2.alpha = alpha;
    _view3.alpha = alpha;
    _view4.alpha = alpha;
}


@end
