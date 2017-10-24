//
//  NSData+Extension.m
//  isInvested
//
//  Created by Blue on 16/10/11.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NSData+Extension.h"
#import "zlib.h"
#import "IndexModel.h"

@implementation NSData (Extension)

- (NSString *)parseString {
    
    NSMutableString *string = [NSMutableString string];
    Byte *byte = (Byte *)[self bytes];
    
    for (NSInteger i = 0; i < self.length; i++) {
        [string appendFormat:@"%02x", byte[i]];
        if ((i + 1) % 4 == 0) [string appendString:@" "];
    }
    return string;
}

- (NSString *)parseReverseString {
    
    NSMutableString *string = [NSMutableString string];
    Byte *byte = (Byte *)[self bytes];
    
    for (NSInteger i = self.length - 1, j = 1; i >= 0; i--, j++) {
        [string appendFormat:@"%02x", byte[i]];
        if (i % 4 == 0) [string appendString:@" "];
    }
    return string;
}

/** 解压data */
- (NSData *)uncompressZippedData {
    
    if ([self length] == 0) return self;
    
    unsigned  full_length = (unsigned)[self length];
    unsigned half_length = (unsigned)[self length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;

    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;

    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        
        if (status == Z_STREAM_END) {
            done = YES;
            
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
        
    } else {
        return nil;
    }
}

/** 读取压缩包 */
- (NSData *)unarchiverData {
    
    TransZipData2 transZipData;
    [self getBytes:&transZipData range:NSMakeRange(8, sizeof(TransZipData2))];
    
    NSData *data = [[self subdataWithRange:NSMakeRange(8 + sizeof(TransZipData2), transZipData.m_lZipLen)] uncompressZippedData];
    
    AnsTrendData2  ansData2;
    [data getBytes:&ansData2 range:NSMakeRange(0, sizeof(AnsTrendData2))];
    
    if (transZipData.m_lOrigLen != data.length) {
        LOG(@"解压后的包长度与给定的不符--");
        return nil;
    }
    LOG(@"data长==%ld 解压前长==%d  解压后长==%ld", self.length, transZipData.m_lZipLen, data.length);
    return data;
}

/** 取登录包 */
+ (NSData *)getLoginBullet {
    
    LoginPack login;
    memset(&login,0x00,sizeof(LoginPack));
    memcpy(login.head, [@"ZJHR" cStringUsingEncoding:NSUTF8StringEncoding], 4);
    login.length =  sizeof(login) - 8;
    login.m_nType = 0x0102;
    login.m_lKey = 3;
//    const char *str = [[NSString stringWithFormat:@"%ld",(long)[SingleSocket shareInstance].socketindex++] cStringUsingEncoding:NSUTF8StringEncoding];
//    memcpy(&login.m_nIndex,str,1);
    strncpy(login.m_szUser,[@"gpj_ios" cStringUsingEncoding:NSUTF8StringEncoding], 64);
    strncpy(login.m_szPWD,[@"bgt5vfr4" cStringUsingEncoding:NSUTF8StringEncoding], 64);
    return [NSData dataWithBytes:&login length:sizeof(login)];
}

/** 取心跳子弹 */
+ (NSData *)getHeartbeatBullet {
    
    TestSrvData2 testSrv;
    memset(&testSrv,0x00,sizeof(TestSrvData2));
    memcpy(testSrv.head,[@"ZJHR" cStringUsingEncoding:NSUTF8StringEncoding],4);
    testSrv.length =  sizeof(TestSrvData2) -8;
    testSrv.m_nType =0x0905;
    return [NSData dataWithBytes:&testSrv length:sizeof(testSrv)];
}

/** 取实时子弹 */
+ (NSData *)getRealTimeBulletWithIndexes:(NSArray<IndexModel *> *)indexes {
    
    MorePack morePack;
    memset(&morePack, 0x00, sizeof(morePack));
    memcpy(morePack.m_head, "ZJHR", 4);
    NSUInteger count = indexes.count;
    morePack.m_length = (int)sizeof(MorePack) + sizeof(CodeInfo) * (int)count - 8;
    morePack.m_nType = 0x0201;
    const char *str = [[NSString stringWithFormat:@"%d",0] cStringUsingEncoding:NSUTF8StringEncoding];
    memcpy(&morePack.m_nIndex,str,1);
    morePack.m_nSize = count;
    morePack.m_nOption = 0x0080;
    
    NSMutableData *data = [NSMutableData dataWithBytes:&morePack length:sizeof(MorePack)];
    for (int i = 0; i < count; i++) {
        
        IndexModel *model = indexes[i];
        CodeInfo codeInfo;
        memcpy(codeInfo.m_cCode2, [model.code cStringUsingEncoding:NSUTF8StringEncoding], 6);
        codeInfo.m_cCodeType2 = (unsigned short)strtoul([model.code_type UTF8String], 0, 0);
        [data appendData:[NSData dataWithBytes:&codeInfo length:sizeof(CodeInfo)]];
    }
    return data;
}

/** 取主推子弹 */
+ (NSData *)getPushBulletWithIndexes:(NSArray *)indexes {
    
    MorePack morePack;
    memset(&morePack, 0x00, sizeof(morePack));
    memcpy(morePack.m_head, "ZJHR", 4);
    NSUInteger count = indexes.count;
    morePack.m_length = (int)sizeof(MorePack) + sizeof(CodeInfo) * (int)count - 8;
    morePack.m_nType = 0x0A01;
    const char *str = [[NSString stringWithFormat:@"%d",0] cStringUsingEncoding:NSUTF8StringEncoding];
    memcpy(&morePack.m_nIndex,str,1);
    morePack.m_nSize = count;
    morePack.m_nOption = 0x0080;
    
    NSMutableData *data = [NSMutableData dataWithBytes:&morePack length:sizeof(MorePack)];
    for (int i = 0; i < count; i++) {
        
        IndexModel *model = indexes[i];
        CodeInfo codeInfo;
        memcpy(codeInfo.m_cCode2, [model.code cStringUsingEncoding:NSUTF8StringEncoding], 6);
        codeInfo.m_cCodeType2 = (unsigned short)strtoul([model.code_type UTF8String], 0, 0);
        [data appendData:[NSData dataWithBytes:&codeInfo length:sizeof(CodeInfo)]];
    }
    return data;
}

/** 取分时子弹 */
//+ (NSData *)getTimeSharingBulletWithModel:(IndexModel *)m {
//    
//    TrendPack trendPack ;
//    memset(&trendPack,0x00,sizeof(TrendPack));
//    memcpy(trendPack.m_head,"ZJHR",4);
//    trendPack.m_length =  sizeof(TrendPack) - 8;
//    trendPack.m_nType = 0x0301;
//    trendPack.m_nSize = 0;
//    trendPack.m_nOption	= 0x0080;
//    memcpy(trendPack.m_cCode,[m.code cStringUsingEncoding:NSUTF8StringEncoding],6);
//    memcpy(trendPack.m_cCode2,[m.code cStringUsingEncoding:NSUTF8StringEncoding],6);
//    trendPack.m_cCodeType = (unsigned short)strtoul([m.code_type UTF8String], 0, 0);
//    trendPack.m_cCodeType2 = (unsigned short)strtoul([m.code_type UTF8String], 0, 0);
//    return [NSData dataWithBytes:&trendPack length:sizeof(TrendPack)];
//}

/** 取历史分时子弹 */
+ (NSData *)getHistoryTimeSharingBulletWithModel:(IndexModel *)m date:(int)date {
    
    HistoryTrendPack historyTrendPack;
    memset(&historyTrendPack,0x00,sizeof(HistoryTrendPack));
    memcpy(historyTrendPack.m_head,"ZJHR",4);
    historyTrendPack.m_length =  sizeof(HistoryTrendPack) - 8;
    historyTrendPack.m_nType = 0x0304;
    historyTrendPack.m_nSize = 0;
    historyTrendPack.m_nOption	= 0x0080;
    memcpy(historyTrendPack.m_cCode,[m.code cStringUsingEncoding:NSUTF8StringEncoding],6);
    memcpy(historyTrendPack.m_cCode2,[m.code cStringUsingEncoding:NSUTF8StringEncoding],6);
    historyTrendPack.m_cCodeType = (unsigned short)strtoul([m.code_type UTF8String], 0, 0);
    historyTrendPack.m_cCodeType2 = (unsigned short)strtoul([m.code_type UTF8String], 0, 0);
    historyTrendPack.m_lDate = date;    
    return [NSData dataWithBytes:&historyTrendPack length:sizeof(HistoryTrendPack)];
}

/** 取K线子弹 */
+ (NSData *)getKLineBulletWithModel:(IndexModel *)m SocketRequestStyle:(SocketRequestStyle)requestStyle {
    
    TeachPack teach ;
    memset(&teach,0x00,sizeof(TeachPack));
    memcpy(teach.m_head,[@"ZJHR" cStringUsingEncoding:NSUTF8StringEncoding],4);
    teach.m_length =  sizeof(TeachPack) - 8;
    teach.m_nType = 0x0402;
    teach.m_nSize =1;
    const char *str = [[NSString stringWithFormat:@"%d",0] cStringUsingEncoding:NSUTF8StringEncoding];
    memcpy(&teach.m_nIndex,str,1);
    teach.m_nOption	= 0x0080;
    memcpy(teach.m_cCode,[m.code cStringUsingEncoding:NSUTF8StringEncoding],6);
    teach.m_cCodeType = (unsigned short)strtoul([m.code_type UTF8String], 0, 0);
    //已经请求到的数据个数，0代表请求最新的数据
    teach.m_lBeginPosition = 0;
    teach.m_nSize2 = 0;
    memcpy(teach.m_cCode2,[m.code cStringUsingEncoding:NSUTF8StringEncoding],6);
    teach.m_cCodeType2 = (unsigned short)strtoul([m.code_type UTF8String], 0, 0);
    
    switch (requestStyle) { // 0x00E0 1秒  0x00C0 1分  0x0030 5分  0x0010 1日
        case SocketRequestStyleDayK:
            teach.m_cPeriod = 0x0010;  //基数1天
            teach.m_nPeriodNum = 1;
            break;
        case SocketRequestStyleWeekK:
            teach.m_cPeriod = 0x0010;
            teach.m_nPeriodNum = 7;
            break;
        case SocketRequestStyleMonthK:
            teach.m_cPeriod = 0x0010;
            teach.m_nPeriodNum = 30;
            break;
        case SocketRequestStyle1Min:
            teach.m_cPeriod = 0x00C0;
            teach.m_nPeriodNum = 1;
            break;
        case SocketRequestStyle5Min:
            teach.m_cPeriod = 0x00C0;
            teach.m_nPeriodNum = 5;
            break;
        case SocketRequestStyle15Min:
            teach.m_cPeriod = 0x00C0;
            teach.m_nPeriodNum = 15;
            break;
        case SocketRequestStyle30Min:
            teach.m_cPeriod = 0x00C0;
            teach.m_nPeriodNum = 30;
            break;
        case SocketRequestStyle60Min:
            teach.m_cPeriod = 0x00C0;
            teach.m_nPeriodNum = 60;
            break;
        case SocketRequestStyle120Min:
            teach.m_cPeriod = 0x00C0;
            teach.m_nPeriodNum = 120;
            break;
        case SocketRequestStyle180Min:
            teach.m_cPeriod = 0x00C0;
            teach.m_nPeriodNum = 180;
            break;
        case SocketRequestStyle240Min:
            teach.m_cPeriod = 0x00C0;
            teach.m_nPeriodNum = 240;
            break;
        default:
            break;
    }    
    teach.m_nDay = 300 * teach.m_nPeriodNum; //1000条
    return [NSData dataWithBytes:&teach length:sizeof(TeachPack)];
}

@end
