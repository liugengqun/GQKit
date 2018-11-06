

#import "GQLabelCell.h"
#import "GQKit.h"
@interface GQLabelCell()

@end
@implementation GQLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (UILabel *)gq_textLab {
    if (_gq_textLab == nil) {
        _gq_textLab = [UILabel gq_labelWithFrame:CGRectZero text:@"" textColor:GQ_BlueColor font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft onSuperView:self.contentView];
        _gq_textLab.numberOfLines = 0;
    }
    return _gq_textLab;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.gq_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
    }];
}

- (void)setGq_textStr:(NSString *)gq_textStr{
    _gq_textStr = gq_textStr;
    self.gq_textLab.text = gq_textStr;
    [UILabel gq_changeLineSpaceForLabel:self.gq_textLab WithSpace:8];
}

@end
