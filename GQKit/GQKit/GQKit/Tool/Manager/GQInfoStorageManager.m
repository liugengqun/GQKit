//
//  GQInfoStorage.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQInfoStorageManager.h"

@implementation GQInfoStorageManager

+ (void)gq_removeObjectForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)gq_saveObject:(id)object forKey:(NSString *)key {
    if (object) {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (id)gq_getObjectForKey:(NSString *)key {
    if (key) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil;
}

+ (void)gq_saveBool:(BOOL)boo forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:boo forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)gq_getBoolForKey:(NSString *)key {
    if (key) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:key];
    }
    return nil;
}

@end
