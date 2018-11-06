//
//  GQTimeManager.m
//  HXLive
//
//  Created by Apple on 10/12/18.
//  Copyright © 2018年 HXLive. All rights reserved.
//

#import "GQTimeManager.h"

@implementation GQTimeManager

+ (NSString *)gq_timeStampWithDate:(NSDate *)date {
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    return timeStamp;
}

+ (NSDate *)gq_dateWithTimeStamp:(NSString *)timeStamp dataFormatString:(NSString *)formatString {
    NSString *dateStr = [self gq_dateStringWithTimeStamp:timeStamp dataFormatString:formatString];
    return [self gq_dateWithDateString:dateStr dataFormatString:formatString];
}

+ (NSString *)gq_dateStringWithTimeStamp:(NSString *)timeStamp dataFormatString:(NSString *)formatString {
    NSString *dateString;
    NSDate *tmpDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
    dateString = [format stringFromDate:tmpDate];
    return dateString;
}

+ (NSString *)gq_dateStringWithDateString:(NSString *)dateString dataFormatString:(NSString *)formatString {
    NSDate *tmpDate =  [self gq_dateWithDateString:dateString dataFormatString:formatString];
    return [self gq_timeStampWithDate:tmpDate];
}

+ (NSDate *)gq_dateWithDateString:(NSString *)dateString dataFormatString:(NSString *)formatString {
    NSDate *tmpDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    tmpDate = [dateFormatter dateFromString:dateString];
    return tmpDate;
}

+ (NSString *)gq_dateWithDate:(NSDate *)date dataFormatString:(NSString *)formatString {
    NSString *timeStamp = [self gq_timeStampWithDate:date];
    return [self gq_dateStringWithTimeStamp:timeStamp dataFormatString:formatString];
}
@end
