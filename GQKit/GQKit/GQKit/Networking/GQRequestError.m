//
//  GQRequestError.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQRequestError.h"

@implementation GQRequestError
+ (instancetype)errWithError:(NSError *)error {
    GQRequestError *err = [GQRequestError new];
    err.orgError = error;
    err.success = NO;
    if (error) {
        if (error.code == 200) {
            err.info = error.userInfo[NSLocalizedDescriptionKey];
        }
        if ([err.info isKindOfClass:NSNull.class] || err.info == nil) {
            err.info = @"你的网络似乎有点问题喔~~";
        }
    }
    return err;
}
@end
