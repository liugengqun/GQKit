//
//  GQRequestError.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQRequestError : NSObject
@property (assign, nonatomic) BOOL success;
@property (copy, nonatomic) NSString *info;
@property (strong, nonatomic) NSError *orgError;
@property (strong, nonatomic) NSDictionary *orgReponse;
@property (nonatomic,assign) int code;

+ (instancetype)errWithError:(NSError *)error;
@end
