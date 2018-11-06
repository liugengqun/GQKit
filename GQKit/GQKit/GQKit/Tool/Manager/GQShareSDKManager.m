//
//  GQShareSDKManager.m
//  SnowCrow
//
//  Created by Apple on 9/10/18.
//  Copyright © 2018年 SnowCrow. All rights reserved.
//

#import "GQShareSDKManager.h"

#define WX_APPID    @""
#define WX_SEC      @""
#define QQ_APPID    @""

@implementation GQShareSDKManager

+ (instancetype)gq_shareInstance {
    static GQShareSDKManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GQShareSDKManager alloc] init];
    });
    return instance;
}

- (void)gq_registerShareSDK {
    [WXApi registerApp:WX_APPID];
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:QQ_APPID appkey:QQ_APPID];
        
        //微信
        [platformsRegister setupWeChatWithAppId:WX_APPID appSecret:WX_SEC];
    }];
    
}

- (void)gq_shareSDKWithByText:(NSString *)text images:(NSString *)images url:(NSString *)url title:(NSString *)title type:(NSInteger)type {
    SSDKPlatformType shareType = 0;
    if (type == 2) {
        BOOL haveWetchat = [self gq_haveWetchat];
        if (!haveWetchat) {
            [GQ_Hud gq_showMessage:@"您当前没有安装微信"];
            return;
        }
        shareType = SSDKPlatformSubTypeWechatSession;
    }else if (type == 1){
        BOOL haveWetchat = [self gq_haveWetchat];
        if (!haveWetchat) {
            [GQ_Hud gq_showMessage:@"您当前没有安装微信"];
            return;
        }
        shareType = SSDKPlatformSubTypeWechatTimeline;
    } else if (type == 3) {
        BOOL haveqQQ = [self gq_haveQQ];
        if (!haveqQQ) {
            [GQ_Hud gq_showMessage:@"您当前没有安装QQ"];
            return;
        }
        shareType = SSDKPlatformSubTypeQQFriend;
    } else if (type == 4) {
        BOOL haveqQQ = [self gq_haveQQ];
        if (!haveqQQ) {
            [GQ_Hud gq_showMessage:@"您当前没有安装QQ"];
            return;
        }
        shareType = SSDKPlatformSubTypeQZone;
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:images
                                        url:[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                break;
            }
            case SSDKResponseStateFail:
            {
                break;
            }
            default:
                break;
        }
    }];
    
}
- (BOOL)gq_haveWetchat {
    if (![WXApi isWXAppInstalled]) {
        return YES;
    }
    return YES;
}

- (BOOL)gq_haveQQ {
    if (![QQApiInterface isQQInstalled]) {
        return NO;
    }
    return YES;
}

- (void)gq_wechatLogin {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    self.loginType = 1;
}
- (void)gq_wechatLoginAndGetUserInfo {
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
       if (state == SSDKResponseStateSuccess) {
           self.loginType = 1;
           self.user = user;
           [[NSNotificationCenter defaultCenter] postNotificationName:GQNotification_WeixinLogin object:nil userInfo:nil];
       } else {
       }
   }];
}
- (void)gq_qqLoginAndGetUserInfo {
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
         if (state == SSDKResponseStateSuccess) {
             self.user = user;
             self.loginType = 2;
             [[NSNotificationCenter defaultCenter] postNotificationName:GQNotification_QQLogin object:nil userInfo:nil];
         } else {
         }
     }];
}

@end
