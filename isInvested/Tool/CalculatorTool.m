//
//  CalculatorTool.m
//  isInvested
//
//  Created by Blue on 16/10/28.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CalculatorTool.h"
#import "IndexModel.h"

@implementation CalculatorTool

+ (CGFloat)EMAdays:(NSInteger)days lastEMA:(CGFloat)lastEMA closePrice:(CGFloat)closePrice {
    //指数移动平均指标 EMA(12)＝(收盘价－昨日的EMA)×2/13＋昨日的EMA  
//    return (closePrice - lastEMA) * 2 / (days + 1) + lastEMA; //之前的
//    return lastEMA * (days - 1) / (days + 1) + closePrice * 2 / (days + 1);
    
    return (lastEMA * (days - 1) + closePrice * 2) / (days + 1);
}

+ (CGFloat)DEAdays:(NSInteger)days lastDEA:(CGFloat)lastDEA DIF:(CGFloat)DIF {
    return 2.0 / (days + 1.0) * DIF + (days - 1.0) / (days + 1.0) * lastDEA;
}

+ (CGFloat)SMAdays:(NSInteger)days lastSMA:(CGFloat)lastSMA closePrice:(NSInteger)closePrice {
    // 第一天==closePrice
    return (closePrice + (days - 1) * lastSMA) / days;
}

+ (void)KDJArrayWithOriginalArray:(NSArray<IndexModel *> *)array {
    
    NSInteger count = array.count;
    if (count < 8) return;
    
    for (int i = 0; i < 8; i++) {
        IndexModel *m = array[i];
        m.K = 50.0;
        m.D = 50.0;
        m.J = 3.0 * m.K - 2.0 * m.D;
    }
    
    for (int i = 8; i < count; i++) {
        
        CGFloat max9Price = CGFLOAT_MIN;
        CGFloat min9Price = CGFLOAT_MAX;
        
        for (int j = i - 8 ; j <= i; j++) {
            max9Price = MAX(max9Price, array[j].max_price);
            min9Price = MIN(min9Price, array[j].min_price);
        }
        
        IndexModel *m = array[i];
        CGFloat RSV = (m.close_price - min9Price) / (max9Price - min9Price) * 100.0;
        m.K = 2.0 / 3.0 * array[i - 1].K + 1.0 / 3.0 * RSV;
        m.D = 2.0 / 3.0 * array[i - 1].D + 1.0 / 3.0 * m.K;
        m.J = 3.0 * m.K - 2.0 * m.D;
    }
}

+ (void)RSIArrayWithOriginalArray:(NSArray<IndexModel *> *)array {
    
    NSInteger count = array.count;
    if (!count) return;
    
    CGFloat sma1 = [CalculatorTool SMAdays:6 lastSMA:array[0].close_price closePrice:array[0].close_price];
    CGFloat sma2 = [CalculatorTool SMAdays:6 lastSMA:array[0].close_price closePrice:array[0].close_price];
    array[0].RSI1 = sma1 / sma2 * 100.0;
    
    for (int i = 1; i < count; i++) {
        IndexModel *m = array[i];
        IndexModel *lastM = array[i - 1];
        
        CGFloat max6 = MAX(m.close_price - lastM.close_price, 0);
        CGFloat abs6 = ABS(m.close_price - lastM.close_price);
        
        m.SMA6MAX = [CalculatorTool SMAdays:6 lastSMA:lastM.SMA6MAX closePrice:max6];
        m.SMA12MAX = [CalculatorTool SMAdays:12 lastSMA:lastM.SMA12MAX closePrice:max6];
        m.SMA24MAX = [CalculatorTool SMAdays:24 lastSMA:lastM.SMA24MAX closePrice:max6];
        
        m.SMA6ABS = [CalculatorTool SMAdays:6 lastSMA:lastM.SMA6ABS closePrice:abs6];
        m.SMA12ABS = [CalculatorTool SMAdays:12 lastSMA:lastM.SMA12ABS closePrice:abs6];
        m.SMA24ABS = [CalculatorTool SMAdays:24 lastSMA:lastM.SMA24ABS closePrice:abs6];
        
        m.RSI1 = m.SMA6MAX / m.SMA6ABS * 100.0;
        m.RSI2 = m.SMA12MAX / m.SMA12ABS * 100.0;
        m.RSI3 = m.SMA24MAX / m.SMA24ABS * 100.0;
    }
}

+ (void)MACDArrayWithOriginalArray:(NSArray<IndexModel *> *)array {
    
    NSInteger count = array.count;
    if (count < 2) return;
    
    //计算index0
    IndexModel *m0 = array[0];
    m0.EMA12 = [CalculatorTool EMAdays:12 lastEMA:m0.close_price closePrice:m0.close_price];
    m0.EMA26 = m0.close_price;
    m0.DEA = [CalculatorTool EMAdays:9 lastEMA:m0.DIF closePrice:m0.DIF]; // DIF = EMA12 - EMA26
    
    m0.EMA12 = [CalculatorTool EMAdays:12 lastEMA:m0.EMA12 closePrice:m0.close_price];
    m0.EMA26 = [CalculatorTool EMAdays:26 lastEMA:m0.EMA26 closePrice:m0.close_price];
    
    // 计算index1
    IndexModel *m1 = array[1];
    m1.EMA12 = [CalculatorTool EMAdays:12 lastEMA:m1.close_price closePrice:m1.close_price];
    m1.EMA26 = [CalculatorTool EMAdays:26 lastEMA:m1.close_price closePrice:m1.close_price];
    m1.DEA = [CalculatorTool EMAdays:9 lastEMA:m0.DEA closePrice:m1.DIF]; // DIF = EMA12 - EMA26
    
    for (int i = 2; i < count; i++) {
        IndexModel *m = array[i];
        IndexModel *lastM = array[i - 1];
        
        m.EMA12 = [CalculatorTool EMAdays:12 lastEMA:lastM.EMA12 closePrice:m.close_price];
        m.EMA26 = [CalculatorTool EMAdays:26 lastEMA:lastM.EMA26 closePrice:m.close_price];
        
//        m.DEA = [CalculatorTool DEAdays:9 lastDEA:lastM.DEA DIF:m.DIF];   //2种结果一样
        m.DEA = [CalculatorTool EMAdays:9 lastEMA:lastM.DEA closePrice:m.DIF]; //tom方法
    }
}

@end
