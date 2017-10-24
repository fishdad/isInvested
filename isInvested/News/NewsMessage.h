//
//  NewsMessage.h
//  isInvested
//
//  Created by Blue on 16/8/29.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsMessage : NSObject

@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat cellHeight;
/** 文本展开高度 */
@property (nonatomic, assign) CGFloat textUnfoldHeight;
/** cell展开高度 */
@property (nonatomic, assign) CGFloat cellUnfoldHeight;

/** 开头的时间 */
@property (nonatomic, copy) NSString *Finance_Time;
/** 刷新用的时间 */
@property (nonatomic, copy) NSString *UpdateTime;
/** 短标题 */
@property (nonatomic, copy) NSString *Finance_Name;
/** 长标题 */
@property (nonatomic, copy) NSString *News_Content;
/** 处理后的标题 */
@property (nonatomic, copy) NSMutableAttributedString *content;
/** 点击后的标题 */
@property (nonatomic, copy) NSMutableAttributedString *grayContent;
/** 分享用的图片 */
@property (nonatomic, copy) NSString *News_ImageUrl;

/** 0:无3个参数, 1:有3个参数 */
@property (nonatomic, assign) NSInteger Type;


/** Type == 0 */
/** @"0",字体显示红色 */
@property (nonatomic, copy) NSString *News_Important;


/** Type == 1 */

/** 前4个有色字符 */
@property (nonatomic, copy) NSString *Finance_Effect;
/** 前4个有色字符的颜色 */
@property (nonatomic, copy) UIColor *Finance_Effect_color;
/** >=3 标题变红色 */
@property (nonatomic, assign) NSInteger Finance_Rank;

@property (nonatomic, copy) NSString *days;

/** 前值 */
@property (nonatomic, copy) NSString *Finance_Before;
/** 预期 */
@property (nonatomic, copy) NSString *Finance_Prediction;
/** 实际 */
@property (nonatomic, copy) NSString *Finance_Result;
/** 是否显示灰色 */
@property (nonatomic, assign) BOOL isShowGray;
@end

//ClassName = "政经要闻";
//"Finance_Before" = ""; 前值-------
//"Finance_Country" = "";
//"Finance_Effect" = "";  // 空值 , 没有"利空金银"几个字,  有值:取前2个字符, 为"影响", 显示"影响较小"--------
//"Finance_Name" = "";
//"Finance_Prediction" = "";预期----------
//"Finance_Rank" = 0;  >=3 为红色, 财经专用
//"Finance_Result" = "";实际--------------
//"Finance_Time" = "1900-01-01T00:00:00";---------------
//ID = 145459;
//Icon = "";
//"News_Content" = "【下周美油沥青是涨是跌，下周行情预测，行情分析】";----------
//"News_Effect" = "";
//"News_ImageUrl" = "http://open.cngold.com.cn/ueditor/net/upload/image/20160828/6360801661615593832035084.jpg";
//"News_Important" = 1;   0为红色----------
//"News_ReferUrl" = "";
//"News_VideoUrl" = "";
//Reading = "";
//Type = 0; 1有3个参数, 0没有3个参数
//UpdateTime = "2016-08-28 22:32:27";------------
