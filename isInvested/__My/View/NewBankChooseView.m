//
//  NewBankChooseView.m
//  isInvested
//
//  Created by Ben on 2016/12/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NewBankChooseView.h"
#import "NewBankTableViewCell.h"
#import "BankModel.h"

@interface NewBankChooseView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) NSArray *codeArr;
@property (nonatomic, strong) NSMutableArray *modelArr;

@end

@implementation NewBankChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpSubViews];
        
        _codeArr = @[@"BOC",@"ABC",@"CCB",@"ICBC",@"CITIC",@"CMBC",@"CIB",@"CEB",@"BOS"];
        _dic = @{
                  @"BOC"  :@[@"中国银行",@"入金:单笔1万,单日5万;出金:单笔5万,单日50万"],
                  @"ABC"  :@[@"农业银行",@"入金:单笔2万,单日5万;出金:单笔5万,单日50万"],
                  @"CCB"  :@[@"建设银行",@"入金:单笔2万,单日5万;出金:单笔5万,单日50万"],
                  @"ICBC" :@[@"工商银行",@"入金:单笔5万,单日5万;出金:单笔5万,单日50万"],
                  @"CITIC":@[@"中信银行",@"入金:单笔0.5万,单日5万;出金:单笔5万,单日50万"],
                  @"CMBC" :@[@"民生银行",@"入金:单笔5万,单日100万;出金:单笔5万,单日50万"],
                  @"CIB"  :@[@"兴业银行",@"入金:单笔2万,单日5万;出金:单笔5万,单日50万"],
                  @"CEB"  :@[@"光大银行",@"入金:单笔2万,单日5万;出金:单笔5万,单日50万"],
                  @"BOS"  :@[@"上海银行",@"入金:单笔0.5万,单日5万;出金:单笔5万,单日50万"]};
        
        _modelArr = [NSMutableArray arrayWithCapacity:1];
        for (NSString *code in _codeArr) {
            NSArray *arr = _dic[code];
            BankModel *model = [[BankModel alloc] initWithArr:arr];
            model.code = code;
            [_modelArr addObject:model];
        }

    }
    return self;
}

-(void)setUpSubViews{
    
    //黑色底部
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.7;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch)];
    [backView addGestureRecognizer:tap];
    [self addSubview:backView];
    
    //白板
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, WIDTH, 42);
    label.text = @"选择开户行";
    label.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat w = 42;
    btn.frame = CGRectMake(WIDTH - 15 - w, (42 - w) * 0.5, w, w);
    [btn setImage:[UIImage imageNamed:@"bankChooseCancel"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    label.userInteractionEnabled = YES;
    [label addSubview:btn];

    [label addSubview:[Util setUpLineWithFrame:CGRectMake(0, label.bottom - 0.5, WIDTH, 0.5)]];
    
    CGFloat y = 200;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, label.bottom, WIDTH, HEIGHT - y - label.height - 5) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [whiteView addSubview:_tableView];
    _tableView.estimatedRowHeight = 55;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    whiteView.frame = CGRectMake(0, y, WIDTH, HEIGHT - y);
    
    
    [_tableView registerClass:[NewBankTableViewCell class] forCellReuseIdentifier:@"myCell"];


}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _codeArr.count;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 55;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return ;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.model = _modelArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.chooseBank) {
        self.chooseBank(_codeArr[indexPath.row]);
    }
    [self removeFromSuperview];
}

-(void)tapTouch{
    [self removeFromSuperview];
}

-(void)btnClick:(UIButton *)btn{
    [self removeFromSuperview];
}

@end
