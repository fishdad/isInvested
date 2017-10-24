//
//  UploadCardImgViewController.m
//  isInvested
//
//  Created by Ben on 16/12/26.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "UploadCardImgViewController.h"
#import "AddOpenAccountFlowView.h"
#import "ChooseImgView.h"
#import "NSDictionary+NullKeys.h"

@interface UploadCardImgViewController ()
{

    ChooseImgView *imgView1;
    ChooseImgView *imgView2;
}

@end

@implementation UploadCardImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"完善开户资料";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    [self.view addSubview:scrollView];
    
    AddOpenAccountFlowView *addView = [[AddOpenAccountFlowView alloc] initWithFrame:CGRectMake(15, 20, (WIDTH - 30), 44) SelectIndex:2];
    [scrollView addSubview:addView];
    
    CGFloat x = 27;
    CGFloat imgW = WIDTH - 27 * 2;
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(15, addView.bottom + 20, WIDTH - 30, 30);
    label1.text = @"*请上传您的身份证正面照";
    [scrollView addSubview:label1];

    imgView1 = [[ChooseImgView alloc] initWithFrame:CGRectMake(x, label1.bottom + 5, imgW, 0) WithTarget:self Title:@"身份证正面"];
    imgView1.isAllowEdit = NO;
    imgView1.height = imgView1.selfHeight;
    imgView1.target = self;
    [scrollView addSubview:imgView1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(15, imgView1.bottom + 5, WIDTH - 30, 30);
    label2.text = @"*请上传您的身份证反面照";
    [scrollView addSubview:label2];
    
    imgView2 = [[ChooseImgView alloc] initWithFrame:CGRectMake(x , label2.bottom + 5, imgW, imgW) WithTarget:self Title:@"身份证反面"];
    imgView2.isAllowEdit = NO;
    imgView2.height = imgView2.selfHeight;
    imgView2.target = self;
    [scrollView addSubview:imgView2];
    
    //下一步
    x = 15;
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, imgView2.bottom + 10, (WIDTH - 2 * x), 44)];
    loginBtn.tag = 101;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 3;
    loginBtn.backgroundColor = OXColor(0xf5f5f5);
    [loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginBtn];

    
    scrollView.contentSize = CGSizeMake(WIDTH, loginBtn.bottom + 10);

}

//5.上传PDF文件(在风险测评提交页面)
-(void)upLoadRiskTest{
    
    //根据账号获取测试通过的风险测评
    NSString *ID = [NSUserDefaults objectForKey:UserID];
    NSString *pString = [NSUserDefaults objectForKey:[NSString stringWithFormat:@"%@riskTest",ID]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:@"UploadFile" forKey:@"method"];
    [params setObject:@"pdf" forKey:@"fileExt"];
    [params setObject:@"riskTest" forKey:@"fileName"];
    [params setValue:pString forKey:@"fileContent"];
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        NSString *riskTestStr = [responseObject handleNullObjectForKey:@"result"];
        
        if ([riskTestStr rangeOfString:@"pdf"].length > 0) {
            //风险测评上传成功
            [NSUserDefaults setObject:riskTestStr forKey:riskTestName];
            [self upLoadCertFrontScan];
        }else{
            
            [HUDTool showText:@"上传失败,请重试"];
            return ;
        }
        
    } failure:^(NSError *error) {
        
        [HUDTool showText:@"上传失败,请重试"];
        return ;
    }];
}

