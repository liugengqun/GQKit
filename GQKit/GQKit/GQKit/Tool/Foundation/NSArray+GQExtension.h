//
//  NSArray+GQExtension.h
//  GQKit
//
//  Created by Apple on 9/1/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//


#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSArray (GQExtension)
/** json字符串 变 数组 */
+ (NSArray *)gq_arrayWithStr:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
