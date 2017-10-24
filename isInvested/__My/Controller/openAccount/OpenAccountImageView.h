//
//  OpenAccountImageView.h
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^voidBlock)();

@interface OpenAccountImageView : UIImageView

@property(nonatomic,copy) voidBlock openAccountBlock;//开户

@end
