//
//  EditChooseCell.m
//  isInvested
//
//  Created by Blue on 16/8/16.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "EditChooseCell.h"
#import "IndexModel.h"

@interface EditChooseCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *codeL;
@end

@implementation EditChooseCell

- (void)setModel:(IndexModel *)model {
    [super setModel:model];
    
    self.nameL.text = model.mediumName;
    self.codeL.text = model.code;
}

- (IBAction)clickedDel {
    ((void(^)())self.objc1)();
}

- (IBAction)clickedTop {
    ((void(^)())self.objc2)();
}

@end
