//
//  MyTransferResultViewController.m
//  isInvested
//
//  Created by Ben on 16/9/19.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MyTransferResultViewController.h"
#import "ImgViewLblView.h"

@interface MyTransferResultViewController ()

@property (nonatomic, strong) ImgViewLblView *info;
@property (nonatomic, strong) ImgViewLblView *card;
@property (nonatomic, strong) ImgViewLblView *time1;
@property (nonatomic, strong) ImgViewLblView *time2;
@property (nonatomic, strong) UIView *line;//进度条的线
@property (nonatomic, strong) UILabel *priceLbl;

@end

@implementation MyTransferResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转账结果";
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       [self initSubViews];
    }
    return self;
}

-(void)initSubViews{

    CGFloat lblH = 40;
    _info = [[ImgViewLblView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, lblH)];
    _info.img = [UIImage imageNamed:@"deal_transerOK"];
    _info.label.text = @"转账申请已受理,当天到账";
    _priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(45, NH(_info) + 5, WIDTH, lblH)];
    _priceLbl.textColor = OXColor(0xec6a00);
    _priceLbl.font = BOLD_FONT(30);
    _card = [[ImgViewLblView alloc] initWithFrame:CGRectMake(0, NH(_priceLbl) + 5, WIDTH, lblH)];
    _card.img = [UIImage imageNamed:@"deal_transerCard"];
    [_card cardImgView];
//    _card.label.text = @"****银行卡号****";
    _card.label.text = [Util getCardStr];
    _time1 = [[ImgViewLblView alloc] initWithFrame:CGRectMake(0, NH(_card) + 15, WIDTH, lblH)];
    [_time1 imgViewTypeBorder:NO];
    
    _time1.label.text = [NSString stringWithFormat:@"提交时间: %@",[Util GetsTheCurrentTime]];
    _time1.label.textColor = OXColor(0xec6a00);
    _time2 = [[ImgViewLblView alloc] initWithFrame:CGRectMake(0, NH(_time1) + 5, WIDTH, lblH)];
    [_time2 imgViewTypeBorder:YES];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [formatter1 stringFromDate:[NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 2)]];
    _time2.label.text = [NSString stringWithFormat:@"预计到账: %@",strDate];
    _time2.label.textColor = OXColor(0x999999);
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(15 + 9, _time1.centerY, 2, 50)];
    _line.backgroundColor = OrangeBackColor;
    [self.view addSubview:_line];
    
     [self.view addSubview:_info];
     [self.view addSubview:_priceLbl];
     [self.view addSubview:_card];
     [self.view addSubview:_time1];
     [self.view addSubview:_time2];
    
    //下一步
    CGFloat x = 15;
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, NH(_time2) + 30, (WIDTH - 2 * x), 44)];
    loginBtn.tag = 101;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 3;
    loginBtn.backgroundColor = OrangeBackColor;
    [loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clickedBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];

}

//是否成功到账
-(void)setIsSuccessAmount:(BOOL)isSuccessAmount{

    if (isSuccessAmount) {
        _info.label.text = @"转账成功";
        _time2.hidden = YES;
        _line.hidden = YES;
        _time1.label.text = [NSString stringWithFormat:@"到账时间: %@",[Util GetsTheCurrentTime]];
    }
}

-(void)setPrice:(NSString *)price{

    _priceLbl.text = price;
}

-(void)clickedBack{

    if (self.okBlock) {
        self.okBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
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
