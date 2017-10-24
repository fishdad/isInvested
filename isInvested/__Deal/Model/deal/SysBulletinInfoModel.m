//
//  SysBulletinInfoModel.m
//  isInvested
//
//  Created by Ben on 16/12/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "SysBulletinInfoModel.h"

@implementation SysBulletinInfoModel

+(SysBulletinInfoModel *)shareModelWithStruct:(SysBulletinInfo) stu{

    SysBulletinInfoModel *model = [[SysBulletinInfoModel alloc] init];
    model.LoginID = stu.LoginID;		///< 登录ID
    model.BulletinID = stu.BulletinID;   ///< 公告ID
    model.TradeMode = stu.TradeMode;		///< 交易模式
    model.BulletinType = stu.BulletinType;		///< 公告类型
    model.BulletinPriorty = stu.BulletinPriorty;  ///< 优先级
    model.BulletinHeader = [NSString stringWithUTF8String:stu.BulletinHeader];		///< 公告消息头
    model.BulletinContent = [NSString stringWithUTF8String:stu.BulletinContent];		///< 公告消息正文
    model.PublisherName = [NSString stringWithUTF8String:stu.PublisherName];		///< 发布方名
    model.BulletinMethod = stu.BulletinMethod;		///< 公告方式

    return model;
}

@end
