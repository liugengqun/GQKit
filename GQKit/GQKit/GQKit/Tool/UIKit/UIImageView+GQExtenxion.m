//
//  UIImageView+GQExtenxion.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "UIImageView+GQExtenxion.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (GQExtenxion)

+ (UIImageView *)gq_imageViewWithFrame:(CGRect)rect image:(UIImage *)image onSuperView:(UIView *)superV{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = image;
    if (superV != nil && [superV isKindOfClass:[UIView class]]) {
        [superV addSubview:imageView];
    }
    return imageView;
}


- (void)gq_imageViewWithUrlStr:(NSString *)urlStr {
    [self gq_imageViewWithUrlStr:urlStr placeholderImageStr:@"占位图"];
}
- (void)gq_headerImageViewWithUrlStr:(NSString *)urlStr {
    [self gq_imageViewWithUrlStr:urlStr placeholderImageStr:@"头像占位图"];
}
- (void)gq_imageViewWithUrlStr:(NSString *)urlStr placeholderImageStr:(NSString *)imageStr {
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:imageStr]];
}
@end
