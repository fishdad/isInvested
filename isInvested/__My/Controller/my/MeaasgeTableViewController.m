//
//  MeaasgeTableViewController.m
//  isInvested
//
//  Created by Ben on 16/11/10.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "MeaasgeTableViewController.h"
#import "MessageTableViewCell.h"
#import "MessageDetailTableViewController.h"

@interface MeaasgeTableViewController ()

@end

@implementation MeaasgeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息提醒";
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"messageCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        cell.titleLbl.text = @"交易提醒";
        cell.timeLbl.text = @"12:34";
        cell.detaiTitleLbl.text = @"粤贵银(kg)已下跌到您设置的3480.00元,请关注...";
    }else{
    
        cell.titleLbl.text = @"行情提醒";
        cell.timeLbl.text = @"12:34";
        cell.detaiTitleLbl.text = @"【上涨提醒】粤贵银（kg）47分钟内容已经上涨1.78%，多单盈利空间22.25%（空单注意风险）；请及时关注。";

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MessageDetailTableViewController *VC = [[MessageDetailTableViewController alloc] init];
    VC.type = indexPath.row;
    [self.navigationController pushViewController:VC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
