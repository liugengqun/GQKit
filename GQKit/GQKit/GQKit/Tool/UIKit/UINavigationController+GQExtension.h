//
//  UINavigationController+GQExtension.h
//  GQKit
//
//  Created by Apple on 28/2/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (GQExtension)
/**
 导航栏文字默认样式
 */
- (void)gq_setDefaultNavTitleTextAttributesWithTitleColor:(nullable UIColor *)titleColor titleFont:(nullable UIFont *)titleFont;

/**
 导航栏透明时候文字样式
 */
- (void)gq_setClearNavTitleTextAttributesWithTitleFont:(nullable UIFont *)titleFont;

/**
 导航栏默认样式
 */
- (void)gq_setDefaultNav;

/**
 导航栏透明
 */
- (void)gq_setClearNav;

/**
 导航栏无下划线 透明
 */
- (void)gq_setShadowImageBeClear;

/**
 导航栏有下划线
 */
- (void)gq_setShadowImageBeLine;
@end

NS_ASSUME_NONNULL_END
