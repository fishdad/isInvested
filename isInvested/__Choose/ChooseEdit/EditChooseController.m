//
//  EditChooseController.m
//  isInvested
//
//  Created by Blue on 16/10/9.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "EditChooseController.h"
#import "SearchViewController.h"
#import "EditChooseCell.h"
#import "IndexModel.h"

@interface EditChooseController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<IndexModel *> *data;
@property (strong, nonatomic) NSMutableArray<IndexModel *> *originData;
@end

@implementation EditChooseController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 1,从自选页进来 2,添加后进来, 故在此方法内, 从数据库内调用
    self.data = [IndexTool selectedIndexes];
    [self.tableView reloadData];
    
    if (!self.originData) self.originData = [NSMutableArray arrayWithArray:self.data];
}

- (void)viewDidLoad {
    
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    [super viewDidLoad];
    
    self.navigationItem.title = @"编辑自选";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickedItem:) title:@"完成"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickedItem:) title:@"添加"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    
    EditChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditChooseCell"];
    if (!cell) cell = [[NSBundle mainBundle] loadNibNamed:@"EditChooseCell" owner:self options:nil][0];
        
    cell.model = self.data[indexPath.row];
    
    cell.objc1 = ^(){ //删除
        [weakSelf.data removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    };
    cell.objc2 = ^(){ //置顶
        [weakSelf.data insertObject:weakSelf.data[indexPath.row] atIndex:0];
        [weakSelf.data removeObjectAtIndex:indexPath.row + 1];
        [tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.data removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.95;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.data exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

#pragma mark - 点击事件

- (void)clickedItem:(UIButton *)item {
    
    for (int i = 0; i < self.data.count; i++) {
        self.data[i].number = i;
    }
    [IndexTool saveWithSelectModels:self.data];
    [CacheTool saveSelectData:self.data]; //保存到缓存, 自选页会从缓存取data
    
    if ([item.currentTitle isEqualToString:@"完成"]) { //点击完成
        [self.navigationController popViewControllerAnimated:YES];
        
        if ([self.originData compareIndexes:self.data] && self.refreshDataBlock) {
            self.refreshDataBlock();
        }
        
    } else { //点击添加
        [self presentViewController:[[SearchViewController alloc] init] animated:YES completion:nil];
    }
}

- (IBAction)clickedClearAll {
    [self.data removeAllObjects];
    [self.tableView reloadData];
}

@end
