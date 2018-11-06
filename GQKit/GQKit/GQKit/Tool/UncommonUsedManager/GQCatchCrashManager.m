//
//  GQCatchCrashManager.m
//  GQKit
//
//  Created by Apple on 15/4/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import "GQCatchCrashManager.h"

@implementation GQCatchCrashManager

void gq_uncaughtExceptionHandler(NSException *exception) {
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    NSLog(@"%@", exceptionInfo);
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:stackArray];
    [tmpArr insertObject:reason atIndex:0];
    //保存到本地 下次启动的时候，上传这个log
    [exceptionInfo writeToFile:[NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
@end
