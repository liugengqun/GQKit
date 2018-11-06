//
//  GQSingleButtonCell.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQSingleButtonCell.h"
#import "GQKit.h"
@implementation GQSingleButtonCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setBtn];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBtn];
    }
    return self;
}
- (void)setBtn {
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _gq_button = [[UIButton alloc] initWithFrame:CGRectZero];
    _gq_button.backgroundColor = GQ_BlueColor;
    [self addSubview:_gq_button];
    [_gq_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gq_button setTitle:@"确定" forState:UIControlStateNormal];
    _gq_button.adjustsImageWhenHighlighted = NO;
    _gq_button.titleLabel.font = [UIFont systemFontOfSize:14];
    _gq_button.layer.cornerRadius = 6;
    _gq_button.clipsToBounds = YES;
    [_gq_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_gq_button setBackgroundImage:[UIImage gq_imageWithColor:[UIColor colorWithWhite:1 alpha:0.3]] forState:UIControlStateDisabled];
    [_gq_button setBackgroundImage:[UIImage gq_imageWithColor:GQ_BlueColor] forState:0];
    
    _gq_button.adjustsImageWhenHighlighted = NO;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGSizeEqualToSize(self.gq_buttonSize, CGSizeZero) == NO) {
        if (self.gq_buttonSize.width == GQ_WindowW) {
            self.gq_button.frame = CGRectMake(0, 0, self.gq_buttonSize.width, self.gq_buttonSize.height);
        } else {
            self.gq_button.frame = CGRectMake((GQ_WindowW - self.gq_buttonSize.width) * 0.5, (self.gq_height - self.gq_buttonSize.height) * 0.5, self.gq_buttonSize.width, self.gq_buttonSize.height);
        }
    } else {
        self.gq_button.frame = CGRectMake(28, self.gq_height - 50, GQ_WindowW - 56, 40);
    }
}
- (void)btnClick {
    if (self.gq_btnClickBlock) {
        self.gq_btnClickBlock();
    }
}
- (void)setGq_buttonTitle:(NSString *)gq_buttonTitle {
    _gq_buttonTitle = gq_buttonTitle;
    [_gq_button setTitle:gq_buttonTitle forState:UIControlStateNormal];
}

- (void)setGq_buttonBgImg:(NSString *)gq_buttonBgImg {
    _gq_buttonBgImg = gq_buttonBgImg;
    [_gq_button setBackgroundImage:[UIImage imageNamed:gq_buttonBgImg] forState:0];
}

- (void)setGq_buttonTitleColor:(UIColor *)gq_buttonTitleColor {
    _gq_buttonTitleColor = gq_buttonTitleColor;
    [_gq_button setTitleColor:gq_buttonTitleColor forState:0];
}
- (void)setGq_buttonBgColor:(UIColor *)gq_buttonBgColor {
    _gq_buttonBgColor = gq_buttonBgColor;
    [_gq_button setBackgroundColor:gq_buttonBgColor];
    [_gq_button setBackgroundImage:[UIImage gq_imageWithColor:gq_buttonBgColor] forState:0];
}
- (void)setGq_buttonTitleFont:(UIFont *)gq_buttonTitleFont {
    _gq_buttonTitleFont = gq_buttonTitleFont;
    _gq_button.titleLabel.font = gq_buttonTitleFont;
}
- (void)setGq_buttonCircle:(BOOL)gq_buttonCircle {
    _gq_buttonCircle = gq_buttonCircle;
    if (gq_buttonCircle) {
        [_gq_button gq_viewCornerRadius:20];
    }
}

@end
