//
//  ChooseTimeView.m
//  isInvested
//
//  Created by Ben on 16/9/20.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ChooseTimeView.h"
#import "DatePickChooseView.h"

@implementation ChooseTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
       
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
         backView.alpha = 0.8;
        backView.backgroundColor = [UIColor blackColor];
        [self addSubview:backView];
        
        [self setUpSubViews];
    }
    return self;
}

-(void)setUpSubViews{
    
    _lbl = [[UILabel alloc] init];
    _lbl.textColor = [UIColor whiteColor];
    _lbl.textAlignment = NSTextAlignmentLeft;
    
    if (WIDTH <= 320) {
        _lbl.font = FONT(15);
    }
   
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"查询历史记录" forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(12);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    btn.backgroundColor = OXColor(0xec6a00);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btn = btn;
    
   

    CGFloat space = 15;
    CGFloat lblH = 30;
    CGFloat btnw = 80;
    CGFloat lblW = WIDTH - 15 - 15 - 10 - btnw;
    _lbl.frame = CGRectMake(space, (self.height - lblH) / 2.0, lblW, lblH);
    _btn.frame = CGRectMake(NW(_lbl) + 10, _lbl.y, btnw, lblH);
    
    [self addSubview:_lbl];
    [self addSubview:_btn];

}
-(void)btnClick:(UIButton *)btn{

    WEAK_SELF
    DatePickChooseView *view = [[DatePickChooseView alloc] initWithFrame:[Util appWindow].bounds];
    view.outOfDays = weakSelf.outOfDays;
    view.dateBlock = ^(NSString *dateStr,NSString *dateStrBegin,NSString *dateStrEnd){
        weakSelf.lbl.text = dateStr;
        NSString *beginDate = [NSString stringWithFormat:@"%@ 00:00:00",dateStrBegin];
        NSString *endDate = [NSString stringWithFormat:@"%@ 23:59:59",dateStrEnd];
        
        long long llBeginDate = [[Util dateToUTCWithDate:beginDate] longLongValue];
        long long llEndDate = [[Util dateToUTCWithDate:endDate] longLongValue];
        if (weakSelf.btnBlock) {
            weakSelf.btnBlock(llBeginDate,llEndDate);
        }
    };
    UIViewController *vc = [[UIViewController alloc] init];
    view.target = vc;
    vc.view = view;
    [[Util appWindow] addSubview:vc.view];
}

@end
