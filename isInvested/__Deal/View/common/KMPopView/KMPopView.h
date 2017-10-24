//
//  KMPopView.h
//  MakerMap
//
//  Created by kevin on 16/3/26.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, PopType) {
//    PopTypeAdd  = 0,//涨
//    PopTypeDel  = 1,//跌
//    PopTypeLevel  = 2,//平仓
//   
//};


typedef void(^PopViewBlock)(NSInteger index);
@interface KMPopView : UIView

+ (KMPopView *)popWithType:(BuyOrderType) type PriceType:(PriceOrderType)priceType Title:(NSString *)title DetailTitleLabels:(NSArray *)detailTitleLabels DetailValueLabels:(NSArray *)detailValueLabels sureBtn:(NSString *)suerStr cancel:(NSString *)cancelStr block:(void(^)(NSInteger index))block canTapCancel:(BOOL)canTap;

- (void)show;
@end
