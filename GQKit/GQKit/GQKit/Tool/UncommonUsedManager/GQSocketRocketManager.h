//
//  GQSocketRocketManager.h
//  GQKit
//
//  Created by Apple on 5/3/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>

extern NSString * const GQNotification_SocketRocketDidOpen;
extern NSString * const GQNotification_SocketRocketDidClose;
extern NSString * const GQNotification_SocketRocketDidReceive;

@interface GQSocketRocketManager : NSObject
+ (instancetype)gq_shareInstance;

/** 获取连接状态 */
@property (nonatomic, assign, readonly) SRReadyState socketReadyState;

/** 开启连接 */
- (void)gq_openWithURLString:(NSString *)urlString;
/** 关闭连接 */
- (void)gq_close;
/** 发送数据 */
- (void)gq_sendData:(id)data;

@end

