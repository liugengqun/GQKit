//
//  GQSearchView.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQSearchView : UIView
/**
 搜索器
 */
@property (nonatomic, weak) UITextField *gq_field;


@property (nonatomic, strong) NSString *gq_leftImageVImage;

/**
 输入结束回调
 */
@property (nonatomic, copy) void (^gq_textFieldEndBlock)(NSString *str);

/**
 点击键盘完成回调
 */
@property (nonatomic, copy) void (^gq_searchBlock)(NSString *str);

/**
 输入文本改变回调
 */
@property (copy, nonatomic) void (^gq_textFieldChangeBlock)(NSString *str);

/**
  textField能否搜索 不能搜索会覆盖一个button  默认yes
 */
@property (nonatomic, assign) BOOL gq_textFieldCanSearch;

/**
 按钮事件回调
*/
@property (copy, nonatomic) void (^gq_touchBtnClickBlock)(void);

/**
 textField 是否在导航栏上 默认no
 */
@property (nonatomic, assign) BOOL gq_textFieldIsNavBar;

@property (nonatomic, assign) CGFloat gq_cornerRadius;

- (void)gq_setFieldPlaceholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor;
@end
