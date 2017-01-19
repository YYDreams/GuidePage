//
//  HHGuidePageViewController.m
//  GuidePage
//
//  Created by 花花 on 2017/1/19.
//  Copyright © 2017年 花花. All rights reserved.
//

#import "HHGuidePageViewController.h"

@interface HHGuidePageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)UIPageControl *pageControl;
@property(assign,nonatomic)NSInteger count;

@property(copy,nonatomic)setupCellHandler setupCellHandler;
@property(copy,nonatomic)finishButtonHandler finishBtnHandller;
@end

static NSString *const GuidePageCellID = @"HHGuidePageCellID";
@implementation HHGuidePageViewController

#pragma mark - init Method
-(instancetype)initWithPagesCount:(NSInteger)count setupCellHandler:(setupCellHandler)setupCellHandler finishHandler:(finishButtonHandler)finishBtnHandler{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _count = count;
        _setupCellHandler =[setupCellHandler copy];
        _finishBtnHandller =[finishBtnHandler copy];
        //使用懒加载初始化
        [self.view addSubview: self.collectionView];
        [self.view addSubview:self.pageControl];
        //注册cell
        [self.collectionView registerClass:[HHGuidePageCell class] forCellWithReuseIdentifier:GuidePageCellID];
    }

    return self;
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    HHGuidePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GuidePageCellID forIndexPath:indexPath];
    if (indexPath.row == self.count -1) {//如果是最后一页，则添加响应事件
        cell.finishBtn.hidden = NO;
        [cell.finishBtn addTarget:self action:@selector(finishBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        cell.finishBtn.hidden = YES;
    }
    
    if (self.setupCellHandler) {
        
        self.setupCellHandler(cell,indexPath);
    }
    return cell;
}

#pragma mark - <UIScrollerViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    if (self.pageControl.currentPage != currentPage) {
        self.pageControl.currentPage = currentPage;
    }
}
#pragma mark - SEL Method
-(void)finishBtnOnClick:(UIButton *)btn{
    
    if (self.finishBtnHandller) {
        self.finishBtnHandller(btn);
    }
}
#pragma mark - Lazy Methods
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.itemSize = self.view.bounds.size;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.bounces = NO;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView = collectionView;
    }
    return _collectionView;
}
- (UIPageControl *)pageControl{
    
    if (!_pageControl) {
        
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.numberOfPages = self.count;
        pageControl.currentPage = 0;
        
        CGSize pageSize = [pageControl sizeForNumberOfPages:self.count];
        CGFloat pageControlX = (self.view.bounds.size.width - pageSize.width)/2;
        CGFloat pageControlY = self.view.bounds.size.height - pageSize.height - 50;
        pageControl.frame = CGRectMake(pageControlX, pageControlY, pageSize.width, pageSize.height);
        _pageControl = pageControl;
    }

    return _pageControl;
}
@end
