//
//  HomePreview.m
//  isInvested
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 Blue. All rights reserved.
//  粤贵银、粤贵钯、粤贵铂、美元指数、现货黄金、现货白银

#import "HomePreview.h"
#import "IndexModel.h"
#import "IndexRectangleCell.h"
#import "ChartDetailsController.h"
#import "EditPreviewController.h"
#import "SocketTool.h"

@interface HomePreview ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pageL;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<IndexModel *> *data;
@end

@implementation HomePreview

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = 0;
    self.width = WIDTH;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                    = CGSizeMake((WIDTH - 1) / 3, 80);
    layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing          = 0.5;
    self.collectionView.collectionViewLayout = layout;
    
    UINib *nib = [UINib nibWithNibName:@"IndexRectangleCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"IndexRectangleCell"];
    
    [self getLatestDataAndRefresh];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(reloadPreviewData:) name:SocketRealTimeAndPushNotification object:nil];
}

- (void)getLatestDataAndRefresh {
    
    self.data = [IndexTool indexesWithSection:0];
    
    NSInteger num = (self.data.count <= 3) ? 3 : 6;
    while (self.data.count < num) {
        [self.data addObject:[[IndexModel alloc]init]];
    }
    [self.collectionView reloadData];
    
    NSInteger current = (self.collectionView.contentOffset.x / self.collectionView.width) + 1;
    NSInteger total = (self.data.count > 3) ? 2 : 1;
    current = (num == 3) ? 1 : current;
    self.pageL.text = [NSString stringWithFormat:@"%ld/%ld", current, total];
}

- (void)reloadPreviewData:(NSNotification *)notification {
    
    NSMutableArray *paths = [NSMutableArray array];
    
    for (IndexModel *model in notification.userInfo[@"userInfo"]) {
        for (int i = 0; i < self.data.count; i++) {
            if ([self.data[i].code isEqualToString:model.code] && (self.data[i].new_price != model.new_price)) {
                self.data[i] = model;
                [paths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                break;
            }
        }
    }
    //拖拽中不要刷新 || 没静止前不要刷新(处于减速状态下), 否则刷新时会跳动  //tag 0==非置顶状态, 1==置顶状态
    if (self.collectionView.isDragging || self.collectionView.isDecelerating || self.tag) return;
    [self.collectionView reloadItemsAtIndexPaths:paths];
}

#pragma mark - collectionView data source & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IndexRectangleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexRectangleCell" forIndexPath:indexPath];
    cell.model = self.data[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.data[indexPath.row].name) return;
    
    ChartDetailsController *vc = [[ChartDetailsController alloc] init];
    vc.model = self.data[indexPath.row];
    UITabBarController *tabBarC = (UITabBarController *)self.window.rootViewController;
    [tabBarC.selectedViewController pushViewController:vc animated:YES];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.collectionView reloadData]; //只有在完全停止时才可刷新, 否则会乱跳动
    
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    self.pageL.text = [NSString stringWithFormat:@"%ld/%d", index + 1, self.data.count > 3 ? 2 : 1];
}

- (IBAction)clickedEdit {
    WEAK_SELF
    [[SocketTool sharedSocketTool] disconnect];
    EditPreviewController *vc = [[EditPreviewController alloc] init];
    vc.refreshDataBlock = ^(){
        [weakSelf getLatestDataAndRefresh];
    };
    UITabBarController *tabBarC = (UITabBarController *)self.window.rootViewController;
    [tabBarC.selectedViewController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
