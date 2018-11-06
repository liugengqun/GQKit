//
//  GQPickerView.m
//  GQKit
//
//  Created by Apple on 4/12/18.
//  Copyright © 2018年 GQKit. All rights reserved.
//

#import "GQPickerView.h"
#import "NSDateFormatter+BAKit.h"
#import "GQKit.h"
@interface GQPickerView()
@property(nonatomic, strong) BAKit_PickerView *tempView;
@end
@implementation GQPickerView
- (void)gq_creatCityPickerViewWithConfiguration:(void (^)(BAKit_PickerView *tempView)) configuration block:(BAKit_PickerViewBlock)block {
    [BAKit_PickerView ba_creatCityPickerViewWithConfiguration:^(BAKit_PickerView *tempView) {
        [self setPickViewUI:tempView];
        configuration(tempView);
        //        NSMutableArray *mulArr = [[NSMutableArray alloc] init];
        //        [dataArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            [mulArr addObject:obj.firstObject];
        //        }];
        //        self.tempView.MultipleArrayTypeBlock(mulArr);
    } block:block];
}

- (void)gq_creatCustomPickerViewWithDataArray:(NSArray *)dataArray
configuration:(void (^)(BAKit_PickerView *tempView))configuration block:(BAKit_PickerViewResultBlock)block {
    [BAKit_PickerView ba_creatCustomPickerViewWithDataArray:dataArray configuration:^(BAKit_PickerView *tempView) {
        [self setPickViewUI:tempView];
        configuration(tempView);
        self.gq_contentTitleLabelStr = dataArray.firstObject;
    } block:block];
}

- (void)gq_creatCustomMultiplePickerViewWithDataArray:(NSArray *)dataArray configuration:(void (^)(BAKit_PickerView *tempView))configuration block:(BAKit_PickerViewResultBlock)block {
    [BAKit_PickerView ba_creatCustomMultiplePickerViewWithDataArray:dataArray configuration:^(BAKit_PickerView *tempView) {
        [self setPickViewUI:tempView];
        configuration(tempView);
        NSMutableArray *mulArr = [[NSMutableArray alloc] init];
        [dataArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mulArr addObject:obj.firstObject];
        }];
        self.tempView.MultipleArrayTypeBlock(mulArr);
    } block:block];
}
- (void)gq_pickViewHidden {
    if (self.gq_pickViewHiddenBlock) {
        self.gq_pickViewHiddenBlock();
    }
    [self.tempView ba_pickViewHidden];
}

- (void)setPickViewUI:(BAKit_PickerView*)tempView {
    tempView.ba_pickViewTitleColor = GQ_BlackColor;
    tempView.ba_buttonTitleColor_sure = GQ_BlackColor;
    tempView.ba_buttonTitleColor_cancle = GQ_BlackColor;
    tempView.ba_pickViewTitleFont = [UIFont boldSystemFontOfSize:15];
    tempView.animationType = BAKit_PickerViewAnimationTypeBottom;
    __weak __typeof(self) weakSelf = self;
    tempView.MultipleArrayTypeBlock = ^(NSArray *selectedArray) {
        if (weakSelf.gq_multipleArrayTypeBlock) {
            weakSelf.gq_multipleArrayTypeBlock(selectedArray);
        }else{
            self.gq_contentTitleLabelStr = [selectedArray componentsJoinedByString:@""];
        }
    };
    self.tempView = tempView;
}

- (void)setGq_contentTitleLabelStr:(NSString *)gq_contentTitleLabelStr {
    _gq_contentTitleLabelStr = gq_contentTitleLabelStr;
    self.tempView.contentTitleLabel.text = gq_contentTitleLabelStr;
}
@end

@interface GQDatePickerView()
@property (nonatomic, strong) BAKit_DatePicker *datePicker;
@end
@implementation GQDatePickerView
- (void)gq_creatPickerViewWithDateYMDConfiguration:(nullable void (^)(BAKit_DatePicker *tempView))configuration block:(BAKit_PickerViewResultBlock)block {
    [self gq_creatPickerViewWithDateType:BAKit_CustomDatePickerDateTypeYMD configuration:configuration
    block:block];
}
- (void)gq_creatPickerViewWithDateType:(BAKit_CustomDatePickerDateType)type configuration:(nullable void (^)(BAKit_DatePicker *tempView))configuration block:(BAKit_PickerViewResultBlock)block {
    [BAKit_DatePicker ba_creatPickerViewWithType:type configuration:^(BAKit_DatePicker *tempView) {
        [self setPickViewUI:tempView];
        
        if (configuration != nil) {
            configuration(tempView);
        } else {
            if (self.gq_viewType == GQDatePickerViewTypeTodayBefore) {
                
            } else if (self.gq_viewType == GQDatePickerViewTypeTodayAfter) {
                NSDateFormatter *format = [NSDateFormatter ba_setupDateFormatterWithYMD];
                NSDate *max = [format dateFromString:@"2100-12-31"];
                NSDate *today = [[NSDate alloc]init];
                [format setDateFormat:@"yyyy-MM-dd"];
                tempView.ba_minDate = today;
                tempView.ba_maxDate = max;
                tempView.ba_defautDate = today;
            } else {
                NSDateFormatter *format = [NSDateFormatter ba_setupDateFormatterWithYMD];
                NSDate *max = [format dateFromString:@"2100-12-31"];
                tempView.ba_maxDate = max;
            }
        }
    } block: block];
}
- (void)gq_pickViewHidden {
    if (self.gq_pickViewHiddenBlock) {
        self.gq_pickViewHiddenBlock();
    }
    [self.datePicker ba_pickViewHidden];
}
- (void)setPickViewUI:(BAKit_DatePicker*)tempView {
    tempView.ba_pickViewTitleColor = GQ_BlackColor;
    tempView.ba_buttonTitleColor_sure = GQ_BlackColor;
    tempView.ba_buttonTitleColor_cancle = GQ_BlackColor;
    tempView.ba_bgYearTitleColor = GQ_BlackColor;
    tempView.ba_pickViewFont = [UIFont systemFontOfSize:12];
    tempView.ba_pickViewTitleFont = [UIFont boldSystemFontOfSize:15];
    tempView.animationType = BAKit_PickerViewAnimationTypeBottom;
    self.datePicker = tempView;
}
@end
