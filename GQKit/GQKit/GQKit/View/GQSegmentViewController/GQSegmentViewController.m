

#import "GQSegmentViewController.h"
#import "GQBaseTableViewController.h"
#import "GQKit.h"
#import "GQSegmentScrollView.h"
@interface GQSegmentViewController () <UIScrollViewDelegate, GQSegmentTitleViewDelegate>
/** 标题栏 */
@property (nonatomic, strong) GQSegmentTitleView *titlesView;
/** 用来显示所有子控制器的view */
@property (nonatomic, strong) GQSegmentScrollView *scrollView;
/** 记录上一次内容滚动视图偏移量 */
@property (nonatomic, assign) CGFloat lastOffsetX;
/** 滚动前underline中心x */
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat halfAlpha;
/** 是否已经创建初始化标识 */
@property (nonatomic, strong) NSMutableArray *initializeArr;
@end

@implementation GQSegmentViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        _gq_selectedTag = 0;
        _gq_titleSize = CGSizeMake(GQ_WindowW, 45);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_gq_selectedTag >= 0) {
        [self jumpSelectedTag:self.gq_selectedTag];
    }
}


-(void)gq_reloadSubviews {
    // 标题栏
    [self setupTitlesView];
    
    // scrollView
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    
    // 默认显示第0个子控制器
    [self addChildVcViewIntoScrollView:0];
}

/**
 *  scrollView
 */
- (GQSegmentScrollView *)scrollView {
    if (_scrollView==nil) {
        _scrollView = [GQSegmentScrollView new];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self setGq_scrollFrame:self.gq_scrollFrame];
        _scrollView.contentSize = CGSizeMake(self.gq_childControllerVc.count * _scrollView.gq_width, 0);
    }
    return _scrollView;

}

- (void)setGq_scrollFrame:(CGRect)gq_scrollFrame {
    _gq_scrollFrame = gq_scrollFrame;
    if (CGRectGetHeight(self.gq_scrollFrame) > 0) {
        self.scrollView.frame = self.gq_scrollFrame;
    } else {
        if (self.gq_titlesViewIsNav) {
            self.scrollView.frame = CGRectMake(0, 0, GQ_WindowW, GQ_WindowH - GQ_NavBarAndStatusBarH) ;
        } else {
            self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.titlesView.frame), GQ_WindowW, GQ_WindowH - self.titlesView.gq_height - GQ_NavBarAndStatusBarH) ;
        }
        
    }
}
/**
 *  标题栏
 */
- (void)setupTitlesView {
    if(_gq_titlesViewIsNav){
        if (self.titlesView == nil) {
            self.titlesView = [[GQSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0,self.gq_navTitlesViewWidth > 0 ? self.gq_navTitlesViewWidth :  GQ_WindowW - 60, GQ_NavBarH)];
            [self loadDataForTitlesView];
            self.navigationItem.titleView = self.titlesView;
        }
    } else {
        if (self.titlesView == nil) {
            self.titlesView = [[GQSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, self.gq_titleSize.width, self.gq_titleSize.height)];
            [self loadDataForTitlesView];
            [self.view addSubview:self.titlesView];
        }
    }
    
}
- (void)loadDataForTitlesView {
    self.titlesView.titleArr = self.gq_titleArr;
    self.titlesView.Delegate = self;
    self.titlesView.needSeparatorLine = self.gq_needSeparatorLine;
    self.titlesView.fixedUnderlineWidth = self.gq_fixedUnderlineWidth;
    self.titlesView.isNeedUnderline = self.gq_isNeedUnderline;
    self.titlesView.normalColor = self.gq_normalColor;
    self.titlesView.selectColor = self.gq_selectColor;
    self.titlesView.titlesViewBackColor = self.gq_titlesViewBackColor;
    self.titlesView.isNeedBottomSeparatorLine = self.gq_titlesViewIsNav ? NO : self.gq_isNeedBottomSeparatorLine;
}

#pragma mark - 监听点击
- (void)segmentTitleViewDidTitleButtonClick:(UIButton *)titleButton {
    NSUInteger index = titleButton.tag;
    self.gq_selectedTag = index;
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentOffset = CGPointMake(index * self.scrollView.gq_width, 0);
    } completion:^(BOOL finished) {
        if ([self.initializeArr[index] integerValue] == 1) {
            return ;
        }
        [self addChildVcViewIntoScrollView:index];
    }];
}


#pragma mark - 其他
/**
 *  添加第index个子控制器的view到scrollview
 */
