//
//  ChartSetRemindView.m
//  isInvested
//
//  Created by Blue on 16/9/23.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ChartSetRemindView.h"
#import "IQKeyboardManager.h"
#import "IndexModel.h"

@interface ChartSetRemindView ()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *percentL;

@property (weak, nonatomic) IBOutlet UITextField *priceUpTF;
@property (weak, nonatomic) IBOutlet UITextField *priceDownTF;

@property (weak, nonatomic) IBOutlet UIView *priceUpView;
@property (weak, nonatomic) IBOutlet UIView *priceDownView;
@end

@implementation ChartSetRemindView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.width = WIDTH;
    self.y = HEIGHT;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(reloadTitleViewData:) name:SocketRealTimeAndPushNotification object:nil];
    
    //禁止它移动导航栏
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    //键盘弹起的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)reloadTitleViewData:(NSNotification *)notification {
    
    NSArray<IndexModel *> *array = notification.userInfo[@"userInfo"];
    LOG(@"刷新底部弹窗view的数据----  数量==%ld   name==%@", array.count, array[0].name);
    
    //    自选页会主推多个品种, 在自选页断开连接之前会收到一个或多个主推
    //    如下判断可排除掉来自自选页的主推,
    if (array.count == 1 && [array[0].code isEqualToString:self.model.code]) {
        self.model = array[0];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(IndexModel *)model {
    _model = model;
    
    self.nameL.text = model.name;
    self.priceL.text = [NSString stringWithFormat:@"%.2f", model.new_price / model.priceunit];
    self.percentL.text = [NSString stringWithFormat:@"%.2f%%", model.fluctuation_percent];
    
    self.priceL.textColor = OXColor(model.color);
    self.percentL.textColor = OXColor(model.color);
}

#pragma mark - 键盘通知方法

- (void)keyboardWillShow:(NSNotification *)noti {
    
    //tf相对于window的坐标
    CGPoint point = [self.priceDownTF convertPoint:self.priceDownTF.bounds.origin toView:nil];
    //最终突出部分的高度
    CGFloat protrusionH = point.y - self.y + self.priceDownTF.height;
    
    // 获取键盘y值
    NSDictionary *dict = noti.userInfo;
    CGFloat keyboardY = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    self.y = keyboardY - protrusionH;
}

- (void)keyboardWillHide {
    self.y = HEIGHT - self.height;
}

#pragma mark - 点击事件

- (IBAction)clickedUpB:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.priceUpView.userInteractionEnabled = sender.selected;
    
    if (sender.selected) {
        [self.priceUpTF becomeFirstResponder];
    } else {
        self.priceUpTF.text = @"";
    }
}

- (IBAction)clickedDownB:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.priceDownView.userInteractionEnabled = sender.selected;
    
    if (sender.selected) {
        [self.priceDownTF becomeFirstResponder];
    } else {
        self.priceDownTF.text = @"";
    }
}

/** 涨到-1 */
- (IBAction)clickedPriceUpMinus {
    self.priceUpTF.text = self.priceUpTF.text.minus1ByMinValueIs0;
}
/** 跌到-1 */
- (IBAction)clickedPriceDownMinus {
    self.priceDownTF.text = self.priceDownTF.text.minus1ByMinValueIs0;
}

/** 涨到+1 */
- (IBAction)clickedPriceUpPlus {
    self.priceUpTF.text = self.priceUpTF.text.plus1ByMaxValueIs99999point99;
}
/** 跌到+1 */
- (IBAction)clickedPriceDownPlus {
    self.priceDownTF.text = self.priceDownTF.text.plus1ByMaxValueIs99999point99;
}

/** 限制输入长度 */
- (IBAction)limitLength:(UITextField *)sender {
    sender.text = sender.text.priceByTenThousand;
}

- (IBAction)clickedCancel {
    [self disappear];
}

- (IBAction)clickedFinish {
    
    if (self.clickedFinishBlock) {
        self.clickedFinishBlock();
    }
    [self disappear];
}

- (void)disappear {
    [UIView animateWithDuration:0.25 animations:^{
        self.y = HEIGHT;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

@end
