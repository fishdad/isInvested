//
//  HttpViewController.m
//  LessonWebView
//
//  Created by lanou3g on 15/9/21.
//  Copyright (c) 2015年 WLong. All rights reserved.
//

#import "HttpViewController.h"

@interface HttpViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
@end

@implementation HttpViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)dealloc
{
    LOG(@"httpVC销毁~~");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //主要用到UIWebView控件
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.webView.scalesPageToFit = YES;
    self.navigationItem.title = self.titleStr;
    //  设置代理
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self setUpData];
}


-(void)setUpData{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    //加载网页
    [self.webView loadRequest:request];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//实现协议的方法

//开始加载时触发
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //NSLog(@"开始加载");

}
//加载完成触发
- (void)webViewDidFinishLoad:(UIWebView *)webView {
   // NSLog(@"完成加载");

}
//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

@end
