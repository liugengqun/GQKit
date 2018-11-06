//
//  GQKit.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#ifndef GQKit_h
#define GQKit_h

#pragma mark -  系统
//设备
#define GQ_iPhone5      ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height == 568)
#define GQ_iPhone6      ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 667)
#define GQ_iPhone6Plus  ([UIScreen mainScreen].bounds.size.width == 414 && [UIScreen mainScreen].bounds.size.height == 736)
#define GQ_iPhoneX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define GQ_iPhoneXSMax  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define GQ_iPhoneXR     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define GQ_iPhoneLH GQ_iPhoneX || GQ_iPhoneXSMax || GQ_iPhoneXR

//定义导航栏  标签栏高度
#define GQ_NavBarH                44
#define GQ_StatusBarH             ((GQ_iPhoneX || GQ_iPhoneXSMax || GQ_iPhoneXR) ? 44 : 20)
#define GQ_TabBarH                ((GQ_iPhoneX || GQ_iPhoneXSMax || GQ_iPhoneXR) ? 83 : 49)
#define GQ_NavBarAndStatusBarH    ((GQ_iPhoneX || GQ_iPhoneXSMax || GQ_iPhoneXR) ? 88 : 64)
#define GQ_TabbarSafeBottomMargin ((GQ_iPhoneX || GQ_iPhoneXSMax || GQ_iPhoneXR) ? 34.f : 0.f)

//屏幕宽高
#define GQ_WindowW  [[UIScreen mainScreen] bounds].size.width
#define GQ_WindowH [[UIScreen mainScreen] bounds].size.height
#define GQ_KeyWindow     [UIApplication sharedApplication].keyWindow

//自定义颜色
#define GQ_RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define GQ_RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]
#define GQ_Hex_Color(color)   [UIColor gq_colorWithHexString:color]



#define GQ_BlackColor      GQ_Hex_Color(@"36404a")
#define GQ_GrayColor       GQ_Hex_Color(@"999999")
#define GQ_BackGroundColor GQ_Hex_Color(@"f7f7f7")
#define GQ_BlueColor       GQ_RGB_COLOR(62,105,218)

//安全回到主线程
#define GQ_dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
//由角度转换弧度
#define GQ_DegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define GQ_RadianToDegrees(radian) (radian * 180.0) / (M_PI)

//弱引用对象
#define GQ_WS(weakSelf) __weak __typeof(self) weakSelf = self;

#define GQ_Hud [GQShowHudManager gq_shareInstance]

#define GQ_Image(imageName) [UIImage imageNamed:imageName]
#define GQ_FontSize(size)   [UIFont systemFontOfSize:size]
#define GQ_BoldFontSize(size)   [UIFont boldSystemFontOfSize:size]

#pragma mark -  快捷注册cell
#define GQ_TableRegisterNib(cell, identifier)       [self.tableView registerNib:[UINib nibWithNibName:cell bundle:nil] forCellReuseIdentifier:identifier];
#define GQ_TableRegisterClass(cell, identifier)     [self.tableView registerClass:NSClassFromString(cell) forCellReuseIdentifier:identifier];

#pragma mark - 打印日志
#ifdef DEBUG
#define GQ_String [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define GQLog(...) printf("%s [Line %d]: %s\n-----\n\n", [GQ_String UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define GQLog(...)
#endif

#pragma mark - 通知
#define GQNotification_WeixinLogin @"GQNotification_WeixinLogin"
#define GQNotification_QQLogin @"GQNotification_QQLogin"

#pragma mark - import
#import "UIView+GQExtension.h"
#import "UILabel+GQExtension.h"
#import "UIButton+GQExtension.h"
#import "UIImage+GQExtension.h"
#import "NSString+GQExtension.h"
#import "NSMutableAttributedString+GQExtension.h"
#import "UIColor+GQExtension.h"
#import "UIBarButtonItem+GQExtension.h"
#import "UIImageView+GQExtenxion.h"
#import "NSDictionary+GQExtension.h"


#import "GQSingleButtonCell.h"
#import "GQDoubleButtonCell.h"
#import "GQShowViewManager.h"
#import "GQShowHudManager.h"
#import "GQAlertController.h"
#import "GQActionSheetView.h"
#import "GQInfoStorageManager.h"
#import "GQPhotoBrowserManager.h"
#import "GQProjectManager.h"
#import "GQSystemModifyDefaultCell.h"
#import <YYModel.h>
#import "MJRefresh.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "NSObject+GQKVO.h"
#endif /* GQKit_h */
