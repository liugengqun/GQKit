//
//  UINavigationController+GQExtension.m
//  GQKit
//
//  Created by Apple on 28/2/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import "UINavigationController+GQExtension.h"
#import "GQKit.h"
#define GQ_NavTitleFont [UIFont systemFontOfSize:16]
#define GQ_NavTitleColor   GQ_Hex_Color(@"36404a")
#define GQ_NavColor  [UIColor whiteColor]
@implementation UINavigationController (GQExtension)
- (void)gq_setDefaultNavTitleTextAttributesWithTitleColor:(nullable UIColor *)titleColor titleFont:(nullable UIFont *)titleFont {
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : titleColor == nil ? GQ_NavTitleColor : titleColor, NSFontAttributeName : titleFont == nil ? GQ_NavTitleFont : titleFont}];
}

- (void)gq_setClearNavTitleTextAttributesWithTitleFont:(nullable UIFont *)titleFont {
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : titleFont == nil ? GQ_NavTitleFont : titleFont}];
}

- (void)gq_setDefaultNav {
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = GQ_NavColor;
    self.navigationBar.backgroundColor = GQ_NavColor;
    [self.navigationBar setBackgroundImage:[UIImage gq_imageWithColor:GQ_NavColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)gq_setClearNav {
    self.navigationBar.translucent = YES;
    self.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationBar setBackgroundImage:[UIImage gq_imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)gq_setShadowImageBeClear {
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (void)gq_setShadowImageBeLine {
    [self.navigationBar setShadowImage:[UIImage gq_imageWithColor:GQ_RGB_COLOR(235, 235, 235)]];
}
@end
