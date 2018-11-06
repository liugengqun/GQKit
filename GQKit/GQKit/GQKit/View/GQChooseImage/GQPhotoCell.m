//
//  GQPhotoCell.m
//  chexiaoxi
//
//  Created by Qun on 16/6/29.
//  Copyright © 2016年 IOS. All rights reserved.
//

#import "GQPhotoCell.h"
#import "UIButton+AFNetworking.h"
@interface GQPhotoCell()

@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *uploadMsgLab;

@property(nonatomic, assign) BOOL hasChooseImg;

@end
@implementation GQPhotoCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.activityIndicator.hidden = YES;
    self.uploadMsgLab.hidden = YES;
    self.addImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setPhotoImg:(id)photoImg {
    _photoImg = photoImg;
    if (photoImg == nil) {
        [self.addImageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
        self.closeBtn.hidden = YES;
        self.hasChooseImg = NO;
    } else {
        if ([photoImg isKindOfClass:[UIImage class]]) {
            [self.addImageBtn setImage:photoImg forState:UIControlStateNormal];
        } else if ([photoImg isKindOfClass:[NSString class]]) {
            [self.addImageBtn setImageForState:0 withURL:[NSURL URLWithString:photoImg] placeholderImage:[UIImage imageNamed:@"占位图"]];
        }
        self.closeBtn.hidden = NO;
        self.hasChooseImg = YES;
    }
}

- (void)setIsLoading:(BOOL)isLoading {
    _isLoading = isLoading;
    if (isLoading) {
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidden = NO;
    } else {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        
    }
}

- (void)setShowUploadMsg:(BOOL)showUploadMsg {
    _showUploadMsg = showUploadMsg;
    if(self.showUploadMsg){
        self.uploadMsgLab.hidden = NO;
    } else {
        self.uploadMsgLab.hidden = YES;
    }
}
- (IBAction)closeBtnClick:(id)sender {
    self.uploadMsgLab.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(photoCellRemovePhotoBtnClickForCell:)]) {
        [self.delegate photoCellRemovePhotoBtnClickForCell:self];
    }
}
- (IBAction)addImageBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(photoCellAddImageBtnClickForCell:hasChooseImg:)]) {
        [self.delegate photoCellAddImageBtnClickForCell:self hasChooseImg:self.hasChooseImg];
    }
}

@end
