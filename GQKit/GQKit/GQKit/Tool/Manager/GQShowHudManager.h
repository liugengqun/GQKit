//
//  GQShowHudManager.h
//  GQKit
//
//  Created by Apple on 6/1/19.
//  Copyright © 2019年 GQKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, GQShowHudManagerType)
{
    GQShowHudManagerTypeIndeterminate,
    GQShowHudManagerTypeLoadingView,
};


@interface GQShowHudManager : NSObject

+ (instancetype)gq_shareInstance;

#pragma mark - loading
/*
 loading类型
 */
@property (nonatomic, assign) GQShowHudManagerType gq_type;
/*
 展示loading
 */
- (void)gq_showLoadingInView:(UIView *)view backgroundIsClear:(BOOL)isClear;
- (void)gq_showLoadingInView:(UIView *)view hint:(NSString*)title backgroundIsClear:(BOOL)isClear;
- (void)gq_hideLoad;


#pragma mark - hud
/*
 隐藏hud
 */
- (void)gq_hideHud;

/*
 展示提示文本的bud
 */
- (void)gq_showMessage:(NSString *)message;
- (void)gq_showMessage:(NSString *)message delay:(CGFloat)time completion:(void(^)(void))completion;
/*
 从默认(showHint:)显示的位置再往上(下)yOffset
 */
- (void)gq_showMessage:(NSString *)message yOffset:(float)yOffset;
@end


