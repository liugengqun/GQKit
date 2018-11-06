//
//  GQCacheManager.m
//
//
//  Created by Qun on 14/11/22.
//  Copyright © 2014年 Qun. All rights reserved.
//

#import "GQCacheManager.h"

@implementation GQCacheManager


+ (void)gq_getCacheSizeWithDirectoryPath:(NSString *)directoryPath completion:(void(^)(NSInteger))completionBlock {
    // 开启异步任务
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        // 1.创建文件管理者
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        // 判断下当前文件是否存在,是否是文件夹
        BOOL isDirectory;
        BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
        
        if (!isExist || !isDirectory) {
            NSException *excp =  [NSException exceptionWithName:@"fileError" reason:@"传入文件不存在,或者不是文件夹,请传文件夹" userInfo:nil];
            [excp raise];
        }
        
        // 2.获取文件夹中所有文件路径
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        NSInteger totalSize = 0;
        
        // 2.1 遍历文件夹中所有子路径
        for (NSString *subPath in subPaths) {
            // 2.2 拼接文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            // 排除隐藏文件
            if ([filePath containsString:@".DS"]) continue;
            
            // 排除文件夹
            BOOL isDirectory;
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isExist || isDirectory) continue;
            
            // 2.3 获取这个路径信息
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
            
            totalSize += [attr fileSize];
        }
        totalSize = totalSize / ( 1024.0 * 1024.0);
        // 一定要记得在主线程调用block
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(totalSize);
            }
        });
        
    });
}

+ (void)gq_removeDirectoryPath:(NSString *)directoryPath {
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 判断下当前文件是否存在,是否是文件夹
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        NSException *excp =  [NSException exceptionWithName:@"fileError" reason:@"传入文件不存在,或者不是文件夹,请传文件夹" userInfo:nil];
        [excp raise];
    }
    
    // 获取文件夹中所有文件
    NSArray *contentPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    
    // 遍历所有子路径
    for (NSString *contentPath in contentPaths) {
        NSString *filePath = [directoryPath stringByAppendingPathComponent:contentPath];
        [mgr removeItemAtPath:filePath error:nil];
    }
}

@end
