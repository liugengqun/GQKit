//
//  GQCyclePagerViewCell.m
//  GQKit
//
//  Created by Apple on 25/03/18.
//  Copyright © 2018年 GQKit. All rights reserved.
//

#import "GQCyclePagerViewCell.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "GQKit.h"
@interface GQCyclePagerViewCell()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@end
@implementation GQCyclePagerViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpTableViewCell];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpTableViewCell];
    }
    return self;
}

- (void)setUpTableViewCell {
    [self addPagerView];
    [self addPageControl];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc] init];
    pagerView.dataSource = self;
    pagerView.delegate = self;
    pagerView.autoScrollInterval = 3;
    [pagerView registerClass:[GQCyclePagerViewImgCell class] forCellWithReuseIdentifier:@"GQCyclePagerViewImgCell"];
    [self.contentView addSubview:pagerView];
    _pagerView = pagerView;
}
- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc] init];
    pageControl.numberOfPages = self.gq_dataArray.count;
    pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    
    [_pagerView addSubview:pageControl];
    self.pageControl = pageControl;
}
- (void)setGq_dataArray:(NSArray *)gq_dataArray {
    _gq_dataArray = gq_dataArray;
    self.pageControl.numberOfPages = self.gq_dataArray.count;
    if (gq_dataArray.count <= 1) {
        self.pagerView.isInfiniteLoop = NO;
        self.pageControl.hidden = YES;
    } else {
        self.pagerView.isInfiniteLoop = YES;
        self.pageControl.hidden = NO;
    }
    [self.pagerView reloadData];
}

#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.gq_dataArray.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    GQCyclePagerViewImgCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"GQCyclePagerViewImgCell" forIndex:index];
    if (self.gq_dataArray.count > 0) {
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.gq_dataArray[index]] placeholderImage:[UIImage imageNamed:@"占位图"]];
    }
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 0;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [_pageControl setCurrentPage:toIndex animate:YES];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (self.gq_itemClickBlock) {
        self.gq_itemClickBlock(index);
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _pagerView.frame = CGRectMake(0,0,GQ_WindowW,self.gq_height);
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame), 26);
}

@end


@implementation GQCyclePagerViewImgCell


- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.imageV];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageV];
    }
    return self;
}
- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _imageV;
}
@end
