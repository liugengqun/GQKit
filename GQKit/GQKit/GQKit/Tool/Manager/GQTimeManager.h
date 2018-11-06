//
//  GQTimeManager.h
//  HXLive
//
//  Created by Apple on 10/12/18.
//  Copyright © 2018年 HXLive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GQTimeManager : NSObject
/*
 NSDate转时间戳
 */
+ (NSString *)gq_timeStampWithDate:(NSDate *)date;
/*
 时间戳转换为NSDate
 */
+ (NSDate *)gq_dateWithTimeStamp:(NSString *)timeStamp dataFormatString:(NSString *)formatString;
/*
 时间戳转换为时间字符串
 */
+ (NSString *)gq_dateStringWithTimeStamp:(NSString *)timeStamp dataFormatString:(NSString *)formatString;

/*
 时间字符串转换为时间戳
 */
+ (NSString *)gq_dateStringWithDateString:(NSString *)dateString dataFormatString:(NSString *)formatString;

/*
 时间字符串转换成NSDate格式
 */
+ (NSDate *)gq_dateWithDateString:(NSString *)dateString dataFormatString:(NSString *)formatString;

/*
 NSDate换成NSString格式
 */
+ (NSString *)gq_dateWithDate:(NSDate *)date dataFormatString:(NSString *)formatString;
@end

NS_ASSUME_NONNULL_END
