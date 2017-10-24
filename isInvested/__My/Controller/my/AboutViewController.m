//
//  AboutViewController.m
//  isInvested
//
//  Created by Ben on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "AboutViewController.h"
#import "HttpViewController.h"
#import "UILabel+TextWidhtHeight.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //app图片
    CGFloat imgW = 80;
    CGFloat imgH = 80;
    CGFloat hSpace = 60 + 64;
    UIImageView *_img = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - imgW) / 2.0, hSpace, imgW, imgH)];
    _img.image = [UIImage imageNamed:@"appIcon"];
    _img.layer.masksToBounds = YES;
    _img.layer.cornerRadius = 10;
    [self.view addSubview:_img];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [NSString stringWithFormat:@"版本: m-%@",app_Version];
    NSArray *titleArr = @[version,@"官网: http://milkvip.cn",@"版权: 广东乾赫贵金属经营有限公司所有",@"声明: 您通过本软件参加的商业活动,与Apple Inc.无关"];
    CGFloat y = NH(_img) + 50;
    UIFont *font = FONT(15);
    if (WIDTH == 320) {
        font = FONT(13);
    }else if(WIDTH == 375){
        font = FONT(14);
    }
    CGFloat lblH = 30;
    for (int i = 0; i < 4; i ++) {
        UILabel *label = [[UILabel alloc] init];
        CGFloat x = 15;
        label.frame = CGRectMake(x, y + lblH * i, WIDTH - 2*x, lblH);
        label.text = titleArr[i];
        label.font = font;
        if (i == 3) {
            label.height = [UILabel getHeightByWidth:label.width title:label.text font:label.font];
            label.numberOfLines = 0;
        }
        
        [label sizeToFit];
        label.textColor = OXColor(0x333333);
        [self.view addSubview:label];

    }
    
    CGFloat btnY = y + lblH * 4 + 60;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, btnY, WIDTH - 60, 40);
    [btn setTitle:@"软件评分" forState:UIControlStateNormal];
    [btn setTitleColor:OXColor(0x333333) forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 20;
    btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    btn.layer.borderWidth = 1;
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    if ([app_Version isEqualToString:@"1.0.1"]) {
        btn.hidden = YES;
    }
}

-(void)btnClick:(UIButton *)btn{
    
    HttpViewController *vc = [[HttpViewController alloc] init];
#warning  -- 正式上线的新版本 此处需要填写appstore链接地址 xinle 
    vc.urlStr = @"appstore地址";
    vc.titleStr = @"软件评分";
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
