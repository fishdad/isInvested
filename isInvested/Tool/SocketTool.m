//
//  SocketTool.m
//  isInvested
//
//  Created by Blue on 16/10/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "SocketTool.h"
#import "GCDAsyncSocket.h"
#import "IndexModel.h"

@interface SocketTool ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;

@property (nonatomic, strong) NSTimer *connectTimer;
@property (nonatomic, strong) NSTimer *heartbeatTimer;

@property (nonatomic, strong) NSData *bufferData; //缓冲区data
@property (nonatomic, strong) NSData *heartbeatData; //心跳包
@property (nonatomic, strong) NSData *loginData; //登录包

@property (nonatomic, strong) NSMutableData *bullets; //一个或多个子弹
@property (nonatomic, strong) NSMutableArray<IndexModel *> *data;
@property (nonatomic, strong) NSMutableArray<NSString *> *dates; //5日分时日期数组

@property (nonatomic, assign) BOOL isInitiativeDisconnect; //是否主动断开
@property (nonatomic, assign) NSInteger bodyLength; //单个包体长度
@property (nonatomic, assign) CGFloat preClose; //昨收
@property (nonatomic, assign) CGFloat maxPrice;
@property (nonatomic, assign) CGFloat minPrice;
@end

@implementation SocketTool

- (instancetype)init {
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.loginData = [NSData getLoginBullet];
    self.heartbeatData = [NSData getHeartbeatBullet];
    return self;
}

- (void)setRequestStyle:(SocketRequestStyle)requestStyle { _requestStyle = requestStyle;
    
    if (!self.indexes.count) return;
    self.bullets = [NSMutableData data];
    
    switch (self.requestStyle) {
            
        case SocketRequestStyleRealTimeAndPush:
            [self.bullets appendData:[NSData getRealTimeBulletWithIndexes:self.indexes]];
            [self.bullets appendData:[NSData getPushBulletWithIndexes:self.indexes]];
            break;
        
        case SocketRequestStyle5days: //5日
        {
            [self initializeParameter];
            
            for (int i = -4; i <= 0; i++) { // 按 -4 -3 -2 -1 0 的顺序
                
                NSDictionary *dict = [TxtTool getHistoryTimeSharingArrayWithCode:self.indexes[0].code date:i];
                if (dict) {
                    if (i == -4) self.preClose = [dict[@"preClose"] floatValue]; //5日的昨收
                    [self.dates addObject:dict[@"date"]]; //每日的日期 @"20150812"
                    [self.data addObjectsFromArray:dict[@"array"]];
                    if (self.maxPrice < [dict[@"maxPrice"] floatValue]) self.maxPrice = [dict[@"maxPrice"] floatValue];
                    if (self.minPrice > [dict[@"minPrice"] floatValue]) self.minPrice = [dict[@"minPrice"] floatValue];
                    
                } else { //空值,需请求
                    int var = [NSDate currentWeek] >= 6 ? (i - 1) : i;
                    [self.bullets appendData:[NSData getHistoryTimeSharingBulletWithModel:self.indexes[0] date:var]];
                }
            }
            break;
        }
        case SocketRequestStyleTimeSharing: //分时
            [self initializeParameter];
            [self.bullets appendData:[NSData getHistoryTimeSharingBulletWithModel:self.indexes[0] date:0]];
            break;
            
        default: //默认都是K线
            [self.bullets appendData:[NSData getKLineBulletWithModel:self.indexes[0] SocketRequestStyle:self.requestStyle]];
            break;
    }
    [self connectServer];
}

- (void)initializeParameter {
    
    self.data = [NSMutableArray arrayWithCapacity:1000];
    self.dates = [NSMutableArray arrayWithCapacity:5];
    self.minPrice = CGFLOAT_MAX;
    self.maxPrice = CGFLOAT_MIN;
    self.preClose = 0.0;
}

/** 连接服务器 */
- (void)connectServer {
    self.isInitiativeDisconnect = NO;
    
    if (self.socket.isConnected) { LOG(@"已经连接, 不用再连了");
        [self launchAndTiming];
        return;
    }
    LOG(@"先断, 再开始连接");
    [self.socket disconnect];
    [self.socket connectToHost:SOCKET_HOST onPort:SOCKET_PORT error:nil];
}

/** 手动断开 */
- (void)disconnect { LOG(@"手动断开!!");
    self.isInitiativeDisconnect = YES;
    [self.socket disconnect];
}

/** 发射并开启心跳定时器 */
- (void)launchAndTiming {
    
    [self removeConnectTimer];
    
    [self.socket writeData:self.bullets withTimeout:-1 tag:0];
    [self.socket readDataWithTimeout:-1 tag:0];
    
    [self removeHeartbeatTimer];
    [self addHeartbeatTimer];
}

