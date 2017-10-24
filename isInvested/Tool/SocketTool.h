//
//  SocketTool.h
//  isInvested
//
//  Created by Blue on 16/10/13.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class IndexModel;

@interface SocketTool : NSObject

@property (nonatomic, strong) NSArray<IndexModel *> *indexes;
@property (nonatomic, assign) SocketRequestStyle requestStyle;

/** 手动断开tcp */
- (void)disconnect;

SingletonH(SocketTool)
@end
