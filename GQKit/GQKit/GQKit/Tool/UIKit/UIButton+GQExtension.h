//
//  UIButton+GQExtension.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, GQButtonType) {
    GQButtonTypeImageRightTitleLeft = 0,  // image在右，label在左  系统默认样式
    GQButtonTypeImageLeftTitleRight, // image在左，label在右
    GQButtonTypeImageTopTitleBottom, // image在上，label在下
    GQButtonTypeImageBottomTitleTop, // image在下，label在上
};
@interface UIButton (GQExtension)

/**
 背景图
 */
+ (UIButton *)gq_buttonWithFrame:(CGRect)rect target:(id)target action:(SEL)action backImage:(UIImage *)image onSuperView:(UIView *)superV;

/**
 文字
 */
+ (UIButton *)gq_buttonWithFrame:(CGRect)rect target:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor onSuperView:(UIView *)superV;

/**
 文字 背景默认透明
 */
+ (UIButton *)gq_buttonWithFrame:(CGRect)rect target:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font onSuperView:(UIView *)superV;


/**
 图 + 文字
 */
+ (UIButton *)gq_buttonWithFrame:(CGRect)rect target:(id)target action:(SEL)action image:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor onSuperView:(UIView *)superV;

/**
 后退按钮 传入图片
 */
+ (UIButton *)gq_buttonWithBackButton:(NSString *)imgStr target:(id)target action:(SEL)action;


/**
 button布局
 */
- (void)gq_layoutButtonWithStyle:(GQButtonType)type
               imageTitleSpacing:(CGFloat)spacing;

#pragma mark - 自定义响应边界
/**
 自定义响应边界 UIEdgeInsetsMake(-3, -4, -5, -6). 表示扩大
 */
@property(nonatomic, assign) UIEdgeInsets gq_hitEdgeInsets;
/**
 自定义响应边界 自定义的边界的范围
 */
@property(nonatomic, assign) CGFloat gq_hitScale;
/*
 自定义响应边界 自定义的宽度的范围
 */
@property(nonatomic, assign) CGFloat gq_hitWidthScale;
/*
 自定义响应边界 自定义的高度的范围
 */
@property(nonatomic, assign) CGFloat gq_hitHeightScale;

/**
 获取验证码倒计时button
 */
- (void)gq_timeCountDownStartWithTime:(NSInteger)time title:(NSString *)title countDownTitle:(NSString *)subTitle normalBgColor:(UIColor *)normalBgColor selectBgColor:(UIColor *)selectBgColor normalTitleColor:(UIColor *)normalTitleColor selectTitleColor:(UIColor *)selectTitleColor;

/**
 加载网络图片并设置占位图
 */
- (void)gq_buttonWithUrlStr:(NSString *)urlStr;
- (void)gq_headerButtonViewWithUrlStr:(NSString *)urlStr;
- (void)gq_buttonWithUrlStr:(NSString *)urlStr placeholderImageStr:(NSString *)imageStr;
@end
