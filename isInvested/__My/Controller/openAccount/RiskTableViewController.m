//
//  RiskTableViewController.m
//  XLApp
//
//  Created by 辛乐 on 16/9/6.
//  Copyright © 2016年 辛乐. All rights reserved.
//

#import "RiskTableViewController.h"
#import "UILabel+TextWidhtHeight.h"
#import "NormalInfoViewController.h"
#import "NSDictionary+NullKeys.h"
#import "AddOpenAccountFlowView.h"
#import "UploadCardImgViewController.h"

@interface RiskTableViewController ()
{

    CGPDFDocumentRef _pdf;
}
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSDictionary *waringDic;
@property (nonatomic, strong) NSMutableDictionary *chooseDic;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) NSString *writableDBPath;

@end

@implementation RiskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"完善开户资料";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = 0;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCell"];
    [self setUpTableViewHeaderView];
    [self setUpDataDic];
    [self setUpTableViewFooterView];
}

-(UILabel *)returnLabelByString:(NSString *)str WithWidth:(CGFloat)width Y:(CGFloat)y{

    UILabel *lbl = [[UILabel alloc] init];
    CGFloat height = [UILabel getHeightByWidth:width title:str font:FONT(16)];
    lbl.text = str;
    lbl.numberOfLines = 0;
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.font = FONT(16);
    lbl.textColor = [UIColor lightGrayColor];
    lbl.frame = CGRectMake(10, y, width, height);
    
    return lbl;
}

-(void)setUpTableViewHeaderView{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    AddOpenAccountFlowView *addView = [[AddOpenAccountFlowView alloc] initWithFrame:CGRectMake(15, 20, (WIDTH - 30), 44) SelectIndex:1];
    [view addSubview:addView];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.frame = CGRectMake(0, addView.bottom + 20, WIDTH, 44);
    titleLbl.text = @"投资风险承受能力评估";
    titleLbl.font = FONT(18);
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLbl];
    
    NSString *str = @"  尊敬的客户，请您认真填写以下测试题目，以便于我们评估您的风险承受能力，并据此提示您投资风险（包括是否适宜进行投资）。为确保测试的有效性，请您务必真实、完整、准确地填写。对于我们的评估意见及风险提示，您同意不持有异议。";
    CGFloat width = WIDTH - 20;
    UILabel *detailLbl = [self returnLabelByString:str WithWidth:width Y:titleLbl.bottom];
    [view addSubview:detailLbl];

    CGFloat viewH = detailLbl.bottom + 10;

    view.frame = CGRectMake(0, 0, WIDTH,viewH);
    self.tableView.tableHeaderView = view;
}

-(void)setUpTableViewFooterView{
    
    NSString *str = @"  本人保证上述所填信息为本人真实的意思表示，完全独立依据自身情况和判断做出上述答案，并接受贵司的评估意见和风险提示。同时确认如本人发生可能影响自身风险承受能力的情形，再次进行交易前必须主动要求贵司对本人进行风险承受能力评估，否则由此导致的一切后果由本人承担。";
    CGFloat width = WIDTH - 20;
    UILabel *detailLbl = [self returnLabelByString:str WithWidth:width Y:10];
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(10, NH(detailLbl) + 10, width, 44);
    [_btn setTitle:@"提交" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 3;
    _btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _btn.layer.borderWidth = 1;

   
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    CGFloat viewH = [UILabel getHeightByWidth:width title:str font:FONT(16)] + _btn.height + 40;
    view.frame = CGRectMake(0, 0, WIDTH,viewH);
    [view addSubview:detailLbl];
    [view addSubview:_btn];

    self.tableView.tableFooterView = view;
}

//生成PDF文件
-(NSData*)createPDFfromUIScrollView:(UIScrollView*)scrollView{
    
    NSMutableData*pdfData=[NSMutableData data];
    
    UIGraphicsBeginPDFContextToData(pdfData,(CGRect){0,0,scrollView.contentSize},nil);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0,0,scrollView.contentSize.width,scrollView.contentSize.height),nil);
    
    CGContextRef pdfContext=UIGraphicsGetCurrentContext();
    
    CGRect origSize=scrollView.frame;
    
    CGRect newSize = origSize;
    
    newSize.size=scrollView.contentSize;
    
    [scrollView setFrame:newSize];
    
    [scrollView.layer renderInContext:pdfContext];
    
    [scrollView setFrame:origSize];
    
    UIGraphicsEndPDFContext();
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"myPDF.pdf"];
    
    LOG(@"生成PDF路径:%@",path);

    [pdfData writeToFile:path atomically:YES];
    
    //读取pdf文件
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [fileHandle readDataToEndOfFile];
    
    return data;
}

//手机截屏
- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}

