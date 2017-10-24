//
//  CALayer+Extension.m
//  isInvested
//
//  Created by Blue on 16/10/25.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "CALayer+Extension.h"

@implementation CALayer (Extension)

- (void)setBorderUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
