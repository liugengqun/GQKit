//
//  GQSingleButtonCell.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQSingleButtonCell : UITableViewCell
@property (strong, nonatomic) UIButton *gq_button;
@property (nonatomic, strong) NSString *gq_buttonTitle;
@property (nonatomic, strong) NSString *gq_buttonBgImg;
@property (nonatomic, strong) UIColor *gq_buttonBgColor;
@property (nonatomic, strong) UIColor *gq_buttonTitleColor;
@property (nonatomic, strong) UIFont *gq_buttonTitleFont;
@property (nonatomic, assign) CGSize gq_buttonSize;
@property (nonatomic, assign) BOOL gq_buttonCircle;
@property (nonatomic, copy) void (^gq_btnClickBlock)(void);
@end
