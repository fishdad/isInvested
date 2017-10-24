//
//  DrawTool.m
//  isInvested
//
//  Created by Blue on 16/10/25.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "DrawTool.h"

@implementation DrawTool

/** 画线段 */
+ (void)drawLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 0.25);
    [OXColor(0xd7d7d7) set];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    CGContextAddPath(ctx, path.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
}

/** 填充渐变色 */
+ (void)drawLinearGradient:(UIBezierPath *)path
                startColor:(UIColor *)startColor
                  endColor:(UIColor *)endColor {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    CGFloat locations[] = { 0.0, 1.0 };
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    //开始点&结束点
    CGRect pathRect = CGPathGetBoundingBox(path.CGPath);
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, path.CGPath);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
