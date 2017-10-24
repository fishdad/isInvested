//
//  ViewController.m
//  XBStepper
//
//  Created by Peter Jin mail:i@Jxb.name on 15/5/12.
//  Github ---- https://github.com/JxbSir
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "XBStepper.h"

@interface XBStepper ()<UITextFieldDelegate>

@property(nonatomic,copy)UIColor        *myBorderColor;
@property(nonatomic,copy)UIColor        *myTextColor;

@property(nonatomic,assign)NSInteger    valueMax;
@property(nonatomic,assign)NSInteger    valueMin;
//@property(nonatomic,assign)float    valueNow;

@property(nonatomic,strong)UIView       *vLineFront;
@property(nonatomic,strong)UIView       *vLineBack;

@property(nonatomic,strong)UIButton     *btnDecrease;
@property(nonatomic,strong)UIButton     *btnIncrease;
@end

@implementation XBStepper

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUIs];
        
        [self reloadStepper];
    }
    return self;
}

/**
 *  设置UI
 */
- (void)initUIs {
    _myBorderColor = [UIColor redColor];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    [self AddUIs];
}

/**
 *  添加UI控件
 */
- (void)AddUIs {
    
    CGFloat btnW = self.frame.size.height + 5;
    
    _txtCount = [[UITextField alloc] initWithFrame:CGRectMake(btnW -  0.5, 0, self.frame.size.width - 2 * btnW + 1.5, self.frame.size.height)];
    _txtCount.textColor = _myTextColor;
    _txtCount.delegate = self;
    _txtCount.font = [UIFont systemFontOfSize:16];
    _txtCount.textAlignment = NSTextAlignmentCenter;

    [self addSubview:_txtCount];
    
    _btnDecrease = [self tempButton:CGRectMake(0, 0, btnW, self.frame.size.height) title:@"－"];
    [_btnDecrease addTarget:self action:@selector(btnActionDecease) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnDecrease];
    
    _btnIncrease = [self tempButton:CGRectMake(self.frame.size.width - self.frame.size.height - 4.5, 0, btnW, self.frame.size.height) title:@"＋"];
    [_btnIncrease addTarget:self action:@selector(btnActionIncease) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnIncrease];
}

/**
 *  创建按钮
 */
- (UIButton*)tempButton:(CGRect)frame title:(NSString*)title {
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.frame = btn.frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:_myTextColor forState:UIControlStateNormal];
//    btn.backgroundColor = OXColor(0xf5f5f5);
    btn.layer.borderColor = OXColor(0xd4d4d4).CGColor;
    btn.layer.borderWidth = 0.5;
    return btn;
}

/**
 *  加载数据
 */
