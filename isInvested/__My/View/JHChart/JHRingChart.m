//
//  JHRingChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/7/5.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHRingChart.h"

@interface JHRingChart ()

//环图间隔 单位为π
@property (nonatomic,assign)CGFloat itemsSpace;

//数值和
@property (nonatomic,assign) CGFloat totolCount;

@property (nonatomic,assign) CGFloat redius;

@property(nonatomic,strong)UILabel *titleLabel;

@end


@implementation JHRingChart



-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.chartOrigin = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)/2 - 25);
        _redius = (CGRectGetHeight(self.frame) -60*k_Width_Scale)/4;
    }
    return self;
}

-(void)setUpDetailTitles:(NSArray *)detailTitles andTitles:(NSString*) title{
    
    //环形中间的标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(0, 0, 60, 60);
    _titleLabel.center = self.chartOrigin;
    _titleLabel.numberOfLines = 2;
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = title;
    _titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_titleLabel];

    //字体的frame
    CGFloat h = 20;
    CGFloat w = 60;
    CGFloat x = (self.frame.size.width - 2 * h - 2 * w - 10) / 2.0;
    CGFloat y = (self.frame.size.height - 10 - h);
    
    //颜色块的frame
    CGFloat ColorH = 14;
    CGFloat ColorY = (self.frame.size.height - 10 - (h - ColorH) / 2.0 - ColorH);
    
    UILabel *label1C = [[UILabel alloc] init];
    label1C.frame = CGRectMake(x, ColorY, ColorH, ColorH);
    label1C.layer.masksToBounds = YES;
    label1C.layer.cornerRadius = ColorH * 0.5;
    label1C.backgroundColor = _k_COLOR_STOCK[1];
    [self addSubview:label1C];
    
    UILabel *label1T = [[UILabel alloc] init];
    label1T.frame = CGRectMake(label1C.frame.origin.x + label1C.frame.size.width + 5, y, w, h);
//    label1T.textAlignment = NSTextAlignmentCenter;
    label1T.text = detailTitles[1];
    label1T.font = [UIFont systemFontOfSize:15];
    label1T.textColor = [UIColor lightGrayColor];
    [self addSubview:label1T];
    
    //实际的显示值1
    UILabel *label1V = [[UILabel alloc] init];
    label1V.frame = CGRectMake(label1C.x, label1C.y - label1T.height, w, label1T.height);
    label1V.textColor = _k_COLOR_STOCK[1];
    label1V.font = FONT(13);
    label1V.text = [NSString stringWithFormat:@"%.0f%%",[_valueDataArr[1] doubleValue]];
    [self addSubview:label1V];
    
    UILabel *label2C = [[UILabel alloc] init];
    label2C.frame = CGRectMake(label1T.frame.origin.x + label1T.frame.size.width, ColorY, ColorH, ColorH);
    label2C.layer.masksToBounds = YES;
    label2C.layer.cornerRadius = ColorH * 0.5;
    label2C.backgroundColor = _k_COLOR_STOCK[0];
    [self addSubview:label2C];
    
    UILabel *label2T = [[UILabel alloc] init];
    label2T.frame = CGRectMake(label2C.frame.origin.x + label2C.frame.size.width + 5, y, w, h);
//    label2T.textAlignment = NSTextAlignmentCenter;
    label2T.text = detailTitles[0];
    label2T.font = [UIFont systemFontOfSize:15];
    label2T.textColor = [UIColor lightGrayColor];
    [self addSubview:label2T];

    //实际的显示值2
    UILabel *label2V = [[UILabel alloc] init];
    label2V.frame = CGRectMake(label2C.x, label2C.y - label2T.height, w, label2T.height);
    label2V.textColor = _k_COLOR_STOCK[0];
    label2V.font = FONT(13);
    label2V.text = [NSString stringWithFormat:@"%.0f%%",[_valueDataArr[0] doubleValue]];
    [self addSubview:label2V];
}

