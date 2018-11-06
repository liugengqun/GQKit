//
//  GQHTTPSessionManager.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface GQHTTPSessionManager : NSObject
@property (nonatomic,strong) AFHTTPSessionManager *gq_sessionManager;

+ (instancetype)gq_shareInstance;

- (void)gq_cancelAllOperations;
/**
 发送一个GET请求
 @param url     请求路径
 @param params  请求参数
 @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (NSURLSessionDataTask *)gq_get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/**
 发送一个POST请求
 @param url     请求路径
 @param params  请求参数
 @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (NSURLSessionDataTask *)gq_post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/**
 上传图片
 @param url     请求路径
 @param params  请求参数
 @param images  图片
 @param progress  进度
 @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (NSURLSessionDataTask *)gq_postUploadWithUrl:(NSString *)url params:(NSDictionary *)params images:(NSArray <UIImage *> *)images progress:(void(^)(NSProgress *uploadProgress))progress success:(void(^)(id responseObj))success failure:(void(^)(id error))failure;

/**
 上传语音
 @param url     请求路径
 @param params  请求参数
 @param dataPath  路径
 @param progress  进度
 @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (NSURLSessionDataTask *)gq_postVoiceWithUrl:(NSString *)url params:(NSDictionary *)params dataPath:(NSString *)dataPath progress:(void(^)(NSProgress *uploadProgress))progress success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
@end
