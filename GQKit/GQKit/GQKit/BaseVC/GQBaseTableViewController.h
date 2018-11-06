//
//  GQBaseTableViewController.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQBaseViewController.h"
#import "GQPlaceHolderView.h"
@class GQRequestError;

typedef NS_ENUM(NSUInteger, GQBaseTableVCStyle)
{
    GQBaseTableVCStylePlain = 1,
    GQBaseTableVCStyleGroup
};
@interface GQBaseTableViewController : GQBaseViewController<UITableViewDelegate, UITableViewDataSource>

#pragma mark - tableview属性
/**
 重写tableView可更换成UICollectionView
 */
@property (strong, nonatomic) UITableView *tableView;
/**
 tableView样式
 */
@property (assign, nonatomic) GQBaseTableVCStyle gq_tableStyle;

/**
 tableViewFrame
 */
@property (assign, nonatomic) CGRect gq_tableViewFrame;
/**
 当界面需要的只是一个单纯的TableView时候，可使用为yes,默认no  当no时候(TableView的父view是uiview)
 导航栏是透明不适合，因为UITableViewController默认tableView是全屏的，frame无法改变
 用法：
 - (void)loadView {
     self.gq_isNeedOnlyTableView = NO;
     [super loadView];
 }
 tableStyle默认group样式，更换样式也在里面
 */
@property (nonatomic, assign) BOOL gq_isNeedOnlyTableView;

#pragma mark - navBar
/**
 导航栏渐变
 */
@property (assign, nonatomic) BOOL gq_isNeedNavGradualChange;
/**
 导航栏渐变时候的标题
 */
@property (nonatomic, strong) NSString *gq_navTitle;
/**
 只需要透明的nav
 */
@property (assign, nonatomic) BOOL gq_isNeedOnlyClearNavBar;
/**
 滑动回调
 */
@property (copy, nonatomic) void (^gq_navGradualChangeBlock)(CGFloat navAlpha);
/**
 导航栏透明之后返回按钮点击事件重写
 */
- (void)gq_backButtonClick;

#pragma mark - GQPlaceHolderView属性
/**
 请求网络后，没有数据或者无网络时，是否覆盖一个 “无数据” view 默认为：YES
 */
@property (assign, nonatomic) BOOL gq_needPlaceHolderView;
/**
 用于显示没有数据或者 无网络
 */
@property (nonatomic, strong) GQPlaceHolderView *gq_placeHolderView;
/**
 添加在哪个view 默认tableview
 */
@property (nonatomic, strong) UIView *gq_placeHolderViewAddView;
/**
 gq_placeHolderView文字
 */
@property (nonatomic, strong) NSString *gq_placeHolderViewText;
/**
 gq_placeHolderView图片
 */
@property (nonatomic, strong) NSString *gq_placeHolderViewImage;
/**
 gq_placeHolderView图片距离顶部距离
 */
@property (nonatomic, assign) CGFloat gq_placeHolderViewImageTop;
/**
 gq_placeHolderView距离SuperView顶部距离
 */
@property (nonatomic, assign) CGFloat gq_placeHolderViewLeaveSuperViewTop;


#pragma mark - 网络请求加载视图属性
/**
 发送请求时显示 加载视图， 默认为yes， 并且只显示一次
 */
@property (assign, nonatomic) BOOL gq_isShowLoadView;
/**
 加载视图背景是否透明 默认不透明  Default no
 */
@property (nonatomic, assign) BOOL gq_loadViewBackgroundIsClear;


#pragma mark - 数据请求
/**
 列表数据
 */
@property (strong, nonatomic) NSMutableArray *gq_objects;
/**
 为空时，不自动填充 objects
 */
@property Class gq_objClass;
/**
 下一次第几页
 */
@property (assign, nonatomic) NSInteger gq_pageNextIndex;

/**
 每页多少条数据  默认 GQ_ApiPageCount
 */
@property (assign, nonatomic) NSUInteger gq_pageSize;

/**
 页数从几开始 默认1
 */
@property (assign, nonatomic) NSInteger gq_pageStartNum;

/**
 是否要有上拉刷新下啦加载  default is no
 */
@property (assign, nonatomic) BOOL gq_enableTableHeaderFooter;

/**
 是否是Get请求 默认no
 */
@property (assign, nonatomic) BOOL gq_isGetRequest;

/**
 请求参数
 */
@property (copy, nonatomic) NSString *(^gq_getRequestUrlBlock)(NSUInteger pageIndex);
/**
 参数列表
 */
@property (copy, nonatomic) NSDictionary *(^gq_getRequestParametersBlock)(void);

/**
 刷新第一页数据，但没有填充 objects 之前 回调
 */
@property (copy, nonatomic) void (^gq_didRefreshSuccessBlock)(void);
/**
 填充了 objects 之后，tableView 即将要刷新， responseObjectsCount 为服务器返回的数据条数
 自己决定 刷新底部的显示样式
*/
@property (copy, nonatomic) void (^gq_tableViewWillReloadBlock)(NSUInteger responseObjectsCount);

/**
 数据解析后tableview刷新前
 */
@property (copy, nonatomic) void (^gq_parseBeforeTableViewReloadBlock)(void);
/**
 数据解析后tableview刷新后
 */
@property (copy, nonatomic) void (^gq_parseAfterTableViewReloadBlock)(void);
/**
 解析数据网络错误时候
 */
@property (copy, nonatomic) void (^gq_parseWhenNetworkFailBlock)(GQRequestError *error);

/**
 字典转模型之后的回调
 */
@property (copy, nonatomic) void (^gq_dataToModelBlock)(NSArray *modelArr);

/**
 解析数据 在子类重写 还没进行字典转模型
 */
- (NSArray *)gq_parseResponseDictionaryData:(NSDictionary *)data;

/**
 没有数据返回 在子类重写
 */
- (void)gq_noDataResponse:(NSDictionary *)data;


#pragma mark - 刷新获取数据
/**
 刷新数据无下拉刷新动画
*/
- (void)gq_refresh;

/**
 重新从第一页刷新数据
*/
- (void)gq_refreshAgain;


@end
