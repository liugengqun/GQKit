//
//  NSDictionary+GQExtension.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "NSDictionary+GQExtension.h"

@implementation NSDictionary (GQExtension)
+ (NSDictionary *)gq_dictWithStr:(NSString *)str {
    if ([str length] == 0) {
        return nil;
    }
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    return dic;
}

- (BOOL)gq_boolValueForKey:(id<NSCopying>)key {
    return [self gq_boolValueForKey:key defaultValue:NO];
}

- (BOOL)gq_boolValueForKey:(id<NSCopying>)key defaultValue:(BOOL)defaultValue {
    id value = [self objectForKey:key];
    
    if (value == [NSNull null] || value == nil) {
        return defaultValue;
    } else {
        return [value boolValue];
    }
}

- (int)gq_intValueForKey:(id<NSCopying>)key {
    return [self gq_intValueForKey:key defaultValue:0];
}

- (int)gq_intValueForKey:(id<NSCopying>)key defaultValue:(int)defaultValue {
    id value = [self objectForKey:key];
    
    if (value == [NSNull null] || value == nil) {
        return defaultValue;
    } else {
        return [value intValue];
    }
}

- (NSString *)gq_stringValueForKey:(id<NSCopying>)key {
    return [self gq_stringValueForKey:key defaultValue:nil];
}

- (NSString *)gq_stringValueForKey:(id<NSCopying>)key defaultValue:(NSString *)defaultValue {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return defaultValue;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return value;
}

- (long long)gq_longLongValueForKey:(id<NSCopying>)key {
    return [self gq_longLongValueForKey:key defaultValue:0];
}

- (long long)gq_longLongValueForKey:(id<NSCopying>)key defaultValue:(long long)defaultValue {
    id value = [self objectForKey:key];
    
    if (value == [NSNull null] || value == nil) {
        return defaultValue;
    } else {
        return [value longLongValue];
    }
}

- (double)gq_doubleValueForKey:(id<NSCopying>)key {
    return [self gq_doubleValueForKey:key defaultValue:0];
}

- (double)gq_doubleValueForKey:(id<NSCopying>)key defaultValue:(double)defaultValue {
    id value = [self objectForKey:key];
    
    if (value == [NSNull null] || value == nil) {
        return defaultValue;
    } else {
        return [value doubleValue];
    }
}

- (NSDictionary *)gq_dictionaryValueForKey:(id<NSCopying>)key {
    NSObject *obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)obj;
    }
    return nil;
}

- (NSArray *)gq_arrayValueForKey:(id<NSCopying>)key {
    NSObject *obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        return (NSArray *)obj;
    }
    return nil;
}

- (time_t)gq_timeValueForKey:(id<NSCopying>)key {
    return [self gq_timeValueForKey:key defaultValue:0];
}

- (time_t)gq_timeValueForKey:(id<NSCopying>)key defaultValue:(time_t)defaultValue {
    id timeObject = [self objectForKey:key];
    if ([timeObject isKindOfClass:[NSNumber class]]) {
        NSNumber *n = (NSNumber *)timeObject;
        CFNumberType numberType = CFNumberGetType((CFNumberRef)n);
        NSTimeInterval t;
        if (numberType == kCFNumberLongLongType) {
            t = [n longLongValue] / 1000;
        }
        else {
            t = [n longValue];
        }
        return t;
    }
    else if ([timeObject isKindOfClass:[NSString class]]) {
        NSString *stringTime   = timeObject;
        if (stringTime.length == 13) {
            long long llt = [stringTime longLongValue];
            NSTimeInterval t = llt / 1000;
            return t;
        }
        else if (stringTime.length == 10) {
            long long lt = [stringTime longLongValue];
            NSTimeInterval t = lt;
            return t;
        }
        else {
            if (!stringTime || (id)stringTime == [NSNull null]) {
                stringTime = @"";
            }
            struct tm created;
            time_t now;
            time(&now);
            
            if (stringTime) {
                if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
                    strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
                }
                return mktime(&created);
            }
        }
    }
    return defaultValue;
}
@end
