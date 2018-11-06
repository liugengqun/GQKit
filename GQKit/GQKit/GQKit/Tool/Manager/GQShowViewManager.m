//
//  GQShowViewManager.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQShowViewManager.h"
#import "GQKit.h"
@interface GQShowViewManager()
@property (nonatomic, strong) UIView *subV;
@property (nonatomic, strong) UIView *bgView ;
@property (nonatomic, strong) UITapGestureRecognizer *bgViewTap;
@property (nonatomic, strong) UITapGestureRecognizer *subViewTap;
@property (nonatomic, assign) CGFloat showChangeDistance;
@property (nonatomic, assign) CGFloat hiddenchangeDistance;

@end
@implementation GQShowViewManager
- (instancetype)init {
    self = [super init];
    if (self) {
        self.gq_touchBgViewToCancel = YES;
    }
    return self;
}
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat gap = frame.size.height - self.showChangeDistance;
    self.showChangeDistance = frame.size.height;
    CGFloat time = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:time animations:^{
        self.subV.gq_y -= gap;
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    CGFloat time = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat gap = frame.size.height - self.hiddenchangeDistance;
    self.hiddenchangeDistance = frame.size.height;
    [UIView animateWithDuration:time animations:^{
        self.subV.gq_y += gap;
    }];
    if (self.gq_keyboardWillHideBlock) {
        self.gq_keyboardWillHideBlock();
    }
}
- (void)keyboardDidHide:(NSNotification *)notification {
    self.showChangeDistance = 0;
    self.hiddenchangeDistance = 0;
}

- (void)gq_cancel {
    if (self.gq_anmiType == GQShowViewManagerAnmiTypeNone) {
        [self.subV removeFromSuperview];
        [self.bgView  removeFromSuperview];
    } else if (self.gq_anmiType == GQShowViewManagerAnmiTypeBottom) {
        [self.bgView endEditing:NO];
        [UIView animateWithDuration:0.25 animations:^{
            self.subV.gq_y += self.subV.gq_height;
            [self.subV removeFromSuperview];
            [self.bgView removeFromSuperview];
        } completion:^(BOOL finished) {
            self.subV.gq_y -= self.subV.gq_height;
        }];
    } else {
        [self.bgView  endEditing:NO];
        [UIView animateWithDuration:0.25 animations:^{
            self.subV.gq_y += GQ_WindowH *0.5;
            [self.subV removeFromSuperview];
            [self.bgView removeFromSuperview];
        } completion:^(BOOL finished) {
            self.subV.gq_y -= GQ_WindowH *0.5;
        }];
    }
    if (self.gq_cancelBlock) {
        self.gq_cancelBlock();
    }
}
- (void)endEdit {
    [self.subV endEditing:YES];
}
- (void)gq_showWithSubView:(UIView *)subView onView:(UIView *)onView{
    self.subV = subView;
    
    if (self.gq_needKeyboardObserver) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    }
    if (onView != nil) {
        [onView addSubview:self.bgView];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    }
    if (CGRectEqualToRect(self.gq_bgViewFrame, CGRectZero) == NO) {
        self.bgView.frame = self.gq_bgViewFrame;
    }
    if (self.gq_touchBgViewToCancel) {
        [self.bgView  addGestureRecognizer:self.bgViewTap];
    }
    if (self.gq_bgViewColor) {
        self.bgView.backgroundColor = self.gq_bgViewColor;
    }
    [subView addGestureRecognizer:self.subViewTap];
    [self.bgView addSubview:subView];
    
    switch (self.gq_anmiType) {
        case GQShowViewManagerAnmiTypeFallCenter: {
            self.subV.gq_y -= GQ_WindowH *0.5;
            [UIView animateWithDuration:0.25 animations:^{
                self.subV.gq_y += GQ_WindowH *0.5;
            }completion:^(BOOL finished) {
                [self.subV gq_shakeAnimation];
            }];
            break;
        }
        case GQShowViewManagerAnmiTypeBottom: {
            self.subV.gq_y += self.subV.gq_height;
            [UIView animateWithDuration:0.25 animations:^{
                self.subV.gq_y -= self.subV.gq_height;
            }completion:^(BOOL finished) {
            }];
            break;
        }
        default:
            break;
    }
}
- (void)gq_showWithSubView:(UIView *)subView {
    [self gq_showWithSubView:subView onView:nil];
}

// 解决弹出UITableView,didSelect方法不调用
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSString *classStr = NSStringFromClass([touch.view class]);
    if ([classStr isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}
- (UITapGestureRecognizer *)bgViewTap {
    if (!_bgViewTap) {
        _bgViewTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gq_cancel)];
    }
    return _bgViewTap;
}
- (UITapGestureRecognizer *)subViewTap {
    if (!_subViewTap) {
        _subViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    }
    return _subViewTap;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
