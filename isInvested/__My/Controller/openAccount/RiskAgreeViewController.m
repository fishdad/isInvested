//
//  RiskAgreeViewController.m
//  isInvested
//
//  Created by Ben on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "RiskAgreeViewController.h"
#import "OpenAccountResultViewController.h"
#import <WebKit/WebKit.h>


@interface RiskAgreeViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation RiskAgreeViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self reloadLocalFile:self.textFileName];
}

- (void)dealloc
{
    LOG(@"httpVC销毁~~");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //主要用到UIWebView控件
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat Y;
    if (self.navigationController.navigationBar.translucent) {
        Y = 0;
    }else{
        Y = 64;
    }
    CGFloat btnH = 40;
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 10, [UIScreen mainScreen].bounds.size.height - btnH - 10 - Y)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.title;
    //  设置代理
    self.webView.navigationDelegate = self;
    [self reloadLocalFile:self.textFileName];
    [self.view addSubview:self.webView];
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    [HUDTool showText:@"正在加载相关协议..."];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"我已阅读并同意相关协议" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    btn.layer.borderWidth = 1;
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btn = btn;
    _btn.frame = CGRectMake(30, _webView.bottom + 5, WIDTH - 60, 40);
    _btn.hidden = YES;
    [self.view addSubview:_btn];

}

//读取本地文件
- (NSString*)reloadLocalFile:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName
                                                     ofType:@"txt"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    NSData *data = [fileHandle readDataToEndOfFile];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *fontFamily = @"";
    NSString *bgColor = @"#ffffff";
    NSString *fontColor = @"#333333";
    NSString *fontSize = @"16";
    
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-size:%@;font-family:%@;color:%@}\n"
                          "</style> \n"
                          "</head> \n"
                          "<body bgcolor=%@>%@</body> \n"
                          "</html>", fontSize, fontFamily, fontColor,bgColor,text];
    [self.webView loadHTMLString:jsString baseURL:nil];
    
    return text;
}


-(void)btnClick:(UIButton *)btn{
    
   [self.navigationController popViewControllerAnimated:YES];
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

    LOG(@"~~~开始加载");
    [HUDTool showToView:self.view];
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

    LOG(@"~~~内容开始返回");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    LOG(@"~~~加载结束");
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '240%'" completionHandler:nil];//修改百分比即可
    [HUDTool hideForView:self.view];
    _btn.hidden = NO;
    
    //阅读完成才能显示按钮 屏蔽 by xinle 产品修改
//    _btn.frame = CGRectMake(30, _webView.scrollView.contentSize.height, WIDTH - 60, 40);
//    CGSize size = _webView.scrollView.contentSize;
//    _webView.scrollView.contentSize = CGSizeMake(size.width,size.height + 49);

}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{

    LOG(@"~~~加载错误");
     [HUDTool hideForView:self.view];
}


//-(void)webViewDidStartLoad:(UIWebView *)webView{
//
//    [HUDTool showToView:self.view];
//}
//
//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//
//    [HUDTool hideForView:self.view];
//    _btn.hidden = NO;
//    //阅读完成才能显示按钮 屏蔽 by xinle 产品修改
////    _btn.frame = CGRectMake(30, _webView.scrollView.contentSize.height, WIDTH - 60, 40);
////    CGSize size = _webView.scrollView.contentSize;
////    _webView.scrollView.contentSize = CGSizeMake(size.width,size.height + 49);
//}
//
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//
//     [HUDTool hideForView:self.view];
//}

@end
