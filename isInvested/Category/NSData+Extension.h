//
//  NSData+Extension.h
//  isInvested
//
//  Created by Blue on 16/10/11.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IndexModel;

/** socketRequest类型 */
typedef NS_ENUM(NSInteger, SocketRequestStyle) {
    
    SocketRequestStyleRealTimeAndPush = 300,
    
    SocketRequestStyleTimeSharing = 301,
    SocketRequestStyle5days = 302,
    SocketRequestStyleDayK = 303,
    SocketRequestStyleWeekK = 304,
    SocketRequestStyleMonthK = 305,
    
    SocketRequestStyle1Min = 1,
    SocketRequestStyle5Min = 5,
    SocketRequestStyle15Min = 15,
    SocketRequestStyle30Min = 30,
    SocketRequestStyle60Min = 60,
    SocketRequestStyle120Min = 120,
    SocketRequestStyle180Min = 180,
    SocketRequestStyle240Min = 240,
};

@interface NSData (Extension)

- (NSString *)parseString;
- (NSString *)parseReverseString;

/** 解压data */
- (NSData *)uncompressZippedData;
/** 读取压缩包 */
- (NSData *)unarchiverData;

/** 取登录包 */
+ (NSData *)getLoginBullet;

/** 取心跳子弹 */
+ (NSData *)getHeartbeatBullet;

/** 取实时子弹 */
+ (NSData *)getRealTimeBulletWithIndexes:(NSArray *)indexes;
/** 取主推子弹 */
+ (NSData *)getPushBulletWithIndexes:(NSArray *)indexes;

/** 取分时子弹 */
//+ (NSData *)getTimeSharingBulletWithModel:(IndexModel *)m;
/** 取历史分时子弹 */
+ (NSData *)getHistoryTimeSharingBulletWithModel:(IndexModel *)m date:(int)date;

/** 取K线子弹 */
+ (NSData *)getKLineBulletWithModel:(IndexModel *)m SocketRequestStyle:(SocketRequestStyle)requestStyle;

@end