#pragma mark - GCDAsyncSocketDelegate

// 链接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port { LOG(@"代理连接成功--------");
    
    self.bufferData = nil; //缓冲区清空, 改成在连接成功后
    [self.socket writeData:self.loginData withTimeout:-1 tag:0]; //发登录包
    [self launchAndTiming];
}

// 断开连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    LOG(@"代理断开连接--------<%@>主动断开", self.isInitiativeDisconnect ? @"是" : @"非");
    [self removeConnectTimer];
    [self removeHeartbeatTimer];
    
     //主动断开的, 不要再连接了
    if (self.isInitiativeDisconnect) return;
    //调用连接定时器, 不停地连接
    [self addConnectTimer];
}

#pragma mark - /** 收到回执 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [self.socket readDataWithTimeout:-1 tag:0];
    LOG(@"\n收到回执的方法__currentThread==%@", [NSThread currentThread]);
    
    NSMutableData *onceData = [NSMutableData dataWithData:self.bufferData];
    [onceData appendData:data];
    self.bufferData = onceData;
    
    if (self.bufferData.length == data.length) { LOG(@"管子长度 == 本次data长度");
        //取包头,重新计算包体长度 //使用此结构体解析 DataHead
        [self.bufferData getBytes:&_bodyLength range:NSMakeRange(4, 4)];
    }
    
    LOG(@"循环判断前:  %ld >= %ld\n", self.bufferData.length, self.bodyLength + 8);
    while (self.bufferData.length >= self.bodyLength + 8) { //至少够取一个完整的包
        
        NSData *oneData = [self.bufferData subdataWithRange:NSMakeRange(0, self.bodyLength + 8)];
        [self processOncePackage:oneData];
        
        self.bufferData =
        [self.bufferData subdataWithRange:NSMakeRange(oneData.length, self.bufferData.length - oneData.length)];
        
        if (self.bufferData.length < 10) break; //管子里的剩余长度太短, 跳出循环
        
        //接着计算下一个包体长度
        [self.bufferData getBytes:&_bodyLength range:NSMakeRange(4, 4)];
        LOG(@"判断前:  %ld >= %ld\n", self.bufferData.length, self.bodyLength + 8);
    }
}

