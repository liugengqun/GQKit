//
//  SCPayTool.h
//  SnowCrow
//
//  Created by Apple on 24/4/18.
//  Copyright © 2018年 SnowCrow. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GQWeChatModel;
@interface GQPayManager : NSObject
+ (void)gq_aliPayWithPayOrder:(NSString *)PayOrder;
+ (void)gq_weChatRegister;
+ (void)gq_weChatWithWeChatModel:(GQWeChatModel *)weChatModel;
@end

@interface GQWeChatModel : NSObject
@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, strong) NSString *timeStamp;
@property (nonatomic, strong) NSString *packageValue;
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *partnerId;
@property (nonatomic, strong) NSString *prepayId;
@property (nonatomic, strong) NSString *nonceStr;
@end
