//
//  PlayerModel.h
//  isInvested
//
//  Created by Blue on 16/8/31.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerModel : NSObject

/** 图片url */
@property (nonatomic, copy) NSString *Src;
/** 跳转地址 */
@property (nonatomic, copy) NSString *Link;
/** 标题 */
@property (nonatomic, copy) NSString *Title;
@end
