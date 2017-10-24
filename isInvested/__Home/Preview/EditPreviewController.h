//
//  EditPreviewController.h
//  isInvested
//
//  Created by Blue on 16/8/30.
//  Copyright © 2016年 Blue. All rights reserved.
//  行情速览

#import <UIKit/UIKit.h>

@interface EditPreviewController : UITableViewController

/** 返回后, 刷新首页的6个指数data */
@property (nonatomic, copy) void (^refreshDataBlock)();
@end
