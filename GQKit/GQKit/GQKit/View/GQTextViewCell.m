//
//  GQTextViewCell.m
//  SnowCrow
//
//  Created by Apple on 9/4/18.
//  Copyright © 2018年 SnowCrow. All rights reserved.
//

#import "GQTextViewCell.h"
#import "GQKit.h"

@interface GQTextViewCell()<YYTextViewDelegate>
@property (strong, nonatomic) UILabel *textCountLabel;
@end
@implementation GQTextViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.gq_textView];
        [self.contentView addSubview:self.textCountLabel];
        
        [self.gq_textView becomeFirstResponder];
        
        self.gq_limitTextCount = 500;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.gq_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    [self.textCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.gq_textView);
        make.right.equalTo(self.gq_textView);
    }];
}
- (void)setGq_limitTextCount:(NSInteger)gq_limitTextCount {
    _gq_limitTextCount = gq_limitTextCount;
    [self textViewDidChange:self.gq_textView];
}
- (void)setGq_textStr:(NSString *)gq_textStr {
    _gq_textStr = gq_textStr;
    self.gq_textView.text = gq_textStr;
}
- (void)setGq_placeholderText:(NSString *)gq_placeholderText {
    _gq_placeholderText = gq_placeholderText;
    self.gq_textView.placeholderText = gq_placeholderText;
}
#pragma mark - YYTextViewDelegate
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length >= self.gq_limitTextCount) {
        
        BOOL flag = textView.text.length > self.gq_limitTextCount;
        
        textView.text = [str substringToIndex:self.gq_limitTextCount];
        
        NSString *allText = [NSString stringWithFormat:@" %zd/%zd", self.gq_limitTextCount, self.gq_limitTextCount];
        self.textCountLabel.attributedText = [allText gq_attStringWithAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} atString:[NSString stringWithFormat:@"%zd",self.gq_limitTextCount]];
        
        return !flag;
    }
    self.textCountLabel.attributedText = nil;
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView {
    if (textView.text.length >= self.gq_limitTextCount) {
        NSString *allText = [NSString stringWithFormat:@" %zd/%zd", self.gq_limitTextCount, self.gq_limitTextCount];
        self.textCountLabel.attributedText = [allText gq_attStringWithAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} atString:[NSString stringWithFormat:@"%zd",self.gq_limitTextCount]];
        
        textView.text = [textView.text substringToIndex:self.gq_limitTextCount];
    } else {
        self.textCountLabel.attributedText = nil;
        NSInteger count = textView.text.length;
        self.textCountLabel.text = [NSString stringWithFormat:@"%ld/%zd", count, self.gq_limitTextCount];
    }
    if (_gq_textViewTextBlock) {
        _gq_textViewTextBlock(textView.text);
    }
}
#pragma mark - 懒加载
- (YYTextView *)gq_textView {
    if (_gq_textView == nil) {
        _gq_textView = [[YYTextView alloc] init];
        [_gq_textView gq_viewCornerRadius:0 borderColor:GQ_RGB_COLOR(204, 204, 204)];
        _gq_textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
        _gq_textView.delegate = self;
        _gq_textView.placeholderText = @"请输入...";
        _gq_textView.font = [UIFont systemFontOfSize:14];
        _gq_textView.placeholderFont = [UIFont systemFontOfSize:14];
        _gq_textView.textColor = GQ_BlackColor;
    }
    return _gq_textView;
}
- (UILabel *)textCountLabel {
    if (_textCountLabel == nil) {
        _textCountLabel = [[UILabel alloc] init];
        _textCountLabel.textColor = GQ_RGB_COLOR(204, 204, 204);
        _textCountLabel.font = [UIFont systemFontOfSize:12];
        _textCountLabel.text = [NSString stringWithFormat:@"0/%zd",self.gq_limitTextCount];
    }
    return _textCountLabel;
}
@end