#pragma mark - /** 处理一个完整的包 */
- (void)processOncePackage:(NSData *)data {
    
    int type; //使用此结构体解析 DataHead
    [data getBytes:&type range:NSMakeRange(8, 2)];
    
    switch (type) {
            
        case 0x8001: //压缩包
            data = [data unarchiverData];
            [self processInflatedData:data];
            break;
            
        case 0x0201: // 实时
        case 0x0a01: // 主推
            LOG(@"这是实时 / 主推来的+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
            int size;
            [data getBytes:&size range:NSMakeRange(24, 2)];
            
            data = [data subdataWithRange:NSMakeRange(28, data.length - 28)];
            [self processRealtimeAndPushData:data withSize:size isFlash:type == 0x0a01];
            break;
            
        case 0x0402://K线
            [self processKLineData:data deviation:8];
            break;
            
        case 0x0905: //心跳返回包
        case 0x20c: //以下都无用
        case 0x101:
        case 0x102:
        case 0x103:
            break;
        
        default:
        {
            NSString *info = [NSString stringWithFormat:@"++未解压的完整包==%x, %ld", type, data.length];
            [HUDTool showText:info];
            LOG(@"info::%@", info);
            break;
        }
    }
}

#pragma mark - /** 处理解压后的 data */
- (void)processInflatedData:(NSData *)data {
    
    int type; //使此结构体解析 AnsTrendData2
    [data getBytes:&type range:NSMakeRange(0, 2)];
    
    switch (type) {
            
        case 0x0201: // 解压后的实时
        case 0x0a01: // 解压后的主推
            LOG(@"实时 / 主推来的+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++解压后");
            int size;
            [data getBytes:&size range:NSMakeRange(16, 2)];
            
            data = [data subdataWithRange:NSMakeRange(20, data.length - 20)];
            [self processRealtimeAndPushData:data withSize:size isFlash:type == 0x0a01];
            break;
            
        case 0x0301: // 解压后的分时
        case 0x0304: // 解压后的分时历史
            [self processTimeSharingData:data];
            break;
            
        case 0x0402://K线
            [self processKLineData:data deviation:0];
            break;
        
        case 0x101: //暂时没用
            break;
        default:
            LOG(@"其它未知类型vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv==%x", type);
            break;
    }
}

#pragma mark - /** 处理实时 & 主推 data */
- (void)processRealtimeAndPushData:(NSData *)data withSize:(unsigned short)size isFlash:(BOOL)isFlash { // size==1, 就当是在详情页
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < size; i++) {
        
        CommRealTimeData commRealTimeData; //length==32
        [data getBytes:&commRealTimeData range:NSMakeRange(0, 32)];
        
        NSInteger location = 0;
        switch (commRealTimeData.m_cCodeType) {
                
            case 0x5a01: //大宗
            case 0x5900:
            case 0x5b00:
            case 0x5400:
            {
                HSWHRealTime2 hSWHRealTime2; //length==104
                [data getBytes:&hSWHRealTime2 range:NSMakeRange(32, 104)];
                
                IndexModel *model = [IndexModel readIndexWithCommRealTimeData:commRealTimeData andHSWHRealTime2:hSWHRealTime2];
                model.isFlash = isFlash;
                [array addObject:model];
                
                location = 136; // CommRealTimeData + HSWHRealTime2 = 32+104 =136
                data = [data subdataWithRange:NSMakeRange(location, data.length - location)];
                break;
            }
            case 0x8100: //外汇
            {
                HSWHRealTime hSWHRealTime;
                [data getBytes:&hSWHRealTime range:NSMakeRange(32, sizeof(HSWHRealTime))];
                
                IndexModel *model = [IndexModel readIndexWithCommRealTimeData:commRealTimeData andHSWHRealTime:hSWHRealTime];
                model.isFlash = isFlash;
                [array addObject:model];
                
                // CommRealTimeData + HSWHRealTime
                location = 32 + sizeof(HSWHRealTime);
                data = [data subdataWithRange:NSMakeRange(location, data.length - location)];
                break;
            }
//            case 0x5190: //恒生指数
//                location += 24; //这是个例外, 结尾会多出24个0
//            case 0x1200: //深证成指
//            case 0x1100: //上证指数
//            {
//                HSIndexRealTime hSIndexRealTime;
//                [data getBytes:&hSIndexRealTime range:NSMakeRange(sizeof(CommRealTimeData), sizeof(hSIndexRealTime))];
                
//                IndexModel *model = [IndexModel readIndexWithCommRealTimeData:commRealTimeData HSIndexRealTime:hSIndexRealTime];
//                model.isFlash = isFlash;
//                [array addObject:model];
                
                // CommRealTimeData + HSIndexRealTime
//                location += sizeof(CommRealTimeData) + sizeof(HSIndexRealTime);
//                data = [data subdataWithRange:NSMakeRange(location, data.length - location)];
//                break;
//            }
            default:
            {
                NSString *info = [NSString stringWithFormat:@"实时&主推未知类型%s--%x",
                                  commRealTimeData.m_cCode,commRealTimeData.m_cCodeType];
                [HUDTool showText:info];
                LOG(@"%@", info);
                break;
            }
        }
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SocketRealTimeAndPushNotification object:nil userInfo:@{ @"userInfo" : array }];
}

#pragma mark - /** 处理分时 or 5日 */

- (void)processTimeSharingData:(NSData *)data { //历史分时
    
    AnsHisTrend2 trend2;
    [data getBytes:&trend2 range:NSMakeRange(0, sizeof(AnsHisTrend2))];

    if (!self.preClose) self.preClose = trend2.m_lPrevClose;
    [self.dates addObject:[NSString stringWithFormat:@"%d", trend2.m_lDate]];

    CGFloat totalPrice = 0.0;
    NSInteger totalNumber = 0;
    
    CGFloat maxPrice = CGFLOAT_MIN;
    CGFloat minPrice = CGFLOAT_MAX;
    NSMutableArray<IndexModel *> *array = [NSMutableArray arrayWithCapacity:1000];
    
    NSInteger count = trend2.m_nSize - 1;
    for (int i = 0; i < count; i++) {
        
        StockCompHistoryData  sData;
        NSInteger location = sizeof(AnsHisTrend2) + i * sizeof(StockCompHistoryData);
        [data getBytes:&sData range:NSMakeRange(location, sizeof(StockCompHistoryData))];
        
        //正常情况赋值  //偶尔出现0值, 取前一个值  //周一前120条数据为空;平时前60条为空
        IndexModel *model = [[IndexModel alloc] init];
        model.new_price = sData.m_lNewPrice ? sData.m_lNewPrice : ( i ? array.lastObject.new_price : trend2.m_lPrevClose );
        [array addObject:model];
        
        //不能写成 if else , 因为第0个值为最小值时, 不会被保存
        if (maxPrice < model.new_price) maxPrice = model.new_price;
        if (minPrice > model.new_price) minPrice = model.new_price;
        
        // 算单个均价, 原来的成交里是累计的, 需要转换成单个的成交量
        model.total = sData.m_lTotal > totalNumber ? sData.m_lTotal - totalNumber : sData.m_lTotal;
        // 正常数据:是累加总量,直接赋值      非正常数据:单条数量, 需加到总量
        totalNumber = sData.m_lTotal > totalNumber ? sData.m_lTotal : totalNumber + sData.m_lTotal;
        totalPrice += model.total * sData.m_lNewPrice;
        model.avg_price = (totalPrice && totalNumber) ? totalPrice / totalNumber : model.new_price;
        
        model.totalPrice = totalPrice;
        model.totalNumber = totalNumber;
    }
    
    if (self.maxPrice < maxPrice) self.maxPrice = maxPrice;
    if (self.minPrice > minPrice) self.minPrice = minPrice;
    
    array.lastObject.isFlash = YES; //单日的历史的最后一条数据, 插入一个结束标记,用于分割黄线用
    [self.data addObjectsFromArray:array];
    
    if (trend2.m_lDate) { //历史分时, 存储至本地
        NSDictionary *dict = @{ @"date"     : @(trend2.m_lDate).stringValue,
                                @"preClose" : @(trend2.m_lPrevClose),
                                @"maxPrice" : @(maxPrice),
                                @"minPrice" : @(minPrice),
                                @"array"    : array };
        [TxtTool saveHistoryTimeSharingData:dict code:self.indexes[0].code day:@(trend2.m_lDate).stringValue];
        return;
    }
    
    if (self.dates.count == 1 || self.dates.count == 5) { //今日分时 or 5日分时的最后一天, 为验证数据,
        NSDictionary *dict = @{ @"style"    : @(self.requestStyle),
                                @"max"      : @(self.maxPrice),
                                @"min"      : @(self.minPrice),
                                @"preClose" : @(self.preClose),
                                @"code"     : self.indexes[0].code,
                                @"dates"    : self.dates,
                                @"data"     : self.data };
        [[NSNotificationCenter defaultCenter] postNotificationName:SocketTimeSharingNotification object:nil userInfo:dict ];
    }
}

