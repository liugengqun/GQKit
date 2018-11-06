//
//  GQAliyunOSSManager.h
//  GQKit
//
//  Created by Qun on 5/1/19.
//  Copyright © 2019年 Qun. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, GQAliyunOSSFileType)
{
    GQAliyunOSSFileTypePicture,
    GQAliyunOSSFileTypeVideo,
};
NS_ASSUME_NONNULL_BEGIN

@interface GQAliyunOSSManager : NSObject
+ (instancetype)gq_shareInstance;
//- (void)gq_aliyunOSSWithBucketName:(NSString *)bucketName fileType:(GQAliyunOSSFileType)fileType filePath:(NSString *)path data:(NSData *)data success:(void(^)(NSString *fullPath))success failure:(void(^)(void))failure;
@end

NS_ASSUME_NONNULL_END
