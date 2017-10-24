//
//  ImgViewLblView.m
//  isInvested
//
//  Created by Ben on 16/9/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ImgViewLblView.h"

@interface ImgViewLblView ()


@end

@implementation ImgViewLblView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //图片
        CGFloat imgW = 30;
        CGFloat imgH = 30;
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (frame.size.height - imgH) / 2.0, imgW, imgH)];
        [self addSubview:_imgView];
        
        //显示框
        CGFloat textFX = NW(_imgView) + 10;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(textFX, (frame.size.height - imgH) / 2.0, (frame.size.width - textFX), imgH)];
        [self addSubview:_label];
    }
    return self;
}

-(void)setImg:(UIImage *)img{

    _imgView.image = img;
}

-(void)imgViewTypeBorder:(BOOL) Border{

    CGFloat imgW = 20;
    CGFloat imgH = 20;
    _imgView.frame = CGRectMake(15, (self.frame.size.height - imgH) / 2.0, imgW, imgH);
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = imgW / 2.0;
    if (Border) {
        _imgView.layer.borderColor = [OXColor(0xec6a00) CGColor];
        _imgView.layer.borderWidth = 2;
        _imgView.backgroundColor = OXColor(0xffffff);
    }else{

        _imgView.backgroundColor = OXColor(0xec6a00);
    }
}

-(void)cardImgView{

    CGFloat imgW = 40;
    CGFloat imgH = 30;
    _imgView.frame = CGRectMake(15, (self.frame.size.height - imgH) / 2.0, imgW, imgH);
    CGFloat textFX = NW(_imgView) + 10;
    _label.frame = CGRectMake(textFX, (self.frame.size.height - imgH) / 2.0, (self.frame.size.width - textFX), imgH);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
