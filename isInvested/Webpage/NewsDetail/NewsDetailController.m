//
//  NewsDetailController.m
//  isInvested
//
//  Created by Blue on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NewsDetailController.h"
#import "NewsDetailTitleView.h"
#import "ImportantNewsMessage.h"
#import "ShareView.h"

@interface NewsDetailController ()<UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) ImportantNewsMessage *model;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIImageView *notNetView;
@end

@implementation NewsDetailController

- (UIImageView *)notNetView {
    if (!_notNetView) {
        _notNetView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notNetwork"]];
        _notNetView.center = CGPointMake(WIDTH / 2, HEIGHT / 2 - 64);
        _notNetView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshNetwork)];
        [_notNetView addGestureRecognizer:tap];
    }
    return _notNetView;
}

- (UIWebView *)webView {
    if (!_webView) {
//        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49)];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)]; //分享btn去掉后
        _webView.delegate = self;
        _webView.hidden = YES;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新闻正文";
    
    [self.view addSubview:self.webView];
    
    [self refreshNetwork];
}

- (void)loadWebView {
    
    NSString *str = [NSString stringWithFormat:@".jpg' width='%.0f' ", WIDTH - 25];
    self.model.Art_Content = [self.model.Art_Content stringByReplacingOccurrencesOfString:@".jpg" withString:str];
//    LOG(@"修改后的Art_Content==%@", self.model.Art_Content);
    [self.webView loadHTMLString:self.model.Art_Content baseURL:nil];
    
    NewsDetailTitleView *titleView = [NewsDetailTitleView viewFromXid];
    titleView.model = self.model;
    [self.webView.scrollView addSubview:titleView];
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.delegate = self;
}

#pragma mark - <WKNavigationDelegate, UIScrollViewDelegate>

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.notNetView removeFromSuperview];
    [HUDTool hideForView:self.view];
    webView.hidden = NO;
}

//- (void)webView:(UIWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
//    [HUDTool hideForView:self.view];
//    webView.hidden = NO;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint point = scrollView.contentOffset;
    if (point.x > 0) {
        scrollView.contentOffset = CGPointMake(0, point.y);
    }
}

#pragma mark - 网络请求

- (void)requestNewsDetailData {
    
    [HUDTool showToView:self.view];
    
    WEAK_SELF
    [HttpTool post:URL_NEWS_DETAIL params:@{@"Id":self.artCode} success:^(id responseObj) {
        weakSelf.model = [ImportantNewsMessage mj_objectWithKeyValues:responseObj[@"model"]];
//        LOG(@"原来的==%@", weakSelf.model.Art_Content);
        [weakSelf loadWebView];
        
    } failure:^(NSError *error) { LOG_ERROR
        [HUDTool hideForView:weakSelf.view];
        [weakSelf refreshNetwork];
    }];
}

- (IBAction)clickedShare {
    
    ShareModel *model = [[ShareModel alloc] init];
    model.caption = self.model.Art_Title;
    model.content = self.model.Art_Docu_Reader;
    model.imageUrl = self.model.Art_Image;
    model.gotoUrl = self.model.ShareUrl;

    [[ShareView viewFromXid] setModel:model];
}

- (void)refreshNetwork {
    if ([HttpTool networkStatus]) {
        [self requestNewsDetailData];
    } else {
        [self.view addSubview:self.notNetView];
    }
}

@end