- (void)addChildVcViewIntoScrollView:(NSUInteger)index {
    if (_initializeArr == nil) {
        _initializeArr = [NSMutableArray new];
        __weak __typeof(self) weakSelf = self;
        [self.gq_childControllerVc enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.initializeArr addObject:@"0"];
        }];
    }
    self.initializeArr[index] = @"1";
    
    Class cls = NSClassFromString(self.gq_childControllerVc[index]);
    if ([cls isSubclassOfClass:[GQBaseTableViewController class]]) {
        GQBaseTableViewController *vc = (GQBaseTableViewController *)[[cls alloc] init];
        [self.scrollView addSubview:vc.view];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        
        vc.view.gq_x = index * self.scrollView.gq_width;
        vc.view.gq_y = 0;
        vc.view.gq_width = GQ_WindowW;
        vc.view.gq_height = self.scrollView.gq_height;
        vc.tableView.frame = vc.view.bounds;
        if (self.gq_initChildVcBlock) {
            self.gq_initChildVcBlock(vc, index);
        }
    } else if ([cls isSubclassOfClass:[UIViewController class]]){
        UIViewController *vc = (UIViewController *)[[cls alloc] init];
        [self.scrollView addSubview:vc.view];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        
        vc.view.gq_x = index * self.scrollView.gq_width;
        vc.view.gq_y = 0;
        vc.view.gq_width = GQ_WindowW;
        vc.view.gq_height = self.scrollView.gq_height;
        if (self.gq_initChildVcBlock) {
            self.gq_initChildVcBlock(vc, index);
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.centerX =  self.titlesView.underline.gq_centerX;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.titlesView.titleButtonIsClick) {
        self.titlesView.titleButtonIsClick = NO;
        _lastOffsetX = scrollView.contentOffset.x;
        return;
    };
    
    NSInteger leftI = scrollView.contentOffset.x / GQ_WindowW;
    NSInteger rightI = leftI + 1;
    
    // 获取左边按钮
    UIButton *leftButton = self.titlesView.titlesButton[leftI];
    
    NSInteger count = self.titlesView.titlesButton.count;
    UIButton *rightButton = nil;
    if (rightI < count) {
        rightButton = self.titlesView.titlesButton[rightI];
    }
    
    //计算比例 0 ~ 1 => 1 ~ 1.3
//    CGFloat scaleL = scrollView.contentOffset.x / GQ_WindowW;
//    scaleL = scaleL - leftI;
//    CGFloat scaleR = 1 - scaleL;
//
//    CGFloat rSelCol = 255;
//    CGFloat gSelCol = 112;
//    CGFloat bSelCol = 18;
//    
//    CGFloat r = 170-rSelCol;
//    CGFloat g = 170-gSelCol;
//    CGFloat b = 170-bSelCol;

//    [rightButton setTitleColor:[UIColor colorWithRed:(rSelCol + r * scaleR)/255.0 green:(gSelCol + g * scaleR)/255.0  blue:(bSelCol + b * scaleR)/255.0  alpha:1] forState:UIControlStateNormal]; // 右边
//    [leftButton setTitleColor:[UIColor colorWithRed:(rSelCol +  r * scaleL)/255.0   green:(gSelCol +  g * scaleL)/255.0 blue:(bSelCol +  b * scaleL)/255.0  alpha:1] forState:UIControlStateNormal]; // 左边
    

    
        // 获取两个标题中心点距离
        CGFloat centerDelta = rightButton.gq_x - leftButton.gq_x;
        
        // 标题宽度差值
        CGFloat widthDelta = [self widthDeltaWithRightBtn:rightButton leftBtn:leftButton];
        
        // 获取scrollView移动距离
        CGFloat offsetDelta = scrollView.contentOffset.x - _lastOffsetX;
        
        // 计算当前下划线偏移量
        CGFloat underLineTransformX = offsetDelta * centerDelta / GQ_WindowW;
        
        // 宽度递增偏移量
        CGFloat underLineWidth = offsetDelta * widthDelta / GQ_WindowW;
        if (self.gq_fixedUnderlineWidth <= 0) {
            self.titlesView.underline.gq_width += underLineWidth;
        }
        self.titlesView.underline.gq_centerX += underLineTransformX;
        
        
        CGFloat underlineTransformTotalX = fabs(self.titlesView.underline.gq_centerX - self.centerX);
        CGFloat alpha =  underlineTransformTotalX / centerDelta;
        if (underlineTransformTotalX < centerDelta * 0.5) {
//            self.titlesView.underline.alpha = 1 - alpha;
            self.halfAlpha = alpha;
        }else{
            if (alpha < 0) {
                alpha = 1;
            }
//            self.titlesView.underline.alpha = self.titlesView.underline.alpha + alpha - self.halfAlpha;
            self.halfAlpha = alpha;
        }

    // 记录上一次的偏移量
    _lastOffsetX = scrollView.contentOffset.x;
     
}
// 获取两个标题按钮宽度差值
- (CGFloat)widthDeltaWithRightBtn:(UIButton *)rightBtn leftBtn:(UIButton *)leftBtn {
    CGRect titleBoundsR = [rightBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    CGRect titleBoundsL = [leftBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];

    return titleBoundsR.size.width - titleBoundsL.size.width;
}

/**
 *  当scrollView滚动完毕的时候调用这个方法
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 点击对应的按钮
    NSUInteger index = scrollView.contentOffset.x / scrollView.gq_width;
    self.gq_selectedTag = index;
    if ([self.initializeArr[index] integerValue] == 0) {
        [self addChildVcViewIntoScrollView:index];
    }
    for (UIView *view in self.titlesView.subviews) {
        if ([view isKindOfClass:UIButton.class] && view.tag == index) {
            [self segmentTitleViewDidTitleButtonClick:(UIButton *)view];
             [self.titlesView titleButtonClick:(UIButton *)view];
            break;
        }
    }
}

- (void)jumpSelectedTag:(NSInteger)gq_selectedTag {
    _gq_selectedTag = gq_selectedTag;
    UIButton *btn = nil;
    for (UIButton *button in self.titlesView.subviews) {
        if ( [button isMemberOfClass:UIButton.class] && button.tag == gq_selectedTag) {
            btn = button;
        }
    }
    if (btn) {
        [self.titlesView titleButtonClick:btn];
    }
}
@end
