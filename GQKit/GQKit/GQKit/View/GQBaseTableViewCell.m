//
//  GQBaseTableViewCell.m
//  GQKit
//
//  Created by Qun on 2020/6/19.
//  Copyright © 2020 GQKit. All rights reserved.
//

#import "GQBaseTableViewCell.h"

@implementation GQBaseTableViewCell

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
}

@end
