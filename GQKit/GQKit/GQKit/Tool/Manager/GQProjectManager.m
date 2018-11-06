//
//  GQProjectManager.m
//  GQKit
//
//  Created by Apple on 5/3/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import "GQProjectManager.h"
#import "GQKit.h"
#import <CoreLocation/CoreLocation.h>
@implementation GQProjectManager


#pragma mark - 提示
+ (void)gq_showAlertWithTel:(NSString*)tel {
    GQAlertController *alert  = [GQAlertController gq_alertWithMessage:[NSString stringWithFormat:@"确定拨打号码：\n\n%@",tel] buttonTitle:nil buttonsColor:nil completion:^(NSInteger clickedButtonTag){
        if (clickedButtonTag == 1) {
            [self telWithNumber:tel];
        }
    }];
    [alert gq_show];
}

+ (void)telWithNumber:(NSString*)tel {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]];
    [[UIApplication sharedApplication] openURL:url];
}


+ (BOOL)gq_showLocationAlertView {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        GQAlertController *alert  = [GQAlertController gq_alertWithMessage:@"你当前未打开定位，为了方便为您提供更好的服务，是否打开？" buttonTitle:nil buttonsColor:nil completion:^(NSInteger clickedButtonTag){
            if (clickedButtonTag == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }];
        [alert gq_show];
        return YES;
    }
    return NO;
}

@end