//6.上传身份证正面
-(void)upLoadCertFrontScan{
    
    //照片数据base64编码 最终字符串
    NSData *data = UIImageJPEGRepresentation(imgView1.dataImgView.image, 0.1);
    NSString *imgDataBase64Front = [Util returnBase64StrByData:data];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [params setObject:@"UploadFile" forKey:@"method"];
    [params setObject:@"jpeg" forKey:@"fileExt"];
    [params setObject:@"certFrontScan" forKey:@"fileName"];
    [params setObject:imgDataBase64Front forKey:@"fileContent"];
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        LOG(@"NormalInfoViewController%@",responseObject);
        
        NSString *certFrontScanStr = [responseObject handleNullObjectForKey:@"result"];
        
        if ([certFrontScanStr rangeOfString:@"jpeg"].length > 0) {
            //身份证正面上传成功
            [NSUserDefaults setObject:certFrontScanStr forKey:certFrontScanName];
            
            //7.上传身份证背面
            [self upLoadcertBackScan];                                            }
        else{
            [Util showHUDAddTo:self.view Text:@"身份证正面上传失败,请重新上传"];
            return ;
        }
        
        
    } failure:^(NSError *error) {
        
        [HUDTool showText:@"网络超时,请查看网络或者稍后再试"];
        LOG(@"certFrontScan%@",error);
    }];
    
}
//7.上传身份证背面
-(void)upLoadcertBackScan{
    
    NSData *data = UIImageJPEGRepresentation(imgView2.dataImgView.image, 0.1);
    
    NSString *imgDataBase64 = [Util returnBase64StrByData:data];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [params setObject:@"UploadFile" forKey:@"method"];
    [params setObject:@"jpeg" forKey:@"fileExt"];
    [params setObject:@"certBackScan" forKey:@"fileName"];
    [params setObject:imgDataBase64 forKey:@"fileContent"];
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        NSString *certBackScanStr = [responseObject handleNullObjectForKey:@"result"];
        
        if ([certBackScanStr rangeOfString:@"jpeg"].length > 0){
            //身份证背面上传成功
            [NSUserDefaults setObject:certBackScanStr forKey:certBackScanName];
           
            if (self.isUpdateScan == YES) {//修改上传资料
                //修改证件
                [self UpdateCert];
            }else{
                //上传附件
                [self submitAtt];
            }
        }else{
            
            [Util showHUDAddTo:self.view Text:@"身份证反面上传失败,请重新上传"];
            return ;
        }
        
    } failure:^(NSError *error) {
        
        LOG(@"certBackScan%@",error);
        
    }];
    
}

//8.上传附件
-(void)submitAtt{

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [params setObject:@"SubmitAtt" forKey:@"method"];
    [params setObject:[NSUserDefaults objectForKey:KHAccount] forKey:@"loginAccount"];
    [params setObject:[NSUserDefaults objectForKey:riskTestName] forKey:@"riskCheckFile"];
    [params setObject:@"1" forKey:@"riskCheckSign"];
    [params setObject:[NSUserDefaults objectForKey:certFrontScanName] forKey:@"certFrontScanName"];
    [params setObject:[NSUserDefaults objectForKey:certBackScanName] forKey:@"certBackScanName"];
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        NSDictionary *resultDic = responseObject;
        if ([[resultDic handleNullObjectForKey:@"errCode"] isEqual: @"99999"]){
            //保存开户账号和开户状态
            
            [self pushNextVC];
        }else{
            [Util showHUDAddTo:self.view Text:@"上传附件失败,请重新上传"];
            return ;
            
        }
        
    } failure:^(NSError *error) {
        
        LOG(@"certBackScan%@",error);
        
    }];

}

//9.证件修改
-(void)UpdateCert{


    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [params setObject:@"UpdateCert" forKey:@"method"];
    [params setObject:[NSUserDefaults objectForKey:KHAccount] forKey:@"loginAccount"];
    [params setObject:[NSUserDefaults objectForKey:certFrontScanName] forKey:@"certFrontScanName"];
    [params setObject:[NSUserDefaults objectForKey:certBackScanName] forKey:@"certBackScanName"];
    
    [HttpTool SOAPData:OpenAccountHOST soapBody:params success:^(id responseObject) {
        
        NSDictionary *resultDic = responseObject;
        if ([[resultDic handleNullObjectForKey:@"errCode"] isEqual: @"99999"]){
            //保存开户账号和开户状态
            [self pushNextVC];
        }else{
            [Util showHUDAddTo:self.view Text:@"证件修改失败,请重新上传"];
            return ;
            
        }
        
    } failure:^(NSError *error) {
        
        LOG(@"UpdateCert%@",error);
        
    }];
}

-(void)pushNextVC{

    [self.navigationController popToRootViewControllerAnimated:YES];
    [Util getDealViewControllerWithBlock:^(UIViewController *dealVC) {
        
        [Util alertViewWithMessage:@"提交成功，我们将尽快审核，请耐心等待" Target:dealVC];
    }];

}

-(void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 101) {
        
        //下一步
        if(imgView1.dataImgView.image == nil){
           [HUDTool showText:@"请上传您的身份证正面照片"];
            return ;
        }
        
        if(imgView2.dataImgView.image == nil){
            [HUDTool showText:@"请上传您的身份证反面照片"];
            return ;
        }
        
        if (self.isUpdateScan == YES) {//修改上传资料
            //不需要上传PDF文件
            [self upLoadCertFrontScan];
            return;
        }
        
        
        if (self.isNeedToUpLoadPDF) {
            //需要上传PDF
            [self upLoadRiskTest];
        }else{
            //不需要上传PDF文件
            [self upLoadCertFrontScan];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
