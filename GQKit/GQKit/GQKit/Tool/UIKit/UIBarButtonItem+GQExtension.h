//
//  UIBarButtonItem+GQExtension.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (GQExtension)
@property (assign, nonatomic) BOOL enabledClick;
/**
 文字 颜色
 */
+ (UIBarButtonItem *)gq_barButtonItemWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action;
/**
 图片 大小
 */
+ (UIBarButtonItem *)gq_barButtonItemWithImage:(NSString *)image size:(CGSize)size target:(id)target action:(SEL)action;
/**
 图片 大小自适应
 */
+ (UIBarButtonItem *)gq_barButtonItemWithImage:(NSString *)image target:(id)target action:(SEL)action;
/**
 标准实例化
 */
+ (UIBarButtonItem *)gq_barButtonItemWithImage:(NSString *)image title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;
@end
