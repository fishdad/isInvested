//
//  UIImage+Extension.m
//  phone
//
//  Created by 吴峰 on 16/6/29.
//  Copyright © 2016年 吴峰. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

/** 返回带圆角的image */
- (instancetype)circleImage {
    
    // 开启图形上下文
    UIGraphicsBeginImageContext(self.size);
    // 上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 绘制图片
    [self drawInRect:rect];
    // 获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

/** 返回带圆角的image */
+ (instancetype)circleImage:(NSString *)name {
    return [[self imageNamed:name] circleImage];
}

@end
