//
//  IndexModel.m
//  isInvested
//
//  Created by Blue on 16/9/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "IndexModel.h"

@implementation IndexModel

@synthesize ma5_price = _ma5_price;
@synthesize ma10_price = _ma10_price;
@synthesize ma20_price = _ma20_price;

- (id)initWithCoder:(NSCoder *)aDecoder {
    //分时图用
    self.new_price = [aDecoder decodeFloatForKey:@"new_price"];
    self.avg_price = [aDecoder decodeFloatForKey:@"avg_price"];
    self.isFlash = [aDecoder decodeBoolForKey:@"isFlash"];
    //K线图用
    self.date = [aDecoder decodeIntegerForKey:@"date"];
    self.open_price = [aDecoder decodeFloatForKey:@"open_price"];
    self.close_price = [aDecoder decodeFloatForKey:@"close_price"];
    self.max_price = [aDecoder decodeFloatForKey:@"max_price"];
    self.min_price = [aDecoder decodeFloatForKey:@"min_price"];
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    //分时图用
    [aCoder encodeFloat:self.new_price forKey:@"new_price"];
    [aCoder encodeFloat:self.avg_price forKey:@"avg_price"];
    [aCoder encodeBool:self.isFlash forKey:@"isFlash"];
    //K线图用
    [aCoder encodeInteger:self.date forKey:@"date"];
    [aCoder encodeFloat:self.open_price forKey:@"open_price"];
    [aCoder encodeFloat:self.close_price forKey:@"close_price"];
    [aCoder encodeFloat:self.max_price forKey:@"max_price"];
    [aCoder encodeFloat:self.min_price forKey:@"min_price"];
}

/** 倍数 */
- (CGFloat)priceunit {
    return [self.code_type containsString:@"8100"] ? 10000.0 : 1000.0;
}

- (NSInteger)open_time {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[]-"];
    NSArray *array = [self.open_close_time componentsSeparatedByCharactersInSet:set];
    for (NSString *str in array) {
        if (str.length) {
            return str.integerValue;
        }
    }
    return 0;
}

- (NSString *)format { //"美元人民币"保留4位小数
    return [self.code isEqualToString:@"USDCNY"] ? @"%.4f" : @"%.2f";
}

- (NSString *)dealTime {
    if (!self.code_type) return @"codeType==null";
    
    NSInteger end = [self.code_type endTime].integerValue;
    NSInteger start = [self.code startTime].integerValue;
    NSInteger now = [@"HHmm" currentTime].integerValue; //当前时间的整数格式
    NSString *stateStr = @"交易中: ";
    NSTimeInterval interval = kInterval1970;
    
    switch ([NSDate currentWeek]) {
        case 6:
        if (now > end) stateStr = @"已休市: ";
        break;
        
        case 7:
        stateStr = @"已休市: ";
        interval -= kOneDaySeconds;
        break;
        
        case 1:
        if (now < start) {
            stateStr = @"已休市: ";
            interval -= kTwoDaysSeconds;
        }
        break;
        
        default:
        if (now >= end && now < start) stateStr = @"已休市: ";
        break;
    }
    
    if ([stateStr isEqualToString:@"已休市: "]) {
        NSString *dateStr = [@"MM/dd" stringFromInterval1970:interval];
        return [NSString stringWithFormat:@"%@%@ %@", stateStr, dateStr, [self.code_type endTime]];
    }
    
    NSInteger sec = self.second + self.open_time * 60;
    NSInteger h = sec / 3600;
    NSInteger m = (sec - h * 3600) / 60;
    NSInteger s = sec - h * 3600 - m * 60;
    return [NSString stringWithFormat:@"交易中: %@ %02ld:%02ld:%02ld", [@"MM/dd" currentTime], h, m, s];
}

- (NSString *)hhmm {
    
    NSInteger sec = self.second + self.open_time * 60;
    NSInteger h = sec / 3600;
    NSInteger m = (sec - h * 3600) / 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", h, m];
}

/** 5日均价 */
- (void)setMa5_price:(CGFloat)ma5_price {
    _ma5_price += ma5_price;
}
- (CGFloat)ma5_price {
    return _ma5_price / 5;
}
/** 10日均价 */
- (void)setMa10_price:(CGFloat)ma10_price {
    _ma10_price += ma10_price;
}
- (CGFloat)ma10_price {
    return _ma10_price / 10;
}
/** 20日均价 */
- (void)setMa20_price:(CGFloat)ma20_price {
    _ma20_price += ma20_price;
}
- (CGFloat)ma20_price {
    return _ma20_price / 20;
}

