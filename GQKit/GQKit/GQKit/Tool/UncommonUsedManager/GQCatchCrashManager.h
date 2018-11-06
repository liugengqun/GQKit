//
//  GQCatchCrashManager.h
//  GQKit
//
//  Created by Apple on 15/4/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GQCatchCrashManager : NSObject
/*
 捕获崩溃信息保存本地
 didFinishLaunchingWithOptions实现NSSetUncaughtExceptionHandler(&gq_uncaughtExceptionHandler);
 */
void gq_uncaughtExceptionHandler(NSException *exception);
@end

NS_ASSUME_NONNULL_END
