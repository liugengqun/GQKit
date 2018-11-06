//
//  GQNavigationController.m
//  GQKit
//
//  Created by Apple on 28/2/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import "GQNavigationController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UINavigationController+GQExtension.h"
#import "GQKit.h"
@interface GQNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation GQNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transferNavigationBarAttributes = YES;
    self.useSystemBackBarButtonItem = YES;
    
    [self gq_setDefaultNav];
    [self gq_setShadowImageBeClear];
    
    [self gq_setDefaultNavTitleTextAttributesWithTitleColor:nil titleFont:nil];
}

//拦截push方法 处理跳转事件
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = GQ_WindowW;
    self.fd_fullscreenPopGestureRecognizer.enabled = YES;
    
    if (self.childViewControllers.count > 0) {
        UIButton *backButton = [[UIButton alloc]init];
        [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0, 40, 40);
        backButton.imageEdgeInsets=UIEdgeInsetsMake(0,-20,0,0);
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}


@end
