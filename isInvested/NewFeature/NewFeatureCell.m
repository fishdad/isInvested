//
//  NewFeatureCell.m
//  isInvested
//
//  Created by Blue on 16/8/9.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NewFeatureCell.h"
#import "IITabBarController.h"

@interface NewFeatureCell ()

/** 单张全屏图片 */
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton    *startButton;
@end

@implementation NewFeatureCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)startButton {
    if (!_startButton) {
        
        _startButton = [[UIButton alloc] init];
        _startButton.size = CGSizeMake(180, 50);
        _startButton.center = CGPointMake(WIDTH * 0.5, HEIGHT * 0.9);
        [_startButton addTarget:self action:@selector(clickedStart) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_startButton];
//        _startButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    return _startButton;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.startButton.hidden = !self.showStartB;
    self.imageView.image = image;
}

- (void)clickedStart {
    
    IITabBarController *tabBarC = [[IITabBarController alloc] init];
    self.window.rootViewController = tabBarC;
}

@end
