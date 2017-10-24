//
//  NSObject+Extension.m
//  isInvested
//
//  Created by Blue on 2017/3/1.
//  Copyright © 2017年 Blue. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/message.h>

@implementation NSObject (Extension)

- (void)setObjc1:(id)objc1 {
    objc_setAssociatedObject(self, @"objc1", objc1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)objc1 {
    return objc_getAssociatedObject(self, @"objc1");
}

- (void)setObjc2:(id)objc2 {
    objc_setAssociatedObject(self, @"objc2", objc2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)objc2 {
    return objc_getAssociatedObject(self, @"objc2");
}

@end
