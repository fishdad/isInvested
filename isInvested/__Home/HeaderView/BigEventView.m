//
//  BigEventView.m
//  isInvested
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "BigEventView.h"
#import "SimpleWebViewController.h"
#import <SafariServices/SafariServices.h>

@interface BigEventView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageIv;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *hourL;
@property (weak, nonatomic) IBOutlet UILabel *minuteL;
@property (weak, nonatomic) IBOutlet UILabel *secondL;

@property (nonatomic, assign) NSTimeInterval timeSec;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy  ) NSString *url;
@property (nonatomic, copy  ) NSString *title;
@end

@implementation BigEventView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.width = WIDTH;
                       
    [self requestBigEvent];
}

- (void)requestBigEvent {
    WEAK_SELF
    [HttpTool get:URL_EVENT params:nil success:^(id responseObj) { //LOG(@"responseObj==%@", responseObj);
        
        if (![responseObj[@"Code"] isEqualToNumber:@200]) return;
        
        // 计算目标时间的秒数
        NSDate *date = [@"yyyy-MM-dd HH:mm" dateFromString:responseObj[@"Data"][0][@"BgColor"]];
        weakSelf.timeSec = [date timeIntervalSince1970];
        
        //当大事件没开始时, 显示大事件view
        if (weakSelf.objc1 && weakSelf.timeSec > kInterval1970) {
            ((void(^)())weakSelf.objc1)();
        }
        
        [weakSelf.imageIv sd_setImageWithURL:[NSURL URLWithString:responseObj[@"Data"][0][@"Src"]]];
        weakSelf.titleL.text = responseObj[@"Data"][0][@"Title"];
        weakSelf.contentL.text = responseObj[@"Data"][0][@"Content"];
        weakSelf.url = responseObj[@"Data"][0][@"Link"];
        weakSelf.title = responseObj[@"Data"][0][@"Title"];
        
        // 启动定时器
        weakSelf.timer =
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];
        
    } failure:^(NSError *error) { LOG_ERROR
    }];
}

/** 开始倒计时 */
- (void)countDown {
    
    NSTimeInterval differ = self.timeSec - kInterval1970;
    
    if (differ < 0) {
        self.hourL.text = @"0";
        self.minuteL.text = @"0";
        self.secondL.text = @"0";
        [self.timer invalidate];
        self.timer = nil;
        if (self.objc2) ((void(^)())self.objc2)();
        return;
    }
    
    NSInteger hour = differ / 3600;
    self.hourL.text = [NSString stringWithFormat:@"%ld", hour];
    
    NSInteger minute = (differ - hour * 3600) / 60;
    self.minuteL.text = [NSString stringWithFormat:@"%ld", minute];
    
    NSInteger second = differ - hour * 3600 - minute * 60;
    self.secondL.text = [NSString stringWithFormat:@"%ld", second];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    SimpleWebViewController *vc = [[SimpleWebViewController alloc] init];
    vc.navigationItem.title = self.title;
    vc.url = self.url;
    UITabBarController *tabBarC = (UITabBarController *)self.window.rootViewController;
    [tabBarC.selectedViewController pushViewController:vc animated:YES];
}

@end
