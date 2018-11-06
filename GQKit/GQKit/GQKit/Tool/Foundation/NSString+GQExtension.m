//
//  NSString+GQExtension.m
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "NSString+GQExtension.h"
#import "NSMutableAttributedString+GQExtension.h"

@implementation NSString (GQExtension)

- (NSString *)gq_strNotNil {
    if (self == nil || self == NULL || [self isKindOfClass:[NSNull class]]){
        return @"";
    } else {
        return self;
    }
}

- (NSMutableAttributedString *)gq_attStringWithAttributes:(NSDictionary *)attibute atString:(NSString *)string {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    [attString gq_addAttributes:attibute atString:string];
    return attString;
}

- (CGFloat)gq_sizeWithFont:(UIFont *)font andWidth:(CGFloat)width {
    if (self.length > 0) {
        CGRect frame = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName:font} context:nil];
        
        return ceil(frame.size.height);
    }
    return 0;
}

-(NSDictionary *)gq_getUrlParameters {
    if (![self respondsToSelector:@selector(rangeOfString:)]) {
        return nil;
    }
    //获取问号的位置，问号后是参数列表
    NSRange range = [self rangeOfString:@"?"];
    
    NSString *propertys = nil;
    if (range.length == 0) {
        propertys = self;
    } else if (self.length > 1){
        propertys = [self substringFromIndex:(int)(range.location+1)];
    }
    if (propertys) {
        NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *paras = [NSMutableDictionary dictionaryWithCapacity:subArray.count];
        [subArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:@"="]) {
                NSArray *dicArray = [obj componentsSeparatedByString:@"="];
                [paras setObject:[dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          forKey:[dicArray[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            }
        }];
        return paras;
    }
    return @{@"paras":[self?:@"" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
}

- (BOOL)gq_isValidUrl {
    return [self.lowercaseString hasPrefix:@"https"]
    || [self.lowercaseString hasPrefix:@"http"]
    || [self.lowercaseString hasPrefix:@"www"];
}


- (NSString *)gq_appendStringPath:(NSString *)path {
    if (path.length == 0) {
        return self;
    }
    NSString *url = self;
    if ([self hasSuffix:@"/"]) {
        url = [self substringToIndex:self.length - 1];
    }
    if (![path hasPrefix:@"/"]) {
        url = [url stringByAppendingString:@"/"];
    }
    return [url stringByAppendingString:path];
}


- (BOOL)gq_isValidTelNumber {
    NSString * MOBILE = @"^1[0-9]{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}
@end
