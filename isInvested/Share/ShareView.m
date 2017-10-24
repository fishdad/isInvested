//
//  ShareView.m
//  isInvested
//
//  Created by Blue on 16/11/18.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ShareView.h"
#import "BottomMaskView.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation ShareView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.width = WIDTH;
    self.y = HEIGHT;
    
    [[[BottomMaskView alloc] init] setSubView:self];
}

- (IBAction)clickedShareButton:(UIButton *)button {
    
    [self shareWebPageToPlatformType:button.tag];
    [self performSelector:@selector(clickedCancel) withObject:nil afterDelay:0.5];
}

- (IBAction)clickedCancel {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.y = HEIGHT;
        
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.caption
                                                                             descr:self.model.content
                                                                         thumImage:self.model.imageUrl];
    //设置网页地址
    shareObject.webpageUrl = self.model.gotoUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"错误==%@",error);
            
            if (error.code == 2008) { //未安装提示
                [self alertWithType:platformType];
            }
            
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}

/** 未安装提示 */
- (void)alertWithType:(UMSocialPlatformType)platformType {
    
    NSString *message = [NSString stringWithFormat:@"未安装%@, 请安装后再分享", platformType < 3 ? @"微信" : @"QQ"];
    UIAlertController *alertC =
    [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
    
    UITabBarController *tabBarC = (UITabBarController *)self.window.rootViewController;
    [tabBarC.selectedViewController presentViewController:alertC animated:YES completion:nil];
}

@end
