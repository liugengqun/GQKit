
//
//  GQHookManager.m
//  GQKit
//
//  Created by Apple on 2/4/18.
//  Copyright © 2018年 GQKit. All rights reserved.
//

#import "GQHookManager.h"
#import <objc/runtime.h>
@implementation GQHookManager

+ (void)gq_hookClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    Class class = classObject;
    Method fromMethod = class_getInstanceMethod(class, fromSelector);
    Method toMethod = class_getInstanceMethod(class, toSelector);
    
    if (class_addMethod(class, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        class_replaceMethod(class, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    } else {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

@end
