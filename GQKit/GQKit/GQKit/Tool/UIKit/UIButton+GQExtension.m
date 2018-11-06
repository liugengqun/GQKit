//
//  UIButton+GQExtension.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "UIButton+GQExtension.h"
#import "UIButton+WebCache.h"
#import <objc/runtime.h>
static const char *kHitEdgeInsets = "hitEdgeInset";
static const char *kHitScale = "hitScale";
static const char *kHitWidthScale = "hitWidthScale";
static const char *kHitHeightScale = "hitWidthScale";
@implementation UIButton (GQExtension)


+ (UIButton *)gq_buttonWithFrame:(CGRect)rect target:(id)target action:(SEL)action backImage:(UIImage *)image onSuperView:(UIView *)superV {
    return [self gq_buttonWithFrame:rect target:target action:action image:image title:@"" titleColor:nil font:nil backgroundColor:nil onSuperView:superV];
}


+ (UIButton *)gq_buttonWithFrame:(CGRect)rect target:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor onSuperView:(UIView *)superV {
    return [self gq_buttonWithFrame:rect target:target action:action image:nil title:title titleColor:titleColor font:font backgroundColor:backgroundColor onSuperView:superV];
}

+ (UIButton *)gq_buttonWithFrame:(CGRect)rect target:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font onSuperView:(UIView *)superV {
    return [self gq_buttonWithFrame:rect target:target action:action image:nil title:title titleColor:titleColor font:font backgroundColor:[UIColor clearColor] onSuperView:superV];
}

+ (UIButton *)gq_buttonWithFrame:(CGRect)rect target:(id)target action:(SEL)action image:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor onSuperView:(UIView *)superV {
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    button.backgroundColor = backgroundColor;
    button.clipsToBounds = YES;
    if (superV != nil && [superV isKindOfClass:[UIView class]]) {
        [superV addSubview:button];
    }
    return button;
}


+ (UIButton *)gq_buttonWithBackButton:(NSString *)imgStr target:(id)target action:(SEL)action {
    UIButton *backButton = [[UIButton alloc]init];
    if (imgStr.length == 0) {
        imgStr = @"返回";
    }
    [backButton setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.imageEdgeInsets=UIEdgeInsetsMake(0,-20,0,0);
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

- (void)gq_layoutButtonWithStyle:(GQButtonType)type
               imageTitleSpacing:(CGFloat)spacing {
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = self.titleLabel.frame.size.width;
    CGFloat labelHeight = self.titleLabel.frame.size.height;
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    switch (type) {
            case GQButtonTypeImageTopTitleBottom: {
                imageEdgeInsets = UIEdgeInsetsMake(- labelHeight - spacing / 2.0, 0, 0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight - spacing / 2.0, 0);
                break;
            }
            case GQButtonTypeImageLeftTitleRight: {
                imageEdgeInsets = UIEdgeInsetsMake(0, -spacing / 2.0, 0, spacing / 2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, spacing / 2.0, 0, -spacing / 2.0);
                break;
            }
            case GQButtonTypeImageBottomTitleTop: {
                imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-spacing/2.0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-spacing/2.0, -imageWith, 0, 0);
                break;
            }
            case GQButtonTypeImageRightTitleLeft: {
                imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing / 2.0, 0, -labelWidth - spacing / 2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith - spacing / 2.0, 0, imageWith + spacing / 2.0);
                break;
            }
        default:
            break;
    }
    
    // 设置图片和文字的相对位置
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

#pragma mark - 自定义响应边界
- (void)setGq_hitEdgeInsets:(UIEdgeInsets)gq_hitEdgeInsets {
    NSValue *value = [NSValue value:&gq_hitEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, kHitEdgeInsets, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIEdgeInsets)gq_hitEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, kHitEdgeInsets);
    UIEdgeInsets edgeInsets;
    [value getValue:&edgeInsets];
    return value ? edgeInsets:UIEdgeInsetsZero;
}
- (void)setGq_hitScale:(CGFloat)gq_hitScale {
    CGFloat width = self.bounds.size.width * gq_hitScale;
    CGFloat height = self.bounds.size.height * gq_hitScale;
    self.gq_hitEdgeInsets = UIEdgeInsetsMake(-height, -width,-height, -width);
    objc_setAssociatedObject(self, kHitScale, @(gq_hitScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)gq_hitScale {
    return [objc_getAssociatedObject(self, kHitScale) floatValue];
}
- (void)setGq_hitWidthScale:(CGFloat)gq_hitScale {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height * gq_hitScale;
    self.gq_hitEdgeInsets = UIEdgeInsetsMake(-height, -width, -height, -width);
    objc_setAssociatedObject(self, kHitScale, @(gq_hitScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)gq_hitWidthScale {
    return [objc_getAssociatedObject(self, kHitWidthScale) floatValue];
}
- (void)setGq_hitHeightScale:(CGFloat)hitHeightScale {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height * hitHeightScale;
    self.gq_hitEdgeInsets = UIEdgeInsetsMake(-height, -width, -height, -width);
    objc_setAssociatedObject(self, kHitHeightScale, @(kHitHeightScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)gq_hitHeightScale {
    return [objc_getAssociatedObject(self, kHitHeightScale) floatValue];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //如果 button 边界值无变化  失效 隐藏 或者透明 直接返回
    if(UIEdgeInsetsEqualToEdgeInsets(self.gq_hitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden || self.alpha == 0 ) {
        return [super pointInside:point withEvent:event];
    } else {
        CGRect relativeFrame = self.bounds;
        CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.gq_hitEdgeInsets);
        return CGRectContainsPoint(hitFrame, point);
    }
}

- (void)gq_timeCountDownStartWithTime:(NSInteger)time title:(NSString *)title countDownTitle:(NSString *)subTitle normalBgColor:(UIColor *)normalBgColor selectBgColor:(UIColor *)selectBgColor normalTitleColor:(UIColor *)normalTitleColor selectTitleColor:(UIColor *)selectTitleColor {
    self.backgroundColor = normalBgColor;
    //倒计时时间
    __block NSInteger timeOut = time;
    dispatch_queue_t queue =       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = normalBgColor;
                [self setTitle:title forState:UIControlStateNormal];
                if (normalTitleColor != nil) {
                    [self setTitleColor:normalTitleColor forState:0];
                }
                self.userInteractionEnabled = YES;
                
            });
        } else {
            int allTime = (int)time + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = selectBgColor;
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                if (selectTitleColor != nil) {
                    [self setTitleColor:selectTitleColor forState:0];
                }
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}


- (void)gq_buttonWithUrlStr:(NSString *)urlStr {
    [self gq_buttonWithUrlStr:urlStr placeholderImageStr:@"占位图"];
}
- (void)gq_headerButtonViewWithUrlStr:(NSString *)urlStr {
    [self gq_buttonWithUrlStr:urlStr placeholderImageStr:@"头像占位图"];
}
- (void)gq_buttonWithUrlStr:(NSString *)urlStr placeholderImageStr:(NSString *)imageStr {
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:0 placeholderImage:[UIImage imageNamed:imageStr]];
}
@end