/** 涨跌额 */
- (CGFloat)fluctuation {
    return self.new_price - self.pre_close;
}

/** 涨跌幅 */
- (CGFloat)fluctuation_percent {
    if (self.pre_close == 0 || self.new_price == 0) return 0.0;
    return self.fluctuation / self.pre_close * 100;
}

#pragma mark - 字符串

- (NSString *)mediumName {
    
    if (!self.code_type) return @"codeType==null";
    
    NSString *tail = @"";
    switch (strtoul([self.code_type UTF8String], 0, 0)) {
        case 0x5a01:
            tail = [self.name isEqualToString:@"粤贵银"] ? @"(kg)" : @"(g)";
            break;
        case 0x5b00:
            tail = @"(美元/盎司)";
            break;
        default:
            break;
    }
    return [self.name stringByAppendingString:tail];
}

- (NSString *)longName {
    
    if (!self.code_type) return @"codeType==null";
    
    NSString *tail = @"";
    switch (strtoul([self.code_type UTF8String], 0, 0)) {
        case 0x5a01:
            tail = [NSString stringWithFormat:@"%@%@", [self.name isEqualToString:@"粤贵银"] ? @"(kg)" : @"(g)", self.code];
            break;
        case 0x5b00:
            tail = [@"(美元/盎司)" stringByAppendingString:self.code];
            break;
        case 0x8100:
            tail = [self.name isEqualToString:@"美元指数"] ? @"UDI" : @"";
            break;
        default:
            break;
    }
    return [self.name stringByAppendingString:tail];
}

- (NSString *)newPriceStr {
    return [NSString stringWithFormat:self.format, self.new_price / self.priceunit];
}

- (NSString *)fluctuationStr {
    return [NSString stringWithFormat:self.format, self.fluctuation / self.priceunit];
}

- (NSString *)fluctuationPercentStr {
    return [NSString stringWithFormat:@"%.2f%%", self.fluctuation_percent];
}

- (NSString *)openPriceStr {
    return [NSString stringWithFormat:self.format, self.open_price / self.priceunit];
}

- (NSString *)preCloseStr {
    return [NSString stringWithFormat:self.format, self.pre_close / self.priceunit];
}

- (NSString *)maxPriceStr {
    return [NSString stringWithFormat:self.format, self.max_price / self.priceunit];
}

- (NSString *)minPriceStr {
    return [NSString stringWithFormat:self.format, self.min_price / self.priceunit];
}

#pragma mark - 颜色

- (NSInteger)color {
    return self.new_price >= self.pre_close ? kRed : kGreen;
}
- (NSInteger)flashColor {
    return self.new_price >= self.pre_close ? kFlashRed : kFlashGreen;
}
- (NSInteger)candleColor {
    return self.close_price >= self.open_price ? kCandleRed : kCandleGreen;
}

- (CGFloat)DIF {
    return self.EMA12 - self.EMA26;
}
- (CGFloat)MACD {
    return (self.DIF - self.DEA) * 2.0;
}


/** 传入2个结构体, 取大宗model */
+ (IndexModel *)readIndexWithCommRealTimeData:(CommRealTimeData)commRealTimeData
                             andHSWHRealTime2:(HSWHRealTime2)hSWHRealTime2 {
    
    IndexModel *model = [[IndexModel alloc] init];
    
    model.code = [NSString stringWithFormat:@"%.6s", commRealTimeData.m_cCode];
    model.code_type = [NSString stringWithFormat:@"0x%x", commRealTimeData.m_cCodeType];
    
    model.new_price = hSWHRealTime2.m_lNewPrice;
    model.open_price = hSWHRealTime2.m_lOpen;
    model.max_price = hSWHRealTime2.m_lMaxPrice;
    model.min_price = hSWHRealTime2.m_lMinPrice;
    model.second = commRealTimeData.m_othData.m_nTime * 60 + commRealTimeData.m_othData.m_nSecond;
    model.buyPrice = hSWHRealTime2.m_lBuyPrice1;
    model.sellPrice = hSWHRealTime2.m_lSellPrice1;
    
    NSDictionary *index = [TxtTool indexWithCodeType:model.code_type andCode:model.code];
    model.name = index[@"name"];
    model.pre_close = [index[@"preclose"] floatValue];
    model.open_close_time = index[@"open_close_time"];
//    LOG(@"code==%@    codeType==%@    hSWHRealTime2.m_lNewPrice==%d", model.code, model.code_type, hSWHRealTime2.m_lNewPrice);
    
    
    model.total = hSWHRealTime2.m_lTotal;
    return model;
}
//49779 50939
/** 传入2个结构体, 取外汇model */
+ (IndexModel *)readIndexWithCommRealTimeData:(CommRealTimeData)commRealTimeData
                              andHSWHRealTime:(HSWHRealTime)hSWHRealTime {
    
    IndexModel *model = [[IndexModel alloc] init];
    
    model.code = [NSString stringWithFormat:@"%.6s", commRealTimeData.m_cCode];
    model.code_type = [NSString stringWithFormat:@"0x%x", commRealTimeData.m_cCodeType];
    model.new_price = hSWHRealTime.m_lNewPrice;
    model.open_price = hSWHRealTime.m_lOpen;
    model.max_price = hSWHRealTime.m_lMaxPrice;
    model.min_price = hSWHRealTime.m_lMinPrice;
    model.second = commRealTimeData.m_othData.m_nTime * 60 + commRealTimeData.m_othData.m_nSecond;

    NSDictionary *index = [TxtTool indexWithCodeType:model.code_type andCode:model.code];
    model.name = index[@"name"];
    model.pre_close = [index[@"preclose"] floatValue];
    model.open_close_time = index[@"open_close_time"];
    return model;
}

