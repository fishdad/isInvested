//
//  MyCenterViewController.m
//  isInvested
//
//  Created by Ben on 16/8/12.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MyCenterViewController.h"
#import "SwitchTableViewCell.h"
#import "LockController.h"
#import "NickNameViewController.h"
#import "SignerViewController.h"
#import "NormalInfoViewController.h"
#import "IINavigationController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <AVFoundation/AVFoundation.h>

@interface MyCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) UITableView *tv;
@property(nonatomic,strong) NSDictionary *dataDic;
@property(nonatomic,strong) NSString *nickName;//昵称
@property(nonatomic,strong) NSString *account;//账号

@property(nonatomic,strong) UIImageView *myImgView;

@end


@implementation MyCenterViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [_tv reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    //头像设置
     CGFloat myImgViewW = 60;
    _myImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - myImgViewW - 30, 10, myImgViewW, myImgViewW)];
    _myImgView.userInteractionEnabled = YES;
    
    [self initTv];
}

//tv初始化
-(void)initTv{
    
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_tv];
    
    WEAK_SELF
    _tv.delegate = weakSelf;
    _tv.dataSource = weakSelf;
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    
    CGFloat logoutX = 20;
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake(logoutX, 80, (WIDTH - logoutX * 2), 40)];
    [footView addSubview:logout];
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    [logout setBackgroundColor:[UIColor redColor]];
    logout.layer.masksToBounds = YES;
    logout.layer.cornerRadius = 3;
    
//    logout.layer.borderWidth = 1;
//    logout.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    _tv.tableFooterView = footView;
    
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
    
        //手机开启touchID
        _dataDic = @{@"0":@[@"头像",@"昵称",@"账号"],
                     @"1":@[@"手势密码",@"修改手势密码"],
                     @"2":@[@"指纹解锁"]};

    }else{
        
        //手机没有开启touchID
        _dataDic = @{@"0":@[@"头像",@"昵称",@"账号"],
                     @"1":@[@"手势密码",@"修改手势密码"],};
    }
}

-(NSString *)nickName{
    
    _nickName = [NSUserDefaults objectForKey:NickName];
    
    return _nickName;
}

-(NSString *)account{
    
    _account = [NSUserDefaults objectForKey:Account];
    
    return _account;
}

