//
//  GQChooseImageViewController.h
//  GQChooseImage
//
//  Created by Qun on 16/9/30.
//  Copyright © 2016年 Qun. All rights reserved.
//

#import <UIKit/UIKit.h>

// 控制器的view的宽度内部控制是设置为屏幕宽度
@protocol GQChooseImageViewControllerDelegate <NSObject>
@optional
- (void)gq_chooseImageViewControllerDidChangeCollectionViewWidth:(CGFloat)width Heigh:(CGFloat)height;
@end

@interface GQChooseImageViewController : UIViewController

/**
 最大可选择图片个数
 */
@property (nonatomic, assign) NSInteger gq_maxImageCount;

/**
 选择的图片数据源
 */
@property (nonatomic, strong) NSMutableArray *gq_dataArr;

/**
 delegate
 */
@property (nonatomic, weak) id <GQChooseImageViewControllerDelegate>gq_delegate;

/**
 *   origin collectionView.origin
 *
 *   itemSize item的size = CGSizeMake(0, 0) 默认collectionView.width = window.width
 *
 *   rowCount 一行几个item = 0 默认 rowCount = 4
 */
- (void)gq_setOrigin:(CGPoint)origin ItemSize:(CGSize)itemSize rowCount:(NSInteger)rowCount;


/**
 传进去图片数组进行显示
 */
@property (nonatomic, strong) NSArray *gq_showPhotos;

@property (copy, nonatomic) void (^gq_chooseImgBlock)(NSArray *imgArr);
@property (copy, nonatomic) void (^gq_removePhotoBlock)(NSUInteger idx);

/**
 图片 停止加载并显示上传图片成功或者失败状态
 */
- (void)gq_setNoLoadingAndUploadStates:(UIImage *)img States:(BOOL)success;
@end
