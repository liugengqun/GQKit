

#import <UIKit/UIKit.h>

@interface GQActionSheetCell : UITableViewCell

@property (strong, nonatomic) UILabel *title;

@property (strong, nonatomic) UIView *separtline;

@end


@interface GQActionSheetView : UIView
/**
 *  ActionSheetView 点击回调
 */
@property (copy, nonatomic) void (^gq_chooseBlock)(NSString *text ,NSInteger idx);
/**
 *  ActionSheetView 消失回调
 */
@property (copy, nonatomic) void (^gq_dismissBlock)(void);

/**
 *  创建一个底部选择view
 *
 *  @param titles 选项数组
 *  @param cancle 取消的标题--默认取消
 *
 *  @return 返回一个底部选择view
 */
- (instancetype)gq_initWithTitles:(NSArray*)titles withCancleTitle:(NSString*)cancle;

- (instancetype)gq_initWithTitles:(NSArray*)titles withCancleTitle:(NSString*)cancle cancelColor:(UIColor *)color;

- (instancetype)gq_initWithTitles:(NSArray*)titles titleColors:(NSArray<UIColor *> *)colors withCancleTitle:(NSString*)cancle;

- (instancetype)gq_initWithTitles:(NSArray*)titles titleColors:(NSArray<UIColor *> *)colors withCancleTitle:(NSString*)cancle cancelColor:(UIColor *)color;

/**
 *  ActionSheetView 出现
 */
- (void)gq_show;
/**
 *  ActionSheetView 消失
 */
- (void)gq_dismiss;


/**
 *  ActionSheetView 上面再添加一个view
 */
@property (nonatomic, strong) UIView *gq_exampleView;
/**
 *  ActionSheetView 上面再添加一个view的高度
 */
@property (nonatomic, assign) CGFloat gq_exampleViewH;

/**
 *  ActionSheetView 自定义cell
 *
 *  @param customCellStr cell名字
 *  @param data cell数据源
 *
 */
- (void)gq_setupCustomCellStr:(NSString *)customCellStr customCellDataArr:(NSArray *)data;
/**
 *  ActionSheetView 自定义cell 数据源赋值回调
 */
@property (copy, nonatomic) void (^gq_customCellDataBlock)(UITableViewCell *cell, NSIndexPath *indexPath);
@end