-(void)logout:(UIButton *)btn{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出登录?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        LOG(@"退出登录清理 ~~");
        [[DealSocketTool shareInstance] cutOffSocket];
        [NSUserDefaults setObject:@"登录/注册" forKey:NickName];
        [NSUserDefaults setObject:@"" forKey:mobilePhone];
        [NSUserDefaults setObject:@"" forKey:PhoneNum];
        [NSUserDefaults setObject:@"" forKey:UserID];
        [NSUserDefaults setBool:NO forKey:isLogin];
        [NSUserDefaults setObject:@"" forKey:KHAccount];
        [NSUserDefaults setObject:@"" forKey:KHSignAccount];
        [NSUserDefaults setBool:NO forKey:isOpenAccount];
        [NSUserDefaults setBool:NO forKey:isBangDingAccount];
        [NSUserDefaults setBool:NO forKey:@"ChkCertStatus"];
        [NSUserDefaults setObject:[NSDate dateWithTimeIntervalSinceNow:(- 60 * 30)] forKey:LastOpenTime];//保存时间
        [NSUserDefaults setObject:@"" forKey:OpenAccountStatus];//当前账号的开户状态清空
        [NSUserDefaults setBool:NO forKey:isSinaAccountBangding];//新浪支付绑卡清空
        [NSUserDefaults setObject:@"" forKey:SinaBangdingBank];//绑卡银行
        [NSUserDefaults setObject:@"" forKey:SinaBangdingBankCard];//绑卡卡号
        [NSUserDefaults setObject:@"" forKey:SinaBangdingbankCardID];//绑定的银行卡ID
        [NSUserDefaults setObject:@"" forKey:certNo];
        [NSUserDefaults setObject:@"" forKey:IDCardName];
        [NSUserDefaults setObject:@"" forKey:KHEmail];//邮箱
        [NSUserDefaults setObject:@"" forKey:riskTestName];//风险测评上传成功
        [NSUserDefaults setObject:@"" forKey:certFrontScanName];//身份证正面上传成功
        [NSUserDefaults setObject:@"" forKey:certBackScanName];//身份证背面上传成功
        [DealSocketTool shareInstance].LoginPassWordStr = @"";//socket登录密码清空
        [[DealSocketTool shareInstance] cutOffSocket];//断开连接
        [DealSocketTool shareInstance].errorPassWordCount = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoOpenAccount" object:nil];
        NSString *signKey = [NSString stringWithFormat:@"SIGNRESULTNOTIFYQUERY%@",[NSUserDefaults objectForKey:UserID]];
        [NSUserDefaults setBool:NO forKey:signKey];
        [NSUserDefaults setObject:nil forKey:@"errorPassWordTime"];//保存时间
        [NSUserDefaults setObject:@(0) forKey:@"errorCount"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- tv的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataDic.allKeys.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        //打开指纹解锁再显示修改手势
         BOOL isNow = [NSUserDefaults boolForKey:[Util isSHPassWord]];
        
        if (isNow == NO) {
            return 1;
        }else{
        
        return [_dataDic[[NSString stringWithFormat:@"%li",section]] count];
        }
    }else{
    
        return [_dataDic[[NSString stringWithFormat:@"%li",section]] count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }else{
        
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }else{
        return 0.1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 15;
    }else{
        return 15;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell ;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    
    //头像
    if ((indexPath.section == 0 && indexPath.row == 0)){
    
        _myImgView.layer.masksToBounds = YES;
        _myImgView.layer.cornerRadius = _myImgView.width / 2.0;
        
        NSString *urlStr = [NSUserDefaults objectForKey:PhotoImgUrl];
        [[SDImageCache sharedImageCache]removeImageForKey:urlStr];
        UIImage * headImage = [Util getUserHeaderImage];
        [_myImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:headImage];
        [cell.contentView addSubview:_myImgView];
        
    }
    
    //手势密码
    if ((indexPath.section == 1 && indexPath.row == 0)) {
        
        BOOL isNow = [NSUserDefaults boolForKey:[Util isSHPassWord]];
        
        cell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil switchOn:isNow switchBlock:^(BOOL isON) {
            
            if (isON == YES) {
                
//                //判断是否开户
//                BOOL openAccount = [NSUserDefaults boolForKey:isOpenAccount];
//                if (openAccount != YES) {
//                
//                    //未开户
//                    NormalInfoViewController *normalVC = [[NormalInfoViewController alloc] init];
//                    IINavigationController*normalNVC = [[IINavigationController alloc] initWithRootViewController:normalVC];
//                    [self presentViewController:normalNVC animated:YES completion:nil];
//                    
//                }
                
                //是否开户签约(以最后的签约为准)
                BOOL sign = [NSUserDefaults boolForKey:isSinaAccountBangding];// 是否新浪支付签约
                if (sign != YES) {
                    [Util goToDeal];
                    [Util alertViewWithMessage:@"请首先完成开户操作" Target:self];
                    return;
                }else{
                
                    //已开户+身份验证
                    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:[Util passwordtwo]];
                    
                    if (password == nil) {
                        LockController *vc = [[LockController alloc] initWithLockType:LockTypeReSet];
                        vc.signerFromType = SignerFromTypeSHSet;
                        vc.appearType = LockAppearTypePush;
                        vc.returnBlock = ^(BOOL isSuccess){
                            
                            [NSUserDefaults setBool:isSuccess forKey:[Util isSHPassWord]];
                        };
                        
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        //身份验证
                        SignerViewController *vc = [[SignerViewController alloc]init];
                        vc.signerType = SignerTypeNone;
                        vc.appearType = AppearTypePush;
                        
                        vc.returnBlock = ^(BOOL isSuccess){
                            
                            [NSUserDefaults setBool:isSuccess forKey:[Util isSHPassWord]];
                        };
                        
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }

                }
                
            }else{
            
                 [NSUserDefaults setBool:NO forKey:[Util isSHPassWord]];
            }
            
            [self.tv reloadData];
            LOG(@"手势密码:%i",isON);
            
        }];
    }
    
    //指纹解锁
    if ((indexPath.section == 2 && indexPath.row == 0)) {
        
        BOOL isNow = [NSUserDefaults boolForKey:[Util isTouchIDPassWord]];
        
        cell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil switchOn:isNow switchBlock:^(BOOL isON) {
            
            if (isON == YES) {
                
//                //判断是否开户
//                BOOL openAccount = [NSUserDefaults boolForKey:isOpenAccount];
//                if (openAccount != YES) {
//                    //未开户
//                    NormalInfoViewController *normalVC = [[NormalInfoViewController alloc] init];
//                    IINavigationController*normalNVC = [[IINavigationController alloc] initWithRootViewController:normalVC];
//                    [self presentViewController:normalNVC animated:YES completion:nil];
//                }
                
                //是否开户签约(以最后的签约为准)
                BOOL sign = [NSUserDefaults boolForKey:isSinaAccountBangding];// 是否新浪支付签约
                if (sign != YES) {
                    [Util goToDeal];
                    [Util alertViewWithMessage:@"请首先完成开户操作" Target:self];
                    return;
                }else{
                    //已开户+身份验证
                    SignerViewController *vc = [[SignerViewController alloc] init];
                    vc.signerType = SignerTypeNone;
                    vc.appearType = AppearTypePush;
                    vc.returnBlock = ^(BOOL isSuccess){
                        
                        [NSUserDefaults setBool:isSuccess forKey:[Util isTouchIDPassWord]];
                    };
                    
                    [self.navigationController pushViewController:vc animated:YES];

                }
                
            }else{
            
                [NSUserDefaults setBool:NO forKey:[Util isTouchIDPassWord]];
            }

            LOG(@"指纹解锁:%i",isON);
        }];
    }

    
    //昵称
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.detailTextLabel.text = self.nickName;
    }
    
    //账户
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.detailTextLabel.text = self.account;
    }
    
    //右侧箭头
    if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 0 && indexPath.row == 1)  || (indexPath.section == 1 && indexPath.row == 1)) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = _dataDic[[NSString stringWithFormat:@"%li",indexPath.section]][indexPath.row];
    cell.textLabel.font = FONT(15);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 && indexPath.row == 0) {
        //头像设置
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"本地相册", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }

    
    if (indexPath.section == 1 && indexPath.row == 1) {
        //手势解锁密码由手势密码验证
        LockController *lockVC = [[LockController alloc] initWithLockType:LockTypeReSet];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;
        lockVC.signerFromType = SignerFromTypeSHSet;
        lockVC.appearType = LockAppearTypePresent;
        IINavigationController*normalNVC = [[IINavigationController alloc] initWithRootViewController:lockVC];
        [self presentViewController:normalNVC animated:YES completion:nil];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        //昵称
        NickNameViewController *nickNameVC = [[NickNameViewController alloc] init];
        [self.navigationController pushViewController:nickNameVC animated:YES];
    }
}

