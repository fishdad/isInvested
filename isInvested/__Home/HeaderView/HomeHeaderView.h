//
//  HomeHeaderView.h
//  isInvested
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"
#import "HomePreview.h"
#import "BigEventView.h"
#import "HomeTitleView.h"

@interface HomeHeaderView : UIView

@property (nonatomic, strong) PlayerView    *playerView;
@property (nonatomic, strong) HomePreview   *preview;
@property (nonatomic, strong) HomeTitleView *titleView;
@property (nonatomic, strong) BigEventView  *eventView;
@end
