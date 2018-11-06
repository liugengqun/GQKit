//
//  GQKeychainManager.m
//  GQKit
//
//  Created by Apple on 10/4/17.
//  Copyright © 2017年 GQKit. All rights reserved.
//

#import "GQKeychainManager.h"

@implementation GQKeychainManager
/*
 extern const CFStringRef kSecClassGenericPassword 一般密码
 extern const CFStringRef kSecClassInternetPassword 互联网密码
 extern const CFStringRef kSecClassCertificate 证书
 extern const CFStringRef kSecClassKey 秘钥
 extern const CFStringRef kSecClassIdentity 身份对象，包含kSecClassKey和kSecClassCertificate
 */
+ (NSMutableDictionary *)gq_getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

+ (void)gq_saveKeychain:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [GQKeychainManager gq_getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)gq_getKeychain:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [GQKeychainManager gq_getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (BOOL)gq_updateKeychain:(id)data forService:(NSString *)service {
    NSMutableDictionary *keychainQuery =  [GQKeychainManager gq_getKeychainQuery:service];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    [updateDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status = SecItemUpdate((CFDictionaryRef)keychainQuery,
                                    (CFDictionaryRef)updateDictionary);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (void)gq_deleteKeychain:(NSString *)service {
    NSMutableDictionary *keychainQuery = [GQKeychainManager gq_getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
@end
