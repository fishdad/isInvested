//
//  IndexModel.h
//  isInvested
//
//  Created by Blue on 16/9/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexModel : NSObject<NSCoding>

@property (nonatomic, copy  ) NSString *name;       //简称
@property (nonatomic, copy  ) NSString *mediumName; //全名
@property (nonatomic, copy  ) NSString *longName;   //全名, 含code
@property (nonatomic, copy  ) NSString *code;
@property (nonatomic, copy  ) NSString *code_type;

@property (nonatomic, assign) NSInteger color;
@property (nonatomic, assign) NSInteger flashColor;
@property (nonatomic, assign) NSInteger candleColor;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, assign) NSInteger open_time;

@property (nonatomic, assign) BOOL isFlash; //是否要闪 or 做为单日分时的最后一条数据的标记

@property (nonatomic, copy  ) NSString *open_close_time;
@property (nonatomic, copy  ) NSString *dealTime;
@property (nonatomic, copy  ) NSString *hhmm; //取 05:30 样式的时间

@property (nonatomic, copy) NSString *format; // %.4f or %.2f
@property (nonatomic, copy) NSString *newPriceStr;
@property (nonatomic, copy) NSString *fluctuationStr;
@property (nonatomic, copy) NSString *fluctuationPercentStr;
@property (nonatomic, copy) NSString *openPriceStr; //今开
@property (nonatomic, copy) NSString *preCloseStr; //昨收
@property (nonatomic, copy) NSString *maxPriceStr; //最高
@property (nonatomic, copy) NSString *minPriceStr; //最低

/** 涨跌额 */
@property (nonatomic, assign) CGFloat fluctuation;
/** 涨跌幅 */
@property (nonatomic, assign) CGFloat fluctuation_percent;
/** 昨收价 */
@property (nonatomic, assign) CGFloat  pre_close;
/** 倍数 */
@property (nonatomic, assign) CGFloat priceunit;

@property (nonatomic, assign) CGFloat  open_price;
@property (nonatomic, assign) CGFloat  close_price;
@property (nonatomic, assign) CGFloat  new_price;
@property (nonatomic, assign) CGFloat  max_price;
@property (nonatomic, assign) CGFloat  min_price;
@property (nonatomic, assign) CGFloat  buyPrice;
@property (nonatomic, assign) CGFloat  sellPrice;

@property (nonatomic, assign) CGFloat  ma5_price;
@property (nonatomic, assign) CGFloat  ma10_price;
@property (nonatomic, assign) CGFloat  ma20_price;

/** 分时均价 */
@property (nonatomic, assign) CGFloat avg_price;
/** 成交量 */
@property (nonatomic, assign) NSInteger total;
/** 排序编号 */
@property (nonatomic, assign) NSInteger number;
/** 默认组号 */
@property (nonatomic, assign) NSInteger section;
/** 修改后的组号 */
@property (nonatomic, assign) NSInteger current_section;

/** 这是k线用的参数 */
@property (nonatomic, assign) NSInteger date;
@property (nonatomic, assign) CGFloat money;
@property (nonatomic, assign) CGFloat nationalDebtRatio;
@property (nonatomic, assign) CGFloat EMA12;
@property (nonatomic, assign) CGFloat EMA26;
@property (nonatomic, assign) CGFloat DIF; // =EMA12 - EMA26
@property (nonatomic, assign) CGFloat DEA;
@property (nonatomic, assign) CGFloat MACD;

@property (nonatomic, assign) CGFloat SMA6MAX;
@property (nonatomic, assign) CGFloat SMA12MAX;
@property (nonatomic, assign) CGFloat SMA24MAX;

@property (nonatomic, assign) CGFloat SMA6ABS;
@property (nonatomic, assign) CGFloat SMA12ABS;
@property (nonatomic, assign) CGFloat SMA24ABS;

@property (nonatomic, assign) CGFloat RSI1;
@property (nonatomic, assign) CGFloat RSI2;
@property (nonatomic, assign) CGFloat RSI3;

@property (nonatomic, assign) CGFloat K;
@property (nonatomic, assign) CGFloat D;
@property (nonatomic, assign) CGFloat J;

@property (nonatomic, assign) CGFloat totalPrice; //分时数组的最后一个, 需保存此属性
@property (nonatomic, assign) NSInteger totalNumber; //分时数组的最后一个, 需保存此属性

/** 这是k线用的参数 */


/** 传入2个结构体, 取大宗model */
+ (IndexModel *)readIndexWithCommRealTimeData:(CommRealTimeData)commRealTimeData
                             andHSWHRealTime2:(HSWHRealTime2)hSWHRealTime2;

/** 传入2个结构体, 取外汇model */
+ (IndexModel *)readIndexWithCommRealTimeData:(CommRealTimeData)commRealTimeData
                             andHSWHRealTime:(HSWHRealTime)hSWHRealTime;

/** 传入2个结构体, 取沪深指数model */
//+ (IndexModel *)readIndexWithCommRealTimeData:(CommRealTimeData)commRealTimeData
//                              HSIndexRealTime:(HSIndexRealTime)hSWHRealTime;

/** 传入2个结构体, 取单个分时model */
//+ (IndexModel *)readTimeSharingModelWithAnsTrendData2:(AnsTrendData2)ansTrendData2
//                                        PriceVolItem2:(PriceVolItem2)priceVolItem2;

/** 传入2结构体, 取单个分时历史model */
//+ (IndexModel *)readTimeSharingHistoryModelWithAnsHisTrend2:(AnsHisTrend2)ansHisTrend2
//                                       StockCompHistoryData:(StockCompHistoryData)stockCompHistoryData;

/** 传入2个结构体, 取k线model */
+ (IndexModel *)readKLineModelWithStockCompDayDataEx:(StockCompDayDataEx)stockCompDayDataEx;
@end
