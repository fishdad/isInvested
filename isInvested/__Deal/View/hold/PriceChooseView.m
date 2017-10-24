//
//  PriceChooseView.m
//  isInvested
//
//  Created by Ben on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "PriceChooseView.h"
#import "UILabel+TextWidhtHeight.h"

@interface PriceChooseView ()
@property (nonatomic, copy) void (^RigntLblFrameBlock)();//右侧的lbl显示动画
@end

@implementation PriceChooseView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setPrecision:(NSInteger)precision{

    _stepper.Precision = precision;
    [_stepper setMaxValue:0 min:0 now:0 Precision:precision];
}

-(void)setUpView{
    

    CGFloat W = [UILabel getWidthWithTitle:@"四个汉字" font:FONT(15)];
    CGFloat lLblW = [UILabel getWidthWithTitle:@"三个字" font:FONT(13)];
    CGFloat spacing = 10;
    CGFloat btnw = (W - lLblW);
    CGFloat RLblW = 55;//右侧的统一长度
    CGFloat H = 30;
    CGFloat stepperW = (WIDTH - 2 * spacing - W - 55);
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(-1, 0, H, H);
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
    
    
    _leftLbl = [[UILabel alloc] init];
    _leftLbl.frame = CGRectMake(spacing + btnw, 0, lLblW, H);
    _leftLbl.font = FONT(13);
    [self addSubview:_leftLbl];
    
    _rightLbl = [[UILabel alloc] init];
    _rightLbl.frame = CGRectMake((WIDTH - RLblW) / 2.0, 0, RLblW, H);
    WEAK_SELF
    //动画显示
    self.RigntLblFrameBlock = ^(){
        weakSelf.rightLbl.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.rightLbl.frame = CGRectMake((WIDTH - RLblW), 0, RLblW, H);
        }];
    };
     _rightLbl.font = FONT(11);

    _stepper = [[XBStepper alloc] initWithFrame:CGRectMake(NW(_leftLbl) + spacing, 0, stepperW, H)];
    [_stepper setMaxValue:0 min:0 now:0 Precision:_precision];
    [_stepper setBackgroundColor:[UIColor whiteColor] BorderColor:[UIColor lightGrayColor] BtnTextColor:OrangeBackColor];
    [self addSubview:_stepper];
    [self addSubview:_rightLbl];
    //设置初始状态
    _btn.selected = NO;
    [self setBtnStatus:_btn];

}

-(void)setBtnStatus:(UIButton *)btn{

    if (btn.selected) {
        [btn setImage:[Util OriginImage:[UIImage imageNamed:@"deal_stopChoose"] scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
        _stepper.userInteractionEnabled = YES;
        [_stepper setBackgroundColor:[UIColor whiteColor] BorderColor:[UIColor lightGrayColor] BtnTextColor:OrangeBackColor];
        _stepper.txtCount.textColor = [UIColor blackColor];
        WEAK_SELF
        _stepper.textShouldBeginWriteBlock = ^(){
            weakSelf.RigntLblFrameBlock();
        };
        _isSelected = YES;
    }else{
        
        [btn setImage:[Util OriginImage:[UIImage imageNamed:@"deal_stopNoChoose"] scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
        _stepper.userInteractionEnabled = NO;
        _stepper.txtCount.text = @"";
        [_stepper setBackgroundColor:[UIColor whiteColor] BorderColor:[UIColor lightGrayColor] BtnTextColor:[UIColor lightGrayColor]];
         _stepper.txtCount.textColor = OXColor(0x999999);
        _rightLbl.hidden = YES;
        CGFloat RLblW = 55;
        CGFloat H = 30;
        _rightLbl.frame = CGRectMake((WIDTH - RLblW) / 2.0, 0, RLblW, H);
        _isSelected = NO;
    }
}

-(void)btnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;

    [self setBtnStatus:btn];
}
//取消选择
-(void)cancelSelected{

    _btn.selected = NO;
    [_btn setImage:[Util OriginImage:[UIImage imageNamed:@"deal_stopNoChoose"] scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
    _stepper.userInteractionEnabled = NO;
    [_stepper setBackgroundColor:[UIColor whiteColor] BorderColor:[UIColor lightGrayColor] BtnTextColor:[UIColor lightGrayColor]];
    _stepper.txtCount.textColor = OXColor(0x999999);
//    _stepper.txtCount.text = @"";
//    _stepper.txtCount.placeholder = @"价格";
    _rightLbl.hidden = YES;
    _isSelected = NO;
}

@end
