//
//  MyTransferViewController.h
//  isInvested
//
//  Created by Ben on 16/9/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTransferViewController : UIViewController
@property (nonatomic, strong) UISegmentedControl *segmentControl;
-(void)actionSegmentControl:(UISegmentedControl *)segment;
@end
