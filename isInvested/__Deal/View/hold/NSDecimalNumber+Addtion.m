//
//  NSDecimalNumber+Addtion.m
//  有应用应用
//
//  Created by xuliying on 15/10/15.
//  Copyright (c) 2015年 xly. All rights reserved.
//

#import "NSDecimalNumber+Addtion.h"

@implementation NSDecimalNumber (Addtion)
+(NSDecimalNumber *)aDecimalNumberWithString:(NSString *)num1 type:(type)type anotherDecimalNumberWithString:(NSString *)num2{
    if (type == Add) {
        return [[NSDecimalNumber decimalNumberWithString:num1] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:num2]];
    }else if (type == subtract){
        return [[NSDecimalNumber decimalNumberWithString:num1] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:num2]];
    }else if (type == multiply){
        return [[NSDecimalNumber decimalNumberWithString:num1] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num2]];
    }else if (type == divide){
        return [[NSDecimalNumber decimalNumberWithString:num1] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:num2]];
    }else{
        return nil;
    }
    
}
+(NSComparisonResult)aDecimalNumberWithString:(NSString *)num1 compareAnotherDecimalNumberWithString:(NSString *)num2{
    return [[NSDecimalNumber decimalNumberWithString:num1] compare:[NSDecimalNumber decimalNumberWithString:num2]];
}

+(NSDecimalNumber *)aDecimalNumberWithNumber:(NSNumber *)num1 type:(type)type anotherDecimalNumberWithNumber:(NSNumber *)num2{
    if (type == Add) {
        return [[NSDecimalNumber decimalNumberWithDecimal:[num1 decimalValue]] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithDecimal:[num2 decimalValue]]];
    }else if (type == subtract){
        return [[NSDecimalNumber decimalNumberWithDecimal:[num1 decimalValue]] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithDecimal:[num2 decimalValue]]];
    }else if (type == multiply){
        return [[NSDecimalNumber decimalNumberWithDecimal:[num1 decimalValue]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[num2 decimalValue]]];
    }else if (type == divide){
        return [[NSDecimalNumber decimalNumberWithDecimal:[num1 decimalValue]] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithDecimal:[num2 decimalValue]]];
    }else{
        return nil;
    }
}
+(NSComparisonResult)aDecimalNumberWithNumber:(NSNumber *)num1 compareAnotherDecimalNumberWithNumber:(NSNumber *)num2{
    return [[NSDecimalNumber decimalNumberWithDecimal:[num1 decimalValue]] compare:[NSDecimalNumber decimalNumberWithDecimal:[num2 decimalValue]]];
}
@end
