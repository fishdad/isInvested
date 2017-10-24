//
//  SysBulletinInfoModel.h
//  isInvested
//
//  Created by Ben on 16/12/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysBulletinInfoModel : NSObject

@property (nonatomic, assign)long long       LoginID;		///< 登录ID
@property (nonatomic, assign)long long BulletinID;   ///< 公告ID
@property (nonatomic, assign)int       TradeMode;		///< 交易模式
@property (nonatomic, assign)int       BulletinType;		///< 公告类型
@property (nonatomic, assign)int       BulletinPriorty;  ///< 优先级
@property (nonatomic, strong)NSString *BulletinHeader;		///< 公告消息头
@property (nonatomic, strong)NSString *BulletinContent;		///< 公告消息正文
@property (nonatomic, strong)NSString *PublisherName;		///< 发布方名
@property (nonatomic, assign)int       BulletinMethod;		///< 公告方式

+(SysBulletinInfoModel *)shareModelWithStruct:(SysBulletinInfo) stu;

@end