-(void)btnClick:(UIButton *)btn{

    if (_chooseDic.allKeys.count < 9) {
        
        [HUDTool showText:@"请完成投资风险承受能力评估"];
        return ;
    }
    
   
    for (int i = 0; i < 9; i ++) {
        
        //禁止选项
        NSString *chooseTitle = [NSString stringWithFormat:@"%i",i];
        NSArray *waringArr = _waringDic[chooseTitle];
        //已选项
        NSString *chooseStrD = _chooseDic[[NSString stringWithFormat:@"%i",i]];
        
        if ([waringArr containsObject:chooseStrD]) {
            [HUDTool showText:@"有不符合开户标准的选项,请重新选择"];
            return ;
        }
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"riskTest"]
                                                     ofType:@"html"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *pData = [fileHandle readDataToEndOfFile];
    NSString *HTMLString = [[NSString alloc] initWithData:pData encoding:NSUTF8StringEncoding];
    //百分号处理
    HTMLString = [HTMLString stringByReplacingOccurrencesOfString:@"%@" withString:@"*"];
    HTMLString = [HTMLString stringByReplacingOccurrencesOfString:@"%" withString:@"percent"];
    HTMLString = [HTMLString stringByReplacingOccurrencesOfString:@"*" withString:@"%@"];
    
    //风险测评的答案存放
    NSDictionary *answerDic = @{@"15":@"0",
                                @"16":@"1",
                                @"17":@"2",
                                @"18":@"3",
                                @"31":@"4",
                                @"32":@"5",
                                @"40":@"6",
                                @"41":@"7",
                                @"50":@"8",
                                @"51":@"9",
                                @"60":@"10",
                                @"61":@"11",
                                @"62":@"12",};
    NSMutableArray *chooseArr = [NSMutableArray arrayWithCapacity:1];
    for (NSString *section in @[@"1",@"3",@"4",@"5",@"6"]) {
        NSString *chooseKey = [NSUserDefaults objectForKey:[NSString stringWithFormat:@"Answer%@",section]];
        NSString *chooseValue = answerDic[chooseKey];
        [chooseArr addObject:chooseValue];
    }
    NSMutableArray *answerArr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 13; i++) {
        if ([chooseArr containsObject:[NSString stringWithFormat:@"%i",i]]) {
            
            [answerArr addObject:@"&#9745"];//选中
        }else{
        
            [answerArr addObject:@"&#9633"];//不选中
        }
    }
    
    HTMLString = [NSString stringWithFormat:HTMLString,answerArr[0],answerArr[1],answerArr[2],answerArr[3],answerArr[4],answerArr[5],answerArr[6],answerArr[7],answerArr[8],answerArr[9],answerArr[10],answerArr[11],answerArr[12]];
    HTMLString = [HTMLString stringByReplacingOccurrencesOfString:@"percent" withString:@"%"];
    NSData *data =[HTMLString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *pString = [Util returnBase64StrByData:data];
    
    //保存到本地查看
    {
    
        //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //    NSString *documentsDirectory = [paths objectAtIndex:0];
        //    NSString *path1 = [documentsDirectory stringByAppendingPathComponent:@"my.html"];
        //    LOG(@"生成html路径:%@",path1);
        //    NSData *data =[HTMLString dataUsingEncoding:NSUTF8StringEncoding];
        //    [data writeToFile:path1 atomically:YES];

    }
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
            //根据账号保存测试通过的风险测评
            NSString *ID = [NSUserDefaults objectForKey:UserID];
            [NSUserDefaults setObject:pString forKey:[NSString stringWithFormat:@"%@riskTest",ID]];
            UploadCardImgViewController *normalVC = [[UploadCardImgViewController alloc] init];
            normalVC.isNeedToUpLoadPDF = NO;
            [self.navigationController pushViewController:normalVC animated:YES];
        }else{
        
            [HUDTool showText:@"风险评估提交失败,请重新提交"];
            return ;
        }
        
    } failure:^(NSError *error) {
        
        [HUDTool showText:@"风险评估提交失败,请重新提交"];
        return ;
    }];
    
}

