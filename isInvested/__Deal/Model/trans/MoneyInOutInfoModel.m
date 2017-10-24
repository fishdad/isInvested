//
//  MoneyInOutInfoModel.m
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MoneyInOutInfoModel.h"

@implementation MoneyInOutInfoModel

+(MoneyInOutInfoModel *)shareModelWithStruct:(MoneyInOutInfo) stu{
    
     MoneyInOutInfoModel *model = [[MoneyInOutInfoModel alloc] init];
     model.RetCode = stu.RetCode;
     model.StrSid = [NSString stringWithUTF8String:stu.StrSid];
     model.LocalSid = [NSString stringWithUTF8String:stu.LocalSid];
     model.BankSid = [NSString stringWithUTF8String:stu.BankSid];
     model.NotifyUrl = [NSString stringWithUTF8String:stu.NotifyUrl];
     model.Message = [NSString stringWithUTF8String:stu.Message];
     model.Ticket = [NSString stringWithUTF8String:stu.Ticket];
    
    return model;
}

@end
