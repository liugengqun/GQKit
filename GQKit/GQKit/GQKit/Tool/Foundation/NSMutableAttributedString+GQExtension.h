//
//  NSMutableAttributedString+GQExtension.h
//  GQKit
//
//  Created by Apple on 18/3/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (GQExtension)
- (NSMutableAttributedString *)gq_addAttributes:(NSDictionary *)attibute atString:(NSString *)string;
@end
