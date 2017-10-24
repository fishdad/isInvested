//
//  SignerViewController.h
//  isInvested
//
//  Created by Ben on 16/8/17.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"

typedef void(^ReturnBlock)(BOOL);

typedef NS_ENUM(NSInteger, UseForType) {
    UseForTypeSigner = 0,    //用于手势,指纹验证
    UseForTypeDeal = 1,   //用于交易验证
};

typedef NS_ENUM(NSInteger, SignerType) {
    SignerTypeNone = 0,    //不带指纹
    SignerTypeTouchID = 1,   //带指纹
};

typedef NS_ENUM(NSInteger, AppearType) {
    AppearTypeAddView = 0,    //添加视图
    AppearTypePresent = 1,   //模态
    AppearTypePush = 2,      //push
};



@interface SignerViewController : UIViewController

@property(nonatomic,strong) MyTextView *accountNum;
@property(nonatomic,strong) MyTextView *passWord2;
@property(nonatomic,assign) SignerType signerType;//是否带指纹
@property(nonatomic,assign) AppearType appearType;//出现方式
@property (nonatomic,assign) UseForType useForType;//用途类型
@property(nonatomic,copy) ReturnBlock returnBlock;//返回是否验证成功
@property(nonatomic,assign) BOOL   isAfter;//延时处理

@end
