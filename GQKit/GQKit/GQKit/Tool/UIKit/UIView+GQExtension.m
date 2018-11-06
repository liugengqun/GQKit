//
//  UIView+GQExtension.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "UIView+GQExtension.h"
#import "GQKit.h"
@implementation UIView (GQExtension)

- (void)setGq_x:(CGFloat)gq_x {
    CGRect frame = self.frame;
    frame.origin.x = gq_x;
    self.frame = frame;
}
- (CGFloat)gq_x {
    return self.frame.origin.x;
}

- (void)setGq_y:(CGFloat)gq_y {
    CGRect frame = self.frame;
    frame.origin.y = gq_y;
    self.frame = frame;
}
- (CGFloat)gq_y {
    return self.frame.origin.y;
}

- (void)setGq_top:(CGFloat)gq_top {
    CGRect frame = self.frame;
    frame.origin.x = gq_top;
    self.frame = frame;
}
- (CGFloat)gq_top {
    return self.frame.origin.y;
}

- (void)setGq_bottom:(CGFloat)gq_bottom {
    CGRect frame = self.frame;
    frame.origin.y = gq_bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)gq_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setGq_centerX:(CGFloat)gq_centerX {
    CGPoint center = self.center;
    center.x = gq_centerX;
    self.center = center;
}
- (CGFloat)gq_centerX {
    return self.center.x;
}

- (void)setGq_centerY:(CGFloat)gq_centerY {
    CGPoint center = self.center;
    center.y = gq_centerY;
    self.center = center;
}
- (CGFloat)gq_centerY {
    return self.center.y;
}

- (void)setGq_width:(CGFloat)gq_width {
    CGRect frame = self.frame;
    frame.size.width = gq_width;
    self.frame = frame;
}
- (CGFloat)gq_width {
    return self.frame.size.width;
}

- (void)setGq_height:(CGFloat)gq_height {
    CGRect frame = self.frame;
    frame.size.height = gq_height;
    self.frame = frame;
}
- (CGFloat)gq_height {
    return self.frame.size.height;
}


- (void)setGq_left:(CGFloat)gq_left {
    CGRect frame = self.frame;
    frame.origin.x = gq_left;
    self.frame = frame;
}
-(CGFloat)gq_left {
    return self.frame.origin.x;
}


- (void)setGq_right:(CGFloat)gq_right {
    CGRect frame = self.frame;
    frame.origin.x = gq_right - frame.size.width;
    self.frame = frame;
}
-(CGFloat)gq_right {
    return self.frame.origin.x + self.frame.size.width;
}


- (void)setGq_size:(CGSize)gq_size {
    CGRect frame = self.frame;
    frame.size = gq_size;
    self.frame = frame;
}
- (CGSize)gq_size {
    return self.frame.size;
}

- (void)setGq_origin:(CGPoint)gq_origin {
    CGRect frame = self.frame;
    frame.origin = gq_origin;
    self.frame = frame;
}
- (CGPoint)gq_origin {
    return self.frame.origin;
}

+ (CGFloat)gq_heightFrom2XHeight:(CGFloat)height {
    if (GQ_iPhone5) {
        return height * 320 / 375 ;
    } else if (GQ_iPhone6Plus) {
        return height * 414 / 375;
    } else if (GQ_iPhoneXSMax || GQ_iPhoneXR) {
        return height * 414 / 375;
    }
    return height;
}

+ (id)gq_viewFromXib {
    NSString *clazz = NSStringFromClass(self);
    NSString *path = [[NSBundle mainBundle] pathForResource:clazz ofType:@"nib"];
    if (path) {
        NSArray *tmp = [[NSBundle mainBundle] loadNibNamed:clazz owner:nil options:nil];
        UIView *view = [tmp lastObject];
        return view;
    }
    
    UIView *view = [[NSClassFromString(clazz) alloc] init];
    return view;
}

- (void)gq_viewCornerRadius:(CGFloat)radius {
    if (radius > 0) {
        self.layer.cornerRadius = radius;
        self.clipsToBounds = YES;
    }
}

- (void)gq_viewCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1;
    [self gq_viewCornerRadius:radius];
}

- (void)gq_removeSubviews {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

#pragma mark - Animation
- (void)gq_moveY:(float)time y:(CGFloat)y {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.toValue = @(y) ;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:nil];
}
- (void)gq_rotationAnimation {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: - M_PI * 2.0 ];
    rotationAnimation.duration = 0.25;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)gq_shakeAnimation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(GQ_DegreesToRadian(-5)),@(GQ_DegreesToRadian(5)),@(GQ_DegreesToRadian(-5)),@(GQ_DegreesToRadian(0))];
    anim.repeatCount =  1;
    anim.duration = 0.5;
    [self.layer addAnimation:anim forKey:nil];
}
- (void)gq_scale {
    [self gq_scaleWithRepeatCount:MAXFLOAT];
}

- (void)gq_scaleWithRepeatCount:(NSInteger)count {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.2;
    animation.repeatCount = count;
    animation.autoreverses = YES;
    animation.fromValue = [NSNumber numberWithFloat:1];
    animation.toValue = [NSNumber numberWithFloat:1.3];
    
    animation.removedOnCompletion = NO;
    animation.fillMode= kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)gq_endAnimation {
    [self.layer removeAllAnimations];
}

@end