#pragma mark ----- ActionSheet触发方法 -----
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 调用系统相机
    if (buttonIndex == 0)
    {
        // 如果有系统相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
           
            NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                NSString *errorStr = @"请在设备的“设置-隐私-相机”选项中，允许牛奶金服访问您的手机。";
                
                [Util alertViewWithMessage:errorStr Target:self];
                return;
            }

            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            //摄像头
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
        //如果没有系统相机提示用户
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您的设备没有摄像头" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
    // 调用系统相册
    if (buttonIndex == 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;//是否可以编辑
            //打开相册选择照片
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 模态进入相册
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

//4.#pragma mark - 拍摄完成后或者选择相册完成后自动调用的方法 -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 存入系统相册
    // UIImageWriteToSavedPhotosAlbum(backImageView.image, nil, nil, nil);
    
    //得到图片
    UIImage  *image = [info objectForKey:UIImagePickerControllerEditedImage];

    //此处处理头像上传
    UIImage *newImg = [self scaleFromImage:image];
    NSData *data = UIImageJPEGRepresentation(newImg, 0.5);
    NSString *imgDataBase64Front = [Util returnBase64StrByData:data];
    NSDictionary *params = @{@"base64":imgDataBase64Front,
                             @"userId":[NSUserDefaults objectForKey:UserID],
                             @"platType":@"3"};
    [HttpTool XLPost:UpLoadUserAvatarBase64 params:params success:^(id responseObj) {
        
        LOG(@"%@ : %@",responseObj[@"State"],responseObj[@"Descr"]);
        if ([responseObj[@"State"] intValue]== 1) {
            
            [Util setPhotoImgUrlWithHost:PhotoImgUrlWithHost];
            NSString *userImgData = [NSString stringWithFormat:@"%@userImgData",[NSUserDefaults objectForKey:UserID]];
            [NSUserDefaults setObject:data forKey:userImgData];
            _myImgView.image = [newImg circleImage];
            [HUDTool showText:@"头像上传成功"];
        }else{
            [HUDTool showText:responseObj[@"Descr"]];
        }
        // 模态返回
        [picker dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        
        LOG(@"头像上传失败:%@",error);
        [HUDTool showText:@"头像上传失败"];
        // 模态返回
        [picker dismissViewControllerAnimated:YES completion:nil];
        return ;
    }];
    
}


//==========================
// 图像压缩
//==========================
- (UIImage *)scaleFromImage:(UIImage *)image
{
    if (!image)
    {
        return nil;
    }
    NSData *data =UIImagePNGRepresentation(image);
    CGFloat dataSize = data.length/1024;
    CGSize size;
    
    if (dataSize<=50)//小于50k
    {
        return image;
    }else//
    {
        size = CGSizeMake(120, 120);
    }
    LOG(@"%f,%f",size.width,size.height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (!newImage)
    {
        return image;
    }
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
