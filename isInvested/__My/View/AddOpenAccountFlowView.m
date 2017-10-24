//
//  AddOpenAccountFlowView.m
//  
//
//  Created by Ben on 16/12/26.
//
//

#import "AddOpenAccountFlowView.h"

@implementation AddOpenAccountFlowView

- (instancetype)initWithFrame:(CGRect)frame SelectIndex:(NSInteger) index
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = OXColor(0xf5f5f5);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        [self setUpMyViewWithSelectIndex:(NSInteger) index];
        
    }
    return self;
}

-(void)setUpMyViewWithSelectIndex:(NSInteger) index{
    
    CGFloat imgW = 15;
    CGFloat lblW = (self.frame.size.width - imgW) * 0.5;
    CGFloat H = self.frame.size.height;
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(0, 0, lblW, H);
    label1.text = @"1.风险测评";
    label1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label1];

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(label1.right, 10, imgW, H - 20)];
    imgView.image = [UIImage imageNamed:@"goBlue"];
    [self addSubview:imgView];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(imgView.right, 0, lblW, H);
    label2.text = @"2.上传证件";
    label2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label2];
    
    if (index == 1) {
        label1.textColor = OXColor(0x1996d5);
        label2.textColor = OXColor(0x999999);
    }else{
        label1.textColor = OXColor(0x999999);
        label2.textColor = OXColor(0x1996d5);
    }
}


@end
