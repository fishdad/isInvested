//
//  UIImage+Extension.h
//  phone
//
//  Created by 吴峰 on 16/6/29.
//  Copyright © 2016年 吴峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/** 返回带圆角的image */
- (instancetype)circleImage;

/** 返回带圆角的image */
+ (instancetype)circleImage:(NSString *)name;

@end
