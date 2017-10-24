//
//  JHRingChart.h
//  JHChartDemo
//
//  Created by 简豪 on 16/7/5.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHChart.h"

@interface JHRingChart : JHChart
#define k_Width_Scale  (self.frame.size.width / [UIScreen mainScreen].bounds.size.width)
/*        值数组         */
@property (nonatomic,strong)NSArray * valueDataArr;

//#define k_COLOR_STOCK @[OXColor(0x48c9ff),OXColor(0xfb4c4c)]
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSArray *detailTitles;
@property (nonatomic, strong) NSArray *k_COLOR_STOCK;

@end
