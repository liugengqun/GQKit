//
// Created by Shaokang Zhao on 15/1/12.
// Copyright (c) 2015 Shaokang Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKTag : NSObject

@property (copy, nonatomic, nullable) NSString *text;
@property (copy, nonatomic, nullable) NSAttributedString *attributedText;
@property (strong, nonatomic, nullable) UIColor *textColor;
@property (strong, nonatomic, nullable) UIColor *selectTextColor;

@property (assign, nonatomic) CGSize fixedSize;  // fixed size

/** imageUrl */
@property (nonatomic, copy, nullable) NSString *imageUrl;
/** placeholderImage */
@property (nonatomic, copy, nullable) NSString *placeholderImage;

///backgound color
@property (strong, nonatomic, nullable) UIColor *bgColor;
@property (strong, nonatomic, nullable) UIColor *selectBgColor;
@property (strong, nonatomic, nullable) UIColor *highlightedBgColor;
///background image
@property (strong, nonatomic, nullable) UIImage *bgImg;
@property (strong, nonatomic, nullable) UIImage *bgSelectImg;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic, nullable) UIColor *borderColor;
@property (assign, nonatomic) CGFloat borderWidth;
///like padding in css
@property (assign, nonatomic) UIEdgeInsets padding;
@property (strong, nonatomic, nullable) UIFont *font;
///if no font is specified, system font with fontSize is used
@property (assign, nonatomic) CGFloat fontSize;
///default:YES
@property (assign, nonatomic) BOOL enable;

- (nonnull instancetype)initWithText: (nonnull NSString *)text;
+ (nonnull instancetype)tagWithText: (nonnull NSString *)text;

@end
