//
//  GQCyclePagerViewCell.h
//  GQKit
//
//  Created by Apple on 25/03/18.
//  Copyright © 2018年 GQKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQCyclePagerViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *gq_dataArray;
@property (copy, nonatomic) void (^gq_itemClickBlock)(NSInteger idx);
@end

@interface GQCyclePagerViewImgCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageV;
@end
