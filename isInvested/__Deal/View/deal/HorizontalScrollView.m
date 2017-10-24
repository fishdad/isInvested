//
//  HorizontalScrollView.m
//  isInvested
//
//  Created by Ben on 16/9/9.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "HorizontalScrollView.h"

@interface HorizontalScrollView ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIScrollView *scrowView;
@property (nonatomic, assign) CGFloat btnW;
@property (nonatomic, strong) NSString *nowString;

@end

@implementation HorizontalScrollView

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)items NowString:(NSString *)nowString
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"deal_unitBack"];
        self.image = image;
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        _nowString = nowString;
        CGFloat count = items.count;
        _scrowView = [[UIScrollView alloc] initWithFrame:self.bounds];
        if (items.count <= 4) {
            _btnW = self.frame.size.width / count;
        }else{
            _btnW = 50;
        }
        _scrowView.contentSize = CGSizeMake(_btnW * count, 0);
        [self addSubview:_scrowView];
        
        _items = items;        
        [self setUpItems];
    }
    return self;
}

-(void)setUpItems{

    CGFloat btnH = 30;
    
    CGFloat count = _items.count;
    for (int i = 0; i < count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(_btnW * i, 5 , _btnW, btnH);
        [btn setTitle:[NSString stringWithFormat:@"%@kg",_items[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if ([_nowString isEqualToString:[NSString stringWithFormat:@"X%@kg",_items[i]]]) {
            [btn setTitleColor:OrangeBackColor forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = FONT(14);
        [_scrowView addSubview:btn];
        
        CGFloat lblH = 20;
        CGFloat lblY = (self.height - lblH) / 2 + 3;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(_btnW * i - 1, lblY, 1, lblH - 3);
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];

    }
}

-(void)btnClick:(UIButton *)btn{
    
    if (self.chooseBlock != nil) {
        self.chooseBlock(btn.tag);
    }
    
    [NSUserDefaults setBool:NO forKey:@"UnitChoose"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnitTransForm" object:nil];
    [self removeFromSuperview];
}

-(void)dealloc{

    LOG(@"HorizontalScrollView销毁了~~");
}

@end
