//
//  BankModel.h
//  isInvested
//
//  Created by Ben on 2016/12/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detailTitle;
@property (nonatomic, assign) BOOL isChoose;

- (instancetype)initWithArr:(NSArray *)arr;

@end
