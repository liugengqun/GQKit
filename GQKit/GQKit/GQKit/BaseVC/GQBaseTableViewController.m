//
//  GQBaseTableViewController.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQBaseTableViewController.h"
#import "UINavigationBar+Awesome.h"
#import <MJRefresh.h>
#import "GQRequestManager.h"
#import "UINavigationController+GQExtension.h"
#define GQ_PlaceHolderView_NoDataImage @"无内容"
#define GQ_PlaceHolderView_NoNetImage  @"无内容"
#define GQ_PlaceHolderView_NoNetText @"你的网络似乎有点问题喔~~"
#define GQ_PlaceHolderView_NoDataText @"获取不到相应数据"
#define GQ_PageStartNum 1
#define GQ_PageSize 10
#define GQ_WhiteItemImageName @"返回_白"
#define GQ_BlackItemImageName @"返回"

@interface GQBaseTableViewController ()
@property (strong, nonatomic) MJRefreshBackNormalFooter *tableFooter;
@property (strong, nonatomic) MJRefreshNormalHeader *tableHeader;

@property (nonatomic, assign) CGFloat navAlpha;

@property (strong, nonatomic) UIBarButtonItem *whiteItem;
@property (strong, nonatomic) UIBarButtonItem *blackItem;

// 设置过是否需要PlaceHolderView
@property (nonatomic, assign) BOOL hasSetNeedPlaceHolderView;

@end

@implementation GQBaseTableViewController

- (void)loadView {
    [super loadView];
    if (self.gq_isNeedOnlyTableView) {
        if (self.gq_tableStyle != GQBaseTableVCStylePlain) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,GQ_NavBarAndStatusBarH, GQ_WindowW, GQ_WindowH - GQ_NavBarAndStatusBarH) style:UITableViewStyleGrouped];
        } else {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,GQ_NavBarAndStatusBarH, GQ_WindowW, GQ_WindowH - GQ_NavBarAndStatusBarH) style:UITableViewStylePlain];
        }
        self.view = self.tableView;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _gq_objects = [@[] mutableCopy];
    _gq_pageSize = GQ_PageSize;
    self.gq_pageStartNum = GQ_PageStartNum;
    _gq_needPlaceHolderView = YES;
    _gq_loadViewBackgroundIsClear = NO;
    _gq_isNeedOnlyTableView = NO;
    _gq_isShowLoadView = YES;
    self.navAlpha = 0;
    
    [self startReachable];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.gq_isNeedOnlyClearNavBar) {
        [self.navigationController gq_setClearNavTitleTextAttributesWithTitleFont:nil];
    } else {
        [self.navigationController gq_setDefaultNavTitleTextAttributesWithTitleColor:nil titleFont:nil];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setGq_placeHolderViewLeaveSuperViewTop:self.gq_placeHolderViewLeaveSuperViewTop];
}

#pragma mark - navigationBar
- (void)navDeal {
    self.navigationItem.leftBarButtonItem = self.whiteItem;
    [self.navigationController gq_setClearNav];
    [self.navigationController gq_setShadowImageBeClear];
    [self setbackButton];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.gq_isNeedOnlyClearNavBar) return;
    if (!self.gq_isNeedNavGradualChange) return;
    if (self.navigationController.viewControllers.lastObject != self) return;
    
    UIColor * color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 200) {
        self.navAlpha = MIN(1, 1 - ((200 + 64 - offsetY) / 64));
        self.title = self.gq_navTitle;
    } else {
        self.navAlpha = 0;
        self.title = @"";
    }
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:self.navAlpha]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage gq_imageWithColor:[color colorWithAlphaComponent:self.navAlpha]] forBarMetrics:UIBarMetricsDefault]; // 处理iphonex
    self.navigationController.navigationBar.barTintColor = [color colorWithAlphaComponent:self.navAlpha];
    self.navigationController.navigationBar.backgroundColor = [color colorWithAlphaComponent:self.navAlpha];
    self.navigationController.view.backgroundColor = [color colorWithAlphaComponent:self.navAlpha];
    
    if (self.navAlpha == 0) {
        self.navigationItem.leftBarButtonItem = self.blackItem;
    } else {
        self.navigationItem.leftBarButtonItem = self.whiteItem;
    }
    if (self.gq_navGradualChangeBlock) {
        self.gq_navGradualChangeBlock(self.navAlpha);
    }
}

- (void)setGq_isNeedNavGradualChange:(BOOL)gq_isNeedNavGradualChange {
    _gq_isNeedNavGradualChange = gq_isNeedNavGradualChange;
    if (gq_isNeedNavGradualChange) {
        [self navDeal];
        self.tableView.frame = CGRectMake(0, 0, GQ_WindowW, GQ_WindowH);
    } else {
        self.tableView.frame = CGRectMake(0, 0, GQ_WindowW, GQ_WindowH - GQ_NavBarAndStatusBarH);
    }
}

