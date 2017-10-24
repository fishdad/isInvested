//
//  KMPopView.m
//  MakerMap
//
//  Created by kevin on 16/3/26.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "KMPopView.h"
#define ScreenBounds    [UIScreen mainScreen].bounds                         //返回屏幕Bounds
#define ScreenOrigin    ScreenBounds.origin                                 //返回屏幕原点
#define ScreenSize      ScreenBounds.size                                   //返回屏幕尺寸
#define ScreenOriginX   ScreenOrigin.x                                      //返回屏幕原点坐标X
#define ScreenOriginY   ScreenOrigin.y                                      //返回屏幕原点坐标Y
#define ScreenWidth     ScreenSize.width                                    //返回屏幕宽度
#define ScreenHeight    ScreenSize.height                                   //返回屏幕高度



@interface KMPopView()<UIGestureRecognizerDelegate>

@property (nonatomic,copy)PopViewBlock popBlock;


@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BuyOrderType type;//订单类型
@property (nonatomic, assign) PriceOrderType priceType;//市价指价类型
@property (nonatomic, strong) NSArray *detailLabels;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIImageView *typeImgView;
@property (nonatomic, strong) UITapGestureRecognizer *cancelTap;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat popWidth;

@end

@implementation KMPopView

-(void)dealloc{

    LOG(@"KMPopView~~~销毁");
}

- (instancetype)init
{
    @throw  [NSException exceptionWithName:@"Use initSuperWithBlock" reason:@"" userInfo:nil];
    
    return nil;
}
- (instancetype)initSuperWithPriceType:(PriceOrderType)priceType Block:(PopViewBlock)block DetailTitleLabels:(NSArray *)detailTitleLabels DetailValueLabels:(NSArray *)detailValueLabels
{
    if (self = [super init]) {
        if (block) {
            _popBlock = block;
        }
        if (ScreenWidth > 320) {
            _popWidth = (ScreenWidth - 100);
        }else{
            _popWidth = (ScreenWidth - 50);
        }
    
        self.frame = CGRectMake(0, 0, ScreenWidth , ScreenHeight);
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0];
        
#pragma mark -- 设置位置
        CGFloat titleLabelH = 35;
        CGFloat labelX = 15;
        CGFloat labelW = (_popWidth - labelX * 2);
        CGFloat labelH = 25;
        
        _popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _popWidth, 5 + titleLabelH + labelH * detailTitleLabels.count + 40 + 10)];
        _popView.backgroundColor = [UIColor whiteColor];
        _popView.clipsToBounds = YES;
        _popView.layer.cornerRadius = 3;
        [self addSubview:_popView];
        
        //类型图标
        _typeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_popView addSubview:_typeImgView];
        
        //标题
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5,_popWidth, titleLabelH)];
        _titleLabel.textColor = OXColor(0x333333);
        _titleLabel.font = FONT(17);
        _titleLabel.textAlignment = 1;
        [_popView  addSubview:_titleLabel];
        
        //详细子标题
        CGFloat count = detailTitleLabels.count;
        for (int i = 0; i < count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, 5 + titleLabelH + i * labelH,labelW, labelH)];
            NSString *threeString = @"";
            UIColor *threeColor = [UIColor whiteColor];
            if ((priceType == PriceOrderTypeMarket) && (i == 0)) {
                threeString = @" (以成交时报价为准)";
                threeColor = RedBackColor;
            }
            label.textAlignment = NSTextAlignmentLeft;
            UIFont *font = FONT(15);
            if (WIDTH <= 320) {
                font = FONT(14);
            }
            label.attributedText = [Util setFirstString:detailTitleLabels[i] secondString:detailValueLabels[i] threeString:threeString firsColor:OXColor(0x999999) secondColor:OXColor(0x666666) threeColor:threeColor firstFont:font secondFont:font threeFont:FONT(13)];
            [label sizeToFit];
            [_popView  addSubview:label];
        }
        
        CGFloat y = 5 + titleLabelH + labelH *detailTitleLabels.count + 10;
       
        //取消按钮
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, y, _popWidth * 0.4, 40);
        [_cancelBtn addTarget:self action:@selector(clickBtn:)
             forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = OXColor(0xe6e6e6);
        _cancelBtn.alpha = 0.7;
        _cancelBtn.tag = 0;
        [_popView addSubview:_cancelBtn];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(_cancelBtn.width, y, 1, 40)];
        line2.backgroundColor = [UIColor grayColor];
        [_popView addSubview:line2];
        
        //操作按钮
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(_cancelBtn.width,y, _popWidth * 0.6, 40);
         _sureBtn.tag = 1;
        [_sureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_popView addSubview:_sureBtn];
        
        _cancelBtn.showsTouchWhenHighlighted = YES;
        _sureBtn.showsTouchWhenHighlighted = YES;
//        //取消手势(此处暂时不需要)
//        _cancelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
//        _cancelTap.delegate = self;
//        [self addGestureRecognizer:_cancelTap];
        
        
    }
    return self;
}
- (void)resetType:(BuyOrderType) type PriceType:(PriceOrderType)priceType Title:(NSString *)title sureBtn:(NSString *)suerStr cancel:(NSString *)cancelStr canTapCancel:(BOOL)canTap
{
    
    if (type == BuyOrderTypeUp) {//涨
        _color = RedBackColor;
    }else if (type == BuyOrderTypeDown){//跌
    
        _color = GreenBackColor;
    }else if (type == BuyOrderTypeLevel){//平仓
        
        _color = OrangeBackColor;
    }
    _sureBtn.backgroundColor = _color;
//    _typeImgView.backgroundColor = _color;
    _typeImgView.image = [Util getImgbyType:type PriceType:priceType];
    
    _titleLabel.text = title;
    
    [_sureBtn setTitle:suerStr forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [_cancelBtn setTitle:cancelStr forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
    _popView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);

    if (!canTap) {
        [self removeGestureRecognizer:_cancelTap];
    }
}
//0:SURE,1:CANCEL
+ (KMPopView *)popWithType:(BuyOrderType) type PriceType:(PriceOrderType)priceType Title:(NSString *)title DetailTitleLabels:(NSArray *)detailTitleLabels DetailValueLabels:(NSArray *)detailValueLabels sureBtn:(NSString *)suerStr cancel:(NSString *)cancelStr block:(void(^)(NSInteger index))block canTapCancel:(BOOL)canTap

{
    
    KMPopView *view = [[KMPopView alloc]initSuperWithPriceType:priceType Block:block DetailTitleLabels:detailTitleLabels DetailValueLabels:detailValueLabels];
    
    [view resetType:type PriceType:priceType Title:title sureBtn:suerStr cancel:cancelStr canTapCancel:canTap];
    
    return view;
}
-(void)tappedCancel
{
    [self removeFromSuperview];
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
        _popBlock(btn.tag);
    }
    [self tappedCancel];
}
#pragma mark - show

- (void)show
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
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
