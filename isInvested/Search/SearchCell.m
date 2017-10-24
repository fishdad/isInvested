//
//  SearchCell.m
//  isInvested
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "SearchCell.h"
#import "IndexModel.h"

@interface SearchCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *codeL;
@property (weak, nonatomic) IBOutlet UIButton *selectB;
@end

@implementation SearchCell

- (void)setModel:(IndexModel *)model {
    [super setModel:model];
    
    self.nameL.text = model.mediumName;
    self.codeL.text = model.code;
    self.selectB.selected = model.number != 99;
}

- (IBAction)clickedAdd:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    // 编号==99, 就是非选中的
    [self.model setNumber:sender.selected ? 98 : 99];
    [IndexTool saveWithSelectModel:self.model]; //自选页DB
}

@end
