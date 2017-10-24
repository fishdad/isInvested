//
//  MoneyInOutInfoModel.h
//  isInvested
//
//  Created by Ben on 16/11/21.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyInOutInfoModel : NSObject

@property (nonatomic, assign) int RetCode;    ///< 返回码
@property (nonatomic, strong) NSString *StrSid;    ///< SID
@property (nonatomic, strong) NSString *LocalSid;  ///< 新增LocalSid
@property (nonatomic, strong) NSString *BankSid;   ///< 新增BankSid
@property (nonatomic, strong) NSString *NotifyUrl; ///< 新增NotifyUrl
@property (nonatomic, strong) NSString *Message;			 ///< 出入金请求返回信息
@property (nonatomic, strong) NSString *Ticket;			 ///<

+(MoneyInOutInfoModel *)shareModelWithStruct:(MoneyInOutInfo) stu;

@end
