//
//  SimpleWebViewController.m
//  isInvested
//
//  Created by Blue on 16/8/31.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "SimpleWebViewController.h"
#import <WebKit/WebKit.h>

@interface SimpleWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIImageView *notNetView;
@end

@implementation SimpleWebViewController

- (UIImageView *)notNetView {
    if (!_notNetView) {
        _notNetView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notNetwork"]];
        _notNetView.center = CGPointMake(WIDTH / 2, HEIGHT / 2 - 64);
        _notNetView.userInteractionEnabled = YES;
        [_notNetView addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshNetwork)]];
    }
    return _notNetView;
}

- (WKWebView *)webView {
    if (!_webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userC = [[WKUserContentController alloc] init];
//        [userC addScriptMessageHandler:self name:@"NativeMethod"];
        config.userContentController = userC;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) configuration:config];
        _webView.navigationDelegate = self;
        _webView.hidden = YES;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GrayBgColor;
    
    [self refreshNetwork];
    WEAK_SELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0*NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if (weakSelf.webView.hidden && [HttpTool networkStatus]) {
                           [weakSelf.webView removeFromSuperview];
                           [HUDTool hideForView:weakSelf.view];
                           [HUDTool showText:@"请求超时!" toView:weakSelf.view];
                       }
                   });
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self.notNetView removeFromSuperview];
    [HUDTool hideForView:self.view];
    webView.hidden = NO;
}

#pragma mark - 点击事件

/** 点击了特殊的按钮, 跳到立即登录 or 立即开户 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    if ([[webView.URL absoluteString] containsString:@"type=goapp"]) {
        [self.navigationController popViewControllerAnimated:NO];
        [Util goToDeal];
    }
}

- (void)refreshNetwork {
    if ([HttpTool networkStatus]) {
        [HUDTool showToView:self.view];
        [self.view addSubview:self.webView];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    } else {
        [self.view addSubview:self.notNetView];
    }
}

@end
