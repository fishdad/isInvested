//
//  KMBottomPopView.m
//  PopView
//
//  Created by Ben on 16/8/9.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "KMBottomPopView.h"
#import "XBStepper.h"

#define ScreenBounds    [UIScreen mainScreen].bounds                         //返回屏幕Bounds
#define ScreenOrigin    ScreenBounds.origin                                 //返回屏幕原点
#define ScreenSize      ScreenBounds.size                                   //返回屏幕尺寸
#define ScreenOriginX   ScreenOrigin.x                                      //返回屏幕原点坐标X
#define ScreenOriginY   ScreenOrigin.y                                      //返回屏幕原点坐标Y
#define ScreenWidth     ScreenSize.width                                    //返回屏幕宽度
#define ScreenHeight    ScreenSize.height                                   //返回屏幕高度

@interface KMBottomPopView()<UIGestureRecognizerDelegate>

@property (nonatomic,copy)PopBottomViewBlock popBlock;
@property (nonatomic,strong)UIView *popView;
@property (nonatomic,assign)NSInteger type;//类型
@property (nonatomic,strong)UIButton *sureBtn;
@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)XBStepper* stepper1;
@property (nonatomic,strong)XBStepper* stepper2;

@property (nonatomic,strong)UIImageView *typeImgView;

@property (nonatomic,strong)UITapGestureRecognizer *cancelTap;


@end


@implementation KMBottomPopView

#define popWidth (ScreenWidth)

- (instancetype)init
{
    @throw  [NSException exceptionWithName:@"Use initSuperWithBlock" reason:@"" userInfo:nil];
    
    return nil;
}
- (instancetype)initSuperWithBlock:(PopBottomViewBlock)block
{
    if (self = [super init]) {
        if (block) {
            _popBlock = block;
        }
        
        self.frame = CGRectMake(0, 0, ScreenWidth , ScreenHeight);
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0];
        
        CGFloat popHeight = 250;
        
        _popView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - popHeight, popWidth, popHeight)];
        
        _popView.backgroundColor = [UIColor whiteColor];
        _popView.clipsToBounds = YES;
        
//        _popView.layer.cornerRadius = 5;
        
        [self addSubview:_popView];
        
        //类型图标
        _typeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 30)];
        [_popView addSubview:_typeImgView];
        
        
        //计数器1
        _stepper1 = [[XBStepper alloc] initWithFrame:CGRectMake(10, 40, 200, 40)];
        [_stepper1 setMaxValue:0 min:0 now:0 Precision:0];
        [_stepper1 setBackgroundColor:[UIColor whiteColor] BorderColor:[UIColor lightGrayColor] BtnTextColor:OrangeBackColor];
        [_popView addSubview:_stepper1];
        
        //计数器2
        _stepper2 = [[XBStepper alloc] initWithFrame:CGRectMake(10, 90, 200, 40)];
        [_stepper2 setMaxValue:0 min:0 now:0 Precision:0];
        [_stepper2 setBackgroundColor:[UIColor whiteColor] BorderColor:[UIColor lightGrayColor] BtnTextColor:OrangeBackColor];
        [_popView addSubview:_stepper2];

        
         CGFloat y = _popView.height - 40;
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,y, ScreenWidth, 1)];
        line1.backgroundColor = [UIColor grayColor];
        [_popView addSubview:line1];
    
        //取消按钮
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, y, popWidth * 0.4, 40);
        [_cancelBtn addTarget:self action:@selector(clickBtn:)
             forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.tag = 0;
        [_popView addSubview:_cancelBtn];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(_cancelBtn.width, y, 1, 40)];
        line2.backgroundColor = [UIColor grayColor];
        [_popView addSubview:line2];
        
        //操作按钮
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(_cancelBtn.width,y, popWidth * 0.6, 40);
        _sureBtn.tag = 1;
        [_sureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_popView addSubview:_sureBtn];
        
        
        
        //取消手势
        _cancelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        _cancelTap.delegate = self;
        [self addGestureRecognizer:_cancelTap];
        
        
    }
    return self;
}
- (void)resetType:(PopBottomType) type Title:(NSString *)title DetailLabels:(NSArray *)detailLabels sureBtn:(NSString *)suerStr cancel:(NSString *)cancelStr canTapCancel:(BOOL)canTap
{
    
    if (type == PopBottomTypeAdd) {//涨
        _typeImgView.backgroundColor = RedBackColor;
    }else if (type == PopBottomTypeDel){//跌
        
        _typeImgView.backgroundColor = GreenBackColor;
    }else if (type == PopBottomTypeLevel){//平仓
        
        _typeImgView.backgroundColor = OrangeBackColor;
    }
    
    
    [_sureBtn setTitle:suerStr forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [_cancelBtn setTitle:cancelStr forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    
    if (!canTap) {
        [self removeGestureRecognizer:_cancelTap];
    }
}
//0:SURE,1:CANCEL
//+ (KMBottomPopView *)popWithType:(PopBottomType) type Title:(NSString *)title DetailLabels:(NSArray *)detailLabels sureBtn:(NSString *)suerStr cancel:(NSString *)cancelStr block:(void(^)(NSInteger index))block canTapCancel:(BOOL)canTap

+ (KMBottomPopView *)popWithTarget:(UIViewController *) target Type:(PopBottomType) type Title:(NSString *)title DetailLabels:(NSArray *)detailLabels sureBtn:(NSString *)suerStr cancel:(NSString *)cancelStr block:(PopBottomViewBlock)block canTapCancel:(BOOL)canTap
{
    
    KMBottomPopView *view = [[KMBottomPopView alloc]initSuperWithBlock:block];
    
    [view resetType:type Title:title DetailLabels:detailLabels sureBtn:suerStr cancel:cancelStr canTapCancel:canTap];
    
    view.target = target;
    
    return view;
}
-(void)tappedCancel
{
    
    [UIView animateWithDuration:0.7f delay:0.f usingSpringWithDamping:.5f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _popView.transform = CGAffineTransformMakeScale(.8f, .8f);
        _popView.alpha = 0;
        _sureBtn.alpha = 0;
        _cancelBtn.alpha = 0;
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]){
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)clickBtn:(UIButton *)btn
{
    if (_popBlock) {
  
#pragma mark -- block 传值内容
        NSArray *arr = @[_stepper1.txtCount.text,_stepper2.txtCount.text];
        _popBlock(btn.tag,arr);
    }
    [self tappedCancel];
}
#pragma mark - show

- (void)show
{
    //添加到window上
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    //添加到控制器上
    [_target.view addSubview:self];
    _popView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    _popView.alpha = 0;
    
    [UIView animateWithDuration:0.5f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _popView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _sureBtn.alpha = 1;
        _cancelBtn.alpha = 1;
        _popView.alpha = 1.0;
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
    } completion:nil];
}


@end
