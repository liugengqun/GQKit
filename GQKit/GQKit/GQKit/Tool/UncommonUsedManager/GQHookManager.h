//
//  GQHookManager.h
//  GQKit
//
//  Created by Apple on 2/4/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GQHookManager : NSObject
/** 交换方法 */
+ (void)gq_hookClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector;
@end

NS_ASSUME_NONNULL_END
