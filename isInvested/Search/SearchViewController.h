//
//  SearchViewController.h
//  isInvested
//
//  Created by Blue on 16/10/9.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (nonatomic, copy) void (^refreshDataBlock)();
@end
