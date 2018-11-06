//
//  GQRequestManager.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQRequestManager.h"
#import "GQKit.h"

@implementation GQRequestManager
+ (instancetype)gq_shareInstance {
    static GQRequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GQRequestManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _loadViewBackgroundIsClear = YES;
    }
    return self;
}

- (NSURLSessionDataTask *)gq_get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *responseObj))success failure:(void (^)(GQRequestError *error))failure isShowLoadingView:(BOOL)isShow {
    if (isShow) {
        [[GQShowHudManager gq_shareInstance] gq_showLoadingInView:self.loadingInView backgroundIsClear:self.loadViewBackgroundIsClear];
    }
    
    NSString *urlStr = [self concatUrl:url];
    params = [self addExtraParameters:params];
    return [[GQHTTPSessionManager gq_shareInstance] gq_get:urlStr params:params success:^(id responseObj) {
        [self successDealWithResponseObj:responseObj success:success failure:failure isShowLoadingView:isShow];
    } failure:^(NSError *error) {
        [self failureDealWithError:error failure:failure isShowLoadingView:isShow];
    }];
}

- (NSURLSessionDataTask *)gq_post:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *responseObj))success failure:(void (^)(GQRequestError *error))failure isShowLoadingView:(BOOL)isShow {
    if (isShow) {
        [[GQShowHudManager gq_shareInstance] gq_showLoadingInView:self.loadingInView backgroundIsClear:self.loadViewBackgroundIsClear];
    }
    
    NSString *urlStr = [self concatUrl:url];
    params = [self addExtraParameters:params];
    return [[GQHTTPSessionManager gq_shareInstance] gq_post:urlStr params:params success:^(id responseObj) {
        [self successDealWithResponseObj:responseObj success:success failure:failure isShowLoadingView:isShow];
    } failure:^(NSError *error) {
        [self failureDealWithError:error failure:failure isShowLoadingView:isShow];
    }];
}

- (NSURLSessionDataTask *)gq_postUploadImageWithUrl:(NSString *)url params:(NSDictionary *)params images:(NSArray <UIImage *> *)images progress:(void(^)(NSProgress *uploadProgress))progress success:(void(^)(id responseObj))success failure:(void(^)(GQRequestError *error))failure isShowLoadingView:(BOOL)isShow {
    if (isShow) {
        [[GQShowHudManager gq_shareInstance] gq_showLoadingInView:self.loadingInView backgroundIsClear:self.loadViewBackgroundIsClear];
    }
    
    NSString *urlStr = [self concatUrl:url];
    params = [self addExtraParameters:params];
    return [[GQHTTPSessionManager gq_shareInstance] gq_postUploadWithUrl:urlStr params:params images:images progress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(id responseObj) {
        [self successDealWithResponseObj:responseObj success:success failure:failure isShowLoadingView:isShow];
    } failure:^(NSError *error) {
        [self failureDealWithError:error failure:failure isShowLoadingView:isShow];
    }];
}

- (NSURLSessionDataTask *)gq_postVoiceWithUrl:(NSString *)url params:(NSDictionary *)params dataPath:(NSString *)dataPath progress:(void(^)(NSProgress *uploadProgress))progress success:(void (^)(id responseObj))success failure:(void (^)(GQRequestError *error))failure isShowLoadingView:(BOOL)isShow {
    if (isShow) {
        [[GQShowHudManager gq_shareInstance] gq_showLoadingInView:self.loadingInView backgroundIsClear:self.loadViewBackgroundIsClear];
    }
    
    NSString *urlStr = [self concatUrl:url];
    params = [self addExtraParameters:params];
    return [[GQHTTPSessionManager gq_shareInstance] gq_postVoiceWithUrl:urlStr params:params dataPath:dataPath progress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(id responseObj) {
        [self successDealWithResponseObj:responseObj success:success failure:failure isShowLoadingView:isShow];
    } failure:^(NSError *error) {
        [self failureDealWithError:error failure:failure isShowLoadingView:isShow];
    }];
}
- (void)successDealWithResponseObj:(id)responseObj success:(void (^)(id responseObj))success failure:(void (^)(GQRequestError *error))failure isShowLoadingView:(BOOL)isShow {
    id result = [responseObj valueForKey:@"code"];
    if (![result isKindOfClass:NSNull.class] && [result integerValue] == 1) {
        if (success) {
            success(responseObj);
        }
    } else {
        GQRequestError *err = [GQRequestError yy_modelWithJSON:responseObj];
        if (failure) {
            failure(err);
        }
        [[GQShowHudManager gq_shareInstance] gq_showMessage:err.info];
    }
    if (isShow) {
        [[GQShowHudManager gq_shareInstance] gq_hideLoad];
    }
}
- (void)failureDealWithError:(NSError *)error failure:(void (^)(GQRequestError *error))failure isShowLoadingView:(BOOL)isShow {
    if (isShow) {
        [[GQShowHudManager gq_shareInstance] gq_hideLoad];
    }
    if (error.code == -999) {
    } else {
        [[GQShowHudManager gq_shareInstance] gq_showMessage:@"你的网络似乎有点问题喔~~"];
    }
    if (failure) {
        failure([GQRequestError errWithError:error]);
    }
}
-(NSString *)concatUrl:(NSString *)url {
    if (![url gq_isValidUrl]) {
        return [@"" gq_appendStringPath:url];
    }
    return url;
}

-(NSDictionary *)addExtraParameters:(NSDictionary *)params {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    return dict;
}
@end

