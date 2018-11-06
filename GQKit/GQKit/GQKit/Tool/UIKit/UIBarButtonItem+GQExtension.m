//
//  UIBarButtonItem+GQExtension.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "UIBarButtonItem+GQExtension.h"
#import "GQKit.h"
@implementation UIBarButtonItem (GQExtension)
@dynamic enabledClick;
-(void)setEnabledClick:(BOOL)enabledClick {
    if (self.customView && [self.customView isKindOfClass:[UIButton class]]) {
        UIButton *btn = self.customView;
        btn.enabled = enabledClick;
    }
}

-(BOOL)enabledClick {
    return YES;
}

+ (UIBarButtonItem *)gq_barButtonItemWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action {
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:color forState:UIControlStateNormal];
    [rightBtn setTitleColor:GQ_RGB_COLOR(102,102,102) forState:UIControlStateDisabled];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [rightBtn sizeToFit];
    if (rightBtn.gq_width < 45) {
        rightBtn.gq_width = 45;
    }
    rightBtn.gq_height = 44;
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    return item;
}

+ (UIBarButtonItem *)gq_barButtonItemWithImage:(NSString *)image size:(CGSize)size target:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if (size.width == 0 || size.height == 0) {
        [btn sizeToFit];
    } else {
        btn.gq_size = size;
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)gq_barButtonItemWithImage:(NSString *)image target:(id)target action:(SEL)action {
    return [self gq_barButtonItemWithImage:image size:CGSizeZero target:target action:action];
}

+ (UIBarButtonItem *)gq_barButtonItemWithImage:(NSString *)image title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn sizeToFit];
    [btn gq_layoutButtonWithStyle:GQButtonTypeImageLeftTitleRight imageTitleSpacing:2];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}


@end
