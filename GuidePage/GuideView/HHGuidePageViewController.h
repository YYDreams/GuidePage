//
//  HHGuidePageViewController.h
//  GuidePage
//
//  Created by 花花 on 2017/1/19.
//  Copyright © 2017年 花花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHGuidePageCell.h"
typedef void(^setupCellHandler)(HHGuidePageCell *cell, NSIndexPath *idnexPath);
typedef void(^finishButtonHandler)(UIButton *finishBtn);
@interface HHGuidePageViewController : UIViewController
@property(readonly,nonatomic)UICollectionView *collectionView;
@property(readonly,nonatomic)UIPageControl *pageControl;
@property(assign,nonatomic,readonly)NSInteger count;

/**
 初始化方法

 @param count 图片总数量
 @param setupCellHandler cell的回调 回调参数cell indexPath
 @param finishBtnHandler 最后一个按钮的回调
 @return self
 */
- (instancetype)initWithPagesCount:(NSInteger)count setupCellHandler:(setupCellHandler)setupCellHandler finishHandler:(finishButtonHandler)finishBtnHandler;
@end
