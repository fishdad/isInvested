//
//  CalendarMessage.h
//  isInvested
//
//  Created by admin on 16/8/26.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarMessage : NSObject

/**
 * 高:3颗红星
 * 中:2颗蓝星
 * 低:1颗蓝星
 */
@property (nonatomic, copy) NSString *Finance_Importance;
/** 国家代码 */
@property (nonatomic, copy) NSString *Country_Code;
/** 标题 */
@property (nonatomic, copy) NSString *Finance_Title;
/** 时间 */
@property (nonatomic, copy) NSString *Finance_Time;
/** 正文 */
@property (nonatomic, copy) NSString *Finance_Content;
/** 前值 */
@property (nonatomic, copy) NSString *Finance_Before;
/** 预测 */
@property (nonatomic, copy) NSString *Finance_Prediction;
/** 公布, 空值显示"侦测中" */
@property (nonatomic, copy) NSString *Finance_Result;

@property (nonatomic, copy) NSString *FinanceUrl;

/** 已公布/侦测中 */
@property (nonatomic, copy) NSString *result;
@property (nonatomic, assign) NSInteger signColor;
@property (nonatomic, copy) NSString *starPicName;
@end

//{
//    "Country_Code" = US;
//    "Country_ID" = 6;
//    "Country_Name" = "美国";
//    "Currency_Name" = "美元";
//    FinanceUrl = "http://m.cngold.com.cn/app/calendar.aspx?Country_ID=6&Keyword_ID=281";
//    "Finance_Before" = "106.1";
//    "Finance_Change" = "";
//    "Finance_Content" = "密歇根大学公布，密歇根大学消费者信心指数旨在反映消费者对美国经济的态度和预期，估量消费者对经济环境改变的感觉。报告中的消费者预期指数为美国官方领先经济指标的组成部分。密歇根大学消费者信心调查以其时效性著称，被认为是美国消费者信心中最及时的指标之一。总体上讲，如数据高于预期将利好美元；反之，数据低于预期将利空美元。<br/><br/>月报，每月中旬公布当月数据初值，每月下旬公布当月数据终值";
//    "Finance_ID" = 62389;
//    "Finance_Importance" = "中";
//    "Finance_Prediction" = "";
//    "Finance_Result" = "";
//    "Finance_Time" = "2016-08-26T22:00:00";
//    "Finance_Title" = "8月密歇根大学现况指数终值";
//    "Keyword_ID" = 281;
//}