- (void)setGq_isNeedOnlyClearNavBar:(BOOL)gq_isNeedOnlyClearNavBar {
    _gq_isNeedOnlyClearNavBar = gq_isNeedOnlyClearNavBar;
    if (gq_isNeedOnlyClearNavBar) {
        [self navDeal];
        self.tableView.frame = CGRectMake(0, 0, GQ_WindowW, GQ_WindowH);
        [self.navigationController gq_setClearNavTitleTextAttributesWithTitleFont:nil];
    } else {
        self.tableView.frame = CGRectMake(0, 0, GQ_WindowW, GQ_WindowH - GQ_NavBarAndStatusBarH);
        [self.navigationController gq_setDefaultNavTitleTextAttributesWithTitleColor:nil titleFont:nil];
    }
    
}

- (void)setbackButton {
    if (self.navigationController.childViewControllers.count == 1) {
        return;
    }
    self.navigationItem.leftBarButtonItem = self.whiteItem;
}

- (UIBarButtonItem *)blackItem {
    if (_blackItem==nil) {
        UIButton *backButton = [UIButton gq_buttonWithBackButton:GQ_WhiteItemImageName target:self action:@selector(gq_backButtonClick)];
        _blackItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    }
    return _blackItem;
}

- (UIBarButtonItem *)whiteItem {
    if (_whiteItem==nil) {
        UIButton *backButton = [UIButton gq_buttonWithBackButton:GQ_BlackItemImageName target:self action:@selector(gq_backButtonClick)];
        _whiteItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    }
    return _whiteItem;
}

- (void)gq_backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView
- (UITableView *)tableView {
    if (!_tableView) {
        if (self.gq_tableStyle != GQBaseTableVCStylePlain) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, GQ_WindowW, GQ_WindowH - GQ_NavBarAndStatusBarH) style:UITableViewStyleGrouped];
        } else {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, GQ_WindowW, GQ_WindowH - GQ_NavBarAndStatusBarH) style:UITableViewStylePlain];
        }
        if (!self.gq_isNeedOnlyTableView) {
            self.view.backgroundColor = [UIColor whiteColor];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = GQ_BackGroundColor;
        if ([_tableView isKindOfClass:[UITableView class]]) {
            _tableView.separatorColor = GQ_Hex_Color(@"eeeeee");
        }
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (void)setGq_tableViewFrame:(CGRect)gq_tableViewFrame {
    _gq_tableViewFrame = gq_tableViewFrame;
    self.tableView.frame = gq_tableViewFrame;
}
- (void)setGq_tableStyle:(GQBaseTableVCStyle)gq_tableStyle {
    _gq_tableStyle = gq_tableStyle;
    [_tableView removeFromSuperview];
    _tableView = nil;
    [self.view addSubview:self.tableView];
}
#pragma mark - UITableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gq_objects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GQ_WindowW, 10)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GQ_WindowW, 10)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - 刷新
- (void)setGq_enableTableHeaderFooter:(BOOL)gq_enableTableHeaderFooter {
    _gq_enableTableHeaderFooter = gq_enableTableHeaderFooter;
    __weak __typeof(&*self) weakSelf = self;
    if (_gq_enableTableHeaderFooter) {
        if (!_tableHeader) {
            _tableHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                if (weakSelf.tableView.mj_footer.isRefreshing) {
                    [weakSelf.tableView.mj_header endRefreshing];
                    return;
                }
                weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
                weakSelf.gq_pageNextIndex = weakSelf.gq_pageStartNum;
                [weakSelf gq_refresh];
            }];
        }
        if (!_tableFooter) {
            _tableFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                if (weakSelf.tableView.mj_header.isRefreshing) {
                    [weakSelf.tableView.mj_footer endRefreshing];
                    return;
                }
                [weakSelf fetchObjectsOnPageNum:weakSelf.gq_pageNextIndex];
            }];
            _tableFooter.stateLabel.font = [UIFont systemFontOfSize:12];
        }
        self.tableView.mj_header = _tableHeader;
        self.tableView.mj_footer = _tableFooter;
    } else {
        self.tableView.mj_footer = nil;
        self.tableView.mj_header = nil;
    }
}

