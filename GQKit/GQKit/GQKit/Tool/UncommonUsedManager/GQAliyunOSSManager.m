//
//  GQAliyunOSSManager.m
//  GQKit
//
//  Created by Qun on 5/1/19.
//  Copyright © 2019年 Qun. All rights reserved.
//

#import "GQAliyunOSSManager.h"
#import <AliyunOSSiOS/OSSService.h>
#import "GQTimeManager.h"
@interface GQAliyunOSSManager()
@property (nonatomic, strong) OSSClient *client;
@end
@implementation GQAliyunOSSManager
+ (instancetype)gq_shareInstance {
    static GQAliyunOSSManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GQAliyunOSSManager alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *endpoint = @"http://oss-cn-shenzhen.aliyuncs.com";
        // 移动端建议使用STS方式初始化OSSClient。可以通过sample中STS使用说明了解更多(https://github.com/aliyun/aliyun-oss-ios-sdk/tree/master/DemoByOC)
//        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:@"LTAIxEfjk3ZQ1jPV" secretKeyId:@"3X7Lb9bzeZ0QVIrrfDwna11gqwmcVO" securityToken:@""];
//
//        OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
        id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"LTAIxEfjk3ZQ1jPV" secretKey:@"3X7Lb9bzeZ0QVIrrfDwna11gqwmcVO"];

        OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
        self.client = client;
    }
    return self;
}
- (void)gq_aliyunOSSWithBucketName:(NSString *)bucketName fileType:(GQAliyunOSSFileType)fileType filePath:(NSString *)path data:(NSData *)data success:(void(^)(NSString *fullPath))success failure:(void(^)(void))failure {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
       [self gq_showLoadingInView:nil backgroundIsClear:YES];
    }];

    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    NSString *time = [GQTimeManager gq_dateWithDate:[NSDate date] dataFormatString:@"yyyy/MM/dd"];
    NSString *tmp = @"";
    if (fileType == GQAliyunOSSFileTypeVideo) {
        tmp = @"mp4";
    } else {
        tmp = @"jpg";
    }
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.%@",time,[self createUUID],tmp];
    // 文件夹名
    put.bucketName = [bucketName length] == 0 ? @"bxl-gendan" : bucketName;
    // 文件名
    put.objectKey = fileName;
    if ([path length] > 0) {
        put.uploadingFileURL = [NSURL fileURLWithPath:path];
    } else {
        put.uploadingData = data;
    }

    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        GQLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);

    };
    OSSTask * putTask = [self.client putObject:put];

    [putTask continueWithBlock:^id(OSSTask *task) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self gq_hideLoad];
            if (!task.error) {
                GQLog(@"upload object success!");
                if (success) {
                    success([NSString stringWithFormat:@"https://bxl-gendan.oss-cn-shenzhen.aliyuncs.com/%@",fileName]);
                }
            } else {
                GQLog(@"upload object failed, error: %@" , task.error);
                if (failure) {
                    failure();
                }
                [self gq_showMessage:@"上传失败,请重新上传"];
            }

        }];
        return nil;
    }];
    // 可以等待任务完成
//    [putTask waitUntilFinished];
}
- (NSString*)createUUID {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid);
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    NSString *tmp = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return tmp;
}
@end
