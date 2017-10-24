//
//  CalculatorTool.h
//  isInvested
//
//  Created by Blue on 16/10/28.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorTool : NSObject

+ (CGFloat)EMAdays:(NSInteger)days lastEMA:(CGFloat)lastEMA closePrice:(CGFloat)closePrice;

+ (CGFloat)DEAdays:(NSInteger)days lastDEA:(CGFloat)lastDEA DIF:(CGFloat)DIF;

+ (CGFloat)SMAdays:(NSInteger)days lastSMA:(CGFloat)lastSMA closePrice:(NSInteger)closePrice;

+ (void)KDJArrayWithOriginalArray:(NSArray<IndexModel *> *)array;

+ (void)RSIArrayWithOriginalArray:(NSArray<IndexModel *> *)array;

+ (void)MACDArrayWithOriginalArray:(NSArray<IndexModel *> *)array;

@end
