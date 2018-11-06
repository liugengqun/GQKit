//
//  GQPickerView.h
//  GQKit
//
//  Created by Apple on 4/12/18.
//  Copyright © 2018年 GQKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAKit_PickerView.h"
#import "BAKit_DatePicker.h"

typedef NS_ENUM(NSUInteger, GQDatePickerViewType)
{
    GQDatePickerViewTypeTodayBefore, // 今天之前的时间
    GQDatePickerViewTypeTodayAfter, // 今天之后的时间
    GQDatePickerViewTypeAll, // 所有的时间
};

NS_ASSUME_NONNULL_BEGIN

@interface GQPickerView : NSObject

@property (nonatomic, strong) NSString *gq_contentTitleLabelStr;
@property(copy, nonatomic) void (^gq_multipleArrayTypeBlock)(NSArray *selectedArray);
/**
 快速创建一个 城市选择器
 
 @param configuration 可以设置BAKit_PickerView 的自定义内容
 @param block 回调
 */
- (void)gq_creatCityPickerViewWithConfiguration:(void (^)(BAKit_PickerView *tempView)) configuration block:(BAKit_PickerViewBlock)block;

/**
 快速创建一个 自定义单列 pickerView
 
 @param dataArray 数组 @[@"男", @"女"]
 @param configuration 可以设置BAKit_PickerView 的自定义内容
 @param block 回调
 */
- (void)gq_creatCustomPickerViewWithDataArray:(NSArray *)dataArray configuration:(void (^)(BAKit_PickerView *tempView))configuration block:(BAKit_PickerViewResultBlock)block;

/**
 快速创建一个 自定义多列 pickerView
 
 @param dataArray 数组 @[@[@"男", @"女"],@[@"21", @"22"],@[@"39", @"40"]]
 @param configuration 可以设置 BAKit_PickerView 的自定义内容
 @param block 回调
 */
- (void)gq_creatCustomMultiplePickerViewWithDataArray:(NSArray *)dataArray configuration:(void (^)(BAKit_PickerView *tempView))configuration block:(BAKit_PickerViewResultBlock)block;
/**
 隐藏
 */
- (void)gq_pickViewHidden;
@property (copy, nonatomic) void (^gq_pickViewHiddenBlock)(void);
@end

@interface GQDatePickerView : NSObject

/**
 时间段类型
 当configuration = nil 有效
 当configuration != nil 相当于 GQDatePickerViewTypeTodayBefore
 */
@property (nonatomic, assign) GQDatePickerViewType gq_viewType;
/**
 快速创建一个DatePickerView 默认年月日
*/
- (void)gq_creatPickerViewWithDateYMDConfiguration:(nullable void (^)(BAKit_DatePicker *tempView))configuration block:(BAKit_PickerViewResultBlock)block;
/**
 快速创建一个DatePickerView
 */
- (void)gq_creatPickerViewWithDateType:(BAKit_CustomDatePickerDateType)type configuration:(nullable void (^)(BAKit_DatePicker *tempView))configuration block:(BAKit_PickerViewResultBlock)block;
/**
 隐藏
 */
- (void)gq_pickViewHidden;
@property (copy, nonatomic) void (^gq_pickViewHiddenBlock)(void);
@end


NS_ASSUME_NONNULL_END
