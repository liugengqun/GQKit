//
//  GQHTTPSessionManager.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQHTTPSessionManager.h"
#import "GQKit.h"
@implementation GQHTTPSessionManager

+ (instancetype)gq_shareInstance {
    static GQHTTPSessionManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GQHTTPSessionManager alloc] init];
    });
    return instance;
}
- (AFHTTPSessionManager *)gq_sessionManager {
    if (_gq_sessionManager == nil) {
        _gq_sessionManager = [AFHTTPSessionManager manager];
        _gq_sessionManager.requestSerializer.timeoutInterval = 20;
        _gq_sessionManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        _gq_sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",@"image/jpeg", @"*/*", nil];
        
    }
    return _gq_sessionManager;
}
- (void)gq_cancelAllOperations {
    [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
}

- (NSURLSessionDataTask *)gq_get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure {
    NSURLSessionDataTask *dataTask = [[self gq_sessionManager] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *url = task.originalRequest.URL.absoluteString;
        GQLog(@"\n\n-------------------  requesting url   -----------------\n %@ \n\n\n-------------------  requesting paras -----------------\n %@ \n\n",url, [url gq_getUrlParameters]);
        GQLog(@"\n-------------------  responseObj -----------------\n %@ \n", responseObject);
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *url = task.originalRequest.URL.absoluteString;
        GQLog(@"\n\n-------------------  requesting url   -----------------\n %@ \n\n\n-------------------  requesting paras -----------------\n %@ \n\n",url, [url gq_getUrlParameters]);
        GQLog(@"\n-------------------  error -----------------\n %@ \n", error);
        
        if (failure) {
            failure(error);
        }
    }];
    return dataTask;
}


- (NSURLSessionDataTask *)gq_post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure {
    NSURLSessionDataTask *dataTask = [[self gq_sessionManager] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *parStr = [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding];
        GQLog(@"\n\n-------------------  requesting url   -----------------\n %@?%@ \n\n\n-------------------  requesting paras -----------------\n %@ \n\n",
              task.originalRequest.URL.absoluteString, parStr, [parStr gq_getUrlParameters]);
        GQLog(@"\n-------------------  responseObj -----------------\n %@ \n", responseObject);
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *parStr = [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding];
        GQLog(@"\n\n-------------------  requesting url   -----------------\n %@?%@ \n\n\n-------------------  requesting paras -----------------\n %@ \n\n",
              task.originalRequest.URL.absoluteString, parStr, [parStr gq_getUrlParameters]);
        GQLog(@"\n-------------------  error -----------------\n %@ \n", error);
        if (failure) {
            failure(error);
        }
    }];
    return dataTask;
}



- (NSURLSessionDataTask *)gq_postUploadWithUrl:(NSString *)url params:(NSDictionary *)params images:(NSArray <UIImage *> *)images progress:(void(^)(NSProgress *uploadProgress))progress success:(void(^)(id responseObj))success failure:(void(^)(id error))failure {
    GQLog(@"\n-------------------  requesting url   -----------------\n %@ \n", url);
    GQLog(@"\n-------------------  requesting paras -----------------\n %@ \n", params);
    
    
    NSMutableArray *imgDataArr = [NSMutableArray new];
    NSMutableArray *nameStrArr = [NSMutableArray new];
    NSMutableArray *fileNameStrArr = [NSMutableArray new];
    for (NSInteger i = 0 ; i < images.count; i++) {
        
        UIImage *image = images[i];
        NSData *imgOriData = UIImageJPEGRepresentation(image, 1);
        BOOL cango = YES;
        if ([imgOriData length] / 1000 < 1000) {
            [imgDataArr addObject:imgOriData];
            cango = NO;
        }
        if (cango == YES) {
            NSData *imgData = UIImageJPEGRepresentation(image, 0.7);
            if ([imgData length]/1000 > 3000) {
                if (failure) {
                    failure(nil);
                }
                if (i == 0) {
                    [[GQShowHudManager gq_shareInstance] gq_showMessage:@"图片太大,请重新选择合适图片"];
                    return nil;
                } else {
                    [[GQShowHudManager gq_shareInstance] gq_showMessage:[NSString stringWithFormat:@"第%zd张图片太大,请重新选择合适图片",i+1]];
                    return nil;
                }
                
            }
            [imgDataArr addObject:imgData];
        }
        
        // NSLog(@"=======%lu",[UIImageJPEGRepresentation(image, 1) length]/1000);
        // NSLog(@"============%lu",[imgData length]/1000);
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timeInterval = [date timeIntervalSince1970]; // 秒
        NSString *fileNameStr = [NSString stringWithFormat:@"image_%ld_%ld.jpg", (long)timeInterval, (long)i];
        [fileNameStrArr addObject:fileNameStr];
        NSString *nameStr;
        if (images.count == 1) {
            nameStr = @"file";//
        } else {
            nameStr = [NSString stringWithFormat:@"file_%ld", (long)i];
        }
        [nameStrArr addObject:nameStr];
    }
    
    NSURLSessionDataTask *task = [[self gq_sessionManager] POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i = 0 ; i < images.count; i++) {
            [formData appendPartWithFileData:imgDataArr[i] name:nameStrArr[i] fileName:fileNameStrArr[i] mimeType:@"multipart/form-data"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        GQLog(@"\n-------------------  responseObj -----------------\n %@ \n", responseObject);
        if (responseObject) {
            if (success) {
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }
        GQLog(@"\n-------------------  error -----------------\n %@ \n", error);
    }];
    [task resume];
    return task;
}


- (NSURLSessionDataTask *)gq_postVoiceWithUrl:(NSString *)url params:(NSDictionary *)params dataPath:(NSString *)dataPath progress:(void(^)(NSProgress *uploadProgress))progress success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure {
    NSURLSessionDataTask *task = [[self gq_sessionManager] POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [NSData dataWithContentsOfFile:dataPath];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"amrRecord_%ld.aac", (long)timeInterval] mimeType:@"amr/mp3/wav/aac"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        GQLog(@"\n-------------------  responseObj -----------------\n %@ \n", responseObject);
        if (responseObject) {
            if (success) {
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }
        GQLog(@"\n-------------------  error -----------------\n %@ \n", error);
    }];
    [task resume];
    return task;
}

@end