- (void)gq_refresh {
    __weak __typeof(&*self)weakSelf = self;
    if ([NSThread isMainThread]) {
        [self fetchObjectsOnPageNum:self.gq_pageNextIndex];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf fetchObjectsOnPageNum:weakSelf.gq_pageNextIndex];
    });
}
- (void)gq_refreshAgain {
    self.gq_pageNextIndex = GQ_PageStartNum;
    [self gq_refresh];
}
#pragma mark - 请求数据
- (void)fetchObjectsOnPageNum:(NSUInteger)page {
    NSString *url = nil;
    if (!self.gq_getRequestUrlBlock) {  // 用户没有设置 ，直接返回
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        return;
    } else {
        url = self.gq_getRequestUrlBlock(page);
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    }
    
    if (self.gq_isShowLoadView) {
        [[GQShowHudManager gq_shareInstance] gq_showLoadingInView:self.view backgroundIsClear:self.gq_loadViewBackgroundIsClear];
        self.gq_isShowLoadView = NO;
    }
    
    NSDictionary *paras = @{};
    if (self.gq_getRequestParametersBlock) {
        id tmp = self.gq_getRequestParametersBlock();
        if ([tmp isKindOfClass:NSDictionary.class]) paras = tmp;
        else paras = @{};
    }
    
    if (self.gq_isGetRequest) {
        [[GQRequestManager gq_shareInstance] gq_get:url params:paras success:^(NSDictionary *response) {
            [self successDeal:response];
        } failure:^(GQRequestError *error) {
            [self failDeal:error];
        } isShowLoadingView:NO];
    } else {
        [[GQRequestManager gq_shareInstance] gq_post:url params:paras success:^(id responseObject) {
            [self successDeal:responseObject];
        } failure:^(GQRequestError * error) {
            [self failDeal:error];
        } isShowLoadingView:NO];
    }
}

- (void)successDeal:(id)responseObject {
    [[GQShowHudManager gq_shareInstance] gq_hideLoad];
    self.gq_placeHolderView.refreshEnd = YES;
    NSDictionary* json = (NSDictionary *)responseObject;
    [self processResponseWithDictionary:json];
}

- (void)failDeal:(GQRequestError *)error {
    [[GQShowHudManager gq_shareInstance] gq_hideLoad];
    self.gq_placeHolderView.refreshEnd = YES;
    if (self.gq_parseWhenNetworkFailBlock) {
        self.gq_parseWhenNetworkFailBlock(error);
    }
    if (error.orgReponse && !error.orgError) {
        [self gq_noDataResponse:error.orgReponse];
    }
    if (_gq_needPlaceHolderView && self.gq_objects.count==0) {
        self.gq_placeHolderView.hidden = NO;
    }
    if (error.code == -3) {
        self.gq_placeHolderView.noteImg.image = [UIImage imageNamed:[self.gq_placeHolderViewImage length] == 0 ? GQ_PlaceHolderView_NoDataImage : self.gq_placeHolderViewImage];
        self.gq_placeHolderView.noteLab.text = error.info.length > 0 ? error.info : GQ_PlaceHolderView_NoNetText;
        self.gq_placeHolderView.updateButton.hidden = YES;
    }else{
        self.gq_placeHolderView.noteImg.image = [UIImage imageNamed:GQ_PlaceHolderView_NoNetImage];
        self.gq_placeHolderView.noteLab.text = error.info.length > 0 ? error.info : GQ_PlaceHolderView_NoNetText;
        self.gq_placeHolderView.updateButton.hidden = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endRefresh];
    });
}

- (void)processResponseWithDictionary:(NSDictionary *)json {
    __weak __typeof(&*self)weakSelf = self;
    NSArray *objects = [weakSelf gq_parseResponseDictionaryData:json];
    if (objects == nil && self.hasSetNeedPlaceHolderView == NO) {
        _gq_needPlaceHolderView = NO;
    }
    // 下拉刷新 从头开始
    if (weakSelf.gq_pageNextIndex == weakSelf.gq_pageStartNum) {
        [weakSelf.gq_objects removeAllObjects];
        if (weakSelf.gq_didRefreshSuccessBlock) {
            weakSelf.gq_didRefreshSuccessBlock();
        }
    }
    self.gq_pageNextIndex = self.gq_pageNextIndex + 1;
    
    if (weakSelf.gq_objClass && objects.count > 0) {
        NSArray *tmp = [NSArray yy_modelArrayWithClass:weakSelf.gq_objClass json:objects];
        [weakSelf.gq_objects addObjectsFromArray:tmp];
    }

    if (self.gq_dataToModelBlock) {
        self.gq_dataToModelBlock(self.gq_objects);
    }
    if (_gq_needPlaceHolderView) self.gq_placeHolderView.hidden = YES;
    if (self.gq_objects.count == 0) {
        if (_gq_needPlaceHolderView) {
            self.gq_placeHolderView.hidden = NO;
            self.gq_placeHolderView.updateButton.hidden = YES;
            self.gq_placeHolderView.noteLab.text = self.gq_placeHolderViewText.length == 0 ? GQ_PlaceHolderView_NoDataText : self.gq_placeHolderViewText;
            self.gq_placeHolderView.noteImg.image = [UIImage imageNamed:[self.gq_placeHolderViewImage length] == 0 ? GQ_PlaceHolderView_NoDataImage : self.gq_placeHolderViewImage];
        }
    }

    if ([NSThread isMainThread]) {
        [weakSelf reloadTableViewWithObjects:objects];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf reloadTableViewWithObjects:objects];
    });
}

