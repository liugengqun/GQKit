//
//  GQPhotoBrowserManager.h
//  GQKit
//
//  Created by Apple on 3/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"
@interface GQPhotoBrowserManager : NSObject<MWPhotoBrowserDelegate>

@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) UIViewController *gq_fromVC;

/**
 *  图片浏览器
 *
 *  @param imageArray 数据源--可以是图片数组，也可以是图片url数组(NSUrl)
 */
- (void)gq_showBrowserWithImages:(NSArray *)imageArray;
/**
 *  图片浏览器
 *
 *  @param imageArray 数据源--可以是图片数组，也可以是图片url数组(NSUrl)
 *  @param index      选中的某一张
 */
- (void)gq_showBrowserWithImages:(NSArray*)imageArray currentIndex:(NSInteger)index;


@end
