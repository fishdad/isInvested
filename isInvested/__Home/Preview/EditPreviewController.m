//
//  EditPreviewController.m
//  isInvested
//
//  Created by Blue on 16/8/30.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "EditPreviewController.h"
#import "PreviewCell.h"
#import "IndexModel.h"

@interface EditPreviewController ()

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<IndexModel *> *> *data;
@property (strong, nonatomic) NSMutableArray<IndexModel *> *originData;
@end

@implementation EditPreviewController

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"    交易品名称", @"    广东贵金属交易中心", @"    伦敦金", @"    参考行情"];
    }
    return _titleArr;
}

- (NSMutableArray *)data {
    
    if (!_data) {
        _data = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i++) {
            NSMutableArray<IndexModel *> *array = [IndexTool indexesWithSection:i];
            [_data addObject:array];
        }
    }
    return _data;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    for (int i = 0; i < self.data[0].count; i++) {
        self.data[0][i].number = i;
    }
    [IndexTool saveWithHomeModels:self.data[0]];
    
    if ([self.originData compareIndexes:self.data[0]] && self.refreshDataBlock) {
        self.refreshDataBlock();
    }
}

- (void)viewDidLoad {
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    [super viewDidLoad];
    
    self.view.backgroundColor = GrayBgColor;
    self.navigationItem.title = @"行情速览";
    
    self.originData = [self.data[0] copy];
    self.tableView.rowHeight = 55.0;
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PreviewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PreviewCell" owner:self options:nil][0];
    }
    //如果该子数组为空, 将不会显示, 直接返回cell
    if (!self.data[indexPath.section].count) return cell;
    
    cell.checked = !indexPath.section;
    cell.titleL.text = self.data[indexPath.section][indexPath.row].longName;
    WEAK_SELF
    cell.clickedSelectBlock = ^(BOOL selected){ //点击勾选的block
        if (!selected && weakSelf.data[0].count == 3) {
            [HUDTool showText:@"请至少保留3个!"];
            return;
        }
        if (selected && weakSelf.data[0].count == 6) {
            [HUDTool showText:@"最多能关注6个!"];
            return;
        }
        IndexModel *model = weakSelf.data[indexPath.section][indexPath.row];
        model.current_section = selected ? 0 : model.section;
        [IndexTool saveWithHomeModel:model];
        weakSelf.data = nil;
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.data[section].count ? 29.0 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!self.data[section].count) return nil;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 29)];
    label.font = FONT(12.0);
    label.textColor = OXColor(0x999999);
    label.text = self.titleArr[section];
    label.backgroundColor = OXColor(0xf0f0f0);
    return label;
}

#pragma mark - 拖动cell的方法

- (IBAction)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress {
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            if (!indexPath.section && indexPath) {
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
                    snapshot.alpha = 0.9;
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
            if (!indexPath.section && indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // 交换数组内数据和cell位置
                [self.data[0] exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
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
    UIImageView *snapshot = [[UIImageView alloc] initWithImage:image];
//    snapshot.layer.masksToBounds = NO;
//    snapshot.layer.cornerRadius = 0.0;
//    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
//    snapshot.layer.shadowRadius = 5.0;
//    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
