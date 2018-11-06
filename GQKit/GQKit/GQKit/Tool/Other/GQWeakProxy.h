//
//  GQWeakProxy.h
//  GQKit
//
//  Created by 刘耿群 on 2019/6/21.
//  Copyright © 2019 GQKit. All rights reserved.
//

/**
 这是一个中间代理类，持有一个弱引用对象
 可以避免循环引用，比如用于NSTimer
 
 @implementation GQView {
     NSTimer *_timer;
 }
 
 - (void)initTimer {
     GQWeakProxy *proxy = [GQWeakProxy gq_proxyWithTarget:self];
     _timer = [NSTimer timerWithTimeInterval:0.1 target:proxy selector:@selector(sel:) userInfo:nil repeats:YES];
 }
 
 - (void)sel:(NSTimer *)timer {
 
 }
 @end
 
 */

#import <Foundation/Foundation.h>

@interface GQWeakProxy : NSProxy
/**
 为目标对象创建一个代理.
 
 @param target 目标对象.
 
 @return 代理.
 */
- (instancetype)gq_initWithTarget:(id)target;

/**
 为目标对象创建一个代理.
 
 @param target 目标对象.
 
 @return 代理.
 */
+ (instancetype)gq_proxyWithTarget:(id)target;
@end

