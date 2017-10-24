//
//  DealDetailsViewController.m
//  isInvested
//
//  Created by Blue on 16/9/1.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "DealDetailsViewController.h"
#import "PositionDetailsController.h"
#import "PriceListController.h"
#import "CloseOutController.h"
#import "MyAssetsViewController.h"
#import <sys/utsname.h>

@interface DealDetailsViewController ()

/** 选中的button */
@property (nonatomic, strong) UIButton *selectButton;
/** 第一个默认选中的button */
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
/** button底部指示线 */
@property (weak, nonatomic) IBOutlet UIView *lineView;
/** 整个标题栏 */
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIView *dateView;
@end

@implementation DealDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dateView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform containsString:@"iPhone5"]) { //iphone5特别, 单独改颜色
        self.titleView.backgroundColor = OXColor(0x1a82cb);
    }
    
    self.view.backgroundColor = GrayBgColor;
    self.navigationItem.title = @"明细";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self
                                                                      action:@selector(clickedAsset)
                                                                       title:@"资产"];
    [self setupChildViewControllers];
    [self addChildVcView];
    self.selectButton = self.firstButton;
}

- (void)setupChildViewControllers {
    
    PositionDetailsController *position = [[PositionDetailsController alloc] init];
    [self addChildViewController:position];
    
    PriceListController *price = [[PriceListController alloc] init];
    [self addChildViewController:price];
    
    CloseOutController *close = [[CloseOutController alloc] init];
    [self addChildViewController:close];
    self.dateView = close.dateView;
}

/** 代码滚动结束, 调用的方法 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self addChildVcView];
}

/** 手动滚动结束, 调用的方法 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 当前页码
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    
    self.selectButton.selected = NO;
    UIButton *button = self.titleView.subviews[index];
    button.selected = YES;
    self.selectButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.x = WIDTH / 3 * index;
    }];
    
    [self addChildVcView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.dateView.x = WIDTH * 2 - scrollView.contentOffset.x;
}

- (void)addChildVcView {
    
    for (DetailsSuperController *vc in self.childViewControllers) {
        [vc removeTimer];
    }
    // 子控制器的索引
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    // 取出子控制器
    DetailsSuperController *childVc = self.childViewControllers[index];
    [childVc addTimer];
    
    if ([childVc isViewLoaded]) return;
    
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

- (IBAction)clickedTitleB:(UIButton *)sender {
    
    self.selectButton.selected = NO;
    sender.selected = YES;
    self.selectButton = sender;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.x = sender.x;
    }];
    
    // 为避免不必的bug,只改变x,不改变y
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = sender.tag * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES]; // NO [self addChildVcView];
}

- (void)clickedAsset {
    self.dateView.hidden = YES;
    MyAssetsViewController *vc = [[MyAssetsViewController alloc] init];
    vc.fromType = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
