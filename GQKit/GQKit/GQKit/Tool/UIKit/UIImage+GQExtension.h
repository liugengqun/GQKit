//
//  UIImage+GQExtension.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GQExtension)
/**
 *  返回未渲染图片
 */
+ (UIImage *)gq_imageWithOriginalRenderingMode:(NSString *)imageName;
/**
 *  返回拉伸图片
 */
+ (UIImage *)gq_imageWithStretchableImage:(NSString *)imageName;
/**
 *  根据颜色返回图片
 */
+ (UIImage *)gq_imageWithColor:(UIColor *)color;

/**
 *  生成一张带有边框的圆形图片
 *
 *  @param borderW     边框宽度
 *  @param borderColor 边框颜色
 *  @param image       要添加边框的图片
 *
 *  @return 生成的带有边框的圆形图片
 */
+ (UIImage *)gq_imageWithBorder:(CGFloat)borderW color:(UIColor *)borderColor image:(UIImage *)image;

/**
 *  根据颜色 尺寸 返回图片
 */
+ (UIImage *)gq_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
*  对图片进行模糊
*/
+ (UIImage *)gq_blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

/**
 *  生成二维码
 */
+ (UIImage *)gq_createQRForString:(NSString *)qrString imageSize:(CGFloat)size;
+ (UIImage *)gq_imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;


/**
 *将图片缩放到指定的CGSize大小
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
+ (UIImage*)gq_image:(UIImage *)image scaleToSize:(CGSize)size;
/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)gq_imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/**
 将图片旋转弧度radians
 */
- (UIImage *)gq_imageRotatedByRadians:(CGFloat)radians;
/**
 将图片旋转角度degrees
 */
- (UIImage *)gq_imageRotatedByDegrees:(CGFloat)degrees;
@end
