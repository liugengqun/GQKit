//
//  GQTextViewCell.h
//  SnowCrow
//
//  Created by Apple on 9/4/18.
//  Copyright © 2018年 SnowCrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"  
@interface GQTextViewCell : UITableViewCell
/**
 textView
 */
@property (strong, nonatomic) YYTextView *gq_textView;
/**
 textView placeholderText
 */
@property (nonatomic, strong) NSString *gq_placeholderText;
/**
 textView回显文字
 */
@property(nonatomic, strong) NSString *gq_textStr;

/**
 textView限制文字字数 默认500
 */
@property(nonatomic, assign) NSInteger gq_limitTextCount;

/**
 textView输入回调
 */
@property (copy, nonatomic) void (^gq_textViewTextBlock)(NSString *comment);
@end
