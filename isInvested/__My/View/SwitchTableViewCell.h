//
//  SwitchTableViewCell.h
//  isInvested
//
//  Created by Ben on 16/8/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchBlock)(BOOL isON);

@interface SwitchTableViewCell : UITableViewCell

@property(nonatomic,copy) SwitchBlock switchBlock;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier switchOn:(BOOL) isOn switchBlock:(SwitchBlock) switchBlock;

@end
