//
//  GQBaseViewController.h
//  GQKit
//
//  Created by 刘耿群 on 2021/5/10.
//  Copyright © 2021 GQKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQKit.h"
@interface GQBaseViewController : UIViewController

#pragma mark - navBar
/**
 导航栏是否需要黑色下线
 */
@property (assign, nonatomic) BOOL gq_navBarShadowImageClear;

#pragma mark - pop到某控制器
/**
 pop到某控制器
 */
- (void)gq_popToVCStr:(NSString *)vcStr;

@end

