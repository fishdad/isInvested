//
//  NSDecimalNumber+Addtion.h
//  有应用应用
//
//  Created by xuliying on 15/10/15.
//  Copyright (c) 2015年 xly. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, type) {
    Add,
    subtract,
    multiply,
    divide
};
@interface NSDecimalNumber (Addtion)
+(NSDecimalNumber *)aDecimalNumberWithString:(NSString *)num1 type:(type)type anotherDecimalNumberWithString:(NSString *)num2;
+(NSComparisonResult)aDecimalNumberWithString:(NSString *)num1 compareAnotherDecimalNumberWithString:(NSString *)num2;

+(NSDecimalNumber *)aDecimalNumberWithNumber:(NSNumber *)num1 type:(type)type anotherDecimalNumberWithNumber:(NSNumber *)num2;
+(NSComparisonResult)aDecimalNumberWithNumber:(NSNumber *)num1 compareAnotherDecimalNumberWithNumber:(NSNumber *)num2;
@end
