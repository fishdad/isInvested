//
//  HomeHeaderView.m
//  isInvested
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "HomeHeaderView.h"

@implementation HomeHeaderView

- (instancetype)init {
    if (self = [super init]) {
        
        self.playerView = [[PlayerView alloc] init];
        [self addSubview:self.playerView];
        
        self.preview = [HomePreview viewFromXid];
        self.preview.y = self.playerView.bottom;
        [self addSubview:self.preview];
        
        self.eventView = [BigEventView viewFromXid];
        self.eventView.y = self.preview.bottom + kPadding;
        [self addSubview:self.eventView];
        
        self.titleView = [HomeTitleView viewFromXid];
        self.titleView.y = self.preview.bottom + kPadding;
        [self addSubview:self.titleView];
        
        self.width = WIDTH;
        self.height = self.titleView.bottom + 0.5;
    }
    return self;
}

@end
