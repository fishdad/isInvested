//
//  LockController.h
//  新华易贷
//
//  Created by 吴 凯 on 15/9/21.
//  Copyright (c) 2015年 吴 凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockView.h"
#import "UIView+XLFrame.h"

typedef void(^ReturnBlock)(BOOL);

typedef NS_ENUM(NSInteger, LockType) {
    LockTypeOpen = 0,    // 解锁
    LockTypeReSet = 1,   //设置
    LockTypeChangeSet = 2,   //重置
};

typedef NS_ENUM(NSInteger, SignerFromType) {
    SignerFromTypeDefault = 0,//默认
    SignerFromTypeSHSet = 1,//手势设置
    SignerFromTypeTouchIDSet = 2,   //指纹设置
};

typedef NS_ENUM(NSInteger, LockAppearType) {
    LockAppearTypeAddView = 0,    //添加视图
    LockAppearTypePresent = 1,   //模态
    LockAppearTypePush = 2,      //push
};


@interface LockController : UIViewController

@property(weak,nonatomic)LockView *lockview;
@property(nonatomic,assign) SignerFromType signerFromType;//来源处
@property(nonatomic,assign) LockAppearType appearType;//出现形势
@property(nonatomic,copy) ReturnBlock returnBlock;//返回是否验证成功

-(instancetype)initWithLockType:(LockType)lockType;

@end
