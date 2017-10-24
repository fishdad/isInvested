//
//  NewBankTableViewCell.m
//  isInvested
//
//  Created by Ben on 2016/12/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NewBankTableViewCell.h"

@implementation NewBankTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = FONT(16);
        _titleLbl.textColor = OXColor(0x333333);
        [self.contentView addSubview:_titleLbl];
        
        _detailLbl = [[UILabel alloc] init];
        _detailLbl.font = FONT(13);
        _detailLbl.numberOfLines = 0;
        _detailLbl.textColor = OXColor(0x999999);
        [self.contentView addSubview:_detailLbl];
        
        _chooseImg = [[UIImageView alloc] init];
        [self.contentView addSubview:_chooseImg];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(17.5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(45);
            make.top.equalTo(self.contentView).offset(5);
            make.size.mas_equalTo(CGSizeMake(WIDTH - 45, 25));
        }];
        
        [_detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(45);
            make.right.equalTo(self.contentView).offset(0);
            make.top.equalTo(_titleLbl.mas_bottom).offset(0);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
        
        [_chooseImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(17.5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];

        
    }
    return self;
}

-(void)setModel:(BankModel *)model{

    self.titleLbl.text = model.title;
    if ([self.titleLbl.text isEqualToString:@"光大银行"]) {
        self.titleLbl.attributedText = [Util setStringsArr:@[@"光大银行",@"(需先开通网银,否则无法签约)"] ColorsArr:@[OXColor(0x000000),OXColor(0x999999)] FontsArr:@[FONT(16),FONT(13)]];
    }
    self.detailLbl.text = model.detailTitle;
    self.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.code]];
    self.chooseImg.image = [UIImage imageNamed:@""];
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