/** 传入2个结构体, 取沪深指数model */
//+ (IndexModel *)readIndexWithCommRealTimeData:(CommRealTimeData)commRealTimeData
//                              HSIndexRealTime:(HSIndexRealTime)hSWHRealTime {
//    
//    IndexModel *model = [[IndexModel alloc] init];
//    
//    model.code = [NSString stringWithFormat:@"%.6s", commRealTimeData.m_cCode];
//    model.code_type = [NSString stringWithFormat:@"0x%x", commRealTimeData.m_cCodeType];
//    model.new_price = hSWHRealTime.m_lNewPrice;
//    model.open_price = hSWHRealTime.m_lOpen;
//    model.max_price = hSWHRealTime.m_lMaxPrice;
//    model.min_price = hSWHRealTime.m_lMinPrice;
//    
//    NSDictionary *index = [TxtTool indexWithCodeType:model.code_type andCode:model.code];
//    model.name = index[@"name"];
//    model.pre_close = [index[@"preclose"] floatValue];
//    model.open_close_time = index[@"open_close_time"];
//    return model;
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"pre_close" : @[ @"pre_close", @"preclose" ] };
}

/** 传入2个结构体, 取单个分时model */
//+ (IndexModel *)readTimeSharingModelWithAnsTrendData2:(AnsTrendData2)ansTrendData2
//                                        PriceVolItem2:(PriceVolItem2)priceVolItem2 {
//    
//    IndexModel *model = [[IndexModel alloc] init];
//    model.code = [NSString stringWithFormat:@"%.6s", ansTrendData2.m_cCode];
//    model.code_type = [NSString stringWithFormat:@"0x%x", ansTrendData2.m_cCodeType];
//    
//    model.new_price = priceVolItem2.m_lNewPrice;
//    return model;
//}

/** 传入2结构体, 取单个分时历史model */
//+ (IndexModel *)readTimeSharingHistoryModelWithAnsHisTrend2:(AnsHisTrend2)ansHisTrend2
//                                       StockCompHistoryData:(StockCompHistoryData)stockCompHistoryData {
//    
//    IndexModel *model = [[IndexModel alloc] init];
//    model.code = [NSString stringWithFormat:@"%.6s", ansHisTrend2.m_cCode];
//    model.code_type = [NSString stringWithFormat:@"0x%x", ansHisTrend2.m_cCodeType];
//    
//    model.new_price = stockCompHistoryData.m_lNewPrice;
//    return model;
//}

/** 传入2个结构体, 取k线model */
+ (IndexModel *)readKLineModelWithStockCompDayDataEx:(StockCompDayDataEx)stockCompDayDataEx {
    
    IndexModel *model = [[IndexModel alloc] init];
//    model.code = [NSString stringWithFormat:@"%.6s", ansDayDataEx2.m_cCode];
//    model.code_type = [NSString stringWithFormat:@"0x%x", ansDayDataEx2.m_cCodeType];
//    model.money = stockCompDayDataEx.m_lMoney;
//    model.nationalDebtRatio = stockCompDayDataEx.m_lNationalDebtRatio;
//    model.total = stockCompDayDataEx.m_lTotal;
    
    model.date = stockCompDayDataEx.m_lDate;
    model.open_price = stockCompDayDataEx.m_lOpenPrice;
    model.close_price = stockCompDayDataEx.m_lClosePrice;
    model.max_price = stockCompDayDataEx.m_lMaxPrice;
    model.min_price = stockCompDayDataEx.m_lMinPrice;
    return model;
}

MJExtensionLogAllProperties
@end
