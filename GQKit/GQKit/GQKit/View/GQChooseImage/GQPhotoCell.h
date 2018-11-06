//
//  GQPhotoCell.h
//  chexiaoxi
//
//  Created by Qun on 16/6/29.
//  Copyright © 2016年 IOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GQPhotoCell;
@protocol GQPhotoCellDelegate <NSObject>
@optional
- (void)photoCellRemovePhotoBtnClickForCell:(GQPhotoCell *)cell;
- (void)photoCellAddImageBtnClickForCell:(GQPhotoCell *)cell hasChooseImg:(BOOL)hasChooseImg;
@end
@interface GQPhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
/** 传递过来的图片 */
@property (nonatomic, strong) id photoImg;

@property (nonatomic, weak) id <GQPhotoCellDelegate>delegate;

@property (nonatomic, assign) BOOL isLoading;
@property(nonatomic, assign) BOOL showUploadMsg;
@end
