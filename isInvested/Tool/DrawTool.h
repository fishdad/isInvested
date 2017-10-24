//
//  DrawTool.h
//  isInvested
//
//  Created by Blue on 16/10/25.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawTool : NSObject

/** 画线段 */
+ (void)drawLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/** 填充渐变色 */
+ (void)drawLinearGradient:(UIBezierPath *)path
                startColor:(UIColor *)startColor
                  endColor:(UIColor *)endColor;
@end
