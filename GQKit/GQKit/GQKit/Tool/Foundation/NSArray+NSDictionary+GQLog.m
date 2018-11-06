//
//  NSArray+NSDictionary+HLLLog.m
//  GQKit
//
//  Created by Apple on 9/1/17.
//  Copyright © 2017年 GQKit. All rights reserved.
//

#ifdef DEBUG

#import "NSArray+NSDictionary+GQLog.h"
#import <objc/runtime.h>

NSString *__t_log_getJSONString(id obj) {
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        NSError *error;
        NSJSONWritingOptions opt = NSJSONWritingPrettyPrinted;
        if (@available(iOS 11, *)) {
            opt = NSJSONWritingPrettyPrinted | NSJSONWritingSortedKeys;
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                           options:opt
                                                             error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *removeSlashJson = [json stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        return [NSString stringWithFormat:@"\n%@", removeSlashJson];
    }
    return nil;
}

int indentationDegree = 0;
NSString *__t_log_joiningString(id obj, NSString *beginStr, NSString *endStr, NSString *indentationStr) {
    NSMutableString *strM = [NSMutableString stringWithString:@"\n"];
    for (int currentDegree = 0; currentDegree < indentationDegree; ++currentDegree) {
        [strM appendString:indentationStr];
    }
    [strM appendString:beginStr];
    [strM appendString:@"\n"];
    
    ++indentationDegree;
    if ([obj isKindOfClass:[NSArray class]]) {
        [(NSArray *)obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            for (int now = 0; now < indentationDegree; now++) {
                [strM appendString:indentationStr];
            }
            [strM appendFormat:@"%@,\n", obj];
        }];
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        [(NSDictionary *)obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            for (int currentDegree = 0; currentDegree < indentationDegree; ++currentDegree) {
                [strM appendString:indentationStr];
            }
            [strM appendFormat:@"%@ = %@;\n", key, obj];
        }];

    }
    --indentationDegree;
    
    for (int currentDegree = 0; currentDegree < indentationDegree; ++currentDegree) {
        [strM appendString:indentationStr];
    }
    [strM appendString:endStr];
    return strM;
}


@implementation NSArray (GQLog)

- (NSString *)descriptionWithLocale:(id)locale {
    return __t_log_joiningString(self, @"[", @"]", @"  ");
}

- (NSString *)description {
    if ([self isKindOfClass:[NSArray class]]) {
        return __t_log_getJSONString(self);
    }
    return [super description];
}

@end

@implementation NSDictionary (GQLog)

- (NSString *)descriptionWithLocale:(id)locale {
    return __t_log_joiningString(self, @"{", @"}", @"  ");
}

- (NSString *)description {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return __t_log_getJSONString(self);
    }
    return [super description];
}

@end

#endif

