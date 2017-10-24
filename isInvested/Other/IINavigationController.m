//
//  IINavigationController.m
//  isInvested
//
//  Created by Blue on 16/8/8.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "IINavigationController.h"

@implementation IINavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏背景view
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg"]
                             forBarMetrics:UIBarMetricsDefault];
    // 去除1px阴影线
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    // 设置导航栏标题文字的颜色
    NSDictionary *textAttrs = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName : BOLD_FONT(17.0) };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttrs];
    
    // 边缘滑动代理
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)pushViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    
    viewController.hidesBottomBarWhenPushed = self.childViewControllers.count;
    [super pushViewController:viewController animated:animated];
    
    // 不是导航控制器的根控制器才需要设置返回按钮
    if (self.childViewControllers.count > 1) {
        viewController.navigationItem.leftBarButtonItem =
        [UIBarButtonItem itemWithTarget:self action:@selector(clickedBack) image:@"back"];
    }
}

- (void)clickedBack {
    [self popViewControllerAnimated:YES];
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.childViewControllers.count > 1;
}

@end
