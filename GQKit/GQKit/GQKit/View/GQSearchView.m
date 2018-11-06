//
//  GQSearchView.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQSearchView.h"
#import "GQKit.h"
@interface GQSearchView()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *leftImageV;
@property(nonatomic, strong) UIButton *touchBtn;

@end
@implementation GQSearchView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp {
    self.backgroundColor = [UIColor whiteColor];
    UITextField *field = [[UITextField alloc] init];
    field.placeholder = @"请输入搜索的关键字";
    field.backgroundColor = GQ_RGB_COLOR(245,245,245);
    field.tintColor = GQ_RGB_COLOR(153, 153, 153);
    field.font = [UIFont systemFontOfSize:14];
    field.borderStyle = UITextBorderStyleNone;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIImageView *leftImageV = [[UIImageView alloc] init];
    self.leftImageV = leftImageV;
    leftImageV.image = [UIImage imageNamed:@"搜索"];
    leftImageV.gq_width = leftImageV.image.size.width + 20;
    leftImageV.gq_height = leftImageV.image.size.height;
    leftImageV.contentMode = UIViewContentModeCenter;
    
    field.leftView = leftImageV;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.returnKeyType = UIReturnKeySearch;
    field.delegate =self;
    [self addSubview:field];
    self.gq_field = field;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setGq_textFieldCanSearch:(BOOL)gq_textFieldCanSearch {
    _gq_textFieldCanSearch = gq_textFieldCanSearch;
    if (gq_textFieldCanSearch == NO) {
        [self.gq_field addSubview:self.touchBtn];
    }
}
- (void)setGq_leftImageVImage:(NSString *)gq_leftImageVImage {
    _gq_leftImageVImage = gq_leftImageVImage;
    self.leftImageV.image = [UIImage imageNamed:gq_leftImageVImage];
}

- (void)gq_setFieldPlaceholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor {
    self.gq_field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : placeholderColor}];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.gq_textFieldIsNavBar) {
        [self sizeToFit];
        self.gq_field.frame = CGRectMake(7, 3, self.frame.size.width - 14, self.frame.size.height - 6);
    } else {
        self.gq_field.frame = CGRectMake(10, 7, self.frame.size.width - 20, self.frame.size.height-14);
    }
    if (self.gq_cornerRadius > 0) {
        self.gq_field.layer.cornerRadius = self.gq_cornerRadius;
    } else {
        self.gq_field.layer.cornerRadius = (self.frame.size.height-14) * 0.5;
    }
    self.gq_field.layer.masksToBounds = YES;
}
- (void)textFChange:(NSNotification *)noti{
    if (self.gq_textFieldChangeBlock) {
        self.gq_textFieldChangeBlock(self.gq_field.text);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.gq_textFieldEndBlock) {
        self.gq_textFieldEndBlock(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.gq_field endEditing:YES];
    if (self.gq_searchBlock) {
        self.gq_searchBlock(self.gq_field.text);
    }
    return YES;
}
- (void)touchBtnClick {
    if (self.gq_touchBtnClickBlock) {
        self.gq_touchBtnClickBlock();
    }
}
- (UIButton *)touchBtn {
    if (_touchBtn == nil) {
        _touchBtn = [[UIButton alloc] init];
        _touchBtn.frame = self.bounds;
        [_touchBtn addTarget:self action:@selector(touchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchBtn;
}

@end
