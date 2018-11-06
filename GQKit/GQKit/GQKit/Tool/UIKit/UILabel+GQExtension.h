//
//  UILabel+GQExtension.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (GQExtension)
/**
 标准实例化
 */
+ (UILabel *)gq_labelWithFrame:(CGRect)rect text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment onSuperView:(UIView *)superV;

/**
 改变行间距
 */
+ (void)gq_changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 改变字间距
 */
+ (void)gq_changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 改变行间距和字间距
 */
+ (void)gq_changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;
@end
