//
//  ImgViewLblView.h
//  isInvested
//
//  Created by Ben on 16/9/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgViewLblView : UIView

@property(nonatomic,strong) UIImage *img;
@property(nonatomic,strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imgView;

-(void)imgViewTypeBorder:(BOOL) Border;
-(void)cardImgView;

@end
