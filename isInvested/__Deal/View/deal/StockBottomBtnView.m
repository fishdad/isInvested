//
//  StockBottomBtnView.m
//  isInvested
//
//  Created by Tom on 16/8/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "StockBottomBtnView.h"

@implementation StockBottomBtnView{
    __weak StockBottomBtnView *mySelf;
}

-(void)dealloc{

    LOG(@"StockBottomBtnView~~~~~销毁");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    mySelf = self;
    if (mySelf) {
        [mySelf addSubviews];
    }
    return mySelf;
}
 - (void)addSubviews
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouch)];
    [view addGestureRecognizer:touch];
    [mySelf addSubview:view];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, height(self) - 216, WIDTH, 216)];
    view1.backgroundColor = [UIColor whiteColor];
    [mySelf addSubview:view1];

    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, HEIGHT - 216, WIDTH, 216)];
    _pickView.delegate = (id)mySelf;
    _pickView.dataSource = mySelf;
    [mySelf addSubview:_pickView];
    LOG(@"***%ld" , _count);
    
    [mySelf initButtonWithName:@"取消" AndX:0];
    [mySelf initButtonWithName:@"确定" AndX:WIDTH - 50];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake( (WIDTH - 150 ) / 2.0, HEIGHT - 216 , 150, 44);
    label.text = @"请选择商品";
    label.textAlignment = NSTextAlignmentCenter;
    [mySelf addSubview:label];
    [mySelf addSubview:[Util setUpLineWithFrame:CGRectMake(0, height(self) - 216 + 44, WIDTH, 0.5)]];
}

-(void)setArray:(NSArray *)array{

    _array = array;
    [_pickView reloadAllComponents];
}

-(void)setCount:(NSInteger)count{

    _count = count;
    [_pickView selectRow:count inComponent:0 animated:YES];
}
//创建单个的btn
- (void)initButtonWithName:(NSString *)name AndX:(CGFloat)x
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(x,  height(self) - 216, 50, 44);
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:OXColor(0x2672d1) forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:mySelf action:@selector(btnActionWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [mySelf addSubview:btn];
}
- (void)btnActionWithButton:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"确定"]) {
        
        LOG(@"选中行数%li",_count);
        
        if (self.chooseIndexBlock) {
            self.chooseIndexBlock(_count);
        }
        
        [mySelf disMiss];
    } else {
        [mySelf disMiss];
    }
}
//消失
- (void)disMiss{
    //动画效果淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(0, HEIGHT, 0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [mySelf removeFromSuperview];
            if (mySelf.dismiss) {
                mySelf.dismiss();
            }
        }
    }];
}

-(void)viewTouch{

    [mySelf disMiss];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _array.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, WIDTH, 30);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONT(16);
    label.text = _array[row];
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _count = row;
    if (_array.count == 0) {
        return;
    }
    LOG(@"~~~~%@",_array[row]);
}

@end
