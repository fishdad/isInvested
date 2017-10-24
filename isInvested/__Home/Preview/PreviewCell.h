//
//  PreviewCell.h
//  isInvested
//
//  Created by Blue on 16/8/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewCell : UITableViewCell

/** 是否勾选 */
@property (nonatomic, getter=isChecked) BOOL checked;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (nonatomic, copy) void(^clickedSelectBlock)(BOOL);
@end