- (void)reloadTableViewWithObjects:(NSArray *)objects {
    if (self.gq_tableViewWillReloadBlock) {
        self.gq_tableViewWillReloadBlock(objects.count);
    }
    
    if (_gq_enableTableHeaderFooter) {
        if (self.gq_objects.count == 0 || objects.count < self.gq_pageSize) {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self.tableFooter setTitle:@"──── 到底啦，别扯啦！ ────" forState:MJRefreshStateNoMoreData];
        }
        [self endRefresh];
    }
    
    if (self.gq_parseBeforeTableViewReloadBlock) self.gq_parseBeforeTableViewReloadBlock();
    [self.tableView reloadData];
    if (self.gq_parseAfterTableViewReloadBlock) self.gq_parseAfterTableViewReloadBlock();
}

// 子类覆盖去解析数据
- (NSArray *)gq_parseResponseDictionaryData:(NSDictionary *)data {
    if ([data isKindOfClass:NSDictionary.class]) {
        return data[@"data"];
    }
    return nil;
}

- (void) gq_noDataResponse:(NSDictionary *)data {
}

- (void)endRefresh {
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)setGq_pageStartNum:(NSInteger)gq_pageStartNum {
    _gq_pageStartNum = gq_pageStartNum;
    self.gq_pageNextIndex = gq_pageStartNum;
}

- (void)setGq_needPlaceHolderView:(BOOL)gq_needPlaceHolderView {
    _gq_needPlaceHolderView = gq_needPlaceHolderView;
    self.hasSetNeedPlaceHolderView = YES;
}

#pragma mark - GQPlaceHolderView
- (GQPlaceHolderView *)gq_placeHolderView {
    if (_gq_placeHolderView == nil) {
        _gq_placeHolderView = [GQPlaceHolderView gq_viewFromXib];
        __weak __typeof(self) weakSelf = self;
        _gq_placeHolderView.resetBtnClickBlock = ^(){
            [weakSelf gq_refresh];
        };
        _gq_placeHolderView.frame = CGRectMake(0, GQ_NavBarAndStatusBarH, GQ_WindowW, GQ_WindowH - GQ_NavBarAndStatusBarH);
        _gq_placeHolderView.hidden = YES;
    }
    if (self.gq_placeHolderViewAddView != nil) {
        [self.gq_placeHolderViewAddView addSubview:_gq_placeHolderView];
    } else {
        [self.tableView addSubview:_gq_placeHolderView];
    }
    if (self.gq_placeHolderViewAddView != nil) {
        [self.gq_placeHolderViewAddView bringSubviewToFront:_gq_placeHolderView];
    } else {
        [self.tableView bringSubviewToFront:_gq_placeHolderView];
    }
    return _gq_placeHolderView;
}

- (void)setGq_placeHolderViewImageTop:(CGFloat)gq_placeHolderViewImageTop {
    _gq_placeHolderViewImageTop = gq_placeHolderViewImageTop;
    self.gq_placeHolderView.topOffset = gq_placeHolderViewImageTop;
}

- (void)setGq_placeHolderViewLeaveSuperViewTop:(CGFloat)gq_placeHolderViewLeaveSuperViewTop {
    _gq_placeHolderViewLeaveSuperViewTop = gq_placeHolderViewLeaveSuperViewTop;
    self.gq_placeHolderView.frame = CGRectMake(0, gq_placeHolderViewLeaveSuperViewTop, GQ_WindowW, self.view.bounds.size.height - gq_placeHolderViewLeaveSuperViewTop);
}

#pragma mark - 监听网络
- (void)startReachable {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable){
            self.gq_placeHolderView.noteImg.image = [UIImage imageNamed:GQ_PlaceHolderView_NoNetImage];
            self.gq_placeHolderView.noteLab.text = GQ_PlaceHolderView_NoNetText;
            //        self.gq_placeHolderView.updateButton.hidden = NO;
        } else {
            self.gq_placeHolderView.noteImg.image = [UIImage imageNamed:[self.gq_placeHolderViewImage length] == 0 ? GQ_PlaceHolderView_NoDataImage : self.gq_placeHolderViewImage];
            self.gq_placeHolderView.noteLab.text = self.gq_placeHolderViewText.length == 0 ? GQ_PlaceHolderView_NoDataText : self.gq_placeHolderViewText;
            self.gq_placeHolderView.updateButton.hidden = YES;
        }
    }];
}

@end