-(void)setValueDataArr:(NSArray *)valueDataArr{
    
    
    _valueDataArr = valueDataArr;
    
    [self configBaseData];
    
}

- (void)configBaseData{
    
    _totolCount = 0;
    //中间的间隔
    _itemsSpace =  (M_PI * 2.0 * 10 / 360)/_valueDataArr.count ;
    _itemsSpace =  0.0f;
    for (id obj in _valueDataArr) {
        
        _totolCount += [obj floatValue];
        
    }

}



//开始动画
- (void)showAnimation{
    
    /*        动画开始前，应当移除之前的layer         */
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    
    CGFloat lastBegin = -M_PI/2;
    
    CGFloat totloL = 0;
    NSInteger  i = 0;
    
    if ([_valueDataArr[0] intValue] == 0 && [_valueDataArr[1] intValue] == 0) {
        //如果两个值都是0的情况
        NSArray* valueDataArr = @[@"1",@"1"];
        CGFloat totolCount = [valueDataArr[0] intValue] + [valueDataArr[1] intValue];
        for (id obj in valueDataArr) {
            
            CAShapeLayer *layer = [CAShapeLayer layer] ;
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor =[OXColor(0xf4f4f4) CGColor];
            
            CGFloat cuttentpace = [obj floatValue] / totolCount * (M_PI * 2 - _itemsSpace * valueDataArr.count);
            totloL += [obj floatValue] / totolCount;
            
            [path addArcWithCenter:self.chartOrigin radius:_redius startAngle:lastBegin  endAngle:lastBegin  + cuttentpace clockwise:YES];
            
            layer.path = path.CGPath;
            [self.layer addSublayer:layer];
            layer.lineWidth = 60*k_Width_Scale;//环形条的宽度
            CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            basic.fromValue = @(0);
            basic.toValue = @(1);
            basic.duration = 0.5;
            basic.fillMode = kCAFillModeForwards;
            
            [layer addAnimation:basic forKey:@"basic"];
            lastBegin += (cuttentpace+_itemsSpace);
            i++;
        }
    }else{
        //正常的情况
        for (id obj in _valueDataArr) {
            
            CAShapeLayer *layer = [CAShapeLayer layer] ;
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor =[_k_COLOR_STOCK[i] CGColor];
            
            CGFloat cuttentpace = [obj floatValue] / _totolCount * (M_PI * 2 - _itemsSpace * _valueDataArr.count);
            totloL += [obj floatValue] / _totolCount;
            
            [path addArcWithCenter:self.chartOrigin radius:_redius startAngle:lastBegin  endAngle:lastBegin  + cuttentpace clockwise:YES];
            
            layer.path = path.CGPath;
            [self.layer addSublayer:layer];
            
            CGFloat r = 60*k_Width_Scale;
            if (WIDTH == 320) {
                r = 44 * k_Width_Scale;
            }
            layer.lineWidth = r;//环形条的宽度
            CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            basic.fromValue = @(0);
            basic.toValue = @(1);
            basic.duration = 0.5;
            basic.fillMode = kCAFillModeForwards;
            
            [layer addAnimation:basic forKey:@"basic"];
            lastBegin += (cuttentpace+_itemsSpace);
            i++;
        }
    }
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    CGFloat lastBegin = 0;
    CGFloat longLen = _redius + 15 *k_Width_Scale;
    
    if ([_valueDataArr[0] doubleValue] == 0 && [_valueDataArr[1] doubleValue] == 0) {
        //如果两个值都是0的情况
        NSArray* valueDataArr = @[@"1",@"1"];
        CGFloat totolCount = [valueDataArr[0] doubleValue] + [valueDataArr[1] doubleValue];
        for (NSInteger i = 0; i<valueDataArr.count; i++) {
            id obj = valueDataArr[i];
            CGFloat currentSpace = [obj floatValue] / totolCount * (M_PI * 2 - _itemsSpace * _valueDataArr.count);;
            CGFloat midSpace = lastBegin + currentSpace / 2;
            CGPoint begin = CGPointMake(self.chartOrigin.x + sin(midSpace) * _redius, self.chartOrigin.y - cos(midSpace)*_redius);
            CGPoint endx = CGPointMake(self.chartOrigin.x + sin(midSpace) * longLen, self.chartOrigin.y - cos(midSpace)*longLen);
            lastBegin += _itemsSpace + currentSpace;
            [self drawLineWithContext:contex andStarPoint:begin andEndPoint:endx andIsDottedLine:NO andColor:_k_COLOR_STOCK[i]];
            CGPoint secondP = CGPointZero;
            CGSize size = [[NSString stringWithFormat:@"%.0f%c",[@"0" floatValue] / totolCount * 100,'%'] boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25*k_Width_Scale]} context:nil].size;
            
            if (midSpace<M_PI) {
                secondP =CGPointMake(endx.x + 20*k_Width_Scale, endx.y);
//                [self drawText:[NSString stringWithFormat:@"%.0f%c",[@"0" floatValue] / totolCount * 100,'%'] andContext:contex atPoint:CGPointMake(secondP.x + 3, secondP.y - size.height / 2) WithColor:_k_COLOR_STOCK[i] andFontSize:25*k_Width_Scale];
            }else{
                secondP =CGPointMake(endx.x - 20*k_Width_Scale, endx.y);
//                [self drawText:[NSString stringWithFormat:@"%.0f%c",[@"0" floatValue] / totolCount * 100,'%'] andContext:contex atPoint:CGPointMake(secondP.x - size.width - 3, secondP.y - size.height/2) WithColor:_k_COLOR_STOCK[i] andFontSize:25*k_Width_Scale];
            }
        }
    }else{
        //正常的情况
        for (NSInteger i = 0; i<_valueDataArr.count; i++) {
            id obj = _valueDataArr[i];
            CGFloat currentSpace = [obj floatValue] / _totolCount * (M_PI * 2 - _itemsSpace * _valueDataArr.count);;
            NSLog(@"%f",currentSpace);
            CGFloat midSpace = lastBegin + currentSpace / 2;
            
            CGPoint begin = CGPointMake(self.chartOrigin.x + sin(midSpace) * _redius, self.chartOrigin.y - cos(midSpace)*_redius);
            CGPoint endx = CGPointMake(self.chartOrigin.x + sin(midSpace) * longLen, self.chartOrigin.y - cos(midSpace)*longLen);
            
            NSLog(@"%@%@",NSStringFromCGPoint(begin),NSStringFromCGPoint(endx));
            lastBegin += _itemsSpace + currentSpace;
            
            [self drawLineWithContext:contex andStarPoint:begin andEndPoint:endx andIsDottedLine:NO andColor:_k_COLOR_STOCK[i]];
            CGPoint secondP = CGPointZero;
            
            CGSize size = [[NSString stringWithFormat:@"%.0f%c",[obj floatValue] / _totolCount * 100,'%'] boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25*k_Width_Scale]} context:nil].size;
            
            CGFloat r = 60*k_Width_Scale;
            if (WIDTH == 320) {
                r = 44 * k_Width_Scale;
            }
            if (midSpace<M_PI) {
                secondP =CGPointMake(endx.x + r, endx.y);
//                [self drawText:[NSString stringWithFormat:@"%.0f%c",[obj floatValue] / _totolCount * 100,'%'] andContext:contex atPoint:CGPointMake(secondP.x - 5, secondP.y - size.height / 2) WithColor:_k_COLOR_STOCK[i] andFontSize:25*k_Width_Scale];
                
            }else{
                secondP =CGPointMake(endx.x - r, endx.y);
//                [self drawText:[NSString stringWithFormat:@"%.0f%c",[obj floatValue] / _totolCount * 100,'%'] andContext:contex atPoint:CGPointMake(secondP.x - size.width + 10, secondP.y - size.height/2) WithColor:_k_COLOR_STOCK[i] andFontSize:25*k_Width_Scale];
            }
        }
    }
    [self setUpDetailTitles:_detailTitles andTitles:_title];
    
    
}




@end
