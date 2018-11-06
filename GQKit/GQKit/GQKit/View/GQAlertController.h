//
//  GQAlertController.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQAlertController : UIAlertController
@property (strong, nonatomic) UIFont *gq_messageFont;
@property (strong, nonatomic) UIColor *gq_messageColor; // 系统默认
@property (assign, nonatomic) BOOL gq_dismissOnTapBackgroundView; //YES：用户点击背景可以消除Alert， 默认yes

@property (assign, nonatomic) BOOL gq_isMessageAlignmentLeft;

/**
 buttonTitle: 按钮 文字 从左到右依次显示，
 buttonsColor: 按钮颜色对应按钮文字，循环使用： 默认为 黑色
 completion: 点击回调。 clickedButtonTag 按钮点击下表从左到右， 从0开始
 当 dismissOnTapBackgroundView 为YES， 则clickedButtonTag==-1 时表示点击背后
 message 默认 14 号字体
 **/
+ (instancetype)gq_alertWithMessage:(NSString *)message buttonTitle:(NSArray<NSString *> *)buttonsTitle buttonsColor:(NSArray<UIColor *> *)buttonsColor completion:(void(^)(NSInteger clickedButtonTag))completion;

/**
 message 默认 14 号字体
 **/
+ (instancetype)gq_alertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSArray<NSString *> *)buttonsTitle buttonsColor:(NSArray<UIColor *> *)buttonsColor completion:(void(^)(NSInteger clickedButtonTag))completion;

// 显示 在Delegate ViewController 中
- (void)gq_showInController:(UIViewController *)controller;
- (void)gq_show;
@end
