//
//  UIColor+GQExtension.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GQExtension)
+ (UIColor *)gq_colorWithHexString: (NSString *)color;
+ (UIColor *)gq_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)gq_colorWithImg:(NSString *)imageName;
@end