#pragma mark - 处理K线

//deviation为差值值, 解压后=0, 未解压的=8
- (void)processKLineData:(NSData *)data deviation:(int)d{
    
    AnsDayDataEx2 ansDayDataEx2;
    [data getBytes:&ansDayDataEx2 range:NSMakeRange(d, sizeof(AnsDayDataEx2))];
    
    NSString *code = [NSString stringWithFormat:@"%.6s", ansDayDataEx2.m_cCode];
    NSInteger start = 20 + d;
    NSMutableArray<IndexModel *> *array = [NSMutableArray array];
    
    for(int i = 0 ; i < ansDayDataEx2.m_nSize; i++){
        
        StockCompDayDataEx  stockCompDayDataEx; //解析model用, 长度==32
        [data getBytes:&stockCompDayDataEx range:NSMakeRange(start + i * 32, 32)];
        [array addObject:[IndexModel readKLineModelWithStockCompDayDataEx:stockCompDayDataEx]];
        
        // 5日, 10日, 20日均价
        if (i >= 20) {
            for (NSInteger j = i - 1; j >= i - 20; j--) {
                array[i].ma20_price = array[j].close_price;
            }
            for (NSInteger j = i - 1; j >= i - 10; j--) {
                array[i].ma10_price = array[j].close_price;
            }
            for (NSInteger j = i - 1; j >= i - 5; j--) {
                array[i].ma5_price = array[j].close_price;
            }
            continue;
        }
        if (i >= 10) {
            for (NSInteger j = i - 1; j >= i - 10; j--) {
                array[i].ma10_price = array[j].close_price;
            }
            for (NSInteger j = i - 1; j >= i - 5; j--) {
                array[i].ma5_price = array[j].close_price;
            }
            continue;
        }
        if (i >= 5) {
            for (NSInteger j = i - 1; j >= i - 5; j--) {
                array[i].ma5_price = array[j].close_price;
            }
        }
        
    } //forEnd
    NSDictionary *dict = @{ @"array" : array, @"code" : code, @"style" : @(self.requestStyle) };
    [[NSNotificationCenter defaultCenter] postNotificationName:SocketKLineNotification object:nil userInfo:dict];
}

#pragma mark - Timer

- (void)addHeartbeatTimer {
    self.heartbeatTimer =
    [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(heartbeat) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.heartbeatTimer forMode:NSRunLoopCommonModes];
}
- (void)addConnectTimer {
    self.connectTimer =
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(connectServer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.connectTimer forMode:NSRunLoopCommonModes];
}

- (void)removeHeartbeatTimer {
    [self.heartbeatTimer invalidate];
    self.heartbeatTimer = nil;
}
- (void)removeConnectTimer {
    [self.connectTimer invalidate];
    self.connectTimer = nil;
}

/** 心跳, 次/10s */
- (void)heartbeat { LOG(@"\n~~~~~~~~~~~~~跳一下~~~~~~~~~~~~~~~~~~~~");
    [self.socket writeData:self.heartbeatData withTimeout:-1 tag:0];
}

SingletonM(SocketTool)
@end
