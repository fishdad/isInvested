//
//  NickNameViewController.m
//  isInvested
//
//  Created by Ben on 16/8/15.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NickNameViewController.h"

@interface NickNameViewController ()

@property(nonatomic,strong) UITextField *NickNameText;
@property(nonatomic,strong) NSString *nickName;//昵称

@end

@implementation NickNameViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"昵称";
    
    self.view.backgroundColor = OXColor(0xf5f5f5);
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    whiteView.backgroundColor = OXColor(0xffffff);
    [self.view addSubview:whiteView];
    
    _NickNameText = [[UITextField alloc] initWithFrame:CGRectMake(15, 20, WIDTH -30, 44)];
    //文本编辑删除类型
    _NickNameText.backgroundColor = OXColor(0xffffff);
    _NickNameText.placeholder = @"请输入昵称,最大长度16位";
    //删除按钮的类型
    _NickNameText.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:_NickNameText];
    
    [self.view addSubview:[Util setUpLineWithFrame:CGRectMake(0, _NickNameText.y, WIDTH, 0.5)]];
    [self.view addSubview:[Util setUpLineWithFrame:CGRectMake(0, _NickNameText.bottom, WIDTH, 0.5)]];
    
    _NickNameText.text = self.nickName;
    [_NickNameText becomeFirstResponder];
    [self setNavigationBarButten];
}

-(NSString *)nickName{
    
    if ([NSUserDefaults objectForKey:NickName] == nil) {
        _nickName = @"牛奶金服";
    }else{
        
        _nickName = [NSUserDefaults objectForKey:NickName];
    }
    
    return _nickName;
}


//设置左右按钮
-(void)setNavigationBarButten{
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtn)];
    
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtn)];
    
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)leftBtn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)rightBtn{
    
    [self.view endEditing:YES];
    if([Util isEmpty: _NickNameText.text]){
        [HUDTool showText:@"请输入您的昵称"];
        return ;
    }
    
    if(_NickNameText.text.length > 16){
        [HUDTool showText:@"昵称允许最大长度为16位"];
        return ;
    }
    
    //匹配是否包含敏感词
    NSString *nickNameStr = [_NickNameText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([Util CommentContent:nickNameStr SensitiveWords:@"管理员|分析师|投资顾问|客服|官方|讲师|主持|主讲"]) {
        [HUDTool showText:@"您输入的昵称包含敏感词或者特殊字符"];
        return ;
    }
    
    NSDictionary *params = @{@"uid":[NSUserDefaults objectForKey:UserID],
                             @"nickname":nickNameStr};
    [HttpTool XLGet:GET_UPDATENICKNAME params:params success:^(id responseObj) {
        
        NSDictionary *dic = responseObj;
        
        if([[dic objectForKey:@"State"] integerValue]==1){
            
            [NSUserDefaults setObject:_NickNameText.text forKey:NickName];
            [HUDTool showText:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        if([[dic objectForKey:@"State"] integerValue]==-1){
            [HUDTool showText:@"昵称不能为空"];
            return ;
        }
        if([[dic objectForKey:@"State"] integerValue]==-2){
            [HUDTool showText:@"包含非法字符或为空"];
            return ;
        }
        if([[dic objectForKey:@"State"] integerValue]==-3){
            [HUDTool showText:@"查询数据失败"];
            return ;
        }
        if([[dic objectForKey:@"State"] integerValue]==0){
            [HUDTool showText:@"未知错误"];
            return ;
        }
        
        
    } failure:^(NSError *error) {
        [HUDTool showText:@"保存失败,请稍后再试"];
        return ;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
