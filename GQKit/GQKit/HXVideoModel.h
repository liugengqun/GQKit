//
//  HXVideoModel.h
//  HXLive
//
//  Created by Apple on 20/12/18.
//  Copyright © 2018年 HXLive. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface HXVideoModel : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *brandMessage;
@property (nonatomic, strong) NSString *video_url;
@property (nonatomic, strong) NSString *comment_count;
@property (nonatomic, strong) NSString *share_count;
@property (nonatomic, strong) NSString *praise_count;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *music_url;
@property (nonatomic, strong) NSString *member_name;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *cover_image;
@property (nonatomic, strong) NSString *view_count;
@property (nonatomic, strong) NSString *music_name;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, assign) BOOL is_follow;
@property (nonatomic, assign) BOOL is_praise;


@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, assign) BOOL is_host;



@property (nonatomic, assign) BOOL isChoose;
@end

NS_ASSUME_NONNULL_END
