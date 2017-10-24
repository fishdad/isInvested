//
//  HttpViewController.h
//  LessonWebView
//
//  Created by lanou3g on 15/9/21.
//  Copyright (c) 2015年 WLong. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HttpViewController : UIViewController

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) NSString *titleStr;

@end
