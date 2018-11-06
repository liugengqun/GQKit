//
//  GQSystemModifyDefaultCell.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, GQSystemModifyDefaultCellType)
{
    GQSystemModifyDefaultCellTypeDisclosureIndicator,
    GQSystemModifyDefaultCellTypeSwitch,
};
@interface GQSystemModifyDefaultCell : UITableViewCell

/**
 隐藏分割线 默认no
 */
@property (assign, nonatomic) BOOL gq_hideSeparatorLine;


/**
 设置最左边image的大小
 */
@property (assign, nonatomic) CGSize gq_imageSize;

@property (assign, nonatomic) GQSystemModifyDefaultCellType gq_cellType;

#pragma mark - GQSystemModifyDefaultCellTypeDisclosureIndicator
- (void)gq_setupAccessoryBtnWithTitle:(NSString *)accessoryBtnTitle img:(NSString *)accessoryBtnImg titleColor:(UIColor *)titleColor;

@property (strong, nonatomic) UIButton *gq_accessoryBtnView;
/**
默认12
*/
@property (nonatomic, strong) UIFont *gq_accessoryBtnViewFont;

/**
要设置gq_accessoryBtnView.userInteractionEnabled = YES
*/
@property (copy, nonatomic) void (^gq_accessoryBtnViewClickBlock)(void);


#pragma mark - GQSystemModifyDefaultCellTypeSwitch
@property (nonatomic, strong) UISwitch *gq_swi;
@property (nonatomic, strong) UIColor *gq_swiOnTintColor;
@property (assign, nonatomic) BOOL gq_swiOn;
@property (copy, nonatomic) void (^gq_switchActionBlock)(UISwitch *swi);
@end
