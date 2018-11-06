//
//  GQShareSDKManager.h
//  SnowCrow
//
//  Created by Apple on 9/10/18.
//  Copyright © 2018年 SnowCrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
@interface GQShareSDKManager : NSObject

+ (instancetype)gq_shareInstance;
/*
 appdelegate初始化sharesdk
 */
- (void)gq_registerShareSDK;
/*
 调起分享 1 朋友圈 2 微信好友 3 qq好友 4 QQ空间
 */
- (void)gq_shareSDKWithByText:(NSString *)text images:(NSString *)images url:(NSString *)url title:(NSString *)title type:(NSInteger)type;
/*
 是否有微信
 */
- (BOOL)gq_haveWetchat;

/*
 微信登录 不获取用户资料 这一步由后台获取 前端值做调起授权操作
 */
- (void)gq_wechatLogin;
/*
 微信登录 获取用户资料
 */
- (void)gq_wechatLoginAndGetUserInfo;
/*
 qq登录 获取用户资料
 */
- (void)gq_qqLoginAndGetUserInfo;

@property (nonatomic, strong) SSDKUser *user;
/*
  1 微信 2 qq
 */
@property (nonatomic, assign) NSInteger loginType;
@end
