//
//  GQJumpMapNavManager.m
//  GQKit
//
//  Created by Apple on 14/1/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import "GQJumpMapNavManager.h"
#import "CLLocation+YCLocation.h"
#import <MapKit/MapKit.h>
#import "GQActionSheetView.h"
#import "GQKit.h"
@implementation GQJumpMapNavManager
{
    double currentLatitude;
    double currentLongitute;
    double targetLatitude;
    double targetLongitute;
    NSString *currentName;
    NSString *toName;
}

- (void)gq_jumpMapNavWithTargetLatitude:(double)targetLatitude targetLongitute:(double)targetLongitute toName:(NSString *)name {
//    [self gq_jumpMapNavWithCurrentLatitude:Loca_latitude currentLongitute:Loca_longitude currentName:Loca_Address TotargetLatitude:targetLatitude targetLongitute:targetLongitute toName:name];
}

- (void)gq_jumpMapNavWithCurrentLatitude:(double)currentLatitude currentLongitute:(double)currentLongitute currentName:(NSString *)currentName toTargetLatitude:(double)targetLatitude targetLongitute:(double)targetLongitute toName:(NSString *)toName {
    CLLocation *from = [[CLLocation alloc]initWithLatitude:currentLatitude longitude:currentLongitute];
    CLLocation *fromLoction = [from locationMarsFromEarth];
    currentLatitude = fromLoction.coordinate.latitude;
    currentLongitute = fromLoction.coordinate.longitude;
    currentName = currentName;
    targetLatitude = targetLatitude;
    targetLongitute = targetLongitute;
    toName = toName;

    NSArray *mapArr= [self checkHasOwnApp];
    GQActionSheetView *mapNavView = [[GQActionSheetView alloc] gq_initWithTitles:mapArr withCancleTitle:@"取消" cancelColor:GQ_BlueColor];
    mapNavView.gq_chooseBlock = ^(NSString *text, NSInteger idx) {
        NSString *btnTitle = mapArr[idx];
        if ([btnTitle isEqualToString:@"苹果地图"]) {
            CLLocationCoordinate2D from = CLLocationCoordinate2DMake(currentLatitude, currentLongitute);
            MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:from addressDictionary:nil]];
            currentLocation.name = currentName;
            
            //终点
            CLLocationCoordinate2D to = CLLocationCoordinate2DMake(targetLatitude, targetLongitute);
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
            toLocation.name = currentName;
            NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
            NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey : [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey : @YES
                                      };
            [MKMapItem openMapsWithItems:items launchOptions:options];
        } else if ([btnTitle isEqualToString:@"google地图"]) {
            NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?saddr=%.8f,%.8f&daddr=%.8f,%.8f&directionsmode=transit",currentLatitude,currentLongitute,targetLatitude,targetLongitute];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
        } else if ([btnTitle isEqualToString:@"高德地图"]){
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",currentLatitude,currentLongitute,currentName,targetLatitude,targetLongitute,toName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *r = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:r options:@{} completionHandler:nil];
            
        } else if ([btnTitle isEqualToString:@"腾讯地图"]){
            NSString *urlStr = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&from=%@&tocoord=%f,%f&to=%@&policy=1",currentLatitude,currentLongitute,currentName,targetLatitude,targetLongitute,toName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *r = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:r options:@{} completionHandler:nil];
        } else if([btnTitle isEqualToString:@"百度地图"]) {
            CLLocation *from = [[CLLocation alloc]initWithLatitude:currentLatitude longitude:currentLongitute];
            CLLocation *fromLoction = [from locationBaiduFromMars];
            CLLocation *to = [[CLLocation alloc]initWithLatitude:targetLatitude longitude:targetLongitute];
            CLLocation *toLoction = [to locationBaiduFromMars];
            
            NSString *stringURL = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:%@&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=gcj02",fromLoction.coordinate.latitude,fromLoction.coordinate.longitude,currentName,toLoction.coordinate.latitude,toLoction.coordinate.longitude,toName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:stringURL];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    };
    [mapNavView gq_show];
}



- (NSArray *)checkHasOwnApp {
    NSArray *mapSchemeArr = @[@"comgooglemaps://",@"iosamap://navi",@"baidumap://map/",@"qqmap://"];
    NSMutableArray *appListArr = [[NSMutableArray alloc] initWithObjects:@"苹果地图", nil];
    for (int i = 0; i < [mapSchemeArr count]; i++) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[mapSchemeArr objectAtIndex:i]]]]) {
            if (i == 0) {
                [appListArr addObject:@"google地图"];
            }else if (i == 1){
                [appListArr addObject:@"高德地图"];
            }else if (i == 2){
                [appListArr addObject:@"百度地图"];
            }else if (i == 3){
                [appListArr addObject:@"腾讯地图"];
            }
        }
    }
    return appListArr;
}
@end
