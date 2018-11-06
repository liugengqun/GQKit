//
//  NSMutableDictionary+GQExtenxion.h
//  SCSupplier
//
//  Created by Apple on 31/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary<KeyType, ObjectType> (GQExtenxion)
- (void)gq_safeSetObject:(nullable ObjectType)obj forKey:(KeyType <NSCopying>)key;
@end

NS_ASSUME_NONNULL_END
