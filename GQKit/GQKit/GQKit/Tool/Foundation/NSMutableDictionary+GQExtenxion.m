//
//  NSMutableDictionary+GQExtenxion.m
//  SCSupplier
//
//  Created by Apple on 31/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "NSMutableDictionary+GQExtenxion.h"

@implementation NSMutableDictionary (GQExtenxion)
- (void)gq_safeSetObject:(id)obj forKey:(id<NSCopying>)key {
    if (key == nil) {
        return;
    } else if (obj == nil) {
        [self removeObjectForKey:key];
    } else {
        [self setObject:obj forKey:key];
    }
}
@end
