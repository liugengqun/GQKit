//
//  GQSegmentScrollView.m
//  GQKit
//
//  Created by Qun on 2019/5/17.
//  Copyright © 2019 GQKit. All rights reserved.
//

#import "GQSegmentScrollView.h"

@implementation GQSegmentScrollView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (point.x <= 20) {
        return self.superview;
    }
    return [super hitTest:point withEvent:event];
}

@end
