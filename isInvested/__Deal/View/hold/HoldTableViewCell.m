//
//  HoldTableViewCell.m
//  isInvested
//
//  Created by Ben on 16/9/22.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "HoldTableViewCell.h"
#import "VarietyDetailView.h"

@interface HoldTableViewCell ()

@property (nonatomic, strong) VarietyDetailView *detailView;

@end

@implementation HoldTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = 0;
        _titleView = [[VarietyDetailTitleView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 41)];
        [self.contentView addSubview:_titleView];
        
        _detailView = [[VarietyDetailView alloc] initWithFrame:CGRectMake(0, NH(_titleView), WIDTH, 126)];
        [self.contentView addSubview:_detailView];
        
        self.contentView.backgroundColor = OXColor(0xf5f5f5);
    }
    
    return self;
}

-(void)setModel:(HoldPositionTotalInfoModel *)model{

    if (![model isKindOfClass:[HoldPositionTotalInfoModel class]]) {
        return;
    }
    _model = model;
    _titleView.model = model;
    _detailView.model = model;
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
