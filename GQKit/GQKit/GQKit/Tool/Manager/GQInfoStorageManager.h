//
//  GQInfoStorage.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQInfoStorageManager : NSObject
+ (void)gq_removeObjectForKey:(NSString *)key;
+ (void)gq_saveObject:(id)object forKey:(NSString *)key;
+ (id)gq_getObjectForKey:(NSString *)key;
+ (void)gq_saveBool:(BOOL)boo forKey:(NSString *)key;
+ (BOOL)gq_getBoolForKey:(NSString *)key;
@end
