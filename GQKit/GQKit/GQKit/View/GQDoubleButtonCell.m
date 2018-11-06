//
//  GQDoubleButtonCell.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQDoubleButtonCell.h"
#import "GQKit.h"
@implementation GQDoubleButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        _gq_leftButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_gq_leftButton];
        [_gq_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_gq_leftButton setTitle:@"清空" forState:UIControlStateNormal];
        _gq_leftButton.backgroundColor = GQ_BlueColor;
        [_gq_leftButton addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _gq_leftButton.adjustsImageWhenHighlighted = NO;
        _gq_leftButton.layer.cornerRadius = 8;
        _gq_leftButton.clipsToBounds = YES;
        
        _gq_rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_gq_rightButton];
        [_gq_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_gq_rightButton setTitle:@"确定" forState:UIControlStateNormal];
        _gq_rightButton.backgroundColor = GQ_BlueColor;
        [_gq_rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _gq_rightButton.adjustsImageWhenHighlighted = NO;
        _gq_rightButton.layer.cornerRadius = 8;
        _gq_rightButton.clipsToBounds = YES;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = (GQ_WindowW - 25 - 25 - 20) / 2;
    self.gq_leftButton.frame = CGRectMake(25, (self.gq_height - 40) * 0.5, w, 40);
    self.gq_rightButton.frame = CGRectMake(w + 20 + 25, (self.gq_height - 40) * 0.5, w, 40);
}
- (void)leftBtnClick {
    if (self.gq_leftBtnClickBlock) {
        self.gq_leftBtnClickBlock();
    }
}
- (void)rightBtnClick {
    if (self.gq_rightBtnClickBlock) {
        self.gq_rightBtnClickBlock();
    }
}
- (void)setGq_leftButtonTitle:(NSString *)gq_leftButtonTitle {
    _gq_leftButtonTitle = gq_leftButtonTitle;
    [_gq_leftButton setTitle:_gq_leftButtonTitle forState:UIControlStateNormal];
}

- (void)setGq_rightButtonTitle:(NSString *)gq_rightButtonTitle {
    _gq_rightButtonTitle = gq_rightButtonTitle;
    [_gq_rightButton setTitle:_gq_rightButtonTitle forState:UIControlStateNormal];
}

@end
