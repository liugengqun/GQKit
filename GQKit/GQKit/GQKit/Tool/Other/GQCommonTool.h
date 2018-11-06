//
//  GQCommonTool.h
//  GQKit
//
//  Created by 刘耿群 on 2019/8/7.
//  Copyright © 2019 GQKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GQCommonTool : NSObject
/// 当前最上层的vc
+ (UIViewController *)gq_topViewController;
/// 当前导航栏控制器
+ (UINavigationController *)gq_currentNaviVC;
@end

NS_ASSUME_NONNULL_END
