//
//  SCPayTool.m
//  SnowCrow
//
//  Created by Apple on 24/4/18.
//  Copyright © 2018年 SnowCrow. All rights reserved.
//

#import "GQPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@implementation GQPayManager
+ (void)gq_aliPayWithPayOrder:(NSString *)payOrder {
    if ([payOrder length] == 0) {
        return;
    }
    [[AlipaySDK defaultService] payOrder:payOrder fromScheme:@"HXLive" callback:^(NSDictionary *resultDic) {
    }];
}

+ (void)gq_weChatRegister {
    [WXApi registerApp:WX_APPID];
}

+ (void)gq_weChatWithWeChatModel:(GQWeChatModel *)weChatModel {
    //数据模型数组
    PayReq *req = [[PayReq alloc]init];
    /** 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录*/
    req.openID =  weChatModel.appid;
    /** 商家向财付通申请的商家id */
    req.partnerId = weChatModel.partnerId;
    /** 预支付订单 */
    req.prepayId = weChatModel.prepayId;
    /** 随机串，防重发 */
    req.nonceStr = weChatModel.nonceStr;
    /** 时间戳，防重发 */
    req.timeStamp = [weChatModel.timeStamp longLongValue];
    /** 商家根据财付通文档填写的数据和签名 */
    req.package = weChatModel.packageValue;
    /** 商家根据微信开放平台文档对数据做的签名 */
    req.sign = weChatModel.sign;
    //发起支付
    [WXApi sendReq:req];
}
@end

@implementation GQWeChatModel



@end
