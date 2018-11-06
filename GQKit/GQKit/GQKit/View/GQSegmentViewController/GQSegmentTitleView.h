

#import <UIKit/UIKit.h>

@protocol GQSegmentTitleViewDelegate <NSObject>
@optional
- (void)segmentTitleViewDidTitleButtonClick:(UIButton *)titleButton;
@end

@interface GQSegmentTitleView : UIScrollView
/** 分割线 */
@property (nonatomic, weak) UIView *underline;

/** 当前被点击的按钮 */
@property (nonatomic, weak) UIButton *clickedTitleButton;

/** 按钮是否被点击 */
@property (nonatomic, assign) BOOL titleButtonIsClick;

@property (nonatomic, strong) NSMutableArray *titlesButton;
@property (nonatomic, strong) NSMutableArray *separatorViews;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *titlesViewBackColor;

@property (assign, nonatomic) BOOL needSeparatorLine;
@property (nonatomic, assign) BOOL isNeedUnderline;
@property (assign, nonatomic) float fixedUnderlineWidth;
@property (nonatomic, assign) BOOL isNeedBottomSeparatorLine;

@property (nonatomic, weak) id <GQSegmentTitleViewDelegate>Delegate;

- (void)titleButtonClick:(UIButton *)titleButton;
@end
