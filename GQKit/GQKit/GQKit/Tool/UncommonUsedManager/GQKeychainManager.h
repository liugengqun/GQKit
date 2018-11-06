//
//  GQKeychainManager.h
//  GQKit
//
//  Created by Apple on 10/4/17.
//  Copyright © 2017年 GQKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQKeychainManager : NSObject
/** 根据特定的Service创建一个用于操作KeyChain的Dictionary */
+ (NSMutableDictionary *)gq_getKeychainQuery:(NSString *)service;
/** 增 */
+ (void)gq_saveKeychain:(NSString *)service data:(id)data;
/** 查 */
+ (id)gq_getKeychain:(NSString *)service;
/** 改 */
+ (BOOL)gq_updateKeychain:(id)data forService:(NSString *)service;
/** 删 */
+ (void)gq_deleteKeychain:(NSString *)service;
@end
