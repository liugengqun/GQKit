//
//  GQProjectManager.h
//  GQKit
//
//  Created by Apple on 5/3/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GQProjectManager : NSObject
/*
 提示打电话
 */
+ (void)gq_showAlertWithTel:(NSString*)tel;
/*
 是否弹出判断位置开启提示
 */
+ (BOOL)gq_showLocationAlertView;
@end

NS_ASSUME_NONNULL_END