- (void)reloadStepper {
    [_btnIncrease setTitleColor:_myTextColor forState:UIControlStateNormal];
    [_btnDecrease setTitleColor:_myTextColor forState:UIControlStateNormal];
//    if (_txtCount.text.floatValue >= _valueMax) {
//        _txtCount.text = [NSString stringWithFormat:@"%.2f",_valueMax];
//        [_btnIncrease setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    }
    if (_txtCount.text.floatValue <= _valueMin) {
        [self getValue:_valueMin ByPrecision:_Precision];
        [_btnDecrease setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - 加减事件
-(CGFloat)getNextValueBy:(CGFloat)value Type:(NSString *)type Precision:(NSInteger)precision{

    CGFloat nextValue;
    if (_Precision == 0) {//整数位
        if ([type isEqualToString:@"＋"]) {
            nextValue = value + 1;
        }else{
            nextValue = value - 1;
        }
    }else{
    //保留两位小数
        if ([type isEqualToString:@"＋"]) {
            nextValue = value + 0.01;
        }else{
            nextValue = value - 0.01;
        }
    }
    return nextValue;
}

- (void)btnActionDecease {

    CGFloat valueNow = _txtCount.text.floatValue;
    valueNow = [self getNextValueBy:valueNow Type:@"－" Precision:_Precision];
    [self getValue:valueNow ByPrecision:_Precision];
    [self reloadStepper];
    if (self.textShouldBeginWriteBlock) {
        self.textShouldBeginWriteBlock();
    }
    if (self.textDidEndEditingBlock) {
        self.textDidEndEditingBlock(_txtCount.text);
    }
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}

- (void)btnActionIncease {
    CGFloat valueNow = _txtCount.text.floatValue;
    valueNow = [self getNextValueBy:valueNow Type:@"＋" Precision:_Precision];
    [self getValue:valueNow ByPrecision:_Precision];
    [self reloadStepper];
    if (self.textShouldBeginWriteBlock) {
        self.textShouldBeginWriteBlock();
    }
    if (self.textDidEndEditingBlock) {
        self.textDidEndEditingBlock(_txtCount.text);
    }
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}

#pragma mark - 对外函数
- (void)setBackgroundColor:(UIColor *)backgroundColor BorderColor:(UIColor*)borderColor BtnTextColor:(UIColor*)textColor {
    borderColor = OXColor(0xd4d4d4);
    _myBorderColor = borderColor;
    _myTextColor = textColor;
    self.layer.borderColor          = borderColor.CGColor;
    self.vLineFront.backgroundColor = backgroundColor;
    self.vLineBack.backgroundColor  = backgroundColor;
    
    _txtCount.textColor = [UIColor blackColor];
    _txtCount.layer.borderColor = [borderColor CGColor];
    _txtCount.layer.borderWidth = 0.5;
//    _txtCount.clearsOnBeginEditing = YES; //开始编辑时清空数据
    [_txtCount addTarget:self action:@selector(textChangeAction:)forControlEvents:UIControlEventEditingChanged];
    
    [_btnDecrease setTitleColor:textColor forState:UIControlStateNormal];
    [_btnIncrease setTitleColor:textColor forState:UIControlStateNormal];
}

-(void)getValue:(CGFloat) value ByPrecision:(NSInteger) precision{

    NSString *str;
    if (precision == 0) {
        str = [NSString stringWithFormat:@"%.0f",value];
        _txtCount.keyboardType = UIKeyboardTypeNumberPad;//根据实际情况选择使用时带小数点还是不带小数点
    }else{
        str = [NSString stringWithFormat:@"%.2f",value];
        _txtCount.keyboardType = UIKeyboardTypeDecimalPad;//根据实际情况选择使用时带小数点还是不带小数点
    }
    
    if (value == 0) {
        _txtCount.text = @"";
        _txtCount.placeholder = str;
    }else{
        _txtCount.text = str;
    }
}

- (void)setMaxValue:(CGFloat)max min:(CGFloat)min now:(CGFloat)now Precision:(NSInteger) precision{
   
    //_valueMax = max;
    _valueMin = min;
    _Precision = precision;
//    if (now == 0) {
//        _txtCount.text = @"";
//         _txtCount.placeholder = [self getValue:now ByPrecision:precision];
//    }
    [self reloadStepper];
}

//手动填写时候的处理
-(void)textFieldDidEndEditing:(UITextField *)textField{

//    if ([textField.text floatValue] > _valueMax) {
//        NSLog(@"超出最大范围");
//        textField.text = [NSString stringWithFormat:@"%.2f",_valueMax];
//    }   
    if ([textField.text integerValue] < _valueMin) {
        NSLog(@"超出最小范围");
        [self getValue:_valueMin ByPrecision:_Precision];
    }
}

- (void) textChangeAction:(UITextField *) textField {
    
    if (self.textDidEndEditingBlock) {
        self.textDidEndEditingBlock(textField.text);
    }

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.textShouldBeginWriteBlock) {
        self.textShouldBeginWriteBlock();
    }
    return YES;
}

- (void) textFieldDidBeginEditing: (UITextField *) textField {
    
    [textField performSelector:@selector(selectAll:) withObject: textField];
    [[UIMenuController sharedMenuController] setMenuVisible: YES animated: YES];
}

//限制小数点的位数 xinle
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = 2;//小数点后需要限制的个数
    for (NSInteger i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
}


@end
