//
//  GQLoadingView.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQLoadingView.h"
#import "GQKit.h"
@interface GQLoadingView()
//加载的图片
@property (nonatomic, strong) UIImageView *loadingImage;
//标题label
@property (strong, nonatomic) UILabel *loadingLabel;
//放置图片的数组
@property (nonatomic, strong) NSMutableArray *imageArray;
@end
@implementation GQLoadingView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpAnimationView];
    }
    return self;
}

- (void)setUpAnimationView {
    [self addSubview:self.loadingImage];
    [self addSubview:self.loadingLabel];
    for (NSInteger i = 0; i<=8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"车下拉_0000%zd", i]];
        [self.imageArray addObject:image];
    }
    [self.loadingImage setAnimationImages:self.imageArray];
    [self.loadingImage setAnimationDuration:0.4];
    
    [self.loadingImage startAnimating];
}

- (UIImageView *)loadingImage {
    if (_loadingImage == nil) {
        _loadingImage = [[UIImageView alloc]init];
        _loadingImage.contentMode = UIViewContentModeCenter;
    }
    return _loadingImage;
}

-(UILabel *)loadingLabel {
    if (_loadingLabel == nil) {
        _loadingLabel = [[UILabel alloc]init];
        _loadingLabel.textColor = [UIColor blackColor];
        _loadingLabel.font = [UIFont systemFontOfSize:12];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _loadingLabel;
}

- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}


- (void)layoutSubviews {
    [self.loadingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.offset(self.gq_width);
        make.height.offset(self.gq_height);
    }];
    
    [self.loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadingImage.mas_bottom);
        make.centerX.equalTo(self);
    }];
}


@end
