//
//  TransferListTableViewCell.m
//  isInvested
//
//  Created by Ben on 16/9/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "TransferListTableViewCell.h"

@implementation TransferListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _valueView = [[TransferListTitleView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        [self.contentView addSubview:_valueView];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
