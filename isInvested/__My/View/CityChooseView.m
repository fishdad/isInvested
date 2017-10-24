//
//  CityChooseView.m
//  isInvested
//
//  Created by Ben on 16/11/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CityChooseView.h"

@interface CityChooseView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{

    NSDictionary *areaDic;//地址
    NSMutableArray *province;  //省
    NSMutableArray *city;      //市
     
    NSString *selectedProvince;//进来默认的省地址

    NSString *p;//选择的省
    NSString *c;//选择的市
}

@end

@implementation CityChooseView{

    __weak CityChooseView *mySelf;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    mySelf = self;
    if (mySelf) {
        [mySelf addSubviews];
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
        areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        //获取到字典中所有的key
        NSArray *components = [areaDic allKeys];
        
        //重新排序key
        NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            //比较key的大小
            if ([obj1 integerValue] > [obj2 integerValue])
            {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue])
            {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        province = [NSMutableArray array];
        for (int i=0; i<[sortedArray count]; i++)
        {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *tmp = [[areaDic objectForKey: index]  allKeys];
            [province addObject: [tmp objectAtIndex:0]];
        }
        
        //默认选择的是第一个
        NSString *index = [sortedArray objectAtIndex:0];
        NSString *selected = [province objectAtIndex:0];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
        
        NSArray *cityArray = [dic allKeys];
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
        city = [[NSMutableArray alloc] initWithArray: [cityDic allKeys]];
        selectedProvince = [province objectAtIndex: 0];
        //强制刷新回去
        [_pickView selectRow:0 inComponent:0 animated:YES];
        [_pickView selectRow:0 inComponent:1 animated:YES];

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
    label.text = @"请选择开户地";
    label.textAlignment = NSTextAlignmentCenter;
    [mySelf addSubview:label];
    [mySelf addSubview:[Util setUpLineWithFrame:CGRectMake(0, height(self) - 216 + 44, WIDTH, 0.5)]];
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
            
            if (p == nil) {
                p = province[0];
            }
            if (c == nil) {
                c = city[0];
            }
            self.chooseIndexBlock(p,c);
        }
        
        [mySelf disMiss];
    } else {
        [mySelf disMiss];
    }
}
-(void)viewTouch{
    
    [mySelf disMiss];
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



#pragma mark- Picker Delegate Methods
//返回几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
    
}
//每一列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [province count];
    }else{
        return [city count];
    }
}
//每一列每一行显示的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [province objectAtIndex: row];
    }
    else
    {
        return [city objectAtIndex: row];
    }
}
//每列的高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return (30);
}
//每一列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return  WIDTH * 0.5;
    }
    else
    {
        return   WIDTH * 0.5;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue])
            {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue])
            {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < [sortedArray count]; i++)
        {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        city = [[NSMutableArray alloc] initWithArray: array];
        
        //滑动第0列 相应第1列和第2列
        [pickerView selectRow: 0 inComponent: 1 animated: YES];
        [pickerView reloadComponent: 1];
        
        
        p = province[row];
        c = city[0];
        
        LOG(@"选中--%@ %@",p,c);
        
    }
    else if (component == 1)
    {
        c = city[row];
        LOG(@"选中--%@ %@",p,c);
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == 0)
    {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  WIDTH * 0.5,  (30))];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
        
    }
    else if (component == 1)
    {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  WIDTH * 0.5,  (30))];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
        
    }

    return myView;
}

@end
