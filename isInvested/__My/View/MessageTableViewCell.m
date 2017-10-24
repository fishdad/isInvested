//
//  MessageTableViewCell.m
//  isInvested
//
//  Created by Ben on 16/11/10.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = FONT(16);
        _titleLbl.textColor = OXColor(0x333333);
        [self.contentView addSubview:_titleLbl];
        
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.font = FONT(13);
        _timeLbl.textAlignment = NSTextAlignmentRight;
        _timeLbl.textColor = OXColor(0x999999);
        [self.contentView addSubview:_timeLbl];

        _detaiTitleLbl = [[UILabel alloc] init];
        _detaiTitleLbl.font = FONT(13);
        _detaiTitleLbl.textColor = OXColor(0x999999);
        [self.contentView addSubview:_detaiTitleLbl];
        

        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(12.5);
            make.top.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(80, 25));
        }];
        
        [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).offset(-12.5);
            make.top.equalTo(_titleLbl);
            make.size.mas_equalTo(CGSizeMake(80, 25));
        }];
        [_detaiTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(12.5);
            make.right.equalTo(self.contentView).offset(-12.5);
            make.top.equalTo(_titleLbl.mas_bottom).offset(8);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];

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
