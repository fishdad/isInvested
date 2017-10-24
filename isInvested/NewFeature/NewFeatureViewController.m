//
//  NewFeatureViewController.m
//  isInvested
//
//  Created by Blue on 16/8/9.
//  Copyright © 2016年 Blue. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "NewFeatureCell.h"

@interface NewFeatureViewController ()

@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation NewFeatureViewController

/** 页数 */
static NSInteger const pagesCount = 3;

/** 判断是否为新版 */
+ (BOOL)isNewFeature {
    
    NSString *lastVersion = [NSUserDefaults objectForKey:@"VersionString"];
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    if ([lastVersion isEqualToString:version]) { // 旧版
        [NSUserDefaults setObject:version forKey:@"VersionString"];
        return NO;
        
    } else { // 新版
        [NSUserDefaults setObject:version forKey:@"VersionString"];
        return YES;
    }
}

- (instancetype)init {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize           = [UIScreen mainScreen].bounds.size;
    layout.scrollDirection    = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[NewFeatureCell class] forCellWithReuseIdentifier:@"NewFeatureCell"];
    
    self.collectionView.bounces = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.control];
}

- (UIPageControl *)control {
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = CGPointMake(WIDTH * 0.5, HEIGHT * 0.95);
        
        _pageControl.numberOfPages = pagesCount;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    }
    return _pageControl;
}

#pragma mark - UIScrollView代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    self.control.currentPage = page;
}

#pragma mark - UICollectionView代理和数据源

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return pagesCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewFeatureCell" forIndexPath:indexPath];
    cell.showStartB = (indexPath.row == pagesCount - 1);
    cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"newFeature_%ld", indexPath.row]];
    return cell;
}

@end
