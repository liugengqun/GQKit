//
//  GQCacheManager.h
//
//
//  Created by Qun on 14/11/22.
//  Copyright © 2014年 Qun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQCacheManager : NSObject
/**
 *  获取缓存尺寸
 */
+ (void)gq_getCacheSizeWithDirectoryPath:(NSString *)directoryPath completion:(void(^)(NSInteger))completionBlock;

/**
 *  删除文件夹
 */
+ (void)gq_removeDirectoryPath:(NSString *)directoryPath;

@end