-(void)setUpDataDic{

    _dataArr = @[@"1、您的年龄是：",@"2、您的职业是：",@"3、您投资资金的来源是：",@"4、您能承受的最大投资损失为：",@"5、一般情况下，您的投资资金占个人总资产的多少：",@"6、您的每月固定支出约占月收入的比例是：",@"7、您对贵金属现货投资产品的了解程度：",@"8、您是否已阅读、理解并接受广东省贵金属交易中心制定的规则制度：",@"9、如因投资发生争议，您是否愿意提请中国广州仲裁委员会仲裁并接受其裁决结果："];
    
    _dataDic = @{@"1、您的年龄是：":@[@"A.不足18岁",@"B.18岁至59岁",@"C.60岁（含）以上"],
                 @"2、您的职业是：":@[@"A.公务员（或事业单位工作人员)",@"B.教师",@"C.学生",@"D.军人",@"E.媒体从业人员",@"F.企业高管",@"G.自由投资者",@"H.金融从业人员",@"I.其他"],
                 @"3、您投资资金的来源是：":@[@"A.借款",@"B.社保资金",@"C.自有资金"],
                 @"4、您能承受的最大投资损失为：":@[@"A.10%以下",@"B.10（含）- 30%",@"C.30%以上"],
                 @"5、一般情况下，您的投资资金占个人总资产的多少：":@[@"A.低于25%",@"B.26-50%",@"C.51-75%",@"D.76%以上"],
                 @"6、您的每月固定支出约占月收入的比例是：":@[@"A.0-35%",@"B.35-50%",@"C.51-100%",@"D.100%以上"],
                 @"7、您对贵金属现货投资产品的了解程度：":@[@"A.贵金属现货投资专业人士",@"B.对贵金属现货投资市场有充分认识，懂得投资技巧",@"C.对贵金属现货投资略有了解，懂得一定的投资技巧",@"D.对贵金属现货投资市场不熟悉，缺乏基本的投资知识"],
                 @"8、您是否已阅读、理解并接受广东省贵金属交易中心制定的规则制度：":@[@"A.是",@"B.否"],
                 @"9、如因投资发生争议，您是否愿意提请中国广州仲裁委员会仲裁并接受其裁决结果：":@[@"A.是",@"B.否"]};
    
    //不适合投资的{题号:选项[0:A依次下排]}
    _waringDic = @{@"0":@[@"0",@"2"],
                   @"1":@[@"0",@"1",@"2",@"3",@"4"],
                   @"2":@[@"0",@"1"],
                   @"3":@[@"0"],
                   @"4":@[@"2",@"3"],
                   @"5":@[@"2",@"3"],
                   @"6":@[@"3"],
                   @"7":@[@"1"],
                   @"8":@[@"1"]};
    
    //当前选择选项
    _chooseDic = [NSMutableDictionary dictionaryWithCapacity:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = _dataArr[section];
    NSArray *dataArr = _dataDic[key];
    return dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  [UILabel getHeightByWidth:self.view.frame.size.width - 20 title:_dataArr[section] font:FONT(18)] + 20;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = _dataArr[section];
    label.font =FONT(18);
    
    CGFloat height = [UILabel getHeightByWidth:self.view.frame.size.width - 20 title:_dataArr[section] font:FONT(18)];
    
    label.frame = CGRectMake(10, 10, self.view.frame.size.width - 20, height);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height + 20)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyCell"];
    
    // Configure the cell...
    NSString *key = _dataArr[indexPath.section];
    NSArray *dataArr = _dataDic[key];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = dataArr[indexPath.row];
    
    NSString *chooseTitle = [NSString stringWithFormat:@"%li",(long)indexPath.section];
    NSString *chooseStr = _chooseDic[chooseTitle];
    if ([chooseStr isEqualToString:[NSString stringWithFormat:@"%li",(long)indexPath.row]]) {
        cell.imageView.image = [UIImage imageNamed:@"risk_select"];
        //选中的再判断是否有效
        /////////////////////
        NSString *chooseStrD = [NSString stringWithFormat:@"%li",(long)indexPath.row];
        NSString *chooseTitleD = [NSString stringWithFormat:@"%li",(long)indexPath.section];
        NSArray *waringArr = _waringDic[chooseTitleD];
        
        if ([waringArr containsObject:chooseStrD]) {
           cell.textLabel.attributedText = [Util setFirstString:dataArr[indexPath.row] secondString:@"  *不符合开户标准" firsColor:[UIColor blackColor] secondColor:[UIColor redColor] firstFont:FONT(16) secondFont:FONT(12)];
        }else{
            cell.textLabel.text = dataArr[indexPath.row];
        }

    }else{
        cell.imageView.image = [UIImage imageNamed:@"risk_noSelect"];
    }

    
    cell.selectionStyle = 0;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *chooseStr = [NSString stringWithFormat:@"%li",(long)indexPath.row];
    
    NSString *chooseTitle = [NSString stringWithFormat:@"%li",(long)indexPath.section];
    NSArray *waringArr = _waringDic[chooseTitle];
    //保存当前选项
    [_chooseDic setObject:[NSString stringWithFormat:@"%li",(long)indexPath.row] forKey:[NSString stringWithFormat:@"%li",(long)indexPath.section]];
    
    if ([waringArr containsObject:chooseStr]) {
        [self.tableView reloadData];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSString *key = _dataArr[indexPath.section];
        NSArray *dataArr = _dataDic[key];
        cell.textLabel.attributedText = [Util setFirstString:dataArr[indexPath.row] secondString:@"  *不符合开户标准" firsColor:[UIColor blackColor] secondColor:[UIColor redColor] firstFont:FONT(16) secondFont:FONT(12)];
    }else{
    
        //用户可自主选择的选项
        if (indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6) {
            [NSUserDefaults setObject:[NSString stringWithFormat:@"%li%li",(long)indexPath.section,(long)indexPath.row] forKey:[NSString stringWithFormat:@"Answer%li",(long)indexPath.section]];
        }
        
        [self.tableView reloadData];
    }
}


@end
