//
//  NSMutableAttributedString+GQExtension.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "NSMutableAttributedString+GQExtension.h"

@implementation NSMutableAttributedString (GQExtension)
- (NSMutableAttributedString *)gq_addAttributes:(NSDictionary *)attibute atString:(NSString *)string {
    if (self.string.length > 0 && string.length > 0) {
        [self addAttributes:attibute range:[self.string rangeOfString:string]];
    }
    return self;
}

@end
