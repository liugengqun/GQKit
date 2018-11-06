//
//  GQPlaceHolderView.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "GQPlaceHolderView.h"
#import "GQKit.h"

@interface GQPlaceHolderView()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopCon;
@end
@implementation GQPlaceHolderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.updateButton gq_viewCornerRadius:20 borderColor:GQ_RGB_COLOR(153, 153, 153)];
    self.refreshView.hidden = YES;
}

- (IBAction)btnClick:(id)sender {
    if (self.resetBtnClickBlock) {
        self.resetBtnClickBlock();
    }
    self.updateButton.hidden = YES;
    self.refreshView.hidden = NO;
    [self.refreshView startAnimating];
}

- (void)setRefreshEnd:(BOOL)refreshEnd {
    _refreshEnd = refreshEnd;
    if (refreshEnd) {
        self.updateButton.hidden = NO;
        self.refreshView.hidden = YES;
        [self.refreshView stopAnimating];
    }
}

- (void)setTopOffset:(CGFloat)topOffset {
    _topOffset = topOffset;
    self.imageTopCon.constant = topOffset;
}


@end
