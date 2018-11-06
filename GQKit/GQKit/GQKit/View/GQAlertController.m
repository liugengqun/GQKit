//
//  GQAlertController.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQAlertController.h"
#import "GQKit.h"
#define GQ_ButtonTitleColor  GQ_RGB_COLOR(46,156,241)
#define GQ_MessageColor      GQ_RGB_COLOR(23,27,31)
@interface GQAlertController ()

@property (weak, nonatomic) UIViewController *delegate;
@property (strong, nonatomic) NSArray<NSString *> *buttonsTitle;
@property (strong, nonatomic) NSArray<UIColor *> *buttonsColor;
@property (strong, nonatomic) void (^completion)(NSInteger tag);

@property (assign, nonatomic) BOOL failedToSetButtonStyle;
@property (assign, nonatomic) BOOL failedToSetMsgStyle;

@property (strong, nonatomic) NSMutableAttributedString *messageAttributedString;
@end

@implementation GQAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    _gq_dismissOnTapBackgroundView = YES;
}
+ (instancetype)gq_alertWithMessage:(NSString *)message buttonTitle:(NSArray<NSString *> *)buttonsTitle buttonsColor:(NSArray<UIColor *> *)buttonsColor completion:(void(^)(NSInteger clickedButtonTag))completion {
    GQAlertController *alert = [self gq_alertWithTitle:nil message:message buttonTitle:buttonsTitle buttonsColor:buttonsColor completion:completion];
    alert.gq_messageFont = [UIFont systemFontOfSize:14];
    
    [alert setupAlertStyle];
    
    return alert;
}

+ (instancetype)gq_alertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSArray<NSString *> *)buttonsTitle buttonsColor:(NSArray<UIColor *> *)buttonsColor completion:(void(^)(NSInteger clickedButtonTag))completion {
    GQAlertController *alert = [GQAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    alert.message = [message stringByAppendingString:@"\n "];
    alert.title = title?:@" ";
    if (buttonsColor.count == 0) {
        alert.buttonsColor = @[GQ_ButtonTitleColor, GQ_ButtonTitleColor];
    } else {
        alert.buttonsColor = buttonsColor;
    }
    if (buttonsTitle.count == 0) {
        alert.buttonsTitle = @[@"取消",@"确定"];
    } else {
        alert.buttonsTitle = buttonsTitle;
    }
    alert.gq_messageFont =  [UIFont systemFontOfSize:14];
    
    alert.completion = completion;
    
    [alert setupAlertActions];
    [alert setupAlertStyle];
    
    return alert;
}

- (void)gq_show {
    [self gq_showInController:nil];
}

- (void)gq_showInController:(UIViewController *)delegate {
    _delegate = delegate;
    if (_delegate == nil) {
        _delegate = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([_delegate isKindOfClass:UITabBarController.class]) {
            UITabBarController *tab = (UITabBarController *)_delegate;
            _delegate = tab.selectedViewController;
        }
        if ([_delegate isKindOfClass:UINavigationController.class]){
            UINavigationController *nav = (UINavigationController *)_delegate;
            _delegate = nav.viewControllers.lastObject;
        }
    }
    
    if ([_delegate respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [_delegate presentViewController:self animated:YES completion:^{
            [self setupDismissActionOnView:self.view.superview];
        }];
    }
}

// 设置 AlertView 的Actions
- (void)setupAlertActions {
    // add actions
    [self.buttonsTitle enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.completion) {
                NSInteger tag = [self.actions indexOfObject:action];
                self.completion(tag);
            }
        }];
        
        [self addAction:action];
    }];
}

// 设置 AlertView 的样式
- (void)setupAlertStyle {
    //    unsigned int count = 0;
    //    Ivar *ivars = class_copyIvarList([UIAlertAction class], &count);
    //    for (int i = 0; i<count; i++) {
    //        Ivar ivar = ivars[i];
    //        NSLog(@"%s------%s", ivar_getName(ivar),ivar_getTypeEncoding(ivar));
    //    }
    
    // add actions
    [self.actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIColor *titleColor = GQ_ButtonTitleColor;
        if (self.buttonsColor.count > idx) {
            titleColor = self.buttonsColor[idx];
        }
        @try {
            if ([titleColor isKindOfClass:UIColor.class]) {
                [action setValue:titleColor forKey:@"titleTextColor"];
            }
        } @catch (NSException *exception) {
            self.failedToSetButtonStyle = YES;
            *stop = YES;
        }
    }];
    
    // add style
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.message];
    self.messageAttributedString = att;
    [att gq_addAttributes:@{NSFontAttributeName: self.gq_messageFont?:[UIFont systemFontOfSize:14]} atString:self.message];
    [att gq_addAttributes:@{NSForegroundColorAttributeName:self.gq_messageColor?:GQ_MessageColor} atString:self.message];
    
    NSRange range = [self.message rangeOfString:@" " options:NSBackwardsSearch];
    if (range.length > 0) {
        [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:range];
    }
    @try {
        [self setValue:att forKey:@"attributedMessage"];
    } @catch (NSException *exception) {
        self.failedToSetMsgStyle = YES;
    }
    
    // TITLE
    NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc] initWithString:self.title];
    [att1 gq_addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} atString:self.title];
    [att1 gq_addAttributes:@{NSForegroundColorAttributeName:GQ_MessageColor} atString:self.title];
    
    NSRange range1 = [self.title rangeOfString:@" " options:NSBackwardsSearch];
    if (range1.length > 0) {
        [att1 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} range:range1];
    }
    @try {
        [self setValue:att1 forKey:@"attributedTitle"];
    } @catch (NSException *exception) {
        self.failedToSetMsgStyle = YES;
    }
}
- (void)setGq_isMessageAlignmentLeft:(BOOL)gq_isMessageAlignmentLeft{
    _gq_isMessageAlignmentLeft = gq_isMessageAlignmentLeft;
    if (self.gq_isMessageAlignmentLeft) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        [paragraph setAlignment:NSTextAlignmentLeft];
        [self.messageAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, self.messageAttributedString.length)];
        [self setValue:self.messageAttributedString forKey:@"attributedMessage"];
    }
}

- (void)setupDismissActionOnView:(UIView *)view {
    // 找到最上面的 最大view
    UIView *actionView = nil;
    CGSize size = [UIScreen mainScreen].bounds.size;
    for (UIView *subv in view.subviews.reverseObjectEnumerator) {
        CGSize viewSize = subv.frame.size;
        if (viewSize.width == size.width && viewSize.height == size.height) {
            actionView = subv;
            break;
        }
    }
    
    if (actionView) {
        actionView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchToDismiss)];
        [actionView addGestureRecognizer:tap];
    }
}

- (void) didTouchToDismiss {
    if (_gq_dismissOnTapBackgroundView) {
        if (self.completion) {
            self.completion(-1);
        }
        [_delegate dismissViewControllerAnimated:YES completion:NULL];
    }
}


@end
