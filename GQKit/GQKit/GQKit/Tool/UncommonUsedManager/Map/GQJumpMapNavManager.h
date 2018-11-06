//
//  GQJumpMapNavManager.h
//  GQKit
//
//  Created by Apple on 14/1/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GQJumpMapNavManager : NSObject
/**
 *  从指定地导航到指定地
 *
 */
- (void)gq_jumpMapNavWithCurrentLatitude:(double)currentLatitude currentLongitute:(double)currentLongitute currentName:(NSString *)currentName toTargetLatitude:(double)targetLatitude targetLongitute:(double)targetLongitute toName:(NSString *)toName;
/**
 *  从目前位置导航到指定地
 *
 */
- (void)gq_jumpMapNavWithTargetLatitude:(double)targetLatitude targetLongitute:(double)targetLongitute toName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
