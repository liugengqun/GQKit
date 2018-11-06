//
//  UIImageView+GQExtenxion.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GQExtenxion)
/**
 实例化 Frame + 图片名
 */
+ (UIImageView *)gq_imageViewWithFrame:(CGRect)rect image:(UIImage *)image onSuperView:(UIView *)superV;

/**
 加载网络图片并设置占位图
 */
- (void)gq_imageViewWithUrlStr:(NSString *)urlStr;
- (void)gq_headerImageViewWithUrlStr:(NSString *)urlStr;
- (void)gq_imageViewWithUrlStr:(NSString *)urlStr placeholderImageStr:(NSString *)imageStr;
@end
