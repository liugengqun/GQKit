//
//  NSString+GQExtension.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (GQExtension)
/**
 string不为nil 为nil返回空串
 */
- (NSString *)gq_strNotNil;

/**
 给某部分文字加上富文本
 */
- (NSMutableAttributedString *)gq_attStringWithAttributes:(NSDictionary *)attibute atString:(NSString *)string;

/**
 根据文字大小还有最大宽度算出size
 */
- (CGFloat)gq_sizeWithFont:(UIFont *)font andWidth:(CGFloat)width;


/**
 获取url参数
 */
- (NSDictionary *)gq_getUrlParameters;

/**
 是否是链接
 */
- (BOOL)gq_isValidUrl;

/**
 拼接路径
 */
- (NSString *)gq_appendStringPath:(NSString *)path;

/**
 合法电话号码
 */
- (BOOL)gq_isValidTelNumber;
@end
