

#import "GQSegmentTitleView.h"
#import "GQKit.h"
#define kTitleColor GQ_RGB_COLOR(102,102,102)
#define kTitleSelectColor  GQ_RGB_COLOR(23,27,31)
@implementation GQSegmentTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _fixedUnderlineWidth = 0;
        _separatorViews = [@[] mutableCopy];
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        _needSeparatorLine = NO;
    }
    return self;
}

- (void)setTitlesViewBackColor:(UIColor *)titlesViewBackColor {
    _titlesViewBackColor = titlesViewBackColor;
    self.backgroundColor = titlesViewBackColor;
}

- (void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    [self setupTitleButtons];
}
- (void)setupTitleButtons {
    UIView *subView= self.subviews.firstObject;
    [subView removeFromSuperview];
    
    NSArray *titles = self.titleArr;
    NSUInteger count = titles.count;
    
    CGFloat titleButtonW = 0;
    if (count > 5) {
        titleButtonW = self.gq_width / 5;
    }else{
        titleButtonW = self.gq_width / count;
    }
    
    CGFloat titleButtonH = self.gq_height;
    
    for (NSInteger i = 0; i < count; i++) {
        UIButton *titleButton = [[UIButton alloc] init];
        titleButton.tag = i;
        [titleButton setTitleColor:kTitleColor forState:UIControlStateNormal];
        
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleButton];
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
        [self.titlesButton addObject:titleButton];
        
        if (i == 0) {
            self.clickedTitleButton = titleButton;
            [self titleButtonClick:titleButton];
        }
        if (i != (titles.count-1)) {
            
            CGRect frame = CGRectMake(CGRectGetMaxX(titleButton.frame), 8, 0.5, self.gq_height-16);
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.backgroundColor = GQ_Hex_Color(@"dddddd");
            view.tag = 1000+i;
            [self addSubview:view];
        }
    }
    
    self.contentSize = CGSizeMake(titleButtonW * count, 0);
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    if (normalColor!=nil) {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *tmp = (UIButton *)subView;
                [tmp setTitleColor:self.normalColor forState:UIControlStateNormal];
            }
        }
    }
} 


- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    if (selectColor != nil) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *tmp = (UIButton *)obj;
                [tmp setTitleColor:self.selectColor forState:0];
                *stop = YES;
            }
        }];
        self.underline.backgroundColor = selectColor;
    }
}

- (void)setNeedSeparatorLine:(BOOL)needSeparatorLine {
    _needSeparatorLine = needSeparatorLine;
    if (!needSeparatorLine) {
        for (UIView *subView in self.subviews) {
            if (subView.tag >= 1000) {
                subView.hidden = YES;
            }
        }
    }
}

- (void)setIsNeedUnderline:(BOOL)isNeedUnderline {
    _isNeedUnderline = isNeedUnderline;
    if (isNeedUnderline) {
        if (self.underline == nil) {
            UIView *underline = [[UIView alloc] init];
            CGFloat underlineH = 3;
            underline.frame = CGRectMake(0, self.gq_height - underlineH, 100, underlineH);
            underline.backgroundColor = kTitleSelectColor;
            [self addSubview:underline];
            self.underline = underline;
        }
        UIButton *firstTitleButton = self.subviews.firstObject;
        
        if (self.fixedUnderlineWidth > 0) {
            self.underline.gq_width = self.fixedUnderlineWidth;
        } else {
            self.underline.gq_width = firstTitleButton.titleLabel.intrinsicContentSize.width + 10;
        }
        
        self.underline.gq_centerX = firstTitleButton.gq_centerX;
    }
}
- (void)setIsNeedBottomSeparatorLine:(BOOL)isNeedBottomSeparatorLine {
    _isNeedBottomSeparatorLine = isNeedBottomSeparatorLine;
    if (isNeedBottomSeparatorLine) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-1, self.contentSize.width, 1)];
        view.backgroundColor = GQ_Hex_Color(@"dddddd");
        [self addSubview:view];
    }
}

/**
 *  标题按钮被点击了
 */
- (void)titleButtonClick:(UIButton *)titleButton{
    self.titleButtonIsClick = YES;

    // 重复点击了某个标题按钮
    if (self.clickedTitleButton == titleButton) {
    }
    
    // 设置标题居中
    [self setupTitleCenter:titleButton];
    
    [self.clickedTitleButton setTitleColor:self.normalColor == nil ? kTitleColor : self.normalColor forState:UIControlStateNormal];
    [titleButton setTitleColor:self.selectColor == nil ? kTitleSelectColor : self.selectColor forState:UIControlStateNormal];
    self.clickedTitleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.clickedTitleButton = titleButton;
    
    //计算应该滚动多少
    CGFloat needScrollOffsetX = self.clickedTitleButton.center.x - self.bounds.size.width * 0.5;
    
    //最大允许滚动的距离
    CGFloat maxAllowScrollOffsetX = self.contentSize.width - self.bounds.size.width;
    
    if (needScrollOffsetX > maxAllowScrollOffsetX) {
        needScrollOffsetX = maxAllowScrollOffsetX;
    }
    if (needScrollOffsetX<0) {
        needScrollOffsetX = 0;
    }
    [self setContentOffset:CGPointMake(needScrollOffsetX, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.fixedUnderlineWidth > 0) {
            self.underline.gq_width = self.fixedUnderlineWidth;
        } else {
            self.underline.gq_width = titleButton.titleLabel.intrinsicContentSize.width + 10;
        }
        self.underline.gq_centerX = titleButton.gq_centerX;
        
    } completion:^(BOOL finished) {
    }];
    
    if ([self.Delegate respondsToSelector:@selector(segmentTitleViewDidTitleButtonClick:)]) {
        [self.Delegate segmentTitleViewDidTitleButtonClick:titleButton];
    }
}
#pragma mark - 设置标题居中
- (void)setupTitleCenter:(UIButton *)titleButton {
    // 本质:修改标题滚动视图的偏移量
    CGFloat offsetX = titleButton.center.x - self.gq_width * 0.5;
    // 处理最小偏移量
    if (offsetX < 0) {
        offsetX = 0;
    }
    // 处理最大偏移量
    CGFloat maxOffsetX = self.contentSize.width - self.gq_width;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
}
#pragma mark - 懒加载
- (NSMutableArray *)titlesButton {
    if (!_titlesButton) {
        _titlesButton = [NSMutableArray array];
    }
    return _titlesButton;
}
@end
