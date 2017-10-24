//
//  ImportantNewsMessage.m
//  isInvested
//
//  Created by Blue on 16/9/27.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ImportantNewsMessage.h"

@implementation ImportantNewsMessage

- (NSString *)Art_MediaAndTime {
    
    NSString *time = [self.Art_ShowTime substringWithRange:NSMakeRange(5, 11)];
    return [self.Art_Media_Name stringByAppendingFormat:@"  %@", time];
}

- (NSArray<NSString *> *)Art_Images {
    if (!_Art_Images) {
        _Art_Images = [self.Art_Image componentsSeparatedByString:@"|"];
    }
    return _Art_Images;
}

- (CGFloat)cellHeight {
    
    if (_cellHeight) return _cellHeight;
    
    if (self.Art_Images.count == 3) {
        _cellHeight = (WIDTH - 50) / 3 * 0.7 + 66;
    } else {
        _cellHeight = 90;
    }
    return _cellHeight;
}


- (NSString *)mediaAndTime {
    NSString *str = [@"yyyy-MM-dd HH:mm:ss" stringFromInterval1970: self.Art_ShowTime.doubleValue];
    return [self.Art_Media_Name stringByAppendingFormat:@"  %@", str];
}

- (NSString *)Art_VisitCount {
    return [@"阅读 " stringByAppendingString:_Art_VisitCount];
}



MJExtensionLogAllProperties
@end
