//
//  GQDoubleButtonCell.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQDoubleButtonCell : UITableViewCell
@property (strong, nonatomic) UIButton *gq_leftButton;
@property (strong, nonatomic) UIButton *gq_rightButton;

@property (nonatomic, strong) NSString *gq_leftButtonTitle;
@property (nonatomic, strong) NSString *gq_rightButtonTitle;

@property (nonatomic, copy) void (^gq_leftBtnClickBlock)(void);
@property (nonatomic, copy) void (^gq_rightBtnClickBlock)(void);


@end
