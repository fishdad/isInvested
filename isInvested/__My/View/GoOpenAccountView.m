//
//  GoOpenAccountView.m
//  isInvested
//
//  Created by Ben on 16/11/29.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "GoOpenAccountView.h"

@implementation GoOpenAccountView

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)awakeFromNib{

    [super awakeFromNib];
    self.goOpenBtn.layer.masksToBounds = YES;
    self.goOpenBtn.layer.cornerRadius = 3;
    [self hiddenYesOrNo:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenYesOrNo:) name:@"GoOpenAccount" object:nil];
}

-(void)hiddenYesOrNo:(NSNotification *) noti{

    BOOL isBangding = [NSUserDefaults boolForKey:isSinaAccountBangding];
    NSString *itemStr = noti.object;
    
    if ([itemStr isEqualToString:@"交易"] || [itemStr isEqualToString:@"YES"]) {
        self.hidden = YES;
    }else{
        self.hidden = isBangding;
    }
}




- (IBAction)goOpenBtn:(id)sender {
    
    [Util goToDeal];
}

@end
