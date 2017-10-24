//
//  ChooseImgView.m
//  isInvested
//
//  Created by Ben on 16/8/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "ChooseImgView.h"
#import "WCLActionSheet.h"
#import "WCLImagePicker.h"

@interface ChooseImgView ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WCLActionSheetDelegate,WCLImagePickerDelegate>

@end

@implementation ChooseImgView

- (instancetype)initWithFrame:(CGRect)frame WithTarget:(UIViewController *)target Title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpMyViewWithTitle:(NSString *)title];
        self.isAllowEdit = YES;
        self.target = target;
    }
    return self;
}

-(void)setUpMyViewWithTitle:(NSString *)title{

    CGFloat W = self.frame.size.width;
    CGFloat H = W * 286 / 534.0;
    
    _titleBtn = [[UIButton alloc] init];
    _titleBtn.frame = CGRectMake(0, 0,W,H);
    [_titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_titleBtn addTarget:self action:@selector(chooseImg) forControlEvents:UIControlEventTouchUpInside];
    [_titleBtn setBackgroundImage:[UIImage imageNamed:@"addCardImg"] forState:UIControlStateNormal];    
    [self addSubview:_titleBtn];
    _dataImgView = [[UIImageView alloc] initWithFrame:_titleBtn.bounds];
    _dataImgView.userInteractionEnabled = NO;
    [self addSubview:_dataImgView];
    
    CGFloat btnW = 30;
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(0, 0, btnW, btnW);
//    _cancelBtn.backgroundColor = [UIColor redColor];
    [_cancelBtn setImage:[UIImage imageNamed:@"edittext_close"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.center = CGPointMake(W - 10, 10);
    _cancelBtn.hidden = YES;
    [self addSubview:_cancelBtn];
    
    self.selfHeight = _titleBtn.bottom;
}


- (void)chooseImg{
    
    WCLActionSheet *actionSheet = [[WCLActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相机",@"从相册选择", nil];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [actionSheet showInView:window];
}

-(void)cancelClick{
    
    _dataImgView.image = nil;
    _titleBtn.hidden = NO;
    _cancelBtn.hidden = YES;
}

#pragma -mark WCLActionSheetDelegate
- (void)actionImageSheet:(WCLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    WCLImagePicker *imagePicker = [WCLImagePicker sharedInstance];
    imagePicker.delegate = self;
    CGFloat scale = (_dataImgView.height / _dataImgView.width);
    [imagePicker showImagePickerWithType:buttonIndex InViewController:self.target heightCompareWidthScale:(scale) isCropImage:YES];
    
}
#pragma -mark WCLImagePickerDelegate
- (void)imagePicker:(WCLImagePicker *)imagePicker didFinished:(UIImage *)editedImag{
    
    self.dataImgView.image = [UIImage imageWithData:UIImageJPEGRepresentation(editedImag, 0.001)];
    
        if (_dataImgView.image != nil) {
            _titleBtn.hidden = YES;
            _cancelBtn.hidden = NO;
            _dataImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            _dataImgView.layer.borderWidth = 1;
        }

};


@end
