//
//  GQCommonTool.m
//  GQKit
//
//  Created by 刘耿群 on 2019/8/7.
//  Copyright © 2019 GQKit. All rights reserved.
//

#import "GQCommonTool.h"

@implementation GQCommonTool
+ (UIViewController *)gq_topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[[UIApplication sharedApplication].delegate window] rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

+ (UINavigationController *)gq_currentNaviVC {
    UINavigationController* naviVC = nil;
    UIViewController *controller = [GQCommonTool gq_topViewController];
    while(controller.presentingViewController != nil){
        controller = controller.presentingViewController;
    }
    [controller dismissViewControllerAnimated:NO completion:nil];
    UIViewController* rootVC = [[UIApplication sharedApplication] delegate].window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]){
        naviVC = (UINavigationController*)rootVC;
    }
    [naviVC popToRootViewControllerAnimated:NO];
    return naviVC;
}
@end
