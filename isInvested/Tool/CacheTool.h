//
//  CacheTool.h
//  isInvested
//
//  Created by Blue on 16/12/29.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheTool : NSObject

+ (void)saveData:(id)obj withCode:(NSString *)code requestStyle:(SocketRequestStyle)style;

+ (id)fetchCacheWithCode:(NSString *)code requestStyle:(SocketRequestStyle)style;

+ (void)clearAllCache;


+ (void)saveSelectData:(id)obj;

+ (id)fetchSelectCache;

@end
