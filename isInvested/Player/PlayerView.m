//
//  PlayerView.m
//  isInvested
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "PlayerView.h"
#import "PlayerModel.h"
#import "PlayerCell.h"
#import "SimpleWebViewController.h"

@interface PlayerView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView       *collectionView;
@property (nonatomic, strong) UIPageControl          *pageC;
@property (nonatomic, strong) NSTimer                *timer;
@property (nonatomic, strong) NSArray<PlayerModel *> *data;
@end

@implementation PlayerView

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                    = CGSizeMake(WIDTH, HEIGHT_21_9);
        layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing          = 0;
        
        CGRect rect = CGRectMake(0, 0, WIDTH, HEIGHT_21_9);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource                     = self;
        _collectionView.delegate                       = self;
        _collectionView.pagingEnabled                  = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        UINib *nib = [UINib nibWithNibName:@"PlayerCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PlayerCell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageC {
    if (!_pageC) {
        
        CGFloat h       = 20.0;
        CGFloat y       = self.collectionView.bottom - h;
        _pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(0, y, WIDTH, h)];
        _pageC.currentPage                   = 0;
        _pageC.pageIndicatorTintColor        = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        _pageC.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageC;
}

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, WIDTH, HEIGHT_21_9);
        
        [self addSubview:self.collectionView];
        [self addSubview:self.pageC];
        [self requestPictures];
    }
    return self;
}

#pragma mark - collectionView data source & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count > 1 ? self.data.count * 10000 : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerCell" forIndexPath:indexPath];
    cell.src = self.data.count ? self.data[indexPath.item % self.data.count].Src : @"";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.data.count) return;
    
    SimpleWebViewController *vc = [[SimpleWebViewController alloc] init];
    vc.url = self.data[indexPath.item % self.data.count].Link;
    vc.navigationItem.title = self.data[indexPath.item % self.data.count].Title;
    
    UITabBarController *tabBarC = (UITabBarController *)self.window.rootViewController;
    [tabBarC.selectedViewController pushViewController:vc animated:YES];
}

#pragma mark - scrollView 代理

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger x      = (NSInteger)scrollView.contentOffset.x;
    NSInteger countW = (NSInteger)(self.data.count * WIDTH);
    NSInteger number = (x % countW) / WIDTH;
    
    self.pageC.currentPage = number;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 停止定时器(一旦定时器停止了,就不能再使用)
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 开启定时器
    [self addTimer];
}

- (void)addTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(nextImage)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextImage {
    
    CGPoint point = self.collectionView.contentOffset;
    NSInteger x = (NSInteger)point.x;
    
    if (x % (NSInteger)WIDTH == 0) { //滚动一整页
        
        point.x += WIDTH;
        [self.collectionView setContentOffset:point animated:YES];
        
        // pageControl的当前页码加1
        if (self.pageC.currentPage != (self.data.count - 1)) {
            self.pageC.currentPage += 1;
        } else {
            self.pageC.currentPage = 0;
        }
        
    } else { //滚动不到一页
        point.x += (WIDTH - x % (NSInteger)WIDTH);
        [self.collectionView setContentOffset:point animated:YES];
    }
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 网络请求

- (void)requestPictures {
    WEAK_SELF
    LOG(@"播放器播放一镒-----------");
    [HttpTool get:URL_PLAYER params:nil success:^(id responseObj) { //LOG(@"照片OK--%@", responseObj);
        
        weakSelf.data = [PlayerModel mj_objectArrayWithKeyValuesArray:responseObj[@"Data"]];
        weakSelf.pageC.numberOfPages = weakSelf.data.count;
        [weakSelf.collectionView reloadData];
        
        [weakSelf removeTimer];
        
        // 默认滚至第0组的第500张图片
        if (self.data.count <= 1) return;
        
        [weakSelf addTimer];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.data.count * 5000 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:NO];
    } failure:^(NSError *error) {
        [weakSelf performSelector:@selector(requestPictures) withObject:nil afterDelay:10.0];
    }];
}

@end
