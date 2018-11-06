//
//  UIView+GQExtension.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GQExtension)
@property (nonatomic, assign) CGFloat gq_x;
@property (nonatomic, assign) CGFloat gq_y;
@property (nonatomic, assign) CGFloat gq_top;
@property (nonatomic, assign) CGFloat gq_bottom;
@property (nonatomic, assign) CGFloat gq_left;
@property (nonatomic, assign) CGFloat gq_right;
@property (nonatomic, assign) CGFloat gq_centerX;
@property (nonatomic, assign) CGFloat gq_centerY;
@property (nonatomic, assign) CGFloat gq_width;
@property (nonatomic, assign) CGFloat gq_height;
@property (nonatomic, assign) CGSize gq_size;
@property (nonatomic, assign) CGPoint gq_origin;

/**
 2X高度适配其他高度
 */
+ (CGFloat)gq_heightFrom2XHeight:(CGFloat)height;
/**
 初始化xib
 xib 文件名字和类名字要一样
 */
+ (id)gq_viewFromXib;

/**
圆角
*/
- (void)gq_viewCornerRadius:(CGFloat)radius;
- (void)gq_viewCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor;

/**
移除子控件
*/
- (void)gq_removeSubviews;

#pragma mark - Animation
/**
 y轴移动
 */
- (void)gq_moveY:(float)time y:(CGFloat)y;
/**
 旋转
 */
- (void)gq_rotationAnimation;
/**
 抖动
 */
- (void)gq_shakeAnimation;
/**
 一直放大再缩小
 */
- (void)gq_scale;
/**
 count次放大再缩小
 */
- (void)gq_scaleWithRepeatCount:(NSInteger)count;
/**
 停止动画
 */
- (void)gq_endAnimation;
@end
