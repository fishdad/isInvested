//
//  SearchViewController.m
//  isInvested
//
//  Created by Blue on 16/10/9.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "IndexModel.h"

@interface SearchViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy  ) NSArray *titles;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *data;
@property (strong, nonatomic) NSMutableArray<IndexModel *> *originData;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"    广东贵金属交易中心", @"    伦敦金", @"    参考行情"];
    
    self.data = [IndexTool searchPageAllIndexes];
    [self.tableView reloadData];
    self.originData = [IndexTool selectedIndexes];
}

#pragma mark - <UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil][0];
    }
    cell.model = self.data[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.data.count == 1 ? 1 : 29.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.data.count == 1) return nil;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 29)];
    label.font = FONT(12.0);
    label.textColor = OXColor(0x999999);
    label.text = self.titles[section];
    label.backgroundColor = OXColor(0xf0f0f0);
    return label;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 点击事件

- (IBAction)typing:(UITextField *)tf {
    
    [self.data removeAllObjects];
    
    if (tf.text.length) { //有搜索关键字
        [self.data addObject:[IndexTool searchModelByText:tf.text]];
    } else {
        self.data = [IndexTool searchPageAllIndexes];
    }
    [self.tableView reloadData];
}

- (IBAction)clickedClose {
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *array = [IndexTool selectedIndexes];
    [CacheTool saveSelectData:array]; //保存到缓存, 自选页会从缓存取data
    
    if ([self.originData compareIndexes:array] && self.refreshDataBlock) {
        self.refreshDataBlock();
    }
}

@end
