//
//  NSArray+GQExtension.m
//  GQKit
//
//  Created by Apple on 9/1/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import "NSArray+GQExtension.h"

@implementation NSArray (GQExtension)
+ (NSArray *)gq_arrayWithStr:(NSString *)str {
    if ([str length] == 0) {
        return nil;
    }
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    return arr;
}
@end
