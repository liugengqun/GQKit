//
//  GQPlaceHolderView.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQPlaceHolderView : UIView
/**
 按钮点击回调
 */
@property (nonatomic, copy) void(^resetBtnClickBlock)(void);

@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIImageView *noteImg;
@property (weak, nonatomic) IBOutlet UILabel *noteLab;

/**
 图片距离顶部距离
 */
@property (nonatomic, assign) CGFloat topOffset;

/**
 菊花刷新停止
 */
@property (nonatomic, assign) BOOL refreshEnd;

@end
