//
//  HUDTool.m
//  isInvested
//
//  Created by Blue on 16/8/9.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "HUDTool.h"
#import "UIImage+GIF.h"

@implementation HUDTool

static UIImageView *_loadingGif;

+ (void)initialize {
    UIImage *image = [UIImage sd_animatedGIFNamed:@"loading"];
    _loadingGif = [[UIImageView alloc] initWithImage:image];
}

+ (void)show {
    [HUDTool showToView:KEY_WINDOW];
}
+ (void)showToView:(UIView *)view {
//    [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    _loadingGif.centerX = WIDTH / 2;
    _loadingGif.centerY = view.centerY * 0.9;
    [view addSubview:_loadingGif];
    view.userInteractionEnabled = NO;
    
//    UIImageView *loadingGif = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"loading"]];
//    loadingGif.centerX = WIDTH / 2;
//    loadingGif.centerY = view.centerY * 0.9;
//    [view addSubview:loadingGif];
//    view.userInteractionEnabled = NO;
}

+ (void)hide {
    [HUDTool hideForView:KEY_WINDOW];
}
+ (void)hideForView:(UIView *)view {
//    [MBProgressHUD hideHUDForView:view animated:YES];
    
    [_loadingGif removeFromSuperview];
    view.userInteractionEnabled = YES;
    
//    [view.subviews.lastObject removeFromSuperview];
//    view.userInteractionEnabled = YES;
}

+ (void)showText:(NSString *)text {
    [HUDTool showText:text toView:KEY_WINDOW];
}
+ (void)showText:(NSString *)text toView:(UIView *)view {
    if (!view) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = FONT(14.0);
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    [hud hideAnimated:YES afterDelay:1.f];
}

@end
