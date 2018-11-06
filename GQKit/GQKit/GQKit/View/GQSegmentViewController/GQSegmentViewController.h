

#import "GQSegmentTitleView.h"
@interface GQSegmentViewController : UIViewController

/** 标题栏数组 */
@property (nonatomic, strong) NSArray <NSString *>*gq_titleArr;

/** 标题栏size 默认CGSizeMake(GQ_WindowW, 45)*/
@property (nonatomic, assign) CGSize gq_titleSize;
/** 标题栏是否在导航栏 */
@property (nonatomic, assign) BOOL gq_titlesViewIsNav;
/** 标题栏在导航栏宽度 */
@property (nonatomic, assign) CGFloat gq_navTitlesViewWidth;

/** 标题之间是否需要分割线 默认no*/
@property (assign, nonatomic) BOOL gq_needSeparatorLine;

/** 是否需要底部滑动 默认no*/
@property (nonatomic, assign) BOOL gq_isNeedUnderline;
/** 底部滑动的滑块宽度 */
@property (assign, nonatomic) float gq_fixedUnderlineWidth;

/** 是否需要底部分割线 默认no */
@property (nonatomic, assign) BOOL gq_isNeedBottomSeparatorLine;
/** 标题栏标题默认颜色 */
@property (nonatomic, strong) UIColor *gq_normalColor;
/** 标题栏标题选中颜色 */
@property (nonatomic, strong) UIColor *gq_selectColor;
/** 标题栏背景色 */
@property (nonatomic, strong) UIColor *gq_titlesViewBackColor;

/** 底部scroll的frame */
@property (nonatomic, assign) CGRect gq_scrollFrame;

/** 传递的子控制器名称 */
@property (nonatomic, strong) NSMutableArray<NSString *>*gq_childControllerVc;
/** 子控制器初始化后回调 */
@property (nonatomic, strong) void(^gq_initChildVcBlock)(UIViewController *childVc, NSUInteger idx);


/** 跳到指定controllers的tag 默认0*/
@property (assign, nonatomic) NSInteger gq_selectedTag;
- (void)jumpSelectedTag:(NSInteger)gq_selectedTag;

// 配置好所有属性后手动调用
-(void)gq_reloadSubviews;
@end
