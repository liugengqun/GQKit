//
//  GQSystemModifyDefaultCell.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQSystemModifyDefaultCell.h"
#import "GQKit.h"
@implementation GQSystemModifyDefaultCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpTableViewCell];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpTableViewCell];
    }
    return self;
}

- (void)setUpTableViewCell {
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.textColor = GQ_BlackColor;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.gq_cellType = GQSystemModifyDefaultCellTypeDisclosureIndicator;
}

- (void)setGq_cellType:(GQSystemModifyDefaultCellType)gq_cellType {
    gq_cellType = gq_cellType;
    switch (gq_cellType) {
        case GQSystemModifyDefaultCellTypeDisclosureIndicator: {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.accessoryView = self.gq_accessoryBtnView;
        }
            break;
        case GQSystemModifyDefaultCellTypeSwitch: {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.accessoryView = self.gq_swi;
        }
            break;
        default:
            break;
    }
}

#pragma mark - GQSystemModifyDefaultCellTypeDisclosureIndicator
- (void)gq_setupAccessoryBtnWithTitle:(NSString *)accessoryBtnTitle img:(NSString *)accessoryBtnImg titleColor:(UIColor *)titleColor {
    if (accessoryBtnImg.length > 0) {
        [self.gq_accessoryBtnView setImage:[UIImage imageNamed:accessoryBtnImg] forState:0];
    } else {
        [self.gq_accessoryBtnView setImage:[UIImage imageNamed:@"通用列表箭头"] forState:0];
    }
    if (accessoryBtnTitle.length == 0) {
        accessoryBtnTitle = @" ";
    }
    if ([accessoryBtnTitle isKindOfClass:[NSAttributedString class]]) {
        [self.gq_accessoryBtnView setAttributedTitle:(NSAttributedString *)accessoryBtnTitle forState:0];
    } else {
        [self.gq_accessoryBtnView setTitle:accessoryBtnTitle forState:0];
    }
    
    [self.gq_accessoryBtnView setTitleColor:titleColor == nil ? GQ_BlackColor : titleColor  forState:0];
    self.gq_accessoryBtnView.titleLabel.font = self.gq_accessoryBtnViewFont == nil ? [UIFont systemFontOfSize:12] : self.gq_accessoryBtnViewFont;
    [self.gq_accessoryBtnView sizeToFit];
    self.gq_accessoryBtnView.gq_height = 45;
    if (self.gq_accessoryBtnView.gq_width > GQ_WindowW - 120) {
        self.gq_accessoryBtnView.gq_width = GQ_WindowW - 120;
    } else if (self.gq_accessoryBtnView.gq_width < 30) {
        if (_gq_accessoryBtnView.userInteractionEnabled) {
            self.gq_accessoryBtnView.gq_width = 30;
        }
    }
    
    [_gq_accessoryBtnView gq_layoutButtonWithStyle:GQButtonTypeImageRightTitleLeft imageTitleSpacing:10];
}
- (void)accessoryBtnViewClick {
    if (self.gq_accessoryBtnViewClickBlock) {
        self.gq_accessoryBtnViewClickBlock();
    }
}
#pragma mark - GQSystemModifyDefaultCellTypeSwitch
- (void)SwitchAction:(UISwitch *)swi {
    if (self.gq_switchActionBlock) {
        self.gq_switchActionBlock(swi);
    }
}
- (void)setGq_swiOn:(BOOL)gq_swiOn {
    _gq_swiOn = gq_swiOn;
    self.gq_swi.on = gq_swiOn;
}
- (void)setGq_swiOnTintColor:(UIColor *)gq_swiOnTintColor {
    _gq_swiOnTintColor = gq_swiOnTintColor;
    self.gq_swi.onTintColor = gq_swiOnTintColor;
}
#pragma mark - layoutSubviews
-(void)layoutSubviews {
    UIImage *orgImg = nil;
    if (!CGSizeEqualToSize(self.gq_imageSize, CGSizeZero)) {
        orgImg = self.imageView.image;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.image = [UIImage gq_imageWithColor:[UIColor clearColor] size:self.gq_imageSize];
    }
    
    [super layoutSubviews];
    
    if (orgImg) {
        self.imageView.image = orgImg;
    }
    if (!CGSizeEqualToSize(self.imageView.gq_size, CGSizeZero) && self.imageView.image != nil) {
        self.imageView.gq_x = 15;
        self.textLabel.gq_x = CGRectGetMaxX(self.imageView.frame) + 5;
        self.imageView.gq_size = self.imageView.gq_size;
    } else {
        self.textLabel.gq_x = 15;
        self.detailTextLabel.gq_x = 15;
        self.imageView.gq_size = CGSizeZero;
        self.imageView.image = nil;
    }
    
    if (self.gq_hideSeparatorLine) {
        for (UIView *view in self.subviews) {
            if ([NSStringFromClass(view.class) hasSuffix:@"SeparatorView"]) {
                view.hidden = YES;view.alpha = 0;
            }
        }
    } else {
        for (UIView *view in self.subviews) {
            if ([NSStringFromClass(view.class) hasSuffix:@"SeparatorView"]) {
                view.hidden = NO;view.alpha = 1;
            }
        }
    }
}
#pragma mark - 懒加载
- (UIButton *)gq_accessoryBtnView {
    if (!_gq_accessoryBtnView) {
        _gq_accessoryBtnView = [[UIButton alloc] init];
        [_gq_accessoryBtnView setImage:[UIImage imageNamed:@"通用列表箭头"] forState:0];
        [_gq_accessoryBtnView addTarget:self action:@selector(accessoryBtnViewClick) forControlEvents:UIControlEventTouchUpInside];
        [_gq_accessoryBtnView gq_layoutButtonWithStyle:GQButtonTypeImageRightTitleLeft imageTitleSpacing:10];
        _gq_accessoryBtnView.userInteractionEnabled = NO;
    }
    return _gq_accessoryBtnView;
}
- (UISwitch *)gq_swi {
    if (_gq_swi == nil) {
        _gq_swi = [[UISwitch alloc] init];
        _gq_swi.gq_size = CGSizeMake(30, 20);
        _gq_swi.onTintColor = GQ_BlueColor;
        [_gq_swi addTarget:self action:@selector(SwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _gq_swi;
}

@end
