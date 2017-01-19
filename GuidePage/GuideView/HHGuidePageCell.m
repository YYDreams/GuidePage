//
//  HHGuidePageCell.m
//  GuidePage
//
//  Created by 花花 on 2017/1/19.
//  Copyright © 2017年 花花. All rights reserved.
//

#import "HHGuidePageCell.h"

@implementation HHGuidePageCell

#pragma mark - init Methods
- (void)awakeFromNib{

    [super awakeFromNib];
    [self commonInit];
}
- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
     [self commonInit];
    }
    return self;
}
- (instancetype)init{

    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit{
   
    [self.contentView addSubview: self.imageView];
    [self.contentView addSubview:self.finishBtn];
    
}
#pragma mark - layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
    [self.finishBtn sizeToFit];
    CGFloat margin = 10;
    CGFloat finishW = self.finishBtn.bounds.size.width + 2 * margin;
    CGFloat finishH = self.finishBtn.bounds.size.height + 2 * margin;
    CGFloat finishX = (self.bounds.size.width - finishW)/2;
    CGFloat finishY = self.bounds.size.height - finishH - 100;
    self.finishBtn.frame = CGRectMake(finishX, finishY, finishW, finishH);
}
#pragma mark - Lazy Methods
- (UIImageView *)imageView{
    
    if (!_imageView) {
        _imageView =[[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (UIButton *)finishBtn{
    if (!_finishBtn) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor orangeColor];
        btn.layer.cornerRadius = 10.f;
        btn.layer.masksToBounds = YES;
       _finishBtn = btn;
    }
    return _finishBtn;
}
@end
