//
//  DetailsSuperController.m
//  isInvested
//
//  Created by Blue on 16/9/2.
//  Copyright © 2016年 Blue. All rights reserved.
//  4个明细页的父控制器

#import "DetailsSuperController.h"

@interface DetailsSuperController ()

@property (nonatomic, strong) NSArray *headerTitles;
@end

@implementation DetailsSuperController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView.sectionHeaderHeight = 25;
    self.tableView.separatorStyle = 0;
}

- (void)addTimer {};
- (void)removeTimer {};

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIButton *button = [[UIButton alloc] init];
    button.tag = section;
    button.adjustsImageWhenHighlighted = NO;
    button.titleLabel.font = FONT(12.0);
    button.backgroundColor = OXColor(0xf0f0f0);
    [button setTitleColor:OXColor(0x999999) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickedSectionHeader:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 24.5, WIDTH, 0.5)];
    line.backgroundColor = OXColor(0xe6e6e6);
    [button addSubview:line];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, WIDTH - 25 - 10, 0, 0);
    
    NSString *title = section < 3 ? [self.headerTitles[section] dateAppendingToday] : self.headerTitles[section];
    [button setTitle:title forState:UIControlStateNormal];
    
    NSString *image = [self.headerTitles[section] hasSuffix:@" "] ? @"deal_select_no" : @"deal_select_yes";
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    return button;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {}

- (void)clickedSectionHeader:(UIButton *)button {}

@end
