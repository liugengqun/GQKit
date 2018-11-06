//
//  GQChooseImageManager.h
//  GQKit
//
//  Created by Apple on 3/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface GQChooseImageManager : NSObject
/// 是否需要录制视频按钮 默认NO
@property (nonatomic, assign) BOOL gq_needVideo;
/// 是否需要录制视频按钮 默认Yes
@property (nonatomic, assign) BOOL gq_needPicture;

- (void)gq_chooseImageShowInViewController:(UIViewController *)vc;
@property (nonatomic, copy) void(^gq_chooseImageBlock)(UIImage *image);
@property (nonatomic, copy) void(^gq_chooseVideoBlock)(PHAsset *asset, NSURL *url, NSData *urlData);
@property (nonatomic, assign) BOOL gq_needCrop;
/*
 图片裁剪比例
 */
@property (nonatomic, assign) CGSize gq_customAspectRatio;


@property (nonatomic, strong) UIView *gq_exampleView;
@property (nonatomic, assign) CGFloat gq_exampleViewH;



@end
