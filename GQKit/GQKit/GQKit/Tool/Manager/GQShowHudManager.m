//
//  GQShowHudManager.m
//  GQKit
//
//  Created by Apple on 6/1/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import "GQShowHudManager.h"
#import "MBProgressHUD.h"
#import "GQLoadingView.h"

#import "GQKit.h"
@interface GQShowHudManager()
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) GQLoadingView *loadingView;
/** 是否有键盘 是否有输入框成为第一响应者 */
@property (nonatomic, assign) BOOL isHaveKeyboard;
@end
@implementation GQShowHudManager

+ (instancetype)gq_shareInstance {
    static GQShowHudManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GQShowHudManager alloc] init];
    });
    return instance;
}

#pragma mark - showLoading
- (void)gq_showLoadingInView:(UIView*)view backgroundIsClear:(BOOL)isClear {
    if (self.gq_type == GQShowHudManagerTypeLoadingView) {
        [self gq_showLoadingWithMessage:@"" yOffset:0 HUDMode:MBProgressHUDModeCustomView inView:view backgroundIsClear:isClear];
    } else {
        [self gq_showLoadingWithMessage:@"" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate inView:view backgroundIsClear:isClear];
    }
}

- (void)gq_showLoadingInView:(UIView*)view hint:(NSString*)title backgroundIsClear:(BOOL)isClear {
    GQ_dispatch_main_async_safe(^{
        if (self.gq_type == GQShowHudManagerTypeLoadingView) {
            [self gq_showLoadingWithMessage:title yOffset:0 HUDMode:MBProgressHUDModeCustomView inView:view backgroundIsClear:isClear];
        } else {
            [self gq_showLoadingWithMessage:@"" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate inView:view backgroundIsClear:isClear];
        }
    });
}
- (void)setLoadingView {
    if (self.loadingView == nil) {
        self.loadingView = [[GQLoadingView alloc]init];
        self.loadingView.gq_size = CGSizeMake(150, 150);
    }
}
- (void)gq_hideLoad {
    [self gq_hideHud];
}

#pragma mark - HUD
- (void)findSubView:(UIView*)view {
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isFirstResponder]) {
            self.isHaveKeyboard = YES;
            *stop = YES;
        } else {
            [self findSubView:obj];
        }
    }];
}


- (void)gq_showMessage:(NSString *)message {
    [self findSubView:[UIApplication sharedApplication].keyWindow];
    if (self.isHaveKeyboard) {
        [self gq_showMessage:message yOffset:-180];
    } else {
        [self gq_showMessage:message yOffset:0];
    }
}

- (void)gq_showMessage:(NSString *)message delay:(CGFloat)time completion:(void(^)(void))completion {
    [self gq_showMessage:message yOffset:0 delay:time completion:completion];
}

- (void)gq_showMessage:(NSString *)message yOffset:(float)yOffset delay:(CGFloat)time completion:(void(^)(void))completion {
    if (message.length == 0) {
        return;
    }
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [MBProgressHUD hideHUDForView:view animated:NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.labelText = message;
    hud.labelColor = [UIColor whiteColor];
    
    CGFloat offset = hud.yOffset;
    offset = 180 + yOffset;
    hud.yOffset = offset;
    hud.completionBlock = ^(){
        if (completion) completion();
    };
    
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}

- (void)gq_showMessage:(NSString *)message yOffset:(float)yOffset {
    [self gq_showMessage:message yOffset:yOffset delay:1.6 completion:nil];
}

- (void)gq_hideHud{
    [[self HUD] hide:YES];
}

- (void)gq_showLoadingWithMessage:(NSString *)message yOffset:(float)yOffset HUDMode:(MBProgressHUDMode)mode inView:(UIView*)hubView backgroundIsClear:(BOOL)isClear {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [MBProgressHUD hideHUDForView:view animated:NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:hubView == nil ? view : hubView animated:YES];
    hud.userInteractionEnabled = YES;
    hud.mode = mode;
    if (hud.mode == MBProgressHUDModeCustomView){
        [self setLoadingView];
        hud.customView = self.loadingView;
        hud.color = [UIColor clearColor];
    }
    hud.margin = 10.f;
    hud.labelText = message;
    hud.labelColor = [UIColor whiteColor];
    
    if (!isClear) {
        hud.backgroundColor = [UIColor whiteColor];
    } else {
        hud.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    
    CGFloat offset = hud.yOffset;
    offset = 0 + yOffset;
    hud.yOffset = offset;
    hud.removeFromSuperViewOnHide = YES;
    self.HUD = hud;
}
@end
