//
//  BankModel.m
//  isInvested
//
//  Created by Ben on 2016/12/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "BankModel.h"

@implementation BankModel

- (instancetype)initWithArr:(NSArray *)arr
{
    self = [super init];
    if (self) {
    
        self.title = arr[0];
        self.detailTitle = arr[1];
        self.isChoose = NO;
    }
    return self;
}

@end
