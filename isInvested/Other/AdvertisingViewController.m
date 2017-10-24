//
//  AdvertisingViewController.m
//  isInvested
//
//  Created by Blue on 16/9/8.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "AdvertisingViewController.h"
#import <SafariServices/SafariServices.h>

@interface AdvertisingViewController ()<SFSafariViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageIv;

@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AdvertisingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestAdvertising];
}

#pragma mark - 网络请求

- (void)requestAdvertising {
    WEAK_SELF
    [HttpTool get:URL_ADVERTISING params:nil success:^(id responseObj) { //LOG(@"广告==%@", responseObj);
        
        if (![responseObj[@"Code"] isEqualToNumber:@200] || ![responseObj[@"Data"] count]) {
            [weakSelf clickedSkip];
            return;
        }
        weakSelf.src = responseObj[@"Data"][0][@"Src"]; //图片
        weakSelf.link = responseObj[@"Data"][0][@"Link"]; //链接
        weakSelf.time = 2;
        [weakSelf loadImage];
        
    } failure:^(NSError *error) {
        [weakSelf clickedSkip];
    }];
}

#pragma mark - 点击事件

- (IBAction)clickedSkip {
    
    [self removeTimer];
    
    if (self.skipAdvertisingBlock) {
        self.skipAdvertisingBlock();
    }
}

#pragma mark - 定时器

- (void)addTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.time
                                                  target:self
                                                selector:@selector(clickedSkip)
                                                userInfo:nil
                                                 repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Other

- (void)loadImage {
    
    [self.imageIv sd_setImageWithURL:[NSURL URLWithString:self.src] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.skipBtn.hidden = NO;
        [self addTimer];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!self.link) return;
    
    [self removeTimer];
    
    if (IOS_VERSION >= 9.0) { // ios9以后
        // xcode8 使用 SFSafariViewController 会打印一些没有的日志,  One of the two will be used. Which one is undefined.
        SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:self.link]];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
        
    } else { // ios8
        [self clickedSkip];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.link]];
    }
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self clickedSkip];
}

@end
