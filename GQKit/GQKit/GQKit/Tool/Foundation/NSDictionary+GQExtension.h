//
//  NSDictionary+GQExtension.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary<KeyType, ObjectType> (GQExtension)
/** json字符串 变 字典 */
+ (NSDictionary *)gq_dictWithStr:(NSString *)str;

#pragma mark - 取值 有默认值
- (BOOL)gq_boolValueForKey:(KeyType <NSCopying>)key;
- (BOOL)gq_boolValueForKey:(KeyType <NSCopying>)key defaultValue:(BOOL)defaultValue;
- (int)gq_intValueForKey:(KeyType <NSCopying>)key;
- (int)gq_intValueForKey:(KeyType <NSCopying>)key defaultValue:(int)defaultValue;
- (long long)gq_longLongValueForKey:(KeyType <NSCopying>)key;
- (long long)gq_longLongValueForKey:(KeyType <NSCopying>)key defaultValue:(long long)defaultValue;
- (nullable NSString *)gq_stringValueForKey:(KeyType <NSCopying>)key;
- (nullable NSString *)gq_stringValueForKey:(KeyType <NSCopying>)key defaultValue:(nullable NSString *)gq_defaultValue;
- (nullable NSDictionary *)gq_dictionaryValueForKey:(KeyType <NSCopying>)key;
- (nullable NSArray *)gq_arrayValueForKey:(KeyType <NSCopying>)key;
- (double)gq_doubleValueForKey:(KeyType <NSCopying>)key;
- (double)gq_doubleValueForKey:(KeyType <NSCopying>)key defaultValue:(double)defaultValue;
- (time_t)gq_timeValueForKey:(KeyType <NSCopying>)key;
- (time_t)gq_timeValueForKey:(KeyType <NSCopying>)key defaultValue:(time_t)defaultValue;
@end
