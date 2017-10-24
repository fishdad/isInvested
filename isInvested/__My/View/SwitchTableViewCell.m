//
//  SwitchTableViewCell.m
//  isInvested
//
//  Created by Ben on 16/8/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "SwitchTableViewCell.h"

@implementation SwitchTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier switchOn:(BOOL) isOn switchBlock:(SwitchBlock) switchBlock{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.switchBlock = switchBlock;
    
    UISwitch*switch1 = [[UISwitch alloc]init];
    
    [switch1 setOn:isOn animated:YES];
    
    [switch1 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:switch1];
    
    [switch1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(7);
        make.right.equalTo(self.contentView).offset(40);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        
    }];
    
    return self;
}

-(void)switchAction:(UISwitch *)mySwitch{


    if (self.switchBlock != nil) {
        self.switchBlock(mySwitch.on);
    }
    
}

@end
