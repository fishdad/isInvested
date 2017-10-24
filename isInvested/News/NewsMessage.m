//
//  NewsMessage.m
//  isInvested
//
//  Created by Blue on 16/8/29.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NewsMessage.h"

#define kRed   OXColor(0xb03939)
#define kGreen OXColor(0x609c59)
#define kBlue  OXColor(0x2a87d0)

@implementation NewsMessage

- (NSString *)Finance_Time {
    return [_UpdateTime substringWithRange:NSMakeRange(11, 5)];
}

- (NSString *)days {
    return [_UpdateTime substringWithRange:NSMakeRange(0, 10)];
}

- (NSString *)News_Content {
    _News_Content = [_News_Content separatedByArray:@[@"<b>", @"</b>", @"<br />"]];
    return [self.Finance_Time stringByAppendingFormat:@" %@", _News_Content];
}

- (NSMutableAttributedString *)content {

    NSMutableAttributedString *attributedStr;
    
    if (_Type == 0) { //普通news == 0
        attributedStr = [[NSMutableAttributedString alloc]initWithString:self.News_Content];
        
    } else { //财经news, 底部有 前值 预期 实际 == 1
        NSString *str = [self.Finance_Time stringByAppendingFormat:@"  %@  %@", _Finance_Effect, _Finance_Name];
        attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        
        if (_Finance_Rank >= 3) { //标题变红色
            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:kRed
                                  range:NSMakeRange(0, attributedStr.length)];
        }
        
        if (_Finance_Effect.length) { //有"利多美元"等字样
            
            UIColor *textBgColor;
            if ([_Finance_Effect hasPrefix:@"利多"]) {
                textBgColor = kRed;
            } else if ([_Finance_Effect hasPrefix:@"利空"]) {
                textBgColor = kGreen;
            } else { //其它就是影响较小
                textBgColor = kBlue;
            }
            NSDictionary *textAttrs = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                         NSBackgroundColorAttributeName : textBgColor,
                                         NSFontAttributeName : FONT(13.0) };
            [attributedStr addAttributes:textAttrs range:NSMakeRange(6, 6)];
        }
    }
    
    // 所有类型, 开头的时间都是红色的
    // 重要消息, 全部都是红色的, 但不包括财经消息, 会与 "得多欧元"等字样冲突
    NSInteger length = [self.News_Important isEqualToString:@"0"] && !_Finance_Effect.length ? attributedStr.length : 5;
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:kRed
                          range:NSMakeRange(0, length)];
    return attributedStr;
}

- (NSMutableAttributedString *)grayContent {
    
    NSMutableAttributedString *grayContent = self.content;
    [grayContent addAttribute:NSForegroundColorAttributeName
                        value:NewsSelectColor
                        range:NSMakeRange(0, grayContent.length)];
    return grayContent;
}

- (CGFloat)textHeight {
    
    if (_textHeight) return _textHeight;
    
    _textHeight = [self.News_Content sizeWithFont:FONT(15.0) maxSize:CGSizeMake(WIDTH - 30, 54)].height + 0.5;
    return _textHeight;
}
- (CGFloat)textUnfoldHeight {
    
    if (_textUnfoldHeight) return _textUnfoldHeight;
    
    _textUnfoldHeight = [self.News_Content sizeWithFont:FONT(15.0) maxSize:CGSizeMake(WIDTH - 30, CGFLOAT_MAX)].height + 0.5;
    return _textUnfoldHeight;
}

- (CGFloat)cellHeight {
    
    if (_cellHeight) return _cellHeight;
    
    _cellHeight = 52.5;//12 + 10 + 20 + 10 + 0.5;
    if (!_Finance_Effect.length) {  //没有分享按钮, 加个判断, 以后要去掉
        _cellHeight -= 30;
    }
    _cellHeight += self.textHeight;
    return _cellHeight;
}
- (CGFloat)cellUnfoldHeight {
    
//    if (_cellUnfoldHeight) return _cellUnfoldHeight;此行必须注释
    
    _cellHeight = 52.5;//12 + 10 + 20 + 10 + 0.5;
    _cellHeight += self.textHeight;
    return _cellHeight;
}

- (NSString *)Finance_Before {
    return [@"前值:  " stringByAppendingString:_Finance_Before];
}

- (NSString *)Finance_Prediction {
    return [@"预期:  " stringByAppendingString:_Finance_Prediction];
}

- (NSString *)Finance_Result {
    return [@"实际:  " stringByAppendingString:_Finance_Result];
}

/** 交换2组高度值, 展开合并用 */
- (void)exchange2heightValue {
    
    self.textHeight       = self.textHeight + self.textUnfoldHeight;
    self.textUnfoldHeight = self.textHeight - self.textUnfoldHeight;
    self.textHeight       = self.textHeight - self.textUnfoldHeight;
    
    self.cellHeight       = self.cellHeight + self.cellUnfoldHeight;
    self.cellUnfoldHeight = self.cellHeight - self.cellUnfoldHeight;
    self.cellHeight       = self.cellHeight - self.cellUnfoldHeight;
}

#pragma mark - Dynamic Method

void exchange2heightValueIMP(id self, SEL _cmd) {
    [self exchange2heightValue];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    if (sel == @selector(exchange2heightValue)) {
        class_addMethod(self, sel, (IMP)exchange2heightValueIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

MJExtensionLogAllProperties
@end
