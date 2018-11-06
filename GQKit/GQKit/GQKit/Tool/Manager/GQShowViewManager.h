//
//  GQShowViewManager.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, GQShowViewManagerAnmiType)
{
    GQShowViewManagerAnmiTypeNone,
    GQShowViewManagerAnmiTypeBottom,
    GQShowViewManagerAnmiTypeFallCenter,
};
@interface GQShowViewManager : NSObject
/// 弹出动画类型
@property (nonatomic, assign) GQShowViewManagerAnmiType gq_anmiType;
/// 是否对键盘监听弹出收起 默认no
@property (nonatomic, assign) BOOL gq_needKeyboardObserver;
/// 点击背景取消 默认yes
@property (nonatomic, assign) BOOL gq_touchBgViewToCancel;
/// 背景view的frame 默认window
@property (nonatomic, assign) CGRect gq_bgViewFrame;
/// 背景view的颜色
@property (nonatomic, strong) UIColor *gq_bgViewColor;

/// show
- (void)gq_showWithSubView:(UIView *)subView;
- (void)gq_showWithSubView:(UIView *)subView onView:(UIView *)onView;
- (void)gq_cancel;

@property (copy, nonatomic) void (^gq_cancelBlock)(void);
@property (copy, nonatomic) void (^gq_keyboardWillHideBlock)(void);
@end
