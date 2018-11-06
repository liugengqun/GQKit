//
//  GQBaseViewController.m
//  GQKit
//
//  Created by 刘耿群 on 2021/5/10.
//  Copyright © 2021 GQKit. All rights reserved.
//

#import "GQBaseViewController.h"
#import "UINavigationController+GQExtension.h"
@interface GQBaseViewController ()

@end

@implementation GQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpForDismissKeyboard];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.gq_navBarShadowImageClear) {
        [self.navigationController gq_setShadowImageBeClear];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.gq_navBarShadowImageClear) {
        [self.navigationController gq_setShadowImageBeLine];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    GQLog(@"%@已经关闭",[NSString stringWithFormat:@"title:%@ class:%@",  self.title,[self class], nil]);
}

#pragma mark - 键盘隐藏
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    __weak __typeof(self) weakSelf = self;
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQuene usingBlock:^(NSNotification *note){
        [weakSelf.view addGestureRecognizer:singleTapGR];
    }];
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQuene usingBlock:^(NSNotification *note){
        [weakSelf.view removeGestureRecognizer:singleTapGR];
    }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj endEditing:YES];
        *stop = YES;
    }];
}

/**
 pop到某控制器
 */
- (void)gq_popToVCStr:(NSString *)vcStr {
    if ([vcStr length] > 0) {
        [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(vcStr)]) {
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
